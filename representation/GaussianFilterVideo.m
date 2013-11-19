function FilteredVideo = GaussianFilterVideo(Video)

t = length(Video);
FilteredVideo = cell(t-4,1);
for i = 3 : t-2
    CURRENT_FRAME = Video{i};
    PREVIOUS_FRAME_1 = Video{i - 2};
    PREVIOUS_FRAME_2 = Video{i - 1};
    NEXT_FRAME_1 = Video{i + 1};
    NEXT_FRAME_2 = Video{i + 2};
    
    CURRENT_IMG = uint8(255 * mat2gray(CURRENT_FRAME));
    PREVIOUS_IMG_1 = uint8(255 * mat2gray(PREVIOUS_FRAME_1));
    PREVIOUS_IMG_2 = uint8(255 * mat2gray(PREVIOUS_FRAME_2));
    NEXT_IMG_1 = uint8(255 * mat2gray(NEXT_FRAME_1));
    NEXT_IMG_2 = uint8(255 * mat2gray(NEXT_FRAME_2));
    
    FILTER_FRAME = 1 * double(PREVIOUS_IMG_1) + 4 * double(PREVIOUS_IMG_2) + 6 * double(CURRENT_IMG) ...
                 + 4 * double(NEXT_IMG_1) + 1 * double(NEXT_IMG_2);
    
    FILTER_IMG = uint8(255 * mat2gray(FILTER_FRAME));
       
    FilteredVideo{i - 2} = FILTER_IMG;
end


end

