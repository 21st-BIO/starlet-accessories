// Hamilton STARlet — Vacuum Manifold Carrier Adapter
//
// Flat plate that bolts into a Hamilton carrier frame using the same
// 4-screw pattern as the plate carrier module bottom rail (screw_lc × screw_wc).
// Four recessed pockets on the top surface receive the manifold's rubber feet,
// locating the manifold precisely in X and Y.
//
// The plate is sized to always contain the foot pockets, so it may overhang
// the carrier's long sides if the manifold is wider than the carrier — this
// is fine, the 4 screws hold it firmly.
//
// SCREW DIMENSIONS match carrier_module_spring.scad exactly.
// FOOT DIMENSIONS are estimates from ruler photos — VERIFY WITH CALIPERS.
//
// Print: flat base down.
// Material: PETG, 4 perimeters, 40% infill.

// ─── Carrier frame screw pattern — matches carrier_module_spring.scad ───
outer_l  = 138.15;  // carrier outer length (inner_l=118.25 + 2×end_wall=9.95)
outer_w  =  92.50;  // carrier outer width
screw_lc = 128.00;  // lengthwise screw centre-to-centre
screw_wc =  48.25;  // widthwise screw centre-to-centre
screw_d  =   5.50;  // clearance hole — same as access_d in carrier module

// ─── Manifold rubber feet — caliper-measured 2026-10-02 ─────────
foot_d   =  16.0;   // TODO: rubber foot outer diameter — estimated from photos; measure
foot_h   =   5.75;  // measured: photo 3
foot_lr  =  72.06;  // measured: photo 2 — foot c-t-c along carrier length axis
foot_fb  =  66.01;  // measured: photo 4 — foot c-t-c along carrier width axis
foot_cl  =   0.5;   // pocket clearance per side (pocket_d = foot_d + 2×foot_cl)

// ─── Plate ──────────────────────────────────────────────────────
base_h = 8.0;   // plate thickness — must be ≥ foot_h; increase if feet are tall
wall   = 12.0;  // minimum plate margin beyond foot pocket centres

// ─── Derived ────────────────────────────────────────────────────
//  Plate is at least as large as the carrier, and grows if feet fall outside it.
plate_l = max(outer_l, foot_lr + 2 * wall);
plate_w = max(outer_w, foot_fb + 2 * wall);

eps = 0.01;
$fn = 48;

module foot_pocket() {
    cylinder(d = foot_d + 2 * foot_cl, h = foot_h + eps, $fn = 32);
}

difference() {
    // ── Plate body — centred on carrier long axis ──────────────────
    translate([-plate_l / 2, -plate_w / 2, 0])
        cube([plate_l, plate_w, base_h]);

    // ── Carrier screw clearance holes (4 off) ─────────────────────
    for (dx = [-screw_lc / 2, screw_lc / 2])
        for (dy = [-screw_wc / 2, screw_wc / 2])
            translate([dx, dy, -eps])
                cylinder(d = screw_d, h = base_h + 2 * eps, $fn = 32);

    // ── Rubber foot pockets (4 off, centred on plate) ─────────────
    for (dx = [-foot_lr / 2, foot_lr / 2])
        for (dy = [-foot_fb / 2, foot_fb / 2])
            translate([dx, dy, base_h - foot_h])
                foot_pocket();

    // ── Engraved label ────────────────────────────────────────────
    translate([0, plate_w / 2 - wall * 0.55, base_h - 0.8])
        linear_extrude(0.8 + eps)
            text("VAC MANIFOLD", size = 5.0, font = "Arial:style=Bold",
                 halign = "center", valign = "center");
    translate([0, -plate_w / 2 + wall * 0.30, base_h - 0.8])
        linear_extrude(0.8 + eps)
            text(str("lr=", foot_lr, "  fb=", foot_fb, "  fd=", foot_d),
                 size = 3.0, font = "Arial",
                 halign = "center", valign = "center");
}
