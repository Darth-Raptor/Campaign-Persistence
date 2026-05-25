private _config = missionNamespace getVariable ["CP_fortifyConfig", [false, false, false, false, false, 120, false]];
[_config] call CP_fnc_sanitizeFortifyConfig
