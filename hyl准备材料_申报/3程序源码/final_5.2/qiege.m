%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%图像处理子程序
%作者：胡一浪
%功能：去掉图片多余黑色边界
%参数：图片
%返回：去掉黑边的图片
%版本：5.1 2018/4/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function e=qiege(sbw)
m=size(sbw,1);%size函数图像的高
n=size(sbw,2);%size函数图像的宽
top=1;bottom=m;left=1;right=n;   % init
while sum(sbw(top,:))==0 && top<=m %A(:,i)=[x x x x x ... x];i代表赋值的行数，x代表要赋的值
    top=top+1;
end
while sum(sbw(bottom,:))==0 && bottom>=1
    bottom=bottom-1;
end
while sum(sbw(:,left))==0 && left<=n
    left=left+1;
end
while sum(sbw(:,right))==0 && right>=1
    right=right-1;
end
dd=right-left;
hh=bottom-top;
e=imcrop(sbw,[left top dd hh]);%imcrop('图象名',[x起点，y起点，x宽度，y宽度])
