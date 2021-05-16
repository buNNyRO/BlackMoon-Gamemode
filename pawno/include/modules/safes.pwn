#define MAX_SAFES 15

enum safeEnum{
	sID, 
	sFactionID,
	Float: sPosX, 
	Float: sPosY, 
	Float: sPosZ,
	sMoney, 
	sDrugs, 
	sMaterials, 
	sVirtualID,

	sPickup,
	Text3D:sText
};
new safeInfo[MAX_SAFES + 1][safeEnum], Iterator:FactionSafes<MAX_SAFES + 1>;

stock saveSafe(const id) {
	update("UPDATE `server_safes` SET `Money` = '%d', `Drugs` = '%d', `Materials` = '%d' WHERE `sID` = '%d'", safeInfo[id][sMoney], safeInfo[id][sDrugs], safeInfo[id][sMaterials], safeInfo[id][sID]);
	return true;
}

function LoadSafes() {
	if(!cache_num_rows()) return print("Faction Safes: 0 [From Database]");
	for(new i = 1, j = cache_num_rows() + 1; i != j; i++) {	
		cache_get_value_name_int(i - 1, "ID", safeInfo[i][sID]);
		cache_get_value_name_int(i - 1, "Faction", safeInfo[i][sFactionID]);
		cache_get_value_name_int(i - 1, "Money", safeInfo[i][sMoney]);
		cache_get_value_name_int(i - 1, "Drugs", safeInfo[i][sDrugs]);
		cache_get_value_name_int(i - 1, "Materials", safeInfo[i][sMaterials]);
		cache_get_value_name_int(i - 1, "VirtualWorld", safeInfo[i][sVirtualID]);
		cache_get_value_name_float(i - 1, "X", safeInfo[i][sPosX]);
		cache_get_value_name_float(i - 1, "Y", safeInfo[i][sPosY]);
		cache_get_value_name_float(i - 1, "Z", safeInfo[i][sPosZ]);
		Iter_Add(FactionSafes, i);
		safeInfo[i][sPickup] = CreateDynamicPickup(1274, 23, safeInfo[i][sPosX], safeInfo[i][sPosY], safeInfo[i][sPosZ], safeInfo[i][sVirtualID]);
	    safeInfo[i][sText] = CreateDynamic3DTextLabel(string_fast("Safe Faction %s\n/fdeposit - /fwithdraw", factionName(i-1)), 0xFFEA00FF, safeInfo[i][sPosX],safeInfo[i][sPosY], safeInfo[i][sPosZ], 25.0, 0xFFFF, 0xFFFF, 0, 0, 0, -1, STREAMER_3D_TEXT_LABEL_SD);
		PickInfo[safeInfo[i][sPickup]][SAFE] = i;
	}
	return printf("Faction Safes: %d [From Database]", Iter_Count(FactionSafes));
}

CMD:fdeposit(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0 && playerInfo[playerid][pFactionRank] < 6)
		return true;

	if(playerInfo[playerid][areaSafe] != 0 && IsPlayerInRangeOfPoint(playerid, 3.5, safeInfo[playerInfo[playerid][areaSafe]][sPosX], safeInfo[playerInfo[playerid][areaSafe]][sPosY], safeInfo[playerInfo[playerid][areaSafe]][sPosZ])) {
		if(playerInfo[playerid][pFaction] != safeInfo[playerInfo[playerid][areaSafe]][sFactionID]) return true;
		playerInfo[playerid][pSafeID] = playerInfo[playerid][pFaction];
		Dialog_Show(playerid, DIALOG_FDEPOSIT, DIALOG_STYLE_LIST, "Faction Deposit", "Money\nMaterials\nDrugs", "Select", "Cancel");
	}
	return true;
}

