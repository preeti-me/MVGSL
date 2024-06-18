clc;clear;close all;

load('building_data.mat');


buildingNumber=1; 

fieldName = sprintf('building%d', buildingNumber);

%%

rooms=eval(['buildingdata.' fieldName '.rooms']);

 for ri=2%1:length(rooms)
    
     roomno= eval(['buildingdata.' fieldName '.rooms(ri)']);

for i=1 %1:length(roomno.salientobjects)

    depthimg=roomno.depthimages{i};
   [h w]=size(depthimg);
   meanDepth=depthimg(ceil(h/2),ceil(w/2));
   meanDepth=double(meanDepth);
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    a=buildingdata.building1.rooms(ri).salientobjects{i};

  for sj=1:length(a)
  labels{1,sj}=a(sj).labels;
  end


  unique_labels = {};
for ii = 1:numel(labels)
    if sum(strcmp(unique_labels, labels{ii})) == 0
        % If the label is not already in the list of unique labels, add it
        unique_labels{end+1} = labels{ii};
    else
        % If the label is already in the list of unique labels, add a unique identifier
        jj = 1;
        new_label = sprintf('%s_%d', labels{ii}, jj);
        while sum(strcmp(unique_labels, new_label)) > 0
            jj = jj + 1;
            new_label = sprintf('%s_%d', labels{ii}, jj);
        end
        unique_labels{end+1} = new_label;
    end
end

uninodes = unique_labels;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


n = size(newadjacencyMatrix, 1); %size of the matrix

newadjacencyMatrix(1:n+1:end) = 0; %Set diagonal elements to zero

%buildingdata.building2.rooms(ri).newadjacencyMatrix{i}= newadjacencyMatrix;
SVG=graph(newadjacencyMatrix,uninodes);
figure; plot(SVG);


end

 end



