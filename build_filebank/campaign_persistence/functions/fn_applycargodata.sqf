params [
    ["_container", objNull, [objNull]],
    ["_data", [], [[]]],
    ["_depth", 0, [0]]
];

if (isNull _container || {!(_data isEqualType [])}) exitWith {};

private _classCount = {
    params ["_entry", ["_defaultCount", 1]];

    private _class = "";
    private _count = _defaultCount;

    if (_entry isEqualType "") then {
        _class = _entry;
    } else {
        if (_entry isEqualType []) then {
            _class = _entry param [0, ""];
            private _rawCount = _entry param [1, _defaultCount];
            if (_rawCount isEqualType 0) then {
                _count = _rawCount;
            };
        };
    };

    [_class, _count]
};

clearWeaponCargoGlobal _container;
clearMagazineCargoGlobal _container;
clearItemCargoGlobal _container;
clearBackpackCargoGlobal _container;

private _weaponsCargo = _data param [0, [], [[]]];
private _weaponsItemsCargo = _data param [1, [], [[]]];
private _magazinesCargo = _data param [2, [], [[]]];
private _itemsCargo = _data param [3, [], [[]]];
private _backpacksCargo = _data param [4, [], [[]]];
private _nestedContainers = _data param [5, [], [[]]];

if (_weaponsItemsCargo isNotEqualTo []) then {
    {
        if (_x isEqualType [] && {(_x param [0, ""]) isNotEqualTo ""}) then {
            _container addWeaponWithAttachmentsCargoGlobal [_x, 1];
        };
    } forEach _weaponsItemsCargo;
} else {
    {
        ([_x] call _classCount) params ["_weapon", "_count"];
        if (_weapon isNotEqualTo "" && {_count > 0}) then {
            _container addWeaponCargoGlobal [_weapon, _count];
        };
    } forEach _weaponsCargo;
};

{
    ([_x] call _classCount) params ["_magazine", "_count"];
    if (_magazine isNotEqualTo "" && {_count > 0}) then {
        _container addMagazineCargoGlobal [_magazine, _count];
    };
} forEach _magazinesCargo;

{
    ([_x] call _classCount) params ["_item", "_count"];
    if (_item isNotEqualTo "" && {_count > 0}) then {
        _container addItemCargoGlobal [_item, _count];
    };
} forEach _itemsCargo;

{
    ([_x] call _classCount) params ["_backpack", "_count"];
    if (_backpack isNotEqualTo "" && {_count > 0}) then {
        _container addBackpackCargoGlobal [_backpack, _count];
    };
} forEach _backpacksCargo;

private _availableContainers = everyContainer _container;
private _usedIndexes = [];
if (_depth < 8) then {
    {
        private _record = _x;
        private _class = _record param [0, "", [""]];
        private _childData = _record param [1, [], [[]]];
        private _index = -1;

        {
            if (_index < 0 && {(_usedIndexes find _forEachIndex) < 0} && {(_x select 0) isEqualTo _class}) then {
                _index = _forEachIndex;
            };
        } forEach _availableContainers;

        if (_index >= 0) then {
            _usedIndexes pushBack _index;
            private _childContainer = (_availableContainers select _index) select 1;
            [_childContainer, _childData, _depth + 1] call CP_fnc_applyCargoData;
        };
    } forEach _nestedContainers;
};
