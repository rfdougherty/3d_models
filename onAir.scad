$fn=200;

length = 180;
width= 80;
height = 30;
cornerRadius = 3;
slop = 0.1;
thick = 2.0;
usbRadius = 5;

boardHoleWidth = 25;
boardHoleLength = 52.5;

stripWidth = 9;

fontFam = "Boston Traffic"; // "Boston Traffic", "Black Ops One", "Lintsec", "Major Snafu"
fontSize = 44;

centerWidth = width/2-cornerRadius;
postHeight = usbRadius-1;

// main box
translate([cornerRadius, cornerRadius, 0]){
  difference() {
    roundedBox(width, length, height, cornerRadius);
    
    translate([thick,thick,thick+slop])
      roundedBox(width-thick*2, length-thick*2, height-thick+slop, cornerRadius);
    
    // Hole for usb
    translate([-cornerRadius-slop, centerWidth-usbRadius, thick+usbRadius+slop])
      rotate([0,90,0])
        cube(size=[usbRadius,usbRadius*2,thick+slop*3]);
        //cylinder(r=usbRadius, h=thick+slop*3);
  }
  
  // support for usb hole
  for(x = [-usbRadius+2.6, 0.3, usbRadius-2])
    translate([-cornerRadius, centerWidth-x, thick+usbRadius+slop])
      rotate([0,90,0])
        cube(size=[usbRadius+slop*2,0.6,thick]);
  
  rotate([0,0,90]) {
    // strips for LEDs
    translate([centerWidth-stripWidth/2, -length+cornerRadius, thick-slop])
      cube(size=[stripWidth, length-cornerRadius+thick*2-(boardHoleLength+10), postHeight+2]);
    translate([centerWidth-20-stripWidth/2, -length+cornerRadius, thick-slop])
      cube(size=[stripWidth, length-cornerRadius+thick+slop, postHeight+2]);
    translate([centerWidth+20-stripWidth/2, -length+cornerRadius, thick-slop])
      cube(size=[stripWidth, length-cornerRadius+thick+slop, postHeight+2]);
  
    // posts
    post(centerWidth-boardHoleWidth/2, -1, postHeight);
    post(centerWidth+boardHoleWidth/2, -1, postHeight);
    post(centerWidth-boardHoleWidth/2, -boardHoleLength-1, postHeight);
    post(centerWidth+boardHoleWidth/2, -boardHoleLength-1, postHeight);
  }
}

// box top
difference() {
translate([length-cornerRadius, width+5, 0]){
  mirror([1,0,0]) {
    roundedBox(width, length, thick, cornerRadius);
    difference() {
      translate([thick,thick,0])
        roundedBox(width-thick*2,length-thick*2,thick+4,cornerRadius);
      translate([thick*2,thick*2,0+slop])
          roundedBox(width-thick*4,length-thick*4,thick+4+slop,cornerRadius);    
    }
  }
}
translate([length/2, width+width/2, -slop])
  mirror()
    text3d("ON AIR", thick+slop*2);
}

module text3d(txt, height) {
	// Use linear_extrude() to make the letters 3D objects as they
	// are only 2D shapes when only using text()
	linear_extrude(height=height+slop*2) {
		text(txt, size=fontSize, font=fontFam, halign="center", valign="center", $fn=16);
	}
}

module post(x, y, h) {
  translate([x, y, thick-slop]) {
    difference() {
      cylinder(r=2.5, h=h+slop);
      cylinder(r=0.8, h=h+slop*2);
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