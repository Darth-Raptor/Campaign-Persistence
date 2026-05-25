params [
    ["_vehicle", objNull, [objNull]],
    ["_state", [], [[]]]
];

if (isNull _vehicle || {!(_state isEqualType [])}) exitWith {};

private _applyAmmo = {
    params ["_targetVehicle", "_ammoState"];

    _targetVehicle setVehicleAmmo 0;

    {
        private _magazineClass = _x param [0, "", [""]];
        private _turretPath = _x param [1, [], [[]]];
        private _ammoCount = _x param [2, 0, [0]];
        if (_magazineClass isNotEqualTo "" && {_turretPath isEqualType []} && {_ammoCount isEqualType 0}) then {
            _targetVehicle setMagazineTurretAmmo [_magazineClass, _ammoCount, _turretPath];
        };
    } forEach (_ammoState param [0, [], [[]]]);

    {
        private _pylonIndex = _x param [0, -1, [0]];
        private _magazineClass = _x param [1, "", [""]];
        private _ammoCount = _x param [2, 0, [0]];
        if (_pylonIndex > 0 && {_magazineClass isNotEqualTo ""}) then {
            _targetVehicle setPylonLoadout [_pylonIndex, _magazineClass, true];
            if (_ammoCount isEqualType 0) then {
                _targetVehicle setAmmoOnPylon [_pylonIndex, _ammoCount];
            };
        };
    } forEach (_ammoState param [1, [], [[]]]);
};

[_vehicle, _state] call _applyAmmo;

[_vehicle, _state] spawn {
    params ["_targetVehicle", "_ammoState"];
    sleep 1;
    if (!isNull _targetVehicle) then {
        _targetVehicle setVehicleAmmo 0;

        {
            private _magazineClass = _x param [0, "", [""]];
            private _turretPath = _x param [1, [], [[]]];
            private _ammoCount = _x param [2, 0, [0]];
            if (_magazineClass isNotEqualTo "" && {_turretPath isEqualType []} && {_ammoCount isEqualType 0}) then {
                _targetVehicle setMagazineTurretAmmo [_magazineClass, _ammoCount, _turretPath];
            };
        } forEach (_ammoState param [0, [], [[]]]);

        {
            private _pylonIndex = _x param [0, -1, [0]];
            private _magazineClass = _x param [1, "", [""]];
            private _ammoCount = _x param [2, 0, [0]];
            if (_pylonIndex > 0 && {_magazineClass isNotEqualTo ""}) then {
                _targetVehicle setPylonLoadout [_pylonIndex, _magazineClass, true];
                if (_ammoCount isEqualType 0) then {
                    _targetVehicle setAmmoOnPylon [_pylonIndex, _ammoCount];
                };
            };
        } forEach (_ammoState param [1, [], [[]]]);
    };
};
