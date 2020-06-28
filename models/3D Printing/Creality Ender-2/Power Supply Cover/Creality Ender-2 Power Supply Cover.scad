/* CONFIGURATION */

// Inner dimensions (dimensions of PSU's front view)
i_w = 112;
i_h = 51;

// wall thickness -- 2mm is recommended, the resulting part will be really robust
wall = 2;

// cover's inner length
// the original part had 61mm, and there's been some space at the end
// however, to give the C14 socket some additional space, we add a little more
i_l = 61 + 10;

/* END CONFIGURATION */


// outer dimensions (calculated from the inner)
o_w = i_w + 2 * wall;
o_l = i_l + wall;
o_h = i_h + 2 * wall;

// original hole diameter is ~ 4mm, but the resulting fit is too lose and there's washers required
// to make the screws hold it properly
b = 5/2;

// the part you put inside the device is the male connector, so one might be tempted to call it a plug
// however, usability wise it's a socket, therefore we'll call a socket here
// this template should work for a majority of plugs, but you should measure yours to make sure it'll fit
module C14_Socket() {
    // holes radius
    b = 2;
    
    // dimensions of the plug
    h = 19;
    w = 27;
    
    $fn = 50;
    
    // holes
    translate([0, h/2]) circle(b);
    translate([7 + w + 7, h/2]) circle(b);
    
    // connector part
    translate([7, 0]) square([w, h]);
}


$fn = 50;

// the actual case
// we rotate it to make printing it easier
rotate([90, 0, 0])
difference() {
    // main body (will be open on the rear end to allow the user to slide in the PSU)
    cube([o_w, o_l, o_h]);

    // inner groove (the PSU will be sled into it)
    translate([wall, wall, wall])
    cube([i_w, i_l, i_h]);
    
    // mounting screw hole on the right wall
    translate([i_w, o_l - 21, 26 + wall])
    rotate([90, 0, 90])
    cylinder(10, b, b);
    
    // mounting screw hole on the bottom wall
    translate([7.5 + wall, o_l - 35, -1])
    rotate([0, 0, 0])
    cylinder(10, b, b);
    
    // cutout for the C14 socket
    translate([25, 5, o_h - wall - 22])
    rotate([90, 0, 0])
    linear_extrude(10) C14_Socket();
    
    // hole for the 12 cable that goes to the printer mainboard
    // use cable ties for strain relief
    translate([80, 5, 20])
    rotate([90, 0, 0])
    cylinder(10, 5, 5);
}


