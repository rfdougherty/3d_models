$fs=0.2;

length = 85; //4.1 * 25.4;
width= 45; //3.1 * 25.4;
height = 35; //1.6 * 25.4;
cornerRadius = 3;
slop = 0.1;
thick = 2.0;
wireRadius = 5;

lidSlop = 0.2; // the rim on the lid will be this much smaller than the box

centerWidth = width/2-cornerRadius;

translate([cornerRadius, cornerRadius, 0]){
  difference() {
    roundedBox(length, width, height, cornerRadius);
    translate([thick,thick,thick+slop])
      roundedBox(length-thick*2, width-thick*2, height-thick+slop, cornerRadius);

    // Hole for wires
    translate([centerWidth, -thick/3, height-(wireRadius/1.1)])
      rotate([90,0,0])
        cylinder(r=wireRadius, h=thick*2);

  }
}

// Make the lid
lidThick = thick + lidSlop/2;
translate([width*2+5, cornerRadius, 0]){
  mirror([1,0,0]) {
    roundedBox(length, width, thick, cornerRadius);
    difference() {
      translate([lidThick, lidThick, 0])
        roundedBox(length-lidThick*2, width-lidThick*2, thick+4, cornerRadius);
      translate([lidThick*2, lidThick*2, 0+slop])
        roundedBox(length-lidThick*4, width-lidThick*4, thick+4+slop, cornerRadius);    
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