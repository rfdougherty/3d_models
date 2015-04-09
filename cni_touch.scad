side_wall = 14.0;
bottom_wall = 6.0;
touch_width = 166.5;
touch_length = 107.0;
touch_depth = 3.5;
wire_cut_depth = 3.3;
wire_cut_width = 6.0;
wire_hole_radius = 2.7;
side_fillet_radius = 15.0;
bottom_fillet_radius = 3.5;
button_side = 7.2;
button_base_depth = 6.0;
button_cap_depth = 0;
button_cap_radius = 0;
wire_offset = 65 + side_wall;
touch_wire_cut_width = 17.0;
touch_wire_cut_length = 15.0;

// Set the angular resolution ($fn segments per 360 deg)
$fn = 40;

box_height = bottom_wall + touch_depth;
box_width = touch_width+side_wall*2;
box_length = touch_length+side_wall*2;
button_position = box_length/2;

module round(width = 50, height = 30, r = 10, center = false){
  translate([0, ((center == true) ? (-height / 2) : 0), 0]) union() {
	translate([-r, 0, 0]) square([width, height]);
	translate([0, r, 0]) square([width, height - 2 * r]);
	intersection(){
		translate([width - r, r, 0]) rotate([0, 0, -90]) square(r);
		translate([width - r, r, 0]) rotate([0, 0, -135]) square(r);
	}
	translate([width - r, r, 0]) circle(r, $fs = 0.3);	
	translate([width - r, height - r, 0]) circle(r, $fs = 0.3);	
  }
}

module round_corner(r=20, height=30, edger=10, center=false, negative=false) {
  rotate_extrude(convexity = 2) 
  if (negative == false) intersection() {
	  translate([0, -height, 0]) square([r, height * 2]);
	  round(width = r, height = height, r = edger, center = center);
  } else difference() {
	  translate([0, -1 - ((center == true) ? height / 2 : 0), 0]) square([r + edger, height + 2]);
	    mirror([1, 0, 0]) translate([-r * 2, 0, 0]) round(width = r, height = height, r = edger, center = center);
  }
}

t = side_fillet_radius;

difference(){
    // Main box
    hull(){
    //cube([box_width, box_length, box_height]);
    for(x=[t,box_width-t]) for(y=[t,box_length-t]) translate([x,y,0]) round_corner(r=side_fillet_radius, length=30, height=box_height, edger=bottom_fillet_radius, extrudecenter=false);
    }
    // cut-out the touch screen cavity
    //translate([side_wall+lip_width, side_wall+lip_width, bottom_wall])
    //  cube([trans_width-lip_width*2, trans_length-lip_width*2, box_height]);

    // cut for the touch screen
    translate([side_wall, side_wall, box_height-touch_depth+0.01])
      cube([touch_width, touch_length, touch_depth+0.01]);

    // cut for (lengthwise) wires
    translate([wire_offset-wire_cut_width/2, side_wall/2, box_height-touch_depth-wire_cut_depth])
      cube([wire_cut_width, button_position-side_wall/2+20, wire_cut_depth+0.1]);

    // cut for wire entry
    translate([wire_offset-wire_cut_width/2+wire_hole_radius, -0.1, box_height/2])
    rotate([-90,0,0]) 
      cylinder(r=wire_hole_radius, h=side_wall+.2);

    // cut for touch screen wire harness
    translate([wire_offset-touch_wire_cut_width/2, side_wall-touch_wire_cut_length/2, box_height-touch_depth-wire_cut_depth])
      cube([touch_wire_cut_width, touch_wire_cut_length, wire_cut_depth+1.5]);

    // cut for (width-wise) button wires
    translate([side_wall/2, button_position-wire_cut_width/2, box_height-touch_depth-wire_cut_depth+0.01])
      cube([box_width-side_wall, wire_cut_width, wire_cut_depth+0.01]);

    // cut for button bases
    translate([side_wall/2-button_side/2, button_position-button_side/2, box_height-button_base_depth+0.01])
      cube([button_side, button_side, button_base_depth]);
    translate([box_width-side_wall/2-button_side/2, button_position-button_side/2, box_height-button_base_depth+0.01])
      cube([button_side, button_side, button_base_depth]);

    // cut for button caps
    translate([side_wall/2, button_position, box_height-button_cap_depth+0.01])
      cylinder(r=button_cap_radius, h=button_cap_depth, $fn=100);
    translate([box_width-side_wall/2, button_position, box_height-button_cap_depth+0.01])
      cylinder(r=button_cap_radius, h=button_cap_depth, $fn=100);

}



// holes
//    for (x=[-1,0,1], y=[-1,0,1] ){
//        translate([x*hole_size*2+box_width/2, y*hole_size*2+box_length/2+trans_base/2, -0.1])
//          cylinder(r=hole_size/2, h=box_height);
//    }

//    // fillets for the side edges
//    fillet(side_fillet_radius, box_height*2, tran=[0,0,0], rot=[0,0,0]);
//    fillet(side_fillet_radius, box_height*2, tran=[box_width,0,0], rot=[0,0,90]);
//    fillet(side_fillet_radius, box_height*2, tran=[0,box_length,0], rot=[0,0,270]);
//    fillet(side_fillet_radius, box_height*2, tran=[box_width,box_length,0], rot=[0,0,180]);
//
//    // fillets for the two bottom length-wise edges
//    fillet(bottom_fillet_radius, box_length*2+.1, tran=[0,0,0], rot=[90,0,0]);
//    fillet(bottom_fillet_radius, box_length*2+.1, tran=[box_width,0,0], rot=[90,-90,0]);
//    // fillets for the two bottom width-wise edges
//    fillet(bottom_fillet_radius, box_width*2+.1, tran=[0,0,0], rot=[90,0,90]);
//    fillet(bottom_fillet_radius, box_width*2+.1, tran=[0,box_length,0], rot=[90,0,-90]);

//module fillet(r, h, tran=[0,0,0], rot=[0,0,0]) {
//    translate(tran)
//    rotate(a=rot)
//    translate([r/2, r/2, -0.1])
//    difference() {
//        cube([r+0.01, r+0.01, h+0.5], center=true);
//        translate([r/2, r/2, 0]) cylinder(r=r, h=h+0.5, center=true);
//    }
//}
