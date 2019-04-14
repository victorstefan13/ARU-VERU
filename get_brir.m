function bir = get_bir(left_name,right_name);
fid = fopen(left_name,'rb');
left = fread(fid,inf,'float32');
fclose(fid);
fid = fopen(right_name,'rb');
right = fread(fid,inf,'float32');
fclose(fid);
bir = [left right];
