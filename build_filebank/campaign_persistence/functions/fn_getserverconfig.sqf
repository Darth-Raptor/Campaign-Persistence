private _config = missionNamespace getVariable ["CP_serverConfig", [false, false, false, false, false, false, 120, false, false]];
[_config] call CP_fnc_sanitizeModuleConfig
