params [
    ["_object", objNull, [objNull]],
    ["_side", sideUnknown, [sideUnknown]],
    ["_cost", -1, [0]],
    ["_forcedId", "", [""]]
];

if (isNull _object) exitWith {""};

private _assignedId = _forcedId;
if (_assignedId isEqualTo "") then {
    _assignedId = _object getVariable ["CP_fortifyPersistenceId", ""];
};

if !(_assignedId isEqualType "") then {
    _assignedId = "";
} else {
    _assignedId = trim _assignedId;
};

if (_assignedId isEqualTo "") then {
    _assignedId = [_object] call CP_fnc_getDefaultFortifyId;
};

if (_assignedId isEqualTo "") exitWith {""};

private _sideKey = [_side] call CP_fnc_getFortifySideKey;
if (_sideKey isEqualTo "unknown") then {
    _sideKey = _object getVariable ["CP_fortifySideKey", "unknown"];
};

_object setVariable ["CP_fortifyPersistenceId", _assignedId, true];
_object setVariable ["CP_fortifyBuilt", true, true];
_object setVariable ["CP_fortifySideKey", _sideKey, true];
_object setVariable ["CP_fortifyCost", _cost, true];

if (_sideKey isNotEqualTo "unknown") then {
    private _trackedSides = missionNamespace getVariable ["CP_fortifyTrackedSides", []];
    _trackedSides pushBackUnique _sideKey;
    missionNamespace setVariable ["CP_fortifyTrackedSides", _trackedSides, true];
};

_assignedId
