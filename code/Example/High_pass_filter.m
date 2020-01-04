Fs=10000;
Ts=1/Fs;
Length=250;
t=(0:Length-1)*Ts;

%% -------Define the signal Frequency-----------%
f1=50;
f2=3000;


%% ------------Define the Signal----------------% 
x=3*sin(2*pi*f1*t)-6*cos(2*pi*f2*t);
subplot(2,2,1);
plot(t,x);

%% ------------Frequency Analysis---------------%
NFFT = 2^nextpow2(Length); 
Y = fft(x,NFFT)/Length;
f1 = Fs/2*linspace(0,1,NFFT/2+1);

subplot(2,2,2);
plot(f1,2*abs(Y(1:NFFT/2+1))) 
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
temp = conv2(hpf,x);
subplot(2,2,3);
plot(t,temp(1:Length));

%% -----------Signal After filter--------------%
NFFT = 2^nextpow2(Length); 
Y = fft(temp,NFFT)/Length;
f1 = Fs/2*linspace(0,1,NFFT/2+1);
subplot(2,2,4);
plot(f1,2*abs(Y(1:NFFT/2+1))) 
xlabel('Frequency (f)'); 
ylabel('|con(f)|');
title('Single-Side Amplitude Spectrum of con(t)');