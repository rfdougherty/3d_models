// Adapted from http://www.thingiverse.com/thing:211643

// all measurments in mm
height = 85;
radius = 100 / 2;
thick = 1.6;

// number of sides. Set to something like 200 for a round pot.
res = 10;

// Saucer try height proportion; Try .15 - .3
sHeight = .21;

// Saucer gap (in mm)
sGap = 1.5;

// Number of drain holes. 
numDrains = 8;

// For non-round pots, the number of drains should == res.
nDrain = res<=12 ? res : numDrains;

offset = thick*2 + sGap;
h2 = (height * sHeight) + thick;
h3 = h2 + (offset/2) + thick;
h1 = h3 - offset - thick;
r1 = radius - offset;

faceOS = 0.01;
faceOS2 = faceOS * 2;
drainH_Hold = (h1 - 2) * 1.414;

drainH = drainH_Hold < 5 ? 5 : drainH_Hold;

union(){
  base();
  taper();
  top();
  drain();
}

module drain(){
	difference(){
		cylinder(h = h1, r1 = r1, r2 = r1, $fn = res);
	
		translate([0,0,-faceOS]) 
			cylinder(h = h1 + faceOS2, r1 = r1 - thick, r2 = r1 - thick, $fn = res);
   	
		for( i = [1:nDrain]){
			rotate([90,0,(360/nDrain) * (i + ((nDrain - 2) % 4) * 0.25) ]) 
				translate([0,(-.707*drainH),0]) 
					rotate([0,0,45]) 
						cube([drainH,drainH*.6,r1]);
    }
	}
}

module base(){
	difference(){
		cylinder(h = h2, r1 = radius, r2 = radius, $fn = res);
		translate([0,0,thick]) 
			cylinder(h = h2+.1, r1 = radius - thick, r2 = radius - thick, $fn = res);
  }
}


module top(){
	difference(){
		translate([0,0,h3]) 
			cylinder(h = height - h3, r1 = radius, r2 = radius, $fn = res);

		translate([0,0,h3-.1]) 
			cylinder(h = (height - h3) + 1.1, r1 = radius - thick, r2 = radius - thick, $fn = res);
  }
}

module taper(){
	translate([0,0,h1]){
    difference(){
      cylinder(h = h3-h1, r1 = r1,    r2 = radius,    $fn = res);
      cylinder(h = h3-h1, r1 = r1-thick, r2 = radius-thick, $fn = res);
      translate([0,0,h3 - h1 - faceOS]) 
        cylinder(h = 1, r1 = radius-thick, r2 = radius-thick, $fn = res);
      translate([0,0,-faceOS]) 
        cylinder(h = faceOS2, r1 = r1-thick, r2 = r1-thick, $fn = res);
    }
  }
}

