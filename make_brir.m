% Args are: room dimensions, surface absorbtion ooefficients (walls, ceiling, floor), reciever
% co-ordinates, source coordinates, head orientation (degrees), impulse response
% length (samples).

% Example command... 
% make_brir([6 7 2.5],[0.6 0.6 0.6 0.6 0.9 0.1],[2 1.2 1.8],[5.1 5.3 1.5],-30,22050);

function brir = make_brir(dims,absorb,source_coords,receiver_coords,bearing,ir_length)
base_command = sprintf('headroom -d %1.4f %1.4f %1.4f -a %1.2f %1.2f %1.2f %1.2f %1.2f %1.2f -h %1.2f %1.2f %1.2f -b %03d 0',...
        dims(1),dims(2),dims(3),...
        absorb(1),absorb(2),absorb(3),absorb(4),absorb(5),absorb(6),...
        receiver_coords(1),receiver_coords(2),receiver_coords(3),round(bearing(1)));
command = [base_command sprintf(' -s %1.1f %1.1f %1.1f -o targ -l %d \n',...            
               source_coords(1),source_coords(2),source_coords(3),ir_length)];
dos(command);
brir = get_brir('targ_L.ir','targ_R.ir');
end

