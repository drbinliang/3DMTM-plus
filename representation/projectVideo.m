function [SEQUENCE_XOZ, SEQUENCE_YOZ] = projectVideo(SEQUENCE)

t = length(SEQUENCE);
SEQUENCE_XOZ = cell(t, 1);
SEQUENCE_YOZ = cell(t, 1);

for i = 1 : t
    FRAME = SEQUENCE{i};
    [~, XOZ_IMG, YOZ_IMG] = reproject(FRAME);
    
    SEQUENCE_XOZ{i} = XOZ_IMG;
    SEQUENCE_YOZ{i} = YOZ_IMG;
end

end

