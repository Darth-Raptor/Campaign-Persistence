if (!isServer) exitWith {
    [] call CP_fnc_getFortifyConfig
};

private _defaultConfig = [false, false, false, false, false, 120, false];
private _module = [] call CP_fnc_findFortifyModule;
if (isNull _module) then {
    CP_fortifyConfig = _defaultConfig;
    CP_fortifyConfigInitialized = true;
    publicVariable "CP_fortifyConfig";
    publicVariable "CP_fortifyConfigInitialized";
    ["INFO", "Fortify Persistence module not found; V4 fortify persistence is inactive."] call CP_fnc_log;
    CP_fortifyConfig
} else {
    private _rawConfig = [
        true,
        _module getVariable ["cp_fortifyEnabled", true],
        _module getVariable ["cp_fortifyPersistPosition", true],
        _module getVariable ["cp_fortifyPersistDamage", true],
        _module getVariable ["cp_fortifyPersistBudget", true],
        _module getVariable ["cp_fortifySaveIntervalSeconds", missionNamespace getVariable ["CP_defaultSaveInterval", 120]],
        _module getVariable ["cp_fortifyDebugLogging", false]
    ];

    CP_fortifyConfig = [_rawConfig] call CP_fnc_sanitizeFortifyConfig;
    CP_fortifyConfigInitialized = true;
    publicVariable "CP_fortifyConfig";
    publicVariable "CP_fortifyConfigInitialized";

    ["INFO", "Loaded Fortify Persistence module configuration.", CP_fortifyConfig] call CP_fnc_log;
    CP_fortifyConfig
}
