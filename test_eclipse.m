%% Initialization
clc; clear variables; close all;


%% Import orbit data
reportFileName = 'GMAT_Report.txt';
eclipseFileName = 'GMAT_Eclipse.txt';

orbit = test_fcn_read_data(reportFileName, eclipseFileName);


%% Calculate Eclipse
rEarth = 6371e3;
beta = 26.1;
rShadow = 

% set up eclipse number variables
eclipseNum = 1;
inEclipse = 0;

inEclipseGMAT = zeros(orbit.numSteps, 1);
inEclipseCalc = zeros(orbit.numSteps, 1);
r = zeros(orbit.numSteps, 2);

for i = 1:orbit.numSteps
    % solve equation of intersection https://math.stackexchange.com/questions/1939423/calculate-if-vector-intersects-sphere
    a = dot(orbit.satSunUnit(i,:), orbit.satSunUnit(i,:));
    b = 2 * dot(orbit.satSunUnit(i,:), orbit.satPos(i,:));
    c = dot(orbit.satPos(i,:), orbit.satPos(i,:)) - rEarth^2;
    
    % discriminant of quadratic equation, if negative then not eclipse
%     d(i) = b^2 - (4 * a * c);
    
    % if positive then check roots
%     if d(i) > 0
        r(i,:) = roots([a b c]);
        % if roots positive and non imaginary then in eclipse (intercetion is infront of
        % satellite)
        if r(i, 1) > 0 && r(i, 2) > 0 && imag(r(i, 1)) == 0 && imag(r(i, 2)) == 0
            inEclipseCalc(i) = 1;
        % else intersection is behind satellite so not in eclipse (sat is
        % infront of Earth
        else
            inEclipseCalc(i) = 0;
        end
%     end
    
    % GMAT eclipse data for comparison
    if (orbit.reportTime(i) > orbit.eclipseStart(eclipseNum) && orbit.reportTime(i) < orbit.eclipseStop(eclipseNum))
        inEclipseGMAT(i) = 1;
        inEclipse = 1;
    else
        inEclipseGMAT(i) = 0;
        if inEclipse == 1
            inEclipse = 0;
            % iterate eclipse number (check against max number of
            % eclipses)
            if eclipseNum < length(orbit.eclipseStart)
                eclipseNum = eclipseNum + 1;
            else
            end
        end
    end
end

find(inEclipseCalc ~= inEclipseGMAT)

range = 1:orbit.numSteps;
figure(1)
hold on
plot(range, inEclipseCalc(range))
plot(range, inEclipseGMAT(range))

