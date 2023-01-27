// Adapted from http://www.thingiverse.com/thing:100764 to fit
// common 7W single-AA flashlights such as the Ultrafire
// http://www.amazon.com/UltraFire-300lm-Flashlight-Torch-Adjustable/dp/B006E0QAFY/
// I simplfied the code a bit and added a lip to better accomodate the barrell.

handlebarDiameter = 22.5;
fudj = 0.5;
flashlightDiameter1 = 26.0; // 22.5 for Ultrafire barrell, 17.5 for handle
flashlightDiameter2 = 26.0; // 25.0, 20.0 for ?
lip = 7;
addedThickness = 1.2;
$fn = 60;

handlebarD = handlebarDiameter + fudj;
length = handlebarD + 6;
circumradius1 = flashlightDiameter1/2 + fudj;
circumradius2 = flashlightDiameter2/2 + fudj;

yOffset = -handlebarD/2 - flashlightDiameter1/2 - .5;

difference() {
	union() {
		flashlightMount();
		handlebarMount();
	}
	#zipCutouts();
}

module flashlightMount() {
	difference() {
		outer();
		flashlightBody();
		cutout();
	}
}

module handlebarMount() {
	difference() {
        // The +0.5 on yOffset reduces overhang to avoid the need for support
		translate([-(flashlightDiameter1-3)/2, yOffset + 0.5, -length/2])
			cube(size=[flashlightDiameter1-3, handlebarD, length], center=false);
		translate([0,yOffset - 3,0])
			rotate([0,90,0]) cylinder(r=handlebarD/2, h=length, center=true);
		cylinder(r=circumradius1, h=length+1, center=true, $fn=60);
	}
}

module zipCutouts() {
    if(flashlightDiameter1>20){
	    translate([flashlightDiameter1/2 - 7,2,0]) zipCutout();
	    translate([-(flashlightDiameter1/2 - 7),2,0]) zipCutout();
    }else{
        translate([0,2,0]) zipCutout();
    }
}
module zipCutout() {
	translate([0,yOffset - 5,0]) rotate([0,90,0])
	    rotate_extrude() translate([handlebarD/2 + 1.25 + 2, 0, 0])
		    square(size=[2.5, 6], center=true);
}

module flashlightBody() {
    translate([0,0,lip+.1])
	    cylinder(r=circumradius1, h=length+.1, center=true, $fn=60);
    translate([0,0,-lip-.1])
        cylinder(r=circumradius2, h=length+.1, center=true, $fn=60);
}

outerYOff = -2;
module outer() {
	translate([0,outerYOff,0]) cylinder(r=circumradius1 + addedThickness, h=length, center=true);
    for(a=[40, 180-40, 15, 180-15])
        rib(a);
}

module rib(angle, extent=3) {
	r = 2;
	translate([
		(circumradius1+addedThickness-r/2) * cos(angle), 
		(circumradius1+addedThickness-r/2) * sin(angle) + outerYOff,
		0
	]) 
		rotate([0,0,angle])
		scale([1,extent,1])
		cylinder(r=r, h=length, center=true);
}

module cutout() {
	translate([0, flashlightDiameter1/3, 0]) 
		cylinder(r=circumradius1 + addedThickness, h=length+3, center=true, $fn=4);

}