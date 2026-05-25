if (!isServer) exitWith {[]};

params [
    ["_object", objNull, [objNull]],
    ["_deleted", false, [true]]
];

private _config = [] call CP_fnc_getFortifyConfig;
if !([_config] call CP_fnc_isFortifyPersistenceActive) exitWith {[]};
if (isNull _object) exitWith {[]};

private _existingId = _object getVariable ["CP_fortifyPersistenceId", ""];
private _isFortifyManaged = _object getVariable ["CP_fortifyBuilt", false];
if ((_existingId isEqualTo "") && {!_isFortifyManaged}) exitWith {[]};

private _id = [_object] call CP_fnc_registerFortifyObject;
if (_id isEqualTo "") exitWith {[]};

private _class = typeOf _object;
private _missionKey = [] call CP_fnc_buildMissionKey;
private _sideKey = _object getVariable ["CP_fortifySideKey", "unknown"];
private _cost = _object getVariable ["CP_fortifyCost", -1];

private _persistPosition = (_config param [CP_FOR_CFG_PERSIST_POSITION, false]) && {!_deleted};
private _persistDamage = (_config param [CP_FOR_CFG_PERSIST_DAMAGE, false]) && {!_deleted};

private _posASL = [];
private _dir = 0;
private _vectorUp = [];
if (_persistPosition) then {
    _posASL = getPosASL _object;
    _dir = getDir _object;
    _vectorUp = vectorUp _object;
};

private _damage = 0;
if (_persistDamage) then {
    _damage = damage _object;
};

[
    CP_FOR_RECORD_SCHEMA_VERSION,
    "fortify",
    _id,
    _missionKey,
    _class,
    _deleted,
    _sideKey,
    _cost,
    _persistPosition,
    _posASL,
    _dir,
    _vectorUp,
    _persistDamage,
    _damage,
    serverTime
]
