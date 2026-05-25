params [
    ["_record", [], [[]]]
];

if (!hasInterface) exitWith {};
if (isNull player || {!alive player} || {!local player}) exitWith {};

private _validation = [_record, player] call CP_fnc_validateStoredRecord;
if !(_validation param [0, false]) exitWith {
    ["WARN", "Rejected a restore payload on the client.", _validation] call CP_fnc_log;
};

private _hasLoadout = _record param [CP_RECORD_HAS_LOADOUT, false];
private _hasAmmo = _record param [CP_RECORD_HAS_AMMO, false];
private _loadout = _record param [CP_RECORD_LOADOUT, [], [[]]];
if (_hasLoadout) then {
    player setUnitLoadout [_loadout, !_hasAmmo];
};

private _hasPosition = _record param [CP_RECORD_HAS_POSITION, false];
if (_hasPosition) then {
    player setDir (_record param [CP_RECORD_DIR, getDir player, [0]]);
    player setPosASL (_record param [CP_RECORD_POS_ASL, getPosASL player, [[]]]);
};

private _hasHealth = _record param [CP_RECORD_HAS_HEALTH, false];
if (_hasHealth) then {
    player setDamage (_record param [CP_RECORD_DAMAGE, damage player, [0]]);
};

[_record] call CP_fnc_restorePlayerVehicleLink;

["INFO", "Applied server-approved player restore.", getPlayerUID player] call CP_fnc_log;
