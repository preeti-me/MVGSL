function [E, inliers, status,R,t, T] = calculateEdfm(img1name,img2name,K)

%image1= rgb2gray(image1);
%image2= rgb2gray(image2);

folderPath='/home/vision/Desktop/new/graph/results/';

%fileName = sprintf('%d_%d_matches.mat', img1name, img2name);
fileName = sprintf('%s_%s_matches.mat', img1name{1}, img2name{1});

filePath = fullfile(folderPath, fileName);

% Check if the file exists
%if exist(filePath, 'file') == 2
    % File exists, load the data
    
dfmmatches = load(filePath);

features1 = dfmmatches.keypoints0;
features2 = dfmmatches.keypoints1;


indx = dfmmatches.matches;

indx1=indx(:,1);indx2=indx(:,2);

matchedPoints1= features1;%(indx1(:),:);

matchedPoints2 = features2;%(indx2,:);

%figure; showMatchedFeatures(image1,image2,matchedPoints1,matchedPoints2,'montage');
%title('Matches');

%%
%Essential matrix.
[E,inliers,status]= estimateEssentialMatrix(matchedPoints1,matchedPoints2,K,'MaxNumTrials', 5000, 'Confidence', 99.99);

%% 
[U,S,V] = svd(E);

diag_110 = [1 0 0; 0 1 0; 0 0 0]; %%to enforce rank 2 constraint
newE = U*diag_110*transpose(V);
[U,D,V] = svd(newE);
W = [0 -1 0; 1 0 0; 0 0 1];
R1 = U*W*V';        t1 = U(:,3);
R2 = U*W'*V';       t2 = -U(:,3);


%%
inlierPoints1 = matchedPoints1(inliers,:); inlierPoints2 = matchedPoints2(inliers,:);
%figure; showMatchedFeatures(image1, image2, inlierPoints1, inlierPoints2,'montage');

[E, inliers, status] = estimateEssentialMatrix(inlierPoints1, inlierPoints2, K, 'Confidence', 99);

% Display the Essential Matrix
disp('Estimated Essential Matrix:'); disp(E);

% Display the number of inliers
disp(['Number of inliers: ' num2str(sum(inliers))]);

if ~isempty(inlierPoints1)
[R, t] = relativeCameraPose(E, K, inlierPoints1, inlierPoints2);
 %R = relativeOrientation.Orientation; t = relativeLocation.Translation;

 T=zeros(4,4);
 T(4,4)=1;

T(1:3,4)=t(1,:)';
T(1:3,1:3)=R(:,:,1);

 %rt=[R t'];
%T = [rt; 0 0 0 1];
else
    R=[]; t=[];T=[];
end


%else
    % File does not exist, set r to an empty array
  %  R=[]; t=[];T=[];
%end

end