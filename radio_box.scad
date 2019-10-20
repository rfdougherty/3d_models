$fs=0.2;

// NOTE: length/width/height are exterior dimensions. Interior dimensions 
// are thick*2 smaller than these.
length = 165; //4.1 * 25.4;
width= 85; //3.1 * 25.4;
height = 40; //1.6 * 25.4;
cornerRadius = 3;
slop = 0.1;
thick = 2.0;
wireRadius = 6;
speakerRadius = 26;
lidRimHeight = 5;

lidSlop = 0.2; // the rim on the lid will be this much smaller than the box

centerWidth = width/2-cornerRadius;

translate([cornerRadius, cornerRadius, 0]){
  difference() {
    roundedBox(length, width, height, cornerRadius);
    translate([thick,thick,thick+slop])
      roundedBox(length-thick*2, width-thick*2, height-thick+slop, cornerRadius);

    // Hole for wires
    translate([-cornerRadius/2, length/2-wireRadius, -thick/2])
      cube(size=[wireRadius, wireRadius*2, thick*2], center=false);
    
    //rotate([0,90,0])
    //  translate([-width/2, length/2, -cornerRadius-thick])
    //    %cylinder(r=3, h=thick*3);
  }
}
// 75 wide, 30-58
// Make the lid
lidThick = thick + lidSlop/2;
translate([width*2+5, cornerRadius, 0]){
  mirror([1,0,0]) {
    difference() {
      union() {
        roundedBox(length, width, thick, cornerRadius);
        translate([lidThick, lidThick, 0])
          roundedBox(length-lidThick*2, width-lidThick*2, thick+lidRimHeight, cornerRadius);
      }
      translate([lidThick*2, lidThick*2, lidThick+slop])
        roundedBox(length-lidThick*4, width-lidThick*4, thick+lidRimHeight+slop, cornerRadius);

      // Hole for speakers
      translate([width/2-speakerRadius/2, speakerRadius+10-cornerRadius*2, -thick/2])
        rotate([0,0,90])
          cylinder(r=speakerRadius, h=lidThick*2);
      translate([width/2-speakerRadius/2, length-speakerRadius-10, -thick/2])
        rotate([0,0,90])
          cylinder(r=speakerRadius, h=lidThick*2);
      
      // hole for display
      translate([width-13, length/2-13-cornerRadius, -thick/2])
        rotate([0,0,90])
          cube(size=[26, 15, thick*2], center=false);
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
