int crouch_done = FALSE;        // Tracks if crouch has already been triggered
int script_enabled = TRUE;      // Tracks whether the script is enabled

define TOGGLE_BTN1 = XB1_LT;    // L2 (Left Trigger)
define TOGGLE_BTN2 = XB1_LEFT;  // Left D-Pad
define SHOOT_BTN = XB1_RT;      // R2 (Right Trigger)
define CROUCH_BTN = XB1_B;      // Circle (Crouch Button)

main {
    // Toggle script on/off with L2 + Left D-Pad
    if (get_val(TOGGLE_BTN1) && get_val(TOGGLE_BTN2)) {
        script_enabled = !script_enabled; // Toggle the script state
        combo_run(TOGGLE_FEEDBACK);      // Provide rumble feedback
        wait(300);                       // Prevent rapid toggling
    }

    if (script_enabled) {
        if (get_ival(SHOOT_BTN)) { // Check if RT/R2 (Right Trigger) is held
            if (!crouch_done) {    // Only run crouch action if it hasn't already been triggered
                combo_run(cCrouchShot); // Run crouch combo
                crouch_done = TRUE;     // Mark as triggered
            }
        } else {
            if (crouch_done) {     // If crouch was triggered, stand back up on release
                combo_run(cStandUp);    // Run stand-up combo
                crouch_done = FALSE;    // Reset the trigger
            }
        }
    }
}

// Combo for crouching with 30ms delay
combo cCrouchShot {
    wait(30);                 // Delay before crouching
    set_val(CROUCH_BTN, 100); // Press B/Circle (Crouch button)
    wait(40);                 // Hold B/Circle for 40ms
    set_val(CROUCH_BTN, 0);   // Release B/Circle
    wait(50);                 // Ensure button press registers
}

// Combo for standing back up
combo cStandUp {
    set_val(CROUCH_BTN, 100); // Press B/Circle (Stand-up button)
    wait(40);                 // Hold B/Circle for 40ms
    set_val(CROUCH_BTN, 0);   // Release B/Circle
    wait(50);                 // Ensure button press registers
}

// Combo for toggle feedback (e.g., vibration)
combo TOGGLE_FEEDBACK {
    set_rumble(RUMBLE_A, 100); // Activate rumble
    wait(300);                 // Wait for 300ms
    set_rumble(RUMBLE_A, 0);   // Stop rumble
}
