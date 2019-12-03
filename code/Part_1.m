clc
close all
%% ------------------Parameter-------------------
Fs=1000;
Ts=1/Fs;
Length=3000;
t=(0:Length-1)*Ts;
Excel(1:5,1:50)=0;
%% ------------------Signal & NOise-------------------
section_length=[0 704 1005 1709 2002 2296 ];
y1=noise+signal;
New=signal;
i=1;
for segment=2:3:5  % set which section u want to compute
    s=signal(section_length(segment)+1:section_length(segment+1));
    N=noise(section_length(segment)+1:section_length(segment+1));
    n2=y1(section_length(segment)+1:section_length(segment+1));
    Size= size(s);
    %figure(segment);
    subplot(4,3,i);
    plot(t(1:Size(2)),s);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Original Signal Segment %d', segment);
    title(txt);
   
    
%%  plot signal+noise figure    
    subplot(4,3,i+3);
    plot(t(1:Size(2)),n2)      %x unit ms
    Length=Size(2);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Noisy Signal   PSNR= %f dB', psnr(s,n2,255));
    title(txt);
        
%% -----------Different moving Filter----------------------------
hpf=[1 -1];
temp = conv2(hpf,s);
subplot(4,3,i+6);
plot(t(1:Size(2)),temp(1:Size(2)));
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    title('MDF for original signal');    
%% ------(Original) Frequency Domain------------------------------- 
    NFFT = 2^nextpow2(Length);
    Y=fft(s,NFFT);
    P2 = abs(Y/Length);
    P1 = P2(1:NFFT/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    subplot(4,3,i+9);
    plot(0:(1/NFFT):(1/2-1/NFFT),P1(1:NFFT/2))   %0:(Fs/NFFT):(Fs/2-Fs/NFFT)-- not normalization
    xlabel('Normalised Frequency (f)'); 
    ylabel('voltage (mV)');
    title('FFT');    
    
 i=i+2;   
%% ---------(With Noise) Frequency Domain------------ 

%     NFFT = 2^nextpow2(Length);
%     Y=fft(n2,NFFT);
%     P2 = abs(Y/Length);
%     P1 = P2(1:NFFT/2+1);
%     P1(2:end-1) = 2*P1(2:end-1);
%     subplot(4,1,4);
%     plot(0:(1/NFFT):(1/2-1/NFFT),P1(1:NFFT/2),'R')
%     FFT_value=P1(1:NFFT/2);
    
end 

for segment=4:4  % set which section u want to compute
    s=signal(section_length(segment)+1:section_length(segment+1));
    N=noise(section_length(segment)+1:section_length(segment+1));
    n2=y1(section_length(segment)+1:section_length(segment+1));
    Size= size(s);
    %figure(segment);
    subplot(4,3,2);
    plot(t(1:Size(2)),s);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Original Signal Segment %d', segment);
    title(txt);
   
    
%%  plot signal+noise figure    
    subplot(4,3,5);
    plot(t(1:Size(2)),n2)      %x unit ms
    Length=Size(2);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Noisy Signal   PSNR= %f dB', psnr(s,n2,255));
    title(txt);
        
%% -----------Different moving Filter----------------------------
hpf=[1 -1];
temp = conv2(hpf,s);
subplot(4,3,8);
plot(t(1:Size(2)),temp(1:Size(2)));
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    title('MDF for original signal');    
%% ------(Original) Frequency Domain------------------------------- 
    NFFT = 2^nextpow2(Length);
    Y=fft(s,NFFT);
    P2 = abs(Y/Length);
    P1 = P2(1:NFFT/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    subplot(4,3,11);
    plot(0:(1/NFFT):(1/2-1/NFFT),P1(1:NFFT/2))   %0:(Fs/NFFT):(Fs/2-Fs/NFFT)-- not normalization
    xlabel('Normalised Frequency (f)'); 
    ylabel('voltage (mV)');
    title('FFT');    
    
    
%% ---------(With Noise) Frequency Domain------------ 

%     NFFT = 2^nextpow2(Length);
%     Y=fft(n2,NFFT);
%     P2 = abs(Y/Length);
%     P1 = P2(1:NFFT/2+1);
%     P1(2:end-1) = 2*P1(2:end-1);
%     subplot(4,1,4);
%     plot(0:(1/NFFT):(1/2-1/NFFT),P1(1:NFFT/2),'R')
%     FFT_value=P1(1:NFFT/2);
    
end 
% figure(6);
% subplot(3,1,1)
% plot(t(1:2296),signal);
%     xlabel('time (s)'); 
%     ylabel('voltage (mV)');
%     title('Original Signal ');
%     
% subplot(3,1,2)
% plot(t(1:2296),y1);
%     xlabel('time (s)'); 
%     ylabel('voltage (mV)');
%     txt=sprintf('Noise & Singal  PSNR=%f', psnr(signal,y1,255));
%     title(txt); 
%     
% subplot(3,1,3)
% plot(t(1:2296),New);
%     xlabel('time (s)'); 
%     ylabel('voltage (mV)');
%     txt=sprintf('Denoise Signal  PSNR=%f', psnr(signal,New,255));
%     title(txt);
