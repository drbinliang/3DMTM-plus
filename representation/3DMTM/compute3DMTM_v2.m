function representation = compute3DMTM_v2(GESTURE, t)
%function [depthMHI, depthMHIs, depthSHI, depthSHIs, AMI, ASI] = compute3DMTM(GESTURE, t)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% %% version 1.0, implementation according to definition 
% num_frames = length(GESTURE);
% 
% %% if paramter t is omitted, default t is the length of the whole gesture sequence
% if nargin < 2
%     t = num_frames;
% end
% 
% ORIGINAL = GESTURE{1};
% %ORIGINAL_IMG = 255 * mat2gray(ORIGINAL);
% 
% %% if t equals 1, MHI is the first frame (pixel values range from 0 to 1)    
% if t == 1
%     depthMHI = mat2gray(ORIGINAL);
%     return;
% end
% 
% %% generate depth images (pixel values range from 0 to 255)
% CURRENT = GESTURE{t};
% CURRENT_IMG = 255 * mat2gray(CURRENT);
% PREVIOUS = GESTURE{t - 1};
% PREVIOUS_IMG = 255 * mat2gray(PREVIOUS);
% 
% % threshold for compute the differences of consecutive frmames
% threshold = 10;
% 
% DIFF_IMG = depthFrameDiff(CURRENT_IMG, PREVIOUS_IMG, threshold);
% 
% depthMHI = DIFF_IMG;
% 
% depthMHI(DIFF_IMG == 1) = num_frames;
% 
% TMP = max(0, computeDepthMHI(GESTURE, t-1) -1);
% depthMHI(DIFF_IMG ~= 1) = TMP(DIFF_IMG ~= 1);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%% version 1.1, implementation without iteration
%% value of t
if nargin < 2
    t = length(GESTURE);
end

num_frames = length(GESTURE);

%% frame nomalization 
ORIGINAL_FRAME = GESTURE{1};
ORIGINAL_IMG = mat2gray(ORIGINAL_FRAME);
[~, ORIGINAL_XOZ_IMG, ORIGINAL_YOZ_IMG] = reproject(ORIGINAL_FRAME);

%% a set of MHIs
depthMHIs = cell(t,1);
depthMHIs{1} = ORIGINAL_IMG;

% %% a set of SHIs
% depthSHIs = cell(t,1);
% depthSHIs{1} = ORIGINAL_IMG;

%% a set of XOZ_MHIs
XOZ_MHIs = cell(t,1);
XOZ_MHIs{1} = ORIGINAL_XOZ_IMG;

%% a set of YOZ_MHIs
YOZ_MHIs = cell(t,1);
YOZ_MHIs{1} = ORIGINAL_YOZ_IMG;

%% XOY_DMM initialization
[row_xoy, col_xoy] = size(ORIGINAL_FRAME);
XOY_DMM = zeros(row_xoy, col_xoy);

%% XOZ_DMM initialization
[row_xoz, col_xoz] = size(ORIGINAL_XOZ_IMG);
XOZ_DMM = zeros(row_xoz, col_xoz);

%% YOZ_DMM initialization
[row_yoz, col_yoz] = size(ORIGINAL_YOZ_IMG);
YOZ_DMM = zeros(row_yoz, col_yoz);

% AMI = zeros(row, col);
% ASI = zeros(row, col);

%% compute MHIs and DMMs
xoy_motion_threshold = 10;
xoy_static_threshold = 50;

other_motion_threshold = 10;
other_static_threshold = 50;

for i = 2:t
    %% frame normalization
    CURRENT_FRAME = GESTURE{i};
    [~, CURRENT_XOZ_IMG, CURRENT_YOZ_IMG] = reproject(CURRENT_FRAME);
    
    PREVIOUS_FRAME = GESTURE{i - 1};
    [~, PREVIOUS_XOZ_IMG, PREVIOUS_YOZ_IMG] = reproject(PREVIOUS_FRAME);
    
    CURRENT_IMG = 255 * mat2gray(CURRENT_FRAME);
    PREVIOUS_IMG = 255 * mat2gray(PREVIOUS_FRAME);
    
    %% difference between consecutive frames
    [MOTION_IMG, STATIC_IMG] = depthFrameDiff(CURRENT_IMG, PREVIOUS_IMG, xoy_motion_threshold, xoy_static_threshold);
%     [MOTION_XOZ_IMG, STATIC_XOZ_IMG] = depthFrameDiff(CURRENT_XOZ_IMG, PREVIOUS_XOZ_IMG, other_motion_threshold, other_static_threshold);
%     [MOTION_YOZ_IMG, STATIC_YOZ_IMG] = depthFrameDiff(CURRENT_YOZ_IMG, PREVIOUS_YOZ_IMG, other_motion_threshold, other_static_threshold);
    DIFF_XOZ_IMG = frameDiff(CURRENT_XOZ_IMG, PREVIOUS_XOZ_IMG);
    DIFF_YOZ_IMG = frameDiff(CURRENT_YOZ_IMG, PREVIOUS_YOZ_IMG);
    
    %% DMM summation
    XOY_DMM = XOY_DMM + MOTION_IMG;
    XOZ_DMM = XOZ_DMM + DIFF_XOZ_IMG;
    YOZ_DMM = YOZ_DMM + DIFF_YOZ_IMG;
    
    %% XOY
    %% compute current MHI according to the definition
    % if D ==1
    depthMHI = MOTION_IMG;
    depthMHI(MOTION_IMG == 1) = num_frames;
    
    % otherwise
    TMP = max(0, depthMHIs{i-1} - 1);
    idx = (MOTION_IMG ~= 1);
    depthMHI(idx) = TMP(idx);
    
    depthMHIs{i} = depthMHI;
    
    %% XOZ
    %% compute current MHI according to the definition
    % if D ==1
    XOZ_MHI = DIFF_XOZ_IMG;
    XOZ_MHI(DIFF_XOZ_IMG == 1) = num_frames;
    
    % otherwise
    TMP = max(0, XOZ_MHIs{i-1} - 1);
    idx = (DIFF_XOZ_IMG ~= 1);
    XOZ_MHI(idx) = TMP(idx);
    
    XOZ_MHIs{i} = XOZ_MHI;
    
    %% YOZ
    %% compute current MHI according to the definition
    % if D ==1
    YOZ_MHI = DIFF_YOZ_IMG;
    YOZ_MHI(DIFF_YOZ_IMG == 1) = num_frames;
    
    % otherwise
    TMP = max(0, YOZ_MHIs{i-1} - 1);
    idx = (DIFF_YOZ_IMG ~= 1);
    YOZ_MHI(idx) = TMP(idx);
    
    YOZ_MHIs{i} = YOZ_MHI;
    
end

depthMHI = depthMHIs{t};

representation = struct;

% XOY_DMM(XOY_DMM >= 1) = 1;
% XOZ_DMM(XOZ_DMM >= 1) = 1;
% YOZ_DMM(YOZ_DMM >= 1) = 1;

%% scale all the elements to [0, 255]

representation.XOY_MHI = uint8(255 * mat2gray(depthMHI));
representation.XOY_DMM = uint8(255 * mat2gray(XOY_DMM));

representation.XOZ_MHI = uint8(255 * mat2gray(XOZ_MHI));
representation.XOZ_DMM = uint8(255 * mat2gray(XOZ_DMM));

representation.YOZ_MHI = uint8(255 * mat2gray(YOZ_MHI));
representation.YOZ_DMM = uint8(255 * mat2gray(YOZ_DMM));
end