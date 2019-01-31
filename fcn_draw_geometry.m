function fcn_draw_geometry(app, thisAxes)
% clear axes
cla(thisAxes)

% set new geometry
app.panel = fcn_set_geometry(app.U, app.depPanels, app.theta, app.normalDir);

% for each panel
for j = 1:length(app.panel)
    % draw the panel
    patch(thisAxes, app.panel{j}.points(:,1), app.panel{j}.points(:,2), app.panel{j}.points(:,3), app.panel{j}.color);
    
    % draw the panel normal
    fcn_plot_line(thisAxes, mean(app.panel{j}.points(:,1)), mean(app.panel{j}.points(:,2)), mean(app.panel{j}.points(:,3)), app.panel{j}.unitNormal(1), app.panel{j}.unitNormal(2), app.panel{j}.unitNormal(3), 'k', 100)
end

%% Functions
    function fcn_plot_line(thisAxes, x, y, z, i, j, k, C, mag)
        % plots line
        % x, y, z = starting point of line
        % i, j, k = direction of line (unit vecotr)
        % mag = length of line
        line(thisAxes, [x (x + i * mag)], [y (y + j * mag)], [z (z + k * mag)],'Color', C, 'LineWidth', 2)
    end
end