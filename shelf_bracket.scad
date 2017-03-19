/*
  Shelf bracket based on Sierpinkski's triangle.

  This bracket is designed for use with 1.5" screws and a drill. In particular,
  the mounting holes are countersunk such that 1.5" screws will not stick
  through a ~0.5 in shelf when tightened. Two of the holes diagonally
  countersunk so as to be accessible from the side. This means that you need to
  install pairs of brackets in opposite 'handed-ness' for maximum lateral
  stability.

*/

sidelength = 150;
thickness = 30;

screwlength = 38.1; // 1.5 inches in mm
screwhead = 5.5;
screwshaft = 2.5;   // penis.
angle = 25;

shelfthickness = 12.7; // 0.5 in in mm

module triangle(size=sidelength, height=1) {
  // extrudes a right triangle of given size and thickness
  linear_extrude(height=height, center=true)
  polygon(points = [[0, 0], [size, 0], [0, size]], paths = [[0, 1, 2]]);
}

module countersink() {
  // The thinner cylinder can be used to show how far your
  // screw will penetrate.
  union() {
    translate([0, 0, -screwlength])
      cylinder(r=screwhead, h=screwlength);
    #cylinder(r=screwshaft, h=screwlength);
  }
}

S = sidelength/2; // precompute this oft-used value
P = 5;            // padding for outer edges
E = screwlength - shelfthickness;


module bracket() {
difference() {
  translate([S+P, S+P, 0])
    rotate(180, [0,0,1])
    triangle(sidelength + P*4, thickness);

  triangle(S-P, 50);
  translate([S/2, -S/2, 0])  triangle(size=S/2-P, height=50);
  translate([-S/2, S/2, 0])  triangle(size=S/2-P, height=50);
  translate([S/2, S/2, 0]) triangle(size=S/2-P, height=50);
  translate([-S/4, S/4, 0]) triangle(size=S/4-P, height=50);
  translate([S/4, S*3/4, 0]) triangle(size=S/4-P, height=50);
  translate([-S/4, S*3/4, 0]) triangle(size=S/4-P, height=50);
  translate([S/4, -S/4, 0]) triangle(size=S/4-P, height=50);
  translate([S*3/4, S/4, 0]) triangle(size=S/4-P, height=50);
  translate([S*3/4, -S/4, 0]) triangle(size=S/4-P, height=50);
  translate([S*3/4, -S*3/4, 0]) triangle(size=S/4-P, height=50);
  translate([-S*3/4, S*3/4, 0]) triangle(size=S/4-P, height=50);
  translate([S*3/4, S*3/4, 0]) triangle(size=S/4-P, height=50);

  rotate(90, [0, 1, 0])
    translate([0, -(S*7/8-P), S+5-E])
    countersink();

  rotate(-90, [1, 0, 0])
    translate([-(S*7/8-P), 0, S+5-E])
    countersink();


  rotate(90, [0, 1, 0])
    translate([0, (S*5/8+P), S+5])
    rotate(-angle, [0, 1, 0])
    translate([0, 0, -E*cos(angle)])
    countersink();

  rotate(-90, [1, 0, 0])
    translate([S*5/8+P, 0, S+5])
    rotate(angle, [1, 0, 0])
    translate([0, 0, -E*cos(angle)])
    countersink();
}
}

bracket();
rotate([0,0,180]) 
  translate([15,15,0]) 
    bracket();
