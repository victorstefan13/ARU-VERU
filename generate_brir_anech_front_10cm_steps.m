%% GENERATE BRIRS FOR THE AUDITORY DISTANCE BISECTION EXPERIMENT.
% ROOM SIZE: 5.4 X 9 X 2.5 (AS IN JASA PAPER)
% FRONTAL SOURCES AT AZIMUTH 0, ELEVATION 0, FROM 1 M TO 6 M, IN STEPS OF
% 10 CM.

% Args are: room dimensions, surface absorbtion coefficients (walls, ceiling, floor), recEIver
% co-ordinates, source coordinates, head orientation (degrees), impulse response
% length (samples).

% Example command... 
% make_brir([6 7 2.5],[0.6 0.6 0.6 0.6 0.9 0.1],[2 1.2 1.8],[5.1 5.3 1.5],-30,22050);

% - Use the Lehmann code to get the coefficients
%[out,OKflag] = ISM_AbsCoeff('T60',0.4,[5  4  2.5],ones(1,6),'LehmannJohansson');
% gives 0.2974    0.2974    0.2974    0.2974    0.2974    0.2974

% e.g. make_brir([5  4  2.5],[0.2974    0.2974    0.2974    0.2974    0.2974 0.2974],[2.5, 1.5, 1.5],[2.5, 2.5, 1.5],90,22050); %produces a 0.5 s BRIR
% now use all coefficients to be 0.3, to get a reverb time of 316 ms using the Sabine equation
% at 44100 Hz - needs to be downsampled as our stimuli are all at 22050 Hz
% [ NOTE for this setup have to specify the listener at 90 deg to match the Lehmann and Johansson configuration - see Room_coordinates.xls]


clear all
clc
%%Setup for the Binaural Room Impulse Responses (to use with make_brir.m):
% room dimensions:
dims = [5.4 22 2.5];

%absorption coefficients (four walls, ceiling, floor): all 1 for anechoic
% 
absorb = [1    1    1    1    1  1];


%receiver (centre of the head) coordinates:
receiver_coords = [2.7 1 1.5];

%bearing of the head as azimuth (=angle in degrees between the direction it is facing
%and wall 1) (Note: elevation = 0 in make_brir.m, but could be changed):

bearing = 90;

% Length of the BRIR (sampling frequency is Fs = 44100 Hz):
ir_length = 44100;


% Generate the positions (x,y,z) of the source on a line at azimuth 0 with respect to the centre of the head, 
%in steps of 10 cm from a distance of 1 m to a maximum distance of 7 m from the head:

step = 0.1; %m
min_dist = 1; % distance from centre of the head and the closest source
max_dist = 20; % distance from centre of the head and the furthest source
for i = 0:floor((max_dist-min_dist)/step)
    
    dist_to_source = min_dist + i*step;
    str_dist = mk_str_dist(dist_to_source); % write the distance as a string for use in the output file name.
    current_brir = [i];
    x = receiver_coords(1);
    y = receiver_coords(2) + dist_to_source;
    z = receiver_coords(3);
    
    
    
    source_coords = [x y z];
    
    %generate BRIR (with default Fs=44100 Hz):
    brir = make_brir(dims,absorb,source_coords,receiver_coords,bearing,ir_length);
    
    l = brir(:, 1);
    r = brir(:, 2);
    
    % downsample BRIR from 44100 to Fs = 22050 Hz (to match our stimuli):
    
    l_down = downsample(l,2);
    r_down = downsample(r,2);
    brir_down= [l_down,r_down];
    
    brir_down_scale = brir_down/150; % initial scaling 
    
    %generate a FILENAME:
    dirname = 'C:\Users\ucv09\Documents\VERU\GenerateStimuli\test\test\'; 
    
    if ( exist(dirname,'dir')==0 )
        disp('Please provide a valid input directory name.')
    else
        filename= strcat(dirname, 'brir_anech_', str_dist , '.wav'); 
    end
    
    for j = 1:length(brir_down_scale)
        if(brir_down_scale(j) > 1 | brir_down_scale(j) < -1)

            brir_down_scale = brir_down_scale./(max(abs(brir_down_scale)));

        end
    end
    audiowrite(filename,brir_down_scale,22050);

    brir_dir = 'C:\Users\ucv09\Documents\VERU\GenerateStimuli\test\test\';

    fprintf("Generating BRIR number: %d\n", i+1);
end

