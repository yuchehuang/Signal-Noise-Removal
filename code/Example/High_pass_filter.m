Fs=10000;
Ts=1/Fs;
Length=500;
t=(0:Length-1)*Ts;

%% -------Define the signal Frequency-----------%
f1=50;
f2=3000;


%% ------------Define the Signal----------------% 
x=3*sin(2*pi*f1*t)-6*cos(2*pi*f2*t);
subplot(2,2,1);
plot(t,x);

%% ------------Frequency Analysis---------------%
[f,magnitude]=myFFT(x,Fs)
subplot(2,2,2);
plot(f,magnitude) 
xlabel('Frequency (f)'); 
ylabel('|x(f)|');
title('Single-Side Amplitude Spectrum of x(t)');

%% ------------Convolution Example--------------%
% con = [0 x 0];
% temp=rand(1,Length);
% for i=2:Length+1
%     temp(i-1)= con(i)-con(i-1);
% end
% subplot(2,2,3);
% plot(t,temp);

%% ------------High Pass Filter----------------%
hpf=[1 -1];
output = conv2(hpf,x);
subplot(2,2,3);
plot(t,output(1:Length));

%% -----------Signal After filter--------------%

[f, megnitude]= myFFT(output,Fs)
subplot(2,2,4);
plot(f,megnitude) 
xlabel('Frequency (f)'); 
ylabel('|con(f)|');
title('Single-Side Amplitude Spectrum of con(t)');

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


