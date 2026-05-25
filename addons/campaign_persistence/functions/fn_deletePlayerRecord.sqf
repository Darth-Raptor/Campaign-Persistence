if (!isServer) exitWith {false};

params [
    ["_unit", objNull, [objNull]]
];

if (isNull _unit || {!isPlayer _unit}) exitWith {false};

private _uid = getPlayerUID _unit;
if (_uid isEqualTo "") exitWith {false};

private _missionKey = [] call CP_fnc_buildMissionKey;
private _result = ["delete_player", [_uid, _missionKey]] call CP_fnc_callBackend;
private _success = _result param [0, false];

if (_success) then {
    ["INFO", "Deleted player persistence record.", [_uid, _missionKey]] call CP_fnc_log;
} else {
    ["ERROR", "Failed to delete player persistence record.", _result] call CP_fnc_log;
};

_success
