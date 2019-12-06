clc
close all
%% ---------Parameter---------
Fs=1000;
Ts=1/Fs;
Length=3000;
t=(0:Length-1)*Ts;
Excel(1:5,1:50)=0;
%% ---------Signal & NOise---------
section_length=[0 704 1005 1709 2002 2296 ];
Mix=noise+signal;
New=signal;

Excel(5,100)=0;
for segment=1:5  % set which section u want to compute
    Original_segment_signal=signal(section_length(segment)+1:section_length(segment+1));
    N=noise(section_length(segment)+1:section_length(segment+1));
    Mix_Signal=Mix(section_length(segment)+1:section_length(segment+1));
    Size= size(Original_segment_signal,2);
    figure(segment);
    subplot(4,1,1);
    plot(t(1:Size),Original_segment_signal);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    title('Original Signal');
    
%%  ---------plot signal+noise figure---------    
    subplot(4,1,2);
    plot(t(1:Size),Mix_Signal)      %x unit ms
    Length=Size;
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Noise Signal   PSNR= %f dB', psnr(Original_segment_signal,Mix_Signal,255));
    title(txt);
    
%% ---------(Original) Frequency Domain--------- 
    NFFT = 2^nextpow2(Length);
    FFT_output=fft(Original_segment_signal,NFFT);
    FFT_Temp_2 = abs(FFT_output/Length);
    FFT_Temp_1 = FFT_Temp_2(1:NFFT/2+1);
    FFT_Temp_1(2:end-1) = 2*FFT_Temp_1(2:end-1);
    subplot(4,1,3);
    hold on
    plot(0:(1/NFFT):(1/2-1/NFFT),FFT_Temp_1(1:NFFT/2))   %0:(Fs/NFFT):(Fs/2-Fs/NFFT)-- not normalization
    xlabel('Normalised Frequency (f)'); 
    ylabel('voltage (mV)');
    title('Frequency Spectrum');    
    
%% ---------(With Noise) Frequency Domain--------- 
    NFFT = 2^nextpow2(Length);
    FFT_output=fft(Mix_Signal,NFFT);
    FFT_Temp_2 = abs(FFT_output/Length);
    FFT_Temp_1 = FFT_Temp_2(1:NFFT/2+1);
    FFT_Temp_1(2:end-1) = 2*FFT_Temp_1(2:end-1);
    plot(0:(1/NFFT):(1/2-1/NFFT),FFT_Temp_1(1:NFFT/2),'R')
    FFT_value=FFT_Temp_1(1:NFFT/2);
    
%% ---------Denoise Operation---------
    
    FFT_output_size=size(FFT_output,2);
    Optimised_threshold=0;
    performance=0;
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for parameter=1:100
    FFT_temp=FFT_output;
    threshold=parameter/100;
    %MAX=mean(n2);
    sprintf('Section %d MAX= %f',segment, Optimised_threshold);
    for i=1:FFT_output_size
        if(rem(fix(i*(Fs/NFFT)*1000),2)==1)
            if abs(FFT_temp(i))<(threshold*Length/2)
            FFT_temp(i)=0;  
            else
            %FFT_temp(i)=FFT_temp(i)*0.99;  
            end  
        end    
    end   
    
    iFFT_output= ifft(FFT_temp,NFFT);
    %Excel(segment,parameter)=psnr(s,iFFT_output(1:Size),255);
    if (performance < psnr(Original_segment_signal,iFFT_output(1:Size),255))
        performance=psnr(Original_segment_signal,iFFT_output(1:Size),255);
        Optimised_threshold=threshold;
    end    
end   

    for i=1:FFT_output_size
        if(rem(fix(i*(Fs/NFFT)*1000),2)==1)
            if abs(FFT_output(i))<(Optimised_threshold*Length/2)
            FFT_output(i)=0;
            else
            %FFT_output(i)=FFT_output(i)*0.99;
            end 
        end    
    end   
    
%% ---------(Denoise) Frequency Domain---------
    FFT_Temp_2 = abs(FFT_output/Length);
    FFT_Temp_1 = FFT_Temp_2(1:NFFT/2+1);
    FFT_Temp_1(2:end-1) = 2*FFT_Temp_1(2:end-1);
    plot(0:(1/NFFT):(1/2-1/NFFT),FFT_Temp_1(1:NFFT/2),'G');
    hold off
    legend('Original','Noisy',' Denoise')
    
%% ---------IFFT---------
iFFT_output= ifft(FFT_output,NFFT);
subplot(4,1,4);
plot(t(1:Size),iFFT_output(1:Size));
sprintf('Max parameter is %d',(Optimised_threshold*2/Length));
xlabel('time (s)'); 
ylabel('voltage (mV)');
txt=sprintf('Dnoise Signal   PSNR=%f dB', psnr(Original_segment_signal,iFFT_output(1:Size),255));
title(txt);   
New(section_length(segment)+1:section_length(segment+1))=iFFT_output(1:Size);
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
plot(t(1:2296),New);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Denoise Signal  PSNR=%f dB', psnr(signal,New,255));
    title(txt);
