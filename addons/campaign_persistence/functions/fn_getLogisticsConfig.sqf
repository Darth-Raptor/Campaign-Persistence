private _config = missionNamespace getVariable ["CP_logisticsConfig", [false, false, false, false, false, false, false, false, 120, false]];
[_config] call CP_fnc_sanitizeLogisticsConfig
