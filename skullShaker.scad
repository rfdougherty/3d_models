hole_size = 3;
side_wall = 1.4;
bottom_wall = 1;
lip_width = 2.6;
lip_depth = 1.2;
cavity_depth = 2.2;
trans_width = 25.6;
trans_length = 25.6;
trans_base = 3;
wire_cut_depth = 3.0;
wire_cut_width = 3.4;
side_fillet_radius = 2.0;
bottom_fillet_radius = 2.6;

// Set the angular resolution ($fn segments per 360 deg)
$fn = 30;

box_height = bottom_wall + cavity_depth + lip_depth;
box_width = trans_width+side_wall*2;
box_length = trans_length+side_wall*2+trans_base;

module fillet(r, h) {
    translate([r / 2, r / 2, 0])
    difference() {
        cube([r + 0.01, r + 0.01, h], center = true);
        translate([r/2, r/2, 0])
          cylinder(r = r, h = h + 1, center = true);
    }
}

module skull_shaker(){
difference(){
    // Main box
    cube([box_width, box_length, box_height]);

    // cut-out the resonance cavity
    translate([side_wall+lip_width, side_wall+lip_width+trans_base, bottom_wall])
      cube([trans_width-lip_width*2, trans_length-lip_width*2, box_height]);

    // cut for the transducer (leaving a lip for mounting)
    translate([side_wall, side_wall, box_height-lip_depth])
      cube([trans_width, trans_length+trans_base, lip_depth+0.1]);

    // outside cut for wires
    translate([side_wall, 0, box_height-wire_cut_depth])
      cube([wire_cut_width, side_wall, wire_cut_depth*2]);

    // inside cut for wires
    translate([side_wall, side_wall, box_height-wire_cut_depth])
      cube([box_width-side_wall*2, wire_cut_width, wire_cut_depth*2]);

    // holes
    for (x=[-1,0,1], y=[-1,0,1] ){
        translate([x*hole_size*2+box_width/2, y*hole_size*2+box_length/2+trans_base/2, -0.1])
          cylinder(r=hole_size/2, h=box_height);
    }

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
      fillet(bottom_fillet_radius, box_length*2+.1);
    translate([0,box_length,0])
      rotate(a=[90,0,-90])
        fillet(bottom_fillet_radius, box_length*2+.1);
}
}

translate([5,0,0]) skull_shaker();

mirror([1, 0, 0]) translate([5,0,0]) skull_shaker();

        
