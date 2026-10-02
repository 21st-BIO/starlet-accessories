// Hamilton STARlet — Q-Tray Deck Adapter
//
// Flat platform with torpedo-slot fingers (same geometry as balance base).
// Q-tray rests on the platform surface; corner L-posts locate it in X and Y.
//
// *** MEASURE THE Q-TRAY WITH CALIPERS AND FILL IN THE TODO VALUES BELOW ***
//
// Torpedo pitch constraint: finger_w + finger_gap MUST equal 23.0 mm.
// Changing one requires an equal, opposite change to the other.
//
// Print: flat base down, fingers pointing toward torpedoes.
// Material: PETG, 4 perimeters, 40% infill.

// ─── Q-Tray footprint — MEASURE AND VERIFY ──────────────────────
tray_l = 100.0;   // TODO: Q-tray outer length (X) — measure with calipers
tray_w =  60.0;   // TODO: Q-tray outer depth  (Y) — measure with calipers
cl     =   0.8;   // clearance per side inside corner posts

// ─── Platform plate ─────────────────────────────────────────────
base_h = 5.0;    // plate thickness
rim    = 8.0;    // plate extends this far beyond tray footprint on all sides

// ─── Corner locating posts ──────────────────────────────────────
post_h   = 8.0;   // post height above plate surface
post_leg = 15.0;  // length of each L-post leg along the tray edge
post_t   =  4.0;  // post wall thickness

// ─── Torpedo alignment fingers — DO NOT CHANGE PITCH ────────────
finger_w   = 16.0;  // -0.5 mm from nominal — pitch = finger_w + finger_gap = 23.0 mm
finger_h   =  5.0;  // finger height (matches torpedo groove depth)
finger_gap =  7.0;  // +0.5 mm — pitch held constant by reducing finger_w
fork_depth = 25.0;  // insertion depth into torpedo slot
n_fingers  =  4;    // TODO: set to span the correct number of torpedo slots

// ─── Derived ────────────────────────────────────────────────────
pitch       = finger_w + finger_gap;   // = 23.0 mm — fixed
finger_span = n_fingers * finger_w + (n_fingers - 1) * finger_gap;
outer_l     = tray_l + 2 * rim;
outer_w     = tray_w + 2 * rim;
plate_x0    = (finger_span - outer_l) / 2;

eps = 0.01;
$fn = 48;

module lpost() {
    cube([post_t, post_leg, post_h]);
    cube([post_leg, post_t, post_h]);
}

difference() {
    union() {
        translate([plate_x0, 0, 0])
            cube([outer_l, outer_w, base_h]);

        for (i = [0 : n_fingers - 1])
            translate([i * pitch, -fork_depth, 0])
                cube([finger_w, fork_depth, finger_h]);

        // Front-left
        translate([plate_x0 + rim - cl - post_t, rim - cl - post_t, base_h]) lpost();
        // Front-right
        translate([plate_x0 + rim + tray_l + cl + post_t, rim - cl - post_t, base_h])
            mirror([1, 0, 0]) lpost();
        // Back-left
        translate([plate_x0 + rim - cl - post_t, rim + tray_w + cl + post_t, base_h])
            mirror([0, 1, 0]) lpost();
        // Back-right
        translate([plate_x0 + rim + tray_l + cl + post_t, rim + tray_w + cl + post_t, base_h])
            mirror([1, 0, 0]) mirror([0, 1, 0]) lpost();
    }

    translate([plate_x0 + outer_l / 2, rim * 0.60, base_h - 0.8])
        linear_extrude(0.8 + eps)
            text("Q-TRAY", size = 5.0, font = "Arial:style=Bold",
                 halign = "center", valign = "center");
    translate([plate_x0 + outer_l / 2, rim * 0.18, base_h - 0.8])
        linear_extrude(0.8 + eps)
            text(str("l=", tray_l, "  w=", tray_w, "  n=", n_fingers),
                 size = 3.5, font = "Arial",
                 halign = "center", valign = "center");
}
