/*  babel\fn_applySlotBabel.sqf
    ------------------------------------------------------------
    Resilient slot-based ACRE Babel application.

    Improvements vs previous version:
    - Normalizes role titles:
        * strips anything after "@"
        * trims ends
        * collapses repeated whitespace
        * uppercases for case-insensitive matching
    - Normalizes Eden var name similarly (uppercase + trim)
    - Builds normalized lookup maps once per client for fast, reliable matching
    - Persists slot key by UID so respawn keeps the same identity

    Requires:
      - babel\babel_config.sqf loaded first (initPlayerLocal.sqf)
      - f_available_languages, f_slotLanguagesByEdenVar, f_slotLanguagesByRoleTitle defined
*/

if (!hasInterface) exitWith {};

waitUntil { !isNull player };
waitUntil { alive player };

// Wait until ACRE API exists AND ACRE is initialized (prevents races)
waitUntil {
    !(isNil "acre_api_fnc_isInitialized") &&
    { [] call acre_api_fnc_isInitialized }
};

// --- Guard rails (configuration) ---
if (isNil "f_available_languages") exitWith {
    diag_log "[BABEL] ERROR: f_available_languages is nil. Did you run babel_config.sqf from initPlayerLocal.sqf?";
};
if (isNil "f_slotLanguagesByEdenVar") exitWith {
    diag_log "[BABEL] ERROR: f_slotLanguagesByEdenVar is nil. Did you run babel_config.sqf from initPlayerLocal.sqf?";
};
if (isNil "f_slotLanguagesByRoleTitle") then {
    // role map optional, but create empty map if absent
    f_slotLanguagesByRoleTitle = createHashMap;
};

// --- Helpers (local functions) ---
if (isNil "f_fnc_babelNormalizeKey") then {
    f_fnc_babelNormalizeKey = {
        params [["_s", "", [""]]];

        if !(_s isEqualType "") then {
            _s = str _s;
        };

        // Take only part before "@"
        private _parts = _s splitString "@";
        _s = _parts param [0, "", [""]];

        // Manual trim + whitespace collapse to avoid trim/regexReplace issues
        private _chars = toArray _s;
        private _ws = [9, 10, 13, 32];
        private _start = 0;
        private _end = (count _chars) - 1;

        while {_start <= _end && {(_chars select _start) in _ws}} do {
            _start = _start + 1;
        };

        while {_end >= _start && {(_chars select _end) in _ws}} do {
            _end = _end - 1;
        };

        _chars = if (_start > _end) then {
            []
        } else {
            _chars select [_start, (_end - _start) + 1]
        };

        private _out = [];
        private _lastWasSpace = false;
        {
            private _isWs = _x in _ws;
            if (_isWs) then {
                if (!_lastWasSpace) then {
                    _out pushBack 32;
                };
            } else {
                _out pushBack _x;
            };
            _lastWasSpace = _isWs;
        } forEach _chars;

        _s = toString _out;

        // Uppercase for case-insensitive matching
        toUpper _s
    };
};

// --- Build normalized lookup maps once per client ---
if (isNil "f_babelNormMapsBuilt") then { f_babelNormMapsBuilt = false; };

if (!f_babelNormMapsBuilt) then {
    f_slotLanguagesByEdenVar_norm = createHashMap;
    {
        private _kNorm = [_x] call f_fnc_babelNormalizeKey;
        f_slotLanguagesByEdenVar_norm set [_kNorm, f_slotLanguagesByEdenVar get _x];
    } forEach (keys f_slotLanguagesByEdenVar);

    f_slotLanguagesByRoleTitle_norm = createHashMap;
    {
        private _kNorm = [_x] call f_fnc_babelNormalizeKey;
        f_slotLanguagesByRoleTitle_norm set [_kNorm, f_slotLanguagesByRoleTitle get _x];
    } forEach (keys f_slotLanguagesByRoleTitle);

    f_babelNormMapsBuilt = true;
};

// --- Register Babel language types once per client ---
if (isNil "f_babelTypesRegistered") then { f_babelTypesRegistered = false; };
if (!f_babelTypesRegistered) then {
    { _x call acre_api_fnc_babelAddLanguageType; } forEach f_available_languages;
    f_babelTypesRegistered = true;
};

// --- Resolve stable slot key (persist across respawns by UID) ---
private _uid = getPlayerUID player;
private _storedKeyVar = format ["f_slotKey_%1", _uid];

private _slotKeyNorm = missionNamespace getVariable [_storedKeyVar, ""];
private _edenVarNorm = "";
private _roleTitleNorm = "";

// Capture on first run (join/JIP). Keep for later respawns.
if (_slotKeyNorm isEqualTo "") then {
    _edenVarNorm = [vehicleVarName player] call f_fnc_babelNormalizeKey;
    _roleTitleNorm = [roleDescription player] call f_fnc_babelNormalizeKey;

    // Prefer Eden var if present; else fallback to role title
    _slotKeyNorm = if (_edenVarNorm != "") then {_edenVarNorm} else {_roleTitleNorm};

    missionNamespace setVariable [_storedKeyVar, _slotKeyNorm];
} else {
    // Still compute current role title for additional fallback / debugging
    _edenVarNorm = [vehicleVarName player] call f_fnc_babelNormalizeKey;
    _roleTitleNorm = [roleDescription player] call f_fnc_babelNormalizeKey;
};

// --- Lookup languages (normalized maps) ---
private _langs = [];

// 1) try persisted slotKeyNorm against EdenVar map
_langs = f_slotLanguagesByEdenVar_norm getOrDefault [_slotKeyNorm, []];

// 2) if not found, try current Eden var name
if (_langs isEqualTo [] && {_edenVarNorm != ""}) then {
    _langs = f_slotLanguagesByEdenVar_norm getOrDefault [_edenVarNorm, []];
};

// 3) if still not found, try role title
if (_langs isEqualTo [] && {_roleTitleNorm != ""}) then {
    _langs = f_slotLanguagesByRoleTitle_norm getOrDefault [_roleTitleNorm, []];
};

// 4) hard fail-safe
if (_langs isEqualTo []) then {
    _langs = ["en"];
    diag_log format [
        "[BABEL] WARNING: No mapping found. Defaulting to %1 | storedKey='%2' edenVar='%3' roleTitle='%4' uid='%5'",
        _langs, _slotKeyNorm, _edenVarNorm, _roleTitleNorm, _uid
    ];
};

// Apply spoken languages (local)
_langs call acre_api_fnc_babelSetSpokenLanguages;

// Force active speaking language to first entry for determinism
[_langs select 0] call acre_api_fnc_babelSetSpeakingLanguage;

// Debug
diag_log format [
    "[BABEL] Applied %1 | storedKey='%2' edenVar='%3' roleTitle='%4' uid='%5'",
    _langs, _slotKeyNorm, _edenVarNorm, _roleTitleNorm, _uid
];
