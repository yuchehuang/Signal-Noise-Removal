t=linspace(0,10,512);
%t= 0:0.1:2*pi;
f1=10;
f2=30;
x=3*sin(5*t)-6*cos(9*t);
%x=3*sin(t);%-6*cos(2*pi*f2*t);
n=5*rand(1,512);

y=x+n;
subplot(4,2,1);
plot(t,x)
title("X");
subplot(4,2,3);
plot(n)
title("noise");
subplot(4,2,5);
plot(y)
title("Y=x+n");

%------------Stat  FFT x  calculation-----------------%
Fs =10000;
xfft=length(x);
xfft2=2^nextpow2(xfft);
xff= fft(x,xfft2);
subplot(4,2,2);
plot(abs(xff));
title("FFT x");
%------------Stat  FFT y  calculation-------%
nfft=length(n);
nfft2=2^nextpow2(nfft);
nff= fft(n,nfft2);
subplot(4,2,4);
plot(abs(nff));
title("FFT n");
%------------Stat  FFT y  calculation-------%
yfft=length(y);
yfft2=2^nextpow2(yfft);
yff= fft(y,yfft2);
subplot(4,2,6);
plot(abs(yff));
title("FFT y");
%----------------MAF 3 filter model-------------------------%
LPF=(1/3)*(1+2*cos(10*t));
Lfft=length(LPF);
Lfft2=2^nextpow2(Lfft);
Lff= fft(LPF,Lfft2);
subplot(4,2,8);
plot(abs(Lff));
title("FFT y");
%----------------Output signal (After filter)-----------------------------%

m=3;               %% to modify the number of sample point
temp=rand(1,fix(m/2));
for i=1:fix(m/2)
    temp(i)=0;
end     
con= [temp y temp];
for loop=1:10       %% to modify the number of filter
    for i=1:1:(512-m)
        total=0;
        for M=0:1:(m-1)
            total=total+con(i+M);
        end  
        con(i+fix(m/2))=(1/m)*total;
    end
end
output= con;
subplot(4,2,7);
plot(output);
title("Output");
