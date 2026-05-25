if (!isServer) exitWith {};

while {true} do {
    private _config = [] call CP_fnc_getVehicleConfig;
    private _interval = _config param [CP_VEH_CFG_SAVE_INTERVAL, missionNamespace getVariable ["CP_defaultSaveInterval", 120]];
    sleep _interval;

    _config = [] call CP_fnc_getVehicleConfig;
    if !([_config] call CP_fnc_isVehiclePersistenceActive) then {
        continue;
    };

    [] call CP_fnc_saveAllVehicles;
}
