
$fa = 1;
base_height = 10;
ped_height = 80;
base_diameter = 120;
ped_diameter = 21;
nut_diameter = 12;
nut_depth = 6;
hole_diam = 5;
hole_depth = ped_height + 1;

//10mm diam x .7mm deep

difference(){
  union(){
    translate([0,0,base_height/2])
      cylinder(h=base_height, r=base_diameter/2, center=true);
    translate([0,0,ped_height/2])
      cylinder(h=ped_height, r1=ped_diameter, r2=ped_diameter/2, center=true);
  }
  translate([0,0,ped_height-nut_depth/2+.1])
    cylinder(h=nut_depth+.1, r=nut_diameter/2, center=true);
  translate([0,0,ped_height-hole_depth/2+.1])
    cylinder(h=hole_depth+.1, r=hole_diam/2, center=true);
}