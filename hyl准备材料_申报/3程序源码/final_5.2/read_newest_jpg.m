%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ͼ�����ӳ���
%���ߣ���һ��
%���ܣ����һ���������ɺ������Ч��ͼƬ
%�������ļ���·��
%���أ�һ��ͼ��
%�汾��5.1 2018/4/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% close all;
% clear;
% clc;
function newest_valid_img = read_newest_jpg(pathname)
filePattern = [pathname, '*.jpg']; 

dirOutput = dir(filePattern);
img_num = length(dirOutput);%��ȡͼ��������
image_name = '';
[~, ind] = sort([dirOutput(:).datenum], 'ascend');
dirOutput = dirOutput(ind);

for j = img_num:-1:1
    if dirOutput(j).bytes > 25000%25000����Ч��ͼ����ڴ��С
        image_name = dirOutput(j).name;% ͼ����
        break;
    end
end

newest_valid_img =  imread(strcat(pathname,image_name));
% figure;imshow(newest_valid_img);title('ԭʼͼ��');
