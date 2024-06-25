clc;clear;close all;

load('building_data.mat');

%%

ADJ={}; ficon_Adj={}; 
data = buildingdata.building10.rooms;

 for ri=4 %:length(rooms)
    
     nimg=data(ri).rgbimages;


for i=1:size(nimg,2)
  
  depthimg=data(ri).depthimages{i};

[h w]=size(depthimg);
meanDepth=depthimg(ceil(h/2),ceil(w/2));
meanDepth=double(meanDepth);%meanDepth=double(meanDepth/1000);


ADJi= data(ri).Adj_closestdistance_cntrd{1,i};

%%%Compute the normalized adjacency matrix
normalizedAdj = ADJi./meanDepth;
sav_normalizedAdj{i}=normalizedAdj;


buildingdata.building10.rooms(ri).normalizedAdj{i}=normalizedAdj;

end
 end


