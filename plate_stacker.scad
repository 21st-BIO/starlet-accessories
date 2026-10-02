// Hamilton STARlet — Plate Stacker
// Same base as carrier module; stacks SBS plates vertically
//
// Structure:
//   BOTTOM RAILS  — identical to carrier module Part 1, screw to carrier
//   L-GUIDES      — continuous L-section uprights full height, guide plate corners
//   ENTRY TAPER   — top taper_h mm of each upright flared outward by taper_d
//                   widens entry opening to ease gripper plate placement
//   (no top plate — open at top for plate loading/unloading)
//
// Material:    PETG
// Orientation: flat base down, open top up
// Supports:    none needed
// Infill:      40%+, 4 perimeters

// ─── Shared dimensions — must match carrier_module.scad ─────
inner_l       = 118.25;
inner_w       =  83.70;
end_wall      =   9.95;
outer_w       =  92.50;
bottom_rail_h =  12.03;

tab_size      =  18.01;
tab_wall      =   4.50;
tab_clearance =   0.20;

screw_d       =   5.35;
screw_lc      = 128.00;
screw_wc      =  48.25;

// ─── Stacker height ──────────────────────────────────────────
module_h   = 51.56;   // carrier module total_h — reference only
extra_h    = 65.47;   // gives upright_h = 105 mm
stacker_h  = module_h + extra_h;   // = 117.03 mm total

// ─── Short-end rail pad — plate rests on this, clear of screw heads ─
rail_pad_l = 25.0;  // pad length (Y direction), centred between the two screw holes
rail_pad_h =  4.0;  // pad height above rail surface

// ─── Entry taper ─────────────────────────────────────────────
taper_d =   1.00;  // inner face inset at very top — tapers linearly across full upright height
                   // bottom: tab_wall = 4.5 mm (correct plate fit)
                   // top:    tab_wall - taper_d = 3.5 mm (1 mm wider opening each side)

// ─── Derived ─────────────────────────────────────────────────
outer_l      = inner_l + 2 * end_wall;        // = 138.15 mm
upright_h    = stacker_h - bottom_rail_h;     // = 125.00 mm
t_s          = tab_size - 2 * tab_clearance;  // = 17.61 mm
eps          = 0.01;                           // overlap epsilon — prevents non-manifold
connector_w  = 3.00;                           // long-side base connector width

$fn = 48;

// ─── L-guide upright — inner face tapers linearly full height ─
module L_upright(h) {
    union() {
        // X-wall: outer face vertical, inner face tapers 1 mm over full height
        hull() {
            translate([0, 0, 0       ]) cube([t_s, tab_wall,           0.01]);
            translate([0, 0, h - 0.01]) cube([t_s, tab_wall - taper_d, 0.01]);
        }

        // Y-wall: outer face vertical, inner face tapers 1 mm over full height
        hull() {
            translate([0, 0, 0       ]) cube([tab_wall,           t_s, 0.01]);
            translate([0, 0, h - 0.01]) cube([tab_wall - taper_d, t_s, 0.01]);
        }
    }
}

module plate_stacker() {
    difference() {
        union() {
            // ── Bottom rails (short ends) ──
            for (ex = [0, outer_l - end_wall])
                translate([ex, 0, 0])
                    cube([end_wall, outer_w, bottom_rail_h]);

            // ── Long-side base connectors — tie the two ends together ──
            for (by = [0, outer_w - connector_w])
                translate([end_wall - eps, by, 0])
                    cube([inner_l + 2*eps, connector_w, bottom_rail_h]);

            // ── Corner L-guide uprights — dip down into bottom rails ──
            translate([0,       0,       bottom_rail_h - eps])                                    L_upright(upright_h + eps);
            translate([outer_l, 0,       bottom_rail_h - eps]) mirror([1,0,0])                   L_upright(upright_h + eps);
            translate([0,       outer_w, bottom_rail_h - eps]) mirror([0,1,0])                   L_upright(upright_h + eps);
            translate([outer_l, outer_w, bottom_rail_h - eps]) mirror([1,0,0]) mirror([0,1,0])   L_upright(upright_h + eps);

            // ── Short-end rail pads — plate rests here, above screw heads ──
            for (ex = [0, outer_l - end_wall])
                translate([ex, outer_w/2 - rail_pad_l/2, bottom_rail_h])
                    cube([end_wall, rail_pad_l, rail_pad_h]);
        }

        // ── Bottom rail screw holes ──
        for (dx = [-screw_lc / 2, screw_lc / 2])
            for (dy = [-screw_wc / 2, screw_wc / 2])
                translate([outer_l/2 + dx, outer_w/2 + dy, -0.1])
                    cylinder(d = screw_d, h = bottom_rail_h + 1, $fn = 32);

        // ── Engraved label on outer face of left end rail (X=0, facing -X) ──
        translate([-eps, outer_w/2, bottom_rail_h * 0.65])
            rotate([0, 90, 0])
                linear_extrude(0.8 + eps)
                    text("PLATE STACKER", size = 3.5, font = "Arial:style=Bold",
                         halign = "center", valign = "center");
        translate([-eps, outer_w/2, bottom_rail_h * 0.25])
            rotate([0, 90, 0])
                linear_extrude(0.8 + eps)
                    text(str("il=",inner_l,"  iw=",inner_w,"  h=",stacker_h),
                         size = 2.5, font = "Arial",
                         halign = "center", valign = "center");
    }
}

plate_stacker();
