params [
    ["_fortifyId", "", [""]]
];

if (_fortifyId isEqualTo "") exitWith {""};
format ["fortifyLog:%1", _fortifyId]
