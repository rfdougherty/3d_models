thick = 5.0;
width = 10.0;
length = 40.0;
hole_rad = 4.0/2;
cone_rad = 8.0/2;
cone_depth = 3.0;

$fn = 40;

difference(){
  cube(size=[length,width,thick], center=true);
  for (x=[-.6,.6]){
      translate([x*(length/2), 0, -.01])
        cylinder(r=hole_rad, h=thick+.05, center=true);
      translate([x*(length/2), 0, thick-cone_depth])
        cylinder(r=hole_rad, r2=cone_rad, h=cone_depth+.01, center=true);
  }
}