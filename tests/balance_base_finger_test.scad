// Finger alignment test — 6 fingers + 10mm base stub
// Slide onto deck torpedoes to verify fit before printing full plates.
// Print flat (fingers pointing away from you).

finger_w   = 16.0;
finger_h   =  5.0;
finger_gap =  7.0;
n_fingers  =  6;
fork_depth = 25.0;
pad_depth  = 10.0;

total_w = n_fingers * finger_w + (n_fingers - 1) * finger_gap;

eps = 0.01;
$fn = 32;

difference() {
    // Base stub — connects all fingers
    cube([total_w, pad_depth, finger_h]);

    // Title
    translate([total_w / 2, pad_depth * 0.72, finger_h - 0.8])
        linear_extrude(0.8 + eps)
            text("FINGER TEST", size = 4.0, font = "Arial:style=Bold",
                 halign = "center", valign = "center");

    // Parameters
    translate([total_w / 2, pad_depth * 0.25, finger_h - 0.8])
        linear_extrude(0.8 + eps)
            text(str("w=", finger_w, "  gap=", finger_gap, "  n=", n_fingers, "  depth=", fork_depth),
                 size = 3.2, font = "Arial",
                 halign = "center", valign = "center");
}

// Fingers
for (i = [0 : n_fingers - 1])
    translate([i * (finger_w + finger_gap), -fork_depth, 0])
        cube([finger_w, fork_depth, finger_h]);
