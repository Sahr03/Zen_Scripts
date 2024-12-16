define AIM_BTN = XB1_LT;        // L2 (Aim Down Sights)
define AIM_STICK = XB1_RS;      // Right Stick (Aiming Stick)
define DRIFT_RADIUS = 10;       // Strength of the aim assist movement (Adjust to your preference)
define DRIFT_DELAY = 20;        // Delay between movements in milliseconds

int aim_assist_active = FALSE;  // Tracks whether aim assist is active

main {
    // Activate aim assist when aiming down sights (L2/Left Trigger)
    if (get_val(AIM_BTN)) {
        if (!aim_assist_active) {
            combo_run(AIM_ASSIST); // Start aim assist combo
            aim_assist_active = TRUE;
        }
    } else {
        if (aim_assist_active) {
            combo_stop(AIM_ASSIST); // Stop aim assist combo
            aim_assist_active = FALSE;
        }
    }
}

// Combo for aim assist micro movement
combo AIM_ASSIST {
    set_val(AIM_STICK, DRIFT_RADIUS);  // Move right stick slightly up-right
    wait(DRIFT_DELAY);                 // Wait
    set_val(AIM_STICK, -DRIFT_RADIUS); // Move right stick slightly down-left
    wait(DRIFT_DELAY);                 // Wait
}
