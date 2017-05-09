% [data,str] = xlsread('Batch_2789954_batch_results.csv');

files = dir('C:\Experiments\mturk_SQ_2sec\Results');
dataFiles = cell(length(files),1);
fileCounter = 1;
for iFile = 1:length(files)
    if regexp(files(iFile).name, regexptranslate('wildcard','Batch_*_batch_results.csv'))
       dataFiles{fileCounter} = files(iFile).name;
       fileCounter = fileCounter+1;
   end
end
dataFiles = dataFiles(~cellfun(@isempty, dataFiles));

omniTally = [];
loopCount = 0;
for iFile = 1:length(dataFiles) % loop through the data files


[data,str] = xlsread(dataFiles{iFile});

goodSubIdx = find(data(:,40) > 0); % check for the participants who have responded to the first trial
numSubs = length(goodSubIdx);
    
responses = data(goodSubIdx,40:end);
conds = str(goodSubIdx+1,43:end);

allData = zeros(120,3,numSubs); %preallocate space for formatted data (trials x data fields x participants)

resp = zeros(120,numSubs);
trialNum = 1;

for iSub = 1:numSubs
    for iResp = 1:5:size(responses,2)

    resp(trialNum,iSub) = responses(iSub,iResp);
    
    trialNum = trialNum + 1;
    end
    trialNum = 1;
end

%% organize lang conditions
langMat = zeros(120,numSubs);
trialNum = 1;

for iSub = 1:numSubs
    for iTrial = 1:5:600 %size(conds,2)
        
        switch conds{iSub,iTrial}
            case 'Eng,Eng'
                langMat(trialNum,iSub) = 1;
            case 'Eng,Kor'
                langMat(trialNum,iSub) = 2;
            case 'Kor,Kor'
                langMat(trialNum,iSub) = 3;
            case 'Kor,Eng'
                langMat(trialNum,iSub) = 4;
            otherwise
                langMat(trialNum,iSub) = NaN;
        end
        trialNum = trialNum + 1;
    end
    trialNum = 1;
end

%% organize seg lengths
padding = zeros(numSubs,2);
responses = [padding, responses]; %add padding to align the cell array and matrix

segMat = zeros(120,numSubs);
trialNum = 1;

for iSub = 1:numSubs
    for iTrial = 4:5:size(responses,2)
        
        switch responses(iSub,iTrial)
            case 60120
                segMat(trialNum,iSub) = 2;
            case 120240
                segMat(trialNum,iSub) = 3;
            case 240480
                segMat(trialNum,iSub) = 4;
            case 480960
                segMat(trialNum,iSub) = 5;
            case 9601920
                segMat(trialNum,iSub) = 6;
            case 240120
                segMat(trialNum,iSub) = 9;
            case 480240
                segMat(trialNum,iSub) = 10;
            case 960480
                segMat(trialNum,iSub) = 11;
            case 1920960
                segMat(trialNum,iSub) = 12;
            otherwise
                switch conds{iSub,iTrial}
                    case '30,60'
                        segMat(trialNum,iSub) = 1;
                    case '60,30'
                        segMat(trialNum,iSub) = 7;
                    case '120,60'
                        segMat(trialNum,iSub) = 8;
                    otherwise
                        segMat(trialNum,iSub) = NaN;
                end
        end
        trialNum = trialNum + 1;
    end
    trialNum = 1;
end

%% Organize matrices into 3D trial matrix

%(trials x data fields x participants)
% data fields: language condition, segment length condition, participant
% response

allData(:,1,:) = langMat;
allData(:,2,:) = segMat;
allData(:,3,:) = resp;

% Preallocate the matrix to hold num correct responses
% Format: segment length cond x lang cond x participant
correctTally = zeros(2,4,numSubs);

totals = zeros(2,4,numSubs);

for iSub = 1:numSubs
for langCond = 1:4
    
   condIdx = find(allData(:,1,iSub) == langCond);
   
   totals(1,langCond,iSub) = length(find(allData(condIdx,2,iSub) < 7));
   totals(2,langCond,iSub) = length(find(allData(condIdx,2,iSub) > 6));
   
   for iTrial = 1:length(condIdx)
      
       if allData(condIdx(iTrial),2,iSub) < 7 % short segment first
           
           if allData(condIdx(iTrial),3,iSub) == 1 % correct response
               correctTally(1,langCond,iSub) = correctTally(1,langCond,iSub)+1;
           end
           
       else % long segment first
           
           if allData(condIdx(iTrial),3,iSub) == 2 % correct response
               correctTally(2,langCond,iSub) = correctTally(2,langCond,iSub)+1;
           end
           
       end
       
   end
    
end
end

%% Calculate Percentages

percentages = zeros(2,4,numSubs);

for i = 1:2
    for j = 1:4
        for k = 1:numSubs
            
            percentages(i,j,k) = correctTally(i,j,k)/totals(i,j,k);
            
        end
    end
end

if loopCount < 1
    omniTally = percentages;
else
    omniTally = cat(3,omniTally,percentages);
end
loopCount = loopCount+1;

end % end the data file loop

%% Plot the Results

omniPercent = sum(omniTally,3)/size(omniTally,3);

omniErrors = zeros(size(omniTally,1),size(omniTally,2));
for i = 1:size(omniTally,1)
    for j = 1:size(omniTally,2)
        omniErrors(i,j) = std(omniTally(i,j,:))/size(omniTally,3);
    end
end

cmap = brewermap(2,'set1');

[~,barHandle,errorHandle] = errorbar_groups(omniPercent,omniErrors,'bar_colors',cmap);
set(gca,'XTick',1.5:2:7.5,'XTickLabel',{'Eng-Eng','Eng-Kor','Kor-Kor','Kor-Eng'});

legend([barHandle],{'Short-Long','Long-Short'});

ylabel('Percent Accuracy');
title(['Two-Second Speech Quilts: Short Segment Identification Rates (n=' num2str(size(omniTally,3)) ')']);
