#define MAX_HOUSES (50) 
#define HOUSE_STREAMER_START 0

enum houseInfoEnum {
	hID,
	hTitle[32 + 1],
	hDescription[64 + 1],
	Float:hExtX,
	Float:hExtY,
	Float:hExtZ,
	Float:hX,
	Float:hY,
	Float:hZ,
	hInterior,
	hLocked,
	hPrice,
	hBalance,
	hOwner[32 + 1],
	hOwnerID,
	hOwned,
	hRentabil,
	hRenters,
	hUpgrade,
	hRentPrice,

	Text3D:hText,
	hPickup,
	hArea
};
new houseInfo[MAX_HOUSES + 1][houseInfoEnum], Iterator:ServerHouses<MAX_HOUSES + 1>, Iterator:RentersHouses[MAX_HOUSES]<MAX_HOUSES +1>, IDSelected[MAX_PLAYERS];

new Float:smallInteriors[5][4] = {
	{344.0841,305.0070,999.1484},
	{300.1171,313.8122,999.1484},
	{243.8739,304.9345,999.1484},
	{266.8921,304.9582,999.1484},
	{318.6140,1114.8862,1083.8828} 
};

new Float:mediumInteriors[5][4] = {
	{295.1721,1472.6118,1080.2578}, 
	{83.0220,1322.5667,1083.8662}, 
	{260.8042,1237.5881,1084.2578},
	{-42.6543,1405.6503,1084.4297},
	{-68.8472,1351.6719,1080.2109} 
};

new Float:bigInteriors[5][4] = {
	{2495.9067,-1692.4989,1014.7422},
	{-2636.6682,1402.8861,906.4609}, 
	{2324.4609,-1149.1307,1050.7101}, 
	{2807.6873,-1174.2528,1025.5703}, 
	{940.8005,-18.5781,1000.9297} 
};

new smallInteriorsID[5][1] = { {6}, {4}, {1}, {2}, {5} };
new mediumInteriorsID[5][1] = { {15}, {9}, {9}, {8}, {6} };
new bigInteriorsID[5][1] = { {3}, {3}, {12}, {8}, {3} };

hook OnGameModeInit() {
	Iter_Init(ServerHouses);
	return true;
}

hook OnPlayerConnect(playerid) {
	IDSelected[playerid] = -1;
	if(playerInfo[playerid][pRent] != -1) Iter_Add(RentersHouses[playerInfo[playerid][pRent]], playerid);
	return true;
}

function LoadHouses() {
	if(!cache_num_rows()) return print("Houses: 0 [From Database]");

	for(new i = 1, j = cache_num_rows() + 1; i != j; i++) {	
		Iter_Add(ServerHouses, i);
		cache_get_value_name(i - 1, "Title", houseInfo[i][hTitle], 32);
		cache_get_value_name(i - 1, "Description", houseInfo[i][hDescription], 64);
		cache_get_value_name(i - 1, "Owner", houseInfo[i][hOwner], 32);	
		cache_get_value_name_int(i - 1, "ID", houseInfo[i][hID]);	
		cache_get_value_name_float(i - 1, "ExtX", houseInfo[i][hExtX]);	
		cache_get_value_name_float(i - 1, "ExtY", houseInfo[i][hExtY]);
		cache_get_value_name_float(i - 1, "ExtZ", houseInfo[i][hExtZ]);
		cache_get_value_name_float(i - 1, "X", houseInfo[i][hX]);
		cache_get_value_name_float(i - 1, "Y", houseInfo[i][hY]);
		cache_get_value_name_float(i - 1, "Z", houseInfo[i][hZ]);
		cache_get_value_name_int(i - 1, "Interior", houseInfo[i][hInterior]);
		cache_get_value_name_int(i - 1, "Locked", houseInfo[i][hLocked]);
		cache_get_value_name_int(i - 1, "Price", houseInfo[i][hPrice]);
		cache_get_value_name_int(i - 1, "Balance", houseInfo[i][hBalance]);
		cache_get_value_name_int(i - 1, "OwnerID", houseInfo[i][hOwnerID]);
		cache_get_value_name_int(i - 1, "Owned", houseInfo[i][hOwned]);
		cache_get_value_name_int(i - 1, "Rentabil", houseInfo[i][hRentabil]);
		cache_get_value_name_int(i - 1, "Renters", houseInfo[i][hRenters]);
		cache_get_value_name_int(i - 1, "Upgrade", houseInfo[i][hUpgrade]);
		cache_get_value_name_int(i - 1, "RentPrice", houseInfo[i][hRentPrice]);

		new rent[75];
		format(rent, sizeof(rent), "\nRent Price: $%s\nType '/rentroom' to rent a room", formatNumber(houseInfo[i][hRentPrice]));
		houseInfo[i][hText] = CreateDynamic3DTextLabel(string_fast("House ID: %d\nHouse Title: %s\nHouse Description: %s\nOwner: %s\nPrice: $%s%s", houseInfo[i][hID], houseInfo[i][hTitle], houseInfo[i][hDescription], houseInfo[i][hOwner], formatNumber(houseInfo[i][hPrice]),(houseInfo[i][hRentPrice] ? rent : "")), -1, houseInfo[i][hExtX],houseInfo[i][hExtY],houseInfo[i][hExtZ], 20.0, 0xFFFF, 0xFFFF, 0, 0, 0, -1, STREAMER_3D_TEXT_LABEL_SD);
		houseInfo[i][hPickup] = CreateDynamicPickup((houseInfo[i][hPrice] ? 1272 : 1273), 23, houseInfo[i][hExtX],houseInfo[i][hExtY],houseInfo[i][hExtZ], 0, 0, -1, STREAMER_PICKUP_SD);					
		PickInfo[houseInfo[i][hPickup]][HOUSE] = i;
		houseInfo[i][hArea] = CreateDynamicSphere(houseInfo[i][hExtX],houseInfo[i][hExtY],houseInfo[i][hExtZ], 2.0, 0, 0);
		Streamer_SetIntData(STREAMER_TYPE_AREA, houseInfo[i][hArea], E_STREAMER_EXTRA_ID, (i + HOUSE_STREAMER_START));
		CreateDynamicMapIcon(houseInfo[i][hExtX],houseInfo[i][hExtY],houseInfo[i][hExtZ],(houseInfo[i][hPrice] ? 31 : 32),0,-1,-1,-1,750.0); 	
	}
	return printf("Houses: %d [From Database]", Iter_Count(ServerHouses));
}