CMD:fwithdraw(playerid, params[]) {
	if(playerInfo[playerid][pFaction] == 0 && playerInfo[playerid][pFactionRank] < 6)
		return true;

	if(playerInfo[playerid][areaSafe] != 0 && IsPlayerInRangeOfPoint(playerid, 3.5, safeInfo[playerInfo[playerid][areaSafe]][sPosX], safeInfo[playerInfo[playerid][areaSafe]][sPosY], safeInfo[playerInfo[playerid][areaSafe]][sPosZ])) {
		if(playerInfo[playerid][pFaction] != safeInfo[playerInfo[playerid][areaSafe]][sFactionID]) return true;
		playerInfo[playerid][pSafeID] = playerInfo[playerid][pFaction];
		Dialog_Show(playerid, DIALOG_FWITHDRAW, DIALOG_STYLE_TABLIST_HEADERS, "Faction Withdraw", string_fast("Option\tResult\nMoney\t$%s\nMaterials\t%s\nDrugs\t%s\n", formatNumber(safeInfo[playerInfo[playerid][areaSafe]][sMoney]), formatNumber(safeInfo[playerInfo[playerid][areaSafe]][sMaterials]), formatNumber(safeInfo[playerInfo[playerid][areaSafe]][sDrugs])), "Select", "Cancel");
	}
	return true;
}

CMD:createsafe(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 6) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	extract params -> new factionID, money, mats, drugs; else return sendPlayerSyntax(playerid, "/createsafe <faction id> <money> <materials> <drugs>");
	if(!Iter_Contains(ServerFactions, factionID)) return sendPlayerError(playerid, "Aceasta factiune nu exista.");
	if(!(0 <= money <= 100000000) && !(0 <= mats <= 1000000) && !(0 <= drugs <= 1000)) return sendPlayerError(playerid, "Invalid money or materials or drugs (Max: $100.000.000 | Materials: 1.000.000 | Drugs: 1.000).");
	new id = Iter_Free(FactionSafes), Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, safeInfo[id][sPosX], safeInfo[id][sPosY], safeInfo[id][sPosZ]);
	safeInfo[id][sID] = id; safeInfo[id][sFactionID] = factionID; safeInfo[id][sMoney] = money; safeInfo[id][sDrugs] = drugs; safeInfo[id][sMaterials] = mats; safeInfo[id][sVirtualID] = GetPlayerVirtualWorld(playerid);
	safeInfo[id][sPickup] = CreateDynamicPickup(1274, 23, safeInfo[id][sPosX], safeInfo[id][sPosY], safeInfo[id][sPosZ], safeInfo[id][sVirtualID]);
    safeInfo[id][sText] = CreateDynamic3DTextLabel(string_fast("Safe Faction %s\n/fdeposit - /fwithdraw", factionName(id-1)), 0xFFEA00FF, safeInfo[id][sPosX],safeInfo[id][sPosY], safeInfo[id][sPosZ], 25.0, 0xFFFF, 0xFFFF, 0, 0, 0, -1, STREAMER_3D_TEXT_LABEL_SD);
	PickInfo[safeInfo[id][sPickup]][SAFE] = id;
	SCMf(playerid, COLOR_SERVER, "* Ai adaugat un seif factiunii %s cu $%s, %d materiale si %d drugs.", factionName(factionID), formatNumber(money), mats, drugs);
	update("INSERT INTO `server_safes` (`Faction`, `Money`, `Drugs`, `Materials`, `VirtualWorld`, `X`, `Y`, `Z`) VALUES ('%d', '%d', '%d', '%d', '%d', '%.2f', '%.2f', '%.2f')", factionID, money, drugs, mats, GetPlayerVirtualWorld(playerid), x, y, z);
	return true;
}

