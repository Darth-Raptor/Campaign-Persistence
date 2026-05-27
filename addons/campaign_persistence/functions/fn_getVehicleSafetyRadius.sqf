params [
    ["_vehicle", objNull, [objNull]]
];

if (isNull _vehicle) exitWith {3};

private _bounds = boundingBoxReal _vehicle;
if !(_bounds isEqualType [] && {(count _bounds) >= 2}) exitWith {3};

private _mins = _bounds param [0, [0, 0, 0], [[]]];
private _maxs = _bounds param [1, [0, 0, 0], [[]]];

private _halfWidth = abs ((_maxs param [0, 0, [0]]) - (_mins param [0, 0, [0]])) / 2;
private _halfLength = abs ((_maxs param [1, 0, [0]]) - (_mins param [1, 0, [0]])) / 2;
private _radius = (_halfWidth max _halfLength) + 1.0;

_radius max 2.5
