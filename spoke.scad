use <threads.scad>;

fn = 64; //100
spoke = 2.5; // 2mm diameter
led_width = 15.5;
led_height = 5;
base_height = 3;

difference () {
  cylinder (r=10, h=14, $fn=fn);
  translate([0,0,2.1])
    metric_thread(diameter=16, pitch=2.0, length=12, internal=true);
}

translate([-15,-20,0]) {
  translate([0,0,base_height]) {
  //translate([0,0,0]) {
    difference() {
      metric_thread(diameter=16, pitch=2.0, length=8, internal=false);
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
    cube([16,led_width+4,led_height+1.5]);
    translate([-.1,2,1.5])
      cube([16.2,led_width,led_height+.1]);
  }
}

translate([10,10,0]) {
  difference() {
    cube([16,led_width+4,led_height+1.5]);
    translate([-.1,2,1.5])
      cube([16.2,led_width,led_height+.1]);
  }
}