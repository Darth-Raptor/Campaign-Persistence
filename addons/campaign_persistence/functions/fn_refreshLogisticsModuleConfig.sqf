if (!isServer) exitWith {
    [] call CP_fnc_getLogisticsConfig
};

private _defaultConfig = [false, false, false, false, false, false, false, false, 120, false];
private _module = [] call CP_fnc_findLogisticsModule;
if (isNull _module) then {
    CP_logisticsConfig = _defaultConfig;
    CP_logisticsConfigInitialized = true;
    publicVariable "CP_logisticsConfig";
    publicVariable "CP_logisticsConfigInitialized";
    ["INFO", "Logistics Persistence module not found; V2 logistics persistence is inactive."] call CP_fnc_log;
    CP_logisticsConfig
} else {
    private _rawConfig = [
        true,
        _module getVariable ["cp_logisticsEnabled", true],
        _module getVariable ["cp_logisticsPersistPosition", true],
        _module getVariable ["cp_logisticsPersistInventory", true],
        _module getVariable ["cp_logisticsPersistNestedInventory", true],
        _module getVariable ["cp_logisticsPersistDamage", true],
        _module getVariable ["cp_logisticsPersistSupplyState", true],
        _module getVariable ["cp_logisticsIncludeRuntime", true],
        _module getVariable ["cp_logisticsSaveIntervalSeconds", missionNamespace getVariable ["CP_defaultSaveInterval", 120]],
        _module getVariable ["cp_logisticsDebugLogging", false]
    ];

    CP_logisticsConfig = [_rawConfig] call CP_fnc_sanitizeLogisticsConfig;
    CP_logisticsConfigInitialized = true;
    publicVariable "CP_logisticsConfig";
    publicVariable "CP_logisticsConfigInitialized";

    ["INFO", "Loaded Logistics Persistence module configuration.", CP_logisticsConfig] call CP_fnc_log;
    CP_logisticsConfig
}
