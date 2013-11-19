function representation = compute3DMTM_v3(FilteredVideo, FilteredVideo_XOZ, FilteredVideo_YOZ)

DMHI_XOY = computeDepthMHI(FilteredVideo);
DMHI_XOZ = computeMHI(FilteredVideo_XOZ);
DMHI_YOZ = computeMHI(FilteredVideo_YOZ);

representation = struct;
representation.XOY_MHI = uint8(255 * mat2gray(DMHI_XOY));
representation.XOZ_MHI = uint8(255 * mat2gray(DMHI_XOZ));
representation.YOZ_MHI = uint8(255 * mat2gray(DMHI_YOZ));

end