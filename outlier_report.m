%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outlier report
% Import stats summary report and 
% Provide listing of SD outliers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sd_limit = 1.5; % Standard deviation limit

% Initialize variables.
filename = 'C:\Users\Jsmith\Desktop\raw_data.csv';
delimiter = ',';
startRow = 2;
formatSpec = '%s%C%C%f%f%f%f%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter,...
  'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError',...
  false, 'EndOfLine', '\r\n');
fclose(fileID);
itable = table(dataArray{1:end-1}, 'VariableNames', {'SubjID','Sequence',...
  'Correction','Left_Hippocampus','Right_Hippocampus',...
  'Hippocampus','eTIV','TBV','volGM','volWM'});
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

for i = 4:width(itable)
  c = table2array(itable(:,i));
  c_mean = mean(c);
  c_sd = std(c);
  c_sd_high = c_mean + sd_limit * c_sd;
  c_sd_low = c_mean - sd_limit * c_sd;
  range = sprintf("%2.2f - %2.2f",min(c),max(c));
  sprintf("Value = %2.2f Mean = %2.2f SD = %2.2f Range = %s",i,c_mean,c_sd,range)
  sprintf("Minimum threshold = %2.2f \nMaximum threshold = %2.2f\n",c_sd_low,c_sd_high)
  for j = 1:height(itable)
    subj = table2array(itable(j,1));
    r = table2array(itable(j,i));
    if r > c_sd_high
      sprintf("Subject: %s High value: %2.2f",subj,r)
    elseif r < c_sd_low
      sprintf("Subject: %s Low value: %2.2f",subj,r)
    else
      sprintf("Subject: %s Normal value: %2.2f",subj,r) 
    end
  end
end
