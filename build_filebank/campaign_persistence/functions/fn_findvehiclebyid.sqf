params [
    ["_id", "", [""]]
];

if (_id isEqualTo "") exitWith {objNull};

private _matches = allMissionObjects "All";
private _index = _matches findIf {
    (_x getVariable ["CP_vehiclePersistenceId", ""]) isEqualTo _id
};

if (_index < 0) exitWith {objNull};
_matches select _index
