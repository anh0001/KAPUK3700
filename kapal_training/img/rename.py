import glob
import os

dirpath = r'/'
dirname = os.path.basename(dirpath)

filepath_list = glob.glob(os.path.join(dirpath, 'pic *.jpg'))
pad = len(str(len(filepath_list)))
for n, filepath in enumerate(filepath_list, 1):
    os.rename(
        filepath,
        os.path.join(dirpath, 'picture {:>0{}}.jpg'.format(n, pad))
    )
