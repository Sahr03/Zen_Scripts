// Define button and axis mappings
define SPRINT_BTN = XB1_LS;       // Left Stick Button for Sprint
define CROUCH_BTN = XB1_B;        // B Button for Crouch
define AIM_BTN = XB1_LT;          // Left Trigger for Aiming Down Sights
define SHOOT_BTN = XB1_RT;        // Right Trigger for Shooting
define JUMP_BTN = XB1_A;          // A Button for Jump
define RELOAD_BTN = XB1_X;        // X Button for Reload
define MOVE_STICK_X = XB1_LX;     // Left Stick X-Axis (Horizontal Movement)
define MOVE_STICK_Y = XB1_LY;     // Left Stick Y-Axis (Vertical Movement)
define AIM_STICK_X = XB1_RX;      // Right Stick X-Axis (Horizontal Aiming)
define AIM_STICK_Y = XB1_RY;      // Right Stick Y-Axis (Vertical Aiming)

// Feature toggles (enable/disable specific functions)
int auto_sprint_enabled = TRUE;   // Auto-sprint when moving forward
int one_hand_mode_enabled = TRUE; // Enable one-handed controls
int turbo_mode_enabled = TRUE;    // Enable turbo functionality
int toggle_crouch_enabled = TRUE; // Enable toggle crouch mode
int auto_aim_enabled = TRUE;      // Enable auto-aim assist

// State variables
int crouch_toggled = FALSE;       // Tracks crouch toggle state
int turbo_active = FALSE;         // Tracks turbo button state
int aim_assist_active = FALSE;    // Tracks aim assist activation
int drift_direction = 1;          // Tracks aim assist drift direction

main {
    // ** Auto-Sprint **
    if (auto_sprint_enabled && get_val(MOVE_STICK_Y) > 70) { // If moving forward
        set_val(SPRINT_BTN, 100); // Activate sprint
    }

    // ** One-Handed Controls: Map left stick to right stick **
    if (one_hand_mode_enabled) {
        set_val(AIM_STICK_X, get_val(MOVE_STICK_X)); // Map horizontal movement
        set_val(AIM_STICK_Y, get_val(MOVE_STICK_Y)); // Map vertical movement
    }

    // ** Toggle Crouch **
    if (toggle_crouch_enabled) {
        if (event_press(CROUCH_BTN)) { // On crouch button press
            crouch_toggled = !crouch_toggled; // Toggle crouch state
        }
        set_val(CROUCH_BTN, crouch_toggled ? 100 : 0); // Apply toggle state
    }

    // ** Turbo Buttons **
    if (turbo_mode_enabled) {
        // Example: Turbo fire for shooting
        if (get_val(SHOOT_BTN) > 0) { // If shoot button is held
            combo_run(TURBO_FIRE);   // Activate turbo fire combo
        }
    }

    // ** Aim Assist Enhancement **
    if (auto_aim_enabled && get_val(AIM_BTN)) { // If aiming down sights
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

// ** Turbo Fire Combo **
combo TURBO_FIRE {
    set_val(SHOOT_BTN, 100); // Press shoot button
    wait(50);                // Wait 50ms
    set_val(SHOOT_BTN, 0);   // Release shoot button
    wait(50);                // Wait 50ms before repeating
}

// ** Aim Assist Combo **
combo AIM_ASSIST {
    // Subtle aim assist drift (micro-movements)
    set_val(AIM_STICK_X, 5 * drift_direction); // Move right stick left or right
    wait(16);                                 // Wait
    set_val(AIM_STICK_Y, 5 * drift_direction); // Move right stick up or down
    wait(16);                                 // Wait
    drift_direction = -drift_direction;       // Alternate drift direction
}
