# PowerCubeSat
A CubeSat Power Modelling Tool

The Power Model presented here is essentially a minimum working example. An overhaul of the GUI and the internal data structures is currently in the works. Documentation and a guide for direct user input for more complex geometries and attitudes are to follow.

The power model has been validated against Thales Alenia Space's power model. Further validation, especially against actual on-orbit satellite power data, is planned any assistance would be welcome.

Contact tom.etchells@bristol.ac.uk for any queries or assistance.


# Orbit Data
To run an analysis, the desired orbit must first be simulated in GMAT, to do so open "OrbitScript.script" in GMAT. To change the satellites orbit, open "DefaultSC" and change the orbit like usual. To change the simulation time, open "Propagate" in the mission tab and changed the elapsed days.

The GMAT script should produce a file called 'GMAT_Report.txt', the file must currently be named correctly for the power model to work.


# Running the GUI
Double click on "CubeSatPowerModel.mlapp" to run the GUI, the first tab has properties such as panel efficiency and mission lifetime and also shows results, the second tab lets you modify the geometry, and the third tab the attitude. The geometry and attitude customization still needs work to allow any configuration to be modelled.
