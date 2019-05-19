%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ͼ�����ӳ���
%���ߣ���һ��
%���ܣ�ʶ��һ��ͼƬ
%��������Ч����ͼƬ����ʾ�����
%���أ���
%�汾��5.1 2018/4/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% close all;
% clear;
% clc;
% 
% %����ԭʼͼ��
% [fn,pn,fi]=uigetfile('*.jpg','ѡ��ͼƬ');
% t9 = clock;%������ʱ��
% original_image=imread('blue_1.jpg');

function RGB_extract_basic(src_image,handles_temp)

identify_result = '';
identify_result_num = 0;%�Ƿ���ʶ���־
standard_image=imresize(src_image,[592 748]);%��һ�����ߴ�592:748��%��ֹͼƬ�����С
% figure;imshow(standard_image);title('ԭʼͼ��');

image_height=size(standard_image,1);%size����ͼ��ĸ�
image_width=size(standard_image,2);%size����ͼ��Ŀ�
DEAL_NUM = 3;   %�죬�����Ƹ�����һ��

% t4=clock;%ʶ��һ�ż�ʱ%��������е�ʱ��
for deal_num = 1:DEAL_NUM
%     t8 = clock;%һ�ַ�����λ����ʱ�䣻
%     t4 = clock;%��ֵ����ʱ
    %��ɫת��ֵ��
    CA = zeros(image_height,image_width,'double');
    for i=1:image_height
        for j=1:image_width
            if deal_num == 1	%�����ɫ���
                if standard_image(i,j,1) < 50 && standard_image(i,j,2) < 50 && standard_image(i,j,3)< 50
                    CA(i,j)=standard_image(i,j,3)+standard_image(i,j,1);
                end
            end
            if deal_num == 2	%������ɫ���
                if standard_image(i,j,1) < 10
                    CA(i,j)=standard_image(i,j,2);
                end
            end
			if deal_num == 3    %�����ɫ���
		        if 1.6*standard_image(i,j,1)-standard_image(i,j,2)-standard_image(i,j,3)>=0
		            CA(i,j)=1.6*standard_image(i,j,1)-standard_image(i,j,2)-standard_image(i,j,3);
		        end
			end
        end
    end
%     disp(['etime����ƽ��: ��ֵ��',num2str(etime(clock,t4))]);
%     t11 = clock;%��Ե��⣬�Ƴ�С�����ʱ
%     figure(1);
%     subplot(4,2,1);imshow(CA);title(strcat('�Ҷ�ͼ��', num2str(deal_num)));
    %��Ե���
    if deal_num == 3        %��ǰ������Ǻ�ɫ
        BianYuan=edge(CA,'canny',0.5);%Canny���ӱ�Ե���
    else                    %��ǰ������ǻƺ���ɫ
        BianYuan=edge(CA,'canny',0.4);%Canny���ӱ�Ե���
    end
%     subplot(4,2,2);imshow(BianYuan),title('Canny���ӱ�Ե����ͼ��');

    %ͼ��Ԥ����
    se=strel('disk',6); %����һ��ָ���뾶10��ƽ��Բ���εĽṹԪ��
    BianYuan_rgb=imclose(BianYuan,se);%�ղ�����
%     figure();imshow(BianYuan_rgb),title('�ղ���');
    BianYuan_rgb_tc=bwfill(BianYuan_rgb,'holes');%���
%     figure();imshow(BianYuan_rgb_tc),title('���');
    YuanShiLvBo=bwareaopen(BianYuan_rgb_tc,1000);%�Ӷ������Ƴ����С��2000��С����
%     figure();imshow(YuanShiLvBo),title('�Ƴ�');
    YuanShiLvBo=YuanShiLvBo(:,:,1);
%     figure();imshow(YuanShiLvBo),title('�Ƴ����С��1000�ĺ�ͼ��');
%     [~,num_L_1]=bwlabeln(YuanShiLvBo); %��¼�˲��������Ŀnum_L_1��
%     disp(['etime�����Ե��⣬�Ƴ�С����',num2str(etime(clock,t11))]);
    
%     t12 = clock;%ƽ����ʱ
    % ��Եƽ������
    hsize = [10 10];
    sigma = 1.5;
    h = fspecial('gaussian', hsize, sigma);
    YuanShiLvBo = imfilter(YuanShiLvBo, h, 'replicate');
