$fn = 300;

union() {
    difference() {
        cube([40, 18, 18]);
        
        translate([-1, 9, 9])
        rotate(a=90, v=[0,1,0])
        cylinder(50, 4, 4);
        
        u = sqrt(8*8*2);
        
        translate([-1, 9, 9])
        rotate(a=90, v=[0,1,0])
        cylinder(7, u/2, u/2, $fn=6);
    }
    
    translate([9, 9, 18]) color("blue") cylinder(40, 9, 9);
}