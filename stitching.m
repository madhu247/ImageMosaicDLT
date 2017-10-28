% Test Stitching
% Author    : Madhu Chegondi
% Date      : 10/25/2017

% Reading Images and resizing them to 20 percent of the original image
% as they are HD and are occupying lot of memory power
img1 = imread('left.jpg');
img2 = imread('right.jpg');
img1 = imresize(img1, 0.2);
img2 = imresize(img2, 0.2);

% Collect points from the given images
imshow(img1), [x1, y1] = ginput(4);
imshow(img2), [x2, y2] = ginput(4);
% Store the points in two matrices to pass them to DLT
p1 = []; p2 = [];
for i=1:4
    p1 = [p1; x1(i), y1(i)];
    p2 = [p2; x2(i), y2(i)];
end

% Computing homographic transformation using DLT algorithm
H = DLT(p1', p2');