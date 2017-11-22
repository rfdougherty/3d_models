$fn=200;

switch_r = 10;
length = 35;
width= switch_r*2+15;
height = switch_r*2+15;
cornerRadius = 3;
slop = 0.1;
thick = 1.5;
wire_width = 4;

translate([cornerRadius, cornerRadius, 0]){
  difference() {
    roundedBox(length, width, height, cornerRadius);
    translate([thick,thick,thick+slop])
      roundedBox(length-thick*2, width-thick*2, height-thick+slop, cornerRadius);
    // Hole for switch
    translate([width/2-cornerRadius, length-cornerRadius+slop, height/2])
      rotate([90,0,0])
        cylinder(r=switch_r, h=thick+slop*3);
    // Hole for wires
    translate([width/2-cornerRadius, -thick/2, height-(wire_width/2)])
      rotate([90,0,0])
        cylinder(r=wire_width, h=thick*2);
  }
}


translate([width*2+5, cornerRadius, 0]){
  mirror([1,0,0]) {
    roundedBox(length, width, thick, cornerRadius);
    difference() {
      translate([thick,thick,0])
        roundedBox(length-thick*2,width-thick*2,thick+4,cornerRadius);
      translate([thick*2,thick*2,0+slop])
          roundedBox(length-thick*4,width-thick*4,thick+4+slop,cornerRadius);    
    }
  }
}


module roundedBox(length, width, height, radius){
  dRadius = 2*radius;

  //cube bottom right
  //translate([width-dRadius,-radius,0])
  //  cube(size=[radius,radius,height+0.01]);

  //cube top left
  //translate([-radius,length-dRadius,0])
  //  cube(size=[radius,radius,height+0.01]);

  //base rounded shape
  minkowski() {
    cube(size=[width-dRadius,length-dRadius, height]);
    cylinder(r=radius, h=0.01);
  } 
}