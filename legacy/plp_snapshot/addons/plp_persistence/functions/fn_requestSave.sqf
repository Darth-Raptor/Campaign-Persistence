/*
    Server-side debounced save request for event-triggered persistence updates.
*/
if (!isServer) exitWith {};
[] call PLP_fnc_ensureServerState;
params [["_reason", "", [""]], ["_object", objNull, [objNull]]];

private _reasons = missionNamespace getVariable ["PLP_pendingSaveReasons", []];
_reasons pushBackUnique _reason;
missionNamespace setVariable ["PLP_pendingSaveReasons", _reasons];

if (!isNull _object && {[_object] call PLP_fnc_isLogisticsPersistent}) then {
    [_object] call PLP_fnc_registerLogisticsObject;
};

if (missionNamespace getVariable ["PLP_saveRequestScheduled", false]) exitWith {};
missionNamespace setVariable ["PLP_saveRequestScheduled", true];

[] spawn {
    sleep 2;
    private _reasons = missionNamespace getVariable ["PLP_pendingSaveReasons", []];
    missionNamespace setVariable ["PLP_pendingSaveReasons", []];
    missionNamespace setVariable ["PLP_saveRequestScheduled", false];

    ["INFO", "Processing event-triggered save", createHashMapFromArray [
        ["reasons", _reasons]
    ]] call PLP_fnc_log;

    [] call PLP_fnc_saveAll;
};
