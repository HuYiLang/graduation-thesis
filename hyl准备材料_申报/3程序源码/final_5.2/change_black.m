%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ͼ�����ӳ���
%���ߣ���һ��
%���ܣ�ͼƬָ������������
%��������Ч����ͼƬ��x,y��ʾ��㣬x_width,y_width��ʾ��Χ[x��㣬y��㣬x��ȣ�y���]��
%���أ����ͼƬ
%�汾��5.1 2018/4/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function e=change_black(sbw,x,y,x_width,y_width)
x = floor(x);%����ȡ��
y = floor(y);

for i = x:x+x_width+1
    for j = y:y+y_width+1
        sbw(j,i) = 0;
    end
end
e = sbw;