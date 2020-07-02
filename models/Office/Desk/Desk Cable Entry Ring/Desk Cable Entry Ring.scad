/* CONFIGURATION */

// corresponds to the inner diameter of the hole in the desk (i.e., the outer diameter of the hole saw)
// you can print the item slightly larger for a tight fit in the end (i.e., to compensate the slot)
hole_diameter = 65;

// thickness of your tabletop
desk_thickness = 25;

// thickness of all walls
// 1.2mm appears to work fine for PLA; you might be able to increase thickness on more flexible materials like PETG
wall_thickness = 1.2;

// cut a slot into the ring to be able to wrap it around cables already in the hole
// only really needed when fitting this in subsequently, set to 0 to disable
slot_width = 1;

// a top layer is added to the ring to prevent the ring from falling through the desk
top_layer_width = 5;

/* CONFIGURATION END */

// top layer that prevents the ring from falling through the desk
top_layer_diameter = hole_diameter + wall_thickness + top_layer_width;
inner_diameter = hole_diameter - 2 * wall_thickness;

$fn = 350;

// print upside down so the top layer attaches the object to the bed
// this way, no other attachment helpers like a brim or raft are needed to print this item
rotate([180, 0, 0])
difference() {
    rotate_extrude() {
        polygon([
            [inner_diameter / 2, 0],
            [hole_diameter / 2, 0],
            [hole_diameter / 2, desk_thickness],
            [top_layer_diameter / 2, desk_thickness],
            [top_layer_diameter / 2, desk_thickness + wall_thickness],
            [inner_diameter / 2, desk_thickness + wall_thickness],
        ]);
    }

    if (slot_width > 0) {
        translate([-0.5 * slot_width, 0, 0])
        cube([slot_width, top_layer_diameter / 2, desk_thickness + wall_thickness]);
    }
}