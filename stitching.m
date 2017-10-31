% Test Stitching
% Author    : Madhu Chegondi
% Date      : 10/25/2017

% Load input Images
img1 = double(imread('stitch1.png'));
img2 = double(imread('stitch2.png'));
[h1, w1, d1] = size(img1);
[h2, w2, d2] = size(img2);

% Collect points from the given images
imshow(img1/255), [x1, y1] = ginput(4);
imshow(img2/255), [x2, y2] = ginput(4);

% Store the points in two matrices and 
% pass them to DLT to compute Homogra-
% phic transformation matrix H
p1 = []; p2 = [];
for i=1:4
    p1 = [p1; x1(i), y1(i)];
    p2 = [p2; x2(i), y2(i)];
end

% append two Images to show correspo-
% nding points on both images 
img3 = appendImages(img1, img2);
image(img3/255);
hold on;
cols = size(img1,2);
for i = 1:4
    line([p1(i,1) p2(i,1)+cols],... 
    [p1(i,2) p2(i,2)], 'Color', 'c');
end
hold off;

% Computing homographic transformation
% using DLT algorithm
H = DLT(p1', p2');

% Warp corners to determine the 
% size of output image
cp = H \ [1 1 w2 w2;...
    1 h2 1 h2; 1 1 1 1];

Xpr = min([cp(1,:)./cp(3,:) 0]):...
    max([cp(1,:)./cp(3,:) w1]);
Ypr = min([cp(2,:)./cp(3,:) 0]):...
    max([cp(2,:)./cp(3,:) h1]);
[Xp, Yp] = ndgrid(Xpr,Ypr);
[wp, hp] = size(Xp); 

% Transform Img2
X = H*[Xp(:) Yp(:) ones(wp*hp,1)]';

% re-sample pixel values with linear 
% interpolation
clear Ip;
xI = reshape( X(1,:)./X(3,:),wp,hp)';
yI = reshape( X(2,:)./X(3,:),wp,hp)';
for i=1:3
    Ip(:,:,i) =...
    interp2(img2(:,:,i), xI, yI, 'linear');
end

% offset and copy original image
% into the warped image
offset =...
    -round([min([cp(1,:)./cp(3,:) 0])...
    min([cp(2,:)./cp(3,:) 0])]);
Ip(1+offset(2):h1+offset(2),...
    1+offset(1):w1+offset(1),:)...
    = double(img1(1:h1,1:w1,:));

% show the result
imshow(Ip/255); axis image;
title('mosaic image');
