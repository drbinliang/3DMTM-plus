function [predict_label, accuracy] = recognize(TR_Gestures, TE_Gestures)
%% data and label preparing for SVM
% training data and label
[train_label, train_data] = getLabelAndData(TR_Gestures);

% test data and label
[test_label, test_data] = getLabelAndData(TE_Gestures);

%% scale data
[train_data_scale,test_data_scale] = scaleForSVM(train_data, test_data, -1, 1);

%% best parameters C and gamma for the model
% cmin = -5;
% cmax = 15;
% gmin = -15;
% gmax = 3;
% v = 5;
% cstep = 0.5;
% gstep = 0.5;
% accstep = 4.5;
% [bestacc, bestc, bestg] = SVMcgForClass(train_label,train_data_scale, cmin,cmax,gmin,gmax,v,cstep,gstep,accstep);
bestc = 32;
bestg = 0.00048828125;
model = svmtrain(train_label, train_data_scale, ['-s 0 -t 2 -c ' num2str(bestc) '-g ' num2str(bestg)]);
[predict_label, accuracy, ~] = svmpredict(test_label, test_data_scale, model, '-q');
end