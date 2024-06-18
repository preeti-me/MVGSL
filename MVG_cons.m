clc;clear;close all;

addpath('/home/vision/Desktop/new/graph/SUNRGBDtoolbox/SUNRGBDtoolbox/')
addpath('/home/vision/Desktop/new/graph/SUNRGBDtoolbox/SUNRGBDtoolbox/n/fs/sun3d/data/SUNRGBD/kv1/NYUdata/')
addpath('/home/vision/Desktop/new/graph/results/')


load('SUNRGBDfullgraphdata.mat');
load('building_data.mat');

buildingNumber=1; 

fieldName = sprintf('building%d', buildingNumber);
k=1; ri=2;

for imageId = 28:29
data = SUNRGBDfullgraphdata(imageId);

folderpath='/home/vision/Desktop/new/SUNRGBD/kv1/NYUdata/';
%seqpath=data.sequenceName;

imgpth='/image/'; dpth='/depth/';
namer = data.rgbname; named= data.depthname;

[~,seqpath,~]=fileparts(namer);

data.rgbpath= fullfile(folderpath,seqpath,imgpth,namer);
data.depthpath = fullfile(folderpath,seqpath,dpth,named);

% [rgb,points3d,depthInpaint,imsize]=read3dPoints(data);

strings=data.rgbname;

imgname{k} = regexp(strings, '0*([1-9]\d*)', 'tokens', 'once');

G{k} = SUNRGBDfullgraphdata(imageId).salientobjects;
rgb{k}=imread(data.rgbpath);
%ADJ{k}= buildingdata.building6.rooms(ri).bin_normalizedAdj{1,k};
ADJ{k}=eval(['buildingdata.' fieldName '.rooms(ri).newadjacencyMatrix{1,k}']);
k=k+1;
end

num_graphs=length(G);
%%
all_adj_matrices={}; merged_graph=graph([],[]); all_nodeprop={}; labels={}; all_labels={};

for j=1:num_graphs

    nodeprop= G{j}; prop={};

    for i=1:length(G{j})

  prop{i,1}= nodeprop(i).labels;

%prop{i,2}= nodeprop(i).worldpts; %contains centroid & orientation
%prop{i,4}=  nodeprop(i).Volume;
prop{i,3}= nodeprop(i).objectPointClouds;
    end
    merge_nodeprop{j}=prop;
    
end

for k=1:num_graphs
all_labels = vertcat(all_labels,merge_nodeprop{1,k}); 
end
%merged_adj=zeros(length(all_labels),length(all_labels));

%%
%merge_nodeprop=[all_nodeprop,nodeprop];

mergedAdjMatrix = blkdiag(ADJ{:}); % Combine the matrices into a block diagonal matrix

unique_labels = {}; % Add unique identifier to labels that have the same name

for i = 1:num_graphs   
    for j = 1:size(G{i},2)
        a=G{i};
        mergenode= a(j).labels;

if sum(strcmp(unique_labels, mergenode)) == 0
        % If the label is not already in the list of unique labels, add it
        unique_labels{end+1} = mergenode;
    else
        % If the label is already in the list of unique labels, add a unique identifier
        rj = 1;
        new_label = sprintf('%s%d', mergenode, rj);
        while sum(strcmp(unique_labels, new_label)) > 0
            rj = rj + 1;
            new_label = sprintf('%s%d', mergenode, rj);
        end
        unique_labels{end+1} = new_label;
       mergenode=new_label;
end

        node_label = sprintf('%s-%d', mergenode, i);
        merged_graph = addnode(merged_graph, node_label);  % Add nodes to merged graph
    end
 end

 all_nodes=merged_graph.Nodes; nodeNames=table2cell(all_nodes);

%merged_graph = graph(mergedAdjMatrix, all_nodes);
%figure;plot(merged_graph,'Layout', 'layered');title('separate graphs of all views');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

