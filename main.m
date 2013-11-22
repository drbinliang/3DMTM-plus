%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Bin Liang (bin.liang.ty@gmail.com)
% Charles Sturt University
% Created:	September 2013
% Modified:	November 2013
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Preparing for running
% clear variables
clear all; close all; clc;

% add to path
this_dir = pwd;
addpath(genpath(this_dir));

% set dataset path
data_path = 'D:\\Research\\Projects\\Dataset\\MSR Action3D\\dataset\\';

% specify the paths to training and  test data
test_subsets = {'test_one\\', 'test_two\\', 'cross_subject_test\\'};
action_subsets = {'AS1\\', 'AS2\\', 'AS3\\'};

% training_data_dir = [data_path test_subsets{1} 'training\\' action_subsets{1}];
% test_data_dir = [data_path test_subsets{1} 'test\\' action_subsets{1}];

performed_dataset_path = [data_path test_subsets{1} action_subsets{1}];
training_data_dir = [performed_dataset_path 'training\\'];
test_data_dir = [performed_dataset_path 'test\\'];

%% Load training data
d = dir(training_data_dir);
isfile = [d(:).isdir] ~= 1;
files = {d(isfile).name}';

TR_Gestures = struct;

%% Feature extraction for training dataset
fprintf('Loading training data:\n');
for i=1:length(files)
    fprintf([files{i}, '...']);
    
    % load data as a video sequence
    SEQUENCE = readDepthDataset([training_data_dir files{i}]);  % frame scale: [1 552]        

    % gesture representation using 3D-MTM
    representation = compute3DMTM(SEQUENCE);
   
    % feature extraction using HOG (fast HOG)
    features = feature_extraction(representation);
    
    % additional information
    name = files{i};
    id = name(2:3);

    % save data
    TR_Gestures(i).Features = features;
    TR_Gestures(i).Name = name;
    TR_Gestures(i).Id = str2double(id);
    
    fprintf('done.\n');        
end

% save training data as .mat file
% save('TR_Gestures.mat', 'TR_Gestures');

% format to SVM file
TR_SVM_file = 'TR_Gestures.svm';
mat2SVMfile(TR_Gestures, TR_SVM_file);

%pause;

%% Load test data
d = dir(test_data_dir);
isfile = [d(:).isdir] ~= 1;
files = {d(isfile).name}';

TE_Gestures = struct;

%% Feature extraction for test dataset
fprintf('Loading test data:\n');
for i=1:length(files)
    fprintf([files{i}, '...']);
    
    % load data as a video sequence
    SEQUENCE = readDepthDataset([test_data_dir files{i}]);    

    % gesture representation using 3D-MTM
    representation = compute3DMTM(SEQUENCE);   
    features = feature_extraction(representation);

    % additional information
    name = files{i};
    id = name(2:3);

    % save data
    TE_Gestures(i).Features = features;
    TE_Gestures(i).Name = name;
    TE_Gestures(i).Id = str2double(id);

    fprintf('done.\n');
end

% save test data as .mat file
% save('TE_Gestures.mat', 'TE_Gestures');

% format to SVM file
TE_SVM_file = 'TE_Gestures.svm';
mat2SVMfile(TE_Gestures, TE_SVM_file);

%pause;

%% recognition
%[predict_label, accuracy] = recognize(TR_Gestures, TE_Gestures);
pause(0.5);beep; pause(0.5);beep; pause(0.5);beep;