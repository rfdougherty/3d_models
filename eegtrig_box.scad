$fs=0.2;

length = 90; //4.1 * 25.4;
width= 55; //3.1 * 25.4;
height = 55; //1.6 * 25.4;
cornerRadius = 3;
slop = 0.1;
thick = 2.0;
wireRadius = 6;
ventRadius = 1.0;
usbRadius = 6;

lidSlop = 0.2; // the rim on the lid will be this much smaller than the box

centerWidth = width/2-cornerRadius;

translate([cornerRadius, cornerRadius, 0]){
  difference() {
    roundedBox(length, width, height, cornerRadius);
    translate([thick,thick,thick+slop])
      roundedBox(length-thick*2, width-thick*2, height-thick+slop, cornerRadius);

    // Hole for wires
    translate([centerWidth, -thick/3, height-(wireRadius/2)])
      rotate([90,0,0])
        cylinder(r=wireRadius, h=thick*2);
    //translate([centerWidth, length-thick, height-(wireRadius/2)])
    //  rotate([90,0,0])
    //    cylinder(r=wireRadius, h=thick*2);
    
    // Hole for usb
    //translate([-cornerRadius-slop, centerWidth-usbRadius, thick+usbRadius+slop])
    translate([centerWidth-usbRadius, length-thick, thick+usbRadius/2+slop])
      rotate([90,0,0])
        cube(size=[usbRadius*2,usbRadius,thick*2+slop*3]);
        //cylinder(r=usbRadius, h=thick+slop*3);

    // Vent holes
    for(x = [cornerRadius+15: 10: length-cornerRadius-15])
      translate([-cornerRadius-thick/2, x, thick+height/2-height/4]) 
        rotate([0,90,0]) 
          cylinder(r=ventRadius, h=thick*2);
    for(x = [cornerRadius+10: 10: length-cornerRadius-10])
      translate([-cornerRadius-thick/2, x, thick+height/2-height/4+10]) 
        rotate([0,90,0]) 
          cylinder(r=ventRadius, h=thick*2);
    for(x = [cornerRadius+15: 10: length-cornerRadius-15])
      translate([-cornerRadius-thick/2, x, thick+height/2-height/4+20]) 
        rotate([0,90,0]) 
          cylinder(r=ventRadius, h=thick*2); 
    
    for(x = [cornerRadius+15: 10: length-cornerRadius-15])
      translate([width-cornerRadius-thick*1.5, x, thick+height/2-height/4]) 
        rotate([0,90,0]) 
          cylinder(r=ventRadius, h=thick*2);
    for(x = [cornerRadius+10: 10: length-cornerRadius-10])
      translate([width-cornerRadius-thick*1.5, x, thick+height/2-height/4+10]) 
        rotate([0,90,0]) 
          cylinder(r=ventRadius, h=thick*2);
    for(x = [cornerRadius+15: 10: length-cornerRadius-15])
      translate([width-cornerRadius-thick*1.5, x, thick+height/2-height/4+20]) 
        rotate([0,90,0]) 
          cylinder(r=ventRadius, h=thick*2); 

  }
  
  // support for usb hole
  for(x = [-usbRadius/2.4, .9, usbRadius/1.4])
    translate([centerWidth - x, length-cornerRadius-thick, thick+usbRadius*1.5+slop])
    //translate([-cornerRadius, centerWidth-x, thick+usbRadius+slop])
      rotate([0,90,0])
        cube(size=[usbRadius+slop*4, thick, 1.2]);
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