for ii =1:num_graphs 
    str=G{ii};
  str_ini={};
    for jj = 1:length(str)
        
        str_name= str(jj).labels;
        str_co= str(jj).corners;
        str_c= str(jj).Volume;
        %str_c= str(jj).centroid;
        %str_comb=[str_c; str_co];
        str_comb=str(jj).objectPointClouds;

        str_ini(jj).name= str_name;
        str_ini(jj).cco= str_comb;
        str_ini(jj).vol= str_c;
    end
    ini_str{ii}=str_ini;
end
%%
K= SUNRGBDfullgraphdata.K; 
[ro co ch]=size(rgb{1});
cameraParams = cameraParameters("K",K, "ImageSize",[ro co]);

focalLength=cameraParams.FocalLength; principalPoint=cameraParams.PrincipalPoint;imageSize= cameraParams.ImageSize;
intrinsics = cameraIntrinsics(focalLength,principalPoint,imageSize);

mv_adj={};

for ki = 1:num_graphs
    for  kj = ki+1:num_graphs
        
        distance=zeros(length(ini_str{ki}),length(ini_str{kj}));

        %[E, inliers, status, R, t, T] = calculateE(rgb{ki}, rgb{kj},cameraParams); 
        
        %image1=rgb{1};image2=rgb{2};
        [E, inliers, status, R, t, T] = calculateEdfm(imgname{ki},imgname{kj},cameraParams); 
         
        %if ~isempty(E) || size(inliers,1)~=0
         %if ~isempty(E)  % Check if E matrix is valid
        if size(inliers,1)~=0
         p1_transformed=[];

      for ci=1:length(ini_str{ki})   
       p1=ini_str{ki}(ci).cco;
       p1=[p1 ones(length(p1),1)];

       if ~isempty(T)
        p1_transformed=T*[p1]';
        p1_transformed=p1_transformed';

       else
           p1_transformed=p1;
       end
       
        p1_transformed=p1_transformed(:,1:3);

    
        ini_str{ki}(ci).trancco= p1_transformed;

        for cj=1:length(ini_str{kj})
            
             p2=ini_str{kj}(cj).cco;
%%
             % Compute pairwise distances
              distances1to2 = pdist2(p1_transformed, p2);

              % Compute chamfer distance
             chamferDist1to2 = sum(min(distances1to2, [], 2)); %extract min in each row then sum them

             normali=length(min(distances1to2, [], 2)); %+length(min(distances1to2, [], 1));

             chamferDist1to2=chamferDist1to2/normali;
             distance(ci,cj) = chamferDist1to2;
%%
            vol1= ini_str{ki}(ci).vol; vol2=ini_str{kj}(cj).vol; 
            volweight(ci,cj) = sqrt(vol1*vol2);


        end
      end
         
     mv_adj{ki,kj}=distance;
     
     distances=distance;
            distanceThreshold=2.04;

      for mei=1:length(distances(:,1))
      for mej=1:length(distances(1,:))

   if distances(mei,mej)>distanceThreshold
     distances(mei,mej)=0;
   else
       distances(mei,mej)=1;
   end
  end
      end

 mv_adj{ki,kj}=distances;


        end
    end
end
 


%%
%all_nodes=merged_graph.Nodes; nodeNames=table2cell(all_nodes);

for gi=1:length(mv_adj(:,1))

    mv_adj{gi,gi}=ADJ{gi};

for gj=1:length(mv_adj(1,:))

   if isempty(mv_adj{gi,gj})
    
    mv_adj{gi,gj}=zeros(length(G{gi}), length(G{gj}));
   end

    v=horzcat(mv_adj(gi,:));
 
    v1{gi}=cell2mat(v);

%newmergedAdjMatrix(1:length(G{gi}),length(G{gi})+1:length(G{gi})+length(G{2}))=mv_adj{1,2};

end
end

