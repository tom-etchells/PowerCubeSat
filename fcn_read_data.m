function orbit = fcn_read_data(reportFileName, eclipseFileName)
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


%% Extract eclipse data
% open file and read eclipse data
fileID = fopen(eclipseFileName,'r');
% skip first 3 lines (header lines)
fgetl(fileID);fgetl(fileID);fgetl(fileID);

% extract eclipse data into array
eclipseData = textscan(fileID,'%s %s %s %s %s %s %s %s %f %s %s %d %f','Delimiter',' ','MultipleDelimsAsOne',1);
fclose(fileID);

% remove last 4 lines (textscan ignores the blacnk lines so this removes
% the 4 info lines at the end of the Eclipse file)
len = length(eclipseData{1}) - 4;

% get eclipse start data
dateString = strcat(eclipseData{1,1}(1:len),'-',eclipseData{1,2}(1:len),'-',eclipseData{1,3}(1:len),{' '},eclipseData{1,4}(1:len));
orbit.eclipseStart = datetime(dateString,'InputFormat','dd-MMM-yyyy HH:mm:ss.SSS');
orbit.numEclipses = length(orbit.eclipseStart);
% get eclipse stop data
dateString = strcat(eclipseData{1,5}(1:len),'-',eclipseData{1,6}(1:len),'-',eclipseData{1,7}(1:len),{' '},eclipseData{1,8}(1:len));
orbit.eclipseStop = datetime(dateString,'InputFormat','dd-MMM-yyyy HH:mm:ss.SSS');


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