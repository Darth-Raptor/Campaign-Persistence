params [
    ["_requestId", "", [""]]
];

if (!hasInterface) exitWith {};
if (_requestId isEqualTo "") exitWith {};
if (isNull player || {!alive player}) exitWith {};
if (!local player) exitWith {};

private _config = [] call CP_fnc_getServerConfig;
if !([_config] call CP_fnc_isPlayerPersistenceActive) exitWith {};

private _persistPosition = _config param [CP_CFG_PERSIST_POSITION, false];
private _persistLoadout = _config param [CP_CFG_PERSIST_LOADOUT, false];
private _persistAmmo = _config param [CP_CFG_PERSIST_AMMO, false];
private _persistHealth = _config param [CP_CFG_PERSIST_HEALTH, false];

private _payload = [[], 0, [], 0];
if (_persistPosition) then {
    _payload set [0, getPosASL player];
    _payload set [1, getDir player];
};

if (_persistLoadout) then {
    _payload set [2, getUnitLoadout [player, !_persistAmmo]];
};

if (_persistHealth) then {
    _payload set [3, damage player];
};

[_requestId, player, getPlayerUID player, _payload] remoteExecCall ["CP_fnc_serverReceiveCollectedState", 2];
