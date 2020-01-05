clc
close all
%% ------------------Parameter-------------------
Fs=1000;
Ts=1/Fs;
Length=3000;
t=(0:Length-1)*Ts;
Excel(1:5,1:50)=0;
%% ------------------Signal & NOise-------------------
section_length=[0 704 1005 1709 2002 2296 ];
y1=noise+signal;
New=signal;

Excel(5,100)=0;
for segment=1:5  % set which section u want to compute
    Original_segment_signal=signal(section_length(segment)+1:section_length(segment+1));
    N=noise(section_length(segment)+1:section_length(segment+1));
    Segment_signal=y1(section_length(segment)+1:section_length(segment+1));
    Size= size(Original_segment_signal);
    %figure(segment);
%     subplot(3,5,segment);
%     plot(t(1:Size(2)),s);
%     xlabel('time (s)'); 
%     ylabel('voltage (mV)');
%     txt=sprintf('Original Signal segment %d',segment);
%     title(txt);
    
%%  plot signal+noise figure    
    subplot(3,5,segment);
    plot(t(1:Size(2)),Segment_signal)      %x unit ms
    Length=Size(2);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Noisy Signal PSNR= %f dB', psnr(Original_segment_signal,Segment_signal,255));
    title(txt);
    
%% ------(Original) Frequency Domain------------------------------- 
    [f_s,FFT_output, megnitude_s]= myFFT_normalisation(Original_segment_signal,Fs);
    subplot(3,5,segment+5);
    hold on
    plot(f_s, megnitude_s)
      
%% ---------(With Noise) Frequency Domain------------ 
    [f_n2,FFT_output, megnitude_n2]= myFFT_normalisation(Segment_signal,Fs);
    plot(f_n2, megnitude_n2,'R')
      
 
 %% --------- Denoise Operation---------------------
    MAX=0;
    performance=0;
    NFFT = 2^nextpow2(Length);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for parameter=1:1000
    threshold=parameter/100000;
    temp=FFT_output;
    FFT_abs = abs(temp/Length);
    FFT_signal_side_spectrum = FFT_abs(1:NFFT/2+1);
    FFT_signal_side_spectrum(2:end-1) = 2*FFT_signal_side_spectrum(2:end-1);
    megnitude=FFT_signal_side_spectrum(1:NFFT/2);
    for i=1:size(megnitude,2)
        if(megnitude(i)<threshold)
            temp(i)=0;
            temp(length(megnitude)-i+1)=0;
        else
            temp(i)=0.99*temp(i);
            temp(length(megnitude)-i+1)=0.99*temp(length(megnitude)-i+1);
        end
    end
    
    iFFT_output= ifft(temp,NFFT);
    if (performance < psnr(Original_segment_signal,iFFT_output(1:Length),255))
        performance=psnr(Original_segment_signal,iFFT_output(1:Length),255);
        MAX=threshold;   
    end 
end

temp=FFT_output;  
FFT_abs = abs(temp/Length);
FFT_signal_side_spectrum = FFT_abs(1:NFFT/2+1);
FFT_signal_side_spectrum(2:end-1) = 2*FFT_signal_side_spectrum(2:end-1);
megnitude=FFT_signal_side_spectrum(1:NFFT/2);
for i=1:size(megnitude,2)
    if(megnitude(i)<MAX)
         temp(i)=0;
         temp(length(megnitude)-i+1)=0;
    else
         temp(i)=0.99*temp(i);
         temp(length(megnitude)-i+1)=0.99*temp(length(megnitude)-i+1);
    end
end

% %% -------------(Denoise) Frequency Domain--------------------- 
    FFT_abs = abs(temp/Length);
    FFT_signal_side_spectrum = FFT_abs(1:NFFT/2+1);
    FFT_signal_side_spectrum(2:end-1) = 2*FFT_signal_side_spectrum(2:end-1);
    megnitude=FFT_signal_side_spectrum(1:NFFT/2);
    f=0:(1/NFFT):(1/2-1/NFFT);
    plot(f,megnitude);
    xlabel('Normalised Frequency (f)'); 
    ylabel('voltage (mV)');
    txt=sprintf('FFT  threshold=%f',MAX);
    title(txt);  
    hold off
    legend('Original','Noisy',' Denoise')
    
%% ----------------IFFT----------------------------
Recovered_signal_segment= ifft(temp,NFFT);
subplot(3,5,segment+10);
plot(t(1:Length),Recovered_signal_segment(1:Length));
sprintf('Max parameter is %d',(MAX*2/Length));
xlabel('time (s)'); 
ylabel('voltage (mV)');
txt=sprintf('Dnoise Signal   PSNR=%f dB', psnr(Original_segment_signal,Recovered_signal_segment(1:Size(2)),255));
title(txt);   
New(section_length(segment)+1:section_length(segment+1))=Recovered_signal_segment(1:Size(2));
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
    
 function [f, magnitude]= myFFT_normalised(input_signal)
    signal_Length=length(input_signal);
    fft_data= fft(input_signal);
    fft_data=abs(fft_data/signal_Length);
    magnitude=fft_data(1:signal_Length/2+1);
    magnitude(2:end-1)=2*magnitude(2:end-1);
    f= (0:(signal_Length/2))/signal_Length;
end

function [f,magnitude]=myFFT(input_signal,Sample_frequency)
 signal_Length=length(input_signal);
 fft_data= fft(input_signal);
 fft_data=abs(fft_data/signal_Length);
 magnitude=fft_data(1:signal_Length/2+1);
 magnitude(2:end-1)=2*magnitude(2:end-1);
 f= Sample_frequency*(0:(signal_Length/2))/signal_Length;
end

function [f,FFT_output, megnitude]= myFFT_normalisation(input_signal,Sample_frequency)
    Length=length(input_signal);
    NFFT = 2^nextpow2(Length);
    FFT_output=fft(input_signal,NFFT);
    FFT_abs = abs(FFT_output/Length);
    FFT_signal_side_spectrum = FFT_abs(1:NFFT/2+1);
    FFT_signal_side_spectrum(2:end-1) = 2*FFT_signal_side_spectrum(2:end-1);
    f=0:(1/NFFT):(1/2-1/NFFT);
    megnitude=FFT_signal_side_spectrum(1:NFFT/2);
end
