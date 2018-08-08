
$fa = 3;
base_height = 10;
ped_height = 80;
hole_depth = 20;
base_diameter = 120;
ped_diameter = 20;
hole_diam = 4;

difference(){
  union(){
    translate([0,0,-base_height/2])
      cylinder(h=base_height, r=base_diameter/2, center=true);
    translate([0,0,-ped_height/2])
      cylinder(h=ped_height, r2=ped_diameter, r1=ped_diameter/2, center=true);
  }
  translate([0,0,-ped_height+hole_depth/2-.1])
    cylinder(h=hole_depth+.1, r=hole_diam/2, center=true);
}