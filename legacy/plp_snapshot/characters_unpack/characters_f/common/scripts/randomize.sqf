if (isServer) then {
	_rnd1 = floor random 5;
	_this setVariable ["BIS_randomSeed1", _rnd1, TRUE];
};

waitUntil {!(isNil {_this getVariable "BIS_randomSeed1"})};
_randomSeed1 = _this getVariable "BIS_randomSeed1";

_this setObjectTexture [0, ["\A3\Characters_F\Common\Data\basicbody_black_co.paa", 
"\A3\Characters_F\Common\Data\basicbody_blue_co.paa", 
"\A3\Characters_F\Common\Data\basicbody_brown_co.paa", 
"\A3\Characters_F\Common\Data\basicbody_green_co.paa", 
"\A3\Characters_F\Common\Data\basicbody_grey_co.paa"] select _randomSeed1];