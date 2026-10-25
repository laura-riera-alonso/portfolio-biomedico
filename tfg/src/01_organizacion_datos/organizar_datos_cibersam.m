%uncompress files
%Once we've downloaded the files from CIBERSAM, we have to uncompress the
%folders
%This script must be run just after downloading the files from CIBERSAM. It
%changes de name of the folder to a more convenient way as
%PatientName_PatientNumber_Modality, gets rid of unwanted modalities and classifies T1 and T1-CE
%First, try without decompressing the original folder. If it doesn't work,
%try decompressing it using the code:
clc
clear all
close all
path_input='DATA_ROOT\1_GettingData\datos_originales';
path_input_2='DATA_ROOT\2_PreprocessingData\datos_originales_unzip';
path_output='DATA_ROOT\2_PreprocessingData\datos_organizados';
pat_exclude={'PAT_105','PAT_107', 'PAT_113', 'PAT_119', 'PAT_126', 'PAT_134', 'PAT_137', 'PAT_141', 'PAT_142'};
%1-%First we eliminate all the folders that are part of the excluded patients and uncompress those that do belong to the dataset
pat_list=dir(path_input);
pat_list=pat_list(~ismember({pat_list.name},{'.', '..', '.DS_Store', 'desktop.ini'}));
for pat=1:numel(pat_list)
    pat_path=fullfile(pat_list(pat).folder,pat_list(pat).name);
    pat_path_uncompressed=fullfile(path_input,pat_list(pat).name);
        if ~contains(pat_list(pat).name, pat_exclude)
            unzip(pat_path, path_input_2);
        end
  
end
%Move files
pat_iter=-1;

image_swim=0;
image_flair=0;
image_t1_ce=0;
image_t1=0;
t1_folder_name={};
pos=0;
time_vector=[];
mod_vector=[];
t1_ce_key={'GAD'};
t1_ce_key_2={'1201', '1101', '1401'};
t1_key={'T1W_3D'};
t1_key_2={'301', '601'};
flair_key={'FLAIR', 'TRA'};
swi_key='SWIp';

%Then, from those that belong to the dataset, those modalities that are not flair, swip or t1
mod_path=fullfile(path_input_2, 'scans');
mod_list=dir(mod_path);
mod_list=mod_list(~ismember({mod_list.name},{'.', '..', '.DS_Store', 'desktop.ini'}));
for b=1:numel(mod_list)
    if contains(mod_list(b).name,swi_key)||contains(mod_list(b).name,flair_key)||contains(mod_list(b).name,t1_key)||contains(mod_list(b).name,t1_ce_key)
        disp(mod_list(b).name)
    else
        status=rmdir(fullfile(mod_list(b).folder, mod_list(b).name), 's');
    end
end 

%Then we classify flair, t1-ce, swim and t1 and eliminate empy folders 
mod_list_2=dir(mod_path);
mod_list_2=mod_list_2(~ismember({mod_list_2.name},{'.', '..', '.DS_Store', 'desktop.ini'}));
for i=1:numel(mod_list_2)
    disp(mod_list_2(i).name)
    pat_path=fullfile(mod_list_2(i).folder,mod_list_2(i).name, 'NIFTI');
    if isempty(pat_path)
        status=rmdir(pat_path);
    end
     
end 

     
for i=1:numel(mod_list_2)
   if ~isfolder(mod_list_2(i).name) %To avoid the two first elements given by dir
       pat_iter=pat_iter+1;
       disp(mod_list_2(i).name)
       img_folder=fullfile(mod_path, mod_list_2(i).name, 'NIFTI');
       img_list=dir(img_folder);
       img_list=img_list(~ismember({img_list.name},{'.', '..', '.DS_Store', 'desktop.ini', '.json'}));
       for n=1:numel(img_list)
         
       split_name=split(img_list(n).name,'_');
       pat_num=string(join(split_name(1:2),'_'));
       ref=string(join(split_name(5:7),'_'));
        %SWI
        if contains(img_list(n).name, swi_key)&& ~contains(img_list(n).name, '.json')
            destination_name='SWIm';
            new_folder_path=fullfile(path_output,destination_name);
            mkdir(new_folder_path)
            new_img_name=fullfile(new_folder_path, string(pat_num)+'_'+destination_name+'.nii.gz');
            img_path=fullfile(img_list(n).folder, img_list(n).name);
            movefile(img_path,new_img_name)

        end
        %T1W_CE
        if contains(img_list(n).name, t1_key)&&contains(ref, t1_ce_key_2)&& ~contains(img_list(n).name, '.json')
            destination_name='T1W_CE_3D_FFE_TRA_IQ';
            new_folder_path=fullfile(path_output,destination_name);
            mkdir(new_folder_path)
            new_img_name=fullfile(new_folder_path, string(pat_num)+'_'+destination_name+'.nii.gz');
            img_path=fullfile(img_list(n).folder, img_list(n).name);
            movefile(img_path,new_img_name)

        end

        %SWIm
        if contains(img_list(n).name,flair_key)&& ~contains(ref,t1_key)&& ~contains(img_list(n).name, '.json')
            destination_name='FLAIR_3D_SPIR_TRA_IQ';
            new_folder_path=fullfile(path_output,destination_name);
            mkdir(new_folder_path)
            new_img_name=fullfile(new_folder_path, string(pat_num)+'_'+destination_name+'.nii.gz');
            img_path=fullfile(img_list(n).folder, img_list(n).name);
            movefile(img_path,new_img_name)

        end
        if contains(img_list(n).name,t1_key)&&contains(ref, t1_key_2)&& ~contains(img_list(n).name, '.json')
            destination_name='T1W_3D_FFE_TRA_IQ';
            new_folder_path=fullfile(path_output,destination_name);
            mkdir(new_folder_path)
            new_img_name=fullfile(new_folder_path, string(pat_num)+'_'+destination_name+'.nii.gz');
            img_path=fullfile(img_list(n).folder, img_list(n).name);
            movefile(img_path,new_img_name)
        end

       % img_list=dir(img_folder);
       % img_list=img_list(~ismember({img_list.name},{'.', '..', '.DS_Store', 'desktop.ini', '.json'}));
       % 
       end
   end
