# Activity-Recognition
Activity Recognition using Graph Theory and statiscal modelling


The technology development in the modern era is limited only by human imagination. These modern technologies are developed with the sole aim to improve and add comfort factor to human lives through smart and intelligent applications by automation and bio-medical researches. Major researches in bio-medical fields are studying our human body activity recognition and this requires live data from sensors attached to human subjects to be processed using mathematical models and develop intelligent learning algorithms to predict and recognize the activities. \par
Our project is focused on such activity recognition using sensor data from Opportunity Data-set provided by Chavarriaga, Ricardo, et al. We decided to Hidden Markov Model as our graphical model to process the sensor data. The sensor data for this project has been obtained from experiments performed in Chavarriaga, Ricardo, et al. The experiment contains five different subjects who perform a sequence of activities. Different sensors are attached to different parts of their body and these sensor data are collected for a different time stamp and the activities are performed and saved as data sets. For this project we make use of the sensor values from the columns 1 to 34 of the data sets in ADL1, ADL2, ADL3, ADL4,and ADL5. The columns 35,36 and 37 are neglected in the project as they have NULL values occurring mostly.  The column-1 represents the time instance in millisecond. The columns from 2 - 37 give us the values of different sensors. Column 245 provide us with the high level activity values. The high level activities are represented by 0,101,102,103,104,and 105 and the legends for this has been provided in the Opportunity Data set signifying different activities. There are few missing data in the set, these are dealt with by extrapolating the values. \par
The specific goals of the project is to predict the high level activities which consists of relaxing, coffee time, early morning, cleanup, sandwich time using Hidden Markov Model. We have used MATLAB to process the given data and also for implementing the Hidden Markov Model. We have coded the Viterbi Algorithm as well to perform training and find the maximum likelihood for the states. In our later sections we have obtained results for the accuracy of the built model, F measure, and ROC curve. 