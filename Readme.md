# <center>MAIA - Markerless Automatic Infant motion Analysis</center>

<p align="center">
  <img src='Media/Maia.png' width="400" height="" >  
</p>

According to Heinz Prechtl's Theory the spontaneous movements of infants reflect the neurological development, it is therefore possible to recognize abnormal motion pattern as pathological.
MAIA is a software architecture that allows a ***quantitative*** infant motion assessment.
The motion is analyzed using a deep neural network for markerless analysis, the DeepLabCut Neural Network.
Once the video of the baby is analyzed it is possible to process the coordinates of the digital markers and extract the parameters that describe the quality of the motion.
Finally the descriptive parameters extracted by MAIA allows to classify whether the subject’s motor pattern is normal or abnormal.

The software architecture is composed of 4 modules:

<p align="center">
  <img src='Media/Architecture.png' width="800" height="" >  
</p>

Each module can be freely modified according to the user's requirements.

## License
This project is licensed under the GNU Lesser General Public License v3.0. If you use the code, please cite me!.

## Requirements
1. [Matlab](https://www.mathworks.com/products/matlab.html)
2. [DeepLabCut toolbox](https://github.com/AlexEMG/DeepLabCut)
