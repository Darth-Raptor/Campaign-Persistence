params [
    ["_object", objNull, [objNull]],
    ["_config", [], [[]]]
];

if (isNull _object) exitWith {false};
if !([_config] call CP_fnc_isFortifyPersistenceActive) exitWith {false};

private _id = _object getVariable ["CP_fortifyPersistenceId", ""];
(_id isEqualType "") && {(trim _id) isNotEqualTo ""}
