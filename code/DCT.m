clc
close all
Fs=1000;
Ts=1/Fs;
Length=100;
f=10;
f2=4;
t=(0:Length-1)*Ts;

%noise=rand(1,Length);
noise= cos(2*pi*f*t);%+rand(1,Length);% +cos(2*pi*f2*t);
subplot(3,1,1);
plot(t,noise)

mean(noise)

%% Original FFT

NFFT = 2^nextpow2(Length); 
Y = fft(noise,NFFT)/Length;
f1 = Fs/2*linspace(0,1,NFFT/2+1);
subplot(3,1,2);
plot(f1,2*abs(Y(1:NFFT/2+1))) 
xlabel('Frequency (f)'); 
ylabel('|x(f)|');
title('Single-Side Amplitude Spectrum of x(t)');


%% Denoise 
threshold=0.1;
T=dct(eye(Length));
Output=T*noise'
% for compare=1:Length
%    if abs(Output(compare))< threshold
%    Output(compare)=0;
%    end
% end  

%Output(9)=0;
Output(3:100)=0;
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