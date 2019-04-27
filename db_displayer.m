function [  ] = db_displayer( databasename )
    fd = imageSet(databasename, 'recursive');
    q = floor(size(fd, 2) / 3);
    r = rem(size(fd, 2), 3);
    if r == 0
        x = q;
    else
        x = q + 1;
    end
    figure;
    count = 1;
    for i=1:x-1
        for j = 1:3
            subplot(x, 3, count);
            imshow(read(fd(count), 1));
            title(fd(count).Description());
            count = count + 1;
        end
    end
    if r == 1
        subplot(x, 3, count+1);
        imshow(read(fd(count), 1));
        title(fd(count).Description());
    elseif r == 2
        subplot(x, 3, count);
        imshow(read(fd(count), 1));
        title(fd(count).Description());
        count = count + 1;
        subplot(x, 3, count+1);
        imshow(read(fd(count), 1));
        title(fd(count).Description());
    else
        subplot(x, 3, count);
        imshow(read(fd(count), 1));
        title(fd(count).Description());
        count = count + 1;
        subplot(x, 3, count);
        imshow(read(fd(count), 1));
        title(fd(count).Description());
        count = count + 1;
        subplot(x, 3, count);
        imshow(read(fd(count), 1));
        title(fd(count).Description());
    end
end