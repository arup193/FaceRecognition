function [ faceclassifier ] = datasetprovider( databasename )
    fd = imageSet(databasename, 'recursive');
    trainingset = fd;
    sz = size(extractHOGFeatures(read(trainingset(1),1)), 2);
    trainfeat = zeros(size(trainingset, 2)*trainingset(1).Count, sz);
    featcount = 1;
    for i=1:size(trainingset, 2)
        for j=1:trainingset(i).Count
            trainfeat(featcount,:) = extractHOGFeatures(read(trainingset(i),j));
            trainlabel{featcount} = trainingset(i).Description();
            featcount = featcount + 1;
        end
    end
    faceclassifier = fitcecoc(trainfeat, trainlabel);
end