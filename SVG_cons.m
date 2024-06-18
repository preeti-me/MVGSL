clc;clear;close all;

addpath('/home/vision/Desktop/new/graph/SUNRGBDtoolbox/SUNRGBDtoolbox/')
addpath('/home/vision/Desktop/new/graph/SUNRGBDtoolbox/SUNRGBDtoolbox/n/fs/sun3d/data/SUNRGBD/kv1/NYUdata/')

load('building_data.mat');



buildingNumber=2; 

fieldName = sprintf('building%d', buildingNumber);

%queryadj=eval(['buildingdata.' fieldName '.rooms(ri).bin_normalizedAdj{1,view}']);
%%


rooms=eval(['buildingdata.' fieldName '.rooms']);

 for ri=6%1:length(rooms)
    
     roomno= eval(['buildingdata.' fieldName '.rooms(ri)']);

for i=1:length(roomno.salientobjects)

    depthimg=roomno.depthimages{i};
   [h w]=size(depthimg);
   meanDepth=depthimg(ceil(h/2),ceil(w/2));
   meanDepth=double(meanDepth);%meanDepth=double(meanDepth/1000);

    for j=1:length(roomno.salientobjects{1,i})

    imgno= roomno.salientobjects{1,i}(j).corners;

    bx= max(imgno(:,1))-min(imgno(:,1));
    by= max(imgno(:,2))-min(imgno(:,2));  bz= max(imgno(:,3))-min(imgno(:,3));
 
   bx=bx/meanDepth; by=by/meanDepth; bz=bz/meanDepth;
  
    dim = [bx,by,bz]; l=max(dim);

   roomno.salientobjects{1,i}(j).maxlength=l;
    end

   normalizedAdj=roomno.normalizedAdj{i};
%%
   numObjects=size(normalizedAdj,2);
  newadjacencyMatrix = zeros(numObjects); distanceThreshold=0.17;

distances = normalizedAdj; 

% Construct adjacency matrix based on distance threshold
for oi = 1:numObjects
    for oj = i+1:numObjects

        li=roomno.salientobjects{1,i}(oi).maxlength;
        lj= roomno.salientobjects{1,i}(oj).maxlength;
        
        dij=distances(oi, oj);

        %if dij <= distanceThreshold 
            if min(li,lj)>dij
               
            newadjacencyMatrix(oi, oj) = 1;
            newadjacencyMatrix(oj, oi) = 1;
            end
        %end
    end
end


%buildingdata.building2.rooms(ri).newadjacencyMatrix{i}= newadjacencyMatrix;


%%
end

 end

%%

