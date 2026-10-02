# Hamilton STARlet 3D-Printed Accessories

Parametric OpenSCAD models for accessories designed for the Hamilton STARlet liquid handling robot at [21st.bio](https://21st.bio).

All parts are printed in **PETG** on a Bambu printer: 4 perimeters, 40% infill, 0.2 mm layer height. No supports are required unless noted.

---

## Deck Torpedo Geometry

Several parts engage the STARlet deck via **torpedo fingers** — thin tabs that slide into the gaps between the T-shaped torpedo rails that run along the deck.

**Critical constraint:** `finger_w + finger_gap` must always equal **23.0 mm** (fixed torpedo pitch). Changing one parameter must be offset by an equal opposite change to the other.

Default values used throughout: `finger_w = 16.0 mm`, `finger_gap = 7.0 mm`.

---

## Parts

### Balance Base — OHAUS Navigator (`balance_base_front.scad` + `balance_base_back.scad`)

Two-piece adapter that seats an OHAUS Navigator analytical balance on the STARlet deck. The balance sits on the adapter; the CO-RE grippers can then transfer plates/tubes directly onto the balance pan for in-situ weighing.

- **Front plate** (`balance_base_front.scad`) — has torpedo fingers on the front face and interlocking join-fingers on the back face. Slide onto the deck torpedoes first.
- **Back plate** (`balance_base_back.scad`) — has join-slots that receive the front plate fingers. `back_trim = 1.0 mm` shortens the plate 1 mm to bring the rear balance feet 1 mm closer together (independently verified on hardware).
- The two plates lock together via a push-fit finger joint (`join_cl = 0.2 mm` clearance).

**Key parameters to verify against your balance:**

| Parameter | Value | Description |
|-----------|-------|-------------|
| `foot_lr` | 163.64 mm | Left–right foot spacing |
| `foot_fb` | 188.09 mm | Front–back foot spacing |
| `foot_d`  | 33.0 mm   | Foot diameter |
| `n_fingers` | 6      | Torpedo fingers |

**Print order:** finger test → front plate → back plate.

---

### Balance Base Test Pieces (`tests/`)

- **`balance_base_finger_test.scad`** — 6-finger stub. Print this first to verify the finger-torpedo fit before committing to the full plate. Parameters must match the front/back plate values.
- **`balance_base_fork_test.scad`** — 2-finger test piece with older parameter values (`finger_w = 16.5`, `finger_gap = 6.5`). Kept for reference.

---

### Plate Carrier Module (`carrier_module_spring.scad`)

Parametric replica of the Hamilton plate carrier module (REF 10072250/00). Holds one SBS microplate on the STARlet deck carrier.

**`carrier_module_spring.scad`** is the production version. It adds bilateral integrated spring tabs to the L-brackets at all four corners — the plate self-centres in X when lowered from above by the CO-RE grippers. Left-end brackets are solid (datum face); right-end brackets have a pre-angled spring tab that deflects outward and pushes the plate toward the left datum.

`carrier_module.scad` is the non-spring variant (solid L-brackets at all corners) — useful if you want a fixed-width pocket or are using a different centering method.

**Key parameters:**

| Parameter | Value | Description |
|-----------|-------|-------------|
| `inner_l` | 118.25 mm | Plate pocket length |
| `inner_w` | 83.70 mm  | Plate pocket width |
| `outer_w` | 92.50 mm  | Frame outer width (narrowed 1 mm/side vs OEM to clear adjacent carriers) |
| `bottom_rail_h` | 15.0 mm | Rail height — sized for current carrier screws; verify against your carrier |
| `access_d` | 5.50 mm  | Allen key clearance holes above each screw |
| `spring_t` | 0.80 mm  | Spring tab thickness — reduce for softer spring |

**Print orientation:** flat base down, L-brackets pointing up. Supports required under L-bracket overhangs only (use support paint in Bambu Slicer).

---

### Carrier Module Rail Test (`tests/carrier_module_rail_test.scad`)

Single end-rail test piece (left hand). Verifies rail height (`bottom_rail_h = 15.0 mm`) and Allen key access hole alignment against the carrier screws before printing the full module. Takes ~15 min to print vs ~4 hours for the full module.

---

### Plate Stacker (`plate_stacker.scad`)

Open-topped frame that stacks SBS microplates vertically above a carrier position. Uses the same bottom rail geometry as the carrier module so it bolts to the same carrier screw pattern.

Continuous L-section uprights guide the plate corners as the CO-RE grippers lower plates into the stack. Entry tapers at the top of each upright widen the opening by `taper_d = 3.0 mm` per side to ease placement. No top plate — fully open at the top.

Default stack height ≈ 105 mm above the rail top face (accommodates 5–6 standard SBS plates depending on plate height).

---

### Tip Waste Chute (`tip_waste_chute_slide.scad`)

Slide chute for 96-MPH tip ejection. Clips vertically into the two clasps on the STARlet instrument side panel; tips eject onto the slide and fall into a waste bin on the floor.

- Clip arm drops straight down (180°) into the clasps
- Slide surface angles 20° from vertical (70° below horizontal) — tips clear the panel and land in the bin
- Side walls retain tips on the slide

---

### Barcode Scanner Holder (`scanner_holder.scad`)

Wall-mount C-channel holder for a **Zebra LI2208** barcode scanner in a fixed/stationary orientation on the STARlet RHS. The CO-RE grippers present plates to the scanner; the scanner reads the plate barcode without operator intervention.

- **Base plate** — extends 22 mm either side of the C-channel; two M5 oblong mounting slots for deck/wall attachment
- **C-channel** — solid back + left + right walls, open at the front; scanner slides in from the top
- **M3 clamp holes** — one through each side wall at 75% of grip height; thumb screws lock the scanner in place

> **Verify `handle_w` and `handle_d` against the physical scanner before printing.** Current values are estimates from the published spec; measure the grip cross-section with calipers.

> **Configure presentation mode:** scan the "Presentation Mode" programming barcode from the LI2208 Product Reference Guide (p. 5-7) so the scanner reads continuously without the trigger being pressed.

---

### Q-Tray Adapter (`qtray_adapter.scad`)

Deck adapter for Q-trays, using the same torpedo-finger approach as the balance base. Sits on the Hamilton deck torpedo rails; the Q-tray drops onto the platform and is located by four corner L-posts.

> **Before printing:** measure the Q-tray with calipers and update `tray_l`, `tray_w`, and `n_fingers` in the file. The torpedo finger geometry (`finger_w`, `finger_gap`) must not be changed independently — see the constraint above.

---

### Vacuum Manifold Carrier Adapter (`vacuum_manifold_adapter.scad`)

Flat plate that mounts a vacuum manifold onto a Hamilton carrier frame. Uses the same 4-screw pattern as the plate carrier module bottom rail (`screw_lc × screw_wc`) — drop it into any standard carrier and bolt it down with the existing carrier screws.

Four recessed pockets on the top surface receive the manifold's rubber feet, locating the manifold precisely in X and Y. The plate auto-sizes: if the manifold is wider than the carrier, the plate grows to contain the foot pockets while the screw holes remain at their correct carrier positions.

> **Before printing:** measure the manifold's rubber feet with calipers and update `foot_d`, `foot_h`, `foot_lr`, and `foot_fb`. All four are currently estimates from ruler photos.

**Key parameters:**

| Parameter | Value | Description |
|-----------|-------|-------------|
| `screw_lc` | 128.00 mm | Lengthwise screw c-t-c — fixed, matches carrier |
| `screw_wc` |  48.25 mm | Widthwise screw c-t-c — fixed, matches carrier |
| `screw_d`  |   5.50 mm | Clearance hole diameter |
| `foot_d`   |  16.0 mm  | Confirmed |
| `foot_h`   |  5.75 mm  | Measured |
| `foot_lr`  | 72.06 mm  | Measured — along carrier length axis |
| `foot_fb`  | 66.01 mm  | Measured — along carrier width axis |
| `base_h`   |   8.0 mm  | Plate thickness — must be ≥ `foot_h` |

---

## Repository Structure

```
starlet-accessories/
├── README.md
├── balance_base_front.scad          # production
├── balance_base_back.scad           # production
├── carrier_module_spring.scad       # production (use this one)
├── carrier_module.scad              # non-spring variant
├── plate_stacker.scad               # production
├── tip_waste_chute_slide.scad       # production
├── scanner_holder.scad              # new — verify handle dimensions before printing
├── qtray_adapter.scad               # template — verify Q-tray dimensions before printing
├── vacuum_manifold_adapter.scad     # new — verify foot dimensions before printing
└── tests/
    ├── balance_base_finger_test.scad
    ├── balance_base_fork_test.scad
    └── carrier_module_rail_test.scad
```

---

## Software

Models authored in [OpenSCAD](https://openscad.org/) (free). Open any `.scad` file and press **F6** to render, **F7** to export STL.
