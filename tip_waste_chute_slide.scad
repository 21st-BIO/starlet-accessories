// Hamilton STARlet — 96 MPH Tip Waste Slide Chute
//
// Compass bearings from the junction (0° = up, 180° = straight down):
//   Clip arm:  180° — vertical tab drops straight down into upward-facing
//              clasps on the instrument side panel.
//   Slide:     160° — 20° from vertical, tilting slightly outward (+Y)
//              away from the instrument so tips clear the panel.
//
// Side view (YZ plane, instrument panel on left):
//
//   panel │
//   clasp →  ║  ← arm (vertical, straight down)
//            ║
//            ◆ junction
//           /
//          /  slide at 160° (nearly vertical, leaning slightly outward)
//         /
//        ○  bin on floor

// ─── Clip arm ─────────────────────────────────────────────────
rail_span  = 110.0;   // X — spans both clasps (85 mm c-t-c)
rail_depth =  45.0;   // Z — vertical insertion depth into clasp slot
rail_t     =   5.5;   // Y — clasp slot is 6 mm

// ─── Slide ────────────────────────────────────────────────────
// 160° compass = 20° from straight down = 70° below horizontal
slide_l     = 200.0;   // length along slope
slide_angle =  70.0;   // degrees below horizontal (= 90 - 20)
plate_t     =   4.0;
side_h      =  20.0;   // side wall height — retains tips on slide
side_t      =   3.5;

$fn = 48;

// Vertical tab: drops straight down (-Z) into clasps
module clip_arm() {
    translate([0, 0, -rail_depth])
        cube([rail_span, rail_t, rail_depth]);
}

// Slide: nearly vertical, leaning outward (+Y) at 20° from -Z
// rotate([-slide_angle, 0, 0]): X-axis rotation, +Y tilts toward -Z
module slide_plate() {
    rotate([-slide_angle, 0, 0])
        translate([0, 0, -plate_t]) {
            cube([rail_span, slide_l, plate_t]);
            for (sx = [0, rail_span - side_t])
                translate([sx, 0, plate_t])
                    cube([side_t, slide_l, side_h]);
        }
}

difference() {
    union() {
        clip_arm();
        slide_plate();
    }
    // ── Engraved label on back face of clip arm (Y = rail_t, operator-facing) ──
    translate([rail_span/2, rail_t + eps, -rail_depth * 0.35])
        rotate([90, 0, 0])
            linear_extrude(0.8 + eps)
                text("TIP WASTE CHUTE", size = 5.0, font = "Arial:style=Bold",
                     halign = "center", valign = "center");
    translate([rail_span/2, rail_t + eps, -rail_depth * 0.70])
        rotate([90, 0, 0])
            linear_extrude(0.8 + eps)
                text(str("span=",rail_span,"  depth=",rail_depth,"  slide=",slide_l,"@",slide_angle,"deg"),
                     size = 3.5, font = "Arial",
                     halign = "center", valign = "center");
}
