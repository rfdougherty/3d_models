/*
Suggested infill: 30%, triangles

TODO: add a lip to lock lid in place. A + cylinder on one piece,
and a cooresponding - cylinder on the other
*/


$fs=0.2;

// NOTE: length/width/height are exterior dimensions. Interior dimensions 
// are thick*2 smaller than these.
thick = 2;
length = 58 + thick*2;
width= 35 + thick*2;
height = 12 + thick*2;
cornerRad = 2;
slop = 0.1;
wireRad = 3;
lidRimHeight = 4;
usb_width = 12;
usb_height = 5;
n_vents = 8;

// the rim on the lid will be a bit smaller than the box
lidThick = thick + 0.1;

snapRimRad = 0.5;
snapRimOffset = (thick + cornerRad) * 2;
snapRimDelta = 4; // the rims will be symmetric if this is a factor of width & length

centerWidth = width/2 - cornerRad;

translate([cornerRad, cornerRad, 0]){
  difference() {
    union() {
      // The main box
      difference() {
        roundedBox(length, width, height, cornerRad);
        translate([thick,thick,thick+slop])
          roundedBox(length-thick*2, width-thick*2, height-thick+slop, cornerRad);
      }
    }
    
    // Holes for vents
    for(y=[length/n_vents+cornerRad/2+thick: length/n_vents: length-length/n_vents+1]) 
      for(x=[0, width-cornerRad])
        translate([x-cornerRad/2-thick, y-cornerRad, height/2 - thick/2]) 
          rotate([0, 90, 0]) 
            cylinder(r=1.2, h=thick*2);
      
    // hole for usb
    translate([width/2 - usb_width/2 - cornerRad, thick/2, thick + usb_height/2])
      rotate([90, 0, 0])
        cube(size=[usb_width, usb_height, thick*2], center=false);
      
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
        for(x=[-width/2+snapRimOffset : snapRimDelta : width/2-snapRimOffset+1]) 
          for(y=[lidThick-cornerRad, length-lidThick-cornerRad])
            translate([x+width/2-cornerRad, y, thick+lidRimHeight/2])
              sphere(snapRimRad);
        // Add snap-rim spheres along long edges
        for(y=[-length/2+snapRimOffset : snapRimDelta : length/2-snapRimOffset+1]) 
          for(x=[lidThick-cornerRad, width-lidThick-cornerRad])
            translate([x, y+length/2-cornerRad, thick+lidRimHeight/2])
              sphere(snapRimRad);
      }
      translate([lidThick*2, lidThick*2, lidThick+slop])
        roundedBox(length-lidThick*4, width-lidThick*4, thick+lidRimHeight+slop, cornerRad);
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
