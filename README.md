# An Indoor Scene Localization Method Using Graphical Summary of Multi-view RGB-D Images
This repo contains the implementation of (i) Graphical summary generation from the multi-view RGB-D images of an indoor scene; (ii) Scene localization for an input query image through a graph summary matching approach. 

# Dataset structure
The graph dataset is structured as follows:

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
    │   ├── newadjacencyMatrix  %graph adjacency matrix
    │   ├── comp_adj  %complement of an adjacency matrix
    │   └── comp_graph     # graph consists of salient objects as nodes and comp_adj
└── ...

```    
# Code
SVG_cons: single-view graph construction\
MVG_cons: multi-view graph construction\
Matching: Scene localization



