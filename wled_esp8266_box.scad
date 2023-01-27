/*
Suggested infill: 30%, triangles
  esp32: l=50, w=50, h=30
esp8266: l=45, w=35, h=30
*/


$fs=0.2;
e = 0.01;

// NOTE: length/width/height are exterior dimensions. Interior dimensions 
// are thick*2 smaller than these.
length = 45; //4.1 * 25.4;
width= 40; //3.1 * 25.4;
height = 27; //1.6 * 25.4;
cornerRad = 3;
slop = 0.1;
thick = 1.6;
lidRimHeight = 4;
wireHoleRad = 4;
secondWireHole = false;
flange_hole_rad = 2;

vent_num = 5; // Set to 0 for no vent holes
vent_hole_rad = 0.7;

// the rim on the lid will be a bit smaller than the box
lidThick = thick + 0.1;

snapRimRad = 0.5;
snapRimOffset = (thick + cornerRad) * 2;
snapRimDelta = 5; // the rims will be symmetric if this is a factor of width & length

centerWidth = width/2-cornerRad;

translate([cornerRad, cornerRad, 0]){
  difference() {
    union() {
      // The main box
      difference() {
        roundedBox(length, width, height, cornerRad);
        translate([thick, thick, thick+slop])
          roundedBox(length-thick*2, width-thick*2, height-thick+slop, cornerRad);
      }
      // Divider for battery compartment (a 14430 lithium cell is 14mm diameter x 53mm long)
      //translate([-cornerRad+thick/2, -cornerRad/2+15, thick])
      //  cube([width-thick, thick, 14]);
      // flange
      //translate([0, -flange_hole_rad*3-cornerRad+0.01, 0])
      //  cube([width-cornerRad*2, flange_hole_rad*3, thick]);
      y = flange_hole_rad*7-cornerRad+0.01;
      x = width-cornerRad*2;
      s = flange_hole_rad*2;
      translate([0, -flange_hole_rad+0.01, 0])
        linear_extrude(thick)
          polygon( points=[[0,0],[x,0],[x,-y+s],[x-s,-y],[s,-y],[0,-y+s],[0,0]] );
          //polygon( points=[[0,0],[x,0],[x,y-5],[x-5,y],[5,y],[0,y-5],[0,0]] );
    }
    
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
    
    // wire hole one
    translate([-cornerRad+width/2, length-cornerRad-e, height-thick/2])
      rotate([90, 0, 0])
        cylinder(r=wireHoleRad, h=thick+2);
    if(secondWireHole) {
      // wire hole two
      translate([-cornerRad+width/2, -cornerRad/2+1, height-thick/2])
        rotate([90, 0, 0])
          cylinder(r=wireHoleRad, h=thick+2*e);
    }
    // flange screw holes
    translate([cornerRad*2, -flange_hole_rad*4, -1])
      cylinder(r=flange_hole_rad, h=thick+2);
    translate([width-cornerRad*4, -flange_hole_rad*4, -1])
      cylinder(r=flange_hole_rad, h=thick+2);
    translate([width/2-cornerRad, -flange_hole_rad*4, -1])
      cylinder(r=flange_hole_rad, h=thick+2);
  }
}

// Make the lid
translate([width*2+5, cornerRad, 0]){
  mirror([1,0,0]) {
    union() {
      difference() {
        union() {
          roundedBox(length, width, thick, cornerRad);
          translate([lidThick, lidThick, 0])
            roundedBox(length-lidThick*2, width-lidThick*2, thick+lidRimHeight, cornerRad);
  
          // Add snap-rim spheres along short edges
          for(x=[-width/2+snapRimOffset : snapRimDelta : width/2-snapRimOffset]) 
            for(y=[lidThick-cornerRad, length-lidThick-cornerRad])
              translate([x+width/2-cornerRad, y, thick+lidRimHeight/2])
                sphere(snapRimRad);
          // Add snap-rim spheres along long edges
          for(y=[-length/2+snapRimOffset : snapRimDelta : length/2-snapRimOffset]) 
            for(x=[lidThick-cornerRad, width-lidThick-cornerRad])
              translate([x, y+length/2-cornerRad, thick+lidRimHeight/2])
                sphere(snapRimRad);
        }
        // Hollow-out lid
        translate([lidThick*2, lidThick*2, lidThick+slop])
          roundedBox(length-lidThick*4, width-lidThick*4, thick+lidRimHeight+slop, cornerRad);
        
        // wire hole one
        translate([-cornerRad+width/2-wireHoleRad, length-cornerRad-thick*2.2, thick])
          cube([wireHoleRad*2, thick*2.2, thick*2 + lidRimHeight]);
        if(secondWireHole) {
          // wire hole two
          translate([-cornerRad+width/2-wireHoleRad, -cornerRad, thick])
            cube([wireHoleRad*2, thick*2.3, thick+lidRimHeight +e]);
        }
        
        // vent holes
        if(vent_num > 0) {
          rng = (width - cornerRad*2) / 2 - 8;
          spacing = rng / (vent_num - 1) * 2;
          for(x=[-rng: spacing: rng])
            for(y=[-rng: spacing: rng])
              translate([-cornerRad+width/2 + x, -cornerRad+length/2 + y, -0.1])
                rotate([0, 0, 90])
                  cylinder(r=vent_hole_rad, h=lidThick+0.3);
        }
      }
    }
  }
}


module roundedBox(length, width, height, radius){
  dRadius = 2*radius;
  //base rounded shape
  minkowski() {
    cube(size=[width-dRadius,length-dRadius, height]);
    cylinder(r=radius, h=0.01);
  }
}
