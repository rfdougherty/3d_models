height = 2.0;
servo_w = 12.1;
servo_l = 24.1;
side = 5.0;
servo_ow = servo_w + side*2;
servo_ol = servo_l + side*2;
screw_rad = 0.8;
screw_off = 2.0;
mount_rad = 1.9;
mount_wide = 15 + side - 3;

module servo(h){
  difference(){
    cube(size=[servo_ow, servo_ol, h], center=true);
    cube(size=[servo_w, servo_l, h+.01], center=true);
    for(x=[-servo_ow/2, servo_ow/2]) 
      for(y=[-servo_ol/2, servo_ol/2])
        translate([x, y, 0]) 
          rotate([0,0,45]) 
            cube(size=[side+0.1, side+0.1, h+.01], center=true);
    translate([0, servo_l/2+screw_off, 0]) 
      cylinder(r=screw_rad, h=h+.01,center=true);
    translate([0, -(servo_l/2+screw_off), 0]) 
      cylinder(r=screw_rad, h=h+.01,center=true);
  }
}


$fa = 8;
$fs = 0.3;

servo(h=height);
difference(){
  translate([servo_ow/2 + mount_wide/2 - side, 0, 0])
    cube(size=[mount_wide-2, servo_ol, height], center=true);
  for(y=[-12, 0, 12]) 
      translate([servo_w/2 + mount_wide/2, y, -.01]) 
        cylinder(r=mount_rad, h=height*2+.1, center=true);
}


