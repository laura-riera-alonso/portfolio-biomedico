clc
close all
clear all
%Post-processed versión Laura 4: es la mimsa que la version 3 pero sin
%denoise

path_input='DATA_ROOT\3_StructuralPreProcessing\volume_slices\volume_slices';
path_output='DATA_ROOT\4_DL\results_MSSIM_res50-26082023_bestEpoch';
path_vasos_out='DATA_ROOT\4_DL\MRISyth_MSSIM_res50-26082023_bestEpoch';
%path_vasos_in='DATA_ROOT\3-StructuralPreProcessing\resultados_preprocesado_prueba\volume_slices\T1W_SUB_PYTHON_unnormalized\Valid';

t1_ce_path=fullfile(path_input,'T1W_CE_3D_FFE_TRA_IQ', 'Valid');
t1_path=fullfile(path_input,'T1W_3D_FFE_TRA_IQ', 'Valid');
t1_ce_pat_list=dir(t1_ce_path);
t1_ce_pat_list=t1_ce_pat_list(~ismember({t1_ce_pat_list.name},{'.', '..', '.DS_Store', 'desktop.ini'}));
t1_pat_list=dir(t1_path);
t1_pat_list=t1_pat_list(~ismember({t1_pat_list.name},{'.', '..', '.DS_Store', 'desktop.ini'}));
it=0;
for pat=40
    it=it+1;
    pat_path=fullfile(path_output, 'PAT_'+string(pat)+'_');
    mkdir(pat_path)
    fprintf(string(pat));
    t1_ce_pat_path=fullfile(t1_ce_path,'PAT_'+string(pat)+'_');
    t1_pat_path=fullfile(t1_path,'PAT_'+string(pat)+'_');
    t1_slices_list=dir(t1_pat_path);
    t1_slices_list=t1_slices_list(~ismember({t1_slices_list.name},{'.', '..', '.DS_Store', 'desktop.ini'}));

    n_slices=numel(t1_slices_list);
    for j=1:(n_slices-1)

        t1_ce_im=fullfile(t1_ce_pat_path,'PAT_'+string(pat)+'_T1W_CE_3D_FFE_TRA_IQ_slice_'+string(j)+'.nii.gz');%'PAT_'+string(pat)+'_T1W_CE_3D_FFE_TRA_IQ_final_crop.nii');
        t1_im=fullfile(t1_pat_path,'PAT_'+string(pat)+'_T1W_3D_FFE_TRA_IQ_slice_'+string(j)+'.nii.gz');
        %1-Open and normalize T1
        t1_read=niftiread(t1_im);
        t1_header=niftiinfo(t1_im); 
        t1_clean=eliminate_outliers(t1_read);
        t1_normal_2=(t1_clean-min(t1_clean(:)))/(max(t1_clean(:))-min(t1_clean(:)));
        %2-Open and normalize T1_CE
        t1_ce_read=niftiread(t1_ce_im);
        t1_ce_header=niftiinfo(t1_ce_im); 
        t1_ce_clean=eliminate_outliers(t1_ce_read);
        t1_ce_normal_2=(t1_ce_clean-min(t1_ce_clean(:)))/(max(t1_ce_clean(:))-min(t1_ce_clean(:)));
        t1_ce_normal_vol(:,:,j)=t1_ce_normal_2;
        %3-Calculate vasos_in as the difference between t1_ce and t1 and
        %normalie
        sub_im=abs(t1_ce_clean-t1_clean);
        sub_im_normal_2=(sub_im-min(sub_im(:)))/(max(sub_im(:))-min(sub_im(:)));
        
        %4-Abre y Normaliza el output de la red
        vasos_out_path=fullfile(path_vasos_out, 'PAT_'+string(pat)+'_.nii.gz');
        vasos_out=niftiread(vasos_out_path);
        vasos_clean=eliminate_outliers(vasos_out);
        vasos_out_normal=(vasos_clean-min(vasos_clean(:)))/(max(vasos_clean(:))-min(vasos_clean(:)));
        vasos_out_normal_2d=vasos_out_normal(:,:,j);
        vasos_after_DR(:,:,j)=(mean(sub_im_normal_2(:))/mean(vasos_out_normal_2d(:)))*vasos_out_normal_2d;
        
        %vasos_after_DR(:,:,j)=change_DR(sub_im_normal_2,vasos_out_normal_2d);
        t1_after_DR(:,:,j)=change_DR(t1_ce_normal_2,t1_normal_2);
        final_img(:,:,j)=vasos_after_DR(:,:,j)+t1_after_DR(:,:,j);
        final_img_2(:,:,j)=1.1*vasos_after_DR(:,:,j)+t1_after_DR(:,:,j);
        final_img_3(:,:,j)=1.2*vasos_after_DR(:,:,j)+t1_after_DR(:,:,j);
        final_img_4(:,:,j)=1.3*vasos_after_DR(:,:,j)+t1_after_DR(:,:,j);
        final_img_5(:,:,j)=1.4*vasos_after_DR(:,:,j)+t1_after_DR(:,:,j);
        final_img_6(:,:,j)=1.5*vasos_after_DR(:,:,j)+t1_after_DR(:,:,j);
        

        %Post-processing
        final(:,:,j)=final_img(:,:,j);
        % final_gamma_1(:,:,j)=imadjust(final_img(:,:,j), [],[],1);
        % final_gamma_2(:,:,j)=imadjust(final_img(:,:,j), [],[],1.2);
        % final_gamma_3(:,:,j)=imadjust(final_img(:,:,j), [],[],1.6);
        % final_gamma_4(:,:,j)=imadjust(final_img(:,:,j), [],[],0.9);
        % final_gamma_5(:,:,j)=imadjust(final_img(:,:,j), [],[],1.4);
        % final_gamma_6(:,:,j)=imadjust(final_img(:,:,j), [],[],0.7);
        % final_img_postprocessed(:,:,j)=medfilt2(imsharpen(final_img(:,:,j)), [3,3]);
        % final_img_postprocessed_2(:,:,j)=imsharpen(medfilt2(final_img(:,:,j), [2,2]));
        % final_img_postprocessed_3(:,:,j)=wiener2(imsharpen(final_img(:,:,j)), [3,3]);
        % final_img_postprocessed_4(:,:,j)=imsharpen(wiener2(final_img(:,:,j),[3,3]));
        new_path=fullfile(pat_path, 'PAT_'+string(pat)+'_original_'+string(j)+ '.jpg');
       
       ssim_val={};

        if j==92
            disp(t1_im)
            img_original(:,:,j)=final(:,:,j);
            [ssim_val_original,ssimmap_original]=ssim(img_original(:,:,100),t1_ce_normal_vol(:,:,100));
            ssim_val_original
            for lambda=0.9:0.1:1.6 
                    img_lambda(:,:,j)=lambda*vasos_after_DR(:,:,j)+t1_after_DR(:,:,j);
                    lambda_path=fullfile(pat_path,'PAT_'+string(pat)+'_lambda_'+string(lambda)+'_slice_'+string(j)+'.jpg');
                    imwrite(img_lambda(:,:,100),lambda_path)
                    lambda
                    [ssim_val_lambda,ssimmap_lambda]=ssim(img_lambda(:,:,100),t1_ce_normal_vol(:,:,100));
                    ssim_val_lambda
                    for gamma=0.8:0.1:1.6 
                        img_gamma(:,:,j)=imadjust(img_original(:,:,j), [],[],gamma);
                        gamma_path=fullfile(pat_path,'PAT_'+string(pat)+'_gamma_'+string(gamma)+'_slice_'+string(j)+'.jpg');
                        imwrite(img_gamma(:,:,j),gamma_path)
                        gamma
                        [ssim_val,ssimmap]=ssim(img_gamma(:,:,100),t1_ce_normal_vol(:,:,100));
                        ssim_val
                        img_lambda_gamma(:,:,j)=imadjust(img_lambda(:,:,j), [],[],gamma);
                        lambda_gamma_path=fullfile(pat_path,'PAT_'+string(pat)+'_lambda_'+string(lambda)+'_gamma_'+string(gamma)+'_slice_'+string(j)+'.jpg');
                        imwrite(img_lambda_gamma(:,:,100),lambda_gamma_path)
                        gamma
                        lambda
                        [ssim_val_lambda_gamma,ssimmap_lambda_gamma]=ssim(img_lambda_gamma(:,:,100),t1_ce_normal_vol(:,:,100));
                        ssim_val_lambda_gamma
                
                    end
                end
            
            % figure
            % imshow(final(:,:,100), [])
            % title('Final image')
            % figure
            % imshow(vasos_after_DR(:,:,100),[])
            % title('Vasos after DR')
            % figure
            % imshow(vasos_out_normal_2d, [])
            % title('Predicted vasos')
            % 
            % figure
            % imshow(sub_im_normal_2, [])
            % title('t1-t1_ce')

            % new_path=fullfile(pat_path, 'PAT_'+string(pat)+'_original_'+string(j)+ '.nii.gz');
            % niftiwrite(final(:,:,100),new_path, t1_header)
            % path_0=fullfile(pat_path,'PAT_'+string(pat)+'_original_'+string(j)+'.jpg');
            % imwrite(final(:,:,100),path_0)
            % t1_im
            % [gamma_ssim,ssimmap_gamma]=ssim(final(:,:,100),t1_ce_normal_vol(:,:,100));
            % gamma_ssim
            % imshow(ssimmap_gamma,[])
            % title("Local SSIM Map with Global SSIM Value: "+num2str(gamma_ssim))
            % 
            % % 
            % % new_path_1=fullfile(pat_path, 'PAT_'+string(pat)+'_gamma_1_'+string(j)+ '.nii.gz');
            % % path_1=fullfile(pat_path, 'PAT_'+string(pat)+'_gamma_1_'+string(j)+'.jpg');
            % % niftiwrite(final_gamma_1(:,:,100),new_path_1, t1_header)
            % % imwrite(final_gamma_1(:,:,100),path_1)
            % t1_im
            % [gamma_1_ssim,ssimmap_gamma_1]=ssim(final_gamma_1(:,:,100),t1_ce_normal_vol(:,:,100));
            % gamma_1_ssim
            % imshow(ssimmap_gamma_1,[])
            % title("Local SSIM Map with Global SSIM Value: "+num2str(gamma_1_ssim))
            % 
            % 
            % % new_path_2=fullfile(pat_path, 'PAT_'+string(pat)+'_gamma_1_2_'+string(j)+ '.nii.gz');
            % % path_2=fullfile(pat_path, 'PAT_'+string(pat)+'_gamma_1_2_'+string(j)+'.jpg');
            % % niftiwrite(final_gamma_2(:,:,100),new_path_2, t1_header)
            % % imwrite(final_gamma_2(:,:,100),path_2)
            % t1_im
            % [gamma_2_ssim,ssimmap_gamma_2]=ssim(final_gamma_2(:,:,100),t1_ce_normal_vol(:,:,100));
            % gamma_2_ssim
            % imshow(ssimmap_gamma_2,[])
            % title("Local SSIM Map with Global SSIM Value: "+num2str(gamma_2_ssim))
            % 
            % 
            % % new_path_3=fullfile(pat_path, 'PAT_'+string(pat)+'_gamma_1_6_'+string(j)+ '.nii.gz');
            % % path_3=fullfile(pat_path, 'PAT_'+string(pat)+'_gamma_1_6_'+string(j)+'.jpg');
            % % niftiwrite(final_gamma_3(:,:,100),new_path_3, t1_header)
            % % imwrite(final_gamma_3(:,:,100),path_3)
            % t1_im
            % [gamma_3_ssim,ssimmap_gamma_3]=ssim(final_gamma_3(:,:,100),t1_ce_normal_vol(:,:,100));
            % gamma_3_ssim
            % imshow(ssimmap_gamma_3,[])
            % title("Local SSIM Map with Global SSIM Value: "+num2str(gamma_3_ssim))
            % 
            % % 
            % % new_path_4=fullfile(pat_path, 'PAT_'+string(pat)+'_gamma_0_9_'+string(j)+ '.nii.gz');
            % % path_4=fullfile(pat_path, 'PAT_'+string(pat)+'_gamma_0_9_'+string(j)+'.jpg');
            % % niftiwrite(final_gamma_4(:,:,100),new_path_4, t1_header)
            % % imwrite(final_gamma_4(:,:,100),path_4)
            % t1_im
            % [gamma_4_ssim,ssimmap_gamma_4]=ssim(final_gamma_4(:,:,100),t1_ce_normal_vol(:,:,100));
            % gamma_4_ssim
            % imshow(ssimmap_gamma_4,[])
            % title("Local SSIM Map with Global SSIM Value: "+num2str(gamma_4_ssim))
            % 
            % 
            % % new_path_5=fullfile(pat_path, 'PAT_'+string(pat)+'_gamma_1_4'+string(j)+ '.nii.gz');
            % % path_5=fullfile(pat_path, 'PAT_'+string(pat)+'_gamma_1_4_'+string(j)+'.jpg');
            % % niftiwrite(final_gamma_5(:,:,100),new_path_5, t1_header)
            % % imwrite(final_gamma_5(:,:,100),path_5)
            % t1_im
            % [gamma_5_ssim,ssimmap_gamma_5]=ssim(final_gamma_5(:,:,100),t1_ce_normal_vol(:,:,100));
            % gamma_5_ssim
            % imshow(ssimmap_gamma_5,[])
            % title("Local SSIM Map with Global SSIM Value: "+num2str(gamma_5_ssim))
            % 
            % % new_path_6=fullfile(pat_path, 'PAT_'+string(pat)+'_gamma_0_7'+string(j)+ '.nii.gz');
            % % path_6=fullfile(pat_path, 'PAT_'+string(pat)+'_gamma_0_7_'+string(j)+'.jpg');
            % % niftiwrite(final_gamma_6(:,:,100),new_path_6, t1_header)
            % % imwrite(final_gamma_6(:,:,100),path_6)
            % t1_im
            % [gamma_6_ssim,ssimmap_gamma_6]=ssim(final_gamma_6(:,:,100),t1_ce_normal_vol(:,:,100));
            % gamma_6_ssim
            % imshow(ssimmap,[])
            % title("Local SSIM Map with Global SSIM Value: "+num2str(gamma_6_ssim))
        % figure
        % imshow(final_img_postprocessed(:,:,100), [])
        % title('Sharpen and medfilt[2,2]')
        % 
        % figure
        % imshow(final_img_postprocessed_2(:,:,100),[])
        % title('Medfilt [2,2] and sharpen ')
        % 
        %  figure
        % imshow(final_img_postprocessed_3(:,:,100),[])
        % title('Sharpen and wiener [3,3]')
        % 
        %  figure
        % imshow(final_img_postprocessed_4(:,:,100),[])
        % title('Wiener[3,3] and sharpen ')
        % new_path=fullfile(pat_path, 'PAT_'+string(pat)+'_sharpen_medfilt_2_2_'+string(j)+ '.nii.gz');
        % niftiwrite(final_img_postprocessed(:,:,100),new_path, t1_header)
        % new_path_2=fullfile(pat_path, 'PAT_'+string(pat)+'_medfilt_2_2_sharpen_'+string(j)+ '.nii.gz');
        % niftiwrite(final_img_postprocessed_2(:,:,100),new_path_2, t1_header)
        % new_path_3=fullfile(pat_path, 'PAT_'+string(pat)+'_sharpen_wiener_3_3_'+string(j)+ '.nii.gz');
        % niftiwrite(final_img_postprocessed_3(:,:,100),new_path_3, t1_header)
        % new_path_4=fullfile(pat_path, 'PAT_'+string(pat)+'_wiener_3_3_sharpen_'+string(j)+ '.nii.gz');
        % niftiwrite(final_img_postprocessed_4(:,:,100),new_path_4, t1_header)
        % % denoisedPSNR = psnr(final_img_postprocessed(:,:,100),t1_ce_normal_vol(:,:,100));
        % % fprintf("\n The PSNR value of the denoised image is %0.4f.",denoisedPSNR);
        % % denoisedPSNR_original = psnr(final_img(:,:,100),t1_ce_normal_vol(:,:,100));
        % % fprintf("\n The PSNR value of the denoised image is %0.4f.",denoisedPSNR_original);
        % % 
        end
        
        
      
    end
    clear vasos_after_DR
    clear t1_after_DR
    clear final_img
    clear final_img_2
    clear final_img_3
    clear final_img_4
    clear final_img_5
    clear final_img_6
    clear final_img_postprocessed
    clear final_img_postprocessed_2
    clear final_img_postprocessed_3
    clear final_img_postprocessed_4
    clear t1_header
    clear t1_ce_normal_vol
    clear final
    clear final_gamma_1
    clear final_gamma_2
    clear final_gamma_3
    clear final_gamma_4
    clear final_gamma_5
    clear final_gamma_6
    clear img_lambda_gamma
    clear img_lambda
    clear img_gamma
    clear img_original
      
      
      
end

%Eliminate outliers
function [t1_read]=eliminate_outliers(t1_read)

t1_read(t1_read<0)=0;
t1_read(t1_read>prctile(t1_read(:),99.9))=prctile(t1_read(:),99.9);

end 

function [t1_after_DR]=change_DR(t1_ce,t1_before_DR)
%DR_t1_ce
DR=mean(t1_ce(:))/mean(t1_before_DR(:));
t1_after_DR=DR*t1_before_DR;
end 



