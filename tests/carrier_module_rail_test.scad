// Carrier module — single end rail test piece (left hand)
// Tests: 15mm rail height and 5.5mm Allen key access holes above each screw.
// Print: flat base down.
// Check: screw holes align with base carrier; Allen key drops through from top.

// ─── Shared dimensions — must match carrier_module.scad ──────
inner_l  = 118.25;
end_wall =   9.95;
outer_w  =  92.50;

screw_lc = 128.00;   // lengthwise screw c-t-c
screw_wc =  48.25;   // widthwise screw c-t-c

// ─── Rail height ──────────────────────────────────────────────
bottom_rail_h = 15.0;   // was 12.03 — increased for new carriers

// ─── Access holes ─────────────────────────────────────────────
access_d = 5.50;   // Allen key clearance — full height

// ─── Derived ──────────────────────────────────────────────────
outer_l  = inner_l + 2 * end_wall;   // = 138.15 mm

// Screw X in left rail = outer_l/2 - screw_lc/2 = 5.075 mm from left edge
hole_x   = outer_l / 2 - screw_lc / 2;   // = 5.075 mm

eps = 0.01;
$fn = 48;

difference() {
    // Single left end rail
    cube([end_wall, outer_w, bottom_rail_h]);

    // Two access holes (left column of screws only)
    for (dy = [-screw_wc / 2, screw_wc / 2])
        translate([hole_x, outer_w / 2 + dy, -0.1])
            cylinder(d = access_d, h = bottom_rail_h + 0.2, $fn = 32);

    // Label on outer face (X=0, facing left)
    translate([-eps, outer_w / 2, bottom_rail_h * 0.68])
        rotate([0, 90, 0])
            linear_extrude(0.8 + eps)
                text("RAIL TEST", size = 3.5, font = "Arial:style=Bold",
                     halign = "center", valign = "center");
    translate([-eps, outer_w / 2, bottom_rail_h * 0.25])
        rotate([0, 90, 0])
            linear_extrude(0.8 + eps)
                text(str("h=", bottom_rail_h, "  d=", access_d),
                     size = 2.5, font = "Arial",
                     halign = "center", valign = "center");
}
