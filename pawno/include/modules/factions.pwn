#include <YSI\y_hooks>
#include <map-zones>


#define MAX_FACTIONS 10
#define MAX_CONTRACTS 30

enum {
	FACTION_TYPE_NONE,
	FACTION_TYPE_MIXT,
	FACTION_TYPE_POLICE,
	FACTION_TYPE_GANGS,
	FACTION_TYPE_PEACEFUL
};

enum {
	SERVICE_PARAMEDICS,
	SERVICE_TAXI,
	SERVICE_INSTRUCTOR
};

enum factionInfoEnum {
	fID,
	fName[32 + 1],
	fMotd[128 + 1],
	fMinLevel,
	fMaxMembers,
	fInterior,
	fType,
	fMapIconType,
	fApps,
	fLocked,
	Float: fEnterX,
	Float: fEnterY,
	Float: fEnterZ,
	Float: fExitX,
	Float: fExitY,
	Float: fExitZ,

	fCommands[8],
	Text3D: fText,
	fMapIcon,
	fPickup
};
new factionInfo[MAX_FACTIONS + 1][factionInfoEnum], Iterator:ServerFactions<MAX_FACTIONS + 1>, Iterator:FactionMembers[MAX_FACTIONS + 1]<MAX_FACTIONS + 1>, Iterator:Wanteds<MAX_PLAYERS>, fSkins[MAX_FACTIONS + 1][8], factionChat[10], Iterator:ServiceCalls[3]<MAX_PLAYERS>, MedicAcceptedCall[MAX_PLAYERS], TaxiAcceptedCall[MAX_PLAYERS], InstructorAcceptedCall[MAX_PLAYERS], invitedPlayer[MAX_PLAYERS], invitedByPlayer[MAX_PLAYERS], ticketPlayer[MAX_PLAYERS], ticketMoney[MAX_PLAYERS], vehicleFaction[MAX_VEHICLES], vehiclePlayerID[MAX_VEHICLES], vehicleRank[MAX_VEHICLES], playerVehicle[MAX_PLAYERS], svfVehicleObjects[2], WarSeconds[MAX_PLAYERS], Iterator:ServerWars<3>, Iterator:Contracts<MAX_PLAYERS>, Contract[MAX_PLAYERS], bool:Undercover[MAX_PLAYERS];

enum contractEnum {
	cID,
	cAgainst,
	cMoney
};
new contractInfo[MAX_CONTRACTS][contractEnum];

new Float:cellRandom[6][3] = {
	{1166.2926,1313.7300,10.8203},
	{1170.7200,1319.0198,10.8203},
	{1172.7723,1313.0377,10.8203},
	{1165.4138,1304.9744,10.8203},
	{1171.6975,1299.7384,10.8203},
	{1166.7410,1294.8850,10.8203}
};

new const GunName[5][] = {
	{"Deagle"}, {"M4"}, {"Rifle"}, {"TEC9"}, {"Combat Shotgun"}
};

new const GunOrder[5][3] = {
	{24, 220, 200}, {31, 310, 320}, {33, 535, 320}, {32, 450, 400}, {27, 530, 250}
};

hook OnGameModeInit() {
	Iter_Init(ServiceCalls);
	return true;
}

hook OnPlayerConnect(playerid) {
	DeletePVar(playerid, "dutyDeelay");
	DeletePVar(playerid, "inviteDeelay");
	DeletePVar(playerid, "soDeelay");
    playerInfo[playerid][pinFaction] = 0;
    playerInfo[playerid][pspecFaction] = 0;
    MedicAcceptedCall[playerid] = -1;
    TaxiAcceptedCall[playerid] = -1;
    InstructorAcceptedCall[playerid] = -1;
    invitedPlayer[playerid] = -1;
	invitedByPlayer[playerid] = -1;
	ticketPlayer[playerid] = -1;
	ticketMoney[playerid] = -1;
	playerVehicle[playerid] = -1;
	WarSeconds[playerid] = -1;
	Contract[playerid] = -1;
	Undercover[playerid] = false;
	return true;
}

hook OnPlayerDeath(playerid, killerid) {
	if(Iter_Contains(FactionMembers[8], playerid) || Iter_Contains(FactionMembers[8], killerid) || Iter_Contains(FactionMembers[9], playerid) || Iter_Contains(FactionMembers[9], killerid)) {
		for(new turf = 1; turf < Iter_Count(ServerWars); turf++) {
			if(IsPlayerInTurf(playerid, turf) && IsPlayerInTurf(killerid, turf)) {
				if(warInfo[turf][wFaction] == playerInfo[playerid][pFaction] && warInfo[turf][wAttacker] == playerInfo[killerid][pFaction] || warInfo[turf][wFaction] == playerInfo[killerid][pFaction] && warInfo[turf][wAttacker] == playerInfo[playerid][pFaction]) {
					decese[playerid][turf] += 1;
					ucideri[killerid][turf] += 1;
					WarScore2[playerid][turf] += 1.5;
					if(playerInfo[killerid][pFaction] == warInfo[turf][wAttacker]) WarScore[1][turf] += 1.5;
					else if(playerInfo[killerid][pFaction] == warInfo[turf][wFaction]) WarScore[2][turf] += 1.5;
					new weaponName[32];
					GetWeaponName(GetPlayerWeapon(killerid), weaponName, 32); 
					SCMf(killerid, COLOR_LIGHTGREEN, "* (War System): L-ai omorat pe %s cu %s de la %d metri, ai primit %0.2f scor iar la echipa ai adus %s scor.", getName(playerid), weaponName, DistanceToPlayer(killerid, playerid), WarScore2[playerid][turf], playerInfo[killerid][pFaction] == warInfo[turf][wAttacker] ? string_fast("%0.2f", WarScore[1][turf]) : string_fast("%0.2f", WarScore[2][turf]));
					SCMf(playerid, COLOR_LIGHTGREEN, "* (War System): Ai fost omorat de %s cu %s de la %d metri.", getName(killerid), weaponName, DistanceToPlayer(playerid, killerid));
				}
			}
		}
	}
	return true;
}

stock factionName(fid) {
	new string[35];
	if(fid == 0) string = "None.";
	else format(string, sizeof(string), "%s", factionInfo[fid][fName]);
	return string;
}

function factionLog(factionid,name[],action[]) {
	gQuery[0] = (EOS);
	update("INSERT INTO `server_factionlogs` (`Factionid`, `Player`, `Action` VALUES('%d' '%s', '%s')", factionid, name, action);
	return true;
}

save_guns(playerid) {
	update("UPDATE `server_users` SET `Guns`='%d|%d|%d|%d|%d' WHERE `ID`='%d'", playerInfo[playerid][pGuns][0], playerInfo[playerid][pGuns][1], playerInfo[playerid][pGuns][2], 
	playerInfo[playerid][pGuns][3], playerInfo[playerid][pGuns][4], playerInfo[playerid][pSQLID]);
	return true;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
	if(ispassenger) return true;
	if(vehicleFaction[vehicleid] != playerInfo[playerid][pFaction] && vehicleFaction[vehicleid] != 0) {
		sendPlayerError(playerid, "Aceasta masina este una de factiune, iar tu nu esti in aceasta factiune.");
		slapPlayer(playerid);
		RemovePlayerFromVehicle(playerid);
	}
	return true;
}

hook OnVehicleDeath(vehicleid, killerid) {
	if(vehicleid == playerVehicle[vehiclePlayerID[vehicleid]]) {
		DestroyVehicle(playerVehicle[vehiclePlayerID[vehicleid]]); 
		vehicleFaction[playerVehicle[vehiclePlayerID[vehicleid]]] = 0; 
		playerVehicle[vehiclePlayerID[vehicleid]] = -1;
		vehiclePlayerID[vehicleid] = -1;
		if(IsValidObject(svfVehicleObjects[0])) DestroyObject(svfVehicleObjects[0]); 
		if(IsValidObject(svfVehicleObjects[1])) DestroyObject(svfVehicleObjects[1]);
	}
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
	new vehicleid = GetPlayerVehicleID(playerid);
	if(newstate == PLAYER_STATE_DRIVER) {
		if(vehicleFaction[vehicleid] != playerInfo[playerid][pFaction] && vehicleFaction[vehicleid] != 0) {
			sendPlayerError(playerid, "Aceasta masina este una de factiune, iar tu nu esti in aceasta factiune.");
			RemovePlayerFromVehicle(playerid);
		}
		if(vehicleRank[vehicleid] > playerInfo[playerid][pFactionRank]) {
			sendPlayerError(playerid,  "Nu ai rank-ul necesar pentru a intra in masina.");
			RemovePlayerFromVehicle(playerid);	
		}
	}
	return true;
}

hook OnPlayerDisconnect(playerid, reason) {
	if(playerVehicle[playerid] != -1) {
		DestroyVehicle(playerVehicle[playerid]); 
		vehicleFaction[playerVehicle[playerid]] = 0; 
		vehiclePlayerID[playerVehicle[playerid]] = -1;
		playerVehicle[playerid] = -1; 
		if(IsValidObject(svfVehicleObjects[0])) DestroyObject(svfVehicleObjects[0]); 
		if(IsValidObject(svfVehicleObjects[1])) DestroyObject(svfVehicleObjects[1]);
	}
	if(playerInfo[playerid][pFaction]) Iter_Remove(FactionMembers[playerInfo[playerid][pFaction]], playerid);
	for(new x; x < 3; x++) {
		if(Iter_Contains(ServiceCalls[x], playerid)) Iter_Remove(ServiceCalls[x], playerid);
	}
	if(MedicAcceptedCall[playerid] != -1) {
		MedicAcceptedCall[MedicAcceptedCall[playerid]] = -1;
		if(Iter_Contains(FactionMembers[1], playerid)) {
			sendFactionMessage(1, COLOR_LIMEGREEN, "(*) %s a anulat apelul lui %s deoarece s-a deconectat.", getName(playerid), getName(MedicAcceptedCall[playerid]));
			SCMf(MedicAcceptedCall[playerid], -1, "{FF6347}(Paramedic Call): {FFFFFF}Your call has been canceled by %s because he disconnected.", getName(playerid));
		}
		else {
			sendFactionMessage(1, COLOR_LIMEGREEN, "(*) %s a anulat apelul preluat de %s deoarece s-a deconectat.", getName(playerid), getName(MedicAcceptedCall[playerid]));
			if(playerInfo[MedicAcceptedCall[playerid]][pCheckpoint] == CHECKPOINT_FACTION_DUTY && playerInfo[MedicAcceptedCall[playerid]][pCheckpointID] == playerid) {
				DisablePlayerCheckpoint(MedicAcceptedCall[playerid]);
				playerInfo[MedicAcceptedCall[playerid]][pCheckpoint] = CHECKPOINT_NONE;
				playerInfo[MedicAcceptedCall[playerid]][pCheckpointID] = -1;
			}
		}
	}
	if(TaxiAcceptedCall[playerid] != -1) {
		TaxiAcceptedCall[TaxiAcceptedCall[playerid]] = -1;
		if(Iter_Contains(FactionMembers[5], playerid)) {
			sendFactionMessage(5, COLOR_LIMEGREEN, "(*) %s a anulat apelul lui %s deoarece s-a deconectat.", getName(playerid), getName(TaxiAcceptedCall[playerid]));
			SCMf(TaxiAcceptedCall[playerid], -1, "{FF6347}(Taxi Call): {FFFFFF}Your call has been canceled by %s because he disconnected.", getName(playerid));
		}
		else {
			sendFactionMessage(5, COLOR_LIMEGREEN, "(*) %s a anulat apelul preluat de %s deoarece s-a deconectat.", getName(playerid), getName(TaxiAcceptedCall[playerid]));
			if(playerInfo[TaxiAcceptedCall[playerid]][pCheckpoint] == CHECKPOINT_FACTION_DUTY && playerInfo[TaxiAcceptedCall[playerid]][pCheckpointID] == playerid) {
				DisablePlayerCheckpoint(TaxiAcceptedCall[playerid]);
				playerInfo[TaxiAcceptedCall[playerid]][pCheckpoint] = CHECKPOINT_NONE;
				playerInfo[TaxiAcceptedCall[playerid]][pCheckpointID] = -1;
			}
		}
	}
	if(playerInfo[playerid][pTaxiDriver] != -1) {
		if(playerInfo[playerid][pTaxiMoney] != 0) {
			addRaportPoint(playerid);					
			sendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "%s a platit taximetristului %s suma de $%s pentru cursa efectuata.", getName(playerid), getName(playerInfo[playerid][pTaxiDriver]), formatNumber(playerInfo[playerid][pTaxiMoney]));
			playerInfo[playerid][pTaxiMoney] = 0;
		}
		playerInfo[playerid][pTaxiDriver] = -1;
		PlayerTextDrawHide(playerid, fareTD[playerid]);
		stop taxi[playerid];
	}
	return true;
}

hook OnPlayerEnterCheckpoint(playerid) {
	if(!Iter_Contains(FactionMembers[1], playerid)) return Y_HOOKS_CONTINUE_RETURN_1;
	switch(playerInfo[playerid][pCheckpoint]) {
		case CHECKPOINT_FACTION_DUTY: {
			if(MedicAcceptedCall[playerid] != -1) {
				MedicAcceptedCall[MedicAcceptedCall[playerid]] = -1;
				MedicAcceptedCall[playerid] = -1;
				DisablePlayerCheckpoint(playerid);
				playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;		
				playerInfo[playerid][pCheckpointID] = -1;
				SCM(playerid, COLOR_GREY, "* Ai ajuns la destinatie.");
			}
			if(TaxiAcceptedCall[playerid] != -1) {
				TaxiAcceptedCall[TaxiAcceptedCall[playerid]] = -1;
				TaxiAcceptedCall[playerid] = -1;
				DisablePlayerCheckpoint(playerid);
				playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;		
				playerInfo[playerid][pCheckpointID] = -1;	
				SCM(playerid, COLOR_GREY, "* Ai ajuns la destinatie.");
			}		
		}
		case CHECKPOINT_WANTEDFIND: {	
			DisablePlayerCheckpoint(playerid);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;		
			playerInfo[playerid][pCheckpointID] = -1;	
			stop wantedFind[playerid];
			SCM(playerid, COLOR_GREY, "* Ai ajuns la destinatie.");
		}
		case CHECKPOINT_GETHIT: {
			DisablePlayerCheckpoint(playerid);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			stop getHit[playerid];
			SCM(playerid, COLOR_GREY, "* Ai ajuns la jucatorul pe care ai contract.");
		}
	}
	return true;
}

Dialog:DIALOG_WANTEDS(playerid, response) {
	if(!response) return true;
	new id = playerInfo[playerid][pSelectedItem];
	if(playerInfo[id][pWantedLevel] == 0) return sendPlayerError(playerid, "Acel player nu mai are wanted.");
	new Float:x, Float:y, Float:z, zone[32];
	GetPlayerPos(id, x, y, z);
	SetPlayerCheckpoint(playerid, x, y, z, 3.5);
	Get3DZone(x, y, z, zone, 32);
	playerInfo[playerid][pCheckpoint] = CHECKPOINT_WANTEDFIND;
	playerInfo[playerid][pCheckpointID] = id;
	wantedFind[playerid] = repeat TimersWantedFind(playerid);
	SCMf(playerid, COLOR_GREY, "*- Ti-a fost setat un checkpoint pe %s (%d) care se afla in zona %s. -*", getName(id), id, zone);
	playerInfo[playerid][pSelectedItem] = -1;
	return true;
}

stock wantedName(playerid) {
	gString[0] = (EOS);
	switch(playerInfo[playerid][pWantedLevel]) {
		case 1: gString = "Attack Civil";
		case 2:	gString = "Kill Civil";
		case 3:	gString = "Neconformare Ordin"; 
		case 4:	gString = "Kill Cop";
		case 5:	gString = "Kamikaze";
		case 6:	gString = "Runner/Robber";
		default: gString = "None";
	}
	return gString;
}

