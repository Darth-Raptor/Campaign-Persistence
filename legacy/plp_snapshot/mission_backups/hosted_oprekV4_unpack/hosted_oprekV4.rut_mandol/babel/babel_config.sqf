/*
    babel\babel_config.sqf
    ------------------------------------------------------------
    Slot-based ACRE Babel configuration for TF20

    - f_available_languages: all language types used in the mission
    - f_slotLanguagesByEdenVar: PRIMARY mapping (Eden variable name -> spoken languages)
    - f_slotLanguagesByRoleTitle: SECONDARY fallback (roleDescription title -> spoken languages)

    Language ID legend used below:
      en = English
      ru = Russian
      ar = Arabic
      ko = Korean
      pl = Polish
      sr = Serbian
      ku = Kurdish
      de = German
      fa = Farsi
      ps = Pashto
      fr = French
      fil = Filipino
      zh = Mandarin Chinese
      es = Spanish
      pt = Portuguese
*/

f_available_languages = [
    ["en",  "English"],
    ["ru",  "Russian"],
    ["ar",  "Arabic"],
    ["ko",  "Korean"],
    ["pl",  "Polish"],
    ["sr",  "Serbian"],
    ["ku",  "Kurdish"],
    ["de",  "German"],
    ["fa",  "Farsi"],
    ["ps",  "Pashto"],
    ["fr",  "French"],
    ["fil", "Filipino"],
    ["zh",  "Mandarin Chinese"],
    ["es",  "Spanish"],
    ["pt",  "Portuguese"]
];

/*
    PRIMARY: Eden variable name -> spoken languages
*/
f_slotLanguagesByEdenVar = createHashMapFromArray [
    ["W11",     ["en","pl","de"]],
    ["W12",     ["en","pl","de"]],
    ["W13",     ["en","pl","ar"]],
    ["X11",     ["en","ko","pl"]],
    ["XA1",     ["en","sr","ku"]],
    ["XA2",     ["en","ar","de"]],
    ["XA3",     ["en","de","fa"]],
    ["XA4",     ["en","fr","fil"]],
    ["XA5",     ["en","pl","zh"]],
    ["XA6",     ["en","ru","ps"]],
    ["XA7",     ["en","es","pt"]],
    ["XA8",     ["en"]],
    ["C001",    ["en"]],
    ["C002",    ["en"]],
    ["C003",    ["en"]],
    ["R101",    ["en"]],
    ["R102",    ["en"]],
    ["R103",    ["en"]],
    ["R104",    ["en"]],
    ["R105",    ["en"]],
    ["R106",    ["en"]],
    ["R107",    ["en"]],
    ["R108",    ["en"]],
    ["R109",    ["en"]],
    ["S001",    ["en"]],
    ["S002",    ["en"]],
    ["S003",    ["en"]],
    ["S004",    ["en"]]
];

/*
    SECONDARY: roleDescription title (before any "@") -> spoken languages
    This is only used if Eden var name is not available on first capture.
*/
f_slotLanguagesByRoleTitle = createHashMapFromArray [
    ["W11@Task Force 20 HHC",     ["en","pl","ar"]],
    ["W12",     ["en","pl","ar"]],
    ["W13",     ["en","pl","ar"]],
    ["X11",     ["en","ko","pl"]],
    ["XA1",     ["en","sr","ku"]],
    ["XA2",     ["en","ar","ps"]],
    ["XA3",     ["en","de","fa"]],
    ["XA4",     ["en","fr","fil"]],
    ["XA5",     ["en","ar","zh"]],
    ["XA6",     ["en","ru","ps"]],
    ["XA7",     ["en","es","pt"]],
    ["XA8",     ["en"]],
    ["C-001",    ["en"]],
    ["C-002",    ["en"]],
    ["C-003",    ["en"]],
    ["R-101",    ["en"]],
    ["R-102",    ["en"]],
    ["R-103",    ["en"]],
    ["R-104",    ["en"]],
    ["R-105",    ["en"]],
    ["R-106",    ["en"]],
    ["R-107",    ["en"]],
    ["R-108",    ["en"]],
    ["R-109",    ["en"]],
    ["S-001",    ["en"]],
    ["S-002",    ["en"]],
    ["S-003",    ["en"]],
    ["S-004",    ["en"]]
];