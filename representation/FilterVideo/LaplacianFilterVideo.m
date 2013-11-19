function FilteredVideo = LaplacianFilterVideo(Video)

t = length(Video);
FilteredVideo = cell(t-2,1);

laplacian_filter = [1 -2 1];
gaussian_filter = fspecial('gaussian', [3 3], 1);

for i = 2 : t-1
    CURRENT_FRAME = Video{i};
    PREVIOUS_FRAME = Video{i - 1};
    NEXT_FRAME = Video{i + 1};
    
    %% normalize to [0 255]
    CURRENT_IMG = uint8(255 * mat2gray(CURRENT_FRAME));
    PREVIOUS_IMG = uint8(255 * mat2gray(PREVIOUS_FRAME));
    NEXT_IMG = uint8(255 * mat2gray(NEXT_FRAME));
    
    %% smoothed by Gaussian filter
    G_CURRENT_IMG = imfilter(CURRENT_IMG, gaussian_filter, 'conv', 'replicate');
    %G_PREVIOUS_IMG = imfilter(PREVIOUS_IMG, gaussian_filter, 'conv', 'replicate');
    %G_NEXT_IMG = imfilter(NEXT_IMG, gaussian_filter, 'conv', 'replicate');
    G_PREVIOUS_IMG = PREVIOUS_IMG;
    G_NEXT_IMG = NEXT_IMG;
    
    FILTER_FRAME = laplacian_filter(1) * double(G_PREVIOUS_IMG) + laplacian_filter(2) * double(G_CURRENT_IMG) + laplacian_filter(3) * double(G_NEXT_IMG);
    
%     FILTER_IMG = uint8(255 * mat2gray(FILTER_FRAME));    
%     FilteredVideo{i - 2} = FILTER_IMG;
        
    FilteredVideo{i - 1} = FILTER_FRAME;
end


end

