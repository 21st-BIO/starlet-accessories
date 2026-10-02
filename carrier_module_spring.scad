// ═══════════════════════════════════════════════════════════════
//  Hamilton STARlet — Plate Carrier Module (Open Frame)
//  Replica of REF 10072250/00
//
//  Structure:
//    BOTTOM RAILS   — short ends only, screw into carrier (CRITICAL)
//    CORNER POSTS   — thin columns, long sides fully open
//    TOP RING       — full perimeter, plate rests on this
//    L-BRACKETS     — open L at each corner above top ring, engage carrier
//                     ALL FOUR corners: bilateral spring tabs, plate self-centres in X
//
//  Material:    PETG
//  Layer height: 0.2 mm
//  Infill:       40%+, gyroid or grid
//  Perimeters:   4 walls minimum
//  Supports:     Under L-bracket overhangs only (support paint in Bambu)
//  Orientation:  Flat base down, L-brackets pointing up
// ═══════════════════════════════════════════════════════════════

// ─── Dimensions ─────────────────────────────────────────────
//   outer_l is now derived (inner_l + 2*end_wall) — do not set directly
inner_l  = 118.25;  // plate pocket length (clear span) — measured
inner_w  =  83.70;  // plate pocket width  (clear span) — updated for 85.5 mm L-span
end_wall =   9.95;  // Part 1 wall thickness — was 7.95, +1 mm each side of screw holes
outer_w  =  92.50;  // was 94.50 — narrowed 1 mm per long side to clear adjacent carriers
total_h  =  51.56;  // frame height: base to top of top plate

bottom_rail_h = 15.0;   // bottom rail height — sits on carrier (was 12.03)
top_rail_h    =  8.0;   // ESTIMATE: top plate height — plate rests here

tab_size =  18.01;  // L-bracket outer extent (both legs)
tab_wall =   3.50;  // reduced from 4.50 — gives 2 mm Y clearance, spring handles X
tab_h    =  13.0;   // ESTIMATE: L-bracket height above top plate
                    //   Adjust in 1 mm steps until module seats in carrier

screw_d  =   5.35;  // verified on printed Part 1 (PETG shrink corrected)
access_d =   5.50;  // Allen key clearance — used for screw + top-plate access holes
screw_lc = 128.0;   // lengthwise centre-to-centre (Part 1 screws)
screw_wc =  48.25;  // verified on printed Part 1

tab_clearance = 0.2;  // subtracted from each face of L-bracket

// ─── CO-RE gripper notches — both long sides ────────────────
notch_l  = 40.0;  // total length, centred on long side
notch_d  =  9.0;  // depth from edge inward

// ─── Integrated spring (right-end L-brackets only) ──────────
//   A thin pre-angled tab carved into the Y-running leg inner face.
//   Left-end brackets remain solid (plate datum face).
//   Plate enters from above; tab deflects outward and pushes plate
//   toward left L-bracket inner faces (X datum).
spring_t      = 0.80;  // tab thickness — reduce for softer spring, increase for stiffer
spring_w      = 6.00;  // tab contact width (y-direction)
spring_pre    = 2.20;  // bilateral: gap (3.39 mm) shared equally left+right (1.695 + 0.5 mm preload)
spring_bridge = 3.00;  // solid root height — tab attaches to bracket here
spring_kerf   = 1.00;  // slot gap between tab and leg wall — must stay open after printing
groove_d      = 2.00;  // relief groove depth — thicker support piece, easier to remove
groove_margin = 1.00;  // clearance either side of tab footprint in X
groove_ext    = 6.00;  // extra outward extension past spring tip — widens accessible groove area

// ═══════════════════════════════════════════════════════════════
//  DERIVED VALUES
// ═══════════════════════════════════════════════════════════════
outer_l  = inner_l + 2 * end_wall;            // = 138.15 mm
sid_wall = (outer_w - inner_w) / 2;           // = 5.40 mm
post_h   = total_h - bottom_rail_h - top_rail_h;  // = 31.53 mm
t_s      = tab_size - 2 * tab_clearance;      // L-bracket outer with clearance

$fn = 48;

// ═══════════════════════════════════════════════════════════════
//  L-BRACKET — solid, used on LEFT-END corners (datum face)
// ═══════════════════════════════════════════════════════════════
module L_bracket() {
    union() {
        cube([t_s,      tab_wall, tab_h]);  // wall along X axis
        cube([tab_wall, t_s,      tab_h]);  // wall along Y axis
    }
}

