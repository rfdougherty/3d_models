/*
@brief Generic Electronic Device Packaging for Tyndall version 2
@details This OpenSCAD script will generate a 2 part fit together packaging.

	Which of the 6 sides of the packaging do you want this feature on? (face_name, T,B,N,E,W,S)
		"T", The Top or Z+ face
		"B", The Bottom or Z- face
		"N", the North or Y+ face
		"E", the East or X+ face
		"W", the West or X- face
		"S", the South or Y- Face
	Where on the face do you want this feature (shape_position [x_pos,y_pos,x_offs,y_offs,rotate,align] )
		x_pos, how far along the face do you move in X
		y_pos, how far along the face do you move in Y
		x_offs, where along the face do you take measurements from in X
		y_offs, where along the face do you take measurements from in Y
		rotate, how much do you want the object rotated in degrees
			if you do not use any of the above please set them to 0! do not just leave them empty!
		align, do you want the object aligned with the "inside" or the "outside" of the packaging face

	What shape do you want? (shape_name, Cone/Ellipse/Cylinder/Round_Rect/Square/Rectangle/Nub_Post/Dip_Post/Hollow_Cylinder)
	What are the shape's dimensions (shape_size[depth,,,])...you will need to read the section below as they are different for each shape
		"Square" shape_size[depth, length_breadth]
		"Rectangle" shape_size[depth, length, breadth]
		"Round_Rect" shape_size[depth, length, breadth, corner_radius, corner_sides]
		"Cylinder" shape_size[depth, radius ,sides]
		"Ellipse" shape_size[depth, radius_length, radius_breadth, sides]
		"Cone" shape_size[depth, radius_bottom, radius_top ,sides]
		"Nub_Post" shape_size[depth, radius_bottom, radius_top, depth_nub, sides]
		"Dip_Post" shape_size[depth, radius_bottom, radius_top, depth_dip, sides]
		"Hollow_Cylinder" shape_size[depth, radius_outside, radius_inside ,sides]
	A string of text you want to have carved into a face (text_to_write)
		for text shape_size[depth,font_height,font_spacing,mirror]


Author Mark Gaffney
Version 2.6k
Date 2013-07-09

 @attention
Copyright (c) 2013 Tyndall National Institute.
All rights reserved.
Permission to use, copy, modify, and distribute this software and its documentation for any purpose, without fee, and without written agreement is hereby granted, provided that the above copyright notice and the following two paragraphs appear in all copies of this software.

IN NO EVENT SHALL TYNDALL NATIONAL INSTITUTE BE LIABLE TO ANY PARTY FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF TYNDALL NATIONAL INSTITUTE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

TYNDALL NATIONAL INSTITUTE SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND TYNDALL NATIONAL INSTITUTE HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.

*/

/* [User Controls] */
//dimensions of the object to be packaged
device_xyz=[90,60,28];
//size of the gap between each side of the object and the internal wall of the packaging
clearance_xyz=[0.5,0.5,0.5];//
//how thick the material of the packaging in each direction//recommend keeping X&Y value the same
//wall_thickness_xyz=[2,2,1];//not yet implemented!!!

//how thick the material of the packaging
wall_t=3;//thickness//actual most recent version has a base thickness of 2 but that is not yet fully implemented in this code

//The external radius of the rounded corners of the packaging
corner_radius=2+clearance_xyz[1]+wall_t;

//How many sides do these rounded corners have?
corner_sides=9;

//How high is the lip that connects the 2 halves?
lip_h=2;

//How tall is the top relative to the bottom
top_bottom_ratio=0.2;

//the orientation of the individual top/bottom half parts when generated separately
flipped=true;//[true, false]

//how far apart the 2 halves are
separation=12;//2;

//how much of an overlap (-ve) or gap (+ve) is there between the inner and outer lip surfaces, a value of 0 implies they meet perfectly in the middle
lip_fit=0.3; //0.35

//what style of box is it
box_type="rounded4sides";//"rounded4sides";//"cuboid","rounded4sides", "rounded6sides", "chamfered6sides"

seam_z = device_xyz[1]*top_bottom_ratio + lip_h/2 - 3.0;

//data structure defining all the cutouts and depressions used on the packaging
holes = [ //format [face_name, shape_name, shape_position[x_pos,y_pos,x_offs,y_offs,rotate,align], shape_size[depth,,,]]
    // position is y,z
	["E", "Round_Rect", [1.0, -4.0, 0,0,0,"outside"], [wall_t, 14, 11, 1, 3]], // uUSB
	["W", "Cylinder", [0, seam_z, 0,0,0,"outside"], [wall_t+10, 4, 16]], // wire
	["W", "Round_Rect", [16.0, -4.0, 0,0,0,"outside"], [wall_t, 12, 12, 1, 3]], // power
	["T", "Cylinder", [30, 0, 0,0,0,"outside"], [wall_t+10, 3.9, 16]], // rotary
	["T", "Round_Rect", [0, 0, 0,0,0,"outside"], [wall_t+10, 34, 19, 1, 3]], // OLED
	["T", "Cylinder", [-14.5, 14.5+3, 0,0,0,"outside"], [wall_t+10, 1.1, 16]], // OLED mount
	["T", "Cylinder", [ 14.5, 14.5+3, 0,0,0,"outside"], [wall_t+10, 1.1, 16]], // OLED mount
	["T", "Cylinder", [-14.5,-14.5+3, 0,0,0,"outside"], [wall_t+10, 1.1, 16]], // OLED mount
	["T", "Cylinder", [ 14.5,-14.5+3, 0,0,0,"outside"], [wall_t+10, 1.1, 16]], // OLED mount

	["T", "Cylinder", [1.5,1.5,-device_xyz[0]/2,-device_xyz[1]/2,0,"outside"], [-2+wall_t+top_bottom_ratio*device_xyz[2]+clearance_xyz[2],3.556/2,16]],//post in cutout
	["T", "Cylinder", [-1.5,1.5, device_xyz[0]/2,-device_xyz[1]/2,0,"outside"], [-2+wall_t+top_bottom_ratio*device_xyz[2]+clearance_xyz[2],3.556/2,16]],//post in cutout
	["T", "Cylinder", [1.5,-1.5,-device_xyz[0]/2, device_xyz[1]/2,0,"outside"], [-2+wall_t+top_bottom_ratio*device_xyz[2]+clearance_xyz[2],3.556/2,16]],//post in cutout
	["T", "Cylinder", [-1.5,-1.5, device_xyz[0]/2, device_xyz[1]/2,0,"outside"], [-2+wall_t+top_bottom_ratio*device_xyz[2]+clearance_xyz[2],3.556/2,16]],//post in cutout
	//[depth, length, breadth, corner_radius, corner_sides]
	];

	post_tolerance=0.2;
