%clc;clear;close all;

load('building_data.mat');

%%

ADJ={}; ficon_Adj={}; 
data = buildingdata.building10.rooms;

 for ri=4 %:length(rooms)
    
     nimg=data(ri).rgbimages;


for i=1:length(nimg)
  
  depthimg=data(ri).depthimages{i};

[h w]=size(depthimg);
meanDepth=depthimg(ceil(h/2),ceil(w/2));
meanDepth=double(meanDepth);%meanDepth=double(meanDepth/1000);


ADJi= buildingdata.building10.rooms.Adj_closestdistance_cntrd{1,i};

Compute the normalized adjacency matrix
normalizedAdj = ADJi./meanDepth;
normalizedlapl = eye(size(ADJi)) - invSqrtDegreeMatrix * ADJi * invSqrtDegreeMatrix;
sav_normalizedAdj{i}=normalizedAdj;


buildingdata.building10.rooms(ri).normalizedAdj{i}=normalizedAdj;

end
 end