%     subplot(4,2,3);imshow(YuanShiLvBo),title(strcat('��Եƽ������',num2str(deal_num)));
    
    [L,num_L]=bwlabeln(YuanShiLvBo); %����ͨ����ĸ������벿�ֽ��б�ע,L�а�������ͨ����ı�ע��num_Lƽ��������ɫ����
% %     ��һ�������㷨������ƽ������ǰ���Ƿ�����µ��������ж�
%     if num_L_1 ~= num_L %���ƽ�������˰�ɫ���򣬲�����������
%         fprintf('%s\n','���ƽ�������˰�ɫ���򣬲���');
%         continue;
%     end
    %�ڶ��������㷨��ͨ����ɫ������Ŀ������ɫ����ռͼƬ�������ж�
    Max_White_area = 0;       %����ɫ���
    S=regionprops(L,'Area','boundingbox');
    rects_pro = cat(1,S.BoundingBox);
    %������
    for i = 1:num_L
        if(S(i).Area >= Max_White_area)
            Max_White_area = S(i).Area;
        end
    end
%     fprintf('num2str(Max_White_area) = %s,��%d��ѭ��\n',num2str(Max_White_area),deal_num);
%     fprintf('num2str(Max_White_area) = %s\n',num2str(S(max_id).Area));
    sum_area_ratio = Max_White_area/(image_height*image_width);%���İ�ɫ����ռͼƬ�����
    if(sum_area_ratio >= 0.1 || sum_area_ratio == 0 || num_L > 4) %����������Ϊ0�������򳬹�4���쳣
%         fprintf('%s\n','max_sum_area/Max_White_area <= 0.8');
        continue;
    end

    for i = 1:num_L
        if S(i).Area/Max_White_area <= 0.2      %���������С����������0.2���Ͱ��������Ϳ��
            YuanShiLvBo = change_black(YuanShiLvBo,round(rects_pro(i, 1)),round(rects_pro(i, 2)),rects_pro(i, 3),rects_pro(i, 4));
%             figure();imshow(YuanShiLvBo),title('������ͼ��');
        end
    end
    
    %�����������㷨������Ϳ�׺�����Ƿ�仯���ж�
    [L,num]=bwlabeln(YuanShiLvBo); %����ͨ����ĸ������벿�ֽ��б�ע,L�а�������ͨ����ı�ע��Ĭ��
    img_reg = regionprops(L,'Area','boundingbox');    
    rects = cat(1,img_reg.BoundingBox);
    
%     max_sum_area = 0;
%     for i = 1:num
%         if(S(i).Area >= max_sum_area)
%             max_sum_area = S(i).Area;
%         end
%     end  
%     if(max_sum_area/Max_White_area <= 0.8)    %���˺�����仯������
%         fprintf('%s\n','max_sum_area/Max_White_area <= 0.8');
%         continue;
%     end
    size_num_rects = size(rects, 1);
%     disp(['etime����ƽ����',num2str(etime(clock,t12))]);
    
%     disp(['etime����һ�ֶ�λ������ʱ',num2str(etime(clock,t8))]); 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %�Զ�λ������Ŀ�����������ȡ
%     t7 = clock;%��ȡ��ƥ����ʱ
    for i = 1:size_num_rects
        Iresult_YuanShiLvBo=imcrop(YuanShiLvBo,rects(i, :));%��ȡ����λ����ĺڰ�ͼ��
%         figure();imshow(Iresult_YuanShiLvBo),title('�и�����ĺڰ�����'); 
        
        %�ж϶�λ�������Ƿ���ϱ�׼
        %��״��
        [L_test,num_test]=bwlabeln(Iresult_YuanShiLvBo); %����ͨ����ĸ������벿�ֽ��б�ע,L�а�������ͨ����ı�ע��Ĭ��
        if num_test > 1 || rects(i, 3)/rects(i, 4) < 0.7 || rects(i, 3)/rects(i, 4) > 1.5    %�ָ��Ӧ����һ�����İ�ɫ����������˵������
