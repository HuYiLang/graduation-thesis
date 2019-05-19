%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%图像处理子程序
%作者：胡一浪
%功能：输出一张最新生成合理的有效的图片
%参数：文件夹路径
%返回：一张图像
%版本：5.1 2018/4/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% close all;
% clear;
% clc;
function newest_valid_img = read_newest_jpg(pathname)
filePattern = [pathname, '*.jpg']; 

dirOutput = dir(filePattern);
img_num = length(dirOutput);%获取图像总数量
image_name = '';
[~, ind] = sort([dirOutput(:).datenum], 'ascend');
dirOutput = dirOutput(ind);

for j = img_num:-1:1
    if dirOutput(j).bytes > 25000%25000是有效的图像的内存大小
        image_name = dirOutput(j).name;% 图像名
        break;
    end
end

newest_valid_img =  imread(strcat(pathname,image_name));
% figure;imshow(newest_valid_img);title('原始图像');
