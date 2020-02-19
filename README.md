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

![alt text](https://github.com/yuchehuang/Signal-Noise-Removal/blob/master/picture/Picture2.png)

Due to the power compaction in DCT, the main energy of the component is concentrated in some parameter and using others to represent the small variation in different frequency. It is good for data compression due to the transforms adopts the less data to represent the original figure but losing detail. Therefore, based on this concept, the noise components which are distributed into the whole spectrum can be eliminated efficiently by removing these tiny value of coefficient