Dialog:SELL_HOUSE_STATE(playerid, response) {
	if(!response) return true;
	if(strcmp(getName(playerid), houseInfo[playerInfo[playerid][pHouseID]][hOwner], true) == 0) {	
		new houseid = playerInfo[playerid][pHouseID], cash = 200000;
		houseInfo[houseid][hOwned] = 0;
		houseInfo[houseid][hPrice] = 0;
		houseInfo[houseid][hOwnerID] = -1;
		format(houseInfo[houseid][hOwner], 32, "AdmBot");
		update("UPDATE `server_houses` SET `Owned`='0',`Owner`='AdmBot',`OwnerID`='-1',`Price`='0' WHERE `ID`='%d' LIMIT 1",houseid);
		Update3DTextLabelText(houseInfo[houseid][hText], COLOR_WHITE, string_fast("House ID: %d\nHouse Title: %s\nHouse Description: %s\nOwner: %s\nPrice: $%s%s", houseInfo[houseid][hID], houseInfo[houseid][hTitle], houseInfo[houseid][hDescription], houseInfo[houseid][hOwner], formatNumber(houseInfo[houseid][hPrice]), formatNumber(houseInfo[houseid][hRentPrice])));
		GivePlayerCash(playerid, 1, cash);
		playerInfo[playerid][pHouse] = 0;
		playerInfo[playerid][pHouseID] = -1;
		playerInfo[playerid][pSpawnChange] = 1;
		update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d', `House` = '0', `HouseID` = '-1', `SpawnChange` = '1' WHERE `ID` = '%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSQLID]);
		SCM(playerid, COLOR_GREY, "* House Notice: Ti-ai vandut cu succes casa la stat, si ai primit $200,000.");		
	}
	return true;
}

Dialog:HOUSE_OPTION(playerid, response, listitem) {
	if(!response) return true;
	switch(listitem) {
		case 0: Dialog_Show(playerid, HOUSE_OPTION_TITLE, DIALOG_STYLE_INPUT, "House: Option", "Introdu mai jos ce titlu doresti sa aiba casa ta", "Ok", "Cancel");
		case 1: Dialog_Show(playerid, HOUSE_OPTION_DESCRIPTION, DIALOG_STYLE_INPUT, "House: Description", "Introdu mai jos ce descriere doresti sa aiba casa ta", "Ok", "Cancel");
	}
	return true;
}

Dialog:HOUSE_OPTION_TITLE(playerid, response, listitem, inputtext[]) {
	if(!response) return true;
	if(strlen(inputtext) < 3 || strlen(inputtext) > 32) return  Dialog_Show(playerid, HOUSE_OPTION_TITLE, DIALOG_STYLE_INPUT, "House: Title", "Introdu mai jos ce titlu doresti sa aiba casa ta\nMinim 3 caractere / Maxim 32 de caractere.", "Ok", "Cancel");
	new houseid = playerInfo[playerid][pHouseID];
	format(houseInfo[houseid][hTitle], 32, inputtext);
	SCM(playerid, COLOR_GREY, string_fast("* House Notice: Ai schimbat titlul casei tale, in '%s'.", inputtext));
	update("UPDATE `server_houses` SET `Title`='%s'  WHERE `ID`='%d' LIMIT 1", inputtext, houseid);
	Update3DTextLabelText(houseInfo[houseid][hText], COLOR_WHITE, string_fast("House ID: %d\nHouse Title: %s\nHouse Description: %s\nOwner: %s\nPrice: $%s%s", houseInfo[houseid][hID], houseInfo[houseid][hTitle], houseInfo[houseid][hDescription], houseInfo[houseid][hOwner], formatNumber(houseInfo[houseid][hPrice]), formatNumber(houseInfo[houseid][hRentPrice])));	
	return true;
}

Dialog:HOUSE_OPTION_DESCRIPTION(playerid, response, listitem,  inputtext[]) {
	if(!response) return true;
	if(strlen(inputtext) < 3 || strlen(inputtext) > 64) return Dialog_Show(playerid, HOUSE_OPTION_DESCRIPTION, DIALOG_STYLE_INPUT, "House: Description", "Introdu mai jos ce descriere doresti sa aiba casa ta\nMinim 3 caractere / Maxim 64 de caractere.", "Ok", "Cancel");
	new houseid = playerInfo[playerid][pHouseID];
	format(houseInfo[houseid][hDescription], 64, inputtext);	
	SCM(playerid, COLOR_GREY, string_fast("* House Notice: Ai schimbat descrierea casei tale, in '%s'.", inputtext));
	update("UPDATE `server_houses` SET `Description`='%s'  WHERE `ID`='%d' LIMIT 1", inputtext, houseid);
	Update3DTextLabelText(houseInfo[houseid][hText], COLOR_WHITE, string_fast("House ID: %d\nHouse Title: %s\nHouse Description: %s\nOwner: %s\nPrice: $%s%s", houseInfo[houseid][hID], houseInfo[houseid][hTitle], houseInfo[houseid][hDescription], houseInfo[houseid][hOwner], formatNumber(houseInfo[houseid][hPrice]), formatNumber(houseInfo[houseid][hRentPrice])));
	return true;
}

