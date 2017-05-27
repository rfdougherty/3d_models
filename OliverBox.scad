$fn=200;

length = 70;
width= 55;
height = 55;
cornerRadius = 5;
slop = 0.1;
thick = 1.5;
motor_width = 20;
motor_length = 15;

translate([cornerRadius, cornerRadius, 0]){
  difference() {
    roundedBox(length, width, height, cornerRadius);
    translate([thick,thick,thick+slop])
      roundedBox(length-thick*2, width-thick*2, height-thick+slop, cornerRadius);
    // Hole for switch
    translate([width/2-cornerRadius, length-cornerRadius+slop, height/2])
      rotate([90,0,0])
        cylinder(r=14, h=thick+slop*3);
    // Hole for motor
    translate([width/2-cornerRadius-motor_width/2, length/2-cornerRadius-motor_length/2, 0-slop]){
      cube(size=[motor_width, motor_length, thick+slop*3]);
    }
  }
  rotate([0,0,90])
    translate([15-cornerRadius,-width+cornerRadius+thick,0])
      cube(size=[thick,width-cornerRadius+thick*2,20]);
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