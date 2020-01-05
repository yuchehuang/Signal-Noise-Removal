Fs=1000;
Ts=1/Fs;
Length=1000;
t=(0:Length-1)*Ts;

f1=10;
f2=30;
x=3*sin(2*pi*f1*t)-6*cos(2*pi*f2*t);
n=2.5-5*rand(1,Length);
Fs =10000;

y=x+n;
subplot(3,2,1);
plot(t,x)
title("X");
subplot(3,2,3);
plot(t,n)
title("noise");
subplot(3,2,5);
plot(t,y)
title("Y=x+n");

%% ------------Stat  FFT x  calculation-----------------%
[f_x,reult_x]=myFFT_normalisation(x,Fs)
subplot(3,2,2);
plot(f_x,reult_x);
title("FFT x");
%% ------------Stat  FFT n  calculation-------%
[f_n,reult_n]=myFFT_normalisation(n,Fs)
subplot(3,2,4);
plot(f_n,reult_n);
title("FFT n");
%% ------------Stat  FFT y  calculation-------%
[f_y,reult_y]=myFFT_normalisation(y,Fs)
subplot(3,2,6);
plot(f_y,reult_y);
title("FFT y");

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