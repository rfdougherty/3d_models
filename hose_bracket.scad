//Shoe Rack Hold Back

total_length=75;
bar_size=15;
bar_offset=55;
holdback_width=20;
holdback_height=10;
flange_width=60;
flange_length=5;
screw_size=4;
screw_offset=20;

hole_width=holdback_width/2;
hole_height=holdback_height*2;
hole_length=40;
hole_offset=10;

difference()
{
	//Create the Main Body
	union()
	{
		translate([0,-holdback_width/2, 0]) cube([total_length, holdback_width, holdback_height]);
		translate([0,-flange_width/2, 0]) cube([flange_length, flange_width, holdback_height]);
	}
	
	rotate([0,90,0]) translate([-holdback_height/2, screw_offset, -10]) cylinder(r=screw_size/2, h=50);
	rotate([0,90,0]) translate([-holdback_height/2, -screw_offset, -10]) cylinder(r=screw_size/2, h=50);

	translate([bar_offset,-bar_size*.3,-5]) cube([bar_size, holdback_width*2, holdback_height*2]);
	translate([hole_offset,-hole_width/2,-5]) cube([hole_length, hole_width, hole_height]);
}	
