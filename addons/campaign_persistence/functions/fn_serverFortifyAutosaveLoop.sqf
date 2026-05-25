if (!isServer) exitWith {};

while {true} do {
    private _config = [] call CP_fnc_getFortifyConfig;
    private _interval = _config param [CP_FOR_CFG_SAVE_INTERVAL, missionNamespace getVariable ["CP_defaultSaveInterval", 120]];
    sleep _interval;

    _config = [] call CP_fnc_getFortifyConfig;
    if !([_config] call CP_fnc_isFortifyPersistenceActive) then {
        continue;
    };

    [] call CP_fnc_saveAllFortifyObjects;
}
