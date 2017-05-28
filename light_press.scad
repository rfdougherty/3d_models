$fn=200;

slop = 0.1;

sensor_width = 4 + 0.5;
sensor_length = 6 + 0.5;
length = 30;
width= 30;
height = 33;
corner = 5;
thick = 2;
motor_width = 20;
motor_length = 15;

translate([corner, corner, 0]){
  difference() {
    roundedBox(length, width, height, corner);
    translate([thick,thick,thick+slop])
      roundedBox(length-thick*2, width-thick*2, height-thick+slop, corner);
    
    // Hole for finger
    translate([width/2-corner, length-corner+slop, height/2])
      rotate([90,0,0])
        cylinder(r=12, h=2*thick+slop*3);
    translate([width/2-corner-12, length-corner+slop, height/2])
      rotate([90,0,0])
        cube(size=[24, 24, 2*thick+slop*3]);

    // Hole for sensor
    translate([width/2-corner-sensor_width/2, length/2-corner-sensor_length/2, 0-slop]){
      cube(size=[sensor_width, sensor_length, thick+slop*3]);
    }
    
    // Cut a slope
    rotate([135,0,0])
      translate([-corner-5, 6, -height*1.5])
        cube(size=[width+10, length, length*2]);
  }
  //rotate([0,0,90])
  //  translate([15-cornerRadius,-width+cornerRadius+thick,0])
  //    cube(size=[thick,width-cornerRadius+thick*2,20]);
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