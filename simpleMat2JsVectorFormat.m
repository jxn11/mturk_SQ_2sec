fprintf('[')
for i = 1:length(shuffTrials)-1
    fprintf('%d',shuffTrials(i))
    fprintf(', ')
end
fprintf('%d',shuffTrials(end))
fprintf(']')