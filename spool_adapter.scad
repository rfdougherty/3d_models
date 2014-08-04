s = 25.4;
outer_radius = 2.25/2*s;
inner_radius = 1/4*s;
base_radius = outer_radius + 8;
base_height = 1.2;
height = (2+5/16)*s;

difference(){
  union(){
    cylinder(r=outer_radius, height+base_height, $fn=64);
    cylinder(r=base_radius, base_height, $fn=64);
  }
  cylinder(r=inner_radius, h=height+base_height, $fn=64);
}