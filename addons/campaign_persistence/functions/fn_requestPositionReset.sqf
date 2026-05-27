if (!hasInterface) exitWith {};
if (isNull player || {!alive player} || {!local player}) exitWith {};

private _spawnPosASL = missionNamespace getVariable ["CP_originalSpawnPosASL", []];
private _spawnDir = missionNamespace getVariable ["CP_originalSpawnDir", getDir player];

if !(_spawnPosASL isEqualType [] && {(count _spawnPosASL) isEqualTo 3}) exitWith {
    ["Campaign Persistence: Original Eden spawn position is not available."] call CP_fnc_notifyClient;
};

[] spawn {
    private _spawnPosASL = + (missionNamespace getVariable ["CP_originalSpawnPosASL", []]);
    private _spawnDir = missionNamespace getVariable ["CP_originalSpawnDir", getDir player];

    if !(vehicle player isEqualTo player) then {
        unassignVehicle player;
        moveOut player;
        sleep 0.25;
    };

    player setVelocity [0, 0, 0];
    player setDir _spawnDir;
    player setPosASL _spawnPosASL;
    player setVelocity [0, 0, 0];

    ["INFO", "Reset a player to their original Eden spawn position before a manual save.", getPlayerUID player] call CP_fnc_log;
    ["Campaign Persistence: Position reset. Requesting a manual save."] call CP_fnc_notifyClient;

    sleep 0.25;
    [] call CP_fnc_requestManualSave;
};
