function fcn_draw_attitude(app, thisAxes)
% clear axes
cla(thisAxes)

% set new attitude
app.attitude = fcn_set_attitude(app.orbit, app.attitudeMode, app.refBody, app.bodyAlignmentVector, app.bodyConstraintVector, app.tumblingRates);

app.orbitPosition = floor(app.orbitPosition);

% draw earth
rE = 6371e3;
[xE,yE,zE] = sphere;
earth = surf(thisAxes, xE*rE, yE*rE, zE*rE);
set(earth,'FaceColor',[0 0 1],'FaceAlpha',0.5);

% scaling for initial geometry size and orbit radius
scaleSize = 6e3;
scaleRad = 1.15;

% plot scaled orbit
plot3(thisAxes, (app.orbit.satPos(app.orbitIndex, 1) .* scaleRad), (app.orbit.satPos(app.orbitIndex, 2) .* scaleRad), (app.orbit.satPos(app.orbitIndex, 3) .* scaleRad), 'k-', 'LineWidth', 2)

% initial direction of positive Z axis of geometry
a1 = [0 0 1];
% desired final direction of positive Z axis
b1 = app.attitude.satPositiveZ(app.orbitPosition,:);

% first rotation matrix
R1 = axis_angle_rot(a1, b1);

% apply first rotation to all points
for j = 1:length(app.panel)
    app.panel{j}.attitudePoints(:,:,app.orbitPosition) = (R1 * app.panel{j}.points(:,:).').';
end

% new initial direction for positive X axis of geometry
% normal of panel 1 is positive X direction, cross of vector 1-4 and 1-2
% gives the normal
a2 = cross((app.panel{1}.attitudePoints(4,:,app.orbitPosition) - app.panel{1}.attitudePoints(1,:,app.orbitPosition)), (app.panel{1}.attitudePoints(2,:,app.orbitPosition) - app.panel{1}.attitudePoints(1,:,app.orbitPosition)));
a2 = a2 ./ norm(a2);

% desired final direction of positive X axis
b2 = app.attitude.satPositiveX(app.orbitPosition,:);

% second rotation matrix
R2 = axis_angle_rot(a2, b2);

for j = 1:length(app.panel)
    % apply second rotation to all points
    app.panel{j}.attitudePoints(:,:,app.orbitPosition) = (R2 * app.panel{j}.attitudePoints(:,:,app.orbitPosition).').';
    
    % apply scaling and shifting to all points
    app.panel{j}.attitudePoints(:,:,app.orbitPosition) = (app.panel{j}.attitudePoints(:,:,app.orbitPosition) .* scaleSize) + app.orbit.satPos(app.orbitPosition,:) * scaleRad;
    
    % draw each panel
    patch(thisAxes, app.panel{j}.attitudePoints(:,1,app.orbitPosition), app.panel{j}.attitudePoints(:,2,app.orbitPosition), app.panel{j}.attitudePoints(:,3,app.orbitPosition), app.panel{j}.color);
end

end


function R = axis_angle_rot(a, b)
    ssc = @(v) [0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
    
    v = cross(a, b);
    R = eye(3) + ssc(v) + ssc(v)^2 * ((1 - dot(a, b)) / norm(v)^2);
end