CMD:order(playerid, params[]) {
	if(playerInfo[playerid][pWeaponLicense] == 0) return sendPlayerError(playerid, "Nu ai licenta de 'Gun'.");
	if(playerInfo[playerid][pinFaction] != playerInfo[playerid][pFaction]) return sendPlayerError(playerid, "Nu esti in HQ-ul factiunii tale.");
	if(Iter_Contains(FactionMembers[8], playerid) || Iter_Contains(FactionMembers[9], playerid)) {
		new x = playerInfo[playerid][pFaction], y[3];
		for(new i = 0; i < 5; i++) {
			if(safeInfo[x][sMaterials] < GunOrder[i][2] && safeInfo[x][sMoney] < GunOrder[i][1] || !playerInfo[playerid][pGuns][i]) return true;
			safeInfo[x][sMaterials] -= GunOrder[i][1];
			safeInfo[x][sMoney] -= GunOrder[i][2];
			serverWeapon(playerid, GunOrder[i][0], 60);
			y[0] ++;
			y[1] += GunOrder[i][1];
			y[2] += GunOrder[i][2];
		}
		saveSafe(x);
		SCM(playerid, COLOR_LIGHTRED, string_fast("* (Order Guns):{ffffff} Ai primit '%d' arme si ai dat '%s' materiale si '$%s'.", y[0], formatNumber(y[1]), formatNumber(y[2])));
		return true;
	}
	else if(Iter_Contains(FactionMembers[10], playerid)) {
		new y = playerInfo[playerid][pFaction];
		if(safeInfo[y][sMaterials] < 100 && safeInfo[y][sMoney] < 1000) return true;
		safeInfo[y][sMaterials] -= 100;
		safeInfo[y][sMoney] -= 1000;
		serverWeapon(playerid, 34, 100);
		serverWeapon(playerid, 4, 1);
		saveSafe(y);
		return true;
	}
	return true;
}

Dialog:DIALOG_FWITHDRAW(playerid, response, listitem) {
	if(!response) return true;
	switch(listitem) {
		case 0: Dialog_Show(playerid, DIALOG_FWITHDRAW2, DIALOG_STYLE_INPUT, "Faction Withdraw", "Seiful factiunii are in total: $%s.\nScrie suma pe care vrei sa o scoti mai jos.", "Ok", "Back", formatNumber(safeInfo[playerInfo[playerid][pSafeID]][sMoney]));
		case 1: Dialog_Show(playerid, DIALOG_FWITHDRAW2, DIALOG_STYLE_INPUT, "Faction Withdraw", "Seiful factiunii are in total: %s materiale.\nScrie suma pe care vrei sa o scoti mai jos.", "Ok", "Back", formatNumber(safeInfo[playerInfo[playerid][pSafeID]][sMaterials]));
		case 2: Dialog_Show(playerid, DIALOG_FWITHDRAW2, DIALOG_STYLE_INPUT, "Faction Withdraw", "Seiful factiunii are in total: %s droguri.\nScrie suma pe care vrei sa o scoti mai jos.", "Ok", "Back", formatNumber(safeInfo[playerInfo[playerid][pSafeID]][sDrugs]));
	}
	playerInfo[playerid][pSelectedItem] = listitem;
	return true;
}

Dialog:DIALOG_FWITHDRAW2(playerid, response, listitem, inputtext[]) {
	if(!response) {
		Dialog_Show(playerid, DIALOG_FWITHDRAW, DIALOG_STYLE_TABLIST_HEADERS, "Faction Withdraw", "Option\tResult\nMoney\t$%s\nMaterials\t%s\nDrugs\t%s\n", "Select", "Cancel", formatNumber(safeInfo[playerInfo[playerid][pSafeID]][sMoney]), formatNumber(safeInfo[playerInfo[playerid][pSafeID]][sMaterials]), formatNumber(safeInfo[playerInfo[playerid][pSafeID]][sDrugs]));
		return true;
	}	
	switch(playerInfo[playerid][pSelectedItem]) {
		case 0: {
			if(safeInfo[playerInfo[playerid][pSafeID]][sMoney] < strval(inputtext) || strval(inputtext) <= 0) return sendPlayerError(playerid, "Suma invalida.");
			safeInfo[playerInfo[playerid][pSafeID]][sMoney] -= strval(inputtext);
			GivePlayerCash(playerid, 1, strval(inputtext));
			sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "(-) %s a luat $%s din seiful factiunii.", getName(playerid), formatNumber(strval(inputtext)));
		}
		case 1: {
			if(safeInfo[playerInfo[playerid][pSafeID]][sMaterials] < strval(inputtext) || strval(inputtext) <= 0) return sendPlayerError(playerid, "Suma invalida.");
			safeInfo[playerInfo[playerid][pSafeID]][sMaterials] -= strval(inputtext);
			playerInfo[playerid][pMats] += strval(inputtext);
			update("UPDATE `server_users` SET `Mats` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pMats], playerInfo[playerid][pSQLID]);
			sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "(-) %s a luat %s materiale din seiful factiunii.", getName(playerid), formatNumber(strval(inputtext)));
		}
		case 2: {
			if(safeInfo[playerInfo[playerid][pSafeID]][sDrugs] < strval(inputtext) || strval(inputtext) <= 0) return sendPlayerError(playerid, "Suma invalida.");
			safeInfo[playerInfo[playerid][pSafeID]][sDrugs] -= strval(inputtext);
			playerInfo[playerid][pDrugs] += strval(inputtext);
			update("UPDATE `server_users` SET `Drugs` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pDrugs], playerInfo[playerid][pSQLID]);
			sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "(-) %s a luat %s droguri din seiful factiunii.", getName(playerid), formatNumber(strval(inputtext)));
		}
	}
	saveSafe(playerInfo[playerid][pSafeID]);	
	return true;
}

