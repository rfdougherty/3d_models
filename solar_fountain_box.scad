$fn=200;

barrelRadius = 3.5;

length = 70;
width= 40;
height = 30;
cornerRadius = 3;
slop = 0.1;
thick = 2.0;

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
    
    // Holes for barrel connectors
    translate([-cornerRadius-slop, centerWidth-7, height-7-barrelRadius+slop])
      rotate([0,90,0])
        cylinder(r=barrelRadius, h=thick+slop*3);
    translate([-cornerRadius-slop, centerWidth+7, height-7-barrelRadius+slop])
      rotate([0,90,0])
        cylinder(r=barrelRadius, h=thick+slop*3);
    
    // pump wire hole
    translate([length-cornerRadius-thick-slop, centerWidth, height-barrelRadius/2-1])
      rotate([0,90,0])
        cylinder(r=barrelRadius, h=thick+slop*3);
  }
  
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
      translate([6-cornerRadius,2,-0.1])
        cube(size=[4, 16, thick*2]);
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