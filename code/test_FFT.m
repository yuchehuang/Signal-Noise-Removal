clc
clear
Fs=1000;
Ts=1/Fs;
Length=1000;
t=(0:Length-1)*Ts;
%t= 0:0.1:2*pi;
f1=50;
f2=30;
x=3*sin(2*pi*f1*t)-6*cos(2*pi*f2*t);
%     Original_segment_signal=x;
%     Length=length(Original_segment_signal);
%     NFFT = 2^nextpow2(Length);
%     FFT_output=fft(Original_segment_signal,NFFT);
%     FFT_Temp_2 = abs(FFT_output/Length);
%     FFT_Temp_1 = FFT_Temp_2(1:NFFT/2+1);
%     FFT_Temp_1(2:end-1) = 2*FFT_Temp_1(2:end-1);
%     plot(0:(1/NFFT):(1/2-1/NFFT),FFT_Temp_1(1:NFFT/2))   %0:(Fs/NFFT):(Fs/2-Fs/NFFT)-- not normalization
   [megnitude,output]=myFFT_normalisation(x,Fs);
   plot(megnitude,output);
    xlabel('Normalised Frequency (f)'); 
    ylabel('voltage (mV)');
    title('Frequency Spectrum');   
    
function [megnitude,output]=myFFT_normalisation(input_signal,Sample_frequency)
 fft_Length=length(input_signal);
 fft_temp=2^nextpow2(fft_Length);
 output= fft(input_signal,fft_temp);
 output=2*abs(output(1:fft_Length/2+1));
 megnitude= Sample_frequency/2*linspace(0,1,fft_Length/2+1); 
end