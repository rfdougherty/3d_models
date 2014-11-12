i = 25.4;

hole_rad = 4.4;
z = 1.2*i;
sy = 1*i;

x = ((5+16/32)/2) * i;
xt = (2+27/32) * i;
sx = (1/2) * i;
y = 73;
yt = 18/32*i;

// Set the angular resolution ($fn segments per 360 deg)
$fn = 60;

module strut_half(){
difference(){
    cube([x+sx, y, z]);
    
    translate([0,0,-.2]) cube([x,y-yt*1.46,z+.4]);

    #translate([-xt/2*0.41,-yt*.35,-.2]) rotate([0,0,-11]) cube([xt,xt,z+.4]);

    //                        0           1          2            3           4           5             6             7 
    //#trapezoid();

    translate([x/1.3, y+5, z/2]) rotate([90,0,0]) cylinder(r=hole_rad/2, h=z*1.5);
    translate([x/1.3, y-14, z/2]) rotate([90,0,0]) cylinder(r2=hole_rad/2*3, r1=hole_rad/2, h=6);

}
}

rotate([-90,0,0]) {
    strut_half();
    mirror([1, 0, 0]) translate([0,0,0]) strut_half();
}

module trapezoid(){
polyhedron(points = [[-s,-s,-s], [-s,-s,z+s], [-s,cy,-s], [-s,cy,z+s], [cx,-s,-s], [cx,-s,z+s], [cx,sy,-s], [cx,sy,z+s]], 
       faces = [[0,1,5,4,0], [0,2,3,1,0], [2,6,8,3,2], [6,4,5,7,6], [0,1,5,4,0], [0,4,6,2,0], [1,3,7,5,1]],
       convexity=60);
}
  
