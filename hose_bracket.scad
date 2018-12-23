// small hose holder
$fs = 0.2;

length=150;
bar_size=50;
width=20;
height=30;
holder_height=20;
holder_width=20;
flange_width=115;
flange_length=15;
screw_size=5;
screw_head=10;
screw_offset=40;
screw_head_taper_depth=4;

difference() {
	//Create the Main Body
	union(){
		translate([0,-width/2, 0]) cube([length, width, height]);
		translate([0,-flange_width/2, 0]) cube([flange_length, flange_width, height]);
    translate([length-holder_width,-width/2,0]) cube([holder_width, width+holder_height, height]);
    
    rotate([0,0,45])
      translate([width/2, -width, 0]) 
        cube([width, width*1.5, height]);
    
    rotate([0,0,-45])
      translate([width/2, -width/2, 0]) 
        cube([width, width*1.5, height]);
	}
	
	rotate([0,90,0]) translate([-height/2, screw_offset, -.1]) 
    cylinder(r=screw_size/2, h=flange_length+.2);
  rotate([0,90,0]) translate([-height/2, screw_offset, flange_length-screw_head_taper_depth+.1]) 
    cylinder(r2=screw_head/2, r1=0, h=screw_head_taper_depth);
  
	rotate([0,90,0]) translate([-height/2, -screw_offset, -.1]) 
    cylinder(r=screw_size/2, h=flange_length+.2);
  rotate([0,90,0]) translate([-height/2, -screw_offset, flange_length-screw_head_taper_depth+.1]) 
    cylinder(r2=screw_head/2, r1=0, h=screw_head_taper_depth);
}	
