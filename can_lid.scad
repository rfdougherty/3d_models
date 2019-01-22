/*
Tapita para comida en lata, no olvides ajustar el diámetro y
el texto de la tapa (ej. el nombre de tu mascota).

Parametric lid for pet can food
Remember to adjust your can diameter and label it accordingly
(ex. the name of your pet!)


Copyright (C) 2016 Diego Elgueda (delgueda@gmail.com)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
*/
    


$fn = 360;
thickness = 1.5;
bg_circle = 85.0/2; // adjust this to be the diameter of your can
sm_circle  = (bg_circle-5.5); // 59/2

height = 6;

// edit lid label in line 71

module lid(){
    difference(){
        cylinder(r=sm_circle, h=height);
 
        translate([0, 0, thickness]){
            cylinder(r=(sm_circle-thickness), h=height);
        }
    }

    translate([0, 0, height]){
        difference(){
            difference(){
                cylinder(r=bg_circle, h=height);
                translate([0, 0, thickness]){
                    cylinder(r=(bg_circle-thickness), h=height);
                }
                
            }
            cylinder(r=(sm_circle-thickness), h=height);
        }
    }

    translate([0,0,(height*2)-thickness]){
        difference(){
            cylinder(r=bg_circle-thickness, h=thickness-0.1);
            cylinder(r=bg_circle-thickness-1, h=thickness);
        }
    }
}
lid();

//difference(){
//    lid();
//    linear_extrude(height=0.5){
//        rotate([0,180,0]){
//            text(font="Gill Sans Ultra Bold", text="Ferdie & Tiger", halign="center", valign="center", size=6);
//        }
//    }
//}
