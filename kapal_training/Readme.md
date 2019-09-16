The folder img_ori and groundtruth_rect_ori.mat are the initial images and ground truth.
Due to color domain and labeling issues of MATLAB, we convert the dataset using convertgray2rgbimage.m and reduce the resolution using changeResolution.m.

Color domain issue is caused by some images are in greyscale, and in colormap images.
While labeling issue is due to missing ground truth box, and broken images header.