// ═══════════════════════════════════════════════════════════════
//  L-BRACKET WITH SPRING — used on RIGHT-END corners only
//  Y-running leg has an integrated spring tab on its inner face.
//
//  Spring geometry (local coords, before mirror([1,0,0])):
//    Root z = tab_h - spring_bridge : tab flush with inner face
//    Tip  z = 0                     : tab protrudes spring_pre past inner face
//    spring_kerf slot frees the tab for z < spring_bridge
//
//  After mirror([1,0,0]) the protrusion faces the plate area,
//  pushing plate toward the solid left-bracket datum.
// ═══════════════════════════════════════════════════════════════
module L_bracket_spring() {
    sy0 = (t_s - spring_w) / 2;  // y-offset: centre tab on Y-running leg
    difference() {
        union() {
            cube([t_s,      tab_wall, tab_h]);
            cube([tab_wall, t_s,      tab_h]);
            // Pre-angled spring tab
            hull() {
                translate([tab_wall - spring_t, sy0, tab_h - spring_bridge - 0.01])
                    cube([spring_t, spring_w, 0.01]);
                translate([tab_wall + spring_pre - spring_t, sy0, 0])
                    cube([spring_t, spring_w, 0.01]);
            }
        }
        // Slot: frees the tab from the leg wall for z < spring_bridge
        translate([tab_wall - spring_t - spring_kerf, sy0, -0.01])
            cube([spring_kerf, spring_w, tab_h - spring_bridge + 0.01]);
    }
}

// ═══════════════════════════════════════════════════════════════
//  RELIEF GROOVE — same local coords as L_bracket_spring
//  Positioned with same translate/mirror as right-end brackets.
//  Cuts groove_d mm down into the top plate under the spring tab,
//  freeing the tab tip from the plate surface so it can flex.
// ═══════════════════════════════════════════════════════════════
module spring_groove() {
    sy0 = (t_s - spring_w) / 2;
    gx0 = tab_wall;  // start at wall inner face — no undercut, no support needed
    gx1 = tab_wall + spring_pre + groove_margin + groove_ext;
    // Open channel between walls: y from X-wall inner face to Y-wall end, x to groove_ext past spring tip
    translate([gx0, tab_wall, -groove_d])
        cube([gx1 - gx0, t_s - tab_wall, groove_d + 0.01]);
}

// ═══════════════════════════════════════════════════════════════
//  CARRIER MODULE
// ═══════════════════════════════════════════════════════════════
module carrier_module() {
    difference() {
        union() {
            // ── Bottom rails (short ends, z = 0 to bottom_rail_h) ──
            for (ex = [0, outer_l - end_wall])
                translate([ex, 0, 0])
                    cube([end_wall, outer_w, bottom_rail_h]);

            // ── Corner posts (bottom rail → top ring) ──
            for (px = [0, outer_l - end_wall])
                for (py = [0, outer_w - sid_wall])
                    translate([px, py, bottom_rail_h])
                        cube([end_wall, sid_wall, post_h]);

            // ── Top solid plate (MTP rests on this, just below L-brackets) ──
            translate([0, 0, total_h - top_rail_h])
                cube([outer_l, outer_w, top_rail_h]);

            // ── L-bracket tabs — all four corners spring (bilateral) ──
            translate([0,       0,       total_h])                                    L_bracket_spring();
            translate([outer_l, 0,       total_h]) mirror([1,0,0])                   L_bracket_spring();
            translate([0,       outer_w, total_h]) mirror([0,1,0])                   L_bracket_spring();
            translate([outer_l, outer_w, total_h]) mirror([1,0,0]) mirror([0,1,0])   L_bracket_spring();
        }

        // ── Relief grooves — all four corners ──
        translate([0,       0,       total_h])                                    spring_groove();
        translate([0,       outer_w, total_h]) mirror([0,1,0])                   spring_groove();
        translate([outer_l, 0,       total_h]) mirror([1,0,0])                   spring_groove();
        translate([outer_l, outer_w, total_h]) mirror([1,0,0]) mirror([0,1,0])   spring_groove();

        // ── Screw + Allen key access holes — punches bottom rail AND top plate ──
        for (dx = [-screw_lc / 2, screw_lc / 2])
            for (dy = [-screw_wc / 2, screw_wc / 2])
                translate([outer_l/2 + dx, outer_w/2 + dy, -0.1])
                    cylinder(d = access_d, h = total_h + 0.2, $fn = 32);

        // ── CO-RE gripper notches — front and back long sides ──
        translate([outer_l/2 - notch_l/2, -0.1,             total_h - top_rail_h - 0.1])
            cube([notch_l, notch_d + 0.1, top_rail_h + 0.2]);
        translate([outer_l/2 - notch_l/2, outer_w - notch_d, total_h - top_rail_h - 0.1])
            cube([notch_l, notch_d + 0.1, top_rail_h + 0.2]);

        // ── Engraved label on top plate ──
        translate([outer_l/2, outer_w/2 + 7, total_h - 0.8])
            linear_extrude(0.8 + 0.01)
                text("CARRIER (SPRING)", size = 5.5, font = "Arial:style=Bold",
                     halign = "center", valign = "center");
        translate([outer_l/2, outer_w/2 - 6, total_h - 0.8])
            linear_extrude(0.8 + 0.01)
                text(str("il=",inner_l,"  iw=",inner_w,"  rail=",bottom_rail_h,"  st=",spring_t,"  ad=",access_d),
                     size = 3.8, font = "Arial",
                     halign = "center", valign = "center");
    }
}

carrier_module();
