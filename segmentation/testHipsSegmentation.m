load matlabData;
basefolder = 'sacro/dataset/';
dataWithCanny = data;
for i = 1:numel(dataWithCanny)
    fPath = [basefolder, dataWithCanny{i}.accessNum];
    disp(fPath);
    hipsFile = [fPath '/segmentationWithCanny.mat'];
    if exist(fPath,'file') 
        display(fPath);

        if exist(hipsFile,'file') > 0
            display('Already segmented');
        %    continue;
        end
        filename = [basefolder, dataWithCanny{i}.accessNum];               
        tic; [ hipsSeg ] = segmentHipsAndSave(filename,'withCanny'); toc;
        hipsFile = [fPath '/segmentationWithCanny'];
        save(segFile, 'hipsSeg');
    end
end
