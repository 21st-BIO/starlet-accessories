// OHAUS Navigator Balance Base — FRONT PLATE
// Has deck alignment fingers (toward torpedoes) and join fingers on back face.
// Assembly: slide this plate onto deck torpedoes first, then push back plate in.
// Print orientation: flat base down, text / pockets facing up.

// ─── Balance foot parameters ─────────────────────────────────
foot_d     = 33.0;
foot_depth =  3.0;
foot_lr    = 163.64;  // +1.5mm L-R spacing
foot_fb    = 188.09;
wall       =  8.0;

// ─── Base plate ──────────────────────────────────────────────
base_h = 5.06;

// ─── Deck alignment fingers ──────────────────────────────────
fork_depth = 25.0;
finger_w   = 16.0;   // -0.5mm to preserve pitch: finger_w + finger_gap = 23.0mm
finger_h   =  5.0;
finger_gap =  7.0;   // +0.5mm — pitch held constant by reducing finger_w
n_fingers  =  6;

// ─── Join fingers ────────────────────────────────────────────
join_depth = 20.0;
join_cl    =  0.2;

// ─── Derived ─────────────────────────────────────────────────
base_w    = foot_lr + foot_d + 2 * wall;
base_d    = foot_fb + foot_d + 2 * wall;
front_d   = base_d / 2;
fp_x      = wall + foot_d / 2;
fp_y      = wall + foot_d / 2;
join_z    = (base_h - finger_h) / 2;

eps = 0.01;
$fn = 64;

module foot_pocket() {
    cylinder(d = foot_d + 0.4, h = foot_depth + eps);
}

module deck_fingers() {
    total_w = n_fingers * finger_w + (n_fingers - 1) * finger_gap;
    x0      = base_w / 2 - total_w / 2;
    for (i = [0 : n_fingers - 1])
        translate([x0 + i * (finger_w + finger_gap), -fork_depth, 0])
            cube([finger_w, fork_depth, finger_h]);
}

module join_fingers() {
    total_w = n_fingers * finger_w + (n_fingers - 1) * finger_gap;
    x0      = base_w / 2 - total_w / 2;
    for (i = [0 : n_fingers - 1])
        translate([x0 + i * (finger_w + finger_gap), 0, join_z])
            cube([finger_w, join_depth, finger_h]);
}

module engrave_label(str, cx, cy, sz) {
    translate([cx, cy, base_h - 0.8])
        linear_extrude(0.8 + eps)
            text(str, size = sz, font = "Arial:style=Bold",
                 halign = "center", valign = "center");
}

difference() {
    cube([base_w, front_d, base_h]);
    translate([fp_x,          fp_y, base_h - foot_depth]) foot_pocket();
    translate([base_w - fp_x, fp_y, base_h - foot_depth]) foot_pocket();
    engrave_label("FRONT", base_w / 2, front_d * 0.65, 18);
    engrave_label(str("lr=",foot_lr,"  fb=",foot_fb,"  fw=",finger_w,"  fg=",finger_gap,"  n=",n_fingers),
                  base_w / 2, front_d * 0.42, 6.0);
}
deck_fingers();
translate([0, front_d, 0]) join_fingers();
