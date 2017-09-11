%% Tymothy Anderson
% CEC495a
% Assignment 01 - Tracking Moving Objects

% This script will use basic computer vision techniques like mathematical
% morphology to track a moving object and plot its trajectory.

% Load Sequential Images
close all; clear all; clc;

StartingFrame = 1;
EndingFrame = 448;

Xcentroid = [ ];
Ycentroid = [ ];

for k = StartingFrame : EndingFrame-1
    % Load and convert sequential test images
    pos1 = imread(['ant/img',sprintf('%2.3d',k),'.jpg']);
    pos1orig = imread(['ant/img',sprintf('%2.3d',k),'.jpg']);
    pos2 = imread(['ant/img',sprintf('%2.3d',k+1),'.jpg']);

    pos1 = rgb2hsv(pos1);
    pos1sub = pos1(:,:,3);

    pos2 = rgb2hsv(pos2);
    pos2sub = pos2(:,:,3);

    % Implement Frame Differencing and Threshold
    diff1 = abs(pos1sub - pos2sub);
    
    thresh = .035;
    Ithresh = diff1 > thresh;

    % Morphology to Reduce Noise
    SE = strel('disk',2,0);
    Iopen = imopen(Ithresh,SE);
    SE = strel('disk',2,0);
    BW = imclose(Iopen,SE);
    imshow(pos1orig);
    
    % Labeling and Counting Objects
    [labels,number] = bwlabel(BW,8);
    
    if number > 0
        % Extract Stats
        Istats = regionprops(labels,'basic','Centroid');
        [maxVal, maxIndex] = max([Istats.Area]);

        % Plot Centroid
        hold on;
        plot(Istats(maxIndex).Centroid(1), Istats(maxIndex).Centroid(2),'r*');
        
        Xcentroid = [Xcentroid Istats(maxIndex).Centroid(1)];
        Ycentroid = [Ycentroid Istats(maxIndex).Centroid(2)];
        
        plot(Xcentroid,Ycentroid,'g-');
        
    end
    pause(0.001);
end