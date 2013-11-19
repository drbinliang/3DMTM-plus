function representation = compute3DMTM_v4(FilteredVideo_XOY, FilteredVideo_XOZ, FilteredVideo_YOZ)

F_MHI_XOY = computeFilterMHI(FilteredVideo_XOY);
F_MHI_XOZ = computeFilterMHI(FilteredVideo_XOZ);
F_MHI_YOZ = computeFilterMHI(FilteredVideo_YOZ);

representation = struct;
representation.XOY_MHI = uint8(255 * mat2gray(F_MHI_XOY));
representation.XOZ_MHI = uint8(255 * mat2gray(F_MHI_XOZ));
representation.YOZ_MHI = uint8(255 * mat2gray(F_MHI_YOZ));

end