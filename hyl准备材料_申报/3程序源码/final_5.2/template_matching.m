%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ͼ�����ӳ���
%���ߣ���һ��
%���ܣ�ģ��ƥ��
%������rgb��ԭͼ��deal_num����ǰ�������ַ�ʽʶ�𣺺죬�����ƣ�BianYuan_rgb_qiege���и�ղ�����ͼ��
%���أ�ƥ���ģ���ģ����
%�汾��5.1 2018/4/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [return_template_image,identify_name]= template_matching(src)%flag_resultʶ����

src=imresize(src,[60 60]);

file_path =  '.\binaryzation_image_template\';% ͼ���ļ���·��  
img_path_list = dir(strcat(file_path,'*.jpg'));%��ȡ���ļ���������jpg��ʽ��ͼ��  
img_num = length(img_path_list);%��ȡͼ��������  
if img_num > 0 %������������ͼ��  
        for j = 1:img_num %��һ��ȡͼ��  
            image_name = img_path_list(j).name;% ͼ����  
            image =  imread(strcat(file_path,image_name));
            temp = 0;
            image_height=size(image,1);%size����ͼ��ĸ�
            image_width=size(image,2);%size����ͼ��Ŀ�
            for image_height_temp=1:image_height %ͼ��߶�
                  for image_width_temp=1:image_width   %ͼ����
                        if(src(image_height_temp,image_width_temp) - image(image_height_temp,image_width_temp) == 0)
                            temp = temp + 1;
                        end
                  end
            end 
%             fprintf('%s %d %s\n',image_name,j,num2str(temp/(image_height * image_height)));% ��ʾ���ڴ����ͼ����
            if(temp/(image_height * image_height) > 0.821)
                return_template_image = image;
                s = regexp(image_name,'\.','split');%�������ļ���xx.bmp����bmpȥ��
                identify_name = char(s(1));
                %д���ļ�
%                 filename = fopen('C:\Users\HYL\Desktop\identify_result.txt','wt');
%                 fprintf(filename,'%s\n',identify_name);
%                 fclose(filename);
                return;
            end             
        end
        identify_name = 'δʶ��';
        return_template_image = imread('unidentification.jpg');
        imwrite(src,strcat(datestr(now,'HHMMSS'),'.jpg'),'bmp');%����δʶ���ͼ��
else
    identify_name = 'ģ���û��.jpgģ��';
    return_template_image = imread('unidentification.jpg');
end