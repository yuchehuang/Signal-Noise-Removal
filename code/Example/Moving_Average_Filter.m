Length=500;
t=linspace(0,10,Length);
Fs =1000;
f1=10;
f2=30;
x=3*sin(5*t)-6*cos(9*t);
n=5*rand(1,Length);

y=x+n;
subplot(4,2,1);
plot(t,x)
title("X");
subplot(4,2,3);
plot(t,n)
title("noise");
subplot(4,2,5);
plot(t,y)
title("Y=x+n");

%% ------------Stat  FFT x  calculation-----------------%
[f_x,reult_x]=myFFT(x,Fs);
subplot(4,2,2);
plot(f_x,reult_x);
title("FFT x");
%% ------------Stat  FFT n  calculation-------%
[f_n,reult_n]=myFFT(n,Fs);
subplot(4,2,4);
plot(f_n,reult_n);
title("FFT n");
%% ------------Stat  FFT y  calculation-------%
[f_y,reult_y]=myFFT(y,Fs);
subplot(4,2,6);
plot(f_y,reult_y);
title("FFT y");
%% ----------------MAF 3 filter model-------------------------%
LPF=(1/3)*(1+2*cos(10*t));
Lfft=length(LPF);
Lfft2=2^nextpow2(Lfft);
Lff= fft(LPF,Lfft2);

%% ----------------MAF 3 filter-----------------------------%
MAF=y;
for loop=1:5
    MAF=myMAF_Filter(MAF,3);
end
subplot(4,2,7);
plot(t,MAF);
title("Output");


%% -------------Stat  FFT MAF 3 calculation--------------------%
subplot(4,2,8);
[f_MAF,result_MAF]=myFFT(MAF,Fs);
plot(f_MAF,result_MAF);
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

function MAF_output=myMAF_Filter(intput_signal,m)
filter_parameter=zeros(1,m);
filter_parameter(1:m)=(1/m);
MAF_output=conv2(filter_parameter,intput_signal);
MAF_output=MAF_output(2:size(intput_signal,2)+1);
end