function showMDC(playerid, targetid) {
	if(playerInfo[targetid][pWantedLevel] == 0) return sendPlayerError(playerid, "Acel player nu are wanted.");
	playerInfo[playerid][pMDCon] = targetid;
	SCM(playerid, COLOR_GREY, "*------------------------------------------- Police MDC -------------------------------------------*");	
	SCMf(playerid, COLOR_GREY, "Name: %s (%d) | Wanted Level: %d | Wanted Time: %d minutes | Chased by: %d cops.", getName(targetid), targetid, playerInfo[targetid][pWantedLevel], playerInfo[targetid][pWantedTime]/60, chasedBy(targetid));
	SCMf(playerid, COLOR_GREY, "Reason: %s.", wantedName(targetid));			
	SCM(playerid, COLOR_GREY, "*------------------------------------------- Police MDC -------------------------------------------*");
	return true;
}

function chasedBy(playerid) {
	new x;
	foreach(new i : Wanteds) {
		if(playerInfo[i][pMDCon] == playerid && playerInfo[i][pCheckpointID] == playerid) x++;
	}
	return x;
}

function LoadFactions() {
	if(!cache_num_rows()) return print("Factions: 0 [From Database]");
	for(new i = 1, j = cache_num_rows() + 1; i != j; i++) {	
		cache_get_value_name_int(i - 1, "ID", factionInfo[i][fID]);
		cache_get_value_name_int(i - 1, "MinLevel", factionInfo[i][fMinLevel]);
		cache_get_value_name_int(i - 1, "MaxMembers", factionInfo[i][fMaxMembers]);
		cache_get_value_name_int(i - 1, "Interior", factionInfo[i][fInterior]);
		cache_get_value_name_int(i - 1, "Type", factionInfo[i][fType]);
		cache_get_value_name_int(i - 1, "MapIconType", factionInfo[i][fMapIconType]);
		cache_get_value_name_int(i - 1, "Apps", factionInfo[i][fApps]);
		cache_get_value_name_int(i - 1, "Locked", factionInfo[i][fLocked]);
		cache_get_value_name(i - 1, "Name", factionInfo[i][fName]);
		cache_get_value_name(i - 1, "Motd", factionInfo[i][fMotd]);
		cache_get_value_name_float(i - 1, "X", factionInfo[i][fEnterX]);
		cache_get_value_name_float(i - 1, "Y", factionInfo[i][fEnterY]);
		cache_get_value_name_float(i - 1, "Z", factionInfo[i][fEnterZ]);
		cache_get_value_name_float(i - 1, "ExtX", factionInfo[i][fExitX]);
		cache_get_value_name_float(i - 1, "ExtY", factionInfo[i][fExitY]);
		cache_get_value_name_float(i - 1, "ExtZ", factionInfo[i][fExitZ]);
		cache_get_value_name_int(i - 1, "SkinRank1", fSkins[factionInfo[i][fID]][2]);
		cache_get_value_name_int(i - 1, "SkinRank2", fSkins[factionInfo[i][fID]][2]);
		cache_get_value_name_int(i - 1, "SkinRank3", fSkins[factionInfo[i][fID]][3]);
		cache_get_value_name_int(i - 1, "SkinRank4", fSkins[factionInfo[i][fID]][4]);
		cache_get_value_name_int(i - 1, "SkinRank5", fSkins[factionInfo[i][fID]][5]);
		cache_get_value_name_int(i - 1, "SkinRank6", fSkins[factionInfo[i][fID]][6]);
		cache_get_value_name_int(i - 1, "SkinRank7", fSkins[factionInfo[i][fID]][7]);
		cache_get_value_name_int(i - 1, "Commands1", factionInfo[i][fCommands][0]);
		cache_get_value_name_int(i - 1, "Commands2", factionInfo[i][fCommands][1]);
		cache_get_value_name_int(i - 1, "Commands3", factionInfo[i][fCommands][2]);
		cache_get_value_name_int(i - 1, "Commands4", factionInfo[i][fCommands][3]);
		cache_get_value_name_int(i - 1, "Commands5", factionInfo[i][fCommands][4]);
		cache_get_value_name_int(i - 1, "Commands6", factionInfo[i][fCommands][6]);
		cache_get_value_name_int(i - 1, "Commands7", factionInfo[i][fCommands][7]);

		Iter_Add(ServerFactions, i);

		factionInfo[i][fText] = CreateDynamic3DTextLabel(string_fast("Faction ID: %d\nFaction Name: %s\nFaction Locked: %s", factionInfo[i][fID], factionInfo[i][fName], factionInfo[i][fLocked] ? "Yes" : "No"), 0x2b8fa6FF, factionInfo[i][fEnterX],factionInfo[i][fEnterY], factionInfo[i][fEnterZ], 25.0, 0xFFFF, 0xFFFF, 0, 0, 0, -1, STREAMER_3D_TEXT_LABEL_SD);
		factionInfo[i][fPickup] = CreateDynamicPickup(1314, 1, factionInfo[i][fEnterX],factionInfo[i][fEnterY], factionInfo[i][fEnterZ], 0, 0, -1, STREAMER_PICKUP_SD);
		PickInfo[factionInfo[i][fPickup]][FACTION] = i;
		if(factionInfo[i][fMapIconType]) {
			factionInfo[i][fMapIcon] = CreateDynamicMapIcon(factionInfo[i][fEnterX],factionInfo[i][fEnterY], factionInfo[i][fEnterZ], factionInfo[i][fMapIconType], -1, 0, 0, -1, 1000.0);
		}
	}
	return printf("Factions: %d [From Database]", Iter_Count(ServerFactions));
}

function whenPlayerLeaveFaction(playerid) {
	playerInfo[playerid][pSkin] = 250;
	playerInfo[playerid][pSpawnChange] = 1;
	SetPlayerSkin(playerid, 250);
	update("UPDATE `server_users` SET `Skin` = '250', `SpawnChange` = '1' WHERE `ID` = '%d'", playerInfo[playerid][pSQLID]);
	SpawnPlayer(playerid);
	return true;
}


function sendPolice(type, playerid, accusedid, wantedlevel, reason[]) {
	switch(type) {
		case 1: { // wanted
			sendFactionMessage(2, COLOR_LIGHTRED, "* Dispatch Police: %s a acordat wanted lui %s, wanted level %d. Motiv: %s. *", getName(playerid), getName(accusedid), wantedlevel, wantedName(accusedid));
			sendFactionMessage(3, COLOR_LIGHTRED, "* Dispatch Police: %s a acordat wanted lui %s, wanted level %d. Motiv: %s. *", getName(playerid), getName(accusedid), wantedlevel, wantedName(accusedid));
			sendFactionMessage(4, COLOR_LIGHTRED, "* Dispatch Police: %s a acordat wanted lui %s, wanted level %d. Motiv: %s. *", getName(playerid), getName(accusedid), wantedlevel, wantedName(accusedid));
		}
		case 2: { // clear
			sendFactionMessage(2, COLOR_LIGHTRED, "* Dispatch Police: %s a acordat clear lui %s, wanted level %d. Motiv: %s. *", getName(playerid), getName(accusedid), wantedlevel, reason);
			sendFactionMessage(3, COLOR_LIGHTRED, "* Dispatch Police: %s a acordat clear lui %s, wanted level %d. Motiv: %s. *", getName(playerid), getName(accusedid), wantedlevel, reason);
			sendFactionMessage(4, COLOR_LIGHTRED, "* Dispatch Police: %s a acordat clear lui %s, wanted level %d. Motiv: %s. *", getName(playerid), getName(accusedid), wantedlevel, reason);	
		} 
		case 3: { // lost wanted
			sendFactionMessage(2, COLOR_LIGHTRED, "* Dispatch Police: %s a pierdut un nivel de wanted. Wanted actual: %d.*", getName(accusedid), wantedlevel);
			sendFactionMessage(3, COLOR_LIGHTRED, "* Dispatch Police: %s a pierdut un nivel de wanted. Wanted actual: %d.*", getName(accusedid), wantedlevel);
			sendFactionMessage(4, COLOR_LIGHTRED, "* Dispatch Police: %s a pierdut un nivel de wanted. Wanted actual: %d.*", getName(accusedid), wantedlevel);
		}
		case 4: { // call 112

		}
	}
	return true;
}

stock GetPlayerCityLocation(playerid)
{
	new city[7 + 1] = "Unknown";

	if(IsPlayerInArea(playerid, 44.60, -2892.90, 2997.00, -768.00)) city = "LS";
	else if(IsPlayerInArea(playerid, 869.40, 596.30, 2997.00, 2993.80)) city = "LV";
	else if(IsPlayerInArea(playerid, -2997.40, -1115.50, -1213.90, 1659.60)) city = "SF";
	return city;
}

stock SetPlayerToFactionColor(playerid) {
	if(!IsPlayerConnected(playerid)) return false;
	switch(playerInfo[playerid][pFaction]) {
		case 1: return SetPlayerColor(playerid, 0xF29D9DFF);
		case 2: return SetPlayerColor(playerid, 0x3456d1FF);
		case 3: return SetPlayerColor(playerid, 0x285dadFF);
		case 4: return SetPlayerColor(playerid, 0x2133d9FF);
		case 5: return SetPlayerColor(playerid, COLOR_YELLOW);
		case 6: return SetPlayerColor(playerid, COLOR_LIGHTGREEN);
		case 7: return SetPlayerColor(playerid, COLOR_PURPLE);
		case 8: return SetPlayerColor(playerid, COLOR_LAWNGREEN);
		case 9: return SetPlayerColor(playerid, COLOR_PURPLE2);
		case 10: return SetPlayerColor(playerid, COLOR_RED);
		default: return SetPlayerColor(playerid, COLOR_WHITE);
	}
	return true;
}

stock sendFactionMessage(fid, color, const message[], va_args<>) {
	if(!Iter_Contains(ServerFactions, fid) || !Iter_Count(FactionMembers[fid], playerid)) return false;
	gString[0] = (EOS);
	va_format(gString, 256, message, va_start<3>);			
	foreach(new i : ServerAdmins) if(playerInfo[i][pspecFaction] == fid) sendSplitMessage(i, color, gString);
	foreach(new id : FactionMembers[fid]) sendSplitMessage(id, color, gString);
	return true;
}

CMD:factions(playerid, params[]) {
	if(!Iter_Count(ServerFactions)) return sendPlayerError(playerid, "Nu sunt factiuni disponibile pe server.");
	new string[456] = "Faction Name\tFaction Applications\tFaction Min. Level\n";
	foreach(new fid : ServerFactions) {
		format(string, sizeof(string), "%s\n{FFFFFF}%s\t%s\t%d", string, factionName(fid), factionInfo[fid][fApps] ? "{4caf50}On" : "{f44336}Off", factionInfo[fid][fMinLevel]);
	}
	Dialog_Show(playerid, NO_DIALOG, DIALOG_STYLE_TABLIST_HEADERS, "Server: Factions", string, "Close", "");
	return true;
}

CMD:gotofaction(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(isnull(params) || !IsNumeric(params)) return sendPlayerSyntax(playerid, "/gotofaction <faction id>");
	new fid = strval(params);
	if(!Iter_Contains(ServerFactions, fid)) return sendPlayerError(playerid, "Invalid faction id.");
	SetPlayerPos(playerid, factionInfo[fid][fEnterX],factionInfo[fid][fEnterY], factionInfo[fid][fEnterZ]);
	SetPlayerVirtualWorld(playerid, 0);
	SetPlayerInterior(playerid, 0);
	playerInfo[playerid][pinFaction] = 0;		
	return SCMf(playerid, COLOR_GREY, "* Goto Notice: Te-ai teleportat la factiunea %s.", factionName(fid));
}

CMD:makeleader(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 4) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	extract params -> new player:targetid, fid; else return sendPlayerSyntax(playerid, "/makeleader <name/id> <faction id>");
	if(!Iter_Contains(ServerFactions, fid)) return sendPlayerError(playerid, "Invalid faction id.");
	if(!isPlayerLogged(targetid)) return sendPlayerError(playerid, "Player not connected.");
	if(playerInfo[playerid][pFaction] > 0) return sendPlayerError(playerid, "Player has in a faction.");
	playerInfo[targetid][pFaction] = fid;
	playerInfo[targetid][pFactionRank] = 7;
	playerInfo[targetid][pFactionAge] = 0;
	playerInfo[targetid][pFactionWarns] = 0;
	playerInfo[targetid][pSkin] = fSkins[playerInfo[playerid][pFaction]][playerInfo[targetid][pFactionRank]];
	playerInfo[targetid][pSpawnChange] = 4;
	SetPlayerSkin(targetid, playerInfo[playerid][pSkin]);
	SpawnPlayer(targetid);
	update("UPDATE `server_users` SET `Faction` = '%d', `FRank` = '7', `FAge` = '%d', `FWarns` = '0', `SpawnChange` = '4', `Skin` = '%d' WHERE `ID` = '%d'", playerInfo[targetid][pFaction], playerInfo[targetid][pFactionAge], playerInfo[targetid][pSkin], playerInfo[targetid][pSQLID]);
	Iter_Add(FactionMembers[fid], targetid);
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s i-a setat lui %s lider la factiunea %s.", getName(playerid), getName(targetid), factionName(fid));
	SCMf(targetid, COLOR_YELLOW, "* Admin %s te-a promovat lider la factiunea %s.", getName(playerid), factionName(fid));
	return true;
}

CMD:auninvite(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 4) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	extract params -> new player: targetid, fp; else return sendPlayerSyntax(playerid, "/auninvite <name/id> <faction punish>");
	if(!isPlayerLogged(targetid)) return sendPlayerError(playerid, "Player not connected.");
	if(playerInfo[targetid][pFaction] == 0) return sendPlayerError(playerid, "Player was not in a faction.");
	if(!(0 <= fp <= 90)) return sendPlayerError(playerid, "Invalid faction punish.");
	new fid = playerInfo[targetid][pFaction];
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s l-a demis pe %s din factiunea %s (rank %d, %d zile) cu %d fp.", getName(playerid), getName(targetid), factionName(fid), playerInfo[targetid][pFactionRank], playerInfo[targetid][pFactionAge], fp);
	if(playerVehicle[targetid] != -1) {
		DestroyVehicle(playerVehicle[targetid]); 
		vehicleFaction[playerVehicle[targetid]] = 0;  
		vehiclePlayerID[playerVehicle[targetid]] = -1;
		vehicleRank[playerVehicle[targetid]] = 0;
		playerVehicle[targetid] = -1;
	}
	Iter_Remove(FactionMembers[playerInfo[targetid][pFaction]], targetid);
	playerInfo[targetid][pSpawnChange] = 1;
	playerInfo[targetid][pFaction] = 0;
	playerInfo[targetid][pFactionRank] = 0;
	playerInfo[targetid][pFactionAge] = 0;
	playerInfo[targetid][pFactionWarns] = 0;	
	playerInfo[targetid][pFactionPunish] = fp;
	if(playerInfo[playerid][pFactionDuty]) playerInfo[playerid][pFactionDuty] = 0;
	update("UPDATE `server_users` SET `Faction` = '0', `FRank` = '7', `FAge` = '0', `FWarns` = '0', `FPunish` = '%d' WHERE `ID` = '%d'", playerInfo[targetid][pFactionPunish], playerInfo[targetid][pSQLID]);
	whenPlayerLeaveFaction(targetid);
	return SCMf(targetid, COLOR_YELLOW, "* Admin %s te-a demis din factiunea %s cu %d faction punish.", getName(playerid), factionName(fid), fp);
}

CMD:flock(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 4) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(isnull(params) || !IsNumeric(params)) return sendPlayerSyntax(playerid, "/flock <faction id>");
	new fid = strval(params);
	if(!Iter_Contains(ServerFactions, fid)) return sendPlayerError(playerid, "Invalid faction id.");
	factionInfo[fid][fLocked] = !factionInfo[fid][fLocked];
	return UpdateDynamic3DTextLabelText(factionInfo[fid][fText], -1, string_fast("Faction ID: %d\nFaction Name: %s\nFaction Locked: %s", factionInfo[fid][fID], factionName(fid), factionInfo[fid][fLocked] ? "Yes" : "No"));
}

