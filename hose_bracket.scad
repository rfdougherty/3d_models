// small hose holder
$fn = 16;

length=120;
bar_size=50;
width=15;
height=20;
holder_height=15;
holder_width=10;
flange_width=80;
flange_length=10;
screw_size=4;
screw_head=8;
screw_offset=30;

hole_width=holdback_width/2;
hole_height=holdback_height*2;
hole_length=40;
hole_offset=10;

difference() {
	//Create the Main Body
	union(){
		translate([0,-width/2, 0]) cube([length, width, height]);
		translate([0,-flange_width/2, 0]) cube([flange_length, flange_width, height]);
    translate([length-holder_width,-width/2,0]) cube([holder_width, width+holder_height, height]);
    translate([holder_width/2,-width,0]) cube([holder_width, width+holder_height, height]);

	}
	
	rotate([0,90,0]) translate([-height/2, screw_offset, -.1]) 
    cylinder(r=screw_size/2, h=flange_length+.2);
  rotate([0,90,0]) translate([-height/2, screw_offset, width/2]) 
    cylinder(r2=screw_head/2, r1=0, h=3);
  
	rotate([0,90,0]) translate([-height/2, -screw_offset, -.1]) 
    cylinder(r=screw_size/2, h=flange_length+.2);
  rotate([0,90,0]) translate([-height/2, -screw_offset, width/2]) 
    cylinder(r2=screw_head/2, r1=0, h=3);
}	