Dialog:HOUSE_OPTION_ADMIN(playerid, response, listitem) {
	if(!response) return true;
	switch(listitem) {
		case 0: Dialog_Show(playerid, HOUSE_OPTION_TITLEADMIN, DIALOG_STYLE_INPUT, "House: Title", "Introdu mai jos ce titlu doresti sa aiba casa", "Ok", "Cancel");
		case 1: Dialog_Show(playerid, HOUSE_OPTION_DESCADMIN, DIALOG_STYLE_INPUT, "House: Description", "Introdu mai jos ce descriere doresti sa aiba casa", "Ok", "Cancel");
	}
	return true;
}

Dialog:HOUSE_OPTION_TITLEADMIN(playerid, response, listitem, inputtext[]) {
	if(!response) return true;
	if(strlen(inputtext) < 3 || strlen(inputtext) > 32) return Dialog_Show(playerid, HOUSE_OPTION_TITLEADMIN, DIALOG_STYLE_INPUT, "House: Title", "Introdu mai jos ce titlu doresti sa aiba casa\nMinim 3 caractere / Maxim 32 caractere.", "Ok", "Cancel");
	format(houseInfo[IDSelected[playerid]][hTitle], 32, inputtext);
	update("UPDATE `server_houses` SET `Title`='%s'  WHERE `ID`='%d' LIMIT 1", inputtext, IDSelected[playerid]);
	Update3DTextLabelText(houseInfo[IDSelected[playerid]][hText], COLOR_WHITE, string_fast("House ID: %d\nHouse Title: %s\nHouse Description: %s\nOwner: %s\nPrice: $%s%s", houseInfo[IDSelected[playerid]][hID], houseInfo[IDSelected[playerid]][hTitle], houseInfo[IDSelected[playerid]][hDescription], houseInfo[IDSelected[playerid]][hOwner], formatNumber(houseInfo[IDSelected[playerid]][hPrice]), formatNumber(houseInfo[IDSelected[playerid]][hRentPrice])));	
	IDSelected[playerid] = -1;
	return true;
}

Dialog:HOUSE_OPTION_DESCADMIN(playerid, response, listitem, inputtext[]) {
	if(!response) return true;
	if(strlen(inputtext) < 3 || strlen(inputtext) > 64) return Dialog_Show(playerid, HOUSE_OPTION_DESCADMIN, DIALOG_STYLE_INPUT, "House: Description", "Introdu mai jos ce descriere doresti sa aiba casa\nMinim 3 caractere / Maxim 64 caractere.", "Ok", "Cancel");
	format(houseInfo[IDSelected[playerid]][hDescription], 64, inputtext);
	update("UPDATE `server_houses` SET `Description`='%s'  WHERE `ID`='%d' LIMIT 1", inputtext, IDSelected[playerid]);
	Update3DTextLabelText(houseInfo[IDSelected[playerid]][hText], COLOR_WHITE, string_fast("House ID: %d\nHouse Title: %s\nHouse Description: %s\nOwner: %s\nPrice: $%s%s", houseInfo[IDSelected[playerid]][hID], houseInfo[IDSelected[playerid]][hTitle], houseInfo[IDSelected[playerid]][hDescription], houseInfo[IDSelected[playerid]][hOwner], formatNumber(houseInfo[IDSelected[playerid]][hPrice]), formatNumber(houseInfo[IDSelected[playerid]][hRentPrice])));	
	IDSelected[playerid] = -1;
	return true;
}

