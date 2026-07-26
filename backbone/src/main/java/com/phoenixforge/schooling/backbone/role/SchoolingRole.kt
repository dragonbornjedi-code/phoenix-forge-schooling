package com.phoenixforge.schooling.backbone.role

/**
 * Dual-interface roles for a single APK.
 * Maps classroom "teacher/student" product language to schooling "steward/child".
 */
enum class SchoolingRole {
    /** Parent/mentor face — PUBLIC + LESSON + PROTECTED scopes. */
    STEWARD,

    /** Child face — PUBLIC + LESSON read; PUBLIC write only. */
    CHILD,
}
