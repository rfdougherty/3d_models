wood_thick = 6.9;
width = 30;
length = 40; //138/2;
thick = 2.4;

module part(){
    cube([width, length, thick]);

    offset = width/2-thick;

    translate([offset-wood_thick/2, 0, thick]) cube([thick,length,width/3]);
    translate([offset-wood_thick/2-thick, 0, thick]) cube([thick,length,thick]);

    translate([offset+wood_thick/2+thick,0,thick]) cube([thick,length,width/3]);
    translate([offset+wood_thick/2+2*thick,0,thick]) cube([thick,length,thick]);
}

sep = 3;
translate([sep,0,0]) part();
translate([-(sep+width),0,0]) part();

