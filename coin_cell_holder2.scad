/*Battery dimensions in mm
CR1225 cell holder: 
 diameter=12mm 
 height=2.5mm 
 tolerance=0.5mm 
 wall thickness=2mm 

CR2032 cell holder: 
 diameter=20mm 
 height=3.2mm 

CR1632 cell holder: 
 diameter=16mm 
 height=3.2mm 

*/

battery_diameter	= 16.0;	// Diameter of battery
battery_height = 3.5;	// Thickness of battery
tolerance = 0.9;	// Make things a little looser
wall_thickness = 1.2;	// Wall thickness
wire_diameter = 1.7;	// Thickness of wire openings
number_of_cells = 1;		// How many cells will be stacked
pitch = 1.27; // 0.1" pitch = 2.54mm / 2 = 1.27
// For a base on both sides:
// base_width = pitch*9;
// base_offset = 0.25;
base_width = 24;
base_length = 8; // pitch*17 for a wide mounting base
base_offset = -6;

extra_length	= -battery_diameter/2+4;	// Extends the opening to shroud the battery

module battery() {
    difference(){
        union(){
            difference(){
                cylinder(r=(battery_diameter/2)+tolerance+wall_thickness, h=battery_height*number_of_cells+(tolerance)+(2*wall_thickness),$fn=64);
                // Cut the cylinder in half
                translate([0,-((battery_diameter/2)+2+tolerance),0])
                    cube([battery_diameter+10,battery_diameter*number_of_cells+5,battery_height*number_of_cells+5]);
            }

        // Square extension up the top
        translate([0,-((battery_diameter/2)+wall_thickness+tolerance),0])
            cube([battery_diameter/2+extra_length,battery_diameter+(2*wall_thickness)+(2*tolerance),battery_height*number_of_cells+(2*wall_thickness)+tolerance]);
    }
      // Cut-out battery shape
      translate([0,0,wall_thickness])
        cylinder(r=(battery_diameter/2)+(tolerance/2), h=battery_height*number_of_cells+tolerance,$fn=64);

      // Cut-out the square extension
      translate([0,-((battery_diameter/2))-(tolerance/2),wall_thickness])
        cube([battery_diameter+tolerance,battery_diameter+tolerance,battery_height*number_of_cells+tolerance]);

      // Cut-out side wire holes
      translate([0,0,-1])
        cylinder(r=wire_diameter/2, h=battery_height*number_of_cells+tolerance+10,$fn=16);
 
  }
}


rotate([0,-40,0]){ //[0,-90,0]
  // Move to propper hieght and orientation
  translate([-battery_diameter/2-extra_length,0,-(battery_height*number_of_cells)+(wall_thickness/4)]){
    battery();
  }
}

difference(){
rotate([0,-90,0]){ //[0,-90,0]
    // Base
    translate([-battery_diameter/2-wall_thickness*3.3, -base_length/2, base_width+base_offset])
      difference(){
        union(){
          rotate([0,90,0])
            cube([base_width,base_length,wall_thickness*2]);
          rotate([0,90,0])
            translate([base_width/2,base_length/2,0])
              cylinder(r=battery_diameter/2, h=wall_thickness*3.5,$fn=16);
        }
        rotate([0,90,0]){
          translate([2,base_length/2,0])
            cylinder(r=wire_diameter/2,h=wall_thickness*4,$fn=16);
          translate([2+19.85,base_length/2,0])
            cylinder(r=wire_diameter/2,h=wall_thickness*4,$fn=16);
          }

      }
}

// Cut-out battery shape
rotate([0,-40,0]){ //[0,-90,0]
  // Move to propper hieght and orientation
  translate([-battery_diameter/2-extra_length,0,-(battery_height*number_of_cells)+(wall_thickness/4)]){
      translate([0,0,wall_thickness])
        cylinder(r=(battery_diameter/2)+(tolerance/2), h=battery_height*number_of_cells+tolerance,$fn=64);
}
}    
}



