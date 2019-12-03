clc
close all

%% ------------------Parameter-------------------
Fs=1000;
Ts=1/Fs;
Length=3000;
t=(0:Length-1)*Ts;

%% ------------------Signal & NOise-------------------
section_length=[0 704 1005 1709 2002 2296 ];
y1=noise+signal;
New=y1;
N=40; 
for segment=1:5  % set which section u want to compute
    clear Fix
    s=signal(section_length(segment)+1:section_length(segment+1));
    n=noise(section_length(segment)+1:section_length(segment+1));
    n2=y1(section_length(segment)+1:section_length(segment+1));
    Fix=s;
    Size= size(s);
    figure(segment);
    subplot(4,1,1);
    plot(t(1:Size(2)),s);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    title('Original Signal');
    
%%  plot signal+noise figure    
    subplot(4,1,2);
    plot(t(1:Size(2)),n2)      %x unit ms
    Length=Size(2);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Noise Signal   PSNR= %f dB', psnr(s,n2,255));
    title(txt);
    
%% ------(Original) Frequency Domain------------------------------- 
    NFFT = 2^nextpow2(Length);
    Y=fft(s,NFFT);
    P2 = abs(Y/Length);
    P1 = P2(1:NFFT/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    subplot(4,1,3);
    hold on
    plot(0:(1/NFFT):(1/2-1/NFFT),P1(1:NFFT/2))
    xlabel('Normalised Frequency (f)');  
    ylabel('voltage (mV)');
        
    
%% ------(With Noise) Frequency Domain------------------------------- 
    NFFT = 2^nextpow2(Length);
    Y=fft(n2,NFFT);
    P2 = abs(Y/Length);
    P1 = P2(1:NFFT/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    plot(0:(1/NFFT):(1/2-1/NFFT),P1(1:NFFT/2),'R')
    FFT_value=P1(1:NFFT/2);
 %% ---------DCT  Denoise Operation---------------------
 clear transform_array
 clear temp
 clear Output
 MAX=0;
 Compare_PSNR=0;
 
%% ------------optimize the threshold--------------------- 
 for test_threshold =1:100
    threshold=test_threshold/10; 
    transform_array = dct(eye(N));
        for section=1:fix(Size(2)/N)
            temp(1:N)=s((N*(section-1))+1:(N*section));
            Output=transform_array*temp';
            for compare=1:N
                if abs(Output(compare))< threshold
                    Output(compare)=0; 
                end
            end         
            Fix(N*(section-1)+1:(N*section))= idct(Output);    
        end 
        
        if rem(Size(2),N)>0
            clear transform_array
            clear temp
            clear Output
            transform_array = dct(eye(rem(Size(2),N)));
            temp=s(N*fix(Size(2)/N)+1:Size(2));
            Output=transform_array*temp';
            for compare=1:rem(Size(2),N)
                if abs(Output(compare))< threshold
                    Output(compare)=0;
                end
            end    
            remain=idct(Output);
            Fix(N*fix(Size(2)/N)+1:Size(2))= remain;
        end 
        
        if Compare_PSNR < psnr(s,Fix,255)
            Compare_PSNR= psnr(s,Fix,255);
            MAX=threshold;
        end 
        
       
 end

 %% -----Calculation the optimized performance--------------------
 clear transform_array
 clear temp
 clear Output
 
 threshold= MAX; 
 transform_array = dct(eye(N));
        for section=1:fix(Size(2)/N)
            temp(1:N)=s((N*(section-1))+1:(N*section));
            Output=transform_array*temp';
            for compare=1:N
                if abs(Output(compare))< threshold
                    Output(compare)=0; 
                end
            end
            
            Fix(N*(section-1)+1:(N*section))= idct(Output);    
        end 
        
        if rem(Size(2),N)>0
            clear transform_array
            clear temp
            clear Output
            transform_array = dct(eye(rem(Size(2),N)));
            temp=s(N*fix(Size(2)/N)+1:Size(2));
            Output=transform_array*temp';
            for compare=1:rem(Size(2),N)
                if abs(Output(compare))< threshold
                    Output(compare)=0;
                end
            end    
            remain=idct(Output);
            Fix(N*fix(Size(2)/N)+1:Size(2))= remain;
        end 

 %% using NxN for executing remaining element
% if rem(Size(2),N)>0
%     clear temp
%     temp(1:N-rem(Size(2),N))=0;
%     temp=[s(N*fix(Size(2)/N)+1:Size(2)) temp]
%     Output=transform_array*temp';
%     Output(round(0.2*N):N)=0;
%     remain=idct(Output);
%     Fix(N*fix(Size(2)/N)+1:Size(2))= remain(1:rem(Size(2),N));
% end

    
%% -------------(Denoise) Frequency Domain---------------------
    Y=fft(Fix,NFFT);
    P2 = abs(Y/Length);
    P1 = P2(1:NFFT/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    plot(0:(1/NFFT):(1/2-1/NFFT),P1(1:NFFT/2),'G');
    txt=sprintf('FFT threshold= %.2f',MAX);
    title(txt);
    hold off
    
    legend('Original','Noisy',' Denoise')
    
%% ----------------IFFT----------------------------
subplot(4,1,4);
plot(t(1:Size(2)),Fix);
sprintf('Denoise PSNR for S2: %f', psnr(s,Fix,255));
xlabel('time (s)'); 
ylabel('voltage (mV)');
txt=sprintf('Dnoise Signal PSNR=%.3f dB N =%d', psnr(s,Fix,255), N);
title(txt);
New(section_length(segment)+1:section_length(segment+1))=Fix;
end 
figure(6);
subplot(3,1,1)
plot(t(1:2296),signal);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    title('Original Signal ');
    
subplot(3,1,2)
plot(t(1:2296),y1);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Noise & Singal  PSNR=%f dB', psnr(signal,y1,255));
    title(txt); 
    
subplot(3,1,3)
plot(t(1:2296),New);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Denoise Signal  PSNR=%f dB', psnr(signal,New,255));
    title(txt);
    
    
