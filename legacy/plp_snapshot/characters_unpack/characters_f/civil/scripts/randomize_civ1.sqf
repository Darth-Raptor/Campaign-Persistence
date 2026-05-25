/*--------------------------------------------------------------------
	file: randomize.sqf
	===================
	Author: Julien VIDA <@tom_48_97>
	Description: Redirect to the new system
--------------------------------------------------------------------*/

if !(local _this || {_this getVariable ["BIS_enableRandomization",true]}) exitWith {};
[_this, [], false] call BIS_fnc_unitHeadgear;