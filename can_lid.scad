/*
lid for pet can food 
*/ 

$fa=1; 
$fs=0.2; 
//$fn = 360;
thickness = 1.7;
diam = 90.3; // adjust this to the diameter of your can
height = 9;
rim_diameter = 1.9;

// edit lid label in line 71

module lid(){
  translate([0, 0, 0,]){ //height]){
    difference(){
      cylinder(r=bg_circle, h=height);
      translate([0, 0, thickness])
        cylinder(r=(bg_circle-thickness), h=height);
    }
  }

  // Add a rim
  translate([0, 0, height-rim_diameter/2])
    rotate_extrude(convexity = 10) 
      translate([bg_circle-thickness, 0, 0]) 
        hull()
          circle(d = rim_diameter); 
}


lid();

