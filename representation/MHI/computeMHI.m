function [MHI, MHIs] = computeMHI(GESTURE, t)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% %% version 1.0, implementation according to definition
% %% value of t
% if nargin < 2
%     t = length(GESTURE);
% end
% 
% num_frames = length(GESTURE);
% 
% %%
% ORIGINAL = GESTURE{1};
% ORIGINAL_BIN_IMG = ORIGINAL;
% ORIGINAL_BIN_IMG(ORIGINAL > 0) = 1;
% 
% if t == 1
%     MHI = ORIGINAL_BIN_IMG;
%     return;
% end
% 
% %% generate binary images
% CURRENT = GESTURE{t};
% PREVIOUS = GESTURE{t - 1};
% 
% CURRENT_BIN_IMG = CURRENT;
% CURRENT_BIN_IMG(CURRENT > 0) = 1;
% PREVIOUS_BIN_IMG = PREVIOUS;
% PREVIOUS_BIN_IMG(PREVIOUS > 0) = 1;
% 
% DIFF = frameDiff(CURRENT_BIN_IMG, PREVIOUS_BIN_IMG);
% 
% MHI = DIFF;
% MHI(DIFF == 1) = num_frames;
% 
% TMP = max(0, computeMHI(GESTURE, t-1) -1);
% MHI(DIFF ~= 1) = TMP(DIFF ~= 1);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% version 1.1, implementation without iteration
%% value of t
if nargin < 2
    t = length(GESTURE);
end

num_frames = length(GESTURE);

%% generate binary image from depth image
ORIGINAL_FRAME = GESTURE{1};
ORIGINAL_BIN_IMG = ORIGINAL_FRAME;
ORIGINAL_BIN_IMG(ORIGINAL_FRAME > 0) = 1;

%% a set of MHIs
MHIs = cell(t,1);
MHIs{1} = ORIGINAL_BIN_IMG;

%% compute the other MHIs
for i = 2:t
    %% generate binary images for current frame and previous frame
    CURRENT_FRAME = GESTURE{i};
    PREVIOUS_FRAME = GESTURE{i - 1};
    
    CURRENT_BIN_IMG = CURRENT_FRAME;
    PREVIOUS_BIN_IMG = PREVIOUS_FRAME;
    CURRENT_BIN_IMG(CURRENT_FRAME > 0) = 1;
    PREVIOUS_BIN_IMG(PREVIOUS_FRAME > 0) = 1;
    
    %% difference between consecutive frames
    DIFF_IMG = frameDiff(CURRENT_BIN_IMG, PREVIOUS_BIN_IMG);
    
    %% compute current MHI according to the definition
    % if D ==1
    MHI = DIFF_IMG;
    MHI(DIFF_IMG == 1) = num_frames;
    
    % otherwise
    TMP = max(0, MHIs{i-1} - 1);
    idx = (DIFF_IMG ~= 1);
    MHI(idx) = TMP(idx);
    
    MHIs{i} = MHI;
end

MHI = MHIs{t};
MHI = uint8(255 * mat2gray(MHI));

end
