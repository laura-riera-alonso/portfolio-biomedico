%Create masks

clear all
close all
clc

path='DATA_ROOT\3_StructuralPreProcessing\volume_slices\volume_slices';
out_path='DATA_ROOT\3_StructuralPreProcessing\mask';
mod_list={'FLAIR_3D_SPIR_TRA_IQ', 'SWIm','T1W_3D_FFE_TRA_IQ'};

for mod=1:numel(mod_list)

    t1_ce_pat_path=fullfile(path, 'T1W_CE_3D_FFE_TRA_IQ','Valid');
    t1_ce_pat_list=dir(t1_ce_pat_path);
    t1_ce_pat_list=t1_ce_pat_list(~ismember({t1_ce_pat_list.name},{'.', '..', '.DS_Store', 'desktop.ini'}));
    
    mod_pat_path=fullfile(path, mod_list{mod}, 'Valid');
    mod_pat_list=dir(mod_pat_path);
    mod_pat_list=mod_pat_list(~ismember({mod_pat_list.name},{'.', '..', '.DS_Store', 'desktop.ini'}));
    for pat=33:40
        t1_ce_img_path=fullfile(t1_ce_pat_path, 'PAT_'+string(pat)+'_');
        mod_img_path=fullfile(mod_pat_path, 'PAT_'+string(pat)+'_');
        
        t1_ce_img_list=dir(t1_ce_img_path);
        t1_ce_img_list=t1_ce_img_list(~ismember({t1_ce_img_list.name},{'.', '..', '.DS_Store', 'desktop.ini'}));
        mod_img_list=dir(mod_img_path);
        mod_img_list=mod_img_list(~ismember({mod_img_list.name},{'.', '..', '.DS_Store', 'desktop.ini'}));
        for j=1:numel(mod_img_list)
            t1_ce_read=niftiread(fullfile(t1_ce_img_path,'PAT_'+string(pat)+'_T1W_CE_3D_FFE_TRA_IQ_slice_'+string(j)+'.nii.gz'));
            path_t1_ce=fullfile(t1_ce_img_path,'PAT_'+string(pat)+'_T1W_CE_3D_FFE_TRA_IQ_slice_'+string(j)+'.nii.gz');
            t1_ce_info=niftiinfo(path_t1_ce);

            mod_read=niftiread(fullfile(mod_img_path,'PAT_'+string(pat)+'_'+mod_list{mod}+'_slice_'+string(j)+'.nii.gz'));
            mod_info=niftiinfo(fullfile(mod_img_path,'PAT_'+string(pat)+'_'+mod_list{mod}+'_slice_'+string(j)+'.nii.gz'));
            gamma=0.62; %chosen by inspection using imageJ once images were normalized
            %Normalize images
            t1_ce_norm=(t1_ce_read-min(t1_ce_read(:)))/(max(t1_ce_read(:))-min(t1_ce_read(:)));
            mod_norm=(mod_read-min(mod_read(:)))/(max(mod_read(:))-min(mod_read(:)));
            mask=t1_ce_norm>gamma;
            

            t1_ce_seg=t1_ce_norm.*mask;
            mod_seg=mod_norm.*mask;
            new_out_path=fullfile(out_path, 'PAT_'+string(pat));
            mkdir(new_out_path)

            mask_path=fullfile(new_out_path,'PAT_'+string(pat)+'_mask_slice_'+string(j)+'.jpg');
            imwrite(double(mask),mask_path)

            t1_ce_seg_path=fullfile(new_out_path,'PAT_'+string(pat)+'_T1W_CE_segmented_slice_'+string(j)+'.jpg');
            %niftiwrite(t1_ce_seg,t1_ce_seg_path,t1_ce_info)
            imwrite(t1_ce_seg,t1_ce_seg_path)

            mod_seg_path=fullfile(new_out_path,'PAT_'+string(pat)+'_'+mod_list{mod}+'segmented_slice_'+string(j)+'.jpg');
            imwrite(mod_seg,mod_seg_path)
            %niftiwrite(mod_seg,mod_seg_path,mod_info)

            % if j==100
            % figure
            % imshow(t1_ce_norm, [])
            % title('TCE')
            % 
            % figure
            % imshow(mask, []);
            % title('Mask')
            % 
            % figure
            % imshow(mod_seg, [])
            % title('Segmented mod')
            % end


        end
    end 
end 



