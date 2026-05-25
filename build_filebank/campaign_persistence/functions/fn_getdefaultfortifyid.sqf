params [
    ["_object", objNull, [objNull]]
];

if (isNull _object) exitWith {""};
format ["fortify:%1:%2:%3", typeOf _object, round (serverTime * 100), floor (random 1000000)]