%             msgbox({'�ָ���ɫ����: ' num2str(num_test) num2str(deal_num) num2str(rects(i, 3)/rects(i, 4)) '��Ӧ�ñ�����'},'�ָ���ɫ����');
            continue;
        end
        %�����
        L_test_Area = regionprops(L_test,'Area');
        white_black_ratio = L_test_Area(1).Area/(size(Iresult_YuanShiLvBo,1)*size(Iresult_YuanShiLvBo,2));
%         msgbox({'�ָ���ɫռ�ܵ��������:' num2str(white_black_ratio)},'�ָ���ɫռ�ܵ��������');
        if deal_num == 1        %�������ռ���ͼֻ��0.5-0.6
            if(white_black_ratio <= 0.5 || white_black_ratio >= 0.6)
                continue;
            end
        else
            if(white_black_ratio <= 0.7 || white_black_ratio >= 0.8)
                continue;
            end
        end   
        
        %����λ�ĺ���ͼƬ
        Iresult_I=imcrop(standard_image,rects(i, :));%ԭͼ�и�
%         figure();imshow(Iresult_I),title('ԭͼ�и�');
        Iresult_change_white = change_white(Iresult_I,Iresult_YuanShiLvBo);%Ŀ��������Χ���ֱ��
%         BianYuan_rgb
%         standard_image=imresize(src_image,[592 748]);
%         figure();imshow(BianYuan_rgb_qiege),title('�ղ����и�ͼ��');
        BianYuan_qiege=imcrop(BianYuan,rects(i, :));%canny�и�    
%         figure();imshow(BianYuan_qiege),title('��λ֮��canny�и�ͼ��');
        BianYuan_qiege=imresize(BianYuan_qiege,[60 60]);
%         figure();imshow(BianYuan_qiege),title('60x60��һ��ͼ��');
        se=strel('disk',5); %����һ��ָ���뾶10��ƽ��Բ���εĽṹԪ��
        BianYuan_qiege_imclose=imclose(BianYuan_qiege,se);%�ղ�����
%         figure();imshow(BianYuan_qiege_imclose),title('canny�и�ͼ���ڱղ���');
        
        identify_result_num = 1;
%         figure(2);imshow(Iresult_change_white),title('Ŀ��������Χ���ֱ��');
        
        e = template_create(Iresult_change_white,deal_num,BianYuan_qiege_imclose);%����ƥ���ģ��
%         figure();imshow(e),title('����ƥ���ģ��');
        
        [return_template_image,identify_name] = template_matching(e);%ģ��ƥ��
        
        identify_result = strcat(identify_result,identify_name);
        if(size(rects, 1) ~= 1 && i ~= size(rects, 1))
            identify_result = strcat(identify_result,',');%���Ÿ���������
        end
    end
%     disp(['etime������ȡ��ƥ���ʱ',num2str(etime(clock,t7))]); 
end
% disp(['etime����ʶ��ͼƬ�ܺ�ʱ',num2str(etime(clock,t4))]);

% t5=clock;%��ʾͼƬ��ʱ
% ��ʾ��ȡ��ͼ��

axes(handles_temp.original_image);
imshow(src_image);%��ʼͼ��
unidentification_img = imread('unidentification.jpg');
if(identify_result_num == 1)
    axes(handles_temp.target_image);
    imshow(Iresult_change_white);%��λͼ��

    axes(handles_temp.standard_image);
    imshow(e);%��ȡͼ��

    axes(handles_temp.template_image);
    imshow(return_template_image);%ģ��ͼ��
    
    set(handles_temp.identify_result,'String',identify_result);%ʶ����
    drawnow;%û��drawnow ֻ����ʾ�����
else
    axes(handles_temp.target_image);
    imshow(unidentification_img);%��λͼ��

    axes(handles_temp.standard_image);
    imshow(unidentification_img);%��ȡͼ��

    axes(handles_temp.template_image);
    imshow(unidentification_img);%ģ��ͼ��
    set(handles_temp.identify_result,'String','δʶ��');%ʶ����
    drawnow;%û��drawnow ֻ����ʾ�����
end
% disp(['etime������ʾͼƬ�ܺ�ʱ',num2str(etime(clock,t5))]);
% disp(['etime�����ܺ�ʱ',num2str(etime(clock,t9))]);

