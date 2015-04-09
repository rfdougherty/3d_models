height = 8.0;
thick = 5.0;
width = 128.0;
length = 180.0;
base_width = 10.0;

$fn = 30;

rotate([180,0,0])
difference(){

  union(){
    for (x=[-1,-0.5,0,0.5,1]){
      rotate([90,0,0])
        translate([x*(length/2-height), 0, 0])
          cylinder(r=height, h=width, center=true);
    }
    for (y=[-1,0,1]){
      translate([0,y*(width/2-base_width/2),0])
        cube(size=[length,base_width,thick], center=true);
    }
  }

  translate([0,0,thick*sqrt(2)])
    cube(size=[length+.1,width+.1,thick*2], center=true);
}