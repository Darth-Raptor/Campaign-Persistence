if (!hasInterface) exitWith {};

private _unit = player;
if (isNull _unit || {!local _unit}) exitWith {};
if (_unit getVariable ["CP_firstUseHandlersRegistered", false]) exitWith {};

_unit setVariable ["CP_firstUseHandlersRegistered", true];

_unit addEventHandler ["GetInMan", {
    params ["_unit", "_role", "_vehicle", "_turret"];

    if (isNull _unit || {!local _unit} || {!isPlayer _unit} || {isNull _vehicle}) exitWith {};
    [_unit, _vehicle] remoteExecCall ["CP_fnc_serverRegisterVehicleFirstUse", 2];
}];

_unit addEventHandler ["InventoryOpened", {
    params ["_unit", "_container"];

    if (!isNull _unit && {local _unit} && {isPlayer _unit} && {!isNull _container}) then {
        [_unit, _container] remoteExecCall ["CP_fnc_serverRegisterLogisticsFirstUse", 2];
    };

    false
}];
