function xml(xmlfile,mri3d_data)

var = mri3d_data.var;
img = mri3d_data.img;

% global hdl img rawimage var
info = getinformation(var,img);

% switch get(hdl.mriType,'value')
%     case 1
%         info.DataType = 'VOL';
%         info.DataVal = 'au';
%     case 2
%         info.DataType = 'T1';
%         info.DataVal = 'ms';
% end

% info.InStudyPatientID = get(hdl.inStudyPatientID,'string');
% info.StartTime = get(hdl.startTime,'string');

% Problem - study start time and in study patient ID - take form CRFs...?
info.StartTime = '00:00:00';
info.InStudyPatientID = 'R01';
info.DataType = 'VOL';
info.DataVal = 'au';


info.PatientName = strtrim(var.PatientName);
info.ExaminationName = strtrim(var.ExaminationName);
info.ContourType = var.group_names{1};
info.IJK2XYZ = var.IJK2XYZ;

if ~nargin
    [xmlname,xmlpath] = uiputfile([var.FileName '.xml'],'Save XML-File');
    if xmlname == 0,
        return
    end
    xmlfile = [xmlpath xmlname];
end
    

docNode = com.mathworks.xml.XMLUtils.createDocument('xhrm');

xhrm = docNode.getDocumentElement;
xhrm.setAttribute('xmlns:mrizh','http://menne-biomed.de/MRIZH');
xhrm.setAttribute('schemaVersion','3.0_0');
xhrm.setAttribute('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
xhrm.setAttribute('xsi:noNamespaceSchemaLocation','http://menne-biomed.de/MRIZH/MRIZH.xsd');

study = docNode.createElement('study');
study.setAttribute('name',info.ExaminationName);
xhrm.appendChild(study);

patient = docNode.createElement('patient');
study.appendChild(patient);

inStudyPatientID = docNode.createElement('inStudyPatientID');
inStudyPatientID.appendChild(docNode.createTextNode(info.InStudyPatientID));
patient.appendChild(inStudyPatientID);
initials = docNode.createElement('initials');
initials.appendChild(docNode.createTextNode(info.PatientName));
patient.appendChild(initials);

records = docNode.createElement('records');
study.appendChild(records);
record = docNode.createElement('record');
records.appendChild(record);
recordDate = docNode.createElement('recordDate');
recordDate.appendChild(docNode.createTextNode(info.RecordDate));
record.appendChild(recordDate);

startTime = docNode.createElement('startTime');
startTime.appendChild(docNode.createTextNode(info.StartTime));
record.appendChild(startTime);

scans = docNode.createElement('scans');
record.appendChild(scans);
scan = docNode.createElement('scan');
scans.appendChild(scan);
time = docNode.createElement('time');
time.appendChild(docNode.createTextNode(info.Time));
scan.appendChild(time);
resolutionI = docNode.createElement('resolutionI');
resolutionI.appendChild(docNode.createTextNode(num2str(info.ResolutionX,'%0.2f')));
scan.appendChild(resolutionI);
resolutionJ = docNode.createElement('resolutionJ');
resolutionJ.appendChild(docNode.createTextNode(num2str(info.ResolutionY,'%0.2f')));
scan.appendChild(resolutionJ);
resolutionK = docNode.createElement('resolutionK');
resolutionK.appendChild(docNode.createTextNode(num2str(info.ResolutionZ,'%0.2f')));
scan.appendChild(resolutionK);
patientOrientation = docNode.createElement('patientOrientation');
patientOrientation.appendChild(docNode.createTextNode(info.PatientOrientation));
scan.appendChild(patientOrientation);
ijk2xyz = docNode.createElement('ijk2xyz');
scan.appendChild(ijk2xyz);
m11 = docNode.createElement('m11');
m11.appendChild(docNode.createTextNode(num2str(info.IJK2XYZ(1,1),'%7.3f')));
ijk2xyz.appendChild(m11);
m12 = docNode.createElement('m12');
m12.appendChild(docNode.createTextNode(num2str(info.IJK2XYZ(1,2),'%7.3f')));
ijk2xyz.appendChild(m12);
m13 = docNode.createElement('m13');
m13.appendChild(docNode.createTextNode(num2str(info.IJK2XYZ(1,3),'%7.3f')));
ijk2xyz.appendChild(m13);
m14 = docNode.createElement('m14');
m14.appendChild(docNode.createTextNode(num2str(info.IJK2XYZ(1,4),'%7.3f')));
ijk2xyz.appendChild(m14);
m21 = docNode.createElement('m21');
m21.appendChild(docNode.createTextNode(num2str(info.IJK2XYZ(2,1),'%7.3f')));
ijk2xyz.appendChild(m21);
m22 = docNode.createElement('m22');
m22.appendChild(docNode.createTextNode(num2str(info.IJK2XYZ(2,2),'%7.3f')));
ijk2xyz.appendChild(m22);
m23 = docNode.createElement('m23');
m23.appendChild(docNode.createTextNode(num2str(info.IJK2XYZ(2,3),'%7.3f')));
ijk2xyz.appendChild(m23);
m24 = docNode.createElement('m24');
m24.appendChild(docNode.createTextNode(num2str(info.IJK2XYZ(2,4),'%7.3f')));
ijk2xyz.appendChild(m24);
m31 = docNode.createElement('m31');
m31.appendChild(docNode.createTextNode(num2str(info.IJK2XYZ(3,1),'%7.3f')));
ijk2xyz.appendChild(m31);
m32 = docNode.createElement('m32');
m32.appendChild(docNode.createTextNode(num2str(info.IJK2XYZ(3,2),'%7.3f')));
ijk2xyz.appendChild(m32);
m33 = docNode.createElement('m33');
m33.appendChild(docNode.createTextNode(num2str(info.IJK2XYZ(3,3),'%7.3f')));
ijk2xyz.appendChild(m33);
m34 = docNode.createElement('m34');
m34.appendChild(docNode.createTextNode(num2str(info.IJK2XYZ(3,4),'%7.3f')));
ijk2xyz.appendChild(m34);
m41 = docNode.createElement('m41');
m41.appendChild(docNode.createTextNode(num2str(info.IJK2XYZ(4,1),'%7.3f')));
ijk2xyz.appendChild(m41);
m42 = docNode.createElement('m42');
m42.appendChild(docNode.createTextNode(num2str(info.IJK2XYZ(4,2),'%7.3f')));
ijk2xyz.appendChild(m42);
m43 = docNode.createElement('m43');
m43.appendChild(docNode.createTextNode(num2str(info.IJK2XYZ(4,3),'%7.3f')));
ijk2xyz.appendChild(m43);
m44 = docNode.createElement('m44');
m44.appendChild(docNode.createTextNode(num2str(info.IJK2XYZ(4,4),'%7.3f')));
ijk2xyz.appendChild(m44);

mriType = docNode.createElement('mriType');
mriType.setAttribute('val',info.DataType);
mriType.setAttribute('unit',info.DataVal);
scan.appendChild(mriType);

slices = docNode.createElement('slices');
scan.appendChild(slices);

i = repmat((1:info.N_j)',1,info.N_i); j = repmat((1:info.N_i),info.N_j,1);

for k = 1:info.N_k
    group = strfind(var.group_names,info.ContourType);
    m = find(~cellfun(@isempty,group)==1);
    m_group = find(img(k).scon_group==m);
    if isempty(m_group)
        continue;
    end
    % Here we are making voxels
    MASK = false(info.N_i,info.N_j);
    
    for m = m_group
        scon_i = img(k).scon_y(m,:); scon_j = img(k).scon_x(m,:);
        image = rawimage(:,:,k);
        MASK = MASK | inpolygon(i,j,scon_i,scon_j);
    end
    data = image(MASK); data_i = i(MASK); data_j = j(MASK);
    % [xyz,~] = ijk2xyz([data_i data_j k*ones(length(data),1)]);
    
    slice = docNode.createElement('slice');
    slice.setAttribute('unit','mm');
    slice.setAttribute('orientation',info.SliceOrientation);
    slice.setAttribute('what',info.ContourType);
    slice.setAttribute('k',num2str(k,'%d'));
    slices.appendChild(slice);
    
    voxels = docNode.createElement('voxels');
    slice.appendChild(voxels);
    
    for l = 1:length(data)
        voxel = docNode.createElement('voxel');
        voxel.setAttribute('i',num2str(data_i(l),'%d'));
        voxel.setAttribute('j',num2str(data_j(l),'%d'));
%         voxel.setAttribute('x',num2str(xyz(l,1),'%0.2f'));
%         voxel.setAttribute('y',num2str(xyz(l,2),'%0.2f'));
%         voxel.setAttribute('z',num2str(xyz(l,3),'%0.2f'));
        voxel.setAttribute('val',num2str(data(l),'%0.2f'));
        voxels.appendChild(voxel);
    end
end

xmlwrite(xmlfile,docNode);

return