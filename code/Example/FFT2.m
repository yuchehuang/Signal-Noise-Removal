clc
clear
Sample_rate=500;  
Ts=1/Sample_rate;
Length=100;
t=(0:Length-1)*Ts;
%t= 0:0.1:2*pi;
f1=50;
f2=30;
x=3*sin(2*pi*f1*t)-0*cos(2*pi*f2*t);

subplot(2,1,1)
plot(t, x)
xlabel('time (s)'); 
ylabel('|voltage| (mV)');
title('Signal wave');

subplot(2,1,2)
[f, magnitude]=myFFT_normalisation(x,Sample_rate);
plot(f, magnitude)
xlabel('Normalised Frequency (f)'); 
ylabel('|voltage| (mV)');
title('Frequency Spectrum');   

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
    %plot(0:(1/NFFT):(1/2-1/NFFT),FFT_signal_side_spectrum(1:NFFT/2))   %0:(Fs/NFFT):(Fs/2-Fs/NFFT)-- not normalization
    f=0:(1/NFFT):(1/2-1/NFFT);
    megnitude=FFT_signal_side_spectrum(1:NFFT/2);
end