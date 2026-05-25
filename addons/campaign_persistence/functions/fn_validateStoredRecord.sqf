params [
    ["_record", [], [[]]],
    ["_unit", objNull, [objNull]]
];

if !(_record isEqualType []) exitWith {[false, "record_not_array"]};
if ((count _record) < 12) exitWith {[false, "record_too_short"]};
if ((_record select 0) isNotEqualTo CP_RECORD_SCHEMA_VERSION) exitWith {[false, "unsupported_schema"]};

private _uid = _record param [CP_RECORD_UID, "", [""]];
private _missionKey = _record param [CP_RECORD_MISSION_KEY, "", [""]];
if (_uid isEqualTo "" || {_missionKey isEqualTo ""}) exitWith {[false, "missing_identity"]};

if (!isNull _unit && {_uid isNotEqualTo getPlayerUID _unit}) exitWith {[false, "uid_mismatch"]};
if (_missionKey isNotEqualTo ([] call CP_fnc_buildMissionKey)) exitWith {[false, "mission_key_mismatch"]};

private _hasPosition = _record param [CP_RECORD_HAS_POSITION, false];
private _posASL = _record param [CP_RECORD_POS_ASL, [], [[]]];
private _dir = _record param [CP_RECORD_DIR, 0, [0]];
if (_hasPosition) then {
    if !(_posASL isEqualType [] && {(count _posASL) isEqualTo 3}) exitWith {[false, "invalid_position"]};
    if !(_dir isEqualType 0) exitWith {[false, "invalid_direction"]};
};

private _hasLoadout = _record param [CP_RECORD_HAS_LOADOUT, false];
private _loadout = _record param [CP_RECORD_LOADOUT, [], [[]]];
if (_hasLoadout && {!(_loadout isEqualType [])}) exitWith {[false, "invalid_loadout"]};

private _hasHealth = _record param [CP_RECORD_HAS_HEALTH, false];
private _damage = _record param [CP_RECORD_DAMAGE, 0, [0]];
if (_hasHealth && {!(_damage isEqualType 0)}) exitWith {[false, "invalid_damage"]};

private _vehicleId = _record param [CP_RECORD_VEHICLE_ID, "", [""]];
private _vehicleRole = _record param [CP_RECORD_VEHICLE_ROLE, [], [[]]];
if !(_vehicleId isEqualType "") exitWith {[false, "invalid_vehicle_id"]};
if !(_vehicleRole isEqualType []) exitWith {[false, "invalid_vehicle_role"]};

[true, ""]
