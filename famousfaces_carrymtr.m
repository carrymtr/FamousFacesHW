numTrials = 25; 
famousKey = KbName('LeftArrow'); %Response Keys
nonFamousKey = KbName('RightArrow'); 
escapeKey = KbName('ESCAPE'); %End Experiment

%Picture Upload
FamousFolder = 'C:\Documents\PLUS Universität\Matlab\Faces\FamousFaces';
NonFamousFolder = 'C:\Documents\PLUS Universität\Matlab\Faces\NonFamousFaces';

%Find Pics
FamousImages = dir(fullfile(FamousFolder, 'pic*.jpg'));
NonFamousImages = dir(fullfile(NonFamousFolder, 'pic*.jpg'));

%Screen Settings
try
    myScreen = max(Screen('Screens'));
    [myWindow, windowRect] = Screen('OpenWindow', myScreen, [128 128 128], [0 0 640 480]);
    
    for trial = 1:numTrials
        %Show random face usind rand
        if rand > 0.5
            faceType = 'famous';
            faceList = FamousImages;
            correctKey = famousKey;
        else
            faceType = 'nonfamous';
            faceList = NonFamousImages;
            correctKey = nonFamousKey;
        end
        
        % Load random face
        randomFace = faceList(randi(length(faceList))).name;
        if strcmp(faceType, 'famous')
            faceImage = imread(fullfile(FamousFolder, randomFace));
        else
            faceImage = imread(fullfile(NonFamousFolder, randomFace));
        end
        faceTexture = Screen('MakeTexture', myWindow, faceImage);
        
        % Show fixation cross
        DrawFormattedText(myWindow, '+', 'center', 'center', [255, 255, 255]);
        Screen('Flip', myWindow);
        WaitSecs(0.5);
        
        % Show noisy square (mask)
        maskTexture = Screen('MakeTexture', myWindow, rand(windowRect(4), windowRect(3)) * 255);
        Screen('DrawTexture', myWindow, maskTexture);
        Screen('Flip', myWindow);
        WaitSecs(0.5 + rand * 0.5);
        Screen('Close', maskTexture); % Close mask texture
        
        % Show face
        Screen('DrawTexture', myWindow, faceTexture);
        Screen('Flip', myWindow);
        faceOnset = GetSecs;
        WaitSecs(0.2); % Show face briefly
        Screen('Flip', myWindow); % Clear screen
        Screen('Close', faceTexture); % Close face texture
        
        % Record response
        responded = false;
        while ~responded
            [keyIsDown, secs, keyCode] = KbCheck;
            if keyIsDown
                if keyCode(famousKey) || keyCode(nonFamousKey)
                    reactionTime = secs - faceOnset;
                    responded = true;
                    responseKey = find(keyCode);
                elseif keyCode(escapeKey)
                    sca;
                    error('Experiment aborted by user.');
                end
            end
        end
        
        % Feedback
        if ismember(correctKey, responseKey)
            fprintf('Correct! RT: %.3f seconds\n', reactionTime);
        else
            fprintf('Incorrect! RT: %.3f seconds\n', reactionTime);
        end
        
        %Pause before next trial
        WaitSecs(1);
    end
    
    % Close screen
    sca;
catch ME
    sca;
    rethrow(ME);
end

!git init
!git add .
!git commit -m "Initial commit of MATLAB code"
!git remote add origin https://github.com/carrymtr/FamousFaces.git
!git push -u origin master