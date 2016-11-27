function read_gastric_data

% Structure of the study struct
study = struct;
study.name = '';
study.visit = struct;
study.visit.id = '';
study.visit.patient = struct;
study.visit.patient.nick = '';

dirs = dir;
nr_dirs = size( dirs,1 );

nr_study = 0;
nr_change = 0;

for s = 1:nr_dirs
    if ( (dirs(s).isdir) && (~strcmp(dirs(s).name, '.')) && (~strcmp(dirs(s).name, '..')) && (~strcmp(dirs(s).name, 'Analysis')) )
        
        nr_study = nr_study + 1;
        study(nr_study).name = dirs(s).name;
        
        if ~strcmp(dirs(s).name, 'contours_and_3D')
            
            nr_vis = 0;            
            % Go into the study directory (already taken name)
            nr_change = nr_change + 1;
            cd(dirs(s).name);
            dirs1 = dir;
            nr_dirs1 = size( dirs1,1 );
            
            for l = 1:nr_dirs1
                if ( (dirs1(l).isdir) && (~strcmp(dirs1(l).name, '.')) && (~strcmp(dirs1(l).name, '..')) && (~strcmp(dirs1(l).name, 'Analysis')) )
                     
                    nr_vis = nr_vis + 1;
                    % Save
                    study(nr_study).visit(nr_vis).id = dirs1(l).name;
                    
                    if ~strcmp(dirs1(l).name, 'contours_and_3D')
                        
                        nr_pat = 0;
                        % Go into the patient directory / visit
                        nr_change = nr_change + 1;
                        cd(dirs1(l).name);
                        
                        disp(dirs1(l).name);
                        dirs2 = dir;
                        nr_dirs2 = size( dirs2,1 );
                        
                        for m = 1:nr_dirs2
                            if ( (dirs2(m).isdir) && (~strcmp(dirs2(m).name, '.')) && (~strcmp(dirs2(m).name, '..')) && (~strcmp(dirs2(m).name, 'Analysis')) )
                                if ~strcmp(dirs2(m).name, 'contours_and_3D')
                                    
                                    nr_pat = nr_pat + 1;
                                    %study(nr_study).patient(nr_vis).id = dirs2(m).name;
                                    study(nr_study).visit(nr_vis).patient(nr_pat).nick = dirs2(m).name;                                  
                                    % Go into the patient directory / visit
                                    nr_change = nr_change + 1;
                                    cd(dirs2(m).name);
                                    
                                    disp(dirs2(m).name);
                                    dirs3 = dir;
                                    nr_dirs3 = size( dirs3,1 );
                                    
                                    for a = 1:nr_dirs3
                                        if ( (dirs3(a).isdir) && (~strcmp(dirs3(a).name, '.')) && (~strcmp(dirs3(a).name, '..')) && (~strcmp(dirs3(a).name, 'Analysis')))
                                            if ~strcmp(dirs3(a).name, 'contours_and_3D')
                                                
                                            else
                                                
                                                cd('contours_and_3D')
                                                mat_files = dir('*.mat');
                                                nr_mat_files = size( mat_files,1 );
                                                
                                                for k = 1:nr_mat_files
                                                    
                                                    load(mat_files(k).name);
                                                    % Do stuff with each
                                                    % mat file, save
                                                    % volumes, plot
                                                    % contours, make xml
                                                    if isfield(mri3d_data.var,'three_D')
                                                        groups = size(mri3d_data.var.three_D,2);
                                                        volume = zeros(groups,nr_mat_files);
                                                        
                                                        for j = 1:groups
                                                            if ~isempty(mri3d_data.var.three_D(j).vol)
                                                                %volume(k,j) = mri3d_data.var.three_D(j).vol/1000;
                                                                %disp('volume')
                                                                %mri3d_data.var.three_D(j).vol/1000
                                                                volume(j,k) = mri3d_data.var.three_D(j).vol/1000;
                                                                %study(nr_study).patient(nr_vis).volumes(j,k) = volume(j,k);
                                                                study(nr_study).visit(nr_vis).patient(nr_pat).volumes(j,k) = volume(j,k);
                                                            end
                                                        end
                                                        %patient(b).vol = volume;
                                                        %study(nr_study).patient(nr_vis).volumes = volume;
                                                    else
                                                        %volume = 0;
                                                        %study(nr_study).patient(l).volumes(j,k) = volume;
                                                        %volume = zeros(nr_mat_files,5);
                                                        %patient(b).vol = volume;
                                                    end
                                                    
                                                    
                                                    % Extract var struct with parameters and img struct with contours
                                                    nr_slices = size(mri3d_data.img,2);
                                                    var = mri3d_data.var;
                                                    img = mri3d_data.img;
                                                    if isfield(var,'slice_gap')
                                                        slice_gap = var.slice_gap;
                                                    else
                                                        slice_gap = var.SliceSpacing;
                                                    end
                                                    
                                                    mri3d_data.var.FileName
                                                    
                                                    xmlfilename = mri3d_data.var.FileName;
                                                    
                                                    xml(xmlfilename,mri3d_data);
                                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                    %--------------------- Ploting Contours -----------------------------------
                                                    % Plot contours imported from MRI3D tool
                                                    %--------------------------------------------------------------------------
                                                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                                                    figure

                                                    for i = 1:nr_slices

                                                        % If there is a segmentation on the slice
                                                        if img(i).segment

                                                            n1 = size(img(i).scon_x, 1);
                                                            %n1 = img(i).scon_group;
                                                            n2x = length(img(i).scon_x(img(i).scon_x~=0));
                                                            n2y = length(img(i).scon_y(img(i).scon_y~=0));

                                                            if n2x<=n2y
                                                                n2 = n2x-1;
                                                                img(i).scon_count = n2;
                                                            else
                                                                n2 = n2y-1;
                                                                img(i).scon_count = n2;
                                                            end
                                                            
                                                            df_x = abs(diff(img(i).scon_x(1:n2)));
                                                            df_y = abs(diff(img(i).scon_y(1:n2)));
                                                            
                                                            ind_x = find(df_x>2*std(df_x),1,'first');
                                                            ind_y = find(df_y>2*std(df_y),1,'first');
                                                            
                                                            if ~isempty(ind_x) && ~isempty(ind_y)
                                                                if ind_x<=ind_y
                                                                    n2 = ind_x-1;
                                                                else
                                                                    n2 = ind_y-1;
                                                                end
                                                            end
                                                            
                                                            if isempty(ind_x) && ~isempty(ind_y)
                                                                n2 = ind_y-1;
                                                            end
                                                            
                                                            if ~isempty(ind_x) && isempty(ind_y)
                                                                n2 = ind_x-1;
                                                            end
                                                            
                                                            if n1==1
                                                                plot3(img(i).scon_x(1:n2), img(i).scon_y(1:n2), zeros(1,n2)+(i-1)*slice_gap, 'LineWidth', 2)
                                                                hold on
                                                            else

                                                                for j = 1:n1

                                                                    n2x = length(img(i).scon_x(j,img(i).scon_x(j,:)~=0));
                                                                    n2y = length(img(i).scon_y(j,img(i).scon_y(j,:)~=0));

                                                                    if n2x<=n2y
                                                                        n2 = n2x-1;
                                                                        hlp = diff(img(i).scon_x(j,1:n2));
                                                                        hlp1 = find(abs(hlp)>5);
                                                                        if ~isempty(hlp1)
                                                                            img(i).scon_count(j) = hlp1(1)-1;
                                                                        else
                                                                            img(i).scon_count(j) = n2;
                                                                        end
                                                                    else
                                                                        n2 = n2y-1;
                                                                        hlp = diff(img(i).scon_x(j,img(i).scon_x(j,1:n2)));
                                                                        hlp1 = find(abs(hlp)>5);
                                                                        if ~isempty(hlp1)
                                                                            img(i).scon_count(j) = hlp1(1)-1;
                                                                        else
                                                                            img(i).scon_count(j) = n2;
                                                                        end
                                                                    end

                                                                    % plot only group 1
                                                                    if img(i).scon_group(j)==1
                                                                        plot3(img(i).scon_x(j,1:img(i).scon_count(j)),img(i).scon_y(j,1:img(i).scon_count(j)),zeros(1,img(i).scon_count(j))+(i-1)*slice_gap, 'LineWidth', 2)
                                                                        hold on
                                                                    end
                                                                    % plot only group 2
                                                                    if img(i).scon_group(j)==2
                                                                        plot3(img(i).scon_x(j,1:img(i).scon_count(j)),img(i).scon_y(j,1:img(i).scon_count(j)),zeros(1,img(i).scon_count(j))+(i-1)*slice_gap, '-r', 'LineWidth', 2)
                                                                        hold on
                                                                    end
                                                                    % plot only group 3
                                                                    if img(i).scon_group(j)==3
                                                                        plot3(img(i).scon_x(j,1:img(i).scon_count(j)),img(i).scon_y(j,1:img(i).scon_count(j)),zeros(1,img(i).scon_count(j))+(i-1)*slice_gap, '-g', 'LineWidth', 2)
                                                                        hold on
                                                                    end

                                                                end

                                                            end

                                                        end

                                                    end

                                                    grid on
                                                    
                                                    title(strcat('Volume = ',num2str(volume(j,k))));
                                                    
                                                    xlabel('X')
                                                    ylabel('Y')
                                                    zlabel('Z')
                                                                                                       
                                                end
                                                
                                                close all
                                                
                                                % plot the gastric emptying
                                                % curve
                                                figure
                                                plot(study(nr_study).visit(nr_vis).patient(nr_pat).volumes(1,:),'r*:')
                                                
                                                pause(2)
                                                
                                                cd ..
                                                cd ..
                                                
                                                
                                                save study study
                                                                                               
                                                
                                            end
                                            
                                        end
                                        
                                    end
                                                                       
                                else
                                    
                                    mat_files = dir('*.mat');
                                    nr_mat_files = size( mat_files,1 );
                                    
                                    for k = 1:nr_mat_files
                                        
                                        load(mat_files(k).name);
                                        
                                        if isfield(mri3d_data.var,'three_D')
                                            groups = size(mri3d_data.var.three_D,2);
                                            for j = 1:groups
                                                if ~isempty(mri3d_data.var.three_D(j).vol)
                                                    volume(k,j) = mri3d_data.var.three_D(j).vol/1000;
                                                end
                                            end
                                            %patient(b).vol = volume;
                                        else
                                            volume = zeros(nr_mat_files,5);
                                            %patient(b).vol = volume;
                                        end
                                        
                                    end
                                                                       
                                end
                                
                            end
                            
                        end
                        
                        
                        cd ..
                    
                    else
                        
                        mat_files = dir('*.mat');
                        nr_mat_files = size( mat_files,1 );
                        
                        for k = 1:nr_mat_files
                            
                            load(mat_files(k).name);
                            
                            if isfield(mri3d_data.var,'three_D')
                                groups = size(mri3d_data.var.three_D,2);
                                for j = 1:groups
                                    if ~isempty(mri3d_data.var.three_D(j).vol)
                                        volume(k,j) = mri3d_data.var.three_D(j).vol/1000;
                                    end
                                end
                                %patient(b).vol = volume;
                            else
                                volume = zeros(nr_mat_files,5);
                                %patient(b).vol = volume;
                            end
                            
                        end
                                                
                    end
                    
                end
                
            end
            
        end
        
        cd ..
    end
    
end

save study study

end