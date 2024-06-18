# An Indoor Scene Localization Method Using Graphical Summary of Multi-view RGB-D Images
This repo contains the implementation of (i) Graphical summary generation from the multi-view RGB-D images of an indoor scene; (ii) Scene localization for an input query image through a graph summary matching approach. 

# Dataset structure
The graph dataset https://drive.google.com/file/d/171YAnPZ1RESDE4o9kRyup_yLnT-xJ1eQ/view?usp=sharing is structured as follows:

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
Also, download 
You can download the SUNRGBD data from https://rgbd.cs.princeton.edu/
   
# Code
SVG_cons: single-view graph construction\
MVG_cons: multi-view graph construction\
Matching: Scene localization


# Refernces
```bash
@inproceedings{song2015sun,
  title={Sun rgb-d: A rgb-d scene understanding benchmark suite},
  author={Song, Shuran and Lichtenberg, Samuel P and Xiao, Jianxiong},
  booktitle={CVPR},
  pages={567--576},
  year={2015}
}

