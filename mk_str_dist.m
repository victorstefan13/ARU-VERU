function str_dist = mk_str_dist(dist)
%transform distance (number) into a string (e.g. dist = 6.3 becomes str_dist = 'd6p3m'):

if isa(dist, 'integer')
    str_dist = strcat('d',int2str(dist),'m'); 
else
    int_part = floor(dist);
    dec_part = round((dist-floor(dist))*100);
    if dec_part==0
        str_dist = strcat('d',int2str(dist),'m');
    else
        str_dist = strcat('d',int2str(int_part), 'p', int2str(dec_part), 'm');
    end %endifdec_part
end %endifisa


