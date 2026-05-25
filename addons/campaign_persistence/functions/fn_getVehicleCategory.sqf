params [
    ["_object", objNull, [objNull]]
];

if (isNull _object) exitWith {""};
if (_object isKindOf "CAManBase") exitWith {""};
if (_object isKindOf "Logic") exitWith {""};
if (_object isKindOf "Module_F") exitWith {""};
if (_object isKindOf "EmptyDetector") exitWith {""};

if (_object isKindOf "StaticWeapon") exitWith {"static"};
if (_object isKindOf "Air") exitWith {"air"};
if (_object isKindOf "Ship") exitWith {"boat"};
if (_object isKindOf "Tank") exitWith {"armor"};
if (_object isKindOf "Car") exitWith {"car"};
""
