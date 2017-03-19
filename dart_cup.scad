// Outside diameter of cone base. (All measurements are in millimeters!!)
cone_diameter = 17.0;
// Height of cone.
cone_height = 10;
//Thickness of cone walls.
wall = 0.6;
// Outside diameter of neck.
neck_diameter = 5.0;
// Height of neck.
neck_height = 15; //5
// Diameter of hole for dart.
hole_size = 3.0; // 2
hole_depth = 12;
tip_diameter = 0; //6

module dart(){
union() {
  difference() {
    // bottom cylinder
    cylinder(h=cone_height, r1=cone_diameter/2, r2=neck_diameter/2, center=false, $fn=40);
    // inside cylinder
    translate([0,0,-.01])
      cylinder (h=cone_height-wall, r1=cone_diameter/2-wall, r2=neck_diameter/2-wall, center=false, $fn=40);
  }
  difference() {
    // neck
    difference() {
      translate([0,0,cone_height]) 
        cylinder(h=neck_height, r=neck_diameter/2, $fn=40);
      // shaft hole
      translate([0,0,neck_height+cone_height-hole_depth])
        cylinder(h=hole_depth+.1, r=hole_size/2, $fn=40);
    }
  }
  if(tip_diameter>0)
    translate([0,0,neck_height+cone_height])
      sphere(r=tip_diameter/2, center=false, $fn=40);
}
}

d = cone_diameter/2 + 3;
for(x=[-d,d]) 
  for(y=[-d,d])
    translate([x,y,0]) dart();

    