CMD:buyhouse(playerid, params[]) {
	if(playerInfo[playerid][pHouse] != 0) return sendPlayerError(playerid, "Ai deja o casa cumparata.");
	if(playerInfo[playerid][pLevel] < 5) return sendPlayerError(playerid, "Trebuie sa detii, minim level 5.");
	if(playerInfo[playerid][areaHouse] != 0 && IsPlayerInRangeOfPoint(playerid, 3.5, houseInfo[playerInfo[playerid][areaHouse]][hExtX], houseInfo[playerInfo[playerid][areaHouse]][hExtY], houseInfo[playerInfo[playerid][areaHouse]][hExtZ])) {
		if(houseInfo[playerInfo[playerid][areaHouse]][hPrice] == 0) return sendPlayerError(playerid, "Aceasta casa nu este de vanzare.");
		if(houseInfo[playerInfo[playerid][areaHouse]][hOwned] == 1) {
			new id = GetPlayerID(houseInfo[playerInfo[playerid][areaHouse]][hOwner]), moneys, newmoneys;
			gString[0] = (EOS);
			if(id != INVALID_PLAYER_ID) { 
				playerInfo[id][pHouse] = 0;
				playerInfo[id][pHouseID] = -1;
				playerInfo[id][pBank] += houseInfo[playerInfo[playerid][areaHouse]][hPrice];
				SCM(playerid, COLOR_GREY, string_fast("* House Notice: %s ti-a cumparat casa, si ai primit $%s, in banca.", getName(playerid), formatNumber(houseInfo[playerInfo[playerid][areaHouse]][hPrice])));
				update("UPDATE `server_users` SET `Bank` = '%d', `House` = '0', `HouseID` = '-1' WHERE `ID` = '%d'", playerInfo[id][pBank], playerInfo[id][pSQLID]);
			}
			else {
				new Cache: result = mysql_query(SQL, string_fast("SELECT * FROM `server_users` WHERE `Name` = '%s'", houseInfo[playerInfo[playerid][areaHouse]][hOwner]));
				if(cache_num_rows() != 0) {
					cache_get_value_name(0, "Bank", gString); moneys = strval(gString);
					newmoneys = moneys + houseInfo[playerInfo[playerid][areaHouse]][hPrice];
				}
				cache_delete(result);
				update("UPDATE `server_users` SET `Bank` = '%d', `House` = '0', `HouseID` = '-1' WHERE `ID` = '%d'", newmoneys, playerInfo[id][pSQLID]);
			}
			SCM(playerid, COLOR_GREY, string_fast("* House Notice: Felicitari ! Ai cumparat casa cu id %d, si ai platit $%s.", playerInfo[playerid][areaHouse], formatNumber(houseInfo[playerInfo[playerid][areaHouse]][hPrice])));
			GivePlayerCash(playerid, 0, houseInfo[playerInfo[playerid][areaHouse]][hPrice]);
			format(houseInfo[playerInfo[playerid][areaHouse]][hOwner], 32, getName(playerid));
			playerInfo[playerid][pHouse] = 1;
			playerInfo[playerid][pHouseID] = playerInfo[playerid][areaHouse];
			playerInfo[playerid][pSpawnChange] = 2;
			houseInfo[playerInfo[playerid][areaHouse]][hOwned] = 1;
			houseInfo[playerInfo[playerid][areaHouse]][hPrice] = 0;
			Update3DTextLabelText(houseInfo[playerInfo[playerid][areaHouse]][hText], COLOR_WHITE, string_fast("House ID: %d\nHouse Title: %s\nHouse Description: %s\nOwner: %s\nPrice: $%s%s", houseInfo[playerInfo[playerid][areaHouse]][hID], houseInfo[playerInfo[playerid][areaHouse]][hTitle], houseInfo[playerInfo[playerid][areaHouse]][hDescription], houseInfo[playerInfo[playerid][areaHouse]][hOwner], formatNumber(houseInfo[playerInfo[playerid][areaHouse]][hPrice]), formatNumber(houseInfo[playerInfo[playerid][areaHouse]][hRentPrice])));
			update("UPDATE `server_users` SET `House` = '1', `HouseID` = '%d', `SpawnChange` = '2' WHERE `ID` = '%d'", playerInfo[playerid][areaHouse], playerInfo[playerid][pSQLID]);
			update("UPDATE `server_houses` SET `Owned`='1',`Owner`='%s',`OwnerID`='%d',`Price`='0' WHERE `ID`='%d'",houseInfo[playerInfo[playerid][areaHouse]][hOwner], playerInfo[playerid][pSQLID], playerInfo[playerid][areaHouse]);
		}
		else if(houseInfo[playerInfo[playerid][areaHouse]][hOwned] == 0) {
			SCM(playerid, COLOR_GREY, string_fast("* House Notice: Felicitari ! Ai cumparat casa cu id %d, si ai platit $%s.", playerInfo[playerid][areaHouse], formatNumber(houseInfo[playerInfo[playerid][areaHouse]][hPrice])));
			GivePlayerCash(playerid, 0, houseInfo[playerInfo[playerid][areaHouse]][hPrice]);
			format(houseInfo[playerInfo[playerid][areaHouse]][hOwner], 32, getName(playerid));
			playerInfo[playerid][pHouse] = 1;
			playerInfo[playerid][pHouseID] = playerInfo[playerid][areaHouse];
			playerInfo[playerid][pMoney] -= houseInfo[playerInfo[playerid][areaHouse]][hPrice];
			playerInfo[playerid][pSpawnChange] = 2;
			houseInfo[playerInfo[playerid][areaHouse]][hOwned] = 1;
			houseInfo[playerInfo[playerid][areaHouse]][hPrice] = 0;
			Update3DTextLabelText(houseInfo[playerInfo[playerid][areaHouse]][hText], COLOR_WHITE, string_fast("House ID: %d\nHouse Title: %s\nHouse Description: %s\nOwner: %s\nPrice: $%s%s", houseInfo[playerInfo[playerid][areaHouse]][hID], houseInfo[playerInfo[playerid][areaHouse]][hTitle], houseInfo[playerInfo[playerid][areaHouse]][hDescription], houseInfo[playerInfo[playerid][areaHouse]][hOwner], formatNumber(houseInfo[playerInfo[playerid][areaHouse]][hPrice]), formatNumber(houseInfo[playerInfo[playerid][areaHouse]][hRentPrice])));
			update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d' `House` = '1', `HouseID` = '%d', `SpawnChange` = '2' WHERE `ID` = '%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][areaHouse], playerInfo[playerid][pSQLID]);
			update("UPDATE `server_houses` SET `Owned`='1',`Owner`='%s',`OwnerID`='%d',`Price`='0' WHERE `ID`='%d'",houseInfo[playerInfo[playerid][areaHouse]][hOwner],playerInfo[playerid][pSQLID], playerInfo[playerid][areaHouse]);
		}
	}
	return true;
}

CMD:sellhousestate(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti face aceasta actiune, deoarece esti in masina.");
	if(GetPlayerVirtualWorld(playerid) != 0 && GetPlayerInterior(playerid) != 0 && playerInfo[playerid][pinHouse] != -1) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda deoarece, esti intr-un alt virtualworld / interior / esti intr-o casa.");
	if(playerInfo[playerid][pHouse] == 0 && playerInfo[playerid][pHouseID] == -1) return sendPlayerError(playerid, "Nu detii o afacere.");
	Dialog_Show(playerid, SELL_HOUSE_STATE, DIALOG_STYLE_MSGBOX, "House:", "Esti sigur ca doresti sa-ti vinzi casa, pe $200,000?\nDaca apesi pe butonul 'da', nu mai exista cale de intoarcere.", "Da", "Nu");
	return true;
}

CMD:housebalance(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pHouse] == 0 && playerInfo[playerid][pHouseID] == -1) return sendPlayerError(playerid, "Nu detii o casa.");
	new houseid = playerInfo[playerid][pHouseID];
	SCM(playerid, COLOR_GREY, string_fast("* House Notice: Balanta ta la afacere este de $%s.", formatNumber(houseInfo[houseid][hBalance])));
	return true;
}

