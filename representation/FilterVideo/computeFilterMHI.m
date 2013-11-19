function [F_MHI, F_MHIs] = computeFilterMHI(F_VIDEO, t)

%% version 1.1, implementation without iteration
%% value of t
if nargin < 3
    t = length(F_VIDEO);
end

num_frames = length(F_VIDEO);

%ORIGINAL_FRAME = SEQUENCE{2};
%ORIGINAL_FRAME = F_VIDEO{1};

%% a set of MHIs
[row, col] = size(F_VIDEO{1});

F_MHIs = cell(t,1);
F_MHIs{1} = zeros(row, col);

%% threshold of 'slope' for LoG filtered video
motion_threshold = 10;

for i = 2:t
    %% frame normalization
    CURRENT_FRAME = F_VIDEO{i};
    PREVIOUS_FRAME = F_VIDEO{i - 1};
    %NEXT_FRAME = F_VIDEO{i + 1};
    
    %% generate motion image
    MOTION_IMG = generateMotionImg(PREVIOUS_FRAME, CURRENT_FRAME, motion_threshold);
    
    %% compute current MHI according to the definition
    % if D ==1
    F_MHI = MOTION_IMG;
    F_MHI(MOTION_IMG == 1) = num_frames;
    
    % otherwise
    TMP = max(0, F_MHIs{i-1} - 1);

    
    idx = (MOTION_IMG ~= 1);
    F_MHI(idx) = TMP(idx);
    
    F_MHIs{i} = F_MHI;
    
end

F_MHI = F_MHIs{t};

end