CMD:fapps(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 4) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(isnull(params) || !IsNumeric(params)) return sendPlayerSyntax(playerid, "/fapps <faction id>");	
	new fid = strval(params);
	if(!Iter_Contains(ServerFactions, fid)) return sendPlayerError(playerid, "Invalid faction id.");
	factionInfo[fid][fApps] = !factionInfo[fid][fApps];
	return true;
}

CMD:fspec(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 4) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(isnull(params) || !IsNumeric(params)) return sendPlayerSyntax(playerid, "/fspec <faction id>");	
	if(!Iter_Contains(ServerFactions, strval(params))) return sendPlayerError(playerid, "Invalid faction id.");
	if(Iter_Contains(FactionMembers[strval(params)], playerid)) return sendPlayerError(playerid, "You are already in the faction in which you want to give spec.");
	playerInfo[playerid][pspecFaction] = strval(params);
	sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}Admin %s este spec pe factiunea %s.", getName(playerid), factionName(strval(params)));
	return true;
}

CMD:blockf(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0) return sendPlayerError(playerid, "Nu ai vreo factiune.");
	if(playerInfo[playerid][pFactionRank] < 6) return sendPlayerError(playerid, "Nu ai rank 6, pentru a folosi aceasta comanda.");
	switch(factionChat[playerInfo[playerid][pFaction]]) {
		case 0: factionChat[playerInfo[playerid][pFaction]] = 1;
		case 1: factionChat[playerInfo[playerid][pFaction]] = 0;
	}
	sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "(-) %s a %s chatul factiunii.", getName(playerid), factionChat[playerInfo[playerid][pFaction]] ? "activat" : "dezactivat");
	return true;
}

CMD:f(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0) return sendPlayerError(playerid, "Nu ai vreo factiune.");
	if(factionChat[playerInfo[playerid][pFaction]] == 1 && playerInfo[playerid][pFactionRank] < 6) return sendPlayerError(playerid, "Chatul factiunii a fost oprit.");
	if(Iter_Contains(FactionMembers[2], playerid) || Iter_Contains(FactionMembers[3], playerid) || Iter_Contains(FactionMembers[4], playerid)) return sendPlayerError(playerid, "Pentru a scrie pe chatul factiunii, foloseste comanda '/r'");
	extract params -> new string:result[250]; else return sendPlayerSyntax(playerid, "/f <text>");
	if(faceReclama(result)) return removeFunction(playerid, result);
    if(faceReclama(result)) return Reclama(playerid, result);
	if(playerInfo[playerid][pspecFaction] != 0) {
		sendFactionMessage(playerInfo[playerid][pspecFaction], COLOR_LIMEGREEN, "* Admin %s: %s", getName(playerid), result);		
		return true;
	}		
	sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "* (%d) %s: %s", playerInfo[playerid][pFactionRank], getName(playerid), result);
	return true;
}

CMD:r(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0) return sendPlayerError(playerid, "Nu ai vreo factiune.");
	if(Iter_Contains(FactionMembers[1], playerid) || Iter_Contains(FactionMembers[5], playerid) || Iter_Contains(FactionMembers[6], playerid) || Iter_Contains(FactionMembers[7], playerid) || Iter_Contains(FactionMembers[8], playerid) || Iter_Contains(FactionMembers[9], playerid) || Iter_Contains(FactionMembers[10], playerid)) return sendPlayerError(playerid, "Pentru a scrie pe chatul factiunii, foloseste comanda '/f'");
	if(factionChat[playerInfo[playerid][pFaction]] == 1 && playerInfo[playerid][pFactionRank] < 6) return sendPlayerError(playerid, "Chatul factiunii a fost oprit.");
	extract params -> new string:result[250]; else return sendPlayerSyntax(playerid, "/r <text>");
	if(faceReclama(result)) return removeFunction(playerid, result);
    if(faceReclama(result)) return Reclama(playerid, result);
	if(playerInfo[playerid][pspecFaction] != 0) {
		sendFactionMessage(playerInfo[playerid][pspecFaction], COLOR_LAWNGREEN, "* Admin %s: %s, over", getName(playerid), result);		
		return true;
	}		
	sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LAWNGREEN, "* (%d) %s: %s, over", playerInfo[playerid][pFactionRank], getName(playerid), result);
	return true;
}

CMD:d(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0 || playerInfo[playerid][pAdmin] == 0) return sendPlayerError(playerid, "Nu ai vreo factiune.");
	if(Iter_Contains(FactionMembers[1], playerid) || Iter_Contains(FactionMembers[5], playerid) || Iter_Contains(FactionMembers[6], playerid) || Iter_Contains(FactionMembers[7], playerid) || Iter_Contains(FactionMembers[8], playerid)) return sendPlayerError(playerid, "Pentru a folosi aceasta comanda, trebuie sa fii intr-un departament.");
	extract params -> new string:result[250]; else return sendPlayerSyntax(playerid, "/d <text>");
	if(faceReclama(result)) return removeFunction(playerid, result);
    if(faceReclama(result)) return Reclama(playerid, result);
	sendFactionMessage(1, COLOR_LIGHTRED, "* (%s) %s: %s, over", factionName(playerInfo[playerid][pFaction]), getName(playerid), result);
	sendFactionMessage(2, COLOR_LIGHTRED, "* (%s) %s: %s, over", factionName(playerInfo[playerid][pFaction]), getName(playerid), result);
	sendFactionMessage(3, COLOR_LIGHTRED, "* (%s) %s: %s, over", factionName(playerInfo[playerid][pFaction]), getName(playerid), result);
	if(playerInfo[playerid][pAdmin]) sendToAdmin(playerid, COLOR_LIGHTRED, "* Admin %s: %s, over", getName(playerid), result);
	SetPlayerChatBubble(playerid, string_fast("'%s'", result), COLOR_WHITE, 25.0, 5000);
	return true;
}

CMD:heal(playerid, params[]) {
	if(playerInfo[playerid][pinHouse]) {
		if(houseInfo[playerInfo[playerid][pinHouse]][hUpgrade] == 1) SetPlayerHealthEx(playerid, 100);
	}
	if(playerInfo[playerid][pinFaction] == playerInfo[playerid][pFaction]) SetPlayerHealthEx(playerid, 100);
	if(!Iter_Contains(FactionMembers[1], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'Paramedic Department' pentru a folosi aceasta comanda.");
	extract params -> new player:targetid, money; else return sendPlayerSyntax(playerid, "/heal <name/id> <money>");
	if(!(1 <= money <= 500)) return sendPlayerError(playerid, "Invalid money (1$ - 500$).");
	if(vehicleFaction[GetPlayerVehicleID(playerid)] != playerInfo[playerid][pFaction]) return sendPlayerError(playerid, "You are not in a vehicle of your faction.");
	if(!isPlayerLogged(targetid)) return sendPlayerError(playerid, "Player not connected.");
	if(!IsPlayerInVehicle(targetid, GetPlayerVehicleID(playerid))) return sendPlayerError(playerid, "Player is not in your car.");
	if(GetPlayerCash(targetid) < money) return sendPlayerError(playerid, "Player does dosen't have this money");
	if(playerid == targetid) return sendPlayerError(playerid, "Invalid player id.");
	if(playerInfo[targetid][pHealth] >= 95.00) return sendPlayerError(playerid, "Player has enough health.");
	if(playerInfo[targetid][pAFKSeconds] > 0) return sendPlayerError(playerid, "Player is AFK.");
	SetPlayerHealthEx(targetid, 100.00);
	GameTextForPlayer(targetid, string_fast("~r~-$%d", money), 10, 1);
	GameTextForPlayer(playerid, string_fast("~g~+$%d", money), 10, 1);
	GivePlayerCash(targetid, 0, money);
	GivePlayerCash(playerid, 1, money);
	addRaportPoint(playerid);
	update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d' WHERE `ID` = '%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSQLID]);
	update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d' WHERE `ID` = '%d'", MoneyMoney[targetid], StoreMoney[targetid], playerInfo[targetid][pSQLID]);
	SCMf(playerid, -1, "{FF6347}(Paramedic): {FFFFFF}You healed %s for $%s.", getName(targetid), formatNumber(money));
	SCMf(targetid, -1, "{FF6347}(Paramedic %s): {FFFFFF}You receoved health for $%s.", getName(playerid), formatNumber(money));
	return true;
}

CMD:service(playerid, params[]) {
	if(strmatch(params, "medic")) {
		if(Iter_Contains(FactionMembers[1], playerid)) return sendPlayerError(playerid, "You are in 'Paramedic Department' you can't use this command.");
		if(Iter_Contains(ServiceCalls[SERVICE_PARAMEDICS], playerid) || MedicAcceptedCall[playerid] != 0) return sendPlayerError(playerid, "You already have a call for medics.");
		new MapZone:zoneid = GetPlayerMapZone(playerid), zonename[27] = "Unknown";
		if(IsValidMapZone(zoneid)) GetMapZoneName(zoneid, zonename, 27);
		sendFactionMessage(1, COLOR_LIMEGREEN, "(*) %s are nevoie de un medic locatie: %s (%s), scrie /accept medic %d pentru a accepta.", getName(playerid), zonename, GetPlayerCityLocation(playerid), playerid);
		SCMf(playerid, -1, "{FF6347}(Paramedic Call): {FFFFFF}Your call has been sent please wait an answer.");
		Iter_Add(ServiceCalls[SERVICE_PARAMEDICS], playerid);
		return true;
	}
	if(strmatch(params, "taxi")) {
		if(Iter_Contains(FactionMembers[5], playerid)) return sendPlayerError(playerid, "You are in 'Taxi Company' you can't use this command.");
		if(Iter_Contains(ServiceCalls[SERVICE_TAXI], playerid) || TaxiAcceptedCall[playerid] != 0) return sendPlayerError(playerid, "You already have a call for taxi.");
		new MapZone:zoneid = GetPlayerMapZone(playerid), zonename[27] = "Unknown";
		if(IsValidMapZone(zoneid)) GetMapZoneName(zoneid, zonename, 27);
		sendFactionMessage(5, COLOR_LIMEGREEN, "(*) %s are nevoie de un taxi locatie: %s (%s), scrie /accept taxi %d pentru a accepta.", getName(playerid), zonename, GetPlayerCityLocation(playerid), playerid);
		SCMf(playerid, -1, "{FF6347}(Taxi Call): {FFFFFF}Your call has been sent please wait an answer.");
		Iter_Add(ServiceCalls[SERVICE_TAXI], playerid);
		return true;	
	}
	if(strmatch(params, "instructor")) {
		if(Iter_Contains(FactionMembers[7], playerid)) return sendPlayerError(playerid, "You are in 'School Instructors' you can't use this command.");
		if(Iter_Contains(ServiceCalls[SERVICE_INSTRUCTOR], playerid) || InstructorAcceptedCall[playerid] != 0) return sendPlayerError(playerid, "You already have a call for taxi.");
		new MapZone:zoneid = GetPlayerMapZone(playerid), zonename[27] = "Unknown";
		if(IsValidMapZone(zoneid)) GetMapZoneName(zoneid, zonename, 27);
		sendFactionMessage(7, COLOR_LIMEGREEN, "(*) %s are nevoie de un instructor locatie: %s (%s), scrie /accept instructor %d pentru a accepta.", getName(playerid), zonename, GetPlayerCityLocation(playerid), playerid);
		SCMf(playerid, -1, "{FF6347}(Instructor Call): {FFFFFF}Your call has been sent please wait an answer.");
		Iter_Add(ServiceCalls[SERVICE_INSTRUCTOR], playerid);
		return true;	
	}	
	sendPlayerSyntax(playerid, "/service <medic/taxi/instructor>");
	return true;
}

CMD:duty(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0 && Iter_Contains(FactionMembers[1], playerid) || Iter_Contains(FactionMembers[5], playerid) || Iter_Contains(FactionMembers[6], playerid) || Iter_Contains(FactionMembers[7], playerid) || Iter_Contains(FactionMembers[8], playerid)) return sendPlayerError(playerid, "Aceasta comanda, nu este valabila pentru tine.");
	if(GetPVarInt(playerid, "dutyDeelay") >= gettime()) return true;
	if(!playerInfo[playerid][pinFaction]) return sendPlayerError(playerid, "Nu esti in HQ-ul factiunii pentru a folosi aceasta comanda.");
	if(playerInfo[playerid][pWeaponLicense] == 0) return sendPlayerError(playerid, "Nu ai licenta de arme, pentru a folosi aceasta comanda.");
	switch(playerInfo[playerid][pFactionDuty]) {
		case 0: {
			SetPlayerToFactionColor(playerid);
			playerInfo[playerid][pFactionDuty] = 1;
			serverWeapon(playerid, 24, 500);
			serverWeapon(playerid, 3, 0);
			serverWeapon(playerid, 41, 500);
			serverWeapon(playerid, 29, 1000);
			serverWeapon(playerid, 31, 1000);
			SetPlayerArmourEx(playerid, 100);
			SetPlayerHealthEx(playerid, 100);	
			SetPVarInt(playerid, "dutyDeelay", gettime() + 5);
			sendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "%s si-a luat armele in vestiar.", getName(playerid));
		}	
		case 1: {
			playerInfo[playerid][pFactionDuty] = 0;
			resetWeapons(playerid);
			SetPlayerArmourEx(playerid, 0);
			SetPlayerHealthEx(playerid, 100);
			SetPlayerToFactionColor(playerid);
			SetPlayerSkin(playerid, playerInfo[playerid][pSkin]);
			SetPVarInt(playerid, "dutyDeelay", gettime() + 5);
			sendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "%s si-a pus armele in vestiar.", getName(playerid));
		}
	}
	return true;
}

CMD:invite(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat.");
	if(playerInfo[playerid][pFaction] == 0) return sendPlayerError(playerid, "Nu ai o factiune.");
	if(playerInfo[playerid][pFactionRank] < 6) return sendPlayerError(playerid, "Nu ai rank-ul necesar pentru a folosi aceasta comanda.");
	if(invitedPlayer[playerid] > -1) return sendPlayerError(playerid, "Ai invitat deja acest player la tine in factiune.");
	if(GetPVarInt(playerid, "inviteDeelay") >= gettime()) return true;
	extract params -> new player:userID, string:reason[32]; else return sendPlayerSyntax(playerid, "/invite <name/id> <reason>");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este logat.");
	if(playerInfo[userID][pFaction] > 0) return sendPlayerError(playerid, "Acel player are deja o factiune.");
	invitedPlayer[playerid] = userID;
	invitedByPlayer[userID] = playerid;
	gString[0] = (EOS);
	va_format(gString, sizeof(gString), "{32CD32}*{ffffff} Ai invitat pe {32CD32}'%s'{ffffff} (%d) in factiunea ta {32CD32}'%s'{ffffff}. Motiv: %s.", getName(userID), userID, factionName(playerInfo[playerid][pFaction]), reason);
	sendSplitMessage(playerid, COLOR_WHITE, gString);
	SCMf(userID, COLOR_WHITE, "{32CD32}*{ffffff} Ai fost invitat de {32CD32}'%s'{ffffff} (%d) in factiunea lui {32CD32}'%s'{ffffff}. Motiv: %s.", getName(playerid), playerid, factionName(playerInfo[playerid][pFaction]), reason);
	SCMf(userID, COLOR_WHITE, "{32CD32}*{ffffff} Pentru a accepta invitatia tasteaza /accept invite %d.", playerid);
	SetPVarInt(playerid, "inviteDeelay", gettime() + 5);
	return true;
}

