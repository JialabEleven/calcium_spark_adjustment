clear all;
clc;

%% background data calculation for 20 frames of raw_data
cur_p1 = mfilename('fullpath');
i=strfind(cur_p1,'\');
cur_p=cur_p1(1:i(end-1));   
buildingDir = fullfile([cur_p '\calcium_spark_detection\raw_data\']);
buildingDir1 = fullfile([cur_p '\calcium_spark_detection\deal\']);

str=buildingDir;
% str='F:\20220805_ZDD_papaer_code\calcium_spark_detection\raw_data\';
for i=1:20
    img1=imread([str,num2str(i),'.bmp']);
    img_stack(:,:,i)=img1;
     [rows,columns]=size(img1);
end

mean=0;





for j=1:rows
    for k=1:columns
        for m=1:20
            img2(j,k)=img_stack(j,k,m);
            mean_singledots=double(img2(j,k)); %Here，we need double because of unit8's max value is just 255.
            mean=mean+mean_singledots;%get every pixel in picture
            %mean_img(j,k)=mean_img(j,k)+img2(j,k);
        end
        img3(j,k)=mean/20;
        mean=0;
    end
end
img3=img3/255;


save mean_data;




%compare with mean value of first 20 picture


%% deal raw_data
load mean_data;
mean_data=img3;
savepath=buildingDir1;
load mycolormap10.mat;


for ii=1:150
    img=imread([str,num2str(ii),'.bmp']);
    img0=im2double(img);
    img1=img0-mean_data;
    [rows,columns]=size(img1);
    compare_max0(ii)=max(max(img1));
    compare_min0(ii)=min(min(img1));
end
compare_max=max(compare_max0);
compare_min=min(compare_min0);


for n=1:150
    compare_img=imread([str,num2str(n),'.bmp']);
    compare_img1=im2double(compare_img(:,:));%cut useless black background
    compare_img2=compare_img1-mean_data;
    [rows1,columns1]=size(compare_img1);
    for pp=1:rows1
        for qq=1:columns1
            compare_img3(pp,qq)=(compare_img2(pp,qq)-compare_min)/(compare_max-compare_min);
        end
    end
    figure(),imshow(compare_img3,'border','tight');
    colormap(mycolormap10) ;%colorbar;
    %save('buildingDir1\mycolormap10','mycolormap10');
    %colormap("colorcube");
    saveas(gcf,[savepath,num2str(n),'.tif']);
%     compare_stack(:,:,n-30)=compare_img3;
%     figure(),imshow(img1)
%     imwrite(im,[savepath,'mark-',num2str(n),'.tif']);
end


%% change picture to movie
myobj= VideoWriter('base.avi');
myobj.FrameRate=8;
open(myobj)
for jj=1:150
    fname = strcat(savepath,num2str(jj),'.tif');
    frame = imread(fname);
    writeVideo(myobj, frame);
end
close(myobj)

