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
tolerance = 0.5;	// Make things a little looser
wall_thickness = 1.2;	// Wall thickness
wire_diameter = 1.5;	// Thickness of wire openings
number_of_cells = 1;		// How many cells will be stacked
pitch = 1.27; // 0.1" pitch = 2.54mm / 2 = 1.27
// For a base on both sides:
// base_width = pitch*9;
// base_offset = 0.25;
base_width = pitch*7+0.8;
base_length = pitch*11; // pitch*17 for a wide mounting base
base_offset = -0.8;

extra_length	= -battery_diameter/2+4;	// Extends the opening to shroud the battery

rotate([0,-90,0]){ //[0,-90,0]
  // Move to propper hieght and orientation
  translate([-battery_diameter/2-extra_length,0,-(battery_height*number_of_cells)+(wall_thickness/4)]){
    difference(){
      union(){
        difference(){
          union(){
            // Main block
            cylinder(r=(battery_diameter/2)+tolerance+wall_thickness, h=battery_height*number_of_cells+(tolerance)+(2*wall_thickness),$fn=64);
           // Base
            translate([-battery_diameter/2-wall_thickness*1.5, -base_length/2, base_width/1.334+base_offset])
              rotate([0,90,0])
                cube([base_width,base_length,wall_thickness*1.6]);
          }
          // Battery shape
          translate([0,0,wall_thickness])
            cylinder(r=(battery_diameter/2)+(tolerance/2), h=battery_height*number_of_cells+tolerance,$fn=64);
          // Square opening 
          translate([0,-((battery_diameter/2)+2+tolerance),0])
            cube([battery_diameter+10,battery_diameter*number_of_cells+5,battery_height*number_of_cells+5]);
        }
        difference(){
          // Square extension
          translate([0,-((battery_diameter/2)+wall_thickness+tolerance),0])
            cube([battery_diameter/2+extra_length,battery_diameter+(2*wall_thickness)+(2*tolerance),battery_height*number_of_cells+(2*wall_thickness)+tolerance]);
          // Square hole in end
          translate([0,-((battery_diameter/2))-(tolerance/2),wall_thickness])
            cube([battery_diameter+tolerance,battery_diameter+tolerance,battery_height*number_of_cells+tolerance]);
        }
      }
      // Side wire holes
      translate([0,0,-1])
        cylinder(r=wire_diameter/2, h=battery_height*number_of_cells+tolerance+10,$fn=16);

      // Base wire holes
      // sides
      for(y=[-4*pitch,-2*pitch,0,2*pitch,4*pitch]){
        translate([-battery_diameter/2-wall_thickness*2, y, wall_thickness+(battery_height*number_of_cells/1.8)-pitch*3+base_offset])
          rotate([0,90,0])
            cylinder(r=wire_diameter/2,h=wall_thickness*4,$fn=16);
        if(base_width>8*pitch)
          translate([-battery_diameter/2-wall_thickness*2, y, wall_thickness+(battery_height*number_of_cells/1.8)+pitch*3+base_offset])
            rotate([0,90,0])
              cylinder(r=wire_diameter/2,h=wall_thickness*4,$fn=16);
      }

      // end holes
      if(base_length>12*pitch){
        translate([-battery_diameter/2-wall_thickness*3,pitch*7,wall_thickness+(battery_height*number_of_cells/2)+base_offset])
          rotate([0,90,0])
            cylinder(r=wire_diameter/2,h=wall_thickness*2+1,$fn=16);

        translate([-battery_diameter/2-wall_thickness*3,-pitch*7,wall_thickness+(battery_height*number_of_cells/2)+base_offset])
          rotate([0,90,0])
            cylinder(r=wire_diameter/2,h=wall_thickness*2+1,$fn=16);
      }
    }
  }
}



