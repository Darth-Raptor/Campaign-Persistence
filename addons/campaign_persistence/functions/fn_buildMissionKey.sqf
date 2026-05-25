private _missionId = missionNamespace getVariable ["CP_runtimeMissionId", ""];
if (_missionId isEqualTo "") then {
    _missionId = missionName;
};
if (_missionId isEqualTo "") then {
    _missionId = missionNameSource;
};

format ["campaign_persistence:%1:%2", worldName, _missionId]
