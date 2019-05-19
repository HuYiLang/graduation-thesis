%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%图像处理子程序
%作者：胡一浪
%功能：图片b按照sbw部分变白
%参数：b是原图，sbw是对照图；
%返回：周围区域变白的图片
%版本：5.1 2018/4/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function e=change_white(b,sbw)%根据sbw中的黑色区域，将彩色图像b中对应的区域变白，有利于灰度处理。
image_height=size(sbw,1);%size函数图像的高
image_width=size(sbw,2);%size函数图像的宽

for i = 1:image_height
    for j = 1:image_width
        if(sbw(i,j) == 0)
            b(i,j,1)=255;
            b(i,j,2)=255;
            b(i,j,3)=255;
        else
            break;
        end
    end
end

for i = image_height:-1:1
    for j = image_width:-1:1
        if(sbw(i,j) == 0)
            b(i,j,1)=255;
            b(i,j,2)=255;
            b(i,j,3)=255;
        else
            break;
        end
    end
end

e = b;

end
