// Fork test piece — verify torpedo fit before printing full balance base
// Print flat (fingers pointing away), slide over deck torpedoes to check fit.

fork_depth = 25.0;
finger_w   = 16.5;
finger_h   =  5.0;
finger_gap =  6.5;
n_fingers  =  2;
test_pad   = 20.0;

total_w = n_fingers * finger_w + (n_fingers - 1) * finger_gap;
test_w  = total_w + 2 * test_pad;
cx      = test_w / 2;
base_h  =  5.06;
eps     =  0.01;

$fn = 48;

// Handle body with engraved label
difference() {
    cube([test_w, test_pad, base_h]);
    translate([test_w / 2, test_pad * 0.72, base_h - 0.8])
        linear_extrude(0.8 + eps)
            text("FORK TEST", size = 4.0, font = "Arial:style=Bold",
                 halign = "center", valign = "center");
    translate([test_w / 2, test_pad * 0.25, base_h - 0.8])
        linear_extrude(0.8 + eps)
            text(str("w=", finger_w, "  gap=", finger_gap, "  n=", n_fingers, "  d=", fork_depth),
                 size = 3.0, font = "Arial",
                 halign = "center", valign = "center");
}

// Fingers
x0 = cx - total_w / 2;
for (i = [0 : n_fingers - 1])
    translate([x0 + i * (finger_w + finger_gap), -fork_depth, 0])
        cube([finger_w, fork_depth, finger_h]);
