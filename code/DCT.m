clc
close all
Fs=1000;
Ts=1/Fs;
Length=100;
f=10;
f2=4;
t=(0:Length-1)*Ts;

%noise=rand(1,Length);
Signal= cos(2*pi*f*t)+rand(1,Length);% +cos(2*pi*f2*t);
subplot(3,1,1);
plot(t,Signal)
title('Signal figure');
mean(Signal)

%% Original FFT

NFFT = 2^nextpow2(Length); 
Y = fft(Signal,NFFT)/Length;
f1 = Fs/2*linspace(0,1,NFFT/2+1);
subplot(3,1,2);
plot(f1,2*abs(Y(1:NFFT/2+1))) 
xlabel('Frequency (f)'); 
ylabel('|x(f)|');
title('Single-Side Amplitude Spectrum of x(t)');


%% Denoise 
threshold=0.1;
T=dct(eye(Length));
Output=T*Signal';
for compare=1:Length
   if abs(Output(compare))< threshold
   Output(compare)=0;
   end
end  
New=idct(Output);
mean(New);
%% Denoise FFT
hold on
 
Y = fft(New,NFFT)/Length;
f1 = Fs/2*linspace(0,1,NFFT/2+1);
subplot(3,1,2);
plot(f1,2*abs(Y(1:NFFT/2+1)),'r')
hold off 

subplot(3,1,3);
plot(t,New);


%% ------------ My function definition--------------------------%
function output=myFFT(input_signal)
 fft_Length=length(input_signal);
 fft_temp=2^nextpow2(fft_Length);
 output= fft(input_signal,fft_temp);
 output=abs(output);
end