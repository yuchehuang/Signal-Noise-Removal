t=linspace(0,10,512);
Fs =10000;
f1=10;
f2=30;
x=3*sin(5*t)-6*cos(9*t);
n=5*rand(1,512);

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
reult_x=myFFT(x)
subplot(4,2,2);
plot(reult_x);
title("FFT x");
%% ------------Stat  FFT n  calculation-------%
result_n=myFFT(n)
subplot(4,2,4);
plot(result_n);
title("FFT n");
%% ------------Stat  FFT y  calculation-------%
result_y=myFFT(y)
subplot(4,2,6);
plot(result_y);
title("FFT y");
%% ----------------MAF 3 filter model-------------------------%
LPF=(1/3)*(1+2*cos(10*t));
Lfft=length(LPF);
Lfft2=2^nextpow2(Lfft);
Lff= fft(LPF,Lfft2);

%% ----------------MAF 3 filter-----------------------------%
MAF=y;
for loop=1:10
    MAF=myMAF_Filter(MAF,3);
end
subplot(4,2,7);
plot(t,MAF);
title("Output");


%% -------------Stat  FFT MAF 3 calculation--------------------%
subplot(4,2,8);
result_MAF=myFFT(MAF);
plot(result_MAF);
title("FFT y");

%% ------------ My function definition--------------------------%
function output=myFFT(input_signal)
 fft_Length=length(input_signal);
 fft_temp=2^nextpow2(fft_Length);
 output= fft(input_signal,fft_temp);
 output=abs(output);
end

function MAF_output=myMAF_Filter(intput_signal,m)
filter_parameter=zeros(1,m);
filter_parameter(1:m)=(1/m);
MAF_output=conv2(filter_parameter,intput_signal);
MAF_output=MAF_output(2:size(intput_signal,2)+1);
end