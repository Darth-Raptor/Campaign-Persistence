if (!isServer) exitWith {};

private _config = [] call CP_fnc_getVehicleConfig;
if !([_config] call CP_fnc_isVehiclePersistenceActive) exitWith {};

{
    private _category = [_x] call CP_fnc_getVehicleCategory;
    if (_category isNotEqualTo "") then {
        [_x] call CP_fnc_registerVehicle;
    };
} forEach (allMissionObjects "All");
