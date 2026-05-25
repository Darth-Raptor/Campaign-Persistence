if (!isServer) exitWith {
    [] call CP_fnc_getVehicleConfig
};

private _defaultConfig = [false, false, false, false, false, false, false, false, false, false, 120, false];
private _module = [] call CP_fnc_findVehicleModule;
if (isNull _module) then {
    CP_vehicleConfig = _defaultConfig;
    CP_vehicleConfigInitialized = true;
    publicVariable "CP_vehicleConfig";
    publicVariable "CP_vehicleConfigInitialized";
    ["INFO", "Vehicle Persistence module not found; V3 vehicle persistence is inactive."] call CP_fnc_log;
    CP_vehicleConfig
} else {
    private _rawConfig = [
        true,
        _module getVariable ["cp_vehicleEnabled", true],
        _module getVariable ["cp_vehiclePersistPosition", true],
        _module getVariable ["cp_vehiclePersistDamage", true],
        _module getVariable ["cp_vehiclePersistAmmo", true],
        _module getVariable ["cp_vehiclePersistFuel", true],
        _module getVariable ["cp_vehiclePersistInventory", true],
        _module getVariable ["cp_vehiclePersistNestedInventory", true],
        _module getVariable ["cp_vehiclePersistServiceCargo", true],
        _module getVariable ["cp_vehicleIncludeRuntime", true],
        _module getVariable ["cp_vehicleSaveIntervalSeconds", missionNamespace getVariable ["CP_defaultSaveInterval", 120]],
        _module getVariable ["cp_vehicleDebugLogging", false]
    ];

    CP_vehicleConfig = [_rawConfig] call CP_fnc_sanitizeVehicleConfig;
    CP_vehicleConfigInitialized = true;
    publicVariable "CP_vehicleConfig";
    publicVariable "CP_vehicleConfigInitialized";

    ["INFO", "Loaded Vehicle Persistence module configuration.", CP_vehicleConfig] call CP_fnc_log;
    CP_vehicleConfig
}
