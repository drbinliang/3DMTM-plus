function mat2SVMfile_norm(X, fileName)
%TRAIN Summary of this function goes here
%   Detailed explanation goes here

%% Format training data
% number of training data
n = size(X,1);

% label of training data
%tr_label = zeros(n, 1);

%file_path = '/home/span/pgrad/bliang03/Documents/MSR-Action3D/code/SVM_files/';
file_path = 'D:\\Research\\Projects\\MSR Action 3D\\code\\SVM_files\\';

fid = fopen([file_path fileName], 'w');

% XOY_MHI = 1:81;
% XOY_SHI = 82:162;
% XOY_AMI = 163:243;
% XOY_ASI = 244:324;
% 
% XOZ_MHI = 325:405;
% YOZ_MHI = 406:486;
% 
% % data of training data
% num_features = 81 * 6;

%% 3D-MTM number of features
%num_features = 238752;	% cellSize = [8 8]
%num_features = 56124;	% cellSize = [16 16]
%num_features = 11556;   % cellSize = [32 32]

%% 3D-MHI number of features
num_features = 77436;	% cellSize = [8 8]
% num_features = 27396;	% cellSize = [16 16]
%num_features = 11556;   % cellSize = [32 32]

%% 3D-MTM_v2 number of features
%num_features = 233208;	% cellSize = [8 8]
%num_features = 56124;	% cellSize = [16 16]
%num_features = 11556;   % cellSize = [32 32]

%% DMM number of features
% num_features = 116604;	% cellSize = [8 8]
%num_features = 56124;	% cellSize = [16 16]
%num_features = 11556;   % cellSize = [32 32]

for i = 1:n
    fprintf(fid, '%d ', X(i, 1)); 

    for j = 1:num_features
        fprintf(fid, '%d:', j);
        fprintf(fid, '%f ', X(i,j+1));
    end
    fprintf(fid, '\n'); 
    fprintf([int2str(i), '...\n']);
end
fclose(fid);
end

