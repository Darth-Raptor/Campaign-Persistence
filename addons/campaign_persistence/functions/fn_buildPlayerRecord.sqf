if (!isServer) exitWith {[]};

params [
    ["_unit", objNull, [objNull]],
    ["_payload", [], [[]]]
];

private _config = [] call CP_fnc_getServerConfig;
if !([_config] call CP_fnc_isPlayerPersistenceActive) exitWith {[]};
if (isNull _unit || {!isPlayer _unit}) exitWith {[]};

private _uid = getPlayerUID _unit;
if (_uid isEqualTo "") exitWith {[]};

private _persistPosition = _config param [CP_CFG_PERSIST_POSITION, false];
private _persistLoadout = _config param [CP_CFG_PERSIST_LOADOUT, false];
private _persistAmmo = _config param [CP_CFG_PERSIST_AMMO, false];
private _persistHealth = _config param [CP_CFG_PERSIST_HEALTH, false];

private _posASL = [];
private _dir = 0;
private _loadout = [];
private _damage = 0;
private _vehicleLink = ["", []];

if (_persistPosition) then {
    _posASL = _payload param [0, [], [[]]];
    _dir = _payload param [1, 0, [0]];

    if !(_posASL isEqualType [] && {(count _posASL) isEqualTo 3}) exitWith {
        ["WARN", "Rejected player save payload because position data was invalid.", [_uid, _payload]] call CP_fnc_log;
        []
    };

    {
        if !(_x isEqualType 0) exitWith {
            _posASL = [];
        };
    } forEach _posASL;

    if (_posASL isEqualTo [] || {!(_dir isEqualType 0)}) exitWith {
        ["WARN", "Rejected player save payload because direction data was invalid.", [_uid, _payload]] call CP_fnc_log;
        []
    };
};

if (_persistLoadout) then {
    _loadout = _payload param [2, [], [[]]];
    if !(_loadout isEqualType []) exitWith {
        ["WARN", "Rejected player save payload because loadout data was invalid.", _uid] call CP_fnc_log;
        []
    };
};

if (_persistHealth) then {
    _damage = _payload param [3, 0, [0]];
    if !(_damage isEqualType 0) exitWith {
        ["WARN", "Rejected player save payload because health data was invalid.", _uid] call CP_fnc_log;
        []
    };
    _damage = (_damage max 0) min 1;
};

_vehicleLink = [_unit] call CP_fnc_buildPlayerVehicleLink;

[
    CP_RECORD_SCHEMA_VERSION,
    _uid,
    [] call CP_fnc_buildMissionKey,
    _persistPosition,
    _posASL,
    _dir,
    _persistLoadout,
    _persistAmmo,
    _loadout,
    _persistHealth,
    _damage,
    serverTime,
    _vehicleLink param [0, "", [""]],
    _vehicleLink param [1, [], [[]]]
]
