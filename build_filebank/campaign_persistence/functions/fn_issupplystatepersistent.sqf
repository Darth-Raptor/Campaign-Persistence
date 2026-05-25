params [
    ["_object", objNull, [objNull]]
];

if (isNull _object) exitWith {false};
([_object] call CP_fnc_getLogisticsCategory) isEqualTo "supply"
