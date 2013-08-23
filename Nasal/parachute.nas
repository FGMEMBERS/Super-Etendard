# ================================== Chute ==================================================

controls.deployChute = func(v){

	# Deploy
	if (v > 0){
		setprop("sim/model/MirageV/controls/flight/chute_deployed",1);
		setprop("sim/model/MirageV/controls/flight/chute_open",1);
		chuteAngle();
	}
	# Jettison
	if (v < 0){ 
		var voltage = getprop("systems/electrical/outputs/chute_jett");
		if (voltage > 20) {
			setprop("sim/model/MirageV/controls/flight/chute_jettisoned",1);
			setprop("sim/model/MirageV/controls/flight/chute_open",1);
		}
	}
}


var chuteAngle = func {

	var chute_open = getprop('sim/model/MirageV/controls/flight/chute_open');
	
	if (chute_open != '1') {return();}

	var speed = getprop('velocities/airspeed-kt');
	var aircraftpitch = getprop('orientation/pitch-deg[0]');
	var aircraftyaw = -getprop('orientation/side-slip-deg'); <!-- inverted after a change in side-slip sign (bug #901) -->
	var chuteyaw = getprop("sim/model/MirageV/orientation/chute_yaw");
	var aircraftroll = getprop('orientation/roll-deg');

	if (speed > 210) {
		setprop("sim/model/MirageV/controls/flight/chute_jettisoned", 1); # Model Shear Pin
		return();
	}

	# Chute Pitch
	var chutepitch = aircraftpitch * -1;
	setprop("sim/model/MirageV/orientation/chute_pitch", chutepitch);

	# Damped yaw from Vivian's A4 work
	var n = 0.01;
	if (aircraftyaw == nil) {aircraftyaw = 0;}
	if (chuteyaw == nil) {chuteyaw = 0;}
	var chuteyaw = ( aircraftyaw * n) + ( chuteyaw * (1 - n));	
	setprop("sim/model/MirageV/orientation/chute_yaw", chuteyaw);

	# Chute Roll - no twisting for now
	var chuteroll = aircraftroll;
	setprop("sim/model/MirageV/orientation/chute_roll", chuteroll*rand()*-1 );

	return registerTimerControlsNil(chuteAngle);	# Keep watching

} # end function

#var chuteRepack = func{#

	#setprop('sim/model/MirageV/controls/flight/chute_open', 0);#
	#setprop('sim/model/MirageV/controls/flight/chute_deployed', 0);#
	#setprop('sim/model/MirageV/controls/flight/chute_jettisoned', 0);#

 #}  end func	#

