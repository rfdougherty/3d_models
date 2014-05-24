hole_size = 4;
side_wall = 2.5;
bottom_wall = 4.0;
touch_width = 163.0;
touch_length = 85.8;
touch_depth = 2.4;
wire_cut_depth = 5.0;
wire_cut_width = 20.0;
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

module box(){
  difference(){
    // Main box
    cube([box_width, box_length, box_height]);

    // cut-out the touch screen cavity
    //translate([side_wall+lip_width, side_wall+lip_width, bottom_wall])
    //  cube([trans_width-lip_width*2, trans_length-lip_width*2, box_height]);

    // cut for the touch screen
    translate([side_wall, side_wall, box_height-touch_depth])
      cube([touch_width, touch_length, touch_depth+0.1]);

    // inside cut for wires
    translate([side_wall*4, box_length*0.5-wire_cut_width, box_height-wire_cut_depth])
      cube([box_width-side_wall*8, wire_cut_width*2, wire_cut_depth*2]);

    // holes
    translate([box_width/2, box_length*0.5-wire_cut_width+hole_size, -0.1])
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
}

// Mounting tab
module tab(){
  difference(){
    translate([10,box_length-5,0])
      cube([box_width-20, 16, bottom_wall]);
    // holes
    for(x=[-1,0,1]){
      translate([box_width/2-x*(box_width/2.7), box_length+5, -0.1])
        cylinder(r=hole_size/2, h=box_height);
    }
  }
}

union(){
  box();
  tab();
}
