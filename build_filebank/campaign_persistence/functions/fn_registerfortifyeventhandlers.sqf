if (!isServer) exitWith {};
if (missionNamespace getVariable ["CP_fortifyEventHandlersRegistered", false]) exitWith {};
if (isNil "CBA_fnc_addEventHandler") exitWith {
    ["WARN", "CBA event handler API was unavailable; Fortify Persistence runtime hooks were not registered."] call CP_fnc_log;
};

["acex_fortify_objectPlaced", {
    params ["_player", "_side", "_object"];

    private _config = [] call CP_fnc_getFortifyConfig;
    if !([_config] call CP_fnc_isFortifyPersistenceActive) exitWith {};
    if (isNull _object) exitWith {};

    private _cost = _object getVariable ["ace_fortify_cost", -1];
    private _id = [_object, _side, _cost] call CP_fnc_registerFortifyObject;
    if (_id isEqualTo "") exitWith {};

    private _logisticsConfig = [] call CP_fnc_getLogisticsConfig;
    if ([_logisticsConfig] call CP_fnc_isLogisticsPersistenceActive) then {
        if (([_object] call CP_fnc_getLogisticsCategory) isNotEqualTo "") then {
            [_object, [_id] call CP_fnc_getDerivedLogisticsIdForFortify] call CP_fnc_registerLogisticsObject;
        };
    };

    [_object] spawn {
        params ["_placedObject"];
        sleep 1;

        if (isNull _placedObject) exitWith {};

        private _delayedConfig = [] call CP_fnc_getFortifyConfig;
        if !([_delayedConfig] call CP_fnc_isFortifyPersistenceActive) exitWith {};

        private _record = [_placedObject, false] call CP_fnc_buildFortifyRecord;
        if !(_record isEqualTo []) then {
            [_record] call CP_fnc_saveFortifyObjectRecord;
        };

        private _budgetRecord = [] call CP_fnc_buildFortifyBudgetRecord;
        if !(_budgetRecord isEqualTo []) then {
            [_budgetRecord] call CP_fnc_saveFortifyBudgetRecord;
        };
    };
}] call CBA_fnc_addEventHandler;

["acex_fortify_objectDeleted", {
    params ["_player", "_side", "_object"];

    private _config = [] call CP_fnc_getFortifyConfig;
    if !([_config] call CP_fnc_isFortifyPersistenceActive) exitWith {};
    if (isNull _object) exitWith {};

    private _cost = _object getVariable ["CP_fortifyCost", -1];
    [_object, _side, _cost] call CP_fnc_registerFortifyObject;

    private _record = [_object, true] call CP_fnc_buildFortifyRecord;
    if !(_record isEqualTo []) then {
        [_record] call CP_fnc_saveFortifyObjectRecord;
        ["INFO", "Saved fortify tombstone because an ACE Fortify object was deleted.", _record param [CP_FOR_RECORD_ID, "", [""]]] call CP_fnc_log;
    };

    private _logisticsConfig = [] call CP_fnc_getLogisticsConfig;
    if ([_logisticsConfig] call CP_fnc_isLogisticsPersistenceActive) then {
        private _logisticsRecord = [_object, true] call CP_fnc_buildLogisticsRecord;
        if !(_logisticsRecord isEqualTo []) then {
            [_logisticsRecord] call CP_fnc_saveLogisticsRecord;
        };
    };

    private _budgetRecord = [] call CP_fnc_buildFortifyBudgetRecord;
    if !(_budgetRecord isEqualTo []) then {
        [_budgetRecord] call CP_fnc_saveFortifyBudgetRecord;
    };
}] call CBA_fnc_addEventHandler;

missionNamespace setVariable ["CP_fortifyEventHandlersRegistered", true];
["INFO", "Registered Fortify Persistence ACE event handlers."] call CP_fnc_log;
