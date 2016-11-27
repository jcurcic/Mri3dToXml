function info = getinformation(var,img)
% global var

info = struct;

switch var.SliceOrientation
    case 3
        sliceOrientation = 'coronal';
    case 1
        sliceOrientation = 'transversal';
    case 2
        sliceOrientation = 'sagittal';
    otherwise
        sliceOrientation = 'survey';
end
info.SliceOrientation = sliceOrientation;

examinationDateTime = strtrim(strrep(var.ExaminationDateTime, '.', '-'));
info.RecordDate = examinationDateTime(1:10);
info.Time = examinationDateTime(14:end);

info.ResolutionX = var.PixelSpacingX;
info.ResolutionY = var.PixelSpacingY;
info.ResolutionZ = var.SliceSpacing;
info.N_i = var.ResolutionX;
info.N_j = var.ResolutionY;

info.N_k = size(img,2); %var.nimages;

info.PatientOrientation = strtrim(var.PatientPosition);

info.Angulation = var.Angulation;
info.Offcenter = var.Offcenter;