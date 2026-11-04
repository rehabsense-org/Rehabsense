# RehabSense Prototype Builder (Figma plugin)

Generates every screen from UPDATE BRIEF v2 as editable Figma frames (360 x 800), with clickable prototype links.

## Install (development plugin)
1. Unzip this folder.
2. In the Figma desktop app: Plugins > Development > Import plugin from manifest...
3. Choose `manifest.json` from this folder.
4. Run: Plugins > Development > RehabSense Prototype Builder.

## Use
1. Press "Generate screens and prototype". It creates a page named "RehabSense v2 Prototype" with three sections: Patient, Doctor, Admin.
2. Use the screen list in the plugin panel (the "Go" button next to each screen) to jump to any frame.
3. To play the prototype, select P-01 (Patient), D-01 (Doctor) or A-01 (Admin) and press Present (top right).

## What you get
- 143 frames: 73 patient (55 existing/changed + 18 new), 42 doctor, 28 admin. Every frame has an ID, name and status label: NEW, CHANGED or EXISTING (as in the brief, sections 4 to 6).
- Design values only from PROJECT_HANDOFF section 6: colors, Inter type scale, spacing, radii and component sizes. Components mirror the Flutter widgets (RSButton, RSCard, RSInput, RSStatusChip, RSScoreRing, RSProgressBar, RSSegmentedControl, RSStatTile, RSMenuCard, RSDialog, RSEmptyState, RSSkeletonBlock, RSBanner, plus the new RSDoctorCard, RSDocumentTile, RSStepHeader, RSTimeline, RSSlider, RSOtpField, RSChoiceChip).
- All layouts use auto layout, so spacing and alignment stay consistent when you edit.
- About 570 prototype links: buttons, tabs, bottom navigation, list items, dialogs (Back closes them), segmented controls and multi-step wizards.
- "Prototype shortcuts" buttons on a few screens let you reach states that normally depend on the backend (pending doctor, rejected, pain 8+, hold tracking, and so on).

## Notes
- Text inside the frames is English.
- P-50 (Enter Doctor Code) and D-24 (Invite Code) are optional (decision D-07) and are intentionally not linked from the main flow.
- Re-running Generate replaces the generated page. Move any frames you want to keep to another page first.
- Editing the code: sources are in `src/`. Run `./build.sh` to rebuild `code.js` (plain JavaScript, no install needed).
- The icon set is drawn from Lucide outline paths (stroke 1.75, as in the app). No network access is used.
