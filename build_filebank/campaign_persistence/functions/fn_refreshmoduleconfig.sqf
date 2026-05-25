if (!isServer) exitWith {
    [] call CP_fnc_getServerConfig
};

private _defaultConfig = [false, false, false, false, false, false, 120, false, false];
private _module = [] call CP_fnc_findPlayerModule;
if (isNull _module) then {
    CP_serverConfig = _defaultConfig;
    CP_serverConfigInitialized = true;
    publicVariable "CP_serverConfig";
    publicVariable "CP_serverConfigInitialized";
    ["INFO", "Player Persistence module not found; V1 player persistence is inactive."] call CP_fnc_log;
    CP_serverConfig
} else {
    private _rawConfig = [
        true,
        _module getVariable ["cp_enabled", true],
        _module getVariable ["cp_persistPosition", true],
        _module getVariable ["cp_persistLoadout", true],
        _module getVariable ["cp_persistAmmo", true],
        _module getVariable ["cp_persistHealth", true],
        _module getVariable ["cp_saveIntervalSeconds", missionNamespace getVariable ["CP_defaultSaveInterval", 120]],
        _module getVariable ["cp_enableAceManualSave", true],
        _module getVariable ["cp_debugLogging", false]
    ];

    CP_serverConfig = [_rawConfig] call CP_fnc_sanitizeModuleConfig;
    CP_serverConfigInitialized = true;
    publicVariable "CP_serverConfig";
    publicVariable "CP_serverConfigInitialized";

    ["INFO", "Loaded Player Persistence module configuration.", CP_serverConfig] call CP_fnc_log;
    CP_serverConfig
}
