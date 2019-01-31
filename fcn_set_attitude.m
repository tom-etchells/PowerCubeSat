function attitude = fcn_set_attitude(orbit, attitudeMode, refBody, bodyAlignmentVector, bodyConstraintVector, tumblingRates)

% if strcmp(attitudeMode, 'Nadir')
    %% Nadir / Sun Pointing
    % reference body 0 = nadir (Earth), 1 = Sun
    
    % set up body vectors
    satBodyX = zeros(orbit.numSteps,3);
    satBodyY = zeros(orbit.numSteps,3);
    satBodyZ = zeros(orbit.numSteps,3);
    
    satBodyX(:,1) = 1;
    satBodyY(:,2) = 1;
    satBodyZ(:,3) = 1;
    
    for i = 1:orbit.numSteps
        % initial direction of body constraint vector
        bodyConstraintVector = bodyConstraintVector ./ norm(bodyConstraintVector);
        a1 = bodyConstraintVector;
        
        % desired final direction of body constraint vector
        b1 = orbit.satVelUnit(i,:);
        
        % first rotation matrix
        R1 = axis_angle_rot(a1, b1);
        
        % apply first rotation to all vectors
        bodyAlignmentVector = bodyAlignmentVector ./ norm(bodyAlignmentVector);
        newBodyAlignmentVector = R1 * bodyAlignmentVector.';
        satBodyX(i,:) = (R1 * satBodyX(i,:).').';
        satBodyY(i,:) = (R1 * satBodyY(i,:).').';
        satBodyZ(i,:) = (R1 * satBodyZ(i,:).').';
        
        
        % new initial direction for body alignment vector
        a2 = newBodyAlignmentVector;
        a2 = a2 ./ norm(a2);
        
        % desired final direction of body alignment vector
        if refBody == 0
            b2 = orbit.satNadir(i,:);
        elseif refBody == 1
            b2 = orbit.satSunUnit(i,:);
        end
        
        % second rotation matrix
        R2 = axis_angle_rot(a2, b2);
        
        % apply second rotation matrix TODO(could apply in one go R2 * R1 *
        % vector?)
        satBodyX(i,:) = (R2 * satBodyX(i,:).');
        satBodyY(i,:) = (R2 * satBodyY(i,:).');
        satBodyZ(i,:) = (R2 * satBodyZ(i,:).');
    end
    % return attitude data
    attitude.satPositiveX = satBodyX;
    attitude.satPositiveY = satBodyY;
    attitude.satPositiveZ = satBodyZ;
    
    
% elseif strcmp(attitudeMode, 'Tumbling')
%     %% Tumbling
%     % set up body vectors
%     satBodyX = zeros(orbit.numSteps,3);
%     satBodyY = zeros(orbit.numSteps,3);
%     satBodyZ = zeros(orbit.numSteps,3);
%     
%     % initial direction
%     satBodyX(1, :) = [1 0 0];
%     satBodyY(1, :) = [0 1 0];
%     satBodyZ(1, :) = [0 0 1];
%     
%     % add random tumbling for each timestep
%     for i = 2:orbit.numSteps
%         dt = seconds(orbit.reportTime(i) - orbit.reportTime(i - 1));
%         rotX = tumblingRates(1) * dt;
%         rotY = tumblingRates(2) * dt;
%         rotZ = tumblingRates(3) * dt;
%         satBodyX(i, :) = (satBodyX(i - 1, :));
%         satBodyY(i, :) = (satBodyY(i - 1, :));
%         satBodyZ(i, :) = (satBodyZ(i - 1, :));
%         
%         
%     end
%     % return attitude data
%     attitude.satPositiveX = satBodyX;
%     attitude.satPositiveY = satBodyY;
%     attitude.satPositiveZ = satBodyZ;
% end
end


%% Functions
function R = axis_angle_rot(a, b)
ssc = @(v) [0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];

v = cross(a, b);
R = eye(3) + ssc(v) + ssc(v)^2 * ((1 - dot(a, b)) / norm(v)^2);
end