CMD:housewithdraw(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pHouse] == 0 && playerInfo[playerid][pHouseID] == -1) return sendPlayerError(playerid, "Nu detii o casa.");
	new houseid = playerInfo[playerid][pHouseID], suma;
	if(playerInfo[playerid][pinHouse] != houseid) return sendPlayerError(playerid, "Poti folosi aceasta comanda doar din interiorul casei tale.");
	if(sscanf(params, "d", suma)) {
		sendPlayerSyntax(playerid, "/housewithdraw <Suma>");
		SCM(playerid, COLOR_GREY, string_fast("* House Notice: Balanta ta la afacere este de $%s.", formatNumber(houseInfo[houseid][hBalance])));
		return true;
	}
	if(houseInfo[houseid][hBalance] < suma) return sendPlayerError(playerid, "Nu ai suma aceasta de bani in balanta casei tale.");
	houseInfo[houseid][hBalance] -= suma;
	GivePlayerCash(playerid, 1, suma);
	mysql_format(SQL, gQuery, sizeof(gQuery),"UPDATE `server_houses` SET `Balance`='%d'  WHERE `ID`='%d' LIMIT 1", houseInfo[houseid][hBalance], houseid);
	mysql_tquery(SQL, gQuery, "", "");	
	SCM(playerid, COLOR_GREY, string_fast("* House Notice: Ai retras din balanta casei tale, $%s. Iar acum balanta casei tale este de $%s.", formatNumber(suma), formatNumber(houseInfo[houseid][hBalance])));	
	return true;
}

CMD:housedeposit(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pHouse] == 0 && playerInfo[playerid][pHouseID] == -1) return sendPlayerError(playerid, "Nu detii o casa.");
	new houseid = playerInfo[playerid][pHouseID], suma;
	if(playerInfo[playerid][pinHouse] != houseid) return sendPlayerError(playerid, "Poti folosi aceasta comanda doar din interiorul casei tale.");
	if(sscanf(params, "d", suma)) return sendPlayerSyntax(playerid, "/housedeposit <Suma>");
	if(GetPlayerCash(playerid) < suma) return sendPlayerError(playerid, "Nu ai suma aceasta de bani, pentru a adauga in balanta casei tale.");
	houseInfo[houseid][hBalance] += suma;
	GivePlayerCash(playerid, 0, suma);
	mysql_format(SQL, gQuery, sizeof(gQuery),"UPDATE `server_houses` SET `Balance`='%d'  WHERE `ID`='%d' LIMIT 1", houseInfo[houseid][hBalance], houseid);
	mysql_tquery(SQL, gQuery, "", "");	
	SCM(playerid, COLOR_GREY, string_fast("* House Notice: Ai bagat in balanta casei tale, $%s. Iar acum balanta casei tale este de $%s.", formatNumber(suma), formatNumber(houseInfo[houseid][hBalance])));	
	return true;
}

CMD:houseoption(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pHouse] == 0 && playerInfo[playerid][pHouseID] == -1) return sendPlayerError(playerid, "Nu detii o casa.");
	if(Dialog_Opened(playerid)) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda cat timp ai un dialog afisat.");
	Dialog_Show(playerid, HOUSE_OPTION, DIALOG_STYLE_TABLIST_HEADERS, "House:", "Option Name\tOption\nTitle\tSchimba Titlul Casei\nDescription\tSchimba Descrierea Casei", "Select", "Close");	
	return true;
}

CMD:hlock(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pHouse] == 0 && playerInfo[playerid][pHouseID] == -1) return sendPlayerError(playerid, "Nu detii o casa.");
	new houseid = playerInfo[playerid][pHouseID];
	if(houseInfo[houseid][hLocked] == 0) {
		houseInfo[houseid][hLocked] = 1;
		SCM(playerid, COLOR_GREY, "* House Notice: Ai inchis casa ta, acum playerii nu mai pot intra.");
	}
	else if(houseInfo[houseid][hLocked] == 1) {
		houseInfo[houseid][hLocked] = 0;
		SCM(playerid, COLOR_GREY, "* House Notice: Ai deschis casa ta, acum playerii pot intra.");
	}
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof(gQuery),"UPDATE `server_houses` SET `Locked`='%d'  WHERE `ID`='%d' LIMIT 1", houseInfo[houseid][hLocked], houseid);
	mysql_tquery(SQL, gQuery, "", "");	
	return true;
}

CMD:sellhouse(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pHouse] == 0 && playerInfo[playerid][pHouseID] == -1) return sendPlayerError(playerid, "Nu detii o casa.");
	new houseid = playerInfo[playerid][pHouseID], suma;
	if(sscanf(params, "d", suma)) return sendPlayerSyntax(playerid, "/sellhouse <Pret>");
	houseInfo[houseid][hPrice] = suma;
	SCM(playerid, COLOR_GREY, string_fast("* House Notice: Ai pus la vanzare casa ta cu pretul $%s. Acum orice player iti poate cumpara casa.", formatNumber(suma)));
	update("UPDATE `server_houses` SET `Price`='%d'  WHERE `ID`='%d' LIMIT 1", houseInfo[houseid][hPrice], houseid);
	Update3DTextLabelText(houseInfo[houseid][hText], COLOR_WHITE, string_fast("House ID: %d\nHouse Title: %s\nHouse Description: %s\nOwner: %s\nPrice: $%s%s", houseInfo[houseid][hID], houseInfo[houseid][hTitle], houseInfo[houseid][hDescription], houseInfo[houseid][hOwner], formatNumber(houseInfo[houseid][hPrice]), formatNumber(houseInfo[houseid][hRentPrice])));	
	return true;
}

CMD:adminhouse(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pAdmin] < 4) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(Dialog_Opened(playerid)) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda cat timp ai un dialog afisat.");
	new idl;
	if(sscanf(params, "d", idl)) return sendPlayerSyntax(playerid, "/adminhouse <House ID>");
	if(!Iter_Contains(ServerHouses, idl)) return sendPlayerError(playerid, "Acest ID nu exista in baza de date.");
	IDSelected[playerid] = idl;
	Dialog_Show(playerid, HOUSE_OPTION_ADMIN, DIALOG_STYLE_TABLIST_HEADERS, string_fast("House: %d", idl), "Option Name\tOption\nTitlu\tSchimba titlul casei\nDescrierea\tSchimba descrierea casei", "Select", "Cancel");
	return true;
}

CMD:rentabil(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pHouse] == 0 && playerInfo[playerid][pHouseID] == -1) return sendPlayerError(playerid, "Nu detii o casa.");
	if(GetPVarInt(playerid, "RentDeelay") > gettime()) return sendPlayerError(playerid, "Trebuie sa astepti %d secunde inainte sa folosesti aceasta comanda.", (GetPVarInt(playerid, "RentDeelay") - gettime()));
	new houseid = playerInfo[playerid][pHouseID];
	if(houseInfo[houseid][hRentabil] == 0) houseInfo[houseid][hRentabil] = 1;
	else if(houseInfo[houseid][hRentabil] == 1) houseInfo[houseid][hRentabil] = 0;
	Update3DTextLabelText(houseInfo[houseid][hText], COLOR_WHITE, string_fast("House ID: %d\nHouse Title: %s\nHouse Description: %s\nOwner: %s\nPrice: $%s%s", houseInfo[houseid][hID], houseInfo[houseid][hTitle], houseInfo[houseid][hDescription], houseInfo[houseid][hOwner], formatNumber(houseInfo[houseid][hPrice]), formatNumber(houseInfo[houseid][hRentPrice])));		
	SCM(playerid, COLOR_GREY, string_fast("* House Notice: Acum casa ta este %s.", houseInfo[houseid][hRentabil] ? "Rentabila" : "Nerentabila"));
	update("UPDATE `server_houses` SET `Rentabil` = '%d' WHERE `ID` = '%d'", houseInfo[houseid][hRentabil], houseInfo[houseid][hID]);
	SetPVarInt(playerid, "RentDeelay", (gettime() + 60));
	return true;
}

CMD:renters(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pHouse] == 0 && playerInfo[playerid][pHouseID] == -1) return sendPlayerError(playerid, "Nu detii o casa.");
	new houseid = playerInfo[playerid][pHouseID];
	SCM(playerid, COLOR_GREY, string_fast("* House Notice: Ai %d renteri.", Iter_Count(RentersHouses[houseid])));
	return true;
}

CMD:rentroom(playerid, parmas[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pHouse] == 1 && playerInfo[playerid][pHouseID] != -1) return sendPlayerError(playerid, "Detii deja o casa, nu poti folosi aceasta comanda.");
	if(playerInfo[playerid][pRent] != -1) return sendPlayerError(playerid, "Ai deja rentroom la o casa, foloseste (/unrentroom).");
	foreach(new i : ServerHouses) {
		if(IsPlayerInRangeOfPoint(playerid, 5.0 , houseInfo[i][hExtX], houseInfo[i][hExtY], houseInfo[i][hExtZ])) {
			if(houseInfo[i][hRentabil] == 0) return sendPlayerError(playerid, "Aceasta casa nu este rentabila.");
			if(houseInfo[i][hPrice] > 0) return sendPlayerError(playerid, "Nu mai poti da rent, deoarece casa este de vanzare.");
			if(houseInfo[i][hOwned] == 0) return sendPlayerError(playerid, "Nu poti da rent, deoarece aceasta casa nu detine un detinator.");
			playerInfo[playerid][pSpawnChange] = 3;
			playerInfo[playerid][pRent] = i;
			Iter_Add(RentersHouses[i], playerid);
			SetPlayerPos(playerid, houseInfo[i][hX], houseInfo[i][hY], houseInfo[i][hZ]);
			SetPlayerInterior(playerid, houseInfo[i][hInterior]);
			SetPlayerVirtualWorld(playerid, houseInfo[i][hID]);
			playerInfo[playerid][pinHouse] = i;
			update("UPDATE `server_users` SET `SpawnChange` = '3', `Rent` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pRent], playerInfo[playerid][pSQLID]);
			update("UPDATE `server_houses` SET `Renters` = '%d' WHERE `ID` = '%d'", Iter_Count(RentersHouses[i]), i);
			SCM(playerid, COLOR_GREY, string_fast("* House Notice: Ai fost adaugat ca chirias la casa %d, de acum te vei spawna acolo. Foloseste (/spawnchange) daca doresti la spawn.", i));
		}
	}
	return true;
}

CMD:unrentroom(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pRent] == -1) return sendPlayerError(playerid, "Nu ai rentroom la o casa, foloseste (/rentroom).");
	new houseid = playerInfo[playerid][pRent];
	if(Iter_Contains(RentersHouses[houseid], playerid)) Iter_Remove(RentersHouses[houseid], playerid);            
	update("UPDATE `server_houses` SET `Renters` = '%d' WHERE `ID` = '%d'", Iter_Count(RentersHouses[playerid]), houseInfo[houseid][hID]);
	if(playerInfo[playerid][pSpawnChange] == 3) playerInfo[playerid][pSpawnChange] = 1;
	playerInfo[playerid][pRent] = -1;
	update("UPDATE `server_users` SET `SpawnChange` = '1', `Rent` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pRent], playerInfo[playerid][pSQLID]);
	SCM(playerid, COLOR_GREY, "* House Notice: Nu mai esti chirias. Acum te vei spawna la spawn.");
	return true;
}

CMD:setrentprice(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pHouse] == 0 && playerInfo[playerid][pHouseID] == -1) return sendPlayerError(playerid, "Nu detii o casa.");
	new houseid = playerInfo[playerid][pHouseID], suma;
	if(houseInfo[houseid][hRentabil] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece casa ta nu are rent-ul activat.");
	if(sscanf(params, "d", suma)) return sendPlayerSyntax(playerid, "/setrentprice <Suma>");
	houseInfo[houseid][hRentPrice] = suma;
	update("UPDATE `server_houses` SET `RentPrice`='%d'  WHERE `ID`='%d' LIMIT 1", houseInfo[houseid][hRentPrice], houseid);
	Update3DTextLabelText(houseInfo[houseid][hText], COLOR_WHITE, string_fast("House ID: %d\nHouse Title: %s\nHouse Description: %s\nOwner: %s\nPrice: $%s%s", houseInfo[houseid][hID], houseInfo[houseid][hTitle], houseInfo[houseid][hDescription], houseInfo[houseid][hOwner], formatNumber(houseInfo[houseid][hPrice]), formatNumber(houseInfo[houseid][hRentPrice])));	
	SCM(playerid, COLOR_GREY, string_fast("* House Notice: Ai setat rent price-ul la $%s.", formatNumber(suma)));	
	return true;
}

CMD:upgradehouse(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pHouse] == 0 && playerInfo[playerid][pHouseID] == -1) return sendPlayerError(playerid, "Nu detii o casa.");
	new houseid = playerInfo[playerid][pHouseID], upgrade;
	if(sscanf(params, "d", upgrade)) return sendPlayerSyntax(playerid, "/upgradehouse <upgrade>"), SCM(playerid, -1, "1 - Health Upgrade | 2 - Health Armour (Cops)");
	switch(upgrade) {
		case 1: {
			if(houseInfo[houseid][hUpgrade] == 1) return sendPlayerError(playerid, "Detii deja acest upgrade heal.");
			if(GetPlayerCash(playerid) < 50000) return sendPlayerError(playerid, "Nu detii $50,000");
			houseInfo[houseid][hUpgrade] = 1;
			foreach(new i : RentersHouses[houseid]) {
				SCM(i, COLOR_GREY, string_fast("* Rent Notice: Proprietarul rentului tau %s, a facut upgrade heal, acum poti tasta /heal in casa."));
			}
			SCM(playerid, COLOR_GREY, string_fast("* House Notice: Casa ta acum are upgrade heal, acum poti tasta /heal in casa."));
		}
		case 2: {
			if(houseInfo[houseid][hUpgrade] == 2) return sendPlayerError(playerid, "Detii deja acest upgrade armour.");
			if(GetPlayerCash(playerid) < 100000) return sendPlayerError(playerid, "Nu detii $100,000");
			houseInfo[houseid][hUpgrade] = 2;
			foreach(new i : RentersHouses[houseid]) {
				SCM(i, COLOR_GREY, string_fast("* Rent Notice: Proprietarul rentului tau %s, a facut upgrade armour, acum toti politistii pot tasta /armour."));
			}
			SCM(playerid, COLOR_GREY, string_fast("* House Notice: Casa ta acum are upgrade armour, acum politistii pot tasta /armour."));
		}
	}
	return true;
}

CMD:eat(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pHouse] == 0 && playerInfo[playerid][pHouseID] == -1 && playerInfo[playerid][pRent] == -1) return sendPlayerError(playerid, "Nu detii o casa / rent.");
	if(playerInfo[playerid][pHouse] != 0 && playerInfo[playerid][pHouseID] != -1) {
		new houseid = playerInfo[playerid][pHouseID];
		if(houseInfo[houseid][hUpgrade] <= 0) return sendPlayerError(playerid, "Casa ta nu detine upgrade-ul de heal.");
		if(playerInfo[playerid][pinHouse] == houseid){
			SetPlayerHealthEx(playerid, 100);
			sendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "* %s si-a dat heal.", getName(playerid));
		}
	}
	else if(playerInfo[playerid][pRent] != -1) {
		new rentid = playerInfo[playerid][pRent];
		if(houseInfo[rentid][hUpgrade] <= 0) return sendPlayerError(playerid, "Rentul tau nu detine upgrade-ul de heal.");
		if(GetPlayerVirtualWorld(playerid) == houseInfo[rentid][hID] && GetPlayerInterior(playerid) == houseInfo[rentid][hInterior]) {
			SetPlayerHealthEx(playerid, 100);
			sendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "* %s si-a dat heal.", getName(playerid));
		}
	}
	return true;
}

CMD:armour(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pHouse] == 0 && playerInfo[playerid][pHouseID] == -1 && playerInfo[playerid][pRent] == -1) return sendPlayerError(playerid, "Nu detii o casa / rent.");
	if(playerInfo[playerid][pHouse] != 0 && playerInfo[playerid][pHouseID] != -1) {
		new houseid = playerInfo[playerid][pHouseID];
		if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
		if(houseInfo[houseid][hUpgrade] <= 0) return sendPlayerError(playerid, "Casa ta nu detine upgrade-ul de armour.");
		if(playerInfo[playerid][pinHouse] == houseid) {
			if(playerInfo[playerid][pFaction] == 1 || playerInfo[playerid][pFaction] == 2 || playerInfo[playerid][pFaction] == 3) {			
				SetPlayerHealthEx(playerid, 100);
				SetPlayerArmourEx(playerid, 100);
				sendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "* %s si-a dat heal & armour.", getName(playerid));
			}
		}
	}
	else if(playerInfo[playerid][pRent] != -1) {
		new rentid = playerInfo[playerid][pRent];
		if(playerInfo[playerid][pFactionDuty] == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti la datorie.");
		if(houseInfo[rentid][hUpgrade] <= 0) return sendPlayerError(playerid, "Rentul tau nu detine upgrade-ul de armour.");
		if(GetPlayerVirtualWorld(playerid) == houseInfo[rentid][hID] && GetPlayerInterior(playerid) == houseInfo[rentid][hInterior]) {
			if(playerInfo[playerid][pFaction] == 1 || playerInfo[playerid][pFaction] == 2 || playerInfo[playerid][pFaction] == 3) {
				SetPlayerHealthEx(playerid, 100);
				SetPlayerArmourEx(playerid, 100);
				sendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "* %s si-a dat heal & armour.", getName(playerid));
			}
		}
	}
	return true;
}