CMD:so(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0 && Iter_Contains(FactionMembers[1], playerid) || Iter_Contains(FactionMembers[5], playerid) || Iter_Contains(FactionMembers[6], playerid) || Iter_Contains(FactionMembers[7], playerid) || Iter_Contains(FactionMembers[8], playerid)) return sendPlayerError(playerid, "Aceasta comanda, nu este valabila pentru tine.");if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
	if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
	extract params -> new player:userID; else return sendPlayerSyntax(playerid, "/so <name/id>");
	if(GetPVarInt(playerid, "soDeelay") >= gettime()) return true;
	if(!ProxDetectorS(30.0, playerid, userID)) return sendPlayerError(playerid, "Acel player nu se afla in raza ta.");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este conncetat.");
	if(Iter_Contains(FactionMembers[2], userID) || Iter_Contains(FactionMembers[3], userID) || Iter_Contains(FactionMembers[4], userID)) return sendPlayerError(playerid, "Nu poti avertiza un coleg.");
	sendNearbyMessage(playerid, COLOR_YELLOW, 30.0, "*- %s: %s esti cautat de politie, te rugam sa te tragi pe dreapta ! -*", getName(playerid), getName(userID));
	SetPVarInt(playerid, "soDeelay", gettime() + 5);
	return true;	
}

CMD:megaphone(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0 && Iter_Contains(FactionMembers[1], playerid) || Iter_Contains(FactionMembers[5], playerid) || Iter_Contains(FactionMembers[6], playerid) || Iter_Contains(FactionMembers[7], playerid) || Iter_Contains(FactionMembers[8], playerid)) return sendPlayerError(playerid, "Aceasta comanda, nu este valabila pentru tine.");if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
	if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
	extract params -> new string:text[32]; else return sendPlayerSyntax(playerid, "/megaphone <text>");
	if(strlen(text) < 1 || strlen(text) > 32) return sendPlayerError(playerid, "Text invalid, min. 1 caracter max. 32 caractere.");
	if(faceReclama(text)) return removeFunction(playerid, text);
    if(faceReclama(text)) return Reclama(playerid, text);
	sendNearbyMessage(playerid, COLOR_YELLOW, 75.0, "*- %s: %s. -*", getName(playerid), text);
	return true;
}

CMD:frisk(playerid, params[])  {
	if(playerInfo[playerid][pFaction] == 0 && Iter_Contains(FactionMembers[1], playerid) || Iter_Contains(FactionMembers[5], playerid) || Iter_Contains(FactionMembers[6], playerid) || Iter_Contains(FactionMembers[7], playerid) || Iter_Contains(FactionMembers[8], playerid)) return sendPlayerError(playerid, "Aceasta comanda, nu este valabila pentru tine.");if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");	
	if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
	extract params -> new player:userID; else return sendPlayerSyntax(playerid, "/frisk <name/id>");
	if(!ProxDetectorS(8.0, playerid, userID)) return sendPlayerError(playerid, "Acel player nu se afla in raza ta.");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este conncetat.");
	if(Iter_Contains(FactionMembers[2], userID) || Iter_Contains(FactionMembers[3], userID) || Iter_Contains(FactionMembers[4], userID)) return sendPlayerError(playerid, "Nu poti controla un coleg.");
	SCMf(playerid, COLOR_GREY, "* - Lucrurile lui %s (%d) - *", getName(userID), userID);
	SCMf(playerid, COLOR_GREY, "- = Droguri: %s = -\n- = Materiale: %s = -\n", playerInfo[userID][pDrugs] ? (string_fast("%d", playerInfo[userID][pDrugs])) : ("Nu are."), playerInfo[userID][pMats] ? (string_fast("%d", playerInfo[userID][pMats])) : ("Nu are."));
	new Player_Weapons[13], Player_Ammos[13], i;
	for(i = 1;i <= 12;i++) {
		GetPlayerWeaponData(userID,i,Player_Weapons[i],Player_Ammos[i]); 
		if(Player_Weapons[i] != 0) {
			new weaponName[45];
			GetWeaponName(Player_Weapons[i],weaponName,45);
			SCMf(playerid, COLOR_GREY, "* - Arma: %s | Gloante: %d - *", weaponName,Player_Ammos[i]);
		}
	}
	sendNearbyMessage(playerid, COLOR_GREY, 30.0, "*- %s l-a verificat pe %s pentru lucruri ilegale. -*", getName(playerid), getName(userID));
	return true;
}

CMD:cuff(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0 && Iter_Contains(FactionMembers[1], playerid) || Iter_Contains(FactionMembers[5], playerid) || Iter_Contains(FactionMembers[6], playerid) || Iter_Contains(FactionMembers[7], playerid) || Iter_Contains(FactionMembers[8], playerid)) return sendPlayerError(playerid, "Aceasta comanda, nu este valabila pentru tine.");
	if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
	extract params -> new player:userID; else return sendPlayerSyntax(playerid, "/cuff <name/id>");
	if(!ProxDetectorS(8.0, playerid, userID)) return sendPlayerError(playerid, "Acel player nu se afla in raza ta.");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este conncetat.");
	if(playerInfo[userID][pWantedLevel] == 0) return sendPlayerError(playerid, "Acel player nu are wanted.");
	if(Iter_Contains(FactionMembers[2], userID) || Iter_Contains(FactionMembers[3], userID) || Iter_Contains(FactionMembers[4], userID)) return sendPlayerError(playerid, "Nu poti incatusa un coleg.");
	TogglePlayerControllable(userID, 0);
	playerInfo[userID][pCuffed] = 1;
	SetPlayerAttachedObject(userID, 1, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977, -81.700035, 0.891999, 1.000000, 1.168000);
	SetPlayerSpecialAction(userID,SPECIAL_ACTION_CUFFED);
	sendNearbyMessage(playerid, COLOR_GREY, 30.0, "*- %s l-a incatusat pe %s. -*", getName(playerid), getName(userID));
	return true;
}

CMD:uncuff(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0 && Iter_Contains(FactionMembers[1], playerid) || Iter_Contains(FactionMembers[5], playerid) || Iter_Contains(FactionMembers[6], playerid) || Iter_Contains(FactionMembers[7], playerid) || Iter_Contains(FactionMembers[8], playerid)) return sendPlayerError(playerid, "Aceasta comanda, nu este valabila pentru tine.");
	if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
	extract params -> new player:userID; else return sendPlayerSyntax(playerid, "/uncuff <name/id>");
	if(!ProxDetectorS(8.0, playerid, userID)) return sendPlayerError(playerid, "Acel player nu se afla in raza ta.");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este conncetat.");
	if(playerInfo[userID][pCuffed] == 0) return sendPlayerError(playerid, "Acel player nu este incatusat.");
	TogglePlayerControllable(userID, 1);
	playerInfo[userID][pCuffed] = 0;
	SetPlayerSpecialAction(userID,SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(userID,1);
	sendNearbyMessage(playerid, COLOR_GREY, 30.0, "*- %s l-a descatusat pe %s. -*", getName(playerid), getName(userID));
	return true;
}

CMD:tazer(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0 && Iter_Contains(FactionMembers[1], playerid) || Iter_Contains(FactionMembers[5], playerid) || Iter_Contains(FactionMembers[6], playerid) || Iter_Contains(FactionMembers[7], playerid) || Iter_Contains(FactionMembers[8], playerid)) return sendPlayerError(playerid, "Aceasta comanda, nu este valabila pentru tine.");
	if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
	if(GetPlayerWeapon(playerid) != 24) return sendPlayerError(playerid, "Pentru a activa tazer-ul, trebuie sa ai un Desert Eagle in mana.");
	switch(playerInfo[playerid][pTazer]) {
		case 0: {
			playerInfo[playerid][pTazer] = 1;
			sendNearbyMessage(playerid, COLOR_GREY, 30.0, "*- %s si-a echipat tazer-ul. -*", getName(playerid));		
		}
		case 1: {
			playerInfo[playerid][pTazer] = 0;
			SCM(playerid, COLOR_GREY, "*- Tazer off. -*");
		}
	}
	return true;
}

CMD:confiscate(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0 && Iter_Contains(FactionMembers[1], playerid) || Iter_Contains(FactionMembers[5], playerid) || Iter_Contains(FactionMembers[6], playerid) || Iter_Contains(FactionMembers[7], playerid) || Iter_Contains(FactionMembers[8], playerid)) return sendPlayerError(playerid, "Aceasta comanda, nu este valabila pentru tine.");
	if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
	extract params -> new player:userID, string:item[8]; else {
		sendPlayerSyntax(playerid, "/confiscate <name/id> <item>");
		SCM(playerid, COLOR_GREY, "Available items: Driving, Weapons, Drugs.");
		return true;
	}
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este conncetat.");
	if(!ProxDetectorS(8.0, playerid, userID)) return sendPlayerError(playerid, "Acel player nu se afla in raza ta.");
	if(Iter_Contains(FactionMembers[2], userID) || Iter_Contains(FactionMembers[3], userID) || Iter_Contains(FactionMembers[4], userID)) return sendPlayerError(playerid, "Nu poti confisca ceva un coleg.");
	if(IsPlayerInAnyVehicle(userID)) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece jucatorul este in masina.");
	if(strmatch(item, "driving")) {
		if(playerInfo[userID][pDrivingLicense] == 0) return sendPlayerError(playerid, "Acest player nu detine licenta de condus.");
		SCMf(userID, COLOR_GREY, "*- Agent %s ti-a confiscat licenta de condus. -*", getName(userID));
		playerInfo[userID][pDrivingLicense] = 0;
		playerInfo[userID][pDrivingLicenseSuspend] = 2;
		update("UPDATE `server_users` SET `Licenses` = '%d|%d|%d|%d|%d|%d|%d|%d' WHERE `ID` = '%d'", playerInfo[userID][pDrivingLicense], playerInfo[userID][pDrivingLicenseSuspend], playerInfo[userID][pWeaponLicense], playerInfo[userID][pWeaponLicenseSuspend], playerInfo[userID][pFlyLicense], playerInfo[userID][pFlyLicenseSuspend], playerInfo[userID][pBoatLicense], playerInfo[userID][pBoatLicenseSuspend], playerInfo[userID][pSQLID]);	
		addRaportPoint(playerid);
	}
	if(strmatch(item, "weapons")) {
		if(haveWeapons(playerid) == 0) return sendPlayerError(playerid, "Acest player nu are arme.");
		SCMf(userID, COLOR_GREY, "*- Agent %s ti-a confiscat armele. -*", getName(userID));
		resetWeapons(userID);
		addRaportPoint(playerid);
	}
	if(strmatch(item, "drugs")) {
		if(playerInfo[userID][pDrugs] == 0) return sendPlayerError(playerid, "Acest player nu are droguri.");
		SCMf(userID, COLOR_GREY, "*- Agent %s ti-a confiscat drogurile. -*", getName(userID));
		playerInfo[userID][pDrugs] = 0;
		update("UPDATE `server_users` SET `Drugs` = '0' WHERE `ID` = '%d'", playerInfo[userID][pSQLID]);
		addRaportPoint(playerid);
	}
	return true;
}

CMD:ticket(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0 && Iter_Contains(FactionMembers[1], playerid) || Iter_Contains(FactionMembers[5], playerid) || Iter_Contains(FactionMembers[6], playerid) || Iter_Contains(FactionMembers[7], playerid) || Iter_Contains(FactionMembers[8], playerid)) return sendPlayerError(playerid, "Aceasta comanda, nu este valabila pentru tine.");
	if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
	extract params -> new player:userID,  money, string:reason[32]; else return	sendPlayerSyntax(playerid, "/ticket <name/id> <money> <reason>");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este conncetat.");
	if(!ProxDetectorS(8.0, playerid, userID)) return sendPlayerError(playerid, "Acel player nu se afla in raza ta.");
	if(Iter_Contains(FactionMembers[2], userID) || Iter_Contains(FactionMembers[3], userID) || Iter_Contains(FactionMembers[4], userID)) return sendPlayerError(playerid, "Nu poti amenda un coleg.");
	if(IsPlayerInAnyVehicle(userID)) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece jucatorul este in masina.");
	ticketMoney[userID] = money;
	ticketPlayer[playerid] = userID;
	ticketPlayer[userID] = playerid;
	SCMf(userID, COLOR_GREY, "*- Agent %s te amendeaza cu suma %s, motiv: %s. Pentru a plati amenda, tasteaza /accept ticket %d. -*", getName(playerid), formatNumber(money), reason, playerid);
	SCMf(playerid, COLOR_GREY, "*- Il amendezi pe %s cu suma de %s, motiv: %s. -*", getName(userID), formatNumber(money), reason);
	return true;
}

CMD:wanteds(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0 && Iter_Contains(FactionMembers[1], playerid) || Iter_Contains(FactionMembers[5], playerid) || Iter_Contains(FactionMembers[6], playerid) || Iter_Contains(FactionMembers[7], playerid) || Iter_Contains(FactionMembers[8], playerid)) return sendPlayerError(playerid, "Aceasta comanda, nu este valabila pentru tine.");
	if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
	if(Dialog_Opened(playerid)) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece ai un dialog afisat.");
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Trebuie sa fi logat pentru a putea folosi aceasta comanda.");
	if(Iter_Count(Wanteds) == 0) return sendPlayerError(playerid, "Nu sunt suspecti momentan.");
	gString[0] = (EOS);
	foreach(new i : Wanteds) {
		format(gString, 244, "%s (%d)\t%d\t%d cops\n", gString, getName(i), i, playerInfo[i][pWantedLevel], i);
		playerInfo[playerid][pSelectedItem] = i;
	}
	Dialog_Show(playerid, DIALOG_WANTEDS, DIALOG_STYLE_TABLIST_HEADERS, string_fast("Player with Wanted: %d", Iter_Count(Wanteds)), gString, "Ok", "Cancel");
	return true;
}

CMD:mdc(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0 && Iter_Contains(FactionMembers[1], playerid) || Iter_Contains(FactionMembers[5], playerid) || Iter_Contains(FactionMembers[6], playerid) || Iter_Contains(FactionMembers[7], playerid) || Iter_Contains(FactionMembers[8], playerid)) return sendPlayerError(playerid, "Aceasta comanda, nu este valabila pentru tine.");
	if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
	extract params -> new player:userID; else return sendPlayerSyntax(playerid, "/mdc <name/id>");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acest player nu este connectat.");
	showMDC(playerid, userID);
	return true;
}

CMD:su(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0 && Iter_Contains(FactionMembers[1], playerid) || Iter_Contains(FactionMembers[5], playerid) || Iter_Contains(FactionMembers[6], playerid) || Iter_Contains(FactionMembers[7], playerid) || Iter_Contains(FactionMembers[8], playerid)) return sendPlayerError(playerid, "Aceasta comanda, nu este valabila pentru tine.");
	if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
	extract params -> new player:userID, wantedLevel; else return sendPlayerSyntax(playerid, "/su <name/id> <wanted level>");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(Iter_Contains(FactionMembers[2], userID) || Iter_Contains(FactionMembers[3], userID) || Iter_Contains(FactionMembers[4], userID)) return sendPlayerError(playerid, "Nu poti acorda wanted unui coleg.");
	if(!(1 <= wantedLevel <= 6)) return sendPlayerError(playerid, "Invalid Wanted Level (1-6).");
	if(playerInfo[userID][pWantedLevel] < 6) playerInfo[userID][pWantedLevel] = wantedLevel;
	else playerInfo[userID][pWantedLevel] = 6;
	playerInfo[userID][pWantedTime] += 250 * playerInfo[playerid][pWantedLevel];
	SetPlayerWantedLevel(userID, playerInfo[userID][pWantedLevel]);
	Iter_Add(Wanteds, userID);
	wantedTime[userID] = repeat TimerWanted(userID);
	update("UPDATE `server_users` SET `WantedLevel` = '%d' WHERE `ID` = '%d'", playerInfo[userID][pWantedLevel], playerInfo[userID][pSQLID]);
	sendPolice(1, playerid, userID, wantedLevel, "None");
	addRaportPoint(playerid);
	return true;
}

