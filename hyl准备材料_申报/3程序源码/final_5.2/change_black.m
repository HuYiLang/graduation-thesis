%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%图像处理子程序
%作者：胡一浪
%功能：图片指定矩形区域变黑
%参数：有效合理图片和x,y表示起点，x_width,y_width表示范围[x起点，y起点，x宽度，y宽度]；
%返回：变黑图片
%版本：5.1 2018/4/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function e=change_black(sbw,x,y,x_width,y_width)
x = floor(x);%向下取整
y = floor(y);

for i = x:x+x_width+1
    for j = y:y+y_width+1
        sbw(j,i) = 0;
    end
end
e = sbw;