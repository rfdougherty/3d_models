
$fa = 1;
thick = 3;
base_height = 5; //10;
ped_height = 80;
base_diameter = 120;
ped_diameter_bottom = 20; //40;
ped_diameter_top = 15; //30;
hole_diam = 10; //15;
hole_depth = ped_height + 1;
cup_diameter = 80;
cup_height = 15;
peg_height = ped_height * 0.6;// ped_height - base_height*2;
peg_shrinkage = 0.12; //0.15;

//10mm diam x .7mm deep

translate([base_diameter/2-15, base_diameter/2-15, 0]){
  difference(){
    union(){
      translate([0, 0, base_height/2])
        cylinder(h=base_height, r=base_diameter/2, center=true);
      translate([0, 0, ped_height/2])
        cylinder(h=ped_height, r1=ped_diameter_bottom/2, r2=ped_diameter_top/2, 
                 center=true);
    }
    translate([0, 0, ped_height-hole_depth/2+.1])
      cylinder(h=hole_depth+.1, r=hole_diam/2, center=true);
  }
}

translate([-cup_diameter/2+5, -cup_diameter/2+5, 0]){
  union(){
    difference(){
      translate([0, 0, cup_height/2])
        cylinder(h=cup_height, r=cup_diameter/2, center=true);
      translate([0, 0, cup_height/2+thick]) //cup_depth
        cylinder(h=cup_height, r=cup_diameter/2-thick, center=true);
    }
    translate([0, 0, peg_height/2])
      cylinder(h=peg_height, r1=hole_diam/2-peg_shrinkage, 
               r2=hole_diam/2-peg_shrinkage*2, center=true);
  }
}