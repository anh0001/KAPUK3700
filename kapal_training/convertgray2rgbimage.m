imgDir = 'img/';
listfiles = dir(fullfile(imgDir, '*.jpg'));
numfiles = numel(listfiles);
for i=1:numfiles
    im = imread(fullfile(imgDir, listfiles(i).name));
    fprintf('Checking %s\n', fullfile(imgDir, listfiles(i).name));
%     assert(size(im,3)==3, 'Must be RGB color');
    if(size(im,3) ~= 3)
        fprintf('Converting [%d,%d] to RGB color image...\n', size(im,1), size(im,2));
        im = cat(3,im,im,im);
        imwrite(im, fullfile(imgDir, listfiles(i).name));
    end
end