CMD:clear(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0 && Iter_Contains(FactionMembers[1], playerid) || Iter_Contains(FactionMembers[5], playerid) || Iter_Contains(FactionMembers[6], playerid) || Iter_Contains(FactionMembers[7], playerid) || Iter_Contains(FactionMembers[8], playerid)) return sendPlayerError(playerid, "Aceasta comanda, nu este valabila pentru tine.");
	if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
	extract params -> new player:userID, string:reason[32]; else return sendPlayerSyntax(playerid, "/clear <name/id> <reason>");
	if(playerInfo[playerid][pinFaction] != playerInfo[playerid][pFaction] && GetPlayerInterior(playerid) == 0) return sendPlayerError(playerid, "Nu esti in HQ-ul factiunii tale pentru a executa aceasta comanda.");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(!playerInfo[userID][pWantedLevel]) return sendPlayerError(playerid, "Acel player nu are wanted.");
	sendPolice(2, playerid, userID, playerInfo[userID][pWantedLevel], reason);
	SCMf(userID, COLOR_LIGHTRED, "* Info Clear: Ai primit clear de la %s. Motiv: %s.", getName(playerid), wantedName(userID));
	playerInfo[userID][pWantedLevel] = 0;
	playerInfo[userID][pWantedTime] = 0;
	SetPlayerWantedLevel(userID, 0);
	Iter_Remove(Wanteds, userID);
	stop wantedTime[userID];
	update("UPDATE `server_users` SET `WantedLevel` = '0', `WantedTime` = '0' WHERE `ID` = '%d'", playerInfo[userID][pSQLID]);
	return true;
}

CMD:arrest(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0 && Iter_Contains(FactionMembers[1], playerid) || Iter_Contains(FactionMembers[5], playerid) || Iter_Contains(FactionMembers[6], playerid) || Iter_Contains(FactionMembers[7], playerid) || Iter_Contains(FactionMembers[8], playerid)) return sendPlayerError(playerid, "Aceasta comanda, nu este valabila pentru tine.");
	if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
	extract params -> new player:userID; else return sendPlayerSyntax(playerid, "/arrest <name/id>");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(!IsPlayerInAnyVehicle(playerid) && vehicleFaction[GetPlayerVehicleID(playerid)] == playerInfo[playerid][pFaction]) return sendPlayerError(playerid, "Trebuie sa fi intr-un vehicul al factiunii tale.");
	if(!IsPlayerInVehicle(userID, GetPlayerVehicleID(playerid))) return sendPlayerError(playerid, "Acel player trebuie sa fie cu tine in vehicul pentru a-l aresta.");
	if(!playerInfo[userID][pWantedLevel]) return sendPlayerError(playerid, "Acel player nu are wanted.");
	if(!IsPlayerInRangeOfPoint(playerid, 7.5, 1569.0323,-1692.7743,5.8906) && !IsPlayerInRangeOfPoint(playerid, 7.5, 612.1691,-588.3616,17.2266) && !IsPlayerInRangeOfPoint(playerid, 7.5, 2147.7305,-1196.9080,23.8656)) return sendPlayerError(playerid, "Nu te afli intr-un punct de arest pentru a putea executa aceasta comanda.");
	new rand = random(6); 
	if(playerInfo[userID][pCuffed] == 1) {
		SetPlayerSpecialAction(userID,SPECIAL_ACTION_NONE);
		RemovePlayerAttachedObject(userID,1);
		TogglePlayerControllable(userID, 1);
		playerInfo[userID][pCuffed] = 0;
	}
	SetPlayerPos(playerid, cellRandom[rand][0], cellRandom[rand][1], cellRandom[rand][2]);
	SetPlayerVirtualWorld(playerid, 1337);
	jailTime[userID] = repeat TimerJail(userID);
	playerInfo[userID][pJailed] = 1;
	playerInfo[userID][pJailTime] = playerInfo[userID][pWantedLevel]*250;
	playerInfo[userID][pArrested] += 1;	
	va_SendClientMessageToAll(COLOR_LIGHTRED, "* Arrest: Infractorul %s, a fost prins de %s. Acesta platind o amenda in valoare de $%s si inchisoare pe timp de %d secunde.", getName(userID), getName(playerid), formatNumber(playerInfo[userID][pWantedLevel]*2000), playerInfo[userID][pJailTime]);
	playerInfo[userID][pWantedLevel] = 0;
	GivePlayerCash(userID, 0, playerInfo[userID][pWantedLevel]*2000);
	GivePlayerCash(playerid, 1, playerInfo[userID][pWantedLevel]*2000);
	SetPlayerWantedLevel(userID, 0);
	addRaportPoint(playerid);
	Iter_Add(JailedPlayers, userID);
	update("UPDATE `server_users` SET `Jailed` = '%d', `JailTime` = '%d', `WantedLevel` = '0' WHERE `ID` = '%d'", playerInfo[userID][pJailed], playerInfo[userID][pJailTime], playerInfo[userID][pSQLID]);
	return true;
}


CMD:members(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0) return true;
	mysql_tquery(SQL, string_fast("SELECT `Name`,`LastLogin`,`FRank`,`FWarns`,`FAge`,`Commands` WHERE `server_users`.`Faction` = '%d' ORDER BY `server_users`.`FRank` DESC LIMIT 20", playerInfo[playerid][pFaction]), "showFactionMembers", "");
	return 1;
}

function showFactionMembers(playerid) {
	if(playerInfo[playerid][pFaction] == 0) return true;
	new days, name[180], lastl[180], rank, fw, commands, tmembers, memberString[700];
	if(!cache_num_rows()) return 1;
	strcat(memberString, "#. Name\tRank - FW - Raport Points\tStatus\tDays\n");
	for(new i = 1; i < cache_num_rows() +1; i++) {
		cache_get_value_name(i, "Name", name, 125);
		cache_get_value_name(i, "LastLogin", lastl, 125);
		cache_get_value_name_int(i, "FRank", rank);
		cache_get_value_name_int(i, "FWarns", fw);
		cache_get_value_name_int(i, "FAge", days);
		cache_get_value_name_int(i, "Commands", commands);
		format(Selected[playerid][tmembers], MAX_PLAYER_NAME, name);
		new userID = GetPlayerID(name);	
		if(userID != INVALID_PLAYER_ID) strcat(memberString, string_fast("%d. %s (%d)\t%d - %d/3 - %d\tOnline\t%d\n", tmembers+1, name, userID, playerInfo[playerid][pFactionRank], fw, commands, days), sizeof(memberString));
		else strcat(memberString, string_fast("%d. %s (%d)\t%d - %d/3 - %d\t%s\t%d\n", tmembers+1, name, userID, rank, fw, commands, lastl, days), sizeof(memberString));
		tmembers++;
	}
	Dialog_Show(playerid, DIALOG_MEMBERS, DIALOG_STYLE_TABLIST_HEADERS, string_fast("Members (%d/%d)", Iter_Count(FactionMembers[playerInfo[playerid][pFaction]]), tmembers), memberString, "Select", "Cancel");
	return true;
}

Dialog:DIALOG_MEMBERS(playerid, response, listitem) {
	if(!response) return true;
	if(playerInfo[playerid][pFactionRank] < 6) return sendPlayerError(playerid, "Ai nevoie de rank 6+ pentru a putea merge mai departe.");
	format(selName[playerid], 256, Selected[playerid][listitem]);	
	new rank, Cache: result = mysql_query(SQL, string_fast("SELECT * FROM `server_users` WHERE `Name`='%s'", selName[playerid]));
	cache_get_value_name_int(0, "FRank", rank);
	if(rank == 7)  return sendPlayerError(playerid, "Nu se poate modifica ceva unui lider.");
	cache_delete(result);						
	Dialog_Show(playerid, DIALOG_MEMBERS2, DIALOG_STYLE_LIST, string_fast("Member: %s", selName[playerid]), "Rank\nFaction warn\nUn faction warn\nUninvite", "Ok", "Back");
	return true;
}

Dialog:DIALOG_MEMBERS2(playerid, response, listitem) {
	if(!response) showFactionMembers(playerid);
	if(playerInfo[playerid][pFactionRank] < 6) return sendPlayerError(playerid, "Ai nevoie de rank 6+ pentru a putea merge mai departe.");
	new userID = GetPlayerID(selName[playerid]);
	switch(listitem) {
		case 0: Dialog_Show(playerid, DIALOG_MEMBERSRANK, DIALOG_STYLE_INPUT, "Give rank to a member.", string_fast("Scrie mai jos rankul pe care vrei sa il dai membrului %s.", selName[playerid]), "Ok", "Close");
		case 1: {
			new fw, days, rank, id, Cache: result = mysql_query(SQL, string_fast("SELECT * FROM `server_users` WHERE `Name`='%s'", selName[playerid]));
			cache_get_value_name_int(0, "FWarns", fw);
			cache_get_value_name_int(0, "FAge", days);
			cache_get_value_name_int(0, "FRank", rank);
			cache_get_value_name_int(0, "ID", id);
			if(playerInfo[playerid][pFactionRank] == 6 && rank >= 6) return sendPlayerError(playerid, "Nu poti da faction warn unui membru cu rank 6+.");				
			cache_delete(result);
			fw++;
			sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "(+) %s i-a acordat lui %s un Faction Warn.", getName(playerid), selName[playerid]);
			update("UPDATE `server_users` SET `FWarns` = '%d' WHERE `Name` = '%s' LIMIT 1", fw, selName[playerid]);
			if(userID != INVALID_PLAYER_ID) playerInfo[userID][pFactionWarns] = fw;						
			if(fw >= 3) {
				Iter_Remove(FactionMembers[playerInfo[playerid][pFaction]], userID);		
				if(userID != INVALID_PLAYER_ID) {
					playerInfo[userID][pFactionWarns] = 0;	
					playerInfo[userID][pFaction] = 0;
					playerInfo[userID][pFactionRank] = 0;
					playerInfo[userID][pFactionPunish] = 20;
					playerInfo[userID][pFactionAge] = 0;
					if(playerInfo[userID][pGender] == FEMALE_GENDER) playerInfo[userID][pSkin] = 12;
					else playerInfo[userID][pSkin] = 250;
					SetPlayerSkin(userID, playerInfo[userID][pSkin]);
					SpawnPlayer(userID);
					Dialog_Show(userID, 0, DIALOG_STYLE_MSGBOX, "Uninvited", string_fast("Ai fost demis din factiunea %s de AdmBot\nMotiv: 3/3 Faction Warn's.", factionName(playerInfo[playerid][pFaction])), "Ok", "");						
				}	
				sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "(-) %s a fost dat afara de AdmBot, motiv: 3/3 Faction Warn's.", selName[playerid]);
				update("INSERT INTO `server_faction_log` (`Text`, `Player`, `Leader`) VALUES ('%s', '%d', '%d')", string_fast("%s a fost scos de AdmBot din %s (rank %d) dupa %d zile, motiv: 3/3 FW.", selName[playerid], factionName(playerInfo[playerid][pFaction]), rank, days), id, playerInfo[playerid][pSQLID]);
				update("UPDATE `server_users` SET `Faction` = '0', `FRank` = '0', `FPunish` = '20', `FWarns` = '0', `FAge` = '0', `Skin` = '%d' WHERE `Name` = '%s' LIMIT 1", playerInfo[userID][pSkin], selName[playerid]);					
			}
		}
		case 2: {
			new fw, Cache: result = mysql_query(SQL, string_fast("SELECT * FROM `server_users` WHERE `Name`='%s'", selName[playerid]));
			cache_get_value_name_int(0, "FWarn", fw);
			cache_delete(result);
			if(fw == 0) return sendPlayerError(playerid, "Acel membru nu are faction warn's.");
			sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "(+) %s i-a scos lui %s un Faction Warn.", getName(playerid), selName[playerid]);			
			update("UPDATE `server_users ` SET `FWarns` = '%d' WHERE `Name` = '%s' LIMIT 1", fw-1, selName[playerid]);
		}
		case 3: Dialog_Show(playerid, DIALOG_MEMBERSUINV, DIALOG_STYLE_INPUT, string_fast("Uninvite %s", selName[playerid]), "Scrie mai jos motivul pentru pe care vrei sa-l demiti pe acest membru.", "Ok", "Close");				
	} 
	return true;
}

Dialog:DIALOG_MEMBERSRANK(playerid, response, inputtext[]) {
	if(!response) return true;
	new rank = strval(inputtext),userID = GetPlayerID(selName[playerid]);
	if(rank < 1 || rank > 6) return sendPlayerError(playerid, "Rank invalid (1-6).");
	sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "(+) %s i-a dat lui %s rank %d.", getName(playerid), selName[playerid], rank);
	if(userID != INVALID_PLAYER_ID) playerInfo[userID][pFactionRank] = rank;
	update("UPDATE `server_users ` SET `FRank` = '%d' WHERE `Name` = '%s' LIMIT 1", rank, selName[playerid]);	
	factionLog(playerInfo[playerid][pFaction], selName[playerid], string_fast("%s a primit rank %d de la %s.", selName[playerid], rank, getName(playerid)));
	return true;
}

Dialog:DIALOG_MEMBERSUINV(playerid, response, inputtext[]) {
	if(!response) return true;
	SetPVarString(playerid, "Reason", inputtext);
	Dialog_Show(playerid, DIALOG_MEMBERSUINV2, DIALOG_STYLE_INPUT, string_fast("Uninvite %s", selName[playerid]), "Scrie mai jos numarul de FP-uri pe care vrei sa-i dai acestui membru.\nDaca membrul are peste 7 zile, aceasta poate primi fara FP dar cu exceptii", "Ok", "Close");
	return true;
}

Dialog:DIALOG_MEMBERSUINV2(playerid, response, inputtext[]) {
	if(!response) return true;
	new fp = strval(inputtext), userID = GetPlayerID(selName[playerid]), reason[64];
	if(userID != INVALID_PLAYER_ID) return sendPlayerError(playerid, "Acel player este conectat.");
	GetPVarString(playerid, "Reason", reason, 64);
	new id, rank , days, Cache: result = mysql_query(SQL, string_fast("SELECT * FROM `server_users` WHERE `Name`='%s'", selName[playerid]));
	cache_get_value_name_int(0, "ID", id); 
	cache_get_value_name_int(0, "FRank", rank); 
	cache_get_value_name_int(0, "FAge", days); 
	cache_delete(result);
	if(playerInfo[playerid][pFactionRank] == 6 && rank >= 6) return sendPlayerError(playerid, "Nu poti da afara un membru cu rank 6+.");
	Iter_Remove(FactionMembers[playerInfo[playerid][pFaction]], userID);
	update("INSERT INTO `server_faction_log` (`Text`, `Player`, `Leader`) VALUES ('%s', '%d', '%d')", string_fast("%s a fost scos de lider %s din %s (rank %d) dupa %d zile, motiv: %s.", selName[playerid], getName(playerid), factionName(playerInfo[playerid][pFaction]), rank, days, reason), id, playerInfo[playerid][pSQLID]);
	factionLog(playerInfo[playerid][pFaction], selName[playerid], string_fast("%s a fost dat afara de %s, motiv: %s.", selName[playerid], getName(playerid), reason));
	if(userID != INVALID_PLAYER_ID) {
		playerInfo[userID][pFactionWarns] = 0;	
		playerInfo[userID][pFaction] = 0;
		playerInfo[userID][pFactionRank] = 0;
		playerInfo[userID][pFactionPunish] = fp;
		playerInfo[userID][pFactionAge] = 0;
		if(playerInfo[userID][pGender] == FEMALE_GENDER) playerInfo[userID][pSkin] = 12;
		else playerInfo[userID][pSkin] = 250;
		SetPlayerSkin(userID, playerInfo[userID][pSkin]);
		SpawnPlayer(userID);
		Dialog_Show(userID, 0, DIALOG_STYLE_MSGBOX, "Uninvited", string_fast("Ai fost demis din factiunea %s de %s\nMotiv: %s.", factionName(playerInfo[playerid][pFaction]), getName(playerid), response), "Ok", "");						
	}		
	if(fp == 0) {
		sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "(-) %s l-a dat afara pe %s fara FP, motiv: %s.", getName(playerid), selName[playerid], reason);
		if(userID != INVALID_PLAYER_ID) Dialog_Show(userID, 0, DIALOG_STYLE_MSGBOX, "Uninvited", string_fast("Ai fost demis din factiunea %s de %s fara FP, motiv: %s.", factionName(playerInfo[playerid][pFaction]), getName(playerid), reason), "Ok", "");							
	}
	else {
		sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "(-) %s l-a dat afara pe %s cu FP, motiv: %s.", getName(playerid), selName[playerid], reason);	
		if(userID != INVALID_PLAYER_ID) Dialog_Show(userID, 0, DIALOG_STYLE_MSGBOX, "Uninvited", string_fast("Ai fost demis din factiunea %s de %S cu FP, motiv: %s.", factionName(playerInfo[playerid][pFaction]), getName(playerid), reason), "Ok", "");			
	}
	update("UPDATE `server_users` SET `Faction` = '0', `FRank` = '0', `FPunish` = '%d', `FWarns` = '0', `FAge` = '0', `Skin` = '%d' WHERE `Name` = '%s' LIMIT 1", playerInfo[userID][pFactionPunish], playerInfo[userID][pSkin], selName[playerid]);	
	return true;
}

