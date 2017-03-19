$fn = 50;
thickness = 4;
height = 45 + thickness;
width = 26 + 2*thickness;
hole_distance = 6;
hole_size = 4.2;

depth = 2*hole_distance + 2*thickness;


module corner_support() {
  union() {
    // Side vertical support + screw hole
    difference() {
      union() {
        translate([0, thickness, 0]) 
          cube([thickness, width-2*thickness,  depth]);
        hull() {
  	  	  translate([0, width/2, height-width/2]) 
            rotate([0, 90, 0]) 
              cylinder(r=width/4, h= thickness);
  	  	  translate([0, 2*thickness, depth]) 
            rotate([0, 90, 0]) 
              cylinder(r=thickness, h=thickness);
  	  	  translate([0, width-2*thickness, depth]) 
            rotate([0, 90, 0]) 
              cylinder(r=thickness, h=thickness);
        }
  	  }
  	  translate([-thickness, width/2, height-width/2]) 
        rotate([0, 90, 0]) 
          cylinder(r=hole_size/2, h=3*thickness);
	}

	// Bottom horizontal support
    difference() {
	  cube([depth, width, thickness]);
      translate([thickness/2 + depth/2, width/4+thickness/2, -thickness]) 
        rotate([0, 0, 90]) 
          cylinder(r=hole_size/2, h=3*thickness);
      translate([thickness/2 + depth/2, width/4*3-thickness/2, -thickness]) 
        rotate([0, 0, 90]) 
          cylinder(r=hole_size/2, h=3*thickness);
    }

	// Front vertical support + screw hole
	difference() {
  	  hull() {
	  	translate([0, 0, 0]) 
          cube([depth, thickness, thickness]);
	  	translate([0, 0, 0]) 
          cube([thickness, thickness, depth]);
	  	translate([thickness + hole_distance, 0, thickness + hole_distance]) 
          rotate([-90, 0, 0]) 
            cylinder(r=hole_size/2+thickness, h= thickness);
  	  }
  	  translate([thickness + hole_distance, -thickness, thickness + hole_distance]) 
        rotate([-90, 0, 0]) 
          cylinder(r=hole_size/2, h=3*thickness);
	}

	// Back vertical support + screw hole
	difference() {
  	  hull() {
	  	translate([0, width-thickness, 0]) 
          cube([depth, thickness, thickness]);
        translate([0, width-thickness, 0]) 
          cube([thickness, thickness, depth]);
        translate([thickness + hole_distance, width-thickness, thickness + hole_distance]) 
          rotate([-90, 0, 0]) 
            cylinder(r=hole_size/2+thickness, h= thickness);
  	  }
  	  translate([thickness + hole_distance, width-2*thickness, thickness + hole_distance]) 
        rotate([-90, 0, 0]) 
          cylinder(r=hole_size/2, h=3*thickness);
	}
  }
}

translate([-3,-width/2,0]) rotate([0, -90, 0]) corner_support();
translate([3,width/2,0]) rotate([0, -90, 180]) corner_support();