end
%        img_list=dir(img_path); %List of the series of a single patient
%        img_list=img_list(~ismember({img_list.name},{'.', '..', '.DS_Store', 'desktop.ini'}));
%        for b=1:numel(img_list)
%            %if ~isfolder(mod_list(b).name)
%            if contains(img_list(b).name,swi_key)||contains(img_list(b).name,flair_key)||contains(img_list(b).name,t1_key)||contains(img_list(b).name,t1_ce_key)
%                mod_vector=[mod_vector img_list(b).name];
%                disp(img_list(b).name)
%                nifti_path=fullfile(img_list(b).folder, _list(b).name, 'NIFTI');
%                nifti_list=dir(nifti_path, '*.nii.gz');
%                nifti_list=nifti_list(~ismember({nifti_list.name},{'.', '..', '.DS_Store', 'desktop.ini', 'RAW_'}));
%                for n=1:numel(nifti_list)
%                    split_name=split(nifti_list(n).name,'_');
%                    pat_num=string(join(split_name(1:2),'_'));
%                    try
%                        if contains(mod_list(b).name,swi_key)
%                        destination_name='SWIM';
%                        new_folder_path=fullfile(path_output, destination_name, pat_num);
%                        mkdir(new_folder_path)
%                        movefile(nifti_list(1).folder,new_folder_path)  %Change name
%                        image_swim=niftiread(fullfile(nifti_list(1).folder,nifti_list(round(numel(nifti_list)/2)).name));
%                        elseif contains(mod_list(b).name,flair_key)
%                        destination_name='FLAIR';
%                        new_folder_path=fullfile(path_output,destination_name, pat_num);
%                        mkdir(new_folder_path)
%                        movefile(nifti_list(1).folder,new_folder_path)  %Change name
%                        image_flair=niftiread(fullfile(nifti_list(1).folder,nifti_list(round(numel(nifti_list)/2)).name));
% 
%                        elseif contains(mod_list(b).name,t1_ce_key)
%                        destination_name='T1_CE';
%                        new_folder_path=fullfile(path_output,destination_name, pat_num);
%                        mkdir(new_folder_path)
%                        movefile(nifti_list(1).folder,new_folder_path)  %Change name
%                        image_t1_ce=niftiread(fullfile(nifti_list(1).folder,nifti_list(round(numel(nifti_list)/2)).name));
% 
%                        elseif contains(mod_list(b).name,t1_key)&& contains(mod_vector, t1_ce_key)
%                            destination_name='T1';
%                            new_folder_path=fullfile(path_output,destination_name, pat_num);
%                            mkdir(new_folder_path)
%                            movefile(nifti_list(1).folder,new_folder_path)  %Change name
%                            image_t1=niftiread(fullfile(nifti_list(1).folder,nifti_list(round(numel(nifti_list)/2)).name));
% 
%                        elseif contains(mod_list(b).name,t1_key)&& ~contains(mod_vector, t1_ce_key)
%                        %Now we have to classify both T1 according to
%                        %acquisition time
%                        disp(mod_list(b).name)
%                        pos=pos+1;
%                        t1_folder_name{1,pos}=mod_list(b).name;
%                        nifti=niftiinfo(fullfile(nifti_list(n).folder, nifti_list(n).name));
%                        description=nifti.Description;
%                        time=split(split(description,';'),'=');
%                        format long
%                        acquisition_time=string(time(2,2));
%                        time_vector(1,pos)=acquisition_time;
%                        else
%                            delete(fullfile(mod_list(b).folder,mod_list(b).name));
%                        end
%                    catch
%                        disp ('There was an error')
%                    end
% 
%                end
%       else
% 
%       end
% 
%        end
%       %Compare both T1 acquisition times
%       [max_time, idx]=max(str2num(time_vector)); %This corresponds to T1-CE
%       disp(t1_folder_name{:,idx})
%       t1_ce_name='T1W_CE_3D_FFE_TRA_IQ';
%       t1_ce_old=fullfile(mod_list(2).folder,t1_ce_folder_name{:,idx});
%       t1_ce_new=fullfile(mod_list(2).folder,t1_ce_name);
%       movefile(t1_ce_old,t1_ce_new)
%       [min_time, idx2]=min(str2num(time_vector)); %This corresponds to T1
%       disp(t1_folder_name{:,idx2})
%       t1_name='T1W_3D_FFE_TRA_IQ';
%       t1_old=fullfile(mod_list(2).folder,t1_folder_name{:,idx2});
%       t1_new=fullfile(mod_list(2).folder,t1_name);
%       movefile(t1_old,t1_new)
%    end
% end

