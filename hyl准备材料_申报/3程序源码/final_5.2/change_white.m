%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ͼ�����ӳ���
%���ߣ���һ��
%���ܣ�ͼƬb����sbw���ֱ��
%������b��ԭͼ��sbw�Ƕ���ͼ��
%���أ���Χ�����׵�ͼƬ
%�汾��5.1 2018/4/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function e=change_white(b,sbw)%����sbw�еĺ�ɫ���򣬽���ɫͼ��b�ж�Ӧ�������ף������ڻҶȴ���
image_height=size(sbw,1);%size����ͼ��ĸ�
image_width=size(sbw,2);%size����ͼ��Ŀ�

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
