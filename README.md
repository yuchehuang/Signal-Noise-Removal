# Signal-Noise-Removal
 

 ## Key Features
* This project demonstrates the noise removal by using FFT analysis and Decrete Cosine Transform (DCT)
from a contaminated signal. 

* The code is shown in the in the [Code](https://github.com/yuchehuang/Signal-Noise-Removal/tree/master/code)  folder

* The result of the experiment is shown as the [report](https://github.com/yuchehuang/Signal-Noise-Removal/blob/master/Report.pdf)

## Result
### FFT 

![alt text](https://github.com/yuchehuang/Signal-Noise-Removal/blob/master/picture/FFT%20Denoise.png)

![alt text](https://github.com/yuchehuang/Signal-Noise-Removal/blob/master/picture/Picture1.png)


It is clearly that the signal still suffering in the contaminting of noise after passing by the denoise algorithm.

Due to the noise components are distributed irregularly through the spectrum, some of the noise components have combined with the original one. It leads the algorithm can not distinguish the noise element form them because of the magnitude of noise in each frequency is still uncertain.   
 
### DCT
![alt text](https://github.com/yuchehuang/Signal-Noise-Removal/blob/master/picture/DCT%20Denoise.png)
