params [
    ["_vehicle", objNull, [objNull]],
    ["_state", 0, [0, []]]
];

if (isNull _vehicle) exitWith {};

if (_state isEqualType 0) exitWith {
    _vehicle setDamage ((_state max 0) min 1);
};

if !(_state isEqualType []) exitWith {};

private _overallDamage = _state param [0, damage _vehicle, [0]];
private _hitPointNames = _state param [1, [], [[]]];
private _hitPointDamages = _state param [2, [], [[]]];

_vehicle setDamage ((_overallDamage max 0) min 1);

if ((_hitPointNames isEqualType []) && {(_hitPointDamages isEqualType [])}) then {
    {
        private _hitPointName = _x;
        private _hitPointDamage = _hitPointDamages param [_forEachIndex, -1, [0]];
        if (_hitPointName isEqualType "" && {_hitPointName isNotEqualTo ""} && {_hitPointDamage >= 0}) then {
            _vehicle setHitPointDamage [_hitPointName, (_hitPointDamage max 0) min 1, true];
        };
    } forEach _hitPointNames;
};
