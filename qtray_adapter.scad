// Hamilton STARlet — Vacuum Manifold Deck Adapter
//
// Flat platform with torpedo-slot fingers (same geometry as balance base).
// The manifold sits on the platform; four recessed pockets receive the
// rubber feet on the manifold base, locating it precisely in X and Y.
// A 1 cm engraved grid on the top surface aids visual alignment during setup.
//
// DIMENSIONS ESTIMATED FROM RULER PHOTOS — verify with calipers before printing:
//   - foot_d   : measure rubber foot diameter with calipers
//   - foot_lr  : measure left-right centre-to-centre distance between feet
//   - foot_fb  : measure front-back centre-to-centre distance between feet
//   - foot_h   : measure how tall the foot protrudes from the manifold base
//
// Torpedo pitch constraint: finger_w + finger_gap MUST equal 23.0 mm.
// Changing one requires an equal, opposite change to the other.
//
// Print: flat base down.
// Material: PETG, 4 perimeters, 40% infill.

// ─── Rubber foot dimensions — VERIFY WITH CALIPERS ─────────────
foot_d     = 20.0;    // TODO: rubber foot diameter
foot_h     =  4.0;    // TODO: rubber foot protrusion height from manifold base
foot_lr    = 140.0;   // TODO: L-R foot centre-to-centre — estimated ~140 mm
foot_fb    = 100.0;   // TODO: F-B foot centre-to-centre — estimated ~100 mm
foot_cl    =   0.5;   // pocket clearance (radius — so pocket_d = foot_d + 1)

// ─── Platform plate ─────────────────────────────────────────────
base_h   = 5.0;    // plate thickness below pockets
wall     = 15.0;   // plate margin beyond foot pocket centres on all sides

// ─── 1 cm alignment grid on top surface ─────────────────────────
show_grid  = true;
grid_pitch = 10.0;  // 1 cm × 1 cm
grid_w     =  0.6;  // line width
grid_depth =  0.4;  // shallow — cosmetic only

// ─── Torpedo alignment fingers — DO NOT CHANGE PITCH ────────────
finger_w   = 16.0;  // -0.5 mm from nominal — pitch = finger_w + finger_gap = 23.0 mm
finger_h   =  5.0;  // finger height (matches torpedo groove depth)
finger_gap =  7.0;  // +0.5 mm — pitch held constant by reducing finger_w
fork_depth = 25.0;  // insertion depth into torpedo slot
n_fingers  =  8;    // 8 fingers → span = 177 mm — adjust after measuring foot_lr

// ─── Derived ────────────────────────────────────────────────────
pitch       = finger_w + finger_gap;    // = 23.0 mm — fixed
finger_span = n_fingers * finger_w + (n_fingers - 1) * finger_gap;

plate_l  = foot_lr + 2 * wall;         // total plate length
plate_w  = foot_fb + 2 * wall;         // total plate depth
plate_x0 = (finger_span - plate_l) / 2; // centre plate on finger span

total_h  = base_h + foot_h;            // plate thick enough to capture full foot

// Foot pocket centres in plate-local coords
fp_x_l = wall;                 // left foot column X
fp_x_r = wall + foot_lr;       // right foot column X
fp_y_f = wall;                 // front foot row Y
fp_y_b = wall + foot_fb;       // back foot row Y

eps = 0.01;
$fn = 48;

module foot_pocket() {
    cylinder(d = foot_d + 2 * foot_cl, h = foot_h + eps, $fn = 32);
}

module grid(lx, ly) {
    for (y = [grid_pitch : grid_pitch : ly - eps])
        translate([-eps, y - grid_w / 2, 0])
            cube([lx + 2 * eps, grid_w, grid_depth + eps]);
    for (x = [grid_pitch : grid_pitch : lx - eps])
        translate([x - grid_w / 2, -eps, 0])
            cube([grid_w, ly + 2 * eps, grid_depth + eps]);
}

difference() {
    union() {
        // ── Platform plate ────────────────────────────────────────
        translate([plate_x0, 0, 0])
            cube([plate_l, plate_w, total_h]);

        // ── Torpedo fingers ───────────────────────────────────────
        for (i = [0 : n_fingers - 1])
            translate([i * pitch, -fork_depth, 0])
                cube([finger_w, fork_depth, finger_h]);
    }

    // ── Rubber foot pockets (all four corners) ────────────────────
    for (fx = [fp_x_l, fp_x_r])
        for (fy = [fp_y_f, fp_y_b])
            translate([plate_x0 + fx, fy, total_h - foot_h])
                foot_pocket();

    // ── 1 cm alignment grid on top surface ───────────────────────
    if (show_grid)
        translate([plate_x0, 0, total_h - grid_depth])
            grid(plate_l, plate_w);

    // ── Engraved label — front margin ─────────────────────────────
    translate([plate_x0 + plate_l / 2, wall * 0.60, total_h - 0.8])
        linear_extrude(0.8 + eps)
            text("MANIFOLD", size = 5.0, font = "Arial:style=Bold",
                 halign = "center", valign = "center");
    translate([plate_x0 + plate_l / 2, wall * 0.18, total_h - 0.8])
        linear_extrude(0.8 + eps)
            text(str("lr=", foot_lr, "  fb=", foot_fb, "  fd=", foot_d),
                 size = 3.0, font = "Arial",
                 halign = "center", valign = "center");
}
