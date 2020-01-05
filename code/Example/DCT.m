clc
close all

Fs=1000;
Ts=1/Fs;
Length=500;
t=(0:Length-1)*Ts;

f=20;
f2=4;

%noise=rand(1,Length);
original_signal= 10*cos(2*pi*f*t);
noise=1-2*rand(1,Length);% +cos(2*pi*f2*t);
Signal=original_signal+noise;
subplot(4,2,1);
plot(t,original_signal)
title('original signal figure');

subplot(4,2,3);
plot(t,noise)
title('Noise signal figure');

subplot(4,2,5);
plot(t,Signal)
title('Contaminated signal figure');


%% Original FFT
[megnitude,output]=myFFT(original_signal,Fs);
subplot(4,2,2);
plot(megnitude,output)
xlabel('Frequency (f)'); 
ylabel('|x(f)|');
title('original_signal Spectrum of x(t)');

%% Noise FFT
[megnitude,output]=myFFT(noise,Fs);
subplot(4,2,4);
plot(megnitude,output)
xlabel('Frequency (f)'); 
ylabel('|x(f)|');
title('Noise Signal Spectrum of x(t)');

%% Contaminated signal FFT
[megnitude,output]=myFFT(Signal,Fs);
subplot(4,2,6);
plot(megnitude,output)
xlabel('Frequency (f)'); 
ylabel('|x(f)|');
title('Contaminated signal Spectrum of x(t)');

%% Denoise 
threshold=2;
Output=myDCT(Signal, threshold, Length);

%% Denoise FFT
hold on
[megnitude,output]=myFFT(Output,Fs);
plot(megnitude,output,'r')
hold off 

subplot(4,2,8);
plot(megnitude,output)
xlabel('Frequency (f)'); 
ylabel('|x(f)|');
title('Denoise signal Spectrum of x(t)');

subplot(4,2,7);
plot(t,Output);
title('Removal Signal');

%% ------------ My function definition--------------------------%
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

function output=myDCT(intput_signal, threshold, DCT_Length)
    %% DCT
    Filter=dct(eye(DCT_Length));
    Output=Filter*intput_signal';
    %% Noise Removal
    for element=1:size(Output,1)
        if abs(Output(element))< threshold
            Output(element)=0;
        end
    end  
    %% IDCT
    output=idct(Output);
end