function [  ] = recognizer( faceclass )
    faceDetector = vision.CascadeObjectDetector('FrontalFaceCART', 'MinSize', [150 150]);
    pointTracker = vision.PointTracker('MaxBidirectionalError', 2);
    cam = webcam();
    videoFrame = snapshot(cam);
    frameSize = size(videoFrame);
    videoPlayer = vision.VideoPlayer('Position', [100 100 [frameSize(2), frameSize(1)]+30]);
    runLoop = true;
    numPts = 0;
    frameCount = 1;
    personlabel = 'PROCESSING';

while runLoop && frameCount < 100
        videoFrame = snapshot(cam);
        videoFrameGray = rgb2gray(videoFrame);

        bbox = faceDetector.step(videoFrameGray);

        if ~isempty(bbox)
            % Find corner points inside the detected region.
            points = detectMinEigenFeatures(videoFrameGray, 'ROI', bbox(1, :));

            % Re-initialize the point tracker.
            xyPoints = points.Location;
            numPts = size(xyPoints,1);
            release(pointTracker);
            initialize(pointTracker, xyPoints, videoFrameGray);

            % Save a copy of the points.
            oldPoints = xyPoints;

            % Convert the rectangle represented as [x, y, w, h] into an
            % M-by-2 matrix of [x,y] coordinates of the four corners. This
            % is needed to be able to transform the bounding box to display
            % the orientation of the face.
            bboxPoints = bbox2points(bbox(1, :));

            % Convert the box corners into the [x1 y1 x2 y2 x3 y3 x4 y4]
            % format required by insertShape.
            bboxPolygon = reshape(bboxPoints', 1, []);

            % Display a bounding box around the detected face.
            videoFrame = insertShape(videoFrame, 'Polygon', bboxPolygon, 'LineWidth', 3);
            try
                newimg = imcrop(videoFrameGray, bbox);
                scalefactor = 150/size(newimg, 1);
                newimg = imresize(newimg, scalefactor);
                queryfeat = extractHOGFeatures(newimg);
                personlabel = predict(faceclass, queryfeat);
            catch
            end

            % Display detected corners.
            % videoFrame = insertMarker(videoFrame, xyPoints, '+', 'Color', 'white');
        end

    videoFrame = flip(videoFrame ,2);
    videoFrame = insertText(videoFrame, [1 1], personlabel);
    % Display the annotated video frame using the video player object.
    step(videoPlayer, videoFrame);
    personlabel = 'PROCESSING';

    % Check whether the video player window has been closed.
    runLoop = isOpen(videoPlayer);
end

% Clean up.
clear cam;
release(videoPlayer);
release(pointTracker);
release(faceDetector);
end