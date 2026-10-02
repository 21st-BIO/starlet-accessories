// Hamilton STARlet — Q-Tray Deck Adapter
//
// Sits on the Hamilton deck via torpedo-slot fingers (same geometry as the
// balance base adapter). The Q-tray drops into the recessed pocket on top.
//
// *** MEASURE THE Q-TRAY WITH CALIPERS AND FILL IN THE TODO VALUES BELOW ***
//
// Torpedo pitch constraint: finger_w + finger_gap MUST equal 23.0 mm.
// Changing one must be offset by an equal opposite change to the other.
//
// Print: flat base down, fingers pointing toward torpedoes.
// Material: PETG, 4 perimeters, 40% infill.

// ─── Q-Tray pocket — MEASURE AND VERIFY ────────────────────────
tray_l   = 100.0;  // TODO: Q-tray outer length (X) — measure with calipers
tray_w   =  60.0;  // TODO: Q-tray outer width  (Y) — measure with calipers
pocket_h =   5.0;  // TODO: pocket depth — set to tray lip/flange height
cl       =   0.8;  // clearance each side in the pocket

// ─── Adapter plate ─────────────────────────────────────────────
base_h   =  5.0;   // plate thickness below tray pocket
rim_wall =  8.0;   // solid wall around the tray pocket (X and Y)

// ─── Torpedo alignment fingers — DO NOT CHANGE PITCH ───────────
finger_w   = 16.0;  // -0.5mm from nominal — pitch = finger_w + finger_gap = 23.0mm
finger_h   =  5.0;  // finger height (matches torpedo groove depth)
finger_gap =  7.0;  // +0.5mm — pitch held constant by reducing finger_w
fork_depth = 25.0;  // insertion depth into torpedo slot
n_fingers  =  4;    // TODO: count how many torpedo slots the tray spans

// ─── Derived ───────────────────────────────────────────────────
finger_pitch   = finger_w + finger_gap;   // = 23.0 mm — fixed torpedo pitch
total_finger_w = n_fingers * finger_w + (n_fingers - 1) * finger_gap;

pocket_l = tray_l + 2 * cl;
pocket_w = tray_w + 2 * cl;
outer_l  = pocket_l + 2 * rim_wall;
outer_w  = pocket_w + 2 * rim_wall;
total_h  = base_h + pocket_h;

// Centre the plate body on the finger span
body_x   = (total_finger_w - outer_l) / 2;

eps = 0.01;
$fn = 48;

difference() {
    union() {
        // ── Adapter plate body ──────────────────────────────────
        translate([body_x, 0, 0])
            cube([outer_l, outer_w, total_h]);

        // ── Torpedo fingers ─────────────────────────────────────
        for (i = [0 : n_fingers - 1])
            translate([i * finger_pitch, -fork_depth, 0])
                cube([finger_w, fork_depth, finger_h]);
    }

    // ── Tray pocket ─────────────────────────────────────────────
    translate([body_x + rim_wall, rim_wall, base_h])
        cube([pocket_l, pocket_w, pocket_h + eps]);

    // ── Engraved label on top face ──────────────────────────────
    translate([total_finger_w / 2, outer_w - rim_wall * 0.5, total_h - 0.8])
        linear_extrude(0.8 + eps)
            text("Q-TRAY", size = 5.5, font = "Arial:style=Bold",
                 halign = "center", valign = "center");
    translate([total_finger_w / 2, rim_wall * 0.5, total_h - 0.8])
        linear_extrude(0.8 + eps)
            text(str("l=", tray_l, "  w=", tray_w, "  n=", n_fingers),
                 size = 3.5, font = "Arial",
                 halign = "center", valign = "center");
}
