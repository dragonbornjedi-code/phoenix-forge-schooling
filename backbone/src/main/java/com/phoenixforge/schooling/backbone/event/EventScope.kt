package com.phoenixforge.schooling.backbone.event

/**
 * Event visibility scopes (frozen contract with Godot / World file spine).
 * Source of truth: phoenix-forge-classroom forge-sync-client EventScope.
 */
enum class EventScope {
    PUBLIC,
    LESSON,
    PROTECTED,
    ;

    fun childMayWrite(): Boolean = this == PUBLIC
    fun childMayRead(): Boolean = this == PUBLIC || this == LESSON
    fun stewardMayWrite(): Boolean = true
    fun stewardMayRead(): Boolean = true
}
