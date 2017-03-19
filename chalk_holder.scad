

// Chalk diameter. (All measurements in millimeters.)
diameter = 13.0;
// Total height.
height = 35;
// Thickness of cone walls.
wall = 0.6;
hole_diameter = 4.5;
// Taper the inner cylinder to grip the chalk
taper = 0.05;

eraser_diameter = 25;
eraser_height = wall*2;

module chalk(){
  r = diameter/2;
  union(){
    
    difference() {
      union(){
        cylinder(h=eraser_height, r=eraser_diameter/2+wall, center=false, $fn=60);
        cylinder(h=height, r=r+wall, center=false, $fn=60);
      }
      // inside cylinder
      translate([0,0,wall*2])
        cylinder (h=height-wall, r1=r-r*taper, r2=r, center=false, $fn=60);
      rotate([0,90,0])
        translate([-(hole_diameter/2+eraser_height+.1),0,0])
          cylinder(h=diameter+wall*2, r=hole_diameter/2, center=true, $fn=30);
      translate([0,0,-.2])
        cylinder (h=eraser_height+.4, r=hole_diameter/2, center=false, $fn=60);
    }
  }
}

chalk();
//d = eraser_diameter/2 + 3;
//for(x=[-d,d]) translate([x,y,0]) chalk();

    