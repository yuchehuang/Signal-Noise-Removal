t=linspace(0,10,512);
%t= 0:0.1:2*pi;
f1=10;
f2=30;
x=3*sin(5*t)-6*cos(9*t);
n=5*rand(1,512);
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
reult_x=myFFT(x)
subplot(3,2,2);
plot(reult_x);
title("FFT x");
%% ------------Stat  FFT n  calculation-------%
result_n=myFFT(n)
subplot(3,2,4);
plot(result_n);
title("FFT n");
%% ------------Stat  FFT y  calculation-------%
result_y=myFFT(y)
subplot(3,2,6);
plot(result_y);
title("FFT y");
%% ----------------MAF 3 filter model-------------------------%
LPF=(1/3)*(1+2*cos(10*t));
Lfft=length(LPF);
Lfft2=2^nextpow2(Lfft);
Lff= fft(LPF,Lfft2);


%% ------------ My function definition--------------------------%
function output=myFFT(input_signal)
 fft_Length=length(input_signal);
 fft_temp=2^nextpow2(fft_Length);
 output= fft(input_signal,fft_temp);
 output=abs(output);
end