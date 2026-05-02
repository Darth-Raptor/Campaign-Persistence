/*
    Registers local client events that request server saves after meaningful persistence changes.
*/
if (!hasInterface) exitWith {};
params [["_unit", player, [objNull]]];

if (isNull _unit) exitWith {};
if (_unit getVariable ["PLP_saveTriggersRegistered", false]) exitWith {};

_unit setVariable ["PLP_saveTriggersRegistered", true];

_unit addEventHandler ["InventoryClosed", {
    params ["_unit", "_container"];

    private _uid = getPlayerUID _unit;
    if (_uid isNotEqualTo "") then {
        [_uid, [_unit] call PLP_fnc_collectPlayerData] remoteExecCall ["PLP_fnc_storePlayerData", 2];
    };

    private _reason = "playerInventoryClosed";
    if (!isNull _container) then {
        if (_container isKindOf "ReammoBox_F") then {
            _reason = "crateInventoryClosed";
        } else {
            if (_container isKindOf "LandVehicle" || {_container isKindOf "Air"} || {_container isKindOf "Ship"}) then {
                _reason = "vehicleInventoryClosed";
            } else {
                _reason = "containerInventoryClosed";
            };
        };
    };

    [_reason, _container] remoteExecCall ["PLP_fnc_requestSave", 2];
}];

_unit addEventHandler ["GetOutMan", {
    params ["_unit", "", "_vehicle"];

    if (!isNull _vehicle) then {
        ["vehicleExit", _vehicle] remoteExecCall ["PLP_fnc_requestSave", 2];
    };
}];
