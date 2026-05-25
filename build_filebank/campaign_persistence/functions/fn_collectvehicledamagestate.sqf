params [
    ["_vehicle", objNull, [objNull]]
];

if (isNull _vehicle) exitWith {0};

private _hitPointState = getAllHitPointsDamage _vehicle;
private _hitPointNames = _hitPointState param [0, [], [[]]];
private _hitPointDamages = _hitPointState param [2, [], [[]]];

[
    damage _vehicle,
    _hitPointNames,
    _hitPointDamages
]
