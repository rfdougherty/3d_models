use <dsub.scad>

$fn=200;

length = 65;
width= 40;
height = 30;
cornerRadius = 3;
slop = 0.1;
thick = 2.0;
usbRadius = 5;

boardHoleWidth = 25;
boardHoleLength = 52.5;

stripWidth = 9;

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
    // posts
    //post(centerWidth-boardHoleWidth/2, -1, postHeight);
    //post(centerWidth+boardHoleWidth/2, -1, postHeight);
    //post(centerWidth-boardHoleWidth/2, -boardHoleLength-1, postHeight);
    //post(centerWidth+boardHoleWidth/2, -boardHoleLength-1, postHeight);
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
  translate([length-cornerRadius, width+5, 0])
    rotate([0,0,90]) 
      translate([width/2-cornerRadius,10,thick/2])
        scale([1,1,thick*2])
          dsub("db9F", 0);
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