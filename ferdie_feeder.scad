
outer_radius = 25;
wall_thickness = 2.0;
height = 50;
sides = 12;
hole_radius = 3;
lip = 5;

difference(){
  union(){
    cylinder(r=outer_radius, height+wall_thickness, $fn=sides);
    cylinder(r=outer_radius, wall_thickness, $fn=sides);
  }
  translate(v=[0,0,wall_thickness]){
    cylinder(r=outer_radius-wall_thickness, h=height+wall_thickness, $fn=sides);
  }
  // holes
  for (x=sin([0:sides]), y=cos([0:sides]), z=[10, 20, 30, 40]){
    rotate([x, y, 0])
      translate([x*outer_radius, y*outer_radius*2, z])
        cylinder(r=hole_radius, h=wall_thickness+1);
  }
}

  // holes
  theta = [0:360/sides:(sides-1)*360];
  for (x=sin(theta), y=cos(theta), z=[10, 20, 30, 40]){
    rotate([x, y, 0])
      translate([x*outer_radius, y*outer_radius*2, z])
        cylinder(r=hole_radius, h=wall_thickness+1);
  }

translate(v=[outer_radius*2+3,0,0]){
  union(){
    cylinder(r1=outer_radius-wall_thickness-0.2, r2=outer_radius-wall_thickness-0.5, wall_thickness+lip, $fn=sides);
    cylinder(r=outer_radius, wall_thickness, $fn=sides);
  }
}