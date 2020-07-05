/* CONFIGURATION */

// 1.2mm is pretty sturdy; could be thicker if needed, but shouldn't be necessary for normal use
wall_thickness = 1.2;

// total length of the cylinder that takes the "vacuum elbow"
// it needs to extend into the "cup" to create a gapless connection
pipe_holder_length = 50;
// if set to 0, the pipe holder starts at the center of the "cup"
// one can/should offset it downwards by at least the radius of the drill hole
// TODO: calculate optimal offset (i.e., offset as much as possible while keeping a gapless connection
pipe_holder_vertical_offset = 18;

// inner radius of the "cup" part
cup_inner_radius = 25;

// inner width and height of the groove for the sealing
// width should be slightly larger than your actual sealing, height should be ~0.5 to 1 mm less
groove_width = 10;
groove_height = 2;

// hole for the drill (also allows the user to align the drill bit visually)
drill_hole_radius = 12.5;

// 34.6 + 0.2mm play
// inner diameter of the pipe holder
// enter the (largest) outer diameter of your part plus ~0.2mm of play
// (you can also add more, it can always be compensated with some tape)
// example value: the elbow attachment of the vacuum this was printed for initially measured 34.6mm, so we use 34.8
pipe_holder_inner_diameter = 34.8;

/* END OF CONFIGURATION */


$fn = 120;

// simpler version of the cylinder(...) module
module basic_cylinder(height, radius) {
      linear_extrude(height) circle(radius);
}

module pipe_holder(r, l = pipe_holder_length, o = 0, h_off = 0, a = 90, pipe_half_l=20) {
    hull() {
        // upper half
        color("green") rotate(a=[0, a, 0]) union() {
            linear_extrude(pipe_half_l) translate([-wall_thickness, 0, 0]) difference() {
                circle(r);
                translate([-r-wall_thickness+h_off, -r, 0]) square([r, r*2]);
            }
        }
        
        // lower half
        rotate(a=[0, a, 0]) translate([-wall_thickness, 0, o+pipe_half_l]) basic_cylinder(l-pipe_half_l, r);
    }
}

// rotate in print direction
// a brim or raft are absolutely necessary for printing
rotate(a=[0, 90, 0]) difference() {
    pipe_holder_inner_radius = pipe_holder_inner_diameter / 2;
    
    // we don't want to restrict the airflow too much but still reduce the overall height
    // a sensible value is to use half the pipe holder radius
    cup_h = pipe_holder_inner_radius + wall_thickness * 2;
    
    // we start by creating the basic form as a solid, then subtract other parts to hollow it out
    union() {
        difference() {
            union() {
                // this'll become the "cup-like" part that surrounds the (future) hole
                basic_cylinder(cup_h, cup_inner_radius + wall_thickness);
                
                // we need to define the pipe here already before removing the interior of the "cup" part to
                // make sure the pipe is cut off with circular shape as well
                translate([pipe_holder_vertical_offset, 0, pipe_holder_inner_radius])
                pipe_holder(pipe_holder_inner_radius + wall_thickness);
            }
            
            // remove interior of the "cup-like" part
            color("red") basic_cylinder(cup_h - wall_thickness, cup_inner_radius);
        }

        // create the "grooved ring" that will be filled with some sealing
        difference() {
            // outer part of the ring
            color("blue") difference() {
                basic_cylinder(groove_height + wall_thickness, cup_inner_radius + groove_width + wall_thickness);
                basic_cylinder(groove_height + wall_thickness, cup_inner_radius);
            }
            
            // remove a smaller one to create the groove for the sealing
            color("green") difference() {
                basic_cylinder(groove_height, cup_inner_radius + groove_width);
                basic_cylinder(groove_height, cup_inner_radius - wall_thickness);
            }
        }
    }
    
    // remove interior of pipe
    translate([pipe_holder_vertical_offset, 0, pipe_holder_inner_radius])
    color("purple")
    pipe_holder(pipe_holder_inner_radius, h_off=wall_thickness);
    
    // hole for the drill (needs to be tall enough to pervade all objects)
    translate([0, 0, 5])
    color("lime")
    basic_cylinder(pipe_holder_inner_diameter * 2, drill_hole_radius);
}
