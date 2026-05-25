params [
    ["_id", "", [""]]
];

if (_id isEqualTo "") exitWith {objNull};

private _match = allMissionObjects "All" select {
    (_x getVariable ["CP_fortifyPersistenceId", ""]) isEqualTo _id
};

if (_match isEqualTo []) exitWith {objNull};
_match select 0
