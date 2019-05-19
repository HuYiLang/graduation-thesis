%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%图像处理子程序
%作者：胡一浪
%功能：识别一张图片
%参数：有效合理图片和显示句柄；
%返回：无
%版本：5.1 2018/4/23
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% close all;
% clear;
% clc;
% 
% %输入原始图像
% [fn,pn,fi]=uigetfile('*.jpg','选择图片');
% t9 = clock;%程序总时间
% original_image=imread('blue_1.jpg');

function RGB_extract_basic(src_image,handles_temp)

identify_result = '';
identify_result_num = 0;%是否能识别标志
standard_image=imresize(src_image,[592 748]);%归一化，尺寸592:748，%防止图片过大过小
% figure;imshow(standard_image);title('原始图像');

image_height=size(standard_image,1);%size函数图像的高
image_width=size(standard_image,2);%size函数图像的宽
DEAL_NUM = 3;   %红，蓝，黄各处理一次

% t4=clock;%识别一张计时%测程序运行的时间
for deal_num = 1:DEAL_NUM
%     t8 = clock;%一种方法定位花费时间；
%     t4 = clock;%二值化计时
    %彩色转二值化
    CA = zeros(image_height,image_width,'double');
    for i=1:image_height
        for j=1:image_width
            if deal_num == 1	%处理黄色情况
                if standard_image(i,j,1) < 50 && standard_image(i,j,2) < 50 && standard_image(i,j,3)< 50
                    CA(i,j)=standard_image(i,j,3)+standard_image(i,j,1);
                end
            end
            if deal_num == 2	%处理蓝色情况
                if standard_image(i,j,1) < 10
                    CA(i,j)=standard_image(i,j,2);
                end
            end
			if deal_num == 3    %处理红色情况
		        if 1.6*standard_image(i,j,1)-standard_image(i,j,2)-standard_image(i,j,3)>=0
		            CA(i,j)=1.6*standard_image(i,j,1)-standard_image(i,j,2)-standard_image(i,j,3);
		        end
			end
        end
    end
%     disp(['etime程序平滑: 二值化',num2str(etime(clock,t4))]);
%     t11 = clock;%边缘检测，移除小对象计时
%     figure(1);
%     subplot(4,2,1);imshow(CA);title(strcat('灰度图像', num2str(deal_num)));
    %边缘检测
    if deal_num == 3        %当前处理的是红色
        BianYuan=edge(CA,'canny',0.5);%Canny算子边缘检测
    else                    %当前处理的是黄和蓝色
        BianYuan=edge(CA,'canny',0.4);%Canny算子边缘检测
    end
%     subplot(4,2,2);imshow(BianYuan),title('Canny算子边缘检测后图像');

    %图像预处理
    se=strel('disk',6); %创建一个指定半径10的平面圆盘形的结构元素
    BianYuan_rgb=imclose(BianYuan,se);%闭操作；
%     figure();imshow(BianYuan_rgb),title('闭操作');
    BianYuan_rgb_tc=bwfill(BianYuan_rgb,'holes');%填充
%     figure();imshow(BianYuan_rgb_tc),title('填充');
    YuanShiLvBo=bwareaopen(BianYuan_rgb_tc,1000);%从对象中移除面积小于2000的小对象
%     figure();imshow(YuanShiLvBo),title('移除');
    YuanShiLvBo=YuanShiLvBo(:,:,1);
%     figure();imshow(YuanShiLvBo),title('移除面积小于1000的后图像');
%     [~,num_L_1]=bwlabeln(YuanShiLvBo); %记录滤波后白区数目num_L_1；
%     disp(['etime程序边缘检测，移除小对象',num2str(etime(clock,t11))]);
    
%     t12 = clock;%平滑用时
    % 边缘平滑处理
    hsize = [10 10];
    sigma = 1.5;
    h = fspecial('gaussian', hsize, sigma);
    YuanShiLvBo = imfilter(YuanShiLvBo, h, 'replicate');
%     subplot(4,2,3);imshow(YuanShiLvBo),title(strcat('边缘平滑处理',num2str(deal_num)));
    
    [L,num_L]=bwlabeln(YuanShiLvBo); %对连通对象的各个分离部分进行标注,L中包含了连通对象的标注，num_L平滑处理后白色区域。
% %     第一次修正算法：根据平滑处理前后是否产生新的区域来判断
%     if num_L_1 ~= num_L %如果平滑分离了白色区域，不满足条件，
%         fprintf('%s\n','如果平滑分离了白色区域，不满');
%         continue;
%     end
    %第二次修正算法：通过白色区域数目和最大白色区域占图片比例来判断
    Max_White_area = 0;       %最大白色面积
    S=regionprops(L,'Area','boundingbox');
    rects_pro = cat(1,S.BoundingBox);
    %最大面积
    for i = 1:num_L
        if(S(i).Area >= Max_White_area)
            Max_White_area = S(i).Area;
        end
    end
%     fprintf('num2str(Max_White_area) = %s,第%d次循环\n',num2str(Max_White_area),deal_num);
%     fprintf('num2str(Max_White_area) = %s\n',num2str(S(max_id).Area));
    sum_area_ratio = Max_White_area/(image_height*image_width);%最大的白色区域占图片的面积
    if(sum_area_ratio >= 0.1 || sum_area_ratio == 0 || num_L > 4) %面积过大，面积为0，或区域超过4个异常
%         fprintf('%s\n','max_sum_area/Max_White_area <= 0.8');
        continue;
    end

    for i = 1:num_L
        if S(i).Area/Max_White_area <= 0.2      %其他的面积小于最大面积的0.2，就把其他面积涂白
            YuanShiLvBo = change_black(YuanShiLvBo,round(rects_pro(i, 1)),round(rects_pro(i, 2)),rects_pro(i, 3),rects_pro(i, 4));