for gi=num_graphs

    mv_adj{gi,gi}=ADJ{gi};

 for gj=1:num_graphs-1

    mv_adj{gi,gj}=zeros(length(G{gi}),length(G{gj}));%mv_adj{gj,gi};

 end
 
 v=horzcat(mv_adj(gi,:));
 v1{gi}=cell2mat(v);
end


%%
newmergedAdjMatrix=vertcat(v1{:}); newmergedAdjMatrixsym=newmergedAdjMatrix;


newmerged_graph = graph(newmergedAdjMatrixsym, all_nodes,'upper');

%figure;plot(newmerged_graph,'Layout', 'layered');title('newmerged graph');
%figure;plot(newmerged_graph);title('newmerged graph');

startIdx = 1;

for gri=1:length(G)

    graphLength = length(G{gri});

    rowlength = startIdx + graphLength-1;

for meii = startIdx:rowlength %length(newmergedAdjMatrix)

    dist_possiblemergeobj=[]; possiblemergeobj=[];
    
    
    % Extract non-zero values for the current graph
    nonZeroValues = find(newmergedAdjMatrixsym(meii,:)~=0);
    a= nonZeroValues > (startIdx + graphLength-1);
 
    indxn= nonZeroValues(a);

    moi=all_labels(meii,1); moj=all_labels(indxn,1);

   commonObjects = intersect(moi,moj);  %commonobj=find(strcmp(moi,moj));

   if ~isempty(commonObjects)
   idxcommon = find(ismember(moj, commonObjects));
   columnno= indxn(idxcommon);

   for posi=1:length(columnno)
   possiblemergeobj(posi,:)=[meii,columnno(posi)];
   end

  for posii=1:length(possiblemergeobj(:,1))
   dist_possiblemergeobj(posii,:) = newmergedAdjMatrixsym(possiblemergeobj(posii,1),possiblemergeobj(posii,2));
  end

  min_dist_possiblemergeobj=min(dist_possiblemergeobj);

  piio=find(dist_possiblemergeobj==min_dist_possiblemergeobj);

   finalmergeobj= possiblemergeobj(piio,:);

  newmergedAdjMatrixsym(finalmergeobj(1),finalmergeobj(2))= 999;
 
   end
end
% Update the starting index for the next graph
startIdx = startIdx + graphLength;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


 %%
 originalLabels= table2cell(all_nodes);
 newLabels = originalLabels; 
% Create a new adjacency matrix for the merged graph
mergedMatrix1 = newmergedAdjMatrixsym;

[merger, mergec]=find(newmergedAdjMatrixsym==999);

mergeRow=merger; mergeCol=mergec;

% Iterate through the merged indices and update the new matrix
for i = 1:length(mergeRow)
    row = mergeRow(i);
    col = mergeCol(i);
    
   %if strcmp(all_labels{row,1},all_labels{col,1})==1

    % Update node labels by merging them
    newLabel = strcat(originalLabels{row}, '_', originalLabels{col});
    newLabels{row} = newLabel;
    
    % Set the merged object's column to an empty string
    newLabels{col} = '';
    
    % Set the merged object's row and column to zero in the matrix
    mergedMatrix1(row, :) = mergedMatrix1(row, :) + mergedMatrix1(col, :);
    mergedMatrix1(:, row) = mergedMatrix1(:, row) + mergedMatrix1(:, col);
    mergedMatrix1(row, row) = 0; % Set the diagonal entry to 0 to avoid self-loops
    
    % Set the merged object's column to zero
     mergedMatrix1(:, col) = 0;
    mergedMatrix1(col, :) = 0;
      %mergedMatrix1(:, col) = mergedMatrix1(col, :) + mergedMatrix1(row, :);
      
   %end
end

% Remove the merged objects (rows and columns with all zeros)
mergedMatrix1(all(mergedMatrix1 == 0, 2), :) = [];
mergedMatrix1(:, all(mergedMatrix1 == 0, 1)) = [];

% Remove empty strings from node labels
newLabels = newLabels(~cellfun('isempty', newLabels));
    

%disp('Original Adjacency Matrix:'); disp(combinedMatrix);%disp('Merged Adjacency Matrix:'); disp(mergedMatrix1);

disp('New Node Labels:'); disp(newLabels);

%%
% Remove the number after "-" and replace '_' and '-' with '_'
%cleanedNames = regexprep(newLabels, '-\d|_|-', '');
cleanedNames = regexprep(newLabels, '-\d*|_', '');
disp(cleanedNames);

%%
%G_final = digraph(triu(mergedMatrix1)); 
%figure;plot(G_final,'Marker', 'o', 'MarkerSize',8,'Layout', 'force','NodeColor','red', 'ArrowSize', 12,'LineWidth',2);

%mergedMatrix1(1,12)=1; %mergedMatrix1=[mergedMatrix1; zeros(1,12)];

finalmerged_graph = graph(mergedMatrix1, cleanedNames,'lower');

%figure;plot(newmerged_graph,'Layout', 'layered');title('newmerged graph'); %figure;plot(finalmerged_graph);title('final merged graph');

%%%%%%%%%%%%%%%%%%assign_edge_weights%%%%%%%%%%%%%
for nwi=1:length(cleanedNames)

newobj=newLabels(nwi); cmplabf={};

% Extract numeric part after "-"
numericParts = cellfun(@(x) str2double(regexp(x, '-(\d+)', 'tokens', 'once')), newobj);

% Extract string part (e.g., "chair")
stringParts = cellfun(@(x) regexprep(x, '-\d.*|_', ''), newobj, 'UniformOutput', false);

possiview= ini_str{numericParts};

cmplabf={possiview.name};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ncmplabf={};
for i = 1:numel(cmplabf)
    currentLabel = cmplabf{i};
    
  if sum(strcmp(ncmplabf, currentLabel)) == 0
       ncmplabf{end+1} = currentLabel;
  else
       ncj = 1;
        nelabel = sprintf('%s%d', currentLabel, ncj);
        while sum(strcmp(ncmplabf, nelabel)) > 0
            ncj = ncj + 1;
            nelabel = sprintf('%s%d', currentLabel, ncj);
        end
        ncmplabf{end+1} = nelabel;
  end  
end
newcmplabf=ncmplabf;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%if strcmp(stringParts,cmplabf)
ing = find(strcmp(stringParts,newcmplabf));

if ~isempty(ing)
finalmerged_graph.Nodes.vol(nwi,:)= possiview(ing(1)).vol;

end

end


for aii=1:length(mergedMatrix1)
    for ajj= 1:length(mergedMatrix1)


        if mergedMatrix1(aii,ajj)==1
          vo1= finalmerged_graph.Nodes.vol(aii,:); vo2= finalmerged_graph.Nodes.vol(ajj,:);
          fmergedMatrix1(aii,ajj)=  sqrt(vo1*vo2); %max(vo1,vo2);
          fmergedMatrix1(ajj,aii)= sqrt(vo1*vo2); %max(vo1,vo2); %
          fmergedMatrix1(ajj,ajj)=0;fmergedMatrix1(aii,aii)=0;
        end

    end
end

newfinalmerged_graph= graph(fmergedMatrix1, cleanedNames,'lower');

%new1finalmerged_graph=graph([],[]);
%new1finalmerged_graph.Edges.maxweight= newfinalmerged_graph.Edges.Weight;

%finalmerged_graph.Edges=[];
newfinalmerged_graph.Nodes.vol(:)= finalmerged_graph.Nodes.vol(:);
%%

plot(newfinalmerged_graph, 'LineWidth', 3, 'NodeFontSize', 18,'EdgeLabel', round(newfinalmerged_graph.Edges.Weight, 2),'EdgeFontSize',14,'MarkerSize',8,'NodeColor',[1,0.41,0.16],'EdgeColor',[0,0,1]);
