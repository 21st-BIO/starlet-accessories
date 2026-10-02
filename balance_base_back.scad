// OHAUS Navigator Balance Base — BACK PLATE
// Has join slots on front face to receive front plate fingers.
// Assembly: push this plate forward into the front plate join fingers.
// Print orientation: flat base down, text / pockets facing up.

// ─── Balance foot parameters ─────────────────────────────────
foot_d     = 33.0;
foot_depth =  3.0;
foot_lr    = 163.64;  // +1.5mm L-R spacing
foot_fb    = 188.09;
wall       =  8.0;

// ─── Base plate ──────────────────────────────────────────────
base_h = 5.06;

// ─── Finger parameters (must match front plate) ───────────────
finger_w   = 16.0;   // -0.5mm to preserve pitch: finger_w + finger_gap = 23.0mm
finger_h   =  5.0;
finger_gap =  7.0;   // +0.5mm — pitch held constant by reducing finger_w
n_fingers  =  6;

// ─── Join slots ──────────────────────────────────────────────
join_depth = 20.0;
join_cl    =  0.2;

// ─── Trim ─────────────────────────────────────────────────────
back_trim = 1.0;   // shorten back plate so back foot holes move 1mm closer to front

// ─── Derived ─────────────────────────────────────────────────
base_w    = foot_lr + foot_d + 2 * wall;
base_d    = foot_fb + foot_d + 2 * wall;
back_d    = base_d / 2 - back_trim;
fp_x      = wall + foot_d / 2;
fp_y      = wall + foot_d / 2;
fp_y_back = back_d - fp_y;
join_z    = (base_h - finger_h) / 2;

eps = 0.01;
$fn = 64;

module foot_pocket() {
    cylinder(d = foot_d + 0.4, h = foot_depth + eps);
}

module join_slots() {
    total_w = n_fingers * finger_w + (n_fingers - 1) * finger_gap;
    x0      = base_w / 2 - total_w / 2;
    for (i = [0 : n_fingers - 1])
        translate([x0 + i * (finger_w + finger_gap) - join_cl, -eps, join_z - join_cl])
            cube([finger_w + 2*join_cl, join_depth + eps, finger_h + 2*join_cl]);
}

module engrave_label(str, cx, cy, sz) {
    translate([cx, cy, base_h - 0.8])
        linear_extrude(0.8 + eps)
            text(str, size = sz, font = "Arial:style=Bold",
                 halign = "center", valign = "center");
}

difference() {
    cube([base_w, back_d, base_h]);
    translate([fp_x,          fp_y_back, base_h - foot_depth]) foot_pocket();
    translate([base_w - fp_x, fp_y_back, base_h - foot_depth]) foot_pocket();
    join_slots();
    engrave_label("BACK", base_w / 2, back_d * 0.58, 18);
    engrave_label(str("lr=",foot_lr,"  fb=",foot_fb,"  trim=",back_trim,"  fw=",finger_w,"  fg=",finger_gap),
                  base_w / 2, back_d * 0.35, 6.0);
}
