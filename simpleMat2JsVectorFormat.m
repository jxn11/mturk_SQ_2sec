toFormat = trialCodes;

fprintf('[')
for i = 1:length(toFormat)-1
    fprintf('%d',toFormat(i))
    fprintf(', ')
end
fprintf('%d',toFormat(end))
fprintf(']\n')