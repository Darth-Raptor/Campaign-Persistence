waitUntil {!isNull player};
waitUntil {
	getClientState == "BRIEFING READ"
	&& {!isNull findDisplay 46}
	&& {isPlayer player}
	&& {(getPlayerUID player) != ""}
};

removeGoggles player;
[] call TFO_fnc_modcheck;
[] call TFO_fnc_slots;

call compile preprocessFileLineNumbers "babel\babel_config.sqf";
[] execVM "babel\fn_applySlotBabel.sqf";


//SITREP REPORT
["maps-beta.plan-ops.fr#149",0,"SITREP","SITREP","https://maps-beta.plan-ops.fr/MessageTemplates/Details/149?t=4k4GRbthum7XxJGpmigz2PLoLaWF63VTv9h2-uddiMs",[["SITREP","",[["","CALLSIGN",3]]],["LINE 1","LOCATION",[["","",7],["KEY PAD ","",1]]],["LINE 2","ACTIVITY",[["","",0]]],["LINE 3","ENEMY ACTIVITY",[["","",0]]],["LINE 4","LOGISTICS",[["G","",6],["Y","",6],["R","",6]]],["LINE 5","PERSONNEL",[["G","",6],["Y","",6],["R","",6]]],["LINE 6","REMARKS",[["","",8]]]]] call ctab_fnc_registerMessageTemplate;
//SALUTE REPORT
["maps-beta.plan-ops.fr#153",0,"SALUTE REPORT","SALUTE","https://maps-beta.plan-ops.fr/MessageTemplates/Details/153?t=Ke39MKDUHOH_BMq9CK1xCM4MNLS8qtKySYPfhF7iuAg",[["SALUTE","",[["SALUTE","",3]]],["LINE 1","SIZE",[["FIRE TEAM","",6],["SQUAD","",6],["PLATOON","",6],["COMPANY","",6],["","OTHER",0]]],["LINE 2","ACTIVITY",[["","",0]]],["LINE 3","LOCATION",[["","",5]]],["LINE 4","UNIT/UNIFORM",[["","",0]]],["LINE 5","TIME",[["","",2]]],["LINE 6","EQUIPMENT",[["","",8]]]]] call ctab_fnc_registerMessageTemplate;
//CONTACT REPORT
["maps-beta.plan-ops.fr#157",0,"CONTACT REPORT","CONTACT REPORT","https://maps-beta.plan-ops.fr/MessageTemplates/Details/157?t=ze7A2nERb1mgJqJOD4OtBzmrCgPXm6P_4tlYIC4T7V0",[["CONTACT REPORT","",[]],["LINE 1","REPORTING STATION",[["","",3]]],["LINE 2","ENEMY CONTACT DESCRIPTION",[["","",8]]],["LINE 3","LOCATION",[["","",5]]],["LINE 4","TIME",[["","",2]]],["LINE 5","FRIENDLY ACTION",[["","",8]]]]] call ctab_fnc_registerMessageTemplate;
//MED-EVAC
["maps-beta.plan-ops.fr#158",1,"MEDEVAc","MEDEVAc","https://maps-beta.plan-ops.fr/MessageTemplates/Details/158?t=u7OsraWi1JjleAkTuUb2K-aLw_7dp3EDm1zljUvCJwQ",[["MEDEVAC","",[]],["Line 1","LOCATION",[["","Grid of pickup zone",5]]],["Line 2","CALL SIGN & FREQ",[["","Call sign",3],["","Frequency",4]]],["Line 3","NUMBER OF PATIENTS/PRECEDENCE",[["URGT","URGENT Hospital under 90 min",1],["PRI","PRIORITY Hospital under 4 hours",1],["RTN","ROUTINE Hospital within 24 hours",1]]],["Line 4","SPECIAL EQUIPMENT REQUIRED",[["NONE","None",6],["Hoist","Hoist (Winch)",6],["EXTRT","EXTRACTION",6],["VENT","Ventilator",6],["OTHER","Others",0]]],["Line 5","NUMBER TO BE CARRIED LYING/SITTING",[["L","Litter (Stretcher)",1],["A","Ambulatory (Walking)",1],["E","Escorts (e.g. for child patient)",1]]],["Line 6","SECURITY AT PICKUP ZONE (PZ)",[["N","No enemy",6],["P","Possible enemy",6],["E","Enemy in area",6],["X","Hot PZ - Armed escort required",6]]],["Line 7","PICKUP ZONE (PZ) MARKING METHOD",[["P","Panels",6],["L","Laser",6],["S","Smoke",6],["F","Flare",6],["IR","IR",6],["O","Other",0]]],["Line 8","NATIONALITY/STATUS",[["BLUFOR","BLUFOR",1],["CIV","CIV",1],["REDFOR","REDFOR",1]]],["Line 9","PICKUP ZONE (PZ) TERRAIN/OBSTACLES",[["","Terrain / obstacles",0]]]]] call ctab_fnc_registerMessageTemplate;
//AIR TRANSPORT
["maps.plan-ops.fr#218",0,"AIR TRANSPORT","GRID","https://maps.plan-ops.fr/MessageTemplates/Details/218?t=OumNGrLfLdei_ryj8hQKJehPzXyDdyD823LL9e8PCw8",[["GRID","",[["","",7]]],["CONTACT","",[["","CALL SIGN",3],["ON FREQ ","FREQ",4]]],["PACKS","",[["","#",1]]],["SECURITY","",[["N","",6],["P","",6],["C","",6],["E","",6]]],["MARKING","",[["S","",6],["L","",6],["V","",6]]],["REMARKS","",[["","REMARKS",8]]]]] call ctab_fnc_registerMessageTemplate;