clc
close all

%% ------------------Parameter-------------------
Fs=1000;
Ts=1/Fs;
Length=3000;
t=(0:Length-1)*Ts;

%% ------------------Signal & NOise Delcare -------------------
section_length=[0 704 1005 1709 2002 2296 ];
Mix=noise+signal;
Recover_signal_temp=zeros(1,size(signal,2)); %create a new vector for recover signal used
N=40; % size of DCT martix 


%% ------------------Algorithm -------------------
for segment=1:5  % set which section u want to compute
    clear Fix
    Original_signal_segment=signal(section_length(segment)+1:section_length(segment+1));
    n=noise(section_length(segment)+1:section_length(segment+1));
    Mix_Signal=Mix(section_length(segment)+1:section_length(segment+1));
    Size= size(Original_signal_segment,2);
    Signal_Segment=zeros(1,Size);
    figure(segment);
    subplot(4,1,1);
    plot(t(1:Size),Original_signal_segment);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    title('Original Signal');
    
%%  plot the contaminated signal     
    subplot(4,1,2);
    plot(t(1:Size),Mix_Signal)      % unit ms
    Length=Size;
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Noise Signal   PSNR= %f dB', psnr(Original_signal_segment,Mix_Signal,255));
    title(txt);
    
%% ------(Original) Frequency Domain------------------------------- 
    NFFT = 2^nextpow2(Length);
    FFT_output=fft(Original_signal_segment,NFFT);
    P2 = abs(FFT_output/Length);
    P1 = P2(1:NFFT/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    subplot(4,1,3);
    hold on
    plot(0:(1/NFFT):(1/2-1/NFFT),P1(1:NFFT/2))
    xlabel('Normalised Frequency (f)');  
    ylabel('voltage (mV)');
        
    
%% ------(With Noise) Frequency Domain------------------------------- 
    NFFT = 2^nextpow2(Length);
    FFT_output=fft(Mix_Signal,NFFT);
    P2 = abs(FFT_output/Length);
    P1 = P2(1:NFFT/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    plot(0:(1/NFFT):(1/2-1/NFFT),P1(1:NFFT/2),'R')
    FFT_value=P1(1:NFFT/2);
 %% ---------DCT  Denoise Initialisation---------------------
 clear transform_array
 clear DCT_temp
 clear DCT_Output
 MAX=0;
 Compare_PSNR=0;
 
%% ------------optimize the threshold--------------------- 
 for test_threshold =1:100
    threshold=test_threshold/10; 
    transform_array = dct(eye(N));
        for section=1:fix(Size/N)
            DCT_temp(1:N)=Original_signal_segment((N*(section-1))+1:(N*section));
            DCT_Output=transform_array*DCT_temp';
            for compare=1:N
                if abs(DCT_Output(compare))< threshold
                    DCT_Output(compare)=0; 
                end
            end         
            Signal_Segment(N*(section-1)+1:(N*section))= idct(DCT_Output);    
        end 
        
        if rem(Size,N)>0
            clear transform_array
            clear DCT_temp
            clear DCT_Output
            transform_array = dct(eye(rem(Size,N)));
            DCT_temp=Original_signal_segment(N*fix(Size/N)+1:Size);
            DCT_Output=transform_array*DCT_temp';
            for compare=1:rem(Size,N)
                if abs(DCT_Output(compare))< threshold
                    DCT_Output(compare)=0;
                end
            end    
            remain=idct(DCT_Output);
            Signal_Segment(N*fix(Size/N)+1:Size)= remain;
        end 
        
        if Compare_PSNR < psnr(Original_signal_segment,Signal_Segment,255)
            Compare_PSNR= psnr(Original_signal_segment,Signal_Segment,255);
            MAX=threshold;
        end 
        
       
 end

 %% -----DCT Calculation for optimisation--------------------
 clear transform_array
 clear DCT_temp
 clear DCT_Output
 
 threshold= MAX; 
 transform_array = dct(eye(N));
        for section=1:fix(Size/N)
            DCT_temp(1:N)=Original_signal_segment((N*(section-1))+1:(N*section));
            DCT_Output=transform_array*DCT_temp';
            for compare=1:N
                if abs(DCT_Output(compare))< threshold
                    DCT_Output(compare)=0; 
                end
            end
            
            Signal_Segment(N*(section-1)+1:(N*section))= idct(DCT_Output);    
        end 
        
        if rem(Size,N)>0
            clear transform_array
            clear DCT_temp
            clear DCT_Output
            transform_array = dct(eye(rem(Size,N)));
            DCT_temp=Original_signal_segment(N*fix(Size/N)+1:Size);
            DCT_Output=transform_array*DCT_temp';
            for compare=1:rem(Size,N)
                if abs(DCT_Output(compare))< threshold
                    DCT_Output(compare)=0;
                end
            end    
            remain=idct(DCT_Output);
            Signal_Segment(N*fix(Size/N)+1:Size)= remain;
        end 

 %% using NxN for executing remaining element
% if rem(Size(2),N)>0
%     clear temp
%     temp(1:N-rem(Size,N))=0;
%     temp=[s(N*fix(Size/N)+1:Size) temp]
%     Output=transform_array*temp';
%     Output(round(0.2*N):N)=0;
%     remain=idct(Output);
%     Fix(N*fix(Size/N)+1:Size(2))= remain(1:rem(Size(2),N));
% end

    
%% -------------(Denoise) Frequency Domain---------------------
    FFT_output=fft(Signal_Segment,NFFT);
    P2 = abs(FFT_output/Length);
    P1 = P2(1:NFFT/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    plot(0:(1/NFFT):(1/2-1/NFFT),P1(1:NFFT/2),'G');
    txt=sprintf('FFT threshold= %.2f',MAX);
    title(txt);
    hold off
    
    legend('Original','Noisy',' Denoise')
    
%% ----------------IFFT----------------------------
subplot(4,1,4);
plot(t(1:Size),Signal_Segment);
sprintf('Denoise PSNR for S2: %f', psnr(Original_signal_segment,Signal_Segment,255));
xlabel('time (s)'); 
ylabel('voltage (mV)');
txt=sprintf('Dnoise Signal PSNR=%.3f dB N =%d', psnr(Original_signal_segment,Signal_Segment,255), N);
title(txt);
Recover_signal_temp(section_length(segment)+1:section_length(segment+1))=Signal_Segment;
end 


%% ----------------Plot the Recovered Signal----------------------------
figure(6);
subplot(3,1,1)
plot(t(1:2296),signal);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    title('Original Signal ');
    
subplot(3,1,2)
plot(t(1:2296),Mix);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Noise & Singal  PSNR=%f dB', psnr(signal,Mix,255));
    title(txt); 
    
subplot(3,1,3)
plot(t(1:2296),Recover_signal_temp);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Denoise Signal  PSNR=%f dB', psnr(signal,Recover_signal_temp,255));
    title(txt);
    
    
