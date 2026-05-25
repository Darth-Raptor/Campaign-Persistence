params [
    ["_requestOwner", -1, [0]],
    ["_expectedOwner", -1, [0]],
    ["_unit", objNull, [objNull]]
];

if (_expectedOwner <= 0) exitWith {false};
if (isNull _unit || {!isPlayer _unit}) exitWith {false};

private _unitOwner = owner _unit;
if (_unitOwner != _expectedOwner) exitWith {false};

if (_requestOwner isEqualTo _expectedOwner) exitWith {true};

// Hosted or loopback test sessions can surface remoteExecutedOwner as -1
// even though the target unit is still owned by the expected client.
if (_requestOwner < 0) exitWith {true};

false
