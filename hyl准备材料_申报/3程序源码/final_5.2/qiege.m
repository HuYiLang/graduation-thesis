%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ͼ�����ӳ���
%���ߣ���һ��
%���ܣ�ȥ��ͼƬ�����ɫ�߽�
%������ͼƬ
%���أ�ȥ���ڱߵ�ͼƬ
%�汾��5.1 2018/4/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function e=qiege(sbw)
m=size(sbw,1);%size����ͼ��ĸ�
n=size(sbw,2);%size����ͼ��Ŀ�
top=1;bottom=m;left=1;right=n;   % init
while sum(sbw(top,:))==0 && top<=m %A(:,i)=[x x x x x ... x];i����ֵ��������x����Ҫ����ֵ
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
e=imcrop(sbw,[left top dd hh]);%imcrop('ͼ����',[x��㣬y��㣬x��ȣ�y���])
