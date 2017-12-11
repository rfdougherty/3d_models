use <threads.scad>;

fn = 64; //100
spoke = 2.5; // 2mm diameter
led_width = 14.5;
led_height = 5;
base_height = 3;
pitch = 3.5;
slop = 0.6;

difference () {
  cylinder (r=9, h=10, $fn=fn);
  translate([0,0,2.1])
    metric_thread(diameter=16, pitch=pitch, length=9, internal=true);
}

translate([-15,-20,0]) {
  translate([0,0,base_height]) {
  //translate([0,0,0]) {
    difference() {
      metric_thread(diameter=16-slop, pitch=pitch, length=8, internal=false);
      translate([0,0,12-8+.1]) 
        cube([18,3,8], center=true);
    }
  }
  translate([-8,-8,0]) {
    difference() {
      cube([16,16,base_height]);
      //translate([-.1,(18-led_width)/2,0])
      //  cube([16.2,led_width,led_height]);
    }
  }
}

translate([10,-30,0]) {
  difference() {
    cube([16,led_width+4,led_height+1.5+1.5]);
    translate([-.1,2,1.5])
      cube([16.2,led_width,led_height+1.5+.1]);
    translate([8,(led_width+4)/2,-0.1])
      cylinder(r=3, h=3, $fn=fn);
  }
  translate([0,2,led_height]) {
    difference() {
      rotate([45,0,0])
        cube([16,2.8,3]);
      translate([-0.1,-1.5,3])
        cube([16.2,4,3]);
    }
  }
  translate([0,led_width+2,led_height]) {
    difference() {
      rotate([45,0,0])
        cube([16,2.8,3]);
      translate([-0.1,-1.5,3])
        cube([16.2,4,3]);
    }
  }
}

translate([10,10,0]) {
  difference() {
    cube([16,led_width+4,led_height+1.5+1.5]);
    translate([-.1,2,1.5])
      cube([16.2,led_width,led_height+1.5+.1]);
    translate([8,(led_width+4)/2,-0.1])
      cylinder(r=3, h=3, $fn=fn);
  }
  translate([0,2,led_height]) {
    difference() {
      rotate([45,0,0])
        cube([16,2.8,3]);
      translate([-0.1,-1.5,3])
        cube([16.2,4,3]);
    }
  }
  translate([0,led_width+2,led_height]) {
    difference() {
      rotate([45,0,0])
        cube([16,2.8,3]);
      translate([-0.1,-1.5,3])
        cube([16.2,4,3]);
    }
  }
}