%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ͼ�����ӳ���
%���ߣ���һ��
%���ܣ���������ƥ���ͼƬ
%������rgb��ԭͼ��deal_num����ǰ�������ַ�ʽʶ�𣺺죬�����ƣ�BianYuan_rgb_qiege���и�ղ�����ͼ��
%���أ�����ƥ���ͼƬ
%�汾��5.1 2018/4/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function e = template_create(rgb,deal_num,BianYuan_rgb_qiege)

% %ȥ���ڲ�����,������ɫ
image_height=size(rgb,1);%size����ͼ��ĸ�
image_width=size(rgb,2);%size����ͼ��Ŀ�
if(deal_num == 3)           %��ɫ
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
if(deal_num == 2)       %��
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
% subplot(4,2,1);imshow(rgb);title('1.ԭͼ');
b=rgb2gray(rgb);
% subplot(4,2,2); imshow(b);title('2.�Ҷ�');
I1=imbinarize(b,0.6);
%�����㷨�����ͼƬ�Ҷȴ�����,ͼƬȫ��
[L,num_L]=bwlabeln(I1); %����ͨ����ĸ������벿�ֽ��б�ע,L�а�������ͨ����ı�ע��Ĭ��
sum_area = 0;
S=regionprops(L,'Area');
for i = 1:num_L
    sum_area = S(i).Area+sum_area;
end
sum_area = sum_area/(image_height*image_width);
if(sum_area <= 0.35)
%     msgbox(num2str(sum_area),'ͼƬȫ��');
%     fprintf('%s\n','ͼƬȫ��');
    I1=imbinarize(b,0.4);
end

[L,num_L]=bwlabeln(I1); %����ͨ����ĸ������벿�ֽ��б�ע,L�а�������ͨ����ı�ע��Ĭ��
sum_area = 0;
S=regionprops(L,'Area');
for i = 1:num_L
    sum_area = S(i).Area+sum_area;
end
sum_area = sum_area/(image_height*image_width);
if(sum_area <= 0.35)
%     msgbox(num2str(sum_area),'ͼƬȫ��');
%     fprintf('%s\n','ͼƬ��Ȼȫ��');
    e = BianYuan_rgb_qiege;
    return;
end

% subplot(4,2,3);imshow(I1);title('3.��ֵ��');

I1=~I1;
% subplot(4,2,4);imshow(I1);title('4.��ɫ');

if(deal_num == 3)
	I1=bwareaopen(I1,90);%�Ӷ������Ƴ����С��2000��С����
else
	I1=bwareaopen(I1,40);%�Ӷ������Ƴ����С��2000��С����
end
% subplot(4,2,5);imshow(I1),title('5.�Ƴ����С��90');
I1=qiege(I1);

I1=imresize(I1,[60 60]);
% subplot(4,2,6);imshow(I1);title('6.��һ��');

e = I1;

end
