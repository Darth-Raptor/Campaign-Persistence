params [
    ["_id", "", [""]]
];

if (_id isEqualTo "") exitWith {objNull};

private _match = allMissionObjects "All" select {
    (_x getVariable ["CP_runtimeLogisticsPersistenceId", ""]) isEqualTo _id ||
    {(_x getVariable ["CP_logisticsPersistenceId", ""]) isEqualTo _id} ||
    {([_x] call CP_fnc_getDefaultLogisticsId) isEqualTo _id}
};

if (_match isEqualTo []) exitWith {objNull};
_match select 0
