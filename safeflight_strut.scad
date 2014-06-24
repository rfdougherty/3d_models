s = 25.4;

center_hole_rad = .25*s;
thick = 1/8*s;
total_width = 2.375*s;
width = total_width/2;
length = 1.56*s;
side_cut_width = 0.188*s;
side_cut_length = 1.125*s;
flex_cut_width = 0.125*s;
flex_cut_length = 0.04*s;
flex_cut_pos = 0.5*s;
cut_width = 0.375*s;
cut_height = 1.125*s;
tri_cut_width = 1.0*s;
tri_cut_height = 0.125*s;
side_fillet_rad = 4.0;
edge_fillet_rad = 2.0;

// Set the angular resolution ($fn segments per 360 deg)
$fn = 60;

module fillet(r, h) {
    translate([r / 2, r / 2, 0])
    difference() {
        cube([r + 0.01, r + 0.01, h], center = true);
        translate([r/2, r/2, 0])
          cylinder(r = r, h = h + 1, center = true);
    }
}

module oval(w, h, height, center = false) {
  scale([1, h/w, 1]) cylinder(h=height, r=w, center=center);
}

module strut_half(){
difference(){
    // Main box
    cube([width, length, thick]);

    translate([0, length/2, -0.1])
        cylinder(r=center_hole_rad/2, h=thick*1.2);

    translate([0, -length/1.8, -0.1])
        cylinder(r=width, h=thick*1.2);
    translate([0, length+length/1.8, -0.1])
        cylinder(r=width, h=thick*1.2);

    translate([width-side_cut_width+.1, (length-side_cut_length)/2, -0.1])
        cube([side_cut_width+.1, side_cut_length, thick+0.2]);

    translate([width-side_cut_width+.1, (length-side_cut_length)/2, -0.1])
		rotate(a=[0,0,45])
			cube([side_cut_length/sqrt(2), side_cut_length/sqrt(2), thick+0.2]);

    rotate(a=[0,0,45])
    		translate([width/2+17.5, 5, -0.1])
			oval(side_cut_length/3, 3, thick+0.2, false);

    translate([flex_cut_pos-flex_cut_width, (length-flex_cut_length)/2, -0.1])
        cube([flex_cut_width, flex_cut_length, thick+0.2]);

    // holes
    //for (x=[-1,0,1], y=[-1,0,1] ){
    //    translate([x*hole_size*2+width/2, y*hole_size*2+length/2+trans_base/2, -0.1])
    //      cylinder(r=hole_size/2, h=box_height);
    //}

    // fillets for the side edges
    translate([width,0,-0.1])
      rotate(a=[0,0,90])
        fillet(side_fillet_rad, thick*3);
    translate([width,length,-0.1])
      rotate(a=[0,0,180])
        fillet(side_fillet_rad, thick*3);

}
}

translate([0,0,0]) strut_half();

mirror([1, 0, 0]) translate([0,0,0]) strut_half();

        
