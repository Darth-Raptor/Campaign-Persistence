if (!isServer) exitWith {};

while {true} do {
    private _config = [] call CP_fnc_getLogisticsConfig;
    private _interval = _config param [CP_LOG_CFG_SAVE_INTERVAL, missionNamespace getVariable ["CP_defaultSaveInterval", 120]];
    sleep _interval;

    _config = [] call CP_fnc_getLogisticsConfig;
    if !([_config] call CP_fnc_isLogisticsPersistenceActive) then {
        continue;
    };

    [] call CP_fnc_saveAllLogistics;
}
