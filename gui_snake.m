clear all 
close all
clc

%% slide 3 - snake
nRows = 5;
nCols = 4;
dx = 0.1;
dy = 0.1;

field = [nRows, nCols];
dir = 'right';
snake = [6,1];
colors = [1 1 1; 1 0 0];

fig = figure('WindowKeyPressFcn', @funArrowKey);
playButton = uicontrol(fig, 'Style', 'pushbutton', ...
   'Units', 'normalized', ...
   'String', 'Play', ...
   'Position', [0.75, 0.45, 0.2, 0.1], ...
   'Callback', @pushPlay);

editObjects = gobjects(nRows, nCols);
for iR = 1:nRows
   for iC = 1:nCols
      editObjects(iR, iC) = uicontrol(fig, 'Style', 'edit', ...
         'Units', 'normalized', ...
         'Position', [0.05 + (iC-1)*dx, 0.9 - (iR)*dy, dx, dy], ...
         'BackgroundColor', colors(1, :), ...
         'Enable', 'inactive');
      
      if ismember((iC-1)*nRows + iR, snake)
         editObjects(iR, iC).BackgroundColor = colors(2,:);
      end
   end
end

setappdata(fig, 'handles', editObjects);
setappdata(fig, 'snake', snake);
setappdata(fig, 'dir', dir);
setappdata(fig, 'field', field);
setappdata(fig, 'colors', colors);

function pushPlay(hObject, eventdata, handles)
mainFig = hObject.Parent;
if strcmp(hObject.String, 'Play')
    hObject.String = 'Pause';
else
   hObject.String = 'Play';
end
while 1
    % drawnow()
   if strcmp(hObject.String, 'Play')
      % pause the game
      break
   else
      turnOffSnake(mainFig)
      updateSnake(mainFig)
      plotSnake(mainFig)
      
      pause(0.5)
   end
end
end

function turnOffSnake(hFig)
snake = getappdata(hFig, 'snake');
colors = getappdata(hFig, 'colors');
handles = getappdata(hFig, 'handles');
for iS = 1:size(snake,2)
   handles(snake(iS)).BackgroundColor = colors(1, :);
end
end

function plotSnake(hFig)
snake = getappdata(hFig, 'snake');
colors = getappdata(hFig, 'colors');
handles = getappdata(hFig, 'handles');
for iS = 1:size(snake,2)
   handles(snake(iS)).BackgroundColor = colors(2, :);
end
end

function updateSnake(hObject)
dir = getappdata(hObject, 'dir');
snake = getappdata(hObject, 'snake');
field = getappdata(hObject, 'field');

[r, c] = ind2sub(field, snake(1));
switch dir
   case 'left'
      c = c - 1;
      if c == 0
         c = field(2);
      end
   case 'right'
      c = c + 1;
      if c > field(2)
         c = 1;
      end
   case 'up'
      r = r - 1;
      if r == 0
         r = field(1);
      end
      
   case 'down'
      r = r + 1;
      if r > field(1)
         r = 1;
      end
end
newPos = sub2ind(field, r, c);
snake = [newPos, snake(1:end-1)];
setappdata(hObject, 'snake', snake);
end

function funArrowKey(hObject, eventdata, handles)
key = eventdata.Key;
if strcmp(key, 'rightarrow')
   comDir = 'right';
elseif strcmp(key, 'leftarrow')
   comDir = 'left';
end

oldDir = getappdata(hObject, 'dir');
dirString = [oldDir, comDir];
updateDir(hObject, dirString);
end

function updateDir(mainFig, comStr)
switch comStr
   case 'leftright'
      newDir = 'up';
   case 'leftleft'
      newDir = 'down';
   case 'rightright'
      newDir = 'down';
   case 'rightleft'
      newDir = 'up';
   case 'upright'
      newDir = 'right';
   case 'upleft'
      newDir = 'left';
   case 'downright'
      newDir = 'left';
   case 'downleft'
      newDir = 'right';
   otherwise
      % Go on
end

setappdata(mainFig, 'dir', newDir)
end