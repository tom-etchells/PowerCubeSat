function panel = fcn_set_geometry(U, depPanels, theta, normalDir)
% Dimensions in mm using standrard 3U cubesat coord system
% (http://www.cubesat.org/s/spec_dwgs_rev13cds.pdf)

% Points must be defined in a clockwise order when looking at the side of
% the panel with the solar panels on

% set satellite body length in mm
satLength = (U * 113.5);


%% Body Panels
% +ve x panel
panel{1}.points(1,:) = [50 50 satLength/2];
panel{1}.points(2,:) = [50 50 -satLength/2];
panel{1}.points(3,:) = [50 -50 -satLength/2];
panel{1}.points(4,:) = [50 -50 satLength/2];
panel{1}.unitNormal = calc_normals(panel{1}, 0);
panel{1}.color = 'r';

% -ve x panel
panel{2}.points(1,:) = [-50 50 -satLength/2];
panel{2}.points(2,:) = [-50 50 satLength/2];
panel{2}.points(3,:) = [-50 -50 satLength/2];
panel{2}.points(4,:) = [-50 -50 -satLength/2];
panel{2}.unitNormal = calc_normals(panel{2}, 0);
panel{2}.color = 'g';

% +ve y panel
panel{3}.points(1,:) = [-50 50 satLength/2];
panel{3}.points(2,:) = [-50 50 -satLength/2];
panel{3}.points(3,:) = [50 50 -satLength/2];
panel{3}.points(4,:) = [50 50 satLength/2];
panel{3}.unitNormal = calc_normals(panel{3}, 0);
panel{3}.color = 'b';

% -ve y panel
panel{4}.points(1,:) = [50 -50 satLength/2];
panel{4}.points(2,:) = [50 -50 -satLength/2];
panel{4}.points(3,:) = [-50 -50 -satLength/2];
panel{4}.points(4,:) = [-50 -50 satLength/2];
panel{4}.unitNormal = calc_normals(panel{4}, 0);
panel{4}.color = 'c';

% +ve z panel
panel{5}.points(1,:) = [-50 50 satLength/2];
panel{5}.points(2,:) = [50 50 satLength/2];
panel{5}.points(3,:) = [50 -50 satLength/2];
panel{5}.points(4,:) = [-50 -50 satLength/2];
panel{5}.unitNormal = calc_normals(panel{5}, 0);
panel{5}.color = 'm';

% -ve z panel
panel{6}.points(1,:) = [50 50 -satLength/2];
panel{6}.points(2,:) = [-50 50 -satLength/2];
panel{6}.points(3,:) = [-50 -50 -satLength/2];
panel{6}.points(4,:) = [50 -50 -satLength/2];
panel{6}.unitNormal = calc_normals(panel{6}, 0);
panel{6}.color = 'y';


%% Deployable Panels
numPanels = 6;
% +ve x dp
if depPanels(1) == true
    numPanels = numPanels + 1;
    panel{numPanels}.points(1,:) = [(50 + satLength * sind(theta)) 50 (-satLength/2 + satLength * cosd(theta))];
    panel{numPanels}.points(2,:) = [50 50 -satLength/2];
    panel{numPanels}.points(3,:) = [50 -50 -satLength/2];
    panel{numPanels}.points(4,:) = [(50 + satLength * sind(theta)) -50 (-satLength/2 + satLength * cosd(theta))];
    panel{numPanels}.unitNormal = calc_normals(panel{numPanels}, normalDir);
    panel{numPanels}.color = 'r';
end

% -ve x dp
if depPanels(2) == true
    numPanels = numPanels + 1;
    panel{numPanels}.points(1,:) = [-50 50 -satLength/2];
    panel{numPanels}.points(2,:) = [-(50 + satLength * sind(theta)) 50 (-satLength/2 + satLength * cosd(theta))];
    panel{numPanels}.points(3,:) = [-(50 + satLength * sind(theta)) -50 (-satLength/2 + satLength * cosd(theta))];
    panel{numPanels}.points(4,:) = [-50 -50 -satLength/2];
    panel{numPanels}.unitNormal = calc_normals(panel{numPanels}, normalDir);
    panel{numPanels}.color = 'g';
end

% +ve y dp
if depPanels(3) == true
    numPanels = numPanels + 1;
    panel{numPanels}.points(1,:) = [-50 (50 + satLength * sind(theta)) (-satLength/2 + satLength * cosd(theta))];
    panel{numPanels}.points(2,:) = [-50 50 -satLength/2];
    panel{numPanels}.points(3,:) = [50 50 -satLength/2];
    panel{numPanels}.points(4,:) = [50 (50 + satLength * sind(theta)) (-satLength/2 + satLength * cosd(theta))];
    panel{numPanels}.unitNormal = calc_normals(panel{numPanels}, normalDir);
    panel{numPanels}.color = 'b';
end

% -ve y dp
if depPanels(4) == true
    numPanels = numPanels + 1;
    panel{numPanels}.points(1,:) = [-50 -50 -satLength/2];
    panel{numPanels}.points(2,:) = [-50 -(50 + satLength * sind(theta)) (-satLength/2 + satLength * cosd(theta))];
    panel{numPanels}.points(3,:) = [50 -(50 + satLength * sind(theta)) (-satLength/2 + satLength * cosd(theta))];
    panel{numPanels}.points(4,:) = [50 -50 -satLength/2];
    panel{numPanels}.unitNormal = calc_normals(panel{numPanels}, normalDir);
    panel{numPanels}.color = 'c';
end


%% Functions
    function unitNormal = calc_normals(panel, normalDir)
        % calculate panel unit normals
        switch normalDir
            case 0
                normal = (cross((panel.points(4,:) - panel.points(1,:)), (panel.points(2,:) - panel.points(1,:))));
            case 1
                normal = (cross((panel.points(2,:) - panel.points(1,:)), (panel.points(4,:) - panel.points(1,:))));
        end
        unitNormal = normal / norm(normal);
    end
end