/*  onPlayerRespawn.sqf
    ------------------------------------------------------------
    Re-apply Babel after respawn (new unit object).
*/

params ["_newUnit", "_oldUnit", "_respawn", "_respawnDelay"];

// Re-apply Babel settings for the respawned player
[] execVM "babel\fn_applySlotBabel.sqf";
