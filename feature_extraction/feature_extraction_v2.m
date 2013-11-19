function features = feature_extraction_v2(representation)
%FEATURE_EXTRACTION Summary of this function goes here
%   feature extraction, return row feature vector

%% decomposition of representation
% XOY
XOY_MHI = representation.XOY_MHI;
XOY_DMM = representation.XOY_DMM;

% XOZ
XOZ_MHI = representation.XOZ_MHI;
XOZ_DMM = representation.XOZ_DMM;

% YOZ
YOZ_MHI = representation.YOZ_MHI;
YOZ_DMM = representation.YOZ_DMM;

%% Matlab HOG Feature extraction
CellSize = [8 8];
[vec1, vis1] = extractHOGFeatures(XOY_MHI, 'CellSize', CellSize);
[vec2, vis2] = extractHOGFeatures(XOY_DMM, 'CellSize', CellSize);
[vec3, vis3] = extractHOGFeatures(XOZ_MHI, 'CellSize', CellSize);
[vec4, vis4] = extractHOGFeatures(XOZ_DMM, 'CellSize', CellSize);
[vec5, vis5] = extractHOGFeatures(YOZ_MHI, 'CellSize', CellSize);
[vec6, vis6] = extractHOGFeatures(YOZ_DMM, 'CellSize', CellSize);

%features = [vec1 vec2 vec3 vec4 vec5 vec6];
features = [vec1 vec3 vec5];
        
end

