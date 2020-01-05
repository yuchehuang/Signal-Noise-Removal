clc
close all

%% ------------------Parameter-------------------
Fs=1000;
Ts=1/Fs;
Length=3000;
t=(0:Length-1)*Ts;
Excel(1:5,1:50)=0;
%% ------------------Signal & NOise-------------------
section_length=[0 704 1005 1709 2002 2296 ]; %% the segment length of the signal (dividing based on the signal type)
Plot_column=5; %% 5 segment of signal
row=[0*Plot_column,1*Plot_column,2*Plot_column,3*Plot_column];
mix_signal=noise+signal; 

for segment=1:5  % set which section u want to compute
    s=signal(section_length(segment)+1:section_length(segment+1));
    N=noise(section_length(segment)+1:section_length(segment+1));
    n2=mix_signal(section_length(segment)+1:section_length(segment+1));
    Signal_Length= size(s,2);
    %figure(segment);
    subplot(4,Plot_column,segment+row(1));
    plot(t(1:Signal_Length),s);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Original Signal Segment %d', segment);
    title(txt);
   
    
%%  plot signal+noise figure    
    subplot(4,Plot_column,segment+row(2));
    plot(t(1:Signal_Length),n2)      %x unit ms
    Length=Signal_Length;
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Noisy Signal   PSNR= %f dB', psnr(s,n2,255));
    title(txt);
        
%% ----------- Moving Different Filter----------------------------
    MDF_output=MDF(s);
    subplot(4,Plot_column,segment+row(3));
    plot(t(1:Signal_Length),MDF_output(1:Signal_Length));
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    title('MDF for original signal');    
%% ------(Original) Frequency Domain------------------------------- 
    [f, megnitude]= myFFT_normalisation(s,Fs)
    subplot(4,Plot_column,segment+row(4));
    plot(f, megnitude)   %0:(Fs/NFFT):(Fs/2-Fs/NFFT)-- not normalization
    xlabel('Normalised Frequency (f)'); 
    ylabel('voltage (mV)');
    title('FFT');    
   
%% --------- Frequency Domain (With Noise)------------ 

%     NFFT = 2^nextpow2(Length);
%     Y=fft(n2,NFFT);
%     P2 = abs(Y/Length);
%     P1 = P2(1:NFFT/2+1);
%     P1(2:end-1) = 2*P1(2:end-1);
%     subplot(4,1,4);
%     plot(0:(1/NFFT):(1/2-1/NFFT),P1(1:NFFT/2),'R')
%     FFT_value=P1(1:NFFT/2);
    
end 

%% MDF Function 
function output=MDF(input_signal)
hpf=[1 -1];
output = conv2(hpf,input_signal);
end

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

function [f, megnitude]= myFFT_normalisation(input_signal,Sample_frequency)
    Length=length(input_signal);
    NFFT = 2^nextpow2(Length);
    FFT_output=fft(input_signal,NFFT);
    FFT_abs = abs(FFT_output/Length);
    FFT_signal_side_spectrum = FFT_abs(1:NFFT/2+1);
    FFT_signal_side_spectrum(2:end-1) = 2*FFT_signal_side_spectrum(2:end-1);
    f=0:(1/NFFT):(1/2-1/NFFT);
    megnitude=FFT_signal_side_spectrum(1:NFFT/2);
end