%             figure();imshow(YuanShiLvBo),title('处理后的图像');
        end
    end
    
    %第三次修正算法：根据涂白后面积是否变化来判断
    [L,num]=bwlabeln(YuanShiLvBo); %对连通对象的各个分离部分进行标注,L中包含了连通对象的标注。默认
    img_reg = regionprops(L,'Area','boundingbox');    
    rects = cat(1,img_reg.BoundingBox);
    
%     max_sum_area = 0;
%     for i = 1:num
%         if(S(i).Area >= max_sum_area)
%             max_sum_area = S(i).Area;
%         end
%     end  
%     if(max_sum_area/Max_White_area <= 0.8)    %过滤后面积变化，则不行
%         fprintf('%s\n','max_sum_area/Max_White_area <= 0.8');
%         continue;
%     end
    size_num_rects = size(rects, 1);
%     disp(['etime程序平滑后',num2str(etime(clock,t12))]);
    
%     disp(['etime程序一种定位方法耗时',num2str(etime(clock,t8))]); 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %对定位出来的目标区域进行提取
%     t7 = clock;%提取和匹配用时
    for i = 1:size_num_rects
        Iresult_YuanShiLvBo=imcrop(YuanShiLvBo,rects(i, :));%提取出定位区域的黑白图像
%         figure();imshow(Iresult_YuanShiLvBo),title('切割出来的黑白区域'); 
        
        %判断定位的区域是否符合标准
        %形状上
        [L_test,num_test]=bwlabeln(Iresult_YuanShiLvBo); %对连通对象的各个分离部分进行标注,L中包含了连通对象的标注。默认
        if num_test > 1 || rects(i, 3)/rects(i, 4) < 0.7 || rects(i, 3)/rects(i, 4) > 1.5    %分割后应该是一个填充的白色区域，有两个说明不对
%             msgbox({'分割后白色数量: ' num2str(num_test) num2str(deal_num) num2str(rects(i, 3)/rects(i, 4)) '不应该被处理'},'分割后白色数量');
            continue;
        end
        %面积上
        L_test_Area = regionprops(L_test,'Area');
        white_black_ratio = L_test_Area(1).Area/(size(Iresult_YuanShiLvBo,1)*size(Iresult_YuanShiLvBo,2));
%         msgbox({'分割后白色占总的面积比例:' num2str(white_black_ratio)},'分割后白色占总的面积比例');
        if deal_num == 1        %三角面积占这个图只有0.5-0.6
            if(white_black_ratio <= 0.5 || white_black_ratio >= 0.6)
                continue;
            end
        else
            if(white_black_ratio <= 0.7 || white_black_ratio >= 0.8)
                continue;
            end
        end   
        
        %处理定位的合理图片
        Iresult_I=imcrop(standard_image,rects(i, :));%原图切割
%         figure();imshow(Iresult_I),title('原图切割');
        Iresult_change_white = change_white(Iresult_I,Iresult_YuanShiLvBo);%目标区域周围部分变白
%         BianYuan_rgb
%         standard_image=imresize(src_image,[592 748]);
%         figure();imshow(BianYuan_rgb_qiege),title('闭操作切割图像');
        BianYuan_qiege=imcrop(BianYuan,rects(i, :));%canny切割    
%         figure();imshow(BianYuan_qiege),title('定位之后，canny切割图像');
        BianYuan_qiege=imresize(BianYuan_qiege,[60 60]);
%         figure();imshow(BianYuan_qiege),title('60x60归一化图像');
        se=strel('disk',5); %创建一个指定半径10的平面圆盘形的结构元素
        BianYuan_qiege_imclose=imclose(BianYuan_qiege,se);%闭操作；
%         figure();imshow(BianYuan_qiege_imclose),title('canny切割图像在闭操作');
        
        identify_result_num = 1;
%         figure(2);imshow(Iresult_change_white),title('目标区域周围部分变白');
        
        e = template_create(Iresult_change_white,deal_num,BianYuan_qiege_imclose);%生成匹配的模板
%         figure();imshow(e),title('生成匹配的模板');
        
        [return_template_image,identify_name] = template_matching(e);%模板匹配
        
        identify_result = strcat(identify_result,identify_name);
        if(size(rects, 1) ~= 1 && i ~= size(rects, 1))
            identify_result = strcat(identify_result,',');%逗号隔开多个结果
        end
    end
%     disp(['etime程序提取和匹配耗时',num2str(etime(clock,t7))]); 
end
% disp(['etime程序识别图片总耗时',num2str(etime(clock,t4))]);

% t5=clock;%显示图片计时
% 显示提取的图像

axes(handles_temp.original_image);
imshow(src_image);%初始图像
unidentification_img = imread('unidentification.jpg');
if(identify_result_num == 1)
    axes(handles_temp.target_image);
    imshow(Iresult_change_white);%定位图像

    axes(handles_temp.standard_image);
    imshow(e);%提取图像

    axes(handles_temp.template_image);
    imshow(return_template_image);%模板图像
    
    set(handles_temp.identify_result,'String',identify_result);%识别结果
    drawnow;%没有drawnow 只会显示最后结果
else
    axes(handles_temp.target_image);
    imshow(unidentification_img);%定位图像

    axes(handles_temp.standard_image);
    imshow(unidentification_img);%提取图像

    axes(handles_temp.template_image);
    imshow(unidentification_img);%模板图像
    set(handles_temp.identify_result,'String','未识别');%识别结果
    drawnow;%没有drawnow 只会显示最后结果
end
% disp(['etime程序显示图片总耗时',num2str(etime(clock,t5))]);
% disp(['etime程序总耗时',num2str(etime(clock,t9))]);

