function ImageMicroChannelCellDetector_v3(pathname, points, savedir, folderDepth, fRate)

%folderDepth = 3; %������� ����� �� ���������� � �������� �����
threshold = 1; %����� ������������ ��� ����������� ��������
frameThreshold = 2; %����� ������, �� ���������� ������� ������ ������ ���������� � ���������, ����� ���� ��������
% frameThreshold = 1 ������������� ���������� �����
% ��������� �� ������������
test = true; % ���������� ��������� �� ����� ������� ����� � ������� ������������������ ������
trigger=false;
p = 2; %���������� �����, � ������� ����� ����������� �������� �� ���������� ������
%��������! ��� ������� ���������� ����� �� �������� (�� ������� ���� ����)
% ������� ���������� ����� � �����, ����� � ������
width = 0;%������ ����, � ������� �� ������ �� ���������� ������(0 - �����, 1 - 3 �������, 2 - 5 � �.�.
height = 30; %������ ����, � ������� �� ������ �� ���������� ������(0 - �����, 1 - 3 �������, 2 - 5 � �.�.

w = 3; %������ ���� ��� ����������� �����
medianVelocity=1;
sens = 1; %���������� ��� �������� ������ ������ ��������, ��� ������� ��� ��������� �������������� ����� ������
%��� sens > 1 - ������������ ������
deep = 4; %�� ������� ������� ��������� ���������� ������ � ������ ����� ������
% ��� ������ �������� ��� ������ �������
% ���������� ����� ���� ������� � ���, ��� � ������ ������������ ��������� N ������ (���������)
% ���, ��������, �� ������ ��� ������� (������)
% ���� ���������� ����������� �� ������� deep - �������������� ������
% ����� - ��������� ������������ �����������
% ������� ��������� �������� ����� ������� ���������� ����������
% ������� ������� - ���������� ����������� ����������� ������ ������� � ����������� ���������� ����������
second_pass = false; %���������� ����� �� ������ ������ ��� ������������ ��������

%foregroundDetector = vision.ForegroundDetector('NumGaussians', 5, 'NumTrainingFrames', 200);
foregroundDetector = vision.ForegroundDetector('NumGaussians', 5, 'AdaptLearningRate', false);
se = strel('square', w);

%�������� ��� ����� �� ���������������� �������� �����, ������ � �����
flipPath = flip(pathname);
count = 0;
i = 1;
while (true)
    if (flipPath(i+1) == '\')
        count = count + 1;
        if (count >= folderDepth)
            break;
        end
        save_fname(i) = '_';
    else
        save_fname(i) = flipPath(i+1);
    end
    i = i + 1;
end
save_fname = flip(save_fname);

% [filename, pathname] = uigetfile( ...
%     {'*.*',  'All Files (*.*)'}, ...
%     'Select video file');
%
% save_fname = filename;

% videoReader = vision.VideoFileReader(fullfile(pathname,filename));
%
% fRate = videoReader.info.VideoFrameRate;
% disp(fRate);

%������������� �����, � ������� ����� ������� �� ��������
% frame = step(videoReader);
% imshow(frame);
% points = zeros(p, 2);
% %  points(1, 1) = 172;
% %  points(1, 2) = 59;
% %  points(2, 1) = 562;
% %  points(2, 2) = 67;
%  for k = 1:1:p
%      [x, y] = ginput(1);
%      points(k, 1) = x;
%      disp(points(k, 1));
%      points(k, 2) = y;
%      disp(points(k, 2));
%  end

% reset(videoReader); %������������ � ������� �����

%videoPlayer = vision.VideoPlayer('Name', 'Cells');

%videoPlayer.Position(3:4) = [1200,400];  % window size: [width, height]

%����������� ������ ����������� � �����
image_names = dir(fullfile(pathname, '*.png'));
image_names = {image_names.name}';
save_faviname =sprintf('%s.avi', save_fname);
output_video = VideoWriter(fullfile(pathname,save_faviname));
output_video.FrameRate = fRate;
open(output_video);

f = waitbar(0,'�������� �����');
for i = 1:length(image_names)
    waitbar(i/length(image_names), f, '�������� �����')
    img = imread(fullfile(pathname,image_names{i}));
    writeVideo(output_video,img);
end
delete(f)
close(output_video);

videoReader = vision.VideoFileReader(fullfile(pathname,save_faviname));
disp(fRate);

% frame = step(videoReader);
% imshow(frame);
%
% reset(videoReader); %������������ � ������� �����

videoPlayer = vision.VideoPlayer('Name', 'Cells');

%���������� ��������� �����
save_foraviname =sprintf('output_foreground_%s', save_fname);
output_video = VideoWriter(fullfile(pathname,save_foraviname));
output_video.FrameRate = fRate;
open(output_video);

videoPlayer.Position(3:4) = [1200,400];
%���������� ������� ���������� �������� � ���� � ������� ����� �����
i = 0;
while ~isDone(videoReader)
    i = i + 1;
    frame = step(videoReader); % read the next video frame
    %foreground = step(foregroundDetector, frame); %���������� ���������� ������ (0/1)
    foreground = step(foregroundDetector, frame, 1/i) ;
    filteredForeground = imopen(foreground, se);
    imshow(filteredForeground);
    filteredForeground1 = uint8(filteredForeground*255); %������� � ������, ������� ����� �������� � �����
    writeVideo(output_video,filteredForeground1); % ������ �����
    for k = 1:1:p
        %�������� �� ����
        level(k, i) = 0;
        for l = -height:1:height
            for m = -width:1:width
                level(k, i) = level(k, i) + filteredForeground(round(points(k,2)) + l, round(points(k,1)) + m);
                %plot(level);
            end
        end
    end
    %pause(0.02);
    %step(videoPlayer, frame);  % display
end
release(videoReader); % close
close(output_video); % ��������� ���������� �����
trigger1=0;
%������� �������, ������� ������������� ���������� ������ � ��������� ����
%� ��������� ����� ���������������� ��� �����
for k = 1:1:p
    n = 0;
    j = 1;
    trigger2=false;
    while (j <= size(level, 2))
        if (level(k, j) >= threshold)
            n = n + 1;
            %disp(level(j));
            outliers(k, n) = j;
            trigger2=true;
        end
        j = j + 1;
    end
    if trigger2
        trigger1=trigger1+1;
    end
end
help_outliers=zeros(2,1);
%������� ������ ������ �������, �.�. ��� ������������� ����� ������
if trigger1>1
    for k = 1:1:p
        n = 1;
        j = 1;
        while (j <= size(outliers,2))
            initialFrame = outliers(k, j);
            endFrame = outliers(k, j);
            if (j + 1 <= size(outliers,2))
                while (abs(outliers(k, j + 1)-outliers(k, j)) <= sens)
                    endFrame = outliers(k, j + 1);
                    j = j + 1;
                    if ( j + 1 > size(outliers,2) )
                        break;
                    end
                    
                end
            end
            j = j + 1;
            if (endFrame - initialFrame >= (frameThreshold - 1))
                help_outliers(k, n) = round( (endFrame + initialFrame) / 2 );
                trigger=true;
                n = n + 1;
            end
        end
    end
end

%������ ������ ������ � ������� �����
if (second_pass)
    help2_outliers = help_outliers;
    help_outliers = 0;
    for k = 1:1:p
        n = 1;
        help_outliers(k, n) = help2_outliers(k, n);
        for j=2:1:size(help2_outliers,2)
            if (abs(help2_outliers(k, j)-help2_outliers(k, j-1)) <= 2)
                help_outliers(k, n) = help2_outliers(k, j);
            else
                n = n + 1;
                help_outliers(k, n) = help2_outliers(k, j);
            end
        end
    end
end

raw_sparse_outliers = help_outliers';
if trigger
    %��������� ���������� ��������� ���������
    nonz_num = zeros(1);
    for k = 1:1:p
        nonz_num(k) = nnz(help_outliers(k, :));
    end
    
    %������ ������
    j = 1;
    while (j <= min(nonz_num))
        %��������� ��������������� ������� � ������)
        dif(j) = help_outliers(2, j) - help_outliers(1, j);
        if (dif(j) <= 0)%���� ��� �������������, �� ������� ������ � ������
            h = j;
            while(h + 1 <= nonz_num(2))
                help_outliers(2, h) = help_outliers(2, h + 1);
                h = h + 1;
            end
            help_outliers(2, h) = 0;
            nonz_num(2) = nonz_num(2) - 1;
            %���� ������������, �� ���������� ���������� �� ����� �� ��������������� �������
            %�����, ����� �� ������� ������ ��� ���������� ������� � ������
        else
            h = 0;
            help_dif = 0;
            flag = true;
            while (flag && (j + h + 1) <= nonz_num(1) && (j + h) <= nonz_num(2))
                help_dif(h + 1) = help_outliers(2, j + h) - help_outliers(1, j + h + 1);
                h = h + 1;
                if (h == deep || help_dif(h + 1 - 1) <= 0)
                    flag = false;
                end
            end
            % ���� �� ������� deep ������ ������ �� ����� ������� �� ��������������� ������
            %(�.�. �� ������������ ����������� ������ � ��� �� ���� ������������� ��������)
            if (h ~= 0) %��������� ���� �� ���� ��������
                if (help_dif(h + 1 - 1) > 0)
                    %������� ������ �� �����
                    h = j;
                    while(h + 1 <= nonz_num(1))
                        help_outliers(1, h) = help_outliers(1, h + 1);
                        h = h + 1;
                    end
                    help_outliers(1, h) = 0;
                    nonz_num(1) = nonz_num(1) - 1;
                else %��������� �� ��� ���� � ��������� � ��������� ����
                    j = j + 1;
                end
            else
                j = j + 1;
            end
        end
    end
    
    %������������� ���������� ��������� ���������
    nonz_num = zeros(1);
    for k = 1:1:p
        nonz_num(k) = nnz(help_outliers(k, :));
    end
    if nnz(nonz_num)<2
        oldf=cd(savedir);
        save_ftxtname =sprintf('%s.txt', save_fname);
        deletetxtname=strcat('wide_',save_ftxtname);
        disp(deletetxtname);
        delete(deletetxtname);
        cd(oldf);
        delete(fullfile(pathname,save_faviname));
        return;
    end
    sparse_outliers = zeros(p, min(nonz_num));
    times=zeros(1);
    velocities=zeros(1);
    %������� ����
    for k = 1:1:p
        for j = 1:1:min(nonz_num)
            sparse_outliers(k, j) = help_outliers(k, j);
        end
    end
    
    %������ ��������
    dist = abs(points(2,1) - points(1,1)); % ���������� � ��������
    for j = 1:1:size(sparse_outliers, 2)
        times(j) = abs(sparse_outliers(2, j) - sparse_outliers(1, j)); %����� � ������
        velocities(j) = dist / times(j); % �������� � �������� �� ����
        normalizeVelocities(j) = velocities(j) / medianVelocity; %�� ������� ������ ���������� � ����������� �� ��������� � ������� �������
    end
    
    if (test)
        createOutputVideo(sparse_outliers, points, width, height, fRate, pathname, save_faviname);
        %createOutputVideoForeground(sparse_outliers, points, width, height, fRate, pathname, filename, w, savedir);
    end
    
    level = transpose(level);
    %figure(1);
    %plot(level);
    
    output_table = [sparse_outliers; times; velocities; normalizeVelocities];
    output_table = transpose(output_table);
    
    %save
    %     index=num2str(index);
    %     save_fname=strcat(save_fname, index);
    oldf=cd(savedir);
    save_ftxtname =sprintf('%s.txt', save_fname);
    dlmwrite(save_ftxtname, output_table, '\t')
    cd(oldf);
    %������ �������� �������
    %����� � ��������    %����� � ��������    %�������� ������    %�������� ������    %������������� �� ������� ��������
    %   � ����� 1        %   � ����� 2
else
    %     index=num2str(index);
    oldf=cd(savedir);
    save_ftxtname =sprintf('%s.txt', save_fname);
    deletetxtname=strcat('wide_',save_ftxtname);
    disp(deletetxtname);
    delete(deletetxtname);
    cd(oldf);
end
delete(fullfile(pathname,save_faviname));
end

function createOutputVideo(outliers, points, windowWidth, windowHeight, frameRate, pathname, inputFilename)

w = 2*windowWidth + 1;
h = 2*windowHeight + 1; % ������ � ������ �����

%���������� ��������� �����
save_faviname =sprintf('output_%s', inputFilename);
output_video = VideoWriter(fullfile(pathname,save_faviname));
output_video.FrameRate = frameRate;
open(output_video);

%������ ������������� �����
videoReader = vision.VideoFileReader(fullfile(pathname,inputFilename));
i = 1; %�������������� ������� ������
numberOfPoints = size(points, 1);
j = ones(1, numberOfPoints); %�������������� ������� ������ �� ����� � ������
numberOfOutliers = size(outliers, 2);
flag = false; %�����, ����������, ��� ���� ��������
while ~isDone(videoReader)
    frame = step(videoReader);
    for k = 1:1:numberOfPoints
        if (i == outliers( k, j(k) ))
            x1 = points(k,1) - windowWidth;
            y1 = points(k,2) - windowHeight; % ���������� �������� ������ ���� �����
            currentColour = getColour(j(k));
            frameWithDetector = insertShape(frame,'Rectangle',[x1, y1, w, h], 'Color', currentColour );
            for l = 1:1:frameRate
                writeVideo(output_video,frameWithDetector);
            end
            flag = true; % ��������, ��� ��������� ����
            if (j(k) < numberOfOutliers) j(k) = j(k) + 1;
            end
        end
    end
    if (~flag) writeVideo(output_video,frame); %��������� ����, ���� �� ����� � ����� ����� �� ������
    end
    flag = false;
    i = i + 1;
end
release(videoReader); % close
close(output_video); % ����������� ����� ���������� ��������� �����������
end

function createOutputVideoForeground(outliers, points, windowWidth, windowHeight, frameRate, pathname, inputFilename, we, savedir)
foregroundDetector = vision.ForegroundDetector('NumGaussians', 5, 'AdaptLearningRate', false);
se = strel('square', we);
w = 2*windowWidth + 1;
h = 2*windowHeight + 1; % ������ � ������ �����
%���������� ��������� �����
% index=num2str(index);
inputFilename1=strcat(inputFilename);
save_faviname =sprintf('output_foreground_%s', inputFilename1);
output_video = VideoWriter(fullfile(pathname,save_faviname));
output_video.FrameRate = frameRate;
open(output_video);

%������ ������������� �����
videoReader = vision.VideoFileReader(fullfile(pathname,inputFilename));
i = 1; %�������������� ������� ������
numberOfPoints = size(points, 1);
j = ones(1, numberOfPoints); %�������������� ������� ������ �� ����� � ������
numberOfOutliers = size(outliers, 2);
flag = false; %�����, ����������, ��� ���� ��������
l=0;
while ~isDone(videoReader)
    l=l+1;
    frame = step(videoReader); % read the next video frame
    [fheight,fwidth]=size(frame);
    %foreground = step(foregroundDetector, frame); %���������� ���������� ������ (0/1)
    foreground = step(foregroundDetector, frame, 1/l) ;
    filteredForeground = imopen(foreground, se);
    frame1=ones(size(frame));
    frame2=frame1.*filteredForeground;
    frameWOBG=[frame;frame2];
    for k = 1:1:numberOfPoints
        if (i == outliers( k, j(k) ))
            x1 = points(k,1) - windowWidth;
            y1 = points(k,2) - windowHeight; % ���������� �������� ������ ���� �����
            currentColour = getColour(j(k));
            frameWithDetector = insertShape(frameWOBG,'Rectangle',[x1, y1, w, h], 'Color', currentColour );
            frameWithDetector = insertShape(frameWithDetector,'Rectangle',[x1, y1+fheight, w, h], 'Color', currentColour );
            for l = 1:1:frameRate
                writeVideo(output_video,frameWithDetector);
            end
            flag = true; % ��������, ��� ��������� ����
            if (j(k) < numberOfOutliers) j(k) = j(k) + 1;
            end
        end
    end
    if (~flag) writeVideo(output_video,frameWOBG); %��������� ����, ���� �� ����� � ����� ����� �� ������
    end
    flag = false;
    i = i + 1;
end
release(videoReader); % close
close(output_video); % ����������� ����� ���������� ��������� �����������
end

function myColour = getColour(number)
switch mod(number, 8) % ��������� ������� �� ������� �� 8
    case 0
        myColour = 'blue';
    case 1
        myColour = 'green';
    case 2
        myColour = 'yellow';
    case 3
        myColour = 'magenta';
    case 4
        myColour = 'cyan';
    case 5
        myColour = 'red';
    case 6
        myColour = 'white';
    case 7
        myColour = 'black';
    otherwise
        myColour = 'black';
end
end