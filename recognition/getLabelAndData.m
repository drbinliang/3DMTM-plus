function [tr_label, tr_data] = getLabelAndData(Gestures)
%TRAIN Summary of this function goes here
%   Detailed explanation goes here

%% Format training data
% number of training data
n = length(Gestures);

XOY_MHI = 1:81;
XOY_SHI = 82:162;
XOY_AMI = 163:243;
XOY_ASI = 244:324;

XOZ_MHI = 325:405;
YOZ_MHI = 406:486;

% number of features
m = 81 * 6;

% label of training data
tr_label = zeros(n, 1);

% data of training data
tr_data = zeros(n, m);

for i = 1:n
    selected_features = [Gestures(i).Features(XOY_MHI) Gestures(i).Features(XOY_SHI) Gestures(i).Features(XOY_AMI) ...
                         Gestures(i).Features(XOY_ASI) Gestures(i).Features(XOZ_MHI) Gestures(i).Features(YOZ_MHI)];

%     selected_features = [Gestures(i).Features(XOY_MHI) Gestures(i).Features(XOY_SHI) Gestures(i).Features(XOZ_MHI) Gestures(i).Features(YOZ_MHI)];
    tr_label(i) = Gestures(i).Id;
    tr_data(i,:) = selected_features;    
end

%model = svmtrain(tr_label, tr_data, '-s 0 -t 2 -c 1 -g 0.1');

% cross-validation
%accuracy = svmtrain(tr_label, tr_data, '-s 0 -t 2 -v 5 -c 32 -g 0.5');
% model = svmtrain(tr_label, tr_data, '-s 0 -t 2 -c 8 -g 0.0078125');
end