Dialog:DIALOG_FDEPOSIT(playerid, response, listitem) {
	if(!response) return true;
	switch(listitem) {
		case 0: Dialog_Show(playerid, DIALOG_FDEPOSIT2, DIALOG_STYLE_INPUT, "Faction Deposit", "Scrie suma de bani pe care vrei sa o introduci in seiful factiunii tale.", "Ok", "Back");
		case 1: Dialog_Show(playerid, DIALOG_FDEPOSIT2, DIALOG_STYLE_INPUT, "Faction Deposit", "Scrie suma de materiale pe care vrei sa o introduci in seiful factiunii tale.", "Ok", "Back");
		case 2: Dialog_Show(playerid, DIALOG_FDEPOSIT2, DIALOG_STYLE_INPUT, "Faction Deposit", "Scrie suma de droguri pe care vrei sa o introduci in seiful factiunii tale.", "Ok", "Back");
	}
	playerInfo[playerid][pSelectedItem] = listitem;
	return true;
}

Dialog:DIALOG_FDEPOSIT2(playerid, response, listitem, inputtext[]) {
	if(!response) {
		Dialog_Show(playerid, DIALOG_FDEPOSIT, DIALOG_STYLE_LIST, "Faction Deposit", "Money\nMaterials\nDrugs", "Select", "Cancel");
		return true;
	}
	switch(playerInfo[playerid][pSelectedItem]) {
		case 0: {
			if(PlayerMoney(playerid, strval(inputtext)) || strval(inputtext) <= 0) return sendPlayerError(playerid, "Suma invalida.");
			safeInfo[playerInfo[playerid][pSafeID]][sMoney] += strval(inputtext);
			GivePlayerCash(playerid, 0, strval(inputtext));
			sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "* %s a depozitat $%s in seiful factiunii.", getName(playerid), formatNumber(strval(inputtext)));
		}
		case 1: {
			if(playerInfo[playerid][pMats] < strval(inputtext) || strval(inputtext) <= 0) return sendPlayerError(playerid, "Suma invalida.");
			safeInfo[playerInfo[playerid][pSafeID]][sMaterials] += strval(inputtext);
			playerInfo[playerid][pMats] -= strval(inputtext);
			update("UPDATE `server_users` SET `Mats` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pMats], playerInfo[playerid][pSQLID]);
			sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "* %s a depozitat %s materiale in seiful factiunii.", getName(playerid), formatNumber(strval(inputtext)));
		}
		case 2: {
			if(playerInfo[playerid][pDrugs] < strval(inputtext) || strval(inputtext) <= 0) return sendPlayerError(playerid, "Suma invalida.");
			safeInfo[playerInfo[playerid][pSafeID]][sDrugs] += strval(inputtext);
			playerInfo[playerid][pDrugs] -= strval(inputtext);
			update("UPDATE `server_users` SET `Drugs` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pDrugs], playerInfo[playerid][pSQLID]);
			sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "* %s a depozitat %s droguri in seiful factiunii.", getName(playerid), formatNumber(strval(inputtext)));
		}			
	}
	saveSafe(playerInfo[playerid][pSafeID]);	
	return true;
}