$fa = 1;
$fs = 1;

leds_per_mm = 1 / 6.9;  // num LEDs per mm (1 / length of each LED)
led_width = 12;  // width of led strip

height = 18; //20;  // i.e., how far off the wall the thing will be
thick = 3;  // thickness of all walls
lip_angle = 35;  // LED reflector ring angle (e.g., 35)
led_angle = 90;  // LED mount ring angle (keep close to 90)
overhang = 20;
num_leds = 60;
wire_diam = 8;
led_gap = 10;
screw_diam = 6;
e = 0.01;
gap = 0.16;
led_hole_width = 0; // set to 0 for no holes
lip_height = height; //led_width;

hub_circumference = num_leds / leds_per_mm;

hub_radius = hub_circumference / 2 / PI;
base_radius = hub_radius + overhang;

difference() {
  cap();
  if (led_hole_width > 0){
    circular_cylinders(base_radius-led_hole_width, 60, 20, 
                       led_hole_width/2, z=thick + led_width/2);
    circular_cubes(base_radius-led_hole_width, 60, 10, 
                   led_hole_width, height, tz=thick + led_width/2);
  }
}
//mount();


module cap(){
  difference(){
    union(){
      // base
      translate([0, 0, thick/2])
        cylinder(h=thick, r=base_radius, center=true);
      difference() {
        union() {
          // hub
          translate([0, 0, height/2])
            cylinder(h=height, r=hub_radius, center=true);
              // angled LED ring
          translate([0, 0, thick/2 + led_width/2 - e])
            angled_ring(led_width, hub_radius, led_angle);
        }
        // LED wire pass-through
        lw = height;
        translate([led_gap, hub_radius-thick, thick + lw/2 + e])
          rotate([0, 0, 45])
            cube([led_gap, thick*10, lw], center=true);
      }
      // angled reflector ring
      translate([0, 0, thick/2 + lip_height/2 - e])
        angled_ring(lip_height, base_radius, -lip_angle, offset=thick);
    }
    
    // cut-out
    translate([0, 0, height/2+thick+e])
      cylinder(h=height, r=hub_radius-thick, center=true);
    
    // trim reflector ring
    translate([0, 0, height/2-e])
      ring(height, base_radius, led_width);
    
    // Wire hole
    translate([0, -hub_radius+thick*2, height])
      rotate([90, 0, 0])
        cylinder(h=thick*3+overhang, r=wire_diam/2);
  }
}

module mount(){
  hgt = height - 2;
  difference(){
    union(){
      translate([0, 0, hgt/2])
        cylinder(h=hgt, r=hub_radius-thick-gap, center=true);
    }
    // cut-out
    translate([0, 0, hgt/2+thick+e])
      cylinder(h=hgt, r=hub_radius-thick*2-gap, center=true);
    // trim reflector ring
    translate([0, 0, hgt/2-e])
      ring(hgt, base_radius, led_width);
    
    // Wire hole
    translate([0, 0, thick+hgt/2])
      cube([30, hub_radius*3, hgt+e], center=true);
    
    // screw holes
    translate([-hub_radius*0.65, 0, -e])
      rotate([0, 0, 90])
        cylinder(h=thick+3*e, r=screw_diam/2);
    translate([hub_radius*0.65, 0, -e])
      rotate([0, 0, 90])
        cylinder(h=thick+3*e, r=screw_diam/2);
  }
}

module ring(height, radius, thick){
  difference(){
    cylinder(h=height, r=radius+thick, center=true);
    cylinder(h=height+e, r=radius, center=true);
  }
}

module angled_ring(height, rad, angle, offset=0){
  base = height / tan(angle); // tan = opp/adj
  if(angle < 0){
    difference(){
      cylinder(h=height, r=rad, center=true);
      translate([0, 0, -e])
        cylinder(h=height+e*3, r1=rad+base-offset, r2=rad-offset, center=true);
    }
  }else{
    difference(){
      cylinder(h=height, r1=rad+base+offset, r2=rad+offset, center=true);
      translate([0, 0, -e])
        cylinder(h=height+e*3, r=rad, center=true);
    }
  }
}

module circular_cylinders(r, steps, cylh, cylr, x=0, y=0, z=0) {
  aps = 360 / steps;
  for (step=[0:steps]) {
    current_angle = step * aps;
    unit_x = cos(current_angle);
    unit_y = sin(current_angle);
    translate([x, y, z]) {
      translate([unit_x * r, unit_y * r, 0]) {
        rotate([90, 0, 90])
          rotate([0, current_angle, 0])
            cylinder(h=cylh, r=cylr);
      }    
    }
  }
}

module circular_cubes(r, steps, x, y, z, tx=0, ty=0, tz=0) {
  aps = 360 / steps;
  offset = -y / (r * PI) * 90;
  echo(offset);
  for (step=[0:steps]) {
    current_angle = step * aps + offset;
    unit_x = cos(current_angle);
    unit_y = sin(current_angle);
    translate([tx, ty, tz]) {
      translate([unit_x * r, unit_y * r, 0]) {
        rotate([0, 0, current_angle])
          cube([x, y, z]);
      }    
    }
  }
}