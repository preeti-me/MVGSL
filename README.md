# An Indoor Scene Localization Method Using Graphical Summary of Multi-view RGB-D Images
This repository contains the code for paper "An Indoor Scene Localization Method Using Graphical Summary of Multi-view RGB-D Images"
The key contributions of the paper are: 
(i) Graphical summary generation from the multi-view RGB-D images of an indoor scene; (ii) Scene localization for an input query image through a graph summary matching approach. 

The framework for MVGSL comprising of two major stages, namely Graphical Summary Generation, and Scene Localization. 

![methoddiag-1](https://github.com/preeti-me/MVGSL/assets/80210264/c1ad2ad9-b25a-423b-a491-c3495fb06edb)
![methodlab-1](https://github.com/preeti-me/MVGSL/assets/80210264/e6ac61ff-d142-4458-b259-f43997f4287d)



## Dataset structure
The graph dataset https://drive.google.com/file/d/171YAnPZ1RESDE4o9kRyup_yLnT-xJ1eQ/view?usp=sharing is structured as follows:

```shell
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
   
## Content
SVG_cons: single-view graph construction\
MVG_cons: multi-view graph construction\
Matching: Scene localization\
calculateEdfm: Comput Essential matrix\
results folder contains the correspondence point to calculate E matrix.\
The output folder contains the images of the generated SVG and MVG.\
node2vec folder contains the embedding vectors for GT and query.

## Usage

## Refernces and Citations
If you use the source code, please cite the following paper

```bash
@inproceedings{song2015sun,
  title={Sun rgb-d: A rgb-d scene understanding benchmark suite},
  author={Song, Shuran and Lichtenberg, Samuel P and Xiao, Jianxiong},
  booktitle={CVPR},
  pages={567--576},
  year={2015}
}

@inproceedings{efe2021dfm,
  title={Dfm: A performance baseline for deep feature matching},
  author={Efe, Ufuk and Ince, Kutalmis Gokalp and Alatan, Aydin},
  booktitle={CVPR},
  pages={4284--4293},
  year={2021}
}

@inproceedings{grover2016node2vec,
  title={node2vec: Scalable feature learning for networks},
  author={Grover, Aditya and Leskovec, Jure},
  booktitle={Proceedings of the 22nd ACM SIGKDD international conference on Knowledge discovery and data mining},
  pages={855--864},
  year={2016}
}
