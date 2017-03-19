
height = 20;
width = 50;
length = 90;
module block(){
  union(){
    cube([width,length,height]);
    translate([width/2,20,height])
      cylinder(h=60, r1=20, r2=1, $fn=40);
  }
}

d = 22;
difference(){
  block();
  for(x=[d-7,d*2-7]) 
    for(y=[d+35,d*2+35])
      translate([x,y,1]) 
        cylinder(h=60, r1=1, r2=20, center=false, $fn=40);
}