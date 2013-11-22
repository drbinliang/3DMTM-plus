function features = feature_extraction(representation)
%FEATURE_EXTRACTION Summary of this function goes here
%   feature extraction, return row feature vector

%% decomposition of representation
% XOY
XOY_MHI = representation.XOY_MHI;
XOY_SHI = representation.XOY_SHI;
XOY_AMI = representation.XOY_AMI;
XOY_ASI = representation.XOY_ASI;

% XOZ
XOZ_MHI = representation.XOZ_MHI;

% YOZ
YOZ_MHI = representation.YOZ_MHI;

%% HOG Feature extraction
vector_1 = HOG(XOY_MHI);
vector_2 = HOG(XOY_SHI);
vector_3 = HOG(XOY_AMI);
vector_4 = HOG(XOY_ASI);

vector_5 = HOG(XOZ_MHI);
vector_6 = HOG(YOZ_MHI);

features = [vector_1' vector_2' vector_3' ...
            vector_4' vector_5' vector_6'];
        
end

