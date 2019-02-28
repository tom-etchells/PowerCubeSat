function orbit = fcn_read_data(reportFileName)
%% Extract orbit data
% open file
fileID = fopen(reportFileName,'r');
% skip header line
fgetl(fileID);
% get orbital period
orbit.orbitalPeriod = str2double(fgetl(fileID));

% skip header line
fgetl(fileID);
% extract position and velocity data into array
reportData = textscan(fileID,'%s %s %s %s %f %f %f %f %f %f %f %f %f','Delimiter',' ','MultipleDelimsAsOne',1);
fclose(fileID);

% get date and time data
dateString = strcat(reportData{1,1}(:),'-',reportData{1,2}(:),'-',reportData{1,3}(:),{' '},reportData{1,4}(:));
orbit.reportTime = datetime(dateString,'InputFormat','dd-MMM-yyyy HH:mm:ss.SSS');
% get total number of steps
orbit.numSteps = length(orbit.reportTime);


%% Create unit vector arrays for each timestep
% Create sat position array, column 1 = x, 2 = y, 3 = z
orbit.satPos(:,1) = reportData{1,5}(:)*10^3;
orbit.satPos(:,2) = reportData{1,6}(:)*10^3;
orbit.satPos(:,3) = reportData{1,7}(:)*10^3;

% Create sat radius array
orbit.satRad = sqrt(sum(orbit.satPos.^2, 2));

% Create satellite nadir direction unit vector array
orbit.satNadir = -orbit.satPos ./ sqrt(sum(orbit.satPos.^2, 2));

% Create sun position array, column 1 = x, 2 = y, 3 = z,
sunPos(:,1) = reportData{1,11}(:)*10^3;
sunPos(:,2) = reportData{1,12}(:)*10^3;
sunPos(:,3) = reportData{1,13}(:)*10^3;

% Create sat to sun vector array
satSun = sunPos - orbit.satPos;
% Create sat to sun unit vector array
orbit.satSunUnit = satSun ./ sqrt(sum(satSun.^2, 2));

% Create sat velocity array, column 1 = xV, 2 = yV, 3 = zV,
satVel(:,1) = reportData{1,8}(:)*10^3;
satVel(:,2) = reportData{1,9}(:)*10^3;
satVel(:,3) = reportData{1,10}(:)*10^3;
% Create sat velocity unit vector array
orbit.satVelUnit = satVel ./ sqrt(sum(satVel.^2, 2));
end