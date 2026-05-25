private _config = missionNamespace getVariable ["CP_vehicleConfig", [false, false, false, false, false, false, false, false, false, false, 120, false]];
[_config] call CP_fnc_sanitizeVehicleConfig
