%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%图像处理子程序
%作者：胡一浪
%功能：模板匹配
%参数：rgb是原图，deal_num：当前按照哪种方式识别：红，蓝，黄，BianYuan_rgb_qiege：切割闭操作的图像；
%返回：匹配的模板和模板名
%版本：5.1 2018/4/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [return_template_image,identify_name]= template_matching(src)%flag_result识别结果

src=imresize(src,[60 60]);

file_path =  '.\binaryzation_image_template\';% 图像文件夹路径  
img_path_list = dir(strcat(file_path,'*.jpg'));%获取该文件夹中所有jpg格式的图像  
img_num = length(img_path_list);%获取图像总数量  
if img_num > 0 %有满足条件的图像  
        for j = 1:img_num %逐一读取图像  
            image_name = img_path_list(j).name;% 图像名  
            image =  imread(strcat(file_path,image_name));
            temp = 0;
            image_height=size(image,1);%size函数图像的高
            image_width=size(image,2);%size函数图像的宽
            for image_height_temp=1:image_height %图像高度
                  for image_width_temp=1:image_width   %图像宽度
                        if(src(image_height_temp,image_width_temp) - image(image_height_temp,image_width_temp) == 0)
                            temp = temp + 1;
                        end
                  end
            end 
%             fprintf('%s %d %s\n',image_name,j,num2str(temp/(image_height * image_height)));% 显示正在处理的图像名
            if(temp/(image_height * image_height) > 0.821)
                return_template_image = image;
                s = regexp(image_name,'\.','split');%读到的文件是xx.bmp，把bmp去掉
                identify_name = char(s(1));
                %写入文件
%                 filename = fopen('C:\Users\HYL\Desktop\identify_result.txt','wt');
%                 fprintf(filename,'%s\n',identify_name);
%                 fclose(filename);
                return;
            end             
        end
        identify_name = '未识别';
        return_template_image = imread('unidentification.jpg');
        imwrite(src,strcat(datestr(now,'HHMMSS'),'.jpg'),'bmp');%保存未识别的图像
else
    identify_name = '模板库没有.jpg模板';
    return_template_image = imread('unidentification.jpg');
end