params [
    ["_vehicle", objNull, [objNull]]
];

if (isNull _vehicle) exitWith {[]};

private _turretAmmo = [];
{
    private _magazineClass = _x param [0, "", [""]];
    private _turretPath = _x param [1, [], [[]]];
    private _ammoCount = _x param [2, 0, [0]];
    if (_magazineClass isNotEqualTo "" && {_turretPath isEqualType []} && {_ammoCount isEqualType 0}) then {
        _turretAmmo pushBack [_magazineClass, _turretPath, _ammoCount];
    };
} forEach (magazinesAllTurrets _vehicle);

private _pylons = [];
{
    if (_x isNotEqualTo "") then {
        _pylons pushBack [_forEachIndex + 1, _x, _vehicle ammoOnPylon (_forEachIndex + 1)];
    };
} forEach (getPylonMagazines _vehicle);

[_turretAmmo, _pylons]
