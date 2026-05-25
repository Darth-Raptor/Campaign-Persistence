if (!isServer) exitWith {};

while {true} do {
    private _config = [] call CP_fnc_getServerConfig;
    private _interval = _config param [CP_CFG_SAVE_INTERVAL, missionNamespace getVariable ["CP_defaultSaveInterval", 120]];
    sleep _interval;

    _config = [] call CP_fnc_getServerConfig;
    if !([_config] call CP_fnc_isPlayerPersistenceActive) then {
        continue;
    };

    {
        if (!isNull _x && {isPlayer _x} && {alive _x}) then {
            [_x, "autosave"] call CP_fnc_beginSaveForPlayer;
        };
    } forEach allPlayers;
}
