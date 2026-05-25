params [
    ["_unit", objNull, [objNull]]
];

if (isNull _unit || {!isPlayer _unit}) exitWith {[]};

private _config = [] call CP_fnc_getServerConfig;
private _persistPosition = _config param [CP_CFG_PERSIST_POSITION, false];
private _persistLoadout = _config param [CP_CFG_PERSIST_LOADOUT, false];
private _persistAmmo = _config param [CP_CFG_PERSIST_AMMO, false];
private _persistHealth = _config param [CP_CFG_PERSIST_HEALTH, false];

private _payload = [[], 0, [], 0];
if (_persistPosition) then {
    _payload set [0, getPosASL _unit];
    _payload set [1, getDir _unit];
};

if (_persistLoadout) then {
    _payload set [2, getUnitLoadout [_unit, !_persistAmmo]];
};

if (_persistHealth) then {
    _payload set [3, damage _unit];
};

_payload
