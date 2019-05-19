%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%图像处理子程序
%作者：胡一浪
%功能：生成用于匹配的图片
%参数：rgb是原图，deal_num：当前按照哪种方式识别：红，蓝，黄，BianYuan_rgb_qiege：切割闭操作的图像；
%返回：用于匹配的图片
%版本：5.1 2018/4/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function e = template_create(rgb,deal_num,BianYuan_rgb_qiege)

% %去除内部干扰,修正颜色
image_height=size(rgb,1);%size函数图像的高
image_width=size(rgb,2);%size函数图像的宽
if(deal_num == 3)           %红色
    for i = 1:image_height
        for j = 1:image_width
            if ((rgb(i,j,1) > 150 && rgb(i,j,1)<160 && rgb(i,j,2)>150&& rgb(i,j,2)<170&& rgb(i,j,3)>130&& rgb(i,j,3)<160)) || ((rgb(i,j,1) >= 0 && rgb(i,j,1)<50 && rgb(i,j,2)>30&& rgb(i,j,2)<100&& rgb(i,j,3)>100&& rgb(i,j,3)<200)) || (rgb(i,j,1) < 10 && rgb(i,j,2)>30&& rgb(i,j,2)<50&& rgb(i,j,3)>100&& rgb(i,j,3)<150 || ((rgb(i,j,1) > 5 && rgb(i,j,1)<50 && rgb(i,j,2)>20 && rgb(i,j,2)<60&& rgb(i,j,3)>80&& rgb(i,j,3)<160)))
                rgb(i,j,1)=255;
                rgb(i,j,2)=255;
                rgb(i,j,3)=255;
            end
        end
    end
end
if(deal_num == 2)       %蓝
    for i = 1:image_height
        for j = 1:image_width
            if (rgb(i,j,1) > 20)
                rgb(i,j,1)=255;
                rgb(i,j,2)=255;
                rgb(i,j,3)=255;
            end
        end
    end
end
% figure(6);
% subplot(4,2,1);imshow(rgb);title('1.原图');
b=rgb2gray(rgb);
% subplot(4,2,2); imshow(b);title('2.灰度');
I1=imbinarize(b,0.6);
%修正算法，针对图片灰度处理不好,图片全黑
[L,num_L]=bwlabeln(I1); %对连通对象的各个分离部分进行标注,L中包含了连通对象的标注。默认
sum_area = 0;
S=regionprops(L,'Area');
for i = 1:num_L
    sum_area = S(i).Area+sum_area;
end
sum_area = sum_area/(image_height*image_width);
if(sum_area <= 0.35)
%     msgbox(num2str(sum_area),'图片全黑');
%     fprintf('%s\n','图片全黑');
    I1=imbinarize(b,0.4);
end

[L,num_L]=bwlabeln(I1); %对连通对象的各个分离部分进行标注,L中包含了连通对象的标注。默认
sum_area = 0;
S=regionprops(L,'Area');
for i = 1:num_L
    sum_area = S(i).Area+sum_area;
end
sum_area = sum_area/(image_height*image_width);
if(sum_area <= 0.35)
%     msgbox(num2str(sum_area),'图片全黑');
%     fprintf('%s\n','图片仍然全黑');
    e = BianYuan_rgb_qiege;
    return;
end

% subplot(4,2,3);imshow(I1);title('3.二值化');

I1=~I1;
% subplot(4,2,4);imshow(I1);title('4.反色');

if(deal_num == 3)
	I1=bwareaopen(I1,90);%从对象中移除面积小于2000的小对象
else
	I1=bwareaopen(I1,40);%从对象中移除面积小于2000的小对象
end
% subplot(4,2,5);imshow(I1),title('5.移除面积小于90');
I1=qiege(I1);

I1=imresize(I1,[60 60]);
% subplot(4,2,6);imshow(I1);title('6.归一化');

e = I1;

end
