params [
    ["_vehicle", objNull, [objNull]],
    ["_targetPosASL", [], [[]]]
];

if (isNull _vehicle) exitWith {_targetPosASL};
if !(_targetPosASL isEqualType [] && {(count _targetPosASL) isEqualTo 3}) exitWith {_targetPosASL};

private _selfRadius = [_vehicle] call CP_fnc_getVehicleSafetyRadius;
private _targetPosAGL = ASLToAGL _targetPosASL;
private _searchRadius = (_selfRadius + 30) max 35;

private _isSafe = {
    params ["_candidatePosASL"];

    private _nearby = nearestObjects [ASLToAGL _candidatePosASL, ["LandVehicle", "Air", "Ship", "StaticWeapon"], _searchRadius, true];
    private _unsafeIndex = _nearby findIf {
        private _other = _x;
        if (isNull _other || {_other isEqualTo _vehicle}) exitWith {false};

        private _otherRadius = [_other] call CP_fnc_getVehicleSafetyRadius;
        private _minDistance = _selfRadius + _otherRadius + 0.75;
        (_candidatePosASL distance2D (getPosASL _other)) < _minDistance
    };

    _unsafeIndex < 0
};

if ([_targetPosASL] call _isSafe) exitWith {_targetPosASL};

private _stepDistance = (_selfRadius * 1.5) max 4;
private _maxRings = 8;
private _resolvedPosASL = _targetPosASL;
private _foundSafePosition = false;

for "_ring" from 1 to _maxRings do {
    private _ringDistance = _stepDistance * _ring;

    for "_index" from 0 to 15 do {
        private _angle = _index * 22.5;
        private _offsetX = (sin _angle) * _ringDistance;
        private _offsetY = (cos _angle) * _ringDistance;
        private _candidatePosAGL = [
            (_targetPosAGL param [0, 0, [0]]) + _offsetX,
            (_targetPosAGL param [1, 0, [0]]) + _offsetY,
            _targetPosAGL param [2, 0, [0]]
        ];
        private _candidatePosASL = AGLToASL _candidatePosAGL;

        if ([_candidatePosASL] call _isSafe) exitWith {
            _resolvedPosASL = _candidatePosASL;
            _foundSafePosition = true;
        };
    };

    if (_foundSafePosition) exitWith {};
};

_resolvedPosASL
