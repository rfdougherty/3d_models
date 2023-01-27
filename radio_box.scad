/*
Suggested infill: 30%, triangles

TODO: add a lip to lock lid in place. A + cylinder on one piece,
and a cooresponding - cylinder on the other
*/


$fs=0.2;

// NOTE: length/width/height are exterior dimensions. Interior dimensions 
// are thick*2 smaller than these.
length = 200; //4.1 * 25.4;
width= 64; //3.1 * 25.4;
height = 50; //1.6 * 25.4;
cornerRad = 3;
slop = 0.1;
thick = 3; // was 2
wireRad = 3;
speakerRadius = 26;
lidRimHeight = 6;

// the rim on the lid will be a bit smaller than the box
lidThick = thick + 0.1;

snapRimRad = 0.5;
snapRimOffset = (thick + cornerRad) * 2;
snapRimDelta = 8; // the rims will be symmetric if this is a factor of width & length

centerWidth = width/2-cornerRad;

translate([cornerRad, cornerRad, 0]){
  difference() {
    union() {
      // The main box
      difference() {
        roundedBox(length, width, height, cornerRad);
        translate([thick,thick,thick+slop])
          roundedBox(length-thick*2, width-thick*2, height-thick+slop, cornerRad);
      }
      // Add the acoustic dividers
      for(y=[speakerRadius*2+12-thick, length-speakerRadius*2-12]) {
        translate([-cornerRad, y-cornerRad, 0]) {
          difference() {
            // divider
            cube([width, thick, height]);
            // lower cutout for lid rim and wires (1mm)
            translate([thick, -thick/2, height-lidRimHeight+.01-1]) 
              cube([thick+0.3, thick*2, lidRimHeight+1.1]);
            // upper cutout for lid rim
            translate([width-thick*2-0.3, -thick/2, height-lidRimHeight+.01]) 
              cube([thick+0.3, thick*2, lidRimHeight+0.1]);
          }
        }
      }
    }
    // Holes for touch contacts
    for(x=[height/2 - 5, height/2 + 5]) 
      for(y=[-20, 0, 20])
        translate([-cornerRad/2+width-thick*2, length/2+y-cornerRad, -thick/2 + x]) 
          rotate([0, 90, 0]) 
            cylinder(r=0.7, h=thick*2);
    
      // Hole for speakers
      translate([width/2-speakerRadius/2+10, speakerRadius+10-cornerRad*2, -thick/2])
        rotate([0,0,90])
          cylinder(r=speakerRadius, h=lidThick*2);
      translate([width/2-speakerRadius/2+10, length-speakerRadius-10, -thick/2])
        rotate([0,0,90])
          cylinder(r=speakerRadius, h=lidThick*2);
      
      // hole for display
      translate([width-13, length/2-13-cornerRad, -thick/2])
        rotate([0, 0,90])
          cube(size=[26, 15, thick*2], center=false);
      
      // snap-rim (hollowed-out cyliner) on the short sides
      for(y=[thick-cornerRad, length-thick-cornerRad])
        translate([snapRimDelta-cornerRad-1, y, height-(lidRimHeight/2)])
          rotate([0, 90, 0])
            cylinder(r=snapRimRad, h=width-snapRimDelta*2+2);
      // snap-rim on the long sides
      for(x=[thick-cornerRad, width-thick-cornerRad])
        translate([x, snapRimDelta-cornerRad-1, height-(lidRimHeight/2)])
          rotate([-90, 0, 0])
            cylinder(r=snapRimRad, h=length-snapRimDelta*2+2);
  }
}


// Make the lid
translate([width*2+5, cornerRad, 0]){
  mirror([1,0,0]) {
    difference() {
      union() {
        roundedBox(length, width, thick, cornerRad);
        translate([lidThick, lidThick, 0])
          roundedBox(length-lidThick*2, width-lidThick*2, thick+lidRimHeight, cornerRad);

        // Add snap-rim spheres along short edges
        for(x=[-width/2+snapRimOffset:snapRimDelta:width/2-snapRimOffset]) 
          for(y=[lidThick-cornerRad, length-lidThick-cornerRad])
            translate([x+width/2-cornerRad, y, thick+lidRimHeight/2])
              sphere(snapRimRad);
        // Add snap-rim spheres along long edges
        for(y=[-length/2+snapRimOffset:snapRimDelta:length/2-snapRimOffset]) 
          for(x=[lidThick-cornerRad, width-lidThick-cornerRad])
            translate([x, y+length/2-cornerRad, thick+lidRimHeight/2])
              sphere(snapRimRad);
      }
      translate([lidThick*2, lidThick*2, lidThick+slop])
        roundedBox(length-lidThick*4, width-lidThick*4, thick+lidRimHeight+slop, cornerRad);

      // Hole for wires
      translate([-cornerRad/2 + wireRad/2 + thick, length/2-wireRad, -thick/2]) {
        cylinder(r=wireRad, h=(lidThick+lidRimHeight)*2);
        translate([-wireRad-thick-.1, -wireRad, 0.1]) 
          cube([thick*2, wireRad*2, lidThick+lidRimHeight+3]);
      } 
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
