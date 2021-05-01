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
	}
	return printf("Faction Safes: %d [From Database]", Iter_Count(FactionSafes));
}

CMD:fdeposit(playerid, params[]) {
	for(new s = 0; s < Iter_Count(FactionSafes); s++) {
		if(!PlayerToPoint(5, playerid, safeInfo[s][sPosX], safeInfo[s][sPosY], safeInfo[s][sPosZ]))
			continue;

		if(playerInfo[playerid][pFaction] != safeInfo[s][sFactionID])
			continue;

		playerInfo[playerid][pSafeID] = playerInfo[playerid][pFaction];
		Dialog_Show(playerid, DIALOG_FDEPOSIT, DIALOG_STYLE_LIST, "Faction Deposit", "Money\nMaterials\nDrugs", "Select", "Cancel");
	}
	return true;
}

CMD:fwithdraw(playerid, params[]) {
	if(playerInfo[playerid][pFactionRank] < 6)
		return true;

	for(new s = 0; s < Iter_Count(FactionSafes); s++) {
		if(!PlayerToPoint(5, playerid, safeInfo[s][sPosX], safeInfo[s][sPosY], safeInfo[s][sPosZ]))
			continue;

		if(playerInfo[playerid][pFaction] != safeInfo[s][sFactionID])
			continue;
		playerInfo[playerid][pSafeID] = playerInfo[playerid][pFaction];
		Dialog_Show(playerid, DIALOG_FWITHDRAW, DIALOG_STYLE_TABLIST_HEADERS, "Faction Withdraw", string_fast("Option\tResult\nMoney\t$%s\nMaterials\t%s\nDrugs\t%s\n", formatNumber(safeInfo[s][sMoney]), formatNumber(safeInfo[s][sMaterials]), formatNumber(safeInfo[s][sDrugs])), "Select", "Cancel");
	}
	return true;
}

Dialog:DIALOG_FWITHDRAW(playerid, response, listitem) {
	if(!response) return true;
	switch(listitem) {
		case 0: Dialog_Show(playerid, DIALOG_FWITHDRAW2, DIALOG_STYLE_INPUT, "Faction Withdraw", string_fast("Seiful factiunii are in total: $%s.\nScrie suma pe care vrei sa o scoti mai jos.", formatNumber(safeInfo[playerInfo[playerid][pSafeID]][sMoney])), "Ok", "Back");
		case 1: Dialog_Show(playerid, DIALOG_FWITHDRAW2, DIALOG_STYLE_INPUT, "Faction Withdraw", string_fast("Seiful factiunii are in total: %s materiale.\nScrie suma pe care vrei sa o scoti mai jos.", formatNumber(safeInfo[playerInfo[playerid][pSafeID]][sMaterials])), "Ok", "Back");
		case 2: Dialog_Show(playerid, DIALOG_FWITHDRAW2, DIALOG_STYLE_INPUT, "Faction Withdraw", string_fast("Seiful factiunii are in total: %s droguri.\nScrie suma pe care vrei sa o scoti mai jos.", formatNumber(safeInfo[playerInfo[playerid][pSafeID]][sDrugs])), "Ok", "Back");
	}
	playerInfo[playerid][pSelectedItem] = listitem;
	return true;
}

Dialog:DIALOG_FWITHDRAW2(playerid, response, listitem, inputtext[]) {
	if(!response) {
		Dialog_Show(playerid, DIALOG_FWITHDRAW, DIALOG_STYLE_TABLIST_HEADERS, "Faction Withdraw", string_fast("Option\tResult\nMoney\t$%s\nMaterials\t%s\nDrugs\t%s\n", formatNumber(safeInfo[playerInfo[playerid][pSafeID]][sMoney]), formatNumber(safeInfo[playerInfo[playerid][pSafeID]][sMaterials]), formatNumber(safeInfo[playerInfo[playerid][pSafeID]][sDrugs])), "Select", "Cancel");
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