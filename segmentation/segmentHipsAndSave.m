function [ hipsSeg ] = segmentHipsAndSave( fPath, outfile )
%SEGMENTHIPSANDSAVE a function for debugging the first part of the
%segmentation process.
%   segments the hips part of the skeleton and saves it.
[basefolder, folder] = fileparts(fPath);
if exist([fPath,'/',folder,'.mat'],'file')
    load([fPath,'/',folder,'.mat'])
else
    dicomInfo = dicom_folder_info(fPath);
    vol = dicom_read_volume(fPath);
end
slices = size(vol,3); display(slices);
vol = dicom2niftiVol(vol, dicomInfo);
bonesSeg = getBones(vol, 0);
hipsSeg = getHips(bonesSeg, 0, vol); clearvars bonesSeg;
if exist('outfile','var')
    close all;
    try
        picsSeries(hipsSeg, vol, [basefolder, '/', folder, '_', outfile, 'Hips.jpg']);
    catch
        display('Problem showing the images');
    end
end

end

