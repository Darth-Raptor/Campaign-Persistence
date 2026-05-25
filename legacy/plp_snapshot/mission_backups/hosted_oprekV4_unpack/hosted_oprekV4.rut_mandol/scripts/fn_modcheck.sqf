private _loadedModsInfo = getLoadedModsInfo;

_serverMods = [nil, "TF20_ServerMods", "empty"] call BIS_fnc_getServerVariable;
_localMods = { _x == "0" } count _serverMods;
_localMods = _localMods - 1; //1 is for game

_clientMods = [];
{ _clientMods pushBack (_x select 7) } forEach _loadedModsInfo;

_result = _clientMods arrayIntersect _serverMods;
for [{ _i = _localMods }, { _i > 0 }, { _i = _i - 1 }] do { _result pushBack "0" };

if (count _result != count _clientMods) then
{
	private _remainingServerMods = +_serverMods;
	private _badMods = [];

	{
		private _modName = _x select 0;
		private _modId = _x select 7;
		private _modIndex = _remainingServerMods find _modId;

		if (_modIndex > -1) then
		{
			_remainingServerMods deleteAt _modIndex;
		}
		else
		{
			_badMods pushBack format ["%1, %2", _modName, _modId];
		};
	} forEach _loadedModsInfo;

	private _logLine = format ["%1 - %2", name player, _badMods joinString " - "];
	[_logLine] remoteExecCall ["diag_log", 2];

	diag_log _serverMods;
	diag_log _clientMods;
	diag_log _result;
	endMission "MODMISMATCH";
};