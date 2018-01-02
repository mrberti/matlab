clear all;
close all;
more off;

try
    pkg load image
end

color_mode = 0; % 1=gray
calc_mode = 1; % 1=mean on the fly; 2=mean at write
resize_mode = 1; % 1=resize on;
starting_dir = 'C:/Users/Simon/Pictures'
%starting_dir = 'C:/cygwin/home/Simon'
max_pics_per_dir = 10;

dirs = dir(starting_dir);
n = 0;  

clear 'im_add'

for k = 1:size(dirs, 1)
  if dirs(k).isdir && dirs(k).name(1) ~= '.'
    working_dir = [starting_dir '/' dirs(k).name]

    files = dir(working_dir);
    N = size(files,1);
    N = min(N,max_pics_per_dir);
    max_X = 1000;
    max_Y = 1000;

    for i = 3:N
      name = [working_dir '/' files(i).name];
      if (size(name,2) > 3) && (lower(name(end-2:end)) == 'jpg')
        name
        im = imread( name );
        if size(im,1) > max_Y && size(im,2) > max_X
          n = n + 1
          if (resize_mode == 1)
            im = imresize( im, [max_Y max_X] );
          end
          im = cast(im(1:max_X,1:max_Y,:),'double');
          if color_mode == 1
            im = rgb2gray(im);
          end
          %ims(:,:,:,n) = im;
          if exist('im_add', 'var') == 1
            if (calc_mode == 1)
              im_add = (n-1)*(im_add / n + im / n / (n-1));
            elseif (calc_mode == 2)
              im_add = im_add + im;
            end
          else
            printf('creating im_add\n');
            im_add = im;
          end
            imshow(cast(im_add(:,:,:), 'uint8'));
            pause(0.001);
        end
      end
    end
    if exist('im_add', 'var') == 1
      
      printf('writing im_add... ');
      if (calc_mode == 1)
        im_write = round(im_add);
      elseif (calc_mode == 2)
        im_write = im_add / n;
        im_write = round(im_add);
      end
      im_write = cast(im_write(:,:,:), 'uint8');
      imwrite(im_write, ['im_add' int2str(calc_mode) '.jpeg']);

      % scale image
      a = min(min(im_add));
      b = max(max(im_add));
      m = 255./(b-a);
      B = -m.*a;
      imn = im_add .* m + B;

      imn = round(imn);
      imn = cast(imn,'uint8');
      imwrite(imn, ['imn' int2str(calc_mode) '.jpeg'])
      printf('DONE!\n');
    end
  end
end


