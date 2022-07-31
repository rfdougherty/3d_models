/*
Suggested infill: 30%, triangles

*/


$fs=0.2;

// NOTE: length/width/height are exterior dimensions. Interior dimensions 
// are thick*2 smaller than these.
length = 55; //4.1 * 25.4;
width= 55; //3.1 * 25.4;
height = 25; //1.6 * 25.4;
cornerRad = 3;
slop = 0.1;
thick = 2;
outRadius = 7.6;
lidRimHeight = 4;
buttonHoleRad = 1.5;
wireHoleRad = 2.5;

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
        // Opening for OLED
        // The board is 38 high (y) by 36 wide (x), with the 35x20 display centered left-right 
        // and 5mm from the top. Mounting holes are 34mm on-center along y and 31 along x.
        // Buttons are centered 4mm from the bottom and equally spaced along x. Ie., the 1st
        // is centered 9mm from the left, the 2nd centered at 18mm, and the 3rd at 27mm.
        // For y, the screen is 5mm from the top of the board. Putting the screen opening here
        // puts the top of the board 1mm from the inner upper wall of the box.
        board_top = -cornerRad + length - thick - 1;
        // The bottom edge of the screen is is 25mm from the top of the board
        translate([-cornerRad+width/2-35/2, board_top-25, -thick/2])
          cube([35, 20, thick*2]);
        // Buttons are centered at 34mm from the top of the board
        for(x=[-9, 0, 9])
          translate([-cornerRad+width/2-x, board_top-34, -thick/2])
            rotate([0, 0, 90])
              cylinder(r=buttonHoleRad, h=thick*2);
      }
      // Divider for battery compartment (a 14430 lithium cell is 14mm diameter x 53mm long)
      //translate([-cornerRad+thick/2, -cornerRad/2+15, thick])
      //  cube([width-thick, thick, 14]);
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
        // wire hole
        translate([-cornerRad+width/2, -cornerRad+wireHoleRad+thick, -thick/2])
          rotate([0, 0, 90])
            cylinder(r=wireHoleRad, h=thick*2 + lidRimHeight);
        translate([-cornerRad+width/2-wireHoleRad, -cornerRad, -thick/2])
          cube([wireHoleRad*2, thick*2, thick*2 + lidRimHeight]);
        // vent holes
        for(x=[-15: 5: 15])
          for(y=[-15, -10])
          translate([-cornerRad+width/2-x, -cornerRad+width/2-y, -thick/2])
            rotate([0, 0, 90])
              cylinder(r=1, h=thick*2);
        // hole for DHT sensor, which is 20 long x 15 wide. The long dimension also has a 
        // 5mm flange at the top and 27mm of board/wires at the bottom. 
        translate([-cornerRad+thick*2, -cornerRad+thick*2+5, -thick/2])
          cube([15, 20, thick*2 + lidRimHeight]);
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
