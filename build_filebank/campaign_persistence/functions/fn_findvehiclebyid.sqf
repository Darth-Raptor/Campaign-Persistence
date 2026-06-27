params [
    ["_id", "", [""]]
];

if (_id isEqualTo "") exitWith {objNull};

private _matches = allMissionObjects "All" select {
    (_x getVariable ["CP_runtimeVehiclePersistenceId", ""]) isEqualTo _id ||
    {(_x getVariable ["CP_vehiclePersistenceId", ""]) isEqualTo _id} ||
    {([_x] call CP_fnc_getDefaultVehicleId) isEqualTo _id}
};

if (_matches isEqualTo []) exitWith {objNull};
_matches select 0