CMD:createhouse(playerid, params[], help) {
	if(playerInfo[playerid][pAdmin] < 6) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(Iter_Count(ServerHouses) >= MAX_HOUSES) return sendPlayerError(playerid, "Database:Limita de case a fost atinsa !");
	extract params -> new string:interior[32], price, rent; else {
		SCM(playerid, COLOR_GREY, "Optiuni Interior: small, medium, big. | Price: 0$ - not for sale ; > 0$ for sale");
		return sendPlayerSyntax(playerid, "/createhouse <interior> <price> <rent available(0 - no | 1 - yes)>");
	}
	if(!(0 <= rent <= 1)) return sendPlayerError(playerid, "Invalid rent available (0 - 1).");
	if(!(0 <= price <= 100000000)) return sendPlayerError(playerid, "Invalid price (0$ - 100,000,000$).");
	new i = Iter_Count(ServerHouses) + 1, int = random(5);
	Iter_Add(ServerHouses, i);
	houseInfo[i][hID] = i;
	houseInfo[i][hPrice] = price;
	houseInfo[i][hRentabil] = rent;
	GetPlayerPos(playerid, houseInfo[i][hExtX], houseInfo[i][hExtY], houseInfo[i][hExtZ]);
	switch(YHash(interior)) {
		case _H<small>: {
			houseInfo[i][hX] = smallInteriors[int][0];
			houseInfo[i][hY] = smallInteriors[int][1];
			houseInfo[i][hZ] = smallInteriors[int][2];
			houseInfo[i][hInterior] = smallInteriorsID[int][0];	
		}
		case _H<medium>: {
			houseInfo[i][hX] = mediumInteriors[int][0];
			houseInfo[i][hY] = mediumInteriors[int][1];
			houseInfo[i][hZ] = mediumInteriors[int][2];
			houseInfo[i][hInterior] = mediumInteriorsID[int][0];		
		}
		case _H<big>: { 
			houseInfo[i][hX] = bigInteriors[int][0];
			houseInfo[i][hY] = bigInteriors[int][1];
			houseInfo[i][hZ] = bigInteriors[int][2];
			houseInfo[i][hInterior] = bigInteriorsID[int][0];		
		}
		default: {
			SCM(playerid, COLOR_GREY, "Optiuni Interior: small, medium, big. | Price: 0$ - not for sale ; > 0$ for sale");
			return sendPlayerSyntax(playerid, "/createhouse <interior> <price> <rent available(0 - no | 1 - yes)>");
		}
	}
	format(houseInfo[i][hOwner], 32, "Admbot");
	format(houseInfo[i][hTitle], 32, "A new house");
	format(houseInfo[i][hDescription], 64, "A new house %s", interior);
	houseInfo[i][hLocked] = 0;  houseInfo[i][hPrice] = price; houseInfo[i][hBalance] = 0; houseInfo[i][hOwnerID] = -1; houseInfo[i][hOwned] = 1; houseInfo[i][hRentabil] = rent; houseInfo[i][hRenters] = 0; houseInfo[i][hUpgrade] = 0; houseInfo[i][hRentPrice] = 500;
	new rentx[75];
	format(rentx, sizeof(rentx), "\nRent Price: $%s\nType '/rentroom' to rent a room", formatNumber(houseInfo[i][hRentPrice]));
	houseInfo[i][hText] = CreateDynamic3DTextLabel(string_fast("House ID: %d\nHouse Title: %s\nHouse Description: %s\nOwner: %s\nPrice: $%s%s", houseInfo[i][hID], houseInfo[i][hTitle], houseInfo[i][hDescription], houseInfo[i][hOwner], formatNumber(houseInfo[i][hPrice]),(houseInfo[i][hRentPrice] ? rentx : "")), -1, houseInfo[i][hExtX],houseInfo[i][hExtY],houseInfo[i][hExtZ], 20.0, 0xFFFF, 0xFFFF, 0, 0, 0, -1, STREAMER_3D_TEXT_LABEL_SD);
	houseInfo[i][hPickup] = CreateDynamicPickup((houseInfo[i][hPrice] ? 1272 : 1273), 23, houseInfo[i][hExtX],houseInfo[i][hExtY],houseInfo[i][hExtZ], 0, 0, -1, STREAMER_PICKUP_SD);					
	PickInfo[houseInfo[i][hPickup]][HOUSE] = i;
	houseInfo[i][hArea] = CreateDynamicSphere(houseInfo[i][hExtX],houseInfo[i][hExtY],houseInfo[i][hExtZ], 2.0, 0, 0);
	Streamer_SetIntData(STREAMER_TYPE_AREA, houseInfo[i][hArea], E_STREAMER_EXTRA_ID, (i + HOUSE_STREAMER_START));
	CreateDynamicMapIcon(houseInfo[i][hExtX],houseInfo[i][hExtY],houseInfo[i][hExtZ],(houseInfo[i][hPrice] ? 31 : 32),0,-1,-1,-1,750.0); 	
	update("INSERT INTO `server_houses` (`Title`, `Description`, `Owner`, `X`, `Y`, `Z`, `ExtX`, `ExtY`, `ExtZ`, `Interior`, `Price`) VALUES ('%s', '%s', '%s', '%.2f', '%.2f', '%.2f', '%.2f', '%.2f', '%.2f', '%d', '%d')", houseInfo[i][hTitle], houseInfo[i][hDescription], houseInfo[i][hOwner], houseInfo[i][hX], houseInfo[i][hY], houseInfo[i][hZ], houseInfo[i][hExtX], houseInfo[i][hExtY], houseInfo[i][hExtZ], houseInfo[i][hInterior], houseInfo[i][hPrice]);
	SCMf(playerid, COLOR_SERVER, "* Notice: {ffffff}Ai creat o casa de tip '%s' (id: %d | price: $%s | rent available: %s).", interior, houseInfo[i][hID], formatNumber(houseInfo[i][hPrice]), houseInfo[i][hRentabil] ? "yes" : "no");
	return true;
}