params [
    ["_container", objNull, [objNull]],
    ["_depth", 0, [0]],
    ["_includeNested", true, [true]]
];

if (isNull _container) exitWith {[]};

private _toPairs = {
    params ["_cargo"];

    private _pairs = [];
    private _classes = _cargo param [0, []];
    private _counts = _cargo param [1, []];

    {
        private _count = _counts param [_forEachIndex, 0];
        if (_x isNotEqualTo "" && {_count > 0}) then {
            _pairs pushBack [_x, _count];
        };
    } forEach _classes;

    _pairs
};

private _nestedContainers = [];
if (_includeNested && {_depth < 8}) then {
    {
        _x params ["_class", "_childContainer"];
        if (!isNull _childContainer) then {
            _nestedContainers pushBack [_class, [_childContainer, _depth + 1, _includeNested] call CP_fnc_collectCargoData];
        };
    } forEach (everyContainer _container);
};

[
    [getWeaponCargo _container] call _toPairs,
    weaponsItemsCargo _container,
    [getMagazineCargo _container] call _toPairs,
    [getItemCargo _container] call _toPairs,
    [getBackpackCargo _container] call _toPairs,
    _nestedContainers
]
