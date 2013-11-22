Three Dimensional Motion Trail Model for Gesture Recognition.
 
This code is developed for the work: Bin Liang, Lihong Zheng "Three Dimensional Motion Trail Model for Gesture Recognition," 
ICCV 2013 Workshop - Big Data in 3D Computer Vision Workshop.

In case of publication with this code, please cite the paper above.

Dataset: MSR Action3D dataset

HOW to use:

(1) Two SVM files can be generated after running the program, namely "TR_Gestures.svm"
    and "TE_Gestures.svm";
(2) "TR_Gestures.svm" and "TE_Gestures.svm" are used as inputs for LIBSVM. The commands are:
    a.  ## data scale
        svm-scale.exe -l -1 -u 1 -s t_range TR_Gestures.svm > TR_Gestures.svm.scale 
        svm-scale.exe -r t_range TE_Gestures.svm > TE_Gestures.svm.scale
    b.  ## find out the best C and gamma for the SVM model
        python.exe grid.py TR_Gestures.svm.scale
    c.  ## train model
        svm-train.exe -c [best C] -g [bset gamma] TR_Gestures.svm.scale
    d.  ## predict using trained model
        svm-predict.exe TE_Gestures.svm.scale TR_Gestures.svm.scale.model TE_Gestures.svm.predict