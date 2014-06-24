hole_size = 4;
side_wall = 4.0;
bottom_wall = 4;
touch_width = 160.4;
touch_length = 170.4;
touch_depth = 2.0;
wire_cut_depth = 4.0;
wire_cut_width = 10.0;
side_fillet_radius = 3.0;
bottom_fillet_radius = 3.0;

// Set the angular resolution ($fn segments per 360 deg)
$fn = 20;

box_height = bottom_wall + touch_depth;
box_width = touch_width+side_wall*2;
box_length = touch_length+side_wall*2;

module fillet(r, h) {
    translate([r / 2, r / 2, 0])
    difference() {
        cube([r + 0.01, r + 0.01, h], center = true);
        translate([r/2, r/2, 0])
          cylinder(r = r, h = h + 1, center = true);
    }
}

difference(){
    // Main box
    cube([box_width, box_length, box_height]);

    // cut-out the touch screen cavity
    //translate([side_wall+lip_width, side_wall+lip_width, bottom_wall])
    //  cube([trans_width-lip_width*2, trans_length-lip_width*2, box_height]);

    // cut for the touch screen
    translate([side_wall, side_wall, box_height-touch_depth])
      cube([touch_width, touch_length, touch_depth+0.1]);

    // outside cut for wires
    translate([box_width/2-20, side_wall*2, box_height-wire_cut_depth])
      cube([wire_cut_width, box_length*0.75-side_wall, wire_cut_depth*2]);

    // inside cut for wires
    translate([side_wall*3, box_length*0.75-wire_cut_width, box_height-wire_cut_depth])
      cube([box_width-side_wall*6, wire_cut_width*2, wire_cut_depth*2]);
    translate([side_wall*3, box_length*0.25-wire_cut_width, box_height-wire_cut_depth])
      cube([box_width-side_wall*6, wire_cut_width*2, wire_cut_depth*2]);

    // holes
    translate([wire_cut_width/2+box_width/2-20, side_wall*2+hole_size, -0.1])
      cylinder(r=hole_size/2, h=box_height);

    // fillets for the side edges
    fillet(side_fillet_radius, box_height*2);
    translate([box_width,0,0])
      rotate(a=[0,0,90])
        fillet(side_fillet_radius, box_height*2);
    translate([0,box_length,0])
      rotate(a=[0,0,270])
        fillet(side_fillet_radius, box_height*2);
    translate([box_width,box_length,0])
      rotate(a=[0,0,180])
        fillet(side_fillet_radius, box_height*2);

    // fillets for the two bottom length-wise edges
    rotate(a=[90,0,0])
      fillet(bottom_fillet_radius, box_length*2+.1);
    translate([box_width,0,0])
      rotate(a=[90,-90,0])
        fillet(bottom_fillet_radius, box_length*2+.1);
    // fillets for the two bottom width-wise edges
    rotate(a=[90,0,90])
      fillet(bottom_fillet_radius, box_width*2+.1);
    translate([0,box_length,0])
      rotate(a=[90,0,-90])
        fillet(bottom_fillet_radius, box_width*2+.1);
}
