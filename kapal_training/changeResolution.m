% This tool resize images which are higher than 400x600,
% and change its ground truth as well.
clearvars

imgDir = 'img/';
listfiles = dir(fullfile(imgDir, '*.jpg'));
numfiles = numel(listfiles);
load('groundtruth_rect.mat','gTruth');
assert(isempty(gTruth) ~= 1, ['No initial position or ground truth to load.']);

gtRect = gTruth.LabelData.puing;
for i=1:numfiles
    im = imread(fullfile(imgDir, listfiles(i).name));
    im_size_old = size(im);
    fprintf('Checking %s\n', fullfile(imgDir, listfiles(i).name));
%     assert(size(im,3)==3, 'Must be RGB color');

    if(im_size_old(1) > 400 || im_size_old(2) > 600)
        fprintf('Converting [%d,%d] to ', im_size_old(1), im_size_old(2));
        if(im_size_old(2) > 600)
            im = imresize(im, [NaN 600]);
        else
            im = imresize(im, [400 NaN]);
        end
        im_size_new = size(im);
        fprintf('[%d,%d] image\n', im_size_new(1), im_size_new(2));
        assert( ~isempty(gtRect{i}), sprintf('Found empty ground truth %s', listfiles(i).name));
        
        if ~isempty(gtRect{i})
            % change the ground truth as well
            index = cellfun(@(x) contains(x,['/' listfiles(i).name]), gTruth.DataSource.Source);
            assert( sum(index)==1, 'Filename must exist for a single file')
            hor_ratio = double(im_size_new(2) / im_size_old(2));
            vert_ratio = double(im_size_new(1) / im_size_old(1));
            new_gtRect = gtRect{i} .* repmat([hor_ratio vert_ratio hor_ratio vert_ratio], size(gtRect{i},1), 1);
            gtRect{i} = new_gtRect;

            % sanity check
            figure(1)
            imshow(im);
            hold on
                for ii=1:size(new_gtRect,1)
                    rectangle('Position',new_gtRect(ii,:),'EdgeColor','r');
                end
            hold off
        end
    end
    
    % save broken header image or resized image
    imwrite(im, fullfile(imgDir, listfiles(i).name));
end

labelData = table(gtRect, 'VariableNames', gTruth.LabelData.Properties.VariableNames);
gTruth = groundTruth(gTruth.DataSource, gTruth.LabelDefinitions, labelData);
fprintf('Save to groundtruth_rect.mat.\n');
save('groundtruth_rect.mat', 'gTruth');