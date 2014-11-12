hole_size = 3;
side_wall = 17.0;
bottom_wall = 9.0;
touch_width = 166.0;
touch_length = 107.0;
touch_depth = 4.0;
wire_cut_depth = 4.0;
wire_cut_width = 4.0;
side_fillet_radius = 3.0;
bottom_fillet_radius = 3.0;
button_side = 13.0;
button_base_depth = 11.5;
button_cap_depth = 4.5;
button_cap_radius = 7.0;
wire_offset = touch_length/2 + side_wall;
touch_wire_cut_width = 20.0;
touch_wire_cut_length = 10.0;

// Set the angular resolution ($fn segments per 360 deg)
$fn = 20;

box_height = bottom_wall + touch_depth;
box_width = touch_width+side_wall*2;
box_length = touch_length+side_wall*2;
button_position = box_length/2;

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
      cube([touch_width, touch_length, touch_depth+0.01]);

    // cut for wires
    translate([wire_offset-wire_cut_width/2, 0, box_height-touch_depth-wire_cut_depth+0.01])
      cube([wire_cut_width, button_position+.1, wire_cut_depth]);

    // cut for touch screen wire harness
    translate([wire_offset-touch_wire_cut_width/2, side_wall-touch_wire_cut_length/2, box_height-touch_depth-wire_cut_depth+0.01])
      cube([touch_wire_cut_width, touch_wire_cut_length, wire_cut_depth]);

    // cut for button wires
    translate([side_wall/2, button_position-wire_cut_width/2, box_height-touch_depth-wire_cut_depth+0.01])
      cube([box_width-side_wall, wire_cut_width, wire_cut_depth]);

    // cut for button bases
    translate([side_wall/2-button_side/2, button_position-button_side/2, box_height-button_base_depth+0.01])
      cube([button_side, button_side, button_base_depth]);
    translate([box_width-side_wall/2-button_side/2, button_position-button_side/2, box_height-button_base_depth+0.01])
      cube([button_side, button_side, button_base_depth]);

    translate([side_wall/2, button_position, box_height-button_cap_depth+0.01])
      cylinder(r=button_cap_radius, h=button_cap_depth, $fn=100);
    translate([box_width-side_wall/2, button_position, box_height-button_cap_depth+0.01])
      cylinder(r=button_cap_radius, h=button_cap_depth, $fn=100);
    // holes
//    for (x=[-1,0,1], y=[-1,0,1] ){
//        translate([x*hole_size*2+box_width/2, y*hole_size*2+box_length/2+trans_base/2, -0.1])
//          cylinder(r=hole_size/2, h=box_height);
//    }

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
