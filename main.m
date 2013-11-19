%% clear variables
clear all; close all; clc;

%% add to path
this_dir = pwd;
addpath(genpath(this_dir));

%% read data

% % Specify the paths to training and  test data
% training_data_dir = '/home/span/pgrad/bliang03/Documents/MSR-Action3D/training/';
% test_data_dir = '/home/span/pgrad/bliang03/Documents/MSR-Action3D/test/';

% Specify the paths to training and  test data
training_data_dir = 'D:\\Research\\Projects\\Dataset\\MSR Action3D\\dataset\\test_two\\training\\AS3\\';
test_data_dir = 'D:\\Research\\Projects\\Dataset\\MSR Action3D\\dataset\\test_two\\test\\AS3\\';

%% load training data
d = dir(training_data_dir);
isfile = [d(:).isdir] ~= 1;
files = {d(isfile).name}';

TR_Gestures = struct;

% %% construct raw features
num_features = 77436;
TR_FEATURES = zeros(length(files), num_features);
tr_lables = zeros(length(files), 1);
%%
fprintf('Loading training data:\n');
for i=1:length(files)
    fprintf([files{i}, '...']);
    
    SEQUENCE = readDepthDataset([training_data_dir files{i}]);  % frame scale: [1 552]        
    [SEQUENCE_XOZ, SEQUENCE_YOZ] = projectVideo(SEQUENCE);      % frame scale: [0 1]
    
    %% generate representation for each gesture
    % load data and extract features
    
    % video filtered by Gaussian filter [1 4 6 4 1]
%     FilteredVideo = GaussianFilterVideo(SEQUENCE);
%     FilteredVideo_XOZ = GaussianFilterVideo(SEQUENCE_XOZ);
%     FilteredVideo_YOZ = GaussianFilterVideo(SEQUENCE_YOZ);
    
    %% video filtered by LoG
    FilteredVideo_XOY = LoGFilterVideo(SEQUENCE);
    FilteredVideo_XOZ = LoGFilterVideo(SEQUENCE_XOZ);
    FilteredVideo_YOZ = LoGFilterVideo(SEQUENCE_YOZ);
    
    %% video filtered by Laplacian
%     FilteredVideo_XOY = LaplacianFilterVideo(SEQUENCE);
%     FilteredVideo_XOZ = LaplacianFilterVideo(SEQUENCE_XOZ);
%     FilteredVideo_YOZ = LaplacianFilterVideo(SEQUENCE_YOZ);


    % gesture representation
    % 3D-MTM
    %representation = compute3DMTM_v2(SEQUENCE);
    %representation = compute3DMTM_v3(FilteredVideo, FilteredVideo_XOZ, FilteredVideo_YOZ);
    representation = compute3DMTM_v4(FilteredVideo_XOY, FilteredVideo_XOZ, FilteredVideo_YOZ);
   
    features = feature_extraction_v3(representation);
    
%     % MHI
%     representation = computeMHI(SEQUENCE);
%     features = HOG(representation);
    %% additional information
    name = files{i};
    id = name(2:3);

    %% save data
    TR_Gestures(i).Features = features;
    TR_Gestures(i).Name = name;
    TR_Gestures(i).Id = str2double(id);

%     %% save raw features
    tr_lables(i, :) = str2double(id);
    TR_FEATURES(i, :) = features;
    
    fprintf('done.\n');        
end

% %% PCA
% NORM_TR_FEATURES = zscore(TR_FEATURES);
% [COEFF, Proj_TR_Features, latent] = pca(NORM_TR_FEATURES);
% 
% for i=1:length(latent)
%     if latent(i) / sum(latent) > 0.99
%         break;
%     end
% end
% 
% pc_num = i;
% 
% REDUCED_TR_Features = Proj_TR_Features(:, 1:pc_num);

% save training data as .mat file
save('TR_Gestures.mat', 'TR_Gestures');

% format to SVM file
TR_SVM_file = 'TR_Gestures.svm';
% mat2SVMfile(TR_Gestures, TR_SVM_file);

% format normalized features
X = [tr_lables zscore(TR_FEATURES)];
mat2SVMfile_norm(X, TR_SVM_file);

%pause;

%% load test data
d = dir(test_data_dir);
isfile = [d(:).isdir] ~= 1;
files = {d(isfile).name}';

TE_Gestures = struct;

%%
TE_FEATURES = zeros(length(files), num_features);
te_lables = zeros(length(files), 1);
%%
fprintf('Loading test data:\n');
for i=1:length(files)
    fprintf([files{i}, '...']);
    
    SEQUENCE = readDepthDataset([test_data_dir files{i}]);    
    [SEQUENCE_XOZ, SEQUENCE_YOZ] = projectVideo(SEQUENCE);
    
    %% video filtered by LoG
    FilteredVideo_XOY = LoGFilterVideo(SEQUENCE);
    FilteredVideo_XOZ = LoGFilterVideo(SEQUENCE_XOZ);
    FilteredVideo_YOZ = LoGFilterVideo(SEQUENCE_YOZ);
    
    %% generate representation for each gesture
    % load data and extract features
    
    % video filtered by Gaussian filter [1 4 6 4 1]
%     FilteredVideo = GaussianFilterVideo(SEQUENCE);
%     FilteredVideo_XOZ = GaussianFilterVideo(SEQUENCE_XOZ);
%     FilteredVideo_YOZ = GaussianFilterVideo(SEQUENCE_YOZ);

    %% gesture representation
    %3D-MTM
%     representation = compute3DMTM_v2(SEQUENCE);   
%     features = feature_extraction_v2(representation);
%     representation = compute3DMTM_v3(FilteredVideo, FilteredVideo_XOZ, FilteredVideo_YOZ);
   
    representation = compute3DMTM_v4(FilteredVideo_XOY, FilteredVideo_XOZ, FilteredVideo_YOZ);
    features = feature_extraction_v3(representation);

%     % MHI
%     representation = computeMHI(SEQUENCE);
%     features = HOG(representation);
    %% additional information
    name = files{i};
    id = name(2:3);

    %% save data
    TE_Gestures(i).Features = features;
    TE_Gestures(i).Name = name;
    TE_Gestures(i).Id = str2double(id);

    fprintf('done.\n');

    %% save to file
    te_lables(i, :) = str2double(id);
    TE_FEATURES(i, :) = features;
end

% %% PCA
% NORM_TR_FEATURES = zscore(TE_FEATURES);
% Proj_TE_Features = bsxfun(@minus, NORM_TR_FEATURES, mean(NORM_TR_FEATURES)) * COEFF;
% REDUCED_TE_Features = Proj_TE_Features(:, 1:pc_num);

% save test data as .mat file
save('TE_Gestures.mat', 'TE_Gestures');

% format to SVM file
TE_SVM_file = 'TE_Gestures.svm';
%mat2SVMfile(TE_Gestures, TE_SVM_file);

% format normalized features
X = [te_lables zscore(TE_FEATURES)];
mat2SVMfile_norm(X, TE_SVM_file);

%pause;

%% recognition
%[predict_label, accuracy] = recognize(TR_Gestures, TE_Gestures);
pause(0.5);beep; pause(0.5);beep; pause(0.5);beep;