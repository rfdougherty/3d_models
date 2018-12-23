$fn=100;

length = 4 * 25.4;
width= 3 * 25.4;
height = 1.6 * 25.4;
cornerRadius = 3;
slop = 0.1;
thick = 2.0;
wire_width = 6;
vent_rad = 1.5;

centerWidth = width/2-cornerRadius;

translate([cornerRadius, cornerRadius, 0]){
  difference() {
    roundedBox(length, width, height, cornerRadius);
    translate([thick,thick,thick+slop])
      roundedBox(length-thick*2, width-thick*2, height-thick+slop, cornerRadius);

    // Hole for wires
    translate([centerWidth, -thick/3, height-(wire_width/2)])
      rotate([90,0,0])
        cylinder(r=wire_width, h=thick*2);
    translate([centerWidth, length-thick, height-(wire_width/2)])
      rotate([90,0,0])
        cylinder(r=wire_width, h=thick*2);
    
    // Vent holes
    //for(y = [thick+height/2-height/4: 10: thick+height/2+height/4])
    //y = thick+height/2-height/4;
    //  for(x = [cornerRadius+20: 10: length-cornerRadius-20])
    //    translate([-cornerRadius-thick/2, x, y]) 
    //      rotate([0,90,0]) 
    //        %cylinder(r=2, h=thick*2);

    for(x = [cornerRadius+15: 10: length-cornerRadius-15])
      translate([-cornerRadius-thick/2, x, thick+height/2-height/4]) 
        rotate([0,90,0]) 
          cylinder(r=vent_rad, h=thick*2);
    for(x = [cornerRadius+10: 10: length-cornerRadius-10])
      translate([-cornerRadius-thick/2, x, thick+height/2-height/4+10]) 
        rotate([0,90,0]) 
          cylinder(r=vent_rad, h=thick*2);
    for(x = [cornerRadius+15: 10: length-cornerRadius-15])
      translate([-cornerRadius-thick/2, x, thick+height/2-height/4+20]) 
        rotate([0,90,0]) 
          cylinder(r=vent_rad, h=thick*2); 
    
    for(x = [cornerRadius+15: 10: length-cornerRadius-15])
      translate([width-cornerRadius-thick*1.5, x, thick+height/2-height/4]) 
        rotate([0,90,0]) 
          cylinder(r=vent_rad, h=thick*2);
    for(x = [cornerRadius+10: 10: length-cornerRadius-10])
      translate([width-cornerRadius-thick*1.5, x, thick+height/2-height/4+10]) 
        rotate([0,90,0]) 
          cylinder(r=vent_rad, h=thick*2);
    for(x = [cornerRadius+15: 10: length-cornerRadius-15])
      translate([width-cornerRadius-thick*1.5, x, thick+height/2-height/4+20]) 
        rotate([0,90,0]) 
          cylinder(r=vent_rad, h=thick*2); 

  } 
}


translate([width*2+5, cornerRadius, 0]){
  mirror([1,0,0]) {
    roundedBox(length, width, thick, cornerRadius);
    difference() {
      translate([thick,thick,0])
        roundedBox(length-thick*2,width-thick*2,thick+4,cornerRadius);
      translate([thick*2,thick*2,0+slop])
          roundedBox(length-thick*4,width-thick*4,thick+4+slop,cornerRadius);    
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