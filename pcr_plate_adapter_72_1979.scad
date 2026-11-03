// Hamilton STARlet — PCR Plate Adapter (Sarstedt 72.1979)
//
// SBS-footprint adapter that seats the Sarstedt 72.1979 half-skirt 96-well
// PCR plate in a repeatable, self-centred position on the HHS clamp seat and
// MFX plate carrier.
//
// 96 conical guide holes (wide at the top, narrowing downward) at a 9 mm
// pitch accept the PCR plate's V-bottom cones as the plate is lowered from
// above. The cones self-centre the plate — no manual push-right before
// clamping.
//
// The adapter sits in the HHS seat / carrier like a normal SBS microplate.
// The PCR plate is placed on top; the 96 well cones drop into the guide holes.
//
// *** EVERY HEIGHT ON THE SEAT CHANGES AFTER ADDING THIS ADAPTER. ***
// Re-probe A1 and H12 well bottoms with the plate clamped in the adapter
// before running any method. The new Z values replace the existing teach.
//
// PETG required — HHS heats to 70 °C.
// Print: flat face down. No supports needed.
//
// ─── Plate dimensions (Sarstedt 72.1979, measured Sep 2026 by M. Lees) ───
//   plate_l × plate_w = 126.1 × 86.0 mm (NOT true SBS — 0.52 mm wider in Y)
//   A1: 13.0 mm from plate left edge, 11.0 mm from plate rear edge
//   Inner well: ⌀ 5.6 mm opening, 18.5 mm deep, V-bottom ≈ 1.4 mm across tip
//   Overall plate height: 19.33 mm
//
// ─── Cone geometry — external well estimates (* = wall-thickness assumption) ──
//   Well external ⌀ at top  ≈ 6.6 mm * (inner 5.6 + 2 × 0.5 mm wall)
//   Well external ⌀ at plate bottom ≈ 2.5 mm * (very near cone tip)
//   If the plate rocks or jams: adjust cone_top_d (see parameter note below).

// ─── SBS / ANSI plate footprint ─────────────────────────────────
sbs_l    = 127.76;   // adapter outer length (SBS standard)
sbs_w    =  85.48;   // adapter outer width  (SBS standard)
corner_r =   3.0;    // SBS corner radius

// ─── Sarstedt 72.1979 dimensions (measured) ──────────────────────
plate_l  = 126.1;    // plate outer length
plate_w  =  86.0;    // plate outer width (0.52 mm wider than SBS — front overhangs)
a1_xl    =  13.0;    // A1 centre from plate LEFT  edge
a1_yr    =  11.0;    // A1 centre from plate REAR  edge
n_col    =  12;
n_row    =   8;
pitch    =   9.0;    // well pitch (standard SBS 96-well)

// ─── Conical guide hole geometry (* estimated — adjust if fit is poor) ────
// Wide opening at adapter top surface catches the well cone as plate descends.
// Blind recess — solid floor below the cone. No through-holes.
//
// Tuning guide:
//   If wells snag the flat surface between holes → increase cone_top_d (max ~6.5)
//   If plate rocks / doesn't self-centre       → reduce  cone_top_d toward 4.5
//   If tip bottoms out / plate won't seat      → increase cone_bot_d
cone_top_d =  5.5;   // hole diameter at adapter top surface *
cone_bot_d =  2.8;   // diameter at tip of recess (blind, not through) *
cone_h     =  3.0;   // conical recess depth

// ─── Version ─────────────────────────────────────────────────────
version  = "v1.1";   // increment when geometry changes

// ─── Adapter thickness ───────────────────────────────────────────
base_h   =  6.0;     // total height — floor under cones = base_h − cone_h = 3 mm

// ─── Derived ────────────────────────────────────────────────────
// Plate is positioned REAR (Y = sbs_w) and RIGHT (X = sbs_l):
plate_x0 = sbs_l - plate_l;   // = 1.66 mm: plate left edge in adapter space
// plate front overhangs by sbs_w − plate_w = −0.52 mm (fine, front is open)

// A1 in adapter space (origin = adapter front-left, X→right, Y→rear):
a1_x = plate_x0 + a1_xl;      // = 14.66 mm from adapter left edge
a1_y = sbs_w    - a1_yr;      // = 74.48 mm from adapter front edge

eps = 0.01;

module sbs_footprint(h) {
    hull()
        for (cx = [corner_r, sbs_l - corner_r])
            for (cy = [corner_r, sbs_w - corner_r])
                translate([cx, cy, 0])
                    cylinder(r = corner_r, h = h, $fn = 32);
}

// Guide hole: wide (cone_top_d) at top, tapers to cone_bot_d at depth cone_h.
// Blind — solid floor below. Call site: translate to [well_x, well_y, base_h].
module guide_hole() {
    translate([0, 0, -cone_h])
        cylinder(d1 = cone_bot_d, d2 = cone_top_d, h = cone_h + eps, $fn = 32);
}

difference() {
    sbs_footprint(base_h);

    // 96 conical guide holes — columns right (+X), rows A→H toward front (−Y)
    for (col = [0 : n_col - 1])
        for (row = [0 : n_row - 1])
            translate([a1_x + col * pitch,
                       a1_y - row * pitch,
                       base_h])
                guide_hole();

    // A1 corner marker on top surface (rear-left of the well grid)
    translate([a1_x - 3.5, a1_y + 3.5, base_h - 0.7])
        linear_extrude(0.7 + eps)
            text("A1▲", size = 3.5, font = "Arial:style=Bold",
                 halign = "center", valign = "center");

    // Plate ID on underside (readable when adapter is flipped over)
    translate([sbs_l / 2, sbs_w / 2, 0.7])
        rotate([180, 0, 0])
            linear_extrude(0.7 + eps)
                text(str("72.1979  ADAPTER  ", version), size = 4.0, font = "Arial:style=Bold",
                     halign = "center", valign = "center");

    translate([sbs_l / 2, sbs_w / 2 - 6.0, 0.7])
        rotate([180, 0, 0])
            linear_extrude(0.7 + eps)
                text(str("cone⌀", cone_top_d, "→", cone_bot_d,
                         "  h", cone_h, "  base", base_h),
                     size = 2.8, font = "Arial",
                     halign = "center", valign = "center");
}
