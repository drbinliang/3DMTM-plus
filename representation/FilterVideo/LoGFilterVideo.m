function FilteredVideo = LoGFilterVideo(Video)

t = length(Video);
FilteredVideo = cell(t-4,1);

log_filter = fspecial('log', [1 3], 0.8);

for i = 2 : t-1
    CURRENT_FRAME = Video{i};
    PREVIOUS_FRAME = Video{i - 1};
    NEXT_FRAME = Video{i + 1};
    
    CURRENT_IMG = uint8(255 * mat2gray(CURRENT_FRAME));
    PREVIOUS_IMG = uint8(255 * mat2gray(PREVIOUS_FRAME));
    NEXT_IMG = uint8(255 * mat2gray(NEXT_FRAME));
    
    FILTER_FRAME = log_filter(1) * double(PREVIOUS_IMG) + log_filter(2) * double(CURRENT_IMG) + log_filter(3) * double(NEXT_IMG);
    
%     FILTER_IMG = uint8(255 * mat2gray(FILTER_FRAME));    
%     FilteredVideo{i - 2} = FILTER_IMG;
        
    FilteredVideo{i - 1} = FILTER_FRAME;
end


end

