if (!hasInterface) exitWith {};
if (isNull player || {!alive player} || {!local player}) exitWith {};

[player, getPlayerUID player] remoteExecCall ["CP_fnc_serverHandleManualSaveRequest", 2]
