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

Excel(5,100)=0;
for segment=1:5  % set which section u want to compute
    s=signal(section_length(segment)+1:section_length(segment+1));
    N=noise(section_length(segment)+1:section_length(segment+1));
    n2=y1(section_length(segment)+1:section_length(segment+1));
    Size= size(s);
    %figure(segment);
%     subplot(3,5,segment);
%     plot(t(1:Size(2)),s);
%     xlabel('time (s)'); 
%     ylabel('voltage (mV)');
%     txt=sprintf('Original Signal segment %d',segment);
%     title(txt);
    
%%  plot signal+noise figure    
    subplot(3,5,segment);
    plot(t(1:Size(2)),n2)      %x unit ms
    Length=Size(2);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Noisy Signal PSNR= %f dB', psnr(s,n2,255));
    title(txt);
    
%% ------(Original) Frequency Domain------------------------------- 
    NFFT = 2^nextpow2(Length);
    Y=fft(s,NFFT);
    P2 = abs(Y/Length);
    P1 = P2(1:NFFT/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    subplot(3,5,segment+5);
    hold on
    plot(0:(1/NFFT):(1/2-1/NFFT),P1(1:NFFT/2))   %0:(Fs/NFFT):(Fs/2-Fs/NFFT)-- not normalization
  
    
%% ---------(With Noise) Frequency Domain------------ 

    NFFT = 2^nextpow2(Length);
    Y=fft(n2,NFFT);
    P2 = abs(Y/Length);
    P1 = P2(1:NFFT/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    plot(0:(1/NFFT):(1/2-1/NFFT),P1(1:NFFT/2),'R')
    FFT_value=P1(1:NFFT/2);
    
    
 
 %% --------- Denoise Operation---------------------
    %threshold  = mean(abs(Y));
    %threshold = thselect(n2,'rigrsure')
    Ysize=size(Y);
    MAX=0;
    %--------- Optimize the parameter---------------------    
%     for paramteter=1:1000
%         Y_temp=Y;
%         for i=1:Ysize(2)
%             if abs(Y_temp(i)) < paramteter
%                 Y_temp(i) = 0;
%             end
%         end
%         x= ifft(Y_temp,NFFT);
%         if temp < psnr(s,x(1:Size(2)),255)
%             temp=psnr(s,x(1:Size(2)),255);
%             MAX=paramteter;
%         end    
%     end
    %--------- Eliminate noise by power select---------------------
%     for i=1:Ysize(2)
%         if abs(Y(i)) < (5*Length/2);%MAX %(1*Length/2)
%             Y(i) = 0;
%         end
%     end
    %--------- Eliminate noise by Frequency select---------------------
%     for i=1:255
%         if i*1.9531 > 20      % frequency value
%             Y(i) = 0;
%         else
%             Y(i)=Y(i)*0.999;
%         end    
%     end



%     threshold  = mean(P1(1:NFFT/2))
%     for i=1:Ysize(2)
%         if abs(Y(i))<(threshold*Length/2)
%           Y(i)=Y(i)*0.99;  
%         end  
%     end
    
%    sprintf('Section %d Mean= %f',segment, mean(P1(1:NFFT/2))) 
%     for paramteter=1:50
%         Y_temp=Y;
%         threshold = paramteter/10;
%        for i=1:Ysize(2)
%             if abs(Y_temp(i))<(threshold*Length/2)
%             Y_temp(i)=Y_temp(i)*0.99;  
%             end  
%        end
%        
%        x= ifft(Y_temp,NFFT);
%        Excel(segment,paramteter)=psnr(s,x(1:Size(2)),255);
%        %Excel(1,paramteter)=threshold;
%        if temp < psnr(s,x(1:Size(2)),255)
%             temp=psnr(s,x(1:Size(2)),255);
%             MAX=threshold;
%        end    
%     end

performance=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for parameter=1:100
    tempY=Y;
    threshold=parameter/100;
    %MAX=mean(n2);
   if segment==2 
      for i=1:Ysize(2)
        if(rem(fix(i*(Fs/NFFT)*1000),2)==1)
            if abs(tempY(i))<(threshold*Length/2)
            tempY(i)=0;  
            else
            %tempY(i)=tempY(i)*0.99;  
            end  
        end    
      end 
   else
    for i=1:Ysize(2)
        if abs(tempY(i))<(threshold*Length/2)
          tempY(i)=0;  
        else
          %tempY(i)=tempY(i)*0.99;  
        end  
    end 
   end 
    
    x= ifft(tempY,NFFT);
    %Excel(segment,parameter)=psnr(s,x(1:Size(2)),255);
    if (performance < psnr(s,x(1:Size(2)),255))
        performance=psnr(s,x(1:Size(2)),255);
        MAX=threshold;
    end    
end   
    if segment==2 
      for i=1:Ysize(2)
        if(rem(fix(i*(Fs/NFFT)*1000),2)==1)
            if abs(Y(i))<(MAX*Length/2)
            Y(i)=0;
            else
            %Y(i)=Y(i)*0.99;
            end 
        end    
      end
    else   
        for i=1:Ysize(2)
            if abs(Y(i))<(MAX*Length/2)
             Y(i)=0;
            else
            %Y(i)=Y(i)*0.99;
            end  
        end   
    end

   % sprintf('Dnoise Signal   PSNR=%f', psnr(s,x(1:Size(2)),255))
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%     threshold=200;
%     for i=1:256
%        if (i*(Fs/NFFT)> 200)&(i*(Fs/NFFT)<= 500)&(rem(fix(i*(Fs/NFFT)*1000),2)==1)
%            Y(i)=0;
%        else
%            Y(i)=Y(i)*0.999;
%        end 
%     end
    %--------- Eliminate noise by Noise power distribution-------------
  %Y=Y*0.9996;
    
% %% -------------(Denoise) Frequency Domain---------------------
    P2 = abs(Y/Length);
    P1 = P2(1:NFFT/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    plot(0:(1/NFFT):(1/2-1/NFFT),P1(1:NFFT/2));
    xlabel('Normalised Frequency (f)'); 
    ylabel('voltage (mV)');
    txt=sprintf('FFT  threshold=%f',MAX);
    title(txt);  
    hold off
    %legend('Original','Noisy',' Denoise')
    
%% ----------------IFFT----------------------------
x= ifft(Y,NFFT);
subplot(3,5,segment+10);
plot(t(1:Size(2)),x(1:Size(2)));
sprintf('Max parameter is %d',(MAX*2/Length));
xlabel('time (s)'); 
ylabel('voltage (mV)');
txt=sprintf('Dnoise Signal   PSNR=%f dB', psnr(s,x(1:Size(2)),255));
title(txt);   
New(section_length(segment)+1:section_length(segment+1))=x(1:Size(2));
end 
figure(6);
subplot(3,1,1)
plot(t(1:2296),signal);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    title('Original Signal ');
    
subplot(3,1,2)
plot(t(1:2296),y1);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Noise & Singal  PSNR=%f dB', psnr(signal,y1,255));
    title(txt); 
    
subplot(3,1,3)
plot(t(1:2296),New);
    xlabel('time (s)'); 
    ylabel('voltage (mV)');
    txt=sprintf('Denoise Signal  PSNR=%f dB', psnr(signal,New,255));
    title(txt);
