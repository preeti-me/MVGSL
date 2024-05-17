# Saliency-graph
This repo contains the data used in the paper, 


# Dataset structure
The graph dataset is structured as follows:

<!...![image](https://github.com/preeti-me/Saliency-graph/assets/80210264/8d505a48-4c27-4f8c-b7f0-81fbb6dadde7) ...>

```bash
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
