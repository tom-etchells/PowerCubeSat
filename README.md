# PowerCubeSat
A CubeSat Power Modelling Tool

The Power Model still needs some work, especially the GUI, but it does currently work. Doumentation and a guide for direct user input for more complex geometries and attitudes are to follow.


# Orbit Data
To run an analysis, the desired orbit must first be simulated in GMAT. TO do so, open "OrbitScript.script" in GMAT. Before running the script, the file path for the Eclipse Locator must be set. To do this:
- Double click on the "EclipseLocator" in the Resources Tree on the left side of the screen, this should open an "EclipseLocator" window.
- Click the folder icon next to the Filename box on the "EclipseLocator" window, this should open a "Choose a file" window.
- Navigate to the current folder (the folder the GMAT script is in) in the "Choose a file" window.
- Type "Eclipse.txt" in the File Name box in the "Choose a file" window.
- Click open in the "Choose a file" window.

The Filename box in the "EclipseLocator" window should now read "<current_folder>\Eclipse.txt" (e.g. "C:\Users\Tom\Documents\PowerCubeSat\Eclipse.txt"). Now open "DefaultSC" and change the orbit like usual, open "Propagate" in the mission tab to change the simulation time.


# Running the GUI
Double click on "CubeSatPowerModel.mlapp" to run the GUI, the first tab has properties such as panel efficiency and mission lifetime and also shows results, the second tab lets you modify the geometry, and the third tab the attitude. The geometry and attitude customization still needs work to allow any configuration to be modelled.
