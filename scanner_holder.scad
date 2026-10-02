// Zebra LI2208 Barcode Scanner Holder — Hamilton STARlet RHS mount
//
// Orientation: handle slides in from the top, scan head points horizontally
//              into the deck work area.
//
// Structure:
//   BASE PLATE  — full footprint, two M5 slots for deck attachment
//   C-CHANNEL   — three solid walls (back, left, right), open at front (+Y)
//   CLAMP HOLES — M3 through-holes in side walls; thumb screws lock scanner in place
//
// Print: back face down. No supports needed.
// Material: PETG, 4 perimeters, 40% infill.
//
// VERIFY handle_w and handle_d against the physical scanner before printing.

// ─── Scanner handle cross-section — MEASURE AND VERIFY ───────────
handle_w  = 43.0;   // handle width  (X) — verify against physical unit
handle_d  = 38.0;   // handle depth  (Y) — verify against physical unit
grip_l    = 80.0;   // grip channel length (Z)
cl        =  0.6;   // clearance each side

// ─── Wall thicknesses ─────────────────────────────────────────────
back_wall  =  6.0;   // back plate (Y — away from operator)
side_wall  =  5.0;   // left and right walls (X)

// ─── Base plate ───────────────────────────────────────────────────
base_t    =  7.0;   // base plate thickness (Z, below channel)
base_ext  = 22.0;   // base extends this far beyond channel on each side (X)

// ─── M5 mounting slots in base (for deck attachment) ──────────────
slot_d    =  5.5;   // slot width (M5 clearance)
slot_l    = 14.0;   // slot travel in Y (front-back adjustment)
slot_inset = 11.0;  // slot centre from outer edge of base (X)

// ─── M3 clamp screws through side walls ───────────────────────────
clamp_d   =  3.3;   // M3 clearance hole
clamp_z   = grip_l * 0.75;  // height of clamp hole above base top face

// ─── Derived ──────────────────────────────────────────────────────
inner_w  = handle_w + 2 * cl;
inner_d  = handle_d + 2 * cl;
outer_w  = inner_w + 2 * side_wall;
outer_d  = inner_d + back_wall;
base_w   = outer_w + 2 * base_ext;
cx       = outer_w / 2;

eps = 0.01;
$fn = 48;

module slot_hole() {
    hull()
        for (dy = [-slot_l/2, slot_l/2])
            translate([0, dy, 0])
                cylinder(d = slot_d, h = base_t + 2*eps, $fn = 32);
}

difference() {
    union() {
        // ── Base plate — full footprint ───────────────────────────
        translate([-base_ext, 0, -base_t])
            cube([base_w, outer_d, base_t]);

        // ── C-channel body ────────────────────────────────────────
        cube([outer_w, outer_d, grip_l]);
    }

    // ── Handle channel (open at +Y front, full grip length) ───────
    translate([side_wall, back_wall, -eps])
        cube([inner_w, inner_d + eps, grip_l + 2*eps]);

    // ── Mounting slots through base (elongated in Y) ──────────────
    for (sx = [-(base_ext - slot_inset), outer_w + base_ext - slot_inset])
        translate([sx, outer_d / 2, -base_t - eps])
            slot_hole();

    // ── M3 clamp holes through side walls ─────────────────────────
    for (cx = [side_wall / 2, outer_w - side_wall / 2])
        translate([cx, back_wall + inner_d / 2, clamp_z])
            rotate([0, 90, 0])
                cylinder(d = clamp_d, h = side_wall + 2*eps, center = true, $fn = 32);

    // ── Engraved label on back face ───────────────────────────────
    translate([cx, -eps, grip_l * 0.80])
        rotate([90, 0, 0])
            linear_extrude(0.8 + eps)
                text("LI2208", size = 5.5, font = "Arial:style=Bold",
                     halign = "center", valign = "center");
    translate([cx, -eps, grip_l * 0.60])
        rotate([90, 0, 0])
            linear_extrude(0.8 + eps)
                text(str("hw=",handle_w,"  hd=",handle_d,"  l=",grip_l),
                     size = 3.2, font = "Arial",
                     halign = "center", valign = "center");
}
