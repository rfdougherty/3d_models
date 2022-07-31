
width = 50; //149.8;
tab_depth = 5;
tab_width = 10;
// 5mm to the edge of the tract, the guide bar is 3mm (+/- 1mm on either side)
tab_dim = 3;
height = 100;
thick = 3;
slat_height = 15;
hinge_thick = 5;
hinge_shell_thick = 1.4;
hinge_clearance = 0.2;

type = "door2";

if(type=="door"){
  for(i=[0:height/slat_height-1])
      translate([0, slat_height*(i-1), 0]) liston(width, slat_height);  
}
if(type=="door1"){
  liston(width, slat_height);
}
if(type=="door2"){
  liston(width, slat_height);
  translate([0, slat_height, 0]) liston(width, slat_height);
}


// LISTON: Draws a piece of roller door
module liston(longitud, height=10){
  ht = hinge_thick / 2;
  z = thick + ht;
  
  difference(){
    // Slat body
    cube([longitud, height-0.7, thick]);
    
    // cut-out to accomodate outter hinge
    translate([-0.01, height-hinge_thick+hinge_shell_thick-0.6, -0.01])
      cube([hinge_thick+0.41, hinge_thick/2+hinge_shell_thick+0.6, thick+1]);
    translate([longitud-hinge_thick-0.41, height-hinge_thick+hinge_shell_thick-0.6, -0.01])
      cube([hinge_thick+.51, hinge_thick/2+hinge_shell_thick+0.6, thick+1]);
    
    // cut-out to accomodate inner hinge
    translate([hinge_thick, 0, ht+thick-1.2])
      rotate([0, 90, 0]) 
        cylinder(r=hinge_thick/2+0.3, h=hinge_thick+0.3, $fn=20);
    translate([longitud-hinge_thick*2-0.3, 0, ht+thick-1.2])
      rotate([0, 90, 0])
        cylinder(r=hinge_thick/2+0.3, h=hinge_thick+0.3, $fn=20);
  }
  
  difference(){
    union(){
      // horizontal ribs
      //translate([5, height-1.7, 0]) cube([longitud-10, 1, z]);
      translate([hinge_thick+0.5, height-3.2, 0]) 
        rotate([-30, 0, 0])
          cube([longitud-hinge_thick*2-1, hinge_shell_thick, z+2]);
      translate([0, hinge_shell_thick*2, 0]) 
        cube([longitud, hinge_shell_thick, z]);
      translate([0, slat_height/2, 0]) cube([longitud, hinge_shell_thick, z]);
      
      // Slot Guides
      translate([-tab_depth+0.02, 0, 0]){
        cube([tab_depth-0.1, tab_width, thick]);
        translate([1.1, 0, thick])
          cube([1.8, tab_width, 1]); 
      }
      translate([longitud-0.01, 0, 0]){
        cube([tab_depth-0.1, tab_width, thick]);
        translate([1.9, 0, thick])
          cube([1.8, tab_width, 1]); 
      }
      
      // left side
      translate([0, 0, z]){
        rotate([0, 90, 0]){
          difference(){
            union(){
              cylinder(r1=ht+hinge_shell_thick, r2=ht+hinge_shell_thick, h=hinge_thick, $fn=20);
              translate([0, -ht-hinge_shell_thick, 0]) 
                cube([thick + ht, ht+hinge_shell_thick, hinge_thick]);
            }
            cylinder(r1=0.01, r2=ht, h=hinge_thick+0.01, $fn=20);
          }
          translate([0, height, 0.4]){
            translate([0, 0, hinge_clearance])
              cylinder(r1=0, r2=ht-hinge_clearance, h=hinge_thick-hinge_clearance, $fn=20);
            translate([0, 0, hinge_thick]){
              hull(){
                cylinder(r1=ht-hinge_clearance, r2=ht-hinge_clearance, h=hinge_thick, $fn=20);
                translate([ht, -3.5, 0])
                  cylinder(r1=ht-hinge_clearance, r2=ht-hinge_clearance, h=hinge_thick, $fn=20);
              }
            }
          }
        }
      }
      
      // right side
      translate([longitud-hinge_thick, 0, z]){
        rotate([0, 90, 0]){
          difference(){
            union(){
              cylinder(r1=ht+hinge_shell_thick, r2=ht+hinge_shell_thick, h=hinge_thick, $fn=20);
              translate([0, -ht-hinge_shell_thick, 0]) 
                cube([thick + ht, ht+hinge_shell_thick, hinge_thick]);
            }
            translate([0, 0, -0.01]) 
              cylinder(r1=ht, r2=0.01, h=hinge_thick+0.01, $fn=20);
          }
          translate([0, height, -0.4]){
            cylinder(r1=ht-hinge_clearance, r2=0, h=hinge_thick-0.2, $fn=20);
            translate([0, 0, -hinge_thick]){
              hull(){
                cylinder(r1=ht-hinge_clearance, r2=ht-hinge_clearance, h=hinge_thick, $fn=20);
                translate([1.5, -3.5, 0])
                  cylinder(r1=ht-hinge_clearance, r2=ht-hinge_clearance, h=hinge_thick, $fn=20);
              }
            }
          }
        }
      }
    }
    // Clean up the bottom
    translate([0, 0, -10]) cube([longitud, height, 10]);
  }    
}