CMD:fare(playerid, params[]) {
	if(!Iter_Contains(FactionMembers[5], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'Taxi Company' pentru a folosi aceasta comanda.");
	if(vehicleFaction[GetPlayerVehicleID(playerid)] != playerInfo[playerid][pFaction]) return sendPlayerError(playerid, "Acest vehicul nu apartine factiunii tale.");
	extract params -> new fare; else {
		SCM(playerid, -1, "* Options: 0$ - stop fare ; $1 - $5,000 fare active.");
		return sendPlayerSyntax(playerid, "/fare <price>");
	}
	if(playerInfo[playerid][pTaxiDuty] == 1 && fare == 0) {
		foreach(new i : loggedPlayers) {
			if(playerInfo[i][pTaxiDriver] == playerid) {
				PlayerTextDrawHide(i, fareTD[playerid]);
				playerInfo[i][pTaxiDriver] = -1;
				playerInfo[playerid][pTaxiMoney] = 0;
				stop taxi[i];
			}
		}
		SCMf(playerid, COLOR_LIMEGREEN, "* Fare: Acum nu mai esti la datorie si ai primit $%s, banii facuti pana in acest moment.", formatNumber(playerInfo[playerid][pTaxiMoney]));
		PlayerTextDrawHide(playerid, fareTD[playerid]);
		GivePlayerCash(playerid, 1, playerInfo[playerid][pTaxiMoney]);
		playerInfo[playerid][pTaxiFare] = 0;
		playerInfo[playerid][pTaxiDuty] = 0;
		playerInfo[playerid][pTaxiMoney] = 0;
		return true;
	}
	if(!(1 <= fare <= 5000)) return sendPlayerError(playerid, "Invalid fare. (1$ - $5,000).");
	playerInfo[playerid][pTaxiFare] = fare;
	playerInfo[playerid][pTaxiDuty] = 1;
	playerInfo[playerid][pTaxiMoney] = 0;
	updateTaxiTextdraw(playerid);
	va_SendClientMessageToAll(COLOR_GOLD, "* Taxi Driver %s is now on duty for $%s, use [/service taxi].", getName(playerid), formatNumber(fare));
	return true;
}

timer fareUpdateTimer[5000](playerid) {
	if(!IsPlayerInAnyVehicle(playerid)) return true;
	if(playerInfo[playerid][pTaxiDriver] == -1) return true;
	if(playerInfo[playerInfo[playerid][pTaxiDriver]][pTaxiDuty] == 0) return true;
	if(PlayerMoney(playerid, playerInfo[playerInfo[playerid][pTaxiDriver]][pTaxiFare])) {
	    if(playerInfo[playerid][pTaxiMoney] != 0) {
			if(playerInfo[playerid][pTaxiMoney] >= 20) addRaportPoint(playerInfo[playerid][pTaxiDriver]);
			sendNearbyMessage(playerid, COLOR_GOLD, 30.0, "* %s a platit pentru cursa efectuata taximetristului %s, $%s.", getName(playerid), getName(playerInfo[playerid][pTaxiDriver]), formatNumber(playerInfo[playerid][pTaxiMoney]));
			playerInfo[playerid][pTaxiMoney] = 0;
	    }
	    playerInfo[playerid][pTaxiDriver] = -1;
	    PlayerTextDrawHide(playerid, fareTD[playerid]);
		stop taxi[playerid];
	    return true;
	}
	playerInfo[playerInfo[playerid][pTaxiDriver]][pTaxiMoney] += playerInfo[playerInfo[playerid][pTaxiDriver]][pTaxiFare];
	playerInfo[playerid][pTaxiMoney] += playerInfo[playerInfo[playerid][pTaxiDriver]][pTaxiFare];
	GivePlayerCash(playerid, 0, playerInfo[playerInfo[playerid][pTaxiDriver]][pTaxiFare]);
    updateTaxiTextdraw(playerid);
    updateTaxiTextdraw(playerInfo[playerid][pTaxiDriver]);
	return true;
}

function updateTaxiTextdraw(playerid) {
	if(playerInfo[playerid][pTaxiDuty] == 1) {
	    va_PlayerTextDrawSetString(playerid, fareTD[playerid], "%s", playerInfo[playerid][pTaxiFare] ? string_fast("Tarif: ~g~$%s~n~~w~~h~Castig total: ~g~$%s", formatNumber(playerInfo[playerid][pTaxiFare]),
		formatNumber(playerInfo[playerid][pTaxiMoney])) : string_fast("Tarif: ~r~Oprit~n~~w~~h~Castig total: ~g~$%s", formatNumber(playerInfo[playerid][pTaxiMoney])));
		PlayerTextDrawShow(playerid, fareTD[playerid]);
	}
	else {
	    va_PlayerTextDrawSetString(playerid, fareTD[playerid], "%s", playerInfo[playerInfo[playerid][pTaxiDriver]][pTaxiFare] ? string_fast("Tarif: ~g~$%s~n~~w~~h~Costul cursei: ~g~$%s", formatNumber(playerInfo[playerInfo[playerid][pTaxiDriver]][pTaxiFare]),
		formatNumber(playerInfo[playerid][pTaxiMoney])) : string_fast("Tarif: ~r~Oprit~n~~w~~h~Costul cursei: ~g~$%", formatNumber(playerInfo[playerid][pTaxiMoney])));
		PlayerTextDrawShow(playerid, fareTD[playerid]);
	}
	return true;
}

CMD:news(playerid, params[]) {
	if(!Iter_Contains(FactionMembers[7], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'News Reporters' pentru a folosi aceasta comanda.");
	if(vehicleFaction[GetPlayerVehicleID(playerid)] != playerInfo[playerid][pFaction]) return sendPlayerError(playerid, "Acest vehicul nu apartine factiunii tale.");
	new hour, minute, second;
	gettime(hour, minute, second);
	if(minute < 50 || minute > 59) return sendPlayerError(playerid, "Poti pune anunturi doar la %d:50 pana la %d:00", hour, hour+1);
	if(playerInfo[playerid][pMute] > 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece ai mute inca %d secunde.", playerInfo[playerid][pMute]);
	extract params -> new string:result[250]; else return sendPlayerSyntax(playerid, "/news <text>");
	if(strlen(result) < 1 || strlen(result) > 250) return sendPlayerError(playerid, "Invalid text, min. 1 caracter max. 250 caractere.");
	oocNews(COLOR_NEWS, "(*) News %s: %s.", getName(playerid), result);
	addRaportPoint(playerid);
	return true;
}

CMD:live(playerid, params[]) {
	if(!Iter_Contains(FactionMembers[7], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'News Reporters' pentru a folosi aceasta comanda.");
	if(playerInfo[playerid][pTalkingLive] > -1) return sendPlayerError(playerid, "Esti deja intr-un live.");
	if(playerInfo[playerid][pFactionRank] < 3) return sendPlayerError(playerid, "Trebuie sa detii minim rank 3 in factiune pentru a putea acorda live.");
	extract params -> new player:userID; else return sendPlayerSyntax(playerid, "/live <name/id>");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este connectat.");
	if(vehicleFaction[GetPlayerVehicleID(playerid)] != playerInfo[playerid][pFaction]) return sendPlayerError(playerid, "Acest vehicul nu apartine factiunii tale.");
	if(!IsPlayerInVehicle(userID, GetPlayerVehicleID(playerid))) return sendPlayerError(playerid, "Acest player nu este in masina cu tine.");
	new hour, minute, second;
	gettime(hour, minute, second);
	if(hour >= 00 && hour < 8) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda in intervalul 00-08.");
	sendFactionMessage(6, COLOR_LIMEGREEN, "* (NR Dispatch: Reporter %s (%d) e pe cale sa inceapa un interviu cu %s (%d).) *", getName(playerid), playerid, getName(userID), userID);
	SCMf(playerid, COLOR_GREY, "* I-ai oferit lui %s (%d) o conversatie 'Live'.", getName(userID), userID);
	SCMf(userID, COLOR_GREY, "* %s (%d) ti-a oferit o conversatie 'Live', /accept live %d pentru a accepta.", getName(playerid), playerid);
	playerInfo[userID][pLiveOffer] = playerid;
	return true;
}

CMD:endlive(playerid, params[]) {
	if(!Iter_Contains(FactionMembers[7], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'News Reporters' pentru a folosi aceasta comanda.");
	if(playerInfo[playerid][pTalkingLive] == -1) return sendPlayerError(playerid, "Nu esti intr-un live.");
	SCM(playerid, COLOR_GREY, "* Conversatia 'Live' a fost terminata.");
	SCM(playerInfo[playerid][pTalkingLive], COLOR_GREY, "* Conversatia 'Live' a fost terminata.");
	TogglePlayerControllable(playerid, 1);
	TogglePlayerControllable(playerInfo[playerid][pTalkingLive], 1);
	playerInfo[playerInfo[playerid][pTalkingLive]][pTalkingLive] = -1;
	playerInfo[playerid][pTalkingLive] = -1;
	addRaportPoint(playerid);
	Questions = 0;
	foreach(new i : loggedPlayers) {
		if(strlen(playerInfo[i][pQuestionText]) > 10) format(playerInfo[i][pQuestionText], 4, "None");
	}		
	return true;
}

CMD:questions(playerid, params[]) {
	if(!Iter_Contains(FactionMembers[7], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'News Reporters' pentru a folosi aceasta comanda.");
	switch(Questions) {
		case 0: {
			if(playerInfo[playerid][pTalkingLive] == -1) return sendPlayerError(playerid, "Nu esti intr-un live.");
			Questions = 1;
			SCM(playerid, COLOR_LIMEGREEN, "Acum playerii pot trimite intrebari.");
		}
		case 1: {
			Questions = 0;
			SCM(playerid, COLOR_LIMEGREEN, "Acum playerii nu mai pot trimite intrebari.");
		}		
	}
	return true;
}

CMD:question(playerid, params[]) {
	if(strlen(playerInfo[playerid][pQuestionText]) > 10) return sendPlayerError(playerid, "Nu poti pune mai multe intrebari.");
	if(Questions == 0) return sendPlayerError(playerid, "Nu se pot pune intrebari acum.");
	if(playerInfo[playerid][pLevel] < 3) return sendPlayerError(playerid, "Pentru a folosi aceasta comanda, ai nevoie de minim nivel 3.");
	extract params -> new string:result[180]; else return sendPlayerSyntax(playerid, "/question <text>");
	if(strlen(result) < 10 && strlen(result) > 180) return sendPlayerError(playerid, "Intrebare prea mica/mare.");
	sendFactionMessage(6, COLOR_LIMEGREEN, "* (NR Dispatch: Intrebare de la %s (%d). Text: %s.) *", getName(playerid), playerid, result);
	format(playerInfo[playerid][pQuestionText], 180, result);
	SCM(playerid, COLOR_GREY, "* Intrebare trimisa.");
	return true;
}

CMD:aq(playerid, params[]) {
	if(!Iter_Contains(FactionMembers[7], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'News Reporters' pentru a folosi aceasta comanda.");
	if(playerInfo[playerid][pTalkingLive] == -1) return sendPlayerError(playerid, "Nu esti intr-un live.");
	if(Questions == 0) return sendPlayerError(playerid, "Nu poti accepta intrebari acum.");
	extract params -> new player:userID; else return sendPlayerSyntax(playerid, "/aq <name/id>");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este logat.");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(strlen(playerInfo[playerid][pQuestionText]) < 10) return sendPlayerError(playerid, "Acel player nu a pus o intrebare.");
	format(playerInfo[playerid][pQuestionText], 4, "None");
	va_SendClientMessageToAll(COLOR_LIGHTGREEN, "* Intrebare de la %s: %s", getName(userID), playerInfo[playerid][pQuestionText]);
	return true;
}

CMD:startlesson(playerid, params[]) {
	if(!Iter_Contains(FactionMembers[6], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'School Instructors' pentru a folosi aceasta comanda.");
	extract params -> new player:userID; else return sendPlayerSyntax(playerid, "/startlesson <name/id>");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este connectat.");
	if(playerInfo[playerid][pInLesson] != 0 || playerInfo[userID][pInLesson] != 0) return sendPlayerSyntax(playerid, "Tu sau acel player sunteti deja intr-o lectie.");
	if(playerInfo[userID][pLevel] < 3) return sendPlayerError(playerid, "Acel player nu are level 3, nu ii poti acorda o lectie.");
	if(!ProxDetectorS(9.0, playerid, userID)) return sendPlayerError(playerid, "Nu esti langa acel jucator.");
	SCMf(userID, COLOR_GREY, "* Instructorul %s (%d) doreste sa inceapa o lectie cu tine, /accept lesson %d.", getName(playerid), playerid, playerid);
	SCMf(playerid, COLOR_GREY, "* Ai trimis o invitatie de lectie lui %s (%d).", getName(userID), userID);
	playerInfo[userID][pInLesson] = playerid;
	playerInfo[playerid][pInLesson] = userID;
	return true;
}

CMD:stoplesson(playerid, params[]) {
	if(!Iter_Contains(FactionMembers[6], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'School Instructors' pentru a folosi aceasta comanda.");
	extract params -> new player:userID; else return sendPlayerSyntax(playerid, "/stoplesson <name/id>");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este connectat.");
	if(playerInfo[playerid][pInLesson] == 0) return sendPlayerError(playerid, "Nu ai o lectie cu un player.");
	if(playerInfo[userID][pInLesson] != playerid) return sendPlayerError(playerid, "Acel player nu este intr-o lectie cu tine.");
	playerInfo[userID][pInLesson] = 0;
	playerInfo[playerid][pInLesson] = 0;	
	SCMf(userID, COLOR_GREY, "* Instructorul %s (%d) a oprit lectia cu tine.", getName(playerid), playerid);
	SCMf(playerid, COLOR_GREY, "* Ai oprit lectia cu %s (%d).", getName(userID), userID);
	return true;
}

CMD:givelicense(playerid, params[]) {
	if(!Iter_Contains(FactionMembers[6], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'School Instructors' pentru a folosi aceasta comanda.");
	extract params -> new player:userID, string:option[5]; else {
		SCM(playerid, COLOR_GREY, "* Options: Fly, Boat, Gun.");
		return sendPlayerSyntax(playerid, "/givelicense <name/id> <license>");
	}
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este connectat.");
	if(playerInfo[userID][pInLesson] != playerid) return sendPlayerError(playerid, "Acel player nu este intr-o lectie cu tine.");
	if(!ProxDetectorS(9.0, playerid, userID)) return sendPlayerError(playerid, "Nu esti langa acel jucator.");
	if(strmatch(option, "fly")) {		
		if(PlayerMoney(userID, 100000)) return sendPlayerError(playerid, "Acel jucator nu are suma necesara de bani.");
		if(playerInfo[playerid][pFlyLicenseSuspend] > 0) return sendPlayerError(playerid, "Acel jucator are aceasta licenta suspendata.");
		if(playerInfo[playerid][pFlyLicense] > 0) return sendPlayerError(playerid, "Acel jucator are deja aceasta licenta.");
		SCMf(playerid, COLOR_GREY, "* I-ai oferit lui %s (%d) licenta de 'Fly' pentru suma de $100,000.", getName(userID), userID);
		SCMf(userID, COLOR_GREY, "* Instructorul %s (%d) ti-a oferit licenta de 'Fly' in schimbul sumei de $100,000, /accept license %d.", getName(playerid), playerid, playerid);
		playerInfo[userID][pLicense] = 1;
		playerInfo[userID][pLicenseOffer] = playerid;
		return true;
	}	
	if(strmatch(option, "boat")) {		
		if(PlayerMoney(userID, 200000)) return sendPlayerError(playerid, "Acel jucator nu are suma necesara de bani.");
		if(playerInfo[playerid][pBoatLicenseSuspend] > 0) return sendPlayerError(playerid, "Acel jucator are aceasta licenta suspendata.");
		if(playerInfo[playerid][pBoatLicense] > 0) return sendPlayerError(playerid, "Acel jucator are deja aceasta licenta.");
		SCMf(playerid, COLOR_GREY, "* I-ai oferit lui %s (%d) licenta de 'Boat' pentru suma de $200,000.", getName(userID), userID);
		SCMf(userID, COLOR_GREY, "* Instructorul %s (%d) ti-a oferit licenta de 'Boat' in schimbul sumei de $200,000, /accept license %d.", getName(playerid), playerid, playerid);
		playerInfo[userID][pLicense] = 2;
		playerInfo[userID][pLicenseOffer] = playerid;
		return true;
	}	
	if(strmatch(option, "gun")) {		
		if(PlayerMoney(userID, 300000)) return sendPlayerError(playerid, "Acel jucator nu are suma necesara de bani.");
		if(playerInfo[playerid][pBoatLicenseSuspend] > 0) return sendPlayerError(playerid, "Acel jucator are aceasta licenta suspendata.");
		if(playerInfo[playerid][pBoatLicense] > 0) return sendPlayerError(playerid, "Acel jucator are deja aceasta licenta.");
		SCMf(playerid, COLOR_GREY, "* I-ai oferit lui %s (%d) licenta de 'Gun' pentru suma de $300,000.", getName(userID), userID);
		SCMf(userID, COLOR_GREY, "* Instructorul %s (%d) ti-a oferit licenta de 'Gun' in schimbul sumei de $300,000, /accept license %d.", getName(playerid), playerid, playerid);
		playerInfo[userID][pLicense] = 3;
		playerInfo[userID][pLicenseOffer] = playerid;
		return true;
	}	
	return true;
}

CMD:setguns(playerid, parmas[]) {
	if(!Iter_Contains(FactionMembers[8], playerid) && !Iter_Contains(FactionMembers[9], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'Grove Street' sau 'Ballas' pentru a folosi aceasta comanda.");
	gString[0] = (EOS);
	strcat(gString, "Gun\tStatus\n{FFFFFF}");
	for(new i = 0; i < 5; i++) format(gString, sizeof(gString), "%s%s\t%s\n", gString, GunName[i], playerInfo[playerid][pGuns][i] ? ("{00ff00}Enabled") : ("{ff0000}Desabled"));
	Dialog_Show(playerid, DIALOG_SETGUN, DIALOG_STYLE_TABLIST_HEADERS, "Order gun - Set", gString, "Select", "Cacnel");
	return true;
}

Dialog:DIALOG_SETGUN(playerid, response, listitem) {
	if(!response) return true;
	playerInfo[playerid][pGuns][listitem] = playerInfo[playerid][pGuns][listitem] ? false : true;
	SCMf(playerid, COLOR_LIGHTRED, "* (Order Guns):{ffffff} Arma '%s' a fost setata pe modul '%s'.", GunName[listitem], playerInfo[playerid][pGuns][listitem] ? ("{00ff00}Enabled") : ("{ff0000}Desabled"));
	save_guns(playerid);
	return true;
}

CMD:tie(playerid, params[]) {
	if(!Iter_Contains(FactionMembers[8], playerid) && !Iter_Contains(FactionMembers[9], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'Grove Street' sau 'Ballas' pentru a folosi aceasta comanda.");
	if(playerInfo[playerid][pFactionRank] < 2) return sendPlayerError(playerid, "Ai nevoie rank 2+ pentru a face acest lucru.");
	extract params -> new player:userID; else return sendPlayerSyntax(playerid, "/tie <name/id>");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acest player nu este logat.");
	if(playerInfo[userID][pCuffed] == 2) return sendPlayerError(playerid, "Acest player este deja legat.");
	new car = GetPlayerVehicleID(playerid);
	if(!IsPlayerInAnyVehicle(playerid) && !IsPlayerInVehicle(userID, car)) return sendPlayerError(playerid, "Nu esti intr-un vehicul sau acel player nu este in vehicul cu tine.");
	sendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "* %s l-a legat pe %s.", getName(playerid), getName(userID));
	TogglePlayerControllable(userID, 0);
	playerInfo[userID][pCuffed] = 2;
	return true;
}

CMD:untie(playerid, params[]) {
	if(!Iter_Contains(FactionMembers[8], playerid) && !Iter_Contains(FactionMembers[9], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'Grove Street' sau 'Ballas' pentru a folosi aceasta comanda.");
	if(playerInfo[playerid][pFactionRank] < 2) return sendPlayerError(playerid, "Ai nevoie rank 2+ pentru a face acest lucru.");
	extract params -> new player:userID; else return sendPlayerSyntax(playerid, "/tie <name/id>");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acest player nu este logat.");
	if(playerInfo[userID][pCuffed] == 0) return sendPlayerError(playerid, "Acest player nu este legat.");
	if(!ProxDetectorS(8.0, playerid, userID)) return sendPlayerError(playerid, "Acest player nu este langa tine.");
	sendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "* %s l-a dezlegat pe %s.", getName(playerid), getName(userID));
	TogglePlayerControllable(userID, 1);
	playerInfo[userID][pCuffed] = 0;
	return true;
}

CMD:attack(playerid, params[]) {
	if(!Iter_Contains(FactionMembers[8], playerid) && !Iter_Contains(FactionMembers[9], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'Grove Street' sau 'Ballas' pentru a folosi aceasta comanda.");
	if(playerInfo[playerid][pFactionRank] < 3) return sendPlayerError(playerid, "Ai nevoie rank 3+ pentru a face acest lucru.");
	new turf = 0;
	for(new i = 1; i <= Iter_Count(ServerTurfs); i++) {
		if(IsPlayerInTurf(playerid, i) == 1) {
			turf = i;
			break;
		}
    }
    if(turf == 0) return sendPlayerError(playerid, "Nu esti pe un teritoriu.");
    if(turfInfo[turf][tOwned] == playerInfo[playerid][pFaction]) return sendPlayerError(playerid, "Nu poti ataca un teritoriu ce apartine factiunii tale.");
    if(warInfo[turf][wAttacker] != 0) return sendPlayerError(playerid, "Acest teritoriu este deja atacat.");
    if(InWar[playerInfo[playerid][pFaction]] == 1) return sendPlayerError(playerid, "Mafia ta are deja un war activ.");
    if(InWar[turfInfo[turf][tOwned]] == 1) return sendPlayerError(playerid, "Acesta mafie are deja un war activ.");
    sendAdmin(COLOR_LIGHTGREEN, "(War System Admin): %s a atacat teritoriul %d detinut de %s.", factionName(playerInfo[playerid][pFaction]), turf, factionName(turfInfo[turf][tOwned]));
    sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIGHTGREEN, "(War System):{ffffff} %s a atacat teritoriu %d detinut de %s.", getName(playerid), turf, factionName(turfInfo[turf][tOwned]));
    sendFactionMessage(turfInfo[turf][tOwned], COLOR_LIGHTGREEN, "(War System):{ffffff} %s a atacat teritoriu %d detinut de voi.", getName(playerid), turf);
   	warInfo[turf][wTime] = 10;
	warInfo[turf][wAttacker] = playerInfo[playerid][pFaction];
	warInfo[turf][wFaction] = turfInfo[turf][tOwned];
	InWar[turfInfo[turf][tOwned]] = 1;
	InWar[playerInfo[playerid][pFaction]] = 1;
	Iter_Add(ServerWars, turf);
	war[turf] = repeat TimerWar(turf);
	return true;
}

CMD:wars(playerid, params[]) {
	if(Iter_Count(ServerWars) == 0) return sendPlayerError(playerid, "Momentan nu sunt war-uri.");
	for(new i = 1; i < Iter_Count(ServerWars); i++) {
		if(warInfo[i][wAttacker] != 0) SCMf(playerid, COLOR_LIGHTGREEN, "* [WAR]: %s (score: %0.2f) - %s (score: %0.2f) [turf: %d]. Time Left: %d seconds.", factionName(warInfo[i][wAttacker]), WarScore[1][i], factionName(warInfo[i][wFaction]), WarScore[2][i], i, warInfo[i][wTime]);
	}
	SCMf(playerid, COLOR_LIGHTGREEN, "* - Sunt %d war-uri in acest moment.", Iter_Count(ServerWars));
	return true;
}

timer TimerWar[1000](i) {
	warInfo[i][wTime] --;
	foreach(new x : loggedPlayers) {
		if(IsPlayerInTurf(x, i) && playerInfo[x][pOnTurf] == 0) {
			if(warInfo[i][wFaction] == playerInfo[x][pFaction] || warInfo[i][wAttacker] == playerInfo[x][pFaction]) {
				SCM(x, COLOR_LIMEGREEN, "* (War System): Deoarece ai intrat pe teritoriu ai fost transferat intr-un virtual world unde sunt prezenti doar membrii care particia la war.");
				SetPlayerVirtualWorld(x, 69);
				playerInfo[x][pOnTurf] = 1;
			}
		}
		if(warInfo[i][wAttacker] == 8) GangZoneFlashForPlayer(x, turfInfo[i][tID], 0x0CAB3C99);
		else if(warInfo[i][wAttacker] == 9) GangZoneFlashForPlayer(x, turfInfo[i][tID], 0xc22da999);
		va_PlayerTextDrawSetString(x, warTD[x], "War System~n~%s - %s~n~Score:%0.2f - Score:%0.2f~n~Kills: %d - Deaths:%d~n~Score:%0.2f",factionName(warInfo[i][wAttacker]), factionName(warInfo[i][wFaction]), WarScore[1][i], WarScore[2][i], ucideri[x][i], decese[x][i], WarScore[x][i]);
		PlayerTextDrawShow(x, warTD[x]);
		if(warInfo[i][wTime] <= 0) {
			PlayerTextDrawHide(x, warTD[x]);
			if(WarScore[1][i] == WarScore[2][i]) {
				if(playerInfo[x][pFaction] == warInfo[i][wAttacker] || playerInfo[x][pFaction] == warInfo[i][wFaction]) {
					SCMf(x, COLOR_LIMEGREEN, "* (War): {ffffff}Razboiul dintre %s si %s s-a terminat. Deoarece scorul echipelor este egal, nu exista o echipa castigatoare.", 
					factionName(warInfo[i][wAttacker]), factionName(warInfo[i][wFaction])); 
					decese[x][i] = 0;
					ucideri[x][i] = 0;
					GangZoneStopFlashForPlayer(x, turfInfo[i][tID]);
				}
				InWar[warInfo[i][wAttacker]] = 0;
				InWar[warInfo[i][wFaction]] = 0;
				warInfo[i][wTime] = 0;
				warInfo[i][wAttacker] = 0;
				warInfo[i][wFaction] = 0;
				Iter_Remove(ServerWars, i);
				stop war[i];
				return true;
			}
			stop war[i];
			new winner = -1;
			if(WarScore[1][i] > WarScore[2][i]) winner = warInfo[i][wAttacker];
			else if(WarScore[2][i] > WarScore[1][i]) winner = warInfo[i][wFaction];
			GangZoneHideForPlayerEx(x,turfInfo[i][tID]);
			switch(warInfo[i][wAttacker]) {
				case 8: GangZoneShowForPlayerEx(x, turfInfo[i][tID], 0x0CAB3C99);
				case 9: GangZoneShowForPlayerEx(x, turfInfo[i][tID], 0xc22da999);
			}
			if(playerInfo[x][pFaction] == warInfo[i][wAttacker] || playerInfo[x][pFaction] == warInfo[i][wFaction]) {
				SCMf(x, COLOR_LIMEGREEN, "* (War): {ffffff}Razboiul dintre %s si %s s-a terminat. Echipa castigatoare cu scorul de %0.2f este %s.", 
				factionName(warInfo[i][wAttacker]), factionName(warInfo[i][wFaction]), WarScore[winner][i], factionName(winner)); 
				decese[x][i] = 0;
				ucideri[x][i] = 0;
				GangZoneStopFlashForPlayer(x, turfInfo[i][tID]);
			}
			update("UPDATE `server_turfs` SET `Owned` = '%d' WHERE `ID` = '%d' LIMIT 1", winner, i);
			InWar[warInfo[i][wAttacker]] = 0;
			InWar[warInfo[i][wFaction]] = 0;
			turfInfo[i][tOwned] = winner;
			warInfo[i][wTime] = 0;
			warInfo[i][wAttacker] = 0;
			warInfo[i][wFaction] = 0;
			Iter_Remove(ServerWars, i);
		}
	}
	return true;
}

CMD:contract(playerid, params[]) {
	if(playerInfo[playerid][pLevel] < 2) return sendPlayerError(playerid, "Nu ai nivel 2 pentru a face acest lucru.");
	extract params -> new player:userID, money; else return sendPlayerSyntax(playerid, "/contract <name/id> <money>");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(Iter_Contains(FactionMembers[10], userID)) return sendPlayerError(playerid, "Acel player face parte din 'Hitman Agency'.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este logat.");
	if(Iter_Contains(Contracts, userID)) return sendPlayerError(playerid, "Acel player deja are contract pe el.");
	if(!(100000 <= money <= 1000000)) return sendPlayerError(playerid, "Invalid money (100,000$ - $1,000,000).");
	new id = Iter_Free(Contracts);
	contractInfo[id][cID] = id;
	contractInfo[id][cAgainst] = userID;
	contractInfo[id][cMoney] = money;
	Iter_Add(Contracts, id);
	GivePlayerCash(playerid, 0, money);
	SCMf(playerid, COLOR_GOLD, "* (Contracts): Ai depus un contract pe %s (%d) in valoare de $%s.", getName(userID), userID, formatNumber(money));
	sendFactionMessage(10, COLOR_LIMEGREEN, "* %s (%d) a depus un contract pe %s (%d) in valoare de $%s.", getName(playerid), playerid, getName(userID), userID, formatNumber(money));
	return true;
}

CMD:gethit(playerid, params[]) {
	if(!Iter_Contains(FactionMembers[10], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'Hitman Agency' pentru a folosi aceasta comanda.");
	if(Iter_Count(Contracts) == 0) return sendPlayerError(playerid, "Nu sunt contracte momentan.");
	new id = Iter_Random(Contracts), Float:x, Float:y, Float:z;
	GetPlayerPos(contractInfo[id][cAgainst], x, y, z);
	Contract[playerid] = contractInfo[id][cAgainst];
	if(!Undercover[playerid]) {
		Undercover[playerid] = true;
		ShowPlayerNameTagForPlayer(contractInfo[id][cAgainst], playerid, false);
		SCM(playerid, COLOR_GOLD, "* (Undercover): {ffffff}Ai fost pus automat undercover.");
	}
	SetPlayerCheckpoint(playerid, x, y, z, 3);
	playerInfo[playerid][pCheckpoint] = CHECKPOINT_GETHIT;
	playerInfo[playerid][pCheckpointID] = contractInfo[id][cAgainst];
	SCMf(playerid, COLOR_GOLD, "* (Contracts): {ffffff}Ai primit un contract pe %s (%d) in valoare de $%s.", getName(contractInfo[Contract[playerid]][cAgainst]), contractInfo[Contract[playerid]][cAgainst], formatNumber(contractInfo[Contract[playerid]][cMoney]));	 
	getHit[playerid] = repeat TimerGetHit(playerid);
	return true;
}

CMD:contracts(playerid, params[]) {
	if(!Iter_Contains(FactionMembers[10], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'Hitman Agency' pentru a folosi aceasta comanda.");
	if(Iter_Count(Contracts) == 0) return sendPlayerError(playerid, "Nu sunt contracte momentan.");
	foreach(new i : Contracts) {
		SCMf(playerid, COLOR_GOLD, "* #%d. %s (%d) - $%s.", contractInfo[i][cID], getName(contractInfo[i][cAgainst]), contractInfo[i][cAgainst], formatNumber(contractInfo[i][cMoney]));
	}
	SCMf(playerid, COLOR_GOLD, "* Sunt %d contracte momentan.", Iter_Count(Contracts));
	return true;
}

timer TimerGetHit[1000](playerid) {
	new Float:x, Float:y, Float:z;
	GetPlayerPos(Contract[playerid], x, y, z);
	SetPlayerCheckpoint(playerid, x, y, z, 3);
	return true;
}

CMD:svf(playerid, params[]) {
	if(!playerInfo[playerid][pFaction]) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda, deoarece nu esti intr-o factiune.");
	if(Iter_Contains(FactionMembers[2], playerid) && Iter_Contains(FactionMembers[3], playerid) && Iter_Contains(FactionMembers[4], playerid) && playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
	if(playerVehicle[playerid] != -1) return sendPlayerError(playerid, "Ai deja un vehicul de factiune spawnat.");
	new szDialog[256];
	strcat(szDialog, "Vehicle\tRank\n");
	switch(playerInfo[playerid][pFaction]) {
		case 1: {
			strcat(szDialog, "Ambulance\tRank 1\nRancher\t Rank 2\n");
		}
		case 2,3,4: {
 			strcat(szDialog, "Police Car\tRank 1\nRancher\tRank 1\nInfernus\tRank 2\n");
		}
		case 5: {
			strcat(szDialog, "Taxi\tRank 1\nSultan\tRank 2\n"); 
		}
		case 6: {
			strcat(szDialog, "Merit\t Rank 1\nSultan\tRank 2\n");
		}
		case 7: {
			strcat(szDialog, "News Van\t Rank 1\nNews Helicopter\tRank 2\n");
		}
		case 8: {
			strcat(szDialog, "Savana\tRank 1\nHuntley\tRank 2\nSultan\tRank 3\n");
		}
		case 9: {
			strcat(szDialog, "Savana\tRank 1\nHuntley\tRank 2\nSultan\tRank 3\n");
		}
		case 10: {
			strcat(szDialog, "Buffalo\tRank 1\nHelicopter\tRank 1\nSultan\tRank 2\n");
		}
	}
	Dialog_Show(playerid, DIALOG_SVF, DIALOG_STYLE_TABLIST_HEADERS, "Spawn Vehicle Faction", szDialog, "Select", "Cancel");
	return true;
}

Dialog:DIALOG_SVF(playerid, response, listitem) {
	if(!response) return true;
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(Iter_Contains(FactionMembers[1], playerid)) {
		if(!IsPlayerInRangeOfPoint(playerid, 35.0,1177.5360,-1339.0680,13.6679)) return sendPlayerError(playerid, "Nu esti in punctul pentru a spawna un vehicul de factiune.");
		switch(listitem) {
			case 0: {
				playerVehicle[playerid] = CreateVehicle(416, X, Y, Z, 269.4354, 1, 3, 120, 1); 
				vehicleRank[playerVehicle[playerid]] = 1;
			}
			case 1: {
				if(playerInfo[playerid][pFactionRank] < 2) return true;
				playerVehicle[playerid] = CreateVehicle(489, X, Y, Z, 269.4354, 1, 3, 120, 1);
				vehicleRank[playerVehicle[playerid]] = 2;
			}
		}
	}
	else if(Iter_Contains(FactionMembers[2], playerid) || Iter_Contains(FactionMembers[3], playerid) || Iter_Contains(FactionMembers[4], playerid)) {
		if(!IsPlayerInRangeOfPoint(playerid, 35.0,1562.7921,-1627.3217,13.1358) && !IsPlayerInRangeOfPoint(playerid, 5.0, 627.4299,-571.7921,17.7155) && !IsPlayerInRangeOfPoint(playerid, 5.0, 2152.3066,-1189.3269,23.8278)) return sendPlayerError(playerid, "Nu esti in punctul pentru a spawna un vehicul de factiune.");
		switch(listitem) {
			case 0: {
				playerVehicle[playerid] = CreateVehicle(596, X, Y, Z, 92.7334, 1, 0, 120, 1);  
				vehicleRank[playerVehicle[playerid]] = 1;
			}
			case 1: {
				playerVehicle[playerid] = CreateVehicle(490, X, Y, Z, 92.7334, 1, 0, 120, 1); 
				vehicleRank[playerVehicle[playerid]] = 1;
			}
			case 2: {
				if(playerInfo[playerid][pFactionRank] < 2) return true;
				playerVehicle[playerid] = CreateVehicle(411, X, Y, Z, 92.7334, 1, 1, 120, 1);	
				svfVehicleObjects[0] = CreateObject(19327, 1534.2373, -1643.2886, 5.9373, -87.6999, 90.4001, -87.1805);
				SetObjectMaterialText(svfVehicleObjects[0], "POLICE", 0, 50, "Arial", 25, 1, -16777216, 0, 1);
				svfVehicleObjects[1] = CreateObject(19419,0.0000, 0.0000, 0.0000, 0.0000, 0.0000, 0.0000);
				AttachObjectToVehicle(svfVehicleObjects[0], playerVehicle[playerid], 0.0, -1.9, 0.3, 270.0, 0.0, 0.0);
				AttachObjectToVehicle(svfVehicleObjects[1], playerVehicle[playerid], 0.0646, 0.1661, 0.6957, 0.0000, 0.0000, 0.0000);	
				vehicleRank[playerVehicle[playerid]] = 2;
			}
		} 
	}
	else if(Iter_Contains(FactionMembers[5], playerid)) {
		if(!IsPlayerInRangeOfPoint(playerid, 35.0,1779.8936,-1896.2695,13.3892)) return sendPlayerError(playerid, "Nu esti in punctul pentru a spawna un vehicul de factiune.");
		switch(listitem) {
			case 0: {
				playerVehicle[playerid] = CreateVehicle(420, X, Y, Z, 268.6326, 6, 6, 120);
				vehicleRank[playerVehicle[playerid]] = 1;
			}
			case 1: {
				if(playerInfo[playerid][pFactionRank] < 2) return true;
				playerVehicle[playerid] = CreateVehicle(560, X, Y, Z, 268.6326, 6, 6, 120);
				vehicleRank[playerVehicle[playerid]] = 2;
			} 
		}
	}
	else if(Iter_Contains(FactionMembers[6], playerid)) {
		if(!IsPlayerInRangeOfPoint(playerid, 35.0,981.7341,-1303.6301,13.3828)) return sendPlayerError(playerid, "Nu esti in punctul pentru a spawna un vehicul de factiune.");
		switch(listitem) {
			case 0: {
				playerVehicle[playerid] = CreateVehicle(551, X, Y, Z, 90, 16, 16, 120);
			 	vehicleRank[playerVehicle[playerid]] = 1;
			}
			case 1: {
				if(playerInfo[playerid][pFactionRank] < 2) return true;
				playerVehicle[playerid] = CreateVehicle(560, X, Y, Z, 90, 16, 16, 120);
				vehicleRank[playerVehicle[playerid]] = 2;
			} 
		}
	}
	else if(Iter_Contains(FactionMembers[7], playerid)) {
		if(!IsPlayerInRangeOfPoint(playerid, 35.0,2161.8660,-1803.5593,13.3791)) return sendPlayerError(playerid, "Nu esti in punctul pentru a spawna un vehicul de factiune.");
		switch(listitem) {
			case 0: {
				playerVehicle[playerid] = CreateVehicle(582, X, Y, Z, 90, 1, 5, 120);
			 	vehicleRank[playerVehicle[playerid]] = 1;
			}
			case 1: {
				if(playerInfo[playerid][pFactionRank] < 2) return true;
				playerVehicle[playerid] = CreateVehicle(488, X, Y, Z, 90, 1, 5, 120);
				vehicleRank[playerVehicle[playerid]] = 2;
			} 
		}
	}
	else if(Iter_Contains(FactionMembers[8], playerid)) {
		if(!IsPlayerInRangeOfPoint(playerid, 35.0,2507.1914,-1684.6974,13.5566)) return sendPlayerError(playerid, "Nu esti in punctul pentru a spawna un vehicul de factiune.");
		switch(listitem) {
			case 0: {
				playerVehicle[playerid] = CreateVehicle(567, X, Y, Z, 90, 4, 4, 120); 
				vehicleRank[playerVehicle[playerid]] = 1;
			}
			case 1: {
				if(playerInfo[playerid][pFactionRank] < 2) return true;
				playerVehicle[playerid] = CreateVehicle(579, X, Y, Z, 90, 4, 4, 120);
				vehicleRank[playerVehicle[playerid]] = 2;
			} 
			case 2: {
				if(playerInfo[playerid][pFactionRank] < 3) return true;
				playerVehicle[playerid] = CreateVehicle(560, X, Y, Z, 90, 4, 4, 120);
				vehicleRank[playerVehicle[playerid]] = 3;
			}
		}
	}
	else if(Iter_Contains(FactionMembers[9], playerid)) {
		if(!IsPlayerInRangeOfPoint(playerid, 35.0,2228.2258,-1342.3315,23.9838)) return sendPlayerError(playerid, "Nu esti in punctul pentru a spawna un vehicul de factiune.");
		switch(listitem) {
			case 0: {
				playerVehicle[playerid] = CreateVehicle(567, X, Y, Z, 90, 85, 85, 120); 
				vehicleRank[playerVehicle[playerid]] = 1;
			}
			case 1: {
				if(playerInfo[playerid][pFactionRank] < 2) return true;
				playerVehicle[playerid] = CreateVehicle(579, X, Y, Z, 90, 85, 85, 120);
				vehicleRank[playerVehicle[playerid]] = 2;
			} 
			case 2: {
				if(playerInfo[playerid][pFactionRank] < 3) return true;
				playerVehicle[playerid] = CreateVehicle(560, X, Y, Z, 90, 85, 85, 120);
				vehicleRank[playerVehicle[playerid]] = 3;
			}
		}
	} 
	else if(Iter_Contains(FactionMembers[10], playerid)) { 
		if(!IsPlayerInRangeOfPoint(playerid, 35.0,1557.0320,-1113.8785,24.0781)) return sendPlayerError(playerid, "Nu esti in punctul pentru a spawna un vehicul de factiune.");
		switch(listitem) {
			case 0: {
				playerVehicle[playerid] = CreateVehicle(402, X, Y, Z, 90, 43, 43, 120); 
				vehicleRank[playerVehicle[playerid]] = 1;
			}
			case 1: {
				playerVehicle[playerid] = CreateVehicle(447, X, Y, Z, 90, 43, 43, 120); 
				vehicleRank[playerVehicle[playerid]] = 1;
			}
			case 2: {
				if(playerInfo[playerid][pFactionRank] < 2) return true;
				playerVehicle[playerid] = CreateVehicle(560, X, Y, Z, 90, 43, 43, 120);
				vehicleRank[playerVehicle[playerid]] = 2;
			}
		}
	}
	SetVehicleNumberPlate(playerVehicle[playerid], string_fast("SVF-%d", playerInfo[playerid][pFaction]));
	PutPlayerInVehicle(playerid, playerVehicle[playerid], 0);
	vehicle_personal[playerVehicle[playerid]] = -1;
	vehicle_fuel[playerVehicle[playerid]] = 100;
	vehicleFaction[playerVehicle[playerid]] = playerInfo[playerid][pFaction];
	vehiclePlayerID[playerVehicle[playerid]] = playerid;
	return true;
}

CMD:setraport(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat pentru a folosi aceasta comanda.");
	if(playerInfo[playerid][pFactionRank] < 7 && playerInfo[playerid][pFaction] == 0) return sendPlayerError(playerid, "Aceasta comanda poate fi folosita doar de la rank 7.");
	extract params -> new rank, cmds; else {
		SCMf(playerid, COLOR_GREY, "Rank 1: %d | Rank 2: %d | Rank 3: %d | Rank 4: %d | Rank 5: %d | Rank 6: %d | Rank 7: %d.", factionInfo[playerInfo[playerid][pFaction]][fCommands][0], factionInfo[playerInfo[playerid][pFaction]][fCommands][1], factionInfo[playerInfo[playerid][pFaction]][fCommands][2], 
		factionInfo[playerInfo[playerid][pFaction]][fCommands][3], factionInfo[playerInfo[playerid][pFaction]][fCommands][4], factionInfo[playerInfo[playerid][pFaction]][fCommands][5], factionInfo[playerInfo[playerid][pFaction]][fCommands][6]);
		return sendPlayerSyntax(playerid, "/setraport <rank> <points>");
	}
	if(rank < 1 || rank > 5) return sendPlayerError(playerid, "Poti seta puncte de raport doar la rank 1-5.");
	SCMf(playerid, COLOR_LIGHTRED, "* Raport:{ffffff} Ai setat cu succes numarul de comenzi la rank %d in %d.", rank, cmds);
	factionInfo[playerInfo[playerid][pFaction]][fCommands][rank-1] = cmds;
	update("UPDATE `server_factions` SET `Commands%d` = '%d' WHERE `ID` = '%d'", rank, cmds, playerInfo[playerid][pFaction]);
	return true;
}

CMD:resetraport(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat pentru a folosi aceasta comanda.");
	if(playerInfo[playerid][pFactionRank] < 7 && playerInfo[playerid][pFaction] == 0) return sendPlayerError(playerid, "Aceasta comanda poate fi folosita doar de la rank 7.");
	new fid = playerInfo[playerid][pFaction];
	foreach(new i : FactionMembers[fid]) {
		playerInfo[i][pCommands] = 0;
		SCMf(i, COLOR_LIGHTRED, "* Raport:{ffffff} Lider %s ti-a resetat raportul.", getName(playerid));
	}
	update("UPDATE `server_users` SET `Commands` = '0' WHERE `Faction` = '%d'", fid);
	return true;
}

CMD:myraport(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat pentru a folosi aceasta comanda.");
	if(playerInfo[playerid][pFaction] == 0) return sendPlayerError(playerid, "Nu ai o factiune.");
	new fid = playerInfo[playerid][pFaction];
	SCMf(playerid, COLOR_LIGHTRED, "*---{ffffff} Raport {FF6347}---*");
	SCMf(playerid, COLOR_LIGHTRED, "Factiune: %s.Rank: %d.Days: %d.", factionName(fid), playerInfo[playerid][pFactionRank], playerInfo[playerid][pFactionAge]);
	SCMf(playerid, COLOR_LIGHTRED, "Puncte de raport:{ffffff} %d/%d.", playerInfo[playerid][pCommands], raportPoints(playerid));
	SCMf(playerid, COLOR_LIGHTRED, "Status raport:{ffffff} %s.", playerInfo[playerid][pCommands] >= raportPoints(playerid) ? "Terminat" : "Neterminat");
	return true;
}

function raportPoints(playerid) {
	new x;
	x = factionInfo[playerInfo[playerid][pFaction]][fCommands][playerInfo[playerid][pFactionRank]-1];
	return x;
}

function addRaportPoint(playerid) {
	playerInfo[playerid][pCommands] ++;
	update("UPDATE `server_users` SET `Commands` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pCommands], playerInfo[playerid][pSQLID]);
	return true;
}