//data structure defining all the internal supporting structures used on the packaging
posts = [ //format [face_name, shape_name shape_position[x_pos,y_pos,x_offs,y_offs,rotate,align], shape_size[depth,,,]]
    // posts in cutout for securing the lid
	["B", "Hollow_Cylinder",	[1.5,1.5,-device_xyz[0]/2,-device_xyz[1]/2,0,"inside"],
      [(1-top_bottom_ratio)*device_xyz[2]+post_tolerance,(3.556/2)+1,(2/2),16]],
	["T", "Hollow_Cylinder",	[1.5,1.5,-device_xyz[0]/2,-device_xyz[1]/2,0,"inside"],
      [(top_bottom_ratio)*device_xyz[2]+post_tolerance,(3.556/2)+1,(2.3876/2),16]],
    ["B", "Hollow_Cylinder",	[-1.5,1.5, device_xyz[0]/2,-device_xyz[1]/2,0,"inside"],
      [(1-top_bottom_ratio)*device_xyz[2]+post_tolerance,(3.556/2)+1,(2/2),16]],
	["T", "Hollow_Cylinder",	[-1.5,1.5, device_xyz[0]/2,-device_xyz[1]/2,0,"inside"],
      [(top_bottom_ratio)*device_xyz[2]+post_tolerance,(3.556/2)+1,(2.3876/2),16]],
	["B", "Hollow_Cylinder",	[1.5,-1.5,-device_xyz[0]/2, device_xyz[1]/2,0,"inside"],
      [(1-top_bottom_ratio)*device_xyz[2]+post_tolerance,(3.556/2)+1,(2/2),16]],
    ["T", "Hollow_Cylinder",	[1.5,-1.5,-device_xyz[0]/2, device_xyz[1]/2,0,"inside"],
      [(top_bottom_ratio)*device_xyz[2]+post_tolerance,(3.556/2)+1,(2.3876/2),16]],
    ["B", "Hollow_Cylinder",	[-1.5,-1.5, device_xyz[0]/2, device_xyz[1]/2,0,"inside"],
      [(1-top_bottom_ratio)*device_xyz[2]+post_tolerance,(3.556/2)+1,(2/2),16]],
    ["T", "Hollow_Cylinder",	[-1.5,-1.5, device_xyz[0]/2, device_xyz[1]/2,0,"inside"],
      [(top_bottom_ratio)*device_xyz[2]+post_tolerance,(3.556/2)+1,(2.3876/2),16]],
	];

//add external slotted flanges for say passing a belt or strap through in Z plane on up to 4 sides
has_flanges=true;//[true, false]
//how thick are the flanges in Z-direction
flange_t=wall_t;
//how "tall" is the slot in the flange i.e. thick is the material you will want to pass through the slot in the flange
slot_t=3;
//how wide is the slot in the flange
slot_w=27;
//define the flanges on each of the four sides
flanges=[
//flange_sides, flange_type, position[x_pos, y_pos], shape_size[flange_t, flange_case_gap, flange_wall_t,slot_b,slot_l,flange_sides]
	["N","rounded_slot",[0,0],	[flange_t,1,wall_t,slot_t,slot_w,corner_sides]],
	["S","rounded_slot",[0,0],	[flange_t,1,wall_t,slot_t,slot_w,corner_sides]],
	// ["E","rounded_slot",[0,0],	[flange_t,0,wall_t,slot_t,slot_w,corner_sides]],
	// ["W","rounded_slot",[0,0],	[flange_t,0,wall_t,slot_t,slot_w,corner_sides]],

	//["S","2_holes",		[0,0], 	[flange_t,0,wall_t,hole_center_sep,hole_r,box_s]],//[]
];
/* [Hidden] */
//a small number used for manifoldness
a_bit=0.01;
//x dimension of packaging
box_l=device_xyz[0]+2*(clearance_xyz[0]+wall_t); //box_l=device_xyz[0]+2*(clearance_xyz[0]+wall_thickness_xyz[0]);
//y dimension of packaging
box_b=device_xyz[1]+2*(clearance_xyz[1]+wall_t); //box_b=device_xyz[1]+2*(clearance_xyz[1]+wall_thickness_xyz[1]);
//z dimension of packaging
box_h=device_xyz[2]+2*(clearance_xyz[2]+wall_t);//box_h=device_xyz[2]+2*(clearance_xyz[2]+wall_thickness_xyz[2]);

//join together the 5 relevant box values
box=[box_l,box_b,box_h,corner_radius,corner_sides,wall_t];//

//choose if your packaging has a lockign feature between the lips
has_locking_feature=true;//true, false
//choose the shape of this locking feature
locking_feature_type="spheroid"; //["spheroid", "hexagonal", "groove"]

//for groove type locking features
locking_feature_r=lip_h/4;

//for hexagon type locking features
//radius 1 of locking feature for hexagon type locking features
locking_feature_r1=lip_h/4;
//radius 2 of locking feature for hexagon type locking features
locking_feature_r2=lip_h/6;
//height (actually more like length) of locking features along X-direction for hexagon type locking features
locking_feature_hx=20;
//height (actually more like length) of locking features along Y-direction for hexagon type locking features
locking_feature_hy=15;

//for spheroid type locking feature
//height of locking features above vertical surface for spheroid type locking features
locking_feature_max_h=lip_fit;
//depth of locking features from top to bottom in direction of lip h for spheroid type locking features
locking_feature_max_d=lip_h/2;
//length of locking features along X-direction for spheroid type locking features
locking_feature_max_lx=device_xyz[1]-10;//30;
//length of locking features along Y-direction for spheroid type locking features
locking_feature_max_ly=device_xyz[0]-10;//20;

//********************************includes******************//
use<write.scad>;

//******************************calls**********************//
	make_box(box,corner_radius, corner_sides, lip_h, lip_fit, top_bottom_ratio, flipped, separation, holes, posts, text, items, box_type, has_flanges, flanges);

//***************************modules***********************//
module make_box(box, corner_radius=3, corner_sides=5, lip_h=2, lip_fit=0, top_bottom_ratio=0.5, flipped=false, separation=2, holes=[], posts=[], text=[], items=[], box_type="rounded4sides",has_flanges=false, flanges=[]){

	translate(v=[0,0,box[2]/2]){
			union(){
				translate(v=[0,(separation+box[1])/2,0]){//[(separation+box[0])/2,0,0]){
					half_box(box, corner_radius, corner_sides, lip_h, lip_fit, top_bottom_ratio, which_half="bottom", holes=holes, posts=posts, text=text, items=items, box_type=box_type,has_flanges=has_flanges, flanges=flanges);

				}translate(v=[0,-(separation+box[1])/2,0]) rotate(a=[0,180,0]){//[-(separation+box[0])/2,0,0]) rotate(a=[0,180,0]){
					half_box(box, corner_radius, corner_sides, lip_h, lip_fit, top_bottom_ratio, which_half="top", holes=holes, posts=posts, text=text, items=items, box_type=box_type);
				}
			}
    }
}

module half_box(box, corner_radius=3, corner_sides=5, lip_h=2, lip_fit=0, top_bottom_ratio=0.5, which_half="bottom", holes=[], posts=[], text=[], , items=[], box_type="rounded4sides",has_flanges=false, flanges=[]){
	a_bit=0.01;
	echo("holes",holes);

	wall_t=box[5];
	cutaway_extra=0.01;
	if (which_half=="bottom") color("springgreen") {
		echo("bottom half");
		difference(){
		union(){//combine hollow cutout box with posts
			difference(){//cut away the lip and top half
				union(){//add the posts to the hollow box
					difference(){//make the hollow box
						box_type(box, box_type);
						box_type([box[0]-2*box[5],box[1]-2*box[5],box[2]-2*box[5],corner_radius-box[5],corner_sides], box_type);

					}
					make_posts(box, posts);//add the posts

				}
				translate(v=[0,0,box[2]*(1-top_bottom_ratio)-lip_h/2]){//cutting away other half and lip cutout

					difference(){//take interlockign feaetures away from lip cutout
						translate(v=[0,0,lip_h/2 - box[2]/2 ])rounded_rectangle_cylinder_hull(box[0]-(box[5]-lip_fit),box[1]-(box[5]-lip_fit),lip_h+0.01,corner_radius-(box[5]-lip_fit)/2,corner_sides);//cutout for lips
						//locking features
						if (has_locking_feature){
							echo("making locking feature");
							if (locking_feature_type=="hexagonal") translate(v=[0,0,lip_h/2 - locking_feature_r1 - (box[2]*(1-top_bottom_ratio)-lip_h/2)]){
								translate(v=[box_l/2-(wall_t/2-lip_fit/2),0,0])rotate(a=[90,90,0])scale(v=[1,locking_feature_r2/locking_feature_r1,1])cylinder(r=locking_feature_r1, h=19,center=true, $fn=6);
								mirror(v=[1,0,0])translate(v=[box_l/2-(wall_t/2-lip_fit/2),0,0])rotate(a=[90,90,0])scale(v=[1,locking_feature_r2/locking_feature_r1,1])cylinder(r=locking_feature_r1, h=locking_feature_hx,center=true, $fn=6);
								translate(v=[0,box_b/2-(wall_t/2-lip_fit/2),0])rotate(a=[90,90,90])scale(v=[1,locking_feature_r2/locking_feature_r1,1])cylinder(r=locking_feature_r1, h=locking_feature_hy,center=true, $fn=6);
								mirror(v=[0,1,0]) translate(v=[0,box_b/2-(wall_t/2-lip_fit/2),0])rotate(a=[90,90,90])scale(v=[1,locking_feature_r2/locking_feature_r1,1])cylinder(r=locking_feature_r1, h=locking_feature_hy,center=true, $fn=6);
							}
							if (locking_feature_type=="spheroid") translate(v=[0,0,lip_h/2 - locking_feature_r1 - (box[2]*(1-top_bottom_ratio)-lip_h/2)]){
								translate(v=[					box_l/2-(wall_t/2-lip_fit/2),0, box[2]*(0.5-top_bottom_ratio) ]) 				rotate(a=[90,0,90])scale(v=[locking_feature_max_lx/2,locking_feature_max_d/2,locking_feature_max_h])sphere(1, $fn=10);
								mirror(v=[1,0,0])translate(v=[	box_l/2-(wall_t/2-lip_fit/2),0, box[2]*(0.5-top_bottom_ratio) ])rotate(a=[90,0,90])scale(v=[locking_feature_max_lx/2,locking_feature_max_d/2,locking_feature_max_h])sphere(1, $fn=10);
								translate(v=[					0,box_b/2-(wall_t/2-lip_fit/2), box[2]*(0.5-top_bottom_ratio) ])				rotate(a=[90,0,0])scale(v=[locking_feature_max_ly/2,locking_feature_max_d/2,locking_feature_max_h])sphere(1, $fn=10);
								mirror(v=[0,1,0]) translate(v=[	0,box_b/2-(wall_t/2-lip_fit/2), box[2]*(0.5-top_bottom_ratio) ])rotate(a=[90,0,0])scale(v=[locking_feature_max_ly/2,locking_feature_max_d/2,locking_feature_max_h])sphere(1, $fn=10);
							}

						}
					}

					translate(v=[0,0,lip_h+cutaway_extra/2]) cube(size=[box[0]+2*cutaway_extra,box[1]+2*cutaway_extra,box[2]+cutaway_extra], center=true);//need to oversize this using cutaway_extra so it gets any extra material on the side the be removed on the outside (from posts)

				}
				#make_cutouts(box, holes);//remove the material for the cutouts// because this happens at the end you can make a hole in the centre of a post! perhaps a cone for a countersink screw through hole
				make_text(box, text);//text
				make_items(box, items);//items
			}
			//locking features
			if (has_locking_feature && locking_feature_type=="groove"){
				echo("making locking feature");
				translate(v=[0,0,lip_h/2 - locking_feature_r]){
					#translate(v=[box_l/2-(wall_t/2-lip_fit/2),0,0])rotate(a=[90,90,0])cylinder(r=locking_feature_r, h=20,center=true, $fn=6);
					#mirror(v=[1,0,0])translate(v=[box_l/2-(wall_t/2-lip_fit/2),0,0])rotate(a=[90,90,0])cylinder(r=locking_feature_r, h=20,center=true, $fn=6);
					# translate(v=[0,box_b/2-(wall_t/2-lip_fit/2),0])rotate(a=[90,90,90])cylinder(r=locking_feature_r, h=10,center=true, $fn=6);
					#mirror(v=[0,1,0]) translate(v=[0,box_b/2-(wall_t/2-lip_fit/2),0])rotate(a=[90,90,90])cylinder(r=locking_feature_r, h=10,center=true, $fn=6);
				}
			}

			if (has_flanges==true){
				make_flanges(box,wall_t,-(box[2]-wall_t)/2,flanges);
			}
		}

		}

	}else if (which_half=="top") color("crimson") {
		echo("top half");
		difference(){
		union(){
			intersection(){
				difference(){
					union(){
						difference(){//make hollow box
							box_type(box, box_type);
							box_type([box[0]-2*box[5],box[1]-2*box[5],box[2]-2*box[5],corner_radius-box[5],corner_sides], box_type);
						}
						make_posts(box,posts);//add the posts
					}
					#make_cutouts(box, holes);//remove material for cutouts
					make_text(box, text);//text
					make_items(box, items);//items
					//locking features
					if (has_locking_feature && locking_feature_type=="groove"){
						echo("making locking feature");
						translate(v=[0,0,- lip_h/2 + locking_feature_r]){
							#translate(v=[box_l/2-(wall_t/2+lip_fit/2),0,0])rotate(a=[90,90,0])cylinder(r=locking_feature_r, h=21,center=true, $fn=6);
							#mirror(v=[1,0,0])translate(v=[box_l/2-(wall_t/2+lip_fit/2),0,0])rotate(a=[90,90,0])cylinder(r=locking_feature_r, h=21,center=true, $fn=6);
							# translate(v=[0,box_b/2-(wall_t/2+lip_fit/2),0])rotate(a=[90,90,90])cylinder(r=locking_feature_r, h=11,center=true, $fn=6);
							#mirror(v=[0,1,0]) translate(v=[0,box_b/2-(wall_t/2+lip_fit/2),0])rotate(a=[90,90,90])cylinder(r=locking_feature_r, h=11,center=true, $fn=6);
						}
					}
				}
				translate(v=[0,0,(box[2]*(1-top_bottom_ratio))-lip_h/2]){
					union(){
						translate(v=[0,0,lip_h/2 - box[2]/2]) rounded_rectangle_cylinder_hull(box[0]-(box[5]+lip_fit),box[1]-(box[5]+lip_fit),lip_h+0.01,corner_radius-(box[5]+lip_fit)/2,corner_sides);//lips
						//locking features
						if (has_locking_feature){
							echo("making locking feature");
							if (locking_feature_type=="hexagonal") translate(v=[0,0,- lip_h/2 + locking_feature_r1 - ((box[2]*(1-top_bottom_ratio))-lip_h/2)]){
								translate(v=[box_l/2-(wall_t/2+lip_fit/2),0,0])rotate(a=[90,90,0])scale(v=[1,locking_feature_r2/locking_feature_r1,1])cylinder(r=locking_feature_r1, h=19,center=true, $fn=6);
								mirror(v=[1,0,0])translate(v=[box_l/2-(wall_t/2+lip_fit/2),0,0])rotate(a=[90,90,0])scale(v=[1,locking_feature_r2/locking_feature_r1,1])cylinder(r=locking_feature_r1, h=locking_feature_hx,center=true, $fn=6);
								translate(v=[0,box_b/2-(wall_t/2+lip_fit/2),0])rotate(a=[90,90,90])scale(v=[1,locking_feature_r2/locking_feature_r1,1])cylinder(r=locking_feature_r1, h=locking_feature_hy,center=true, $fn=6);
								mirror(v=[0,1,0]) translate(v=[0,box_b/2-(wall_t/2+lip_fit/2),0])rotate(a=[90,90,90])scale(v=[1,locking_feature_r2/locking_feature_r1,1])cylinder(r=locking_feature_r1, h=locking_feature_hy,center=true, $fn=6);
							}
							if (locking_feature_type=="spheroid") translate(v=[0,0,- lip_h/2 + locking_feature_r1 - ((box[2]*(1-top_bottom_ratio))-lip_h/2)]){
								translate(v=[box_l/2-(wall_t/2+lip_fit/2),0,    (box[2]*(0.5-top_bottom_ratio))     ]) 					rotate(a=[90,0,90])scale(v=[locking_feature_max_lx/2,locking_feature_max_d/2,locking_feature_max_h])sphere(1, $fn=10);
								mirror(v=[1,0,0])translate(v=[box_l/2-(wall_t/2+lip_fit/2),0,   (box[2]*(0.5-top_bottom_ratio))    ]) 	rotate(a=[90,0,90])scale(v=[locking_feature_max_lx/2,locking_feature_max_d/2,locking_feature_max_h])sphere(1, $fn=10);
								translate(v=[0,box_b/2-(wall_t/2+lip_fit/2),    (box[2]*(0.5-top_bottom_ratio))    ]) 					rotate(a=[90,0,0])scale(v=[locking_feature_max_ly/2,locking_feature_max_d/2,locking_feature_max_h])sphere(1, $fn=10);
								mirror(v=[0,1,0]) translate(v=[0,box_b/2-(wall_t/2+lip_fit/2),      (box[2]*(0.5-top_bottom_ratio))        ]) 	rotate(a=[90,0,0])scale(v=[locking_feature_max_ly/2,locking_feature_max_d/2,locking_feature_max_h])sphere(1, $fn=10);
							}
						}
					}
					translate(v=[0,0,lip_h-a_bit]) cube(size=[box[0]+2*cutaway_extra,box[1]+2*cutaway_extra,box[2]], center=true);
				}
			}
		}
		}
	}else{
		echo("invalid half requested",which_half);
	}
}

module rounded_rectangle_cylinder_hull(x,y,z,r,s){
	hull(){
		cross_box(x,y,z,r);//this is to ensure the overall dimensions stay true to those requested even for low-poly cylinders
		translate(v=[   x/2 -r ,   y/2 -r , 0])cylinder(h=z, r=r, center=true, $fn=4*s);
		translate(v=[   x/2 -r , -(y/2 -r), 0])cylinder(h=z, r=r, center=true, $fn=4*s);
		translate(v=[ -(x/2 -r), -(y/2 -r), 0])cylinder(h=z, r=r, center=true, $fn=4*s);
		translate(v=[ -(x/2 -r),   y/2 -r , 0])cylinder(h=z, r=r, center=true, $fn=4*s);
	}
}

module cross_box(x,y,z,r){
	cube(size=[x-2*r,y-2*r,z],center=true);
	cube(size=[x-2*r,y,z-2*r],center=true);
	cube(size=[x,y-2*r,z-2*r],center=true);
}

module make_cutouts(box, holes){
	box_l=box[0];//x
	box_b=box[1];//y
	box_h=box[2];//z
	box_t=[box[5],box[5],box[5]];//wall_t

	x_pos = 0;
	y_pos = 0;
	face = "X";

	echo("len(holes)",len(holes));
	for (j=[0:len(holes)-1]){
		// assign (angle = i*360/20, distance = i*10, r = i*2)
		assign (x_pos = holes[j][2][0], y_pos = holes[j][2][1], x_offs= holes[j][2][2], y_offs= holes[j][2][3], face = holes[j][0], shape_type=holes[j][1], shape_data=holes[j][3], rotation=holes[j][2][4], align=holes[j][2][5], depth=holes[j][3][0]){
			//echo("face",face);
			if (face=="N"){
				translate(v=[0,box_b/2,0])rotate(a=[-90,0,0])translate(v=[-(x_pos+x_offs),-(y_pos+y_offs),0]){
					//echo("alignment", align);
					if (align=="inside"){
						//echo("translate by",+depth/2-box_t);
						translate(v=[0,0,+depth/2-box_t[1]]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					}else if (align=="outside"){
						//echo("translate by",-depth/2);
						translate(v=[0,0,-depth/2]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					}else{
						echo("invalid alignment", align);
					}
				}
			}else if (face=="E"){
				translate(v=[box_l/2,0,0])rotate(a=[0,90,0])rotate(a=[0,0,-90])translate(v=[-(x_pos+x_offs),-(y_pos+y_offs),0]){
					//make_shape(shape_type, shape_data);
					if (align=="inside") translate(v=[0,0,+depth/2-box_t[0]]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="T"){
				translate(v=[0,0,box_h/2])rotate(a=[0,0,0])translate(v=[(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,+depth/2-box_t[2]]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="S"){
				translate(v=[0,-box_b/2,0])rotate(a=[+90,0,0])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,+depth/2-box_t[1]]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="W"){
				translate(v=[-box_l/2,0,0])rotate(a=[0,-90,0])rotate(a=[0,0,-90])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,+depth/2-box_t[0]]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="B"){
				//echo("bottom");
				translate(v=[0,0,-box_h/2])rotate(a=[0,180,0])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,+depth/2-box_t[2]]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else{
				echo("Unknown Face",face);
			}
		}
	}
}

module make_posts(box, posts){//this will be based on make_cutouts
	echo ("make_posts");
	a_bit=0.01;
	box_l=box[0];//x
	box_b=box[1];//y
	box_h=box[2];//z
	box_t=[box[5],box[5],box[5]];//wall_t [x,y,z]

	x_pos = 0;
	y_pos = 0;
	face = "X";
	echo("len(posts)",len(posts));
	for (j=[0:len(posts)-1]){
		// assign (angle = i*360/20, distance = i*10, r = i*2)
		assign (x_pos = posts[j][2][0], y_pos = posts[j][2][1], x_offs= posts[j][2][2], y_offs= posts[j][2][3], face = posts[j][0], shape_type=posts[j][1], shape_data=posts[j][3], rotation=posts[j][2][4], align=posts[j][2][5], depth=posts[j][3][0]-a_bit){
			if (face=="N"){
				translate(v=[0,box_b/2,0])rotate(a=[-90,0,0])translate(v=[-(x_pos+x_offs),-(y_pos+y_offs),0]){
					if (align=="inside"){
						translate(v=[0,0,-depth/2-box_t[1]]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					}else if (align=="outside"){
						translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					}else{
						echo("invalid alignment", align);
					}
				}
			}else if (face=="E"){
				translate(v=[box_l/2,0,0])rotate(a=[0,90,0])rotate(a=[0,0,-90])translate(v=[-(x_pos+x_offs),-(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,-depth/2-box_t[0]]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="T"){
				echo(face,align);
				translate(v=[0,0,box_h/2])rotate(a=[0,0,0])translate(v=[(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,-depth/2-box_t[2]]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,-rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="S"){
				translate(v=[0,-box_b/2,0])rotate(a=[+90,0,0])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,-depth/2-box_t[1]]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="W"){
				translate(v=[-box_l/2,0,0])rotate(a=[0,-90,0])rotate(a=[0,0,-90])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,-depth/2-box_t[0]]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="B"){
				translate(v=[0,0,-box_h/2])rotate(a=[0,180,0])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") translate(v=[0,0,-depth/2-box_t[2]]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else if (align=="outside") translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,rotation]) make_shape(shape_type, shape_data);
					else echo("invalid alignment", align);
				}
			}else{
				echo("Unknown Face",face);
			}
		}
	}
}

module make_shape(shape, shape_data){
	a_bit=0.01;//for ensuring manifoldness
	if(shape=="Square"){//[depth, length_breadth]
		cube(size=[shape_data[1],shape_data[1],shape_data[0]+a_bit],center=true);//do thing for square

	}else if(shape=="Rectangle"){//[depth, length, breadth]
		cube(size=[shape_data[1],shape_data[2],shape_data[0]+a_bit],center=true);//do thing for rectangle

	}else if(shape=="Round_Rect"){//[depth, length, breadth, corner_radius, corner_sides]
		rounded_rectangle_cylinder_hull(shape_data[1],shape_data[2],shape_data[0]+a_bit, shape_data[3], shape_data[4]);

	}else if(shape=="Cylinder"){ //(depth, radius ,sides)
		cylinder(r=shape_data[1],h=shape_data[0]+a_bit,center=true, $fn=shape_data[2]);//do thing for cylinder

	}else if(shape=="Ellipse"){ //(depth, radius_length, radius_breadth, sides)
		scale (v=[shape_data[1],shape_data[2],1])cylinder(r=1,h=shape_data[0]+a_bit,center=true, $fn=shape_data[3]);//do thing for ellipse

	}else if(shape=="Cone"){ //(depth, radius_bottom, radius_top ,sides)
		cylinder(r1=shape_data[1],r2=shape_data[2],h=shape_data[0]+a_bit,center=true, $fn=shape_data[3]);//do thing for cone

	}else if(shape=="Nub_Post"){ //(depth, radius_bottom, radius_top , depth_nub, sides)
		union(){
			echo ("make nub",shape_data);
			cylinder(r=shape_data[1], h=shape_data[0]+a_bit,center=true, $fn=shape_data[4]);//do thing for cylinder outside
			translate(v=[0,0,(-shape_data[0]+shape_data[3])/2]) cylinder(r=shape_data[2], h=shape_data[0]+a_bit,center=true, $fn=shape_data[4]);//do thing for cylinder inside
		}

	}else if(shape=="Dip_Post"){ //(depth, radius_bottom, radius_top ,depth_dip, sides)
		difference(){
			echo("dip_post",shape_data);
			cylinder(r=shape_data[1],h=shape_data[0]+a_bit, center=true,$fn=shape_data[4]);//do thing for cylinder outside
			translate(v=[0,0,(-shape_data[0]+shape_data[3])/2]) cylinder(r=shape_data[2], h=shape_data[3]+2*a_bit,center=true, $fn=shape_data[4]);//do thing for cylinder inside
		}
	}else if(shape=="Hollow_Cylinder"){ //(depth, radius_outside, radius_inside ,sides)
		difference(){
			cylinder(r=max(shape_data[2],shape_data[1]), h=shape_data[0]+a_bit,center=true, $fn=shape_data[3]);//do thing for cylinder outside
			cylinder(r=min(shape_data[2],shape_data[1]), h=shape_data[0]+2*a_bit,center=true, $fn=shape_data[3]);//do thing for cylinder inside
		}
	}else{
		echo("Unsupported Shape",shape);
	}
}

module box_type(box, box_type="rounded4sides"){
//basic initial if clause checker will identify if r or s are <=0 or 1 are reverts to a different shape otherwise (simple cuboid)
//this will aid in situations such as r<=wall_t so calculated internal r is now 0 or negative which could cause unexpected geometry or crashes
	if(box_type=="cuboid" || (box[3]<=0 || box[4]<=0)){//|| box[3]<=0 || box[4]=0
		cube(size=[box[0],box[1],box[2]],center=true);
	}else if(box_type=="rounded4sides"){
		rounded_rectangle_cylinder_hull(box[0],box[1],box[2],box[3],box[4]);
	}else if(box_type=="rounded6sides"){
		rounded_rectangle_sphere_hull(box[0],box[1],box[2],box[3],box[4]);
	}else if(box_type=="chamfered6sides"){
		chamfered_rectangle_hull(box[0],box[1],box[2],box[3]);
	}else{
		echo ("unknown box type requested",box_type);
	}
}

module chamfered_rectangle_hull(x,y,z,r){
	hull(){
		cross_box(x,y,z,r);//this is to ensure the overall dimensions stay true to those requested even for low-poly cylinders
	}
}

module rounded_rectangle_sphere_hull(x,y,z,r,s){
	hull(){
		cross_box(x,y,z,r);//this is to ensure the overall dimensions stay true to those requested even for low-poly cylinders
		translate(v=[   x/2 -r ,   y/2 -r ,   z/2 -r ])sphere(r=r, $fn=4*s);
		translate(v=[   x/2 -r , -(y/2 -r),   z/2 -r ])sphere(r=r,$fn=4*s);
		translate(v=[ -(x/2 -r), -(y/2 -r),   z/2 -r ])sphere(r=r,$fn=4*s);
		translate(v=[ -(x/2 -r),   y/2 -r ,   z/2 -r ])sphere(r=r,$fn=4*s);
		translate(v=[   x/2 -r ,   y/2 -r , -(z/2 -r)])sphere(r=r, $fn=4*s);
		translate(v=[   x/2 -r , -(y/2 -r), -(z/2 -r)])sphere(r=r, $fn=4*s);
		translate(v=[ -(x/2 -r), -(y/2 -r), -(z/2 -r)])sphere(r=r, $fn=4*s);
		translate(v=[ -(x/2 -r),   y/2 -r , -(z/2 -r)])sphere(r=r, $fn=4*s);
	}
}

module make_text(box, text){//this will be based on make_cutouts
	//[face_name, text_to_write, shape_position[x_pos,y_pos,x_offs,y_offs,rotate,align], shape_size[depth,font_height,font_spacing,mirror]]
	//["N", "Y+",			[0,0,0,0,0,"outside"], 					[1,4,1,true]]
//	echo ("make_text");
	a_bit=0.01;
	box_l=box[0];//x
	box_b=box[1];//y
	box_h=box[2];//z
	box_t=[box[5],box[5],box[5]];//wall_t [x,y,z]

//%	cube(size=[box_l,box_b,box_h],center=true);

	x_pos = 0;
	y_pos = 0;
	face = "X";
	//echo("len(text)",len(text));
	for (j=[0:len(text)-1]){
		// assign (angle = i*360/20, distance = i*10, r = i*2)
		assign (face = text[j][0], text_to_type=text[j][1], x_pos = text[j][2][0], y_pos = text[j][2][1], x_offs= text[j][2][2], y_offs= text[j][2][3], rotation=text[j][2][4], align=text[j][2][5], depth=text[j][3][0], text_height=text[j][3][1], text_spacing=text[j][3][2], text_mirror=text[j][3][3]){
			//echo("text face",face);
			if (face=="N")mirror(v=[text_mirror,0,0]){
				//translate(v=[0,box_b/2,0])rotate(a=[-90,0,0])translate(v=[-(x_pos+x_offs),-(y_pos+y_offs),0]){
					//echo("alignment", align);
					if (align=="inside") 		writecube(text_to_type,[-x_pos,0,y_pos],box_b-2*box_t[1],face="back", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");// translate(v=[0,0,-depth/2-box_t[1]]) rotate(a=[0,0,-rotation]) make_shape(text_to_type, shape_data);
					else if (align=="outside") 	writecube(text_to_type,[-x_pos,0,y_pos],box_b,face="back", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");// translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,-rotation]) make_shape(text_to_type, shape_data);
					else echo("invalid alignment", align);
				//}
			}else if (face=="E")mirror(v=[0,text_mirror,0]){
				//translate(v=[box_l/2,0,0])rotate(a=[0,90,0])rotate(a=[0,0,-90])translate(v=[-(x_pos+x_offs),-(y_pos+y_offs),0]){
					//make_shape(text_to_type, shape_data);
					if (align=="inside") 		writecube(text_to_type,[0,x_pos,y_pos],box_l-2*box_t[0],face="right", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf"); //translate(v=[0,0,-depth/2-box_t[0]]) rotate(a=[0,0,-rotation]) make_shape(text_to_type, shape_data);
					else if (align=="outside") 	writecube(text_to_type,[0,x_pos,y_pos],box_l,face="right", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,-rotation]) make_shape(text_to_type, shape_data);
					else echo("invalid alignment", align);
				//}
			}else if (face=="T")mirror(v=[text_mirror,0,0]){
				//echo(face,align);
				//translate(v=[0,0,box_h/2])rotate(a=[0,0,0])translate(v=[(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") 		writecube(text_to_type,[x_pos,y_pos,0],box_h-2*box_t[2],face="top", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-box_t[2]]) rotate(a=[0,0,-rotation]) make_shape(text_to_type, shape_data);
					else if (align=="outside") 	writecube(text_to_type,[x_pos,y_pos,0],box_h,face="top", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");// translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,-rotation]) make_shape(text_to_type, shape_data);
					else echo("invalid alignment", align);
				//}
			}else if (face=="S")mirror(v=[text_mirror,0,0]){
				//translate(v=[0,-box_b/2,0])rotate(a=[+90,0,0])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") 		writecube(text_to_type,[x_pos,0,y_pos,0],box_b-2*box_t[1],face="front", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-box_t[1]]) rotate(a=[0,0,rotation]) make_shape(text_to_type, shape_data);
					else if (align=="outside") 	writecube(text_to_type,[x_pos,0,y_pos,0],box_b,face="front", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,rotation]) make_shape(text_to_type, shape_data);
					else echo("invalid alignment", align);
				//}
			}else if (face=="W")mirror(v=[0,text_mirror,0]){
				//translate(v=[-box_l/2,0,0])rotate(a=[0,-90,0])rotate(a=[0,0,-90])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") 		writecube(text_to_type,[0,-x_pos,y_pos],box_l-2*box_t[0],face="left", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-box_t[0]]) rotate(a=[0,0,rotation]) make_shape(text_to_type, shape_data);
					else if (align=="outside") 	writecube(text_to_type,[0,-x_pos,y_pos],box_l,face="left", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,rotation]) make_shape(text_to_type, shape_data);
					else echo("invalid alignment", align);
				//}
			}else if (face=="B")mirror(v=[text_mirror,0,0]){
				//echo("bottom");
				//translate(v=[0,0,-box_h/2])rotate(a=[0,180,0])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") 		writecube(text_to_type,[x_pos,y_pos,0],box_h-2*box_t[2],face="bottom", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");//translate(v=[0,0,-depth/2-box_t[2]]) rotate(a=[0,0,rotation]) make_shape(text_to_type, shape_data);
					else if (align=="outside") 	writecube(text_to_type,[x_pos,y_pos,0],box_h,face="bottom", t=depth,h=text_height,space=text_spacing, rotate=rotation, font="orbitron.dxf");// translate(v=[0,0,-depth/2-a_bit]) rotate(a=[0,0,rotation]) make_shape(text_to_type, shape_data);
					else echo("invalid alignment", align);
				//}
			}else{
				echo("Unknown Face",face);
			}
		}
	}
}

module make_items(box, items){//this will be based on make_cutouts
	//external items on faces [face_name, external_file, shape_position[x_pos,y_pos,x_offs,y_offs,rotate,align], shape_size[scale_z,scale_x,scale_y,mirror]] Note: for silly reasons mirror must be 0 or 1 corresponding to false and true in this version
	//["N", "tyndall_logo_v0_2.stl",			[0,0,0,0,0,"outside"], 					[1,1,1,0]]
	echo ("make_items");
	a_bit=0.01;
	box_l=box[0];//x
	box_b=box[1];//y
	box_h=box[2];//z
	box_t=[box[5],box[5],box[5]];//wall_t [x,y,z]

	x_pos = 0;
	y_pos = 0;
	face = "X";
	echo("len(items)",len(items));
	for (j=[0:len(items)-1]){
		assign (face = items[j][0], items_to_use=items[j][1], x_pos = items[j][2][0], y_pos = items[j][2][1], x_offs= items[j][2][2], y_offs= items[j][2][3], rotation=items[j][2][4], align=items[j][2][5], scale_z=items[j][3][3], scale_x=items[j][3][1], scale_y=items[j][3][2], items_mirror=items[j][3][4], depth=items[j][3][0]){
			//echo("items face",face);
			if (face=="N")mirror(v=[items_mirror,0,0]){
				translate(v=[0,box_b/2,0])rotate(a=[-90,0,0])translate(v=[-(x_pos+x_offs),-(y_pos+y_offs),0]){
					//echo("alignment", align);
					if (align=="inside") 		translate(v=[0,0,-box_t[1]]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);//
					else if (align=="outside") 	 translate(v=[0,0,-depth])   rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);//make_shape(item_to_use, shape_data);
					else echo("invalid alignment", align);
				}
			}else if (face=="E")mirror(v=[0,items_mirror,0]){
				translate(v=[box_l/2,0,0])rotate(a=[0,90,0])rotate(a=[0,0,-90])translate(v=[-(x_pos+x_offs),-(y_pos+y_offs),0]){
					//make_shape(item_to_use, shape_data);
					if (align=="inside") 		translate(v=[0,0,-box_t[0]]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);
					else if (align=="outside") 	translate(v=[0,0,-depth]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);
					else echo("invalid alignment", align);
				}
			}else if (face=="T")mirror(v=[items_mirror,0,0]){
				//echo(face,align);
				translate(v=[0,0,box_h/2])rotate(a=[0,0,0])translate(v=[(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") 		translate(v=[0,0,-box_t[2]]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);
					else if (align=="outside") 	translate(v=[0,0,-depth]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);
					else echo("invalid alignment", align);
				}
			}else if (face=="S")mirror(v=[items_mirror,0,0]){
				translate(v=[0,-box_b/2,0])rotate(a=[+90,0,0])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") 		translate(v=[0,0,-box_t[1]]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);
					else if (align=="outside") 	translate(v=[0,0,-depth]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);
					else echo("invalid alignment", align);
				}
			}else if (face=="W")mirror(v=[0,items_mirror,0]){
				translate(v=[-box_l/2,0,0])rotate(a=[0,-90,0])rotate(a=[0,0,-90])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") 		translate(v=[0,0,-box_t[0]]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);
					else if (align=="outside") 	translate(v=[0,0,-depth]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);
					else echo("invalid alignment", align);
				}
			}else if (face=="B")mirror(v=[items_mirror,0,0]){
				//echo("bottom");
				translate(v=[0,0,-box_h/2])rotate(a=[0,180,0])translate(v=[-(x_pos+x_offs),(y_pos+y_offs),0]){
					if (align=="inside") 		translate(v=[0,0,-box_t[2]]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);
					else if (align=="outside") 	translate(v=[0,0,-depth]) rotate(a=[0,0,-rotation]) scale(v=[scale_x,scale_y,scale_z]) import(items_to_use);
					else echo("invalid alignment", align);
				}
			}else{
				echo("Unknown Face",face);
			}
		}
	}
}

module make_flanges(box,flange_t=2,pos_z=0,flange=[]){//box_x,box_y,box_z,box_r,box_s,wall_t, flange_t, slot_t,slot_w,flange_sides){
	//box_x,box_y,box_z,box_r,box_s,wall_t=box;
	a_bit=0.1;
	face=0;
	type="";
	pos_x=0;
	pos_y=0;
	flange_shape="";
	assign(x=box[0], y=box[1], box_z=box[2], z=flange_t, r=box[3], s=box[4], wall_t=box[5]){
		translate(v=[0,0,pos_z])difference(){
			hull(){
				//cross_box(x,y,z,r);//this is to ensure the overall dimensions stay true to those requested even for low-poly cylinders
				translate(v=[   x/2 -r ,   y/2 -r , 0])cylinder(h=z, r=r, center=true, $fn=4*s);
				translate(v=[   x/2 -r , -(y/2 -r), 0])cylinder(h=z, r=r, center=true, $fn=4*s);
				translate(v=[ -(x/2 -r), -(y/2 -r), 0])cylinder(h=z, r=r, center=true, $fn=4*s);
				translate(v=[ -(x/2 -r),   y/2 -r , 0])cylinder(h=z, r=r, center=true, $fn=4*s);//for 4 box corners

				for (j=[0:len(flange)-1]){
					assign(face=flange[j][0], type=flange[j][1], pos_x=flange[j][2][0], pos_y=flange[j][2][1], flange_shape=flange[j][3], flange_t=flange[j][3][0], flange_case_gap=flange[j][3][1], flange_wall_t=flange[j][3][2], slot_b=flange[j][3][3], slot_l=flange[j][3][4], flange_sides=flange[j][3][5]){

						if(type=="rounded_slot"){
							if(face=="N"){//North
								translate(v=[ -pos_x-(slot_l -slot_b)/2, y/2 +slot_b/2+flange_case_gap, 0])cylinder(h=z, r=(slot_b/2)+wall_t, center=true, $fn=4*flange_sides);
								translate(v=[ -pos_x+(slot_l -slot_b)/2,   y/2 +slot_b/2+flange_case_gap , 0])cylinder(h=z, r=(slot_b/2)+wall_t, center=true, $fn=4*flange_sides);
							}
							else if(face=="S") mirror(v=[0,1,0]){//south, mirror of above
								translate(v=[ -pos_x-(slot_l -slot_b)/2, y/2 +slot_b/2+flange_case_gap, 0])cylinder(h=z, r=(slot_b/2)+wall_t, center=true, $fn=4*flange_sides);
								translate(v=[ -pos_x+(slot_l -slot_b)/2,  y/2 +slot_b/2+flange_case_gap , 0])cylinder(h=z, r=(slot_b/2)+wall_t, center=true, $fn=4*flange_sides);
							}
							else if(face=="E"){//East
								translate(v=[ -(x/2 +slot_b/2+flange_case_gap), pos_x-(slot_l -slot_b)/2, 0])cylinder(h=z, r=(slot_b/2)+wall_t, center=true, $fn=4*flange_sides);
								translate(v=[ -(x/2 +slot_b/2+flange_case_gap), pos_x+(slot_l -slot_b)/2 , 0])cylinder(h=z, r=(slot_b/2)+wall_t, center=true, $fn=4*flange_sides);
							}
							else if(face=="W") mirror(v=[1,0,0]){//West
								translate(v=[ -(x/2 +slot_b/2+flange_case_gap), pos_x-(slot_l -slot_b)/2, 0])cylinder(h=z, r=(slot_b/2)+wall_t, center=true, $fn=4*flange_sides);
								translate(v=[ -(x/2 +slot_b/2+flange_case_gap),  pos_x+(slot_l -slot_b)/2 , 0])cylinder(h=z, r=(slot_b/2)+wall_t, center=true, $fn=4*flange_sides);
							}else{
								echo("unknown face",face);
							}
						}else{
							echo("unsupported type",type);
						}
					}
				}
			}
			//remove material for box hollow
			rounded_rectangle_cylinder_hull(x-2*wall_t,y-2*wall_t,box_z-2*wall_t,max(0,r-wall_t),s);
			//remove material for slots
				for (k=[0:len(flange)-1]){
					assign(face=flange[k][0], type=flange[k][1], pos_x=flange[k][2][0], pos_y=flange[k][2][1], flange_shape=flange[k][3], flange_t=flange[k][3][0], flange_case_gap=flange[k][3][1], flange_wall_t=flange[k][3][2], slot_b=flange[k][3][3], slot_l=flange[k][3][4], flange_sides=flange[k][3][5]){
					if(type=="rounded_slot"){
						if(face=="N")hull(){//East
							translate(v=[ -pos_x-(slot_l -slot_b)/2, y/2 +slot_b/2+flange_case_gap, 0])cylinder(h=z+a_bit, r=slot_b/2, center=true, $fn=4*s);
							translate(v=[ -pos_x+(slot_l -slot_b)/2, y/2 +slot_b/2+flange_case_gap, 0])cylinder(h=z+a_bit, r=slot_b/2, center=true, $fn=4*s);
						}
						else if(face=="S") hull(){
							mirror(v=[0,1,0]){
								translate(v=[ -pos_x-(slot_l -slot_b)/2, y/2 +slot_b/2+flange_case_gap, 0])cylinder(h=z+a_bit, r=slot_b/2, center=true, $fn=4*s);
								translate(v=[ -pos_x+(slot_l -slot_b)/2, y/2 +slot_b/2+flange_case_gap, 0])cylinder(h=z+a_bit, r=slot_b/2, center=true, $fn=4*s);
							}
						}else if(face=="E")hull(){//East
							translate(v=[ -(x/2 +slot_b/2+flange_case_gap), pos_x-(slot_l -slot_b)/2, 0])cylinder(h=z+a_bit, r=slot_b/2, center=true, $fn=4*s);
							translate(v=[ -(x/2 +slot_b/2+flange_case_gap), pos_x+(slot_l -slot_b)/2, 0])cylinder(h=z+a_bit, r=slot_b/2, center=true, $fn=4*s);
						}
						else if(face=="W") hull(){
							mirror(v=[1,0,0]){
								translate(v=[ -(x/2 +slot_b/2+flange_case_gap), pos_x-(slot_l -slot_b)/2, 0])cylinder(h=z+a_bit, r=slot_b/2, center=true, $fn=4*s);
								translate(v=[ -(x/2 +slot_b/2+flange_case_gap), pos_x+(slot_l -slot_b)/2, 0])cylinder(h=z+a_bit, r=slot_b/2, center=true, $fn=4*s);
							}
						}else{
							echo("unknown face",face);
						}
					}else{
						echo("unsupported type",type);
					}
				}
			}
		}
	}
}
