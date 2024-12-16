define AIM_BTN = XB1_LT;         // L2 (Aim Down Sights)
define AIM_STICK_X = XB1_RX;     // Right Stick Horizontal Axis
define AIM_STICK_Y = XB1_RY;     // Right Stick Vertical Axis
define DRIFT_RADIUS = 8;         // Strength of the aim assist movement (Adjust to your preference)
define DRIFT_DELAY = 16;         // Delay between movements in milliseconds

int aim_assist_active = FALSE;   // Tracks whether aim assist is active
int drift_direction = 1;         // Tracks direction for stick movement

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

// Combo for aim assist refined movement
combo AIM_ASSIST {
    // Horizontal movement (Right Stick X-Axis)
    set_val(AIM_STICK_X, DRIFT_RADIUS * drift_direction); // Move right stick left or right
    wait(DRIFT_DELAY);                                   // Wait
    
    // Vertical movement (Right Stick Y-Axis)
    set_val(AIM_STICK_Y, DRIFT_RADIUS * drift_direction); // Move right stick up or down
    wait(DRIFT_DELAY);                                   // Wait

    // Alternate drift direction to create subtle movement
    drift_direction = -drift_direction;
}
