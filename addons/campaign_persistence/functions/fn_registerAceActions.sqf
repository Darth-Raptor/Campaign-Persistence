if (!hasInterface) exitWith {};
if (isNil "ace_interact_menu_fnc_createAction") exitWith {
    ["WARN", "ACE interaction functions were not found; manual save actions will not be available."] call CP_fnc_log;
};

if (missionNamespace getVariable ["CP_aceActionsRegistered", false]) exitWith {};

private _parentAction = [
    "CP_parentAction",
    "Campaign Persistence",
    "",
    {},
    {
        private _config = [] call CP_fnc_getServerConfig;
        [_config] call CP_fnc_isPlayerPersistenceActive && (_config param [CP_CFG_ACE_MANUAL_SAVE, false]) && {alive player}
    }
] call ace_interact_menu_fnc_createAction;

[player, 1, ["ACE_SelfActions"], _parentAction] call ace_interact_menu_fnc_addActionToObject;

private _confirmAction = [
    "CP_confirmSaveAction",
    "Confirm Save",
    "",
    {
        [] call CP_fnc_requestManualSave;
    },
    {
        private _config = [] call CP_fnc_getServerConfig;
        [_config] call CP_fnc_isPlayerPersistenceActive && (_config param [CP_CFG_ACE_MANUAL_SAVE, false]) && {alive player}
    }
] call ace_interact_menu_fnc_createAction;

[player, 1, ["ACE_SelfActions", "CP_parentAction"], _confirmAction] call ace_interact_menu_fnc_addActionToObject;

private _positionResetAction = [
    "CP_positionResetAction",
    "Position Reset",
    "",
    {},
    {
        private _config = [] call CP_fnc_getServerConfig;
        [_config] call CP_fnc_isPlayerPersistenceActive && (_config param [CP_CFG_ACE_MANUAL_SAVE, false]) && {alive player}
    }
] call ace_interact_menu_fnc_createAction;

[player, 1, ["ACE_SelfActions", "CP_parentAction"], _positionResetAction] call ace_interact_menu_fnc_addActionToObject;

private _confirmResetAction = [
    "CP_confirmResetAction",
    "Confirm Reset",
    "",
    {
        [] call CP_fnc_requestPositionReset;
    },
    {
        private _config = [] call CP_fnc_getServerConfig;
        [_config] call CP_fnc_isPlayerPersistenceActive && (_config param [CP_CFG_ACE_MANUAL_SAVE, false]) && {alive player}
    }
] call ace_interact_menu_fnc_createAction;

[player, 1, ["ACE_SelfActions", "CP_parentAction", "CP_positionResetAction"], _confirmResetAction] call ace_interact_menu_fnc_addActionToObject;
missionNamespace setVariable ["CP_aceActionsRegistered", true];
