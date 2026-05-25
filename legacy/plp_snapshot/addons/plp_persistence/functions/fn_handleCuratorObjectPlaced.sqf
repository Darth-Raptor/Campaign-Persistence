/*
    Server side handling for Zeus placed objects.
    Assigns persistence ids early, and excludes Zeus vehicles spawned with AI crew.
*/
if (!isServer) exitWith {
    _this remoteExecCall ["PLP_fnc_handleCuratorObjectPlaced", 2];
};

params ["_curator", "_entity"];

[_curator, _entity] spawn {
    params ["_curator", "_entity"];

    sleep 1;

    if (isNull _entity) exitWith {};

    private _object = _entity;
    if (_entity isKindOf "CAManBase" && {vehicle _entity isNotEqualTo _entity}) then {
        _object = vehicle _entity;
    };

    if (isNull _object) exitWith {};
    if (_object getVariable ["PLP_zeusPlacementHandled", false]) exitWith {};

    _object setVariable ["PLP_zeusPlacementHandled", true, true];
    _object setVariable ["PLP_zeusPlaced", true, true];

    private _hasAiCrew = false;
    if !(_object isKindOf "CAManBase") then {
        _hasAiCrew = (crew _object findIf {!isPlayer _x}) >= 0;
    };

    if (_hasAiCrew) exitWith {
        _object setVariable ["PLP_disablePersistence", true, true];
        ["INFO", "Skipped Zeus placed AI-crewed object", createHashMapFromArray [
            ["class", typeOf _object],
            ["crew", count crew _object]
        ]] call PLP_fnc_log;
    };

    if ([_object] call PLP_fnc_isLogisticsPersistent) then {
        private _id = [_object] call PLP_fnc_registerLogisticsObject;
        ["DEBUG", "Registered Zeus placed object", createHashMapFromArray [
            ["id", _id],
            ["class", typeOf _object],
            ["category", [_object] call PLP_fnc_getObjectCategory]
        ]] call PLP_fnc_log;

        ["zeusObjectPlaced", _object] call PLP_fnc_requestSave;
    };
};
