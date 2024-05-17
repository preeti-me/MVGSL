# Saliency-graph
This repo contains the data used in the paper, 


# Dataset structure
The graph dataset is structured as follows:

buildingdata
└── building1
    ├── name               # building name
    ├── rooms         
    │   ├── name               # rooms name ex: kitchen, bedroom
    │   ├── rgbimages          # color images
    │   ├── depthimages        # depth images
    │   ├── salientobjects     # salient objects properties
    │       ├── labels     
    │       ├── Volume
    │       ├── centroid
    │       ├── corners    
    │       ├── orientation  
    │       └── objectPointClouds 
    │   ├── adjacency matrix
    │   └── saliency graph     # graph consists of salient objects as nodes and adjacency matrix
└── ...
	
