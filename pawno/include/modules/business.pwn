#include <YSI\y_hooks>
#define MAX_BUSINESSES (30) 
#define BUSINESS_STREAMER_START 0

enum businessInfoEnum {
	bizID,
	bizTitle[32 + 1],
	bizDescription[64 + 1],
	bizOwner[32 + 1],
	Float:bizX,
	Float:bizY,
	Float:bizZ,
	Float:bizExtX,
	Float:bizExtY,
	Float:bizExtZ,
	bizFee,
	bizStatic,
	bizType,
	bizInterior,
	bizOwned,
	bizPrice,
	bizOwnerID,
	bizLocked,
	bizBalance,

	Text3D:bizText,
	bizPickup,
	bizArea
};
new bizInfo[MAX_BUSINESSES + 1][businessInfoEnum], Iterator:ServerBusinesses<MAX_BUSINESSES + 1>, AdTimer[MAX_PLAYERS], AdText[MAX_PLAYERS][180];

hook OnGameModeInit() {
	Iter_Init(ServerBusinesses);
	return true;
}

hook OnPlayerConnect(playerid) {
	IDSelected[playerid] = -1;
	AdTimer[playerid] = 0;
	return true;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if(PRESSED(KEY_SECONDARY_ATTACK)) {
		foreach(new i : ServerBusinesses) {
			if(IsPlayerInRangeOfPoint(playerid, 3.5, bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ])) {
				if(bizInfo[i][bizLocked] == 1) return sendPlayerError(playerid, "Aceasta afacere, este inchisa.");
				if(bizInfo[i][bizStatic] == 1) return sendPlayerError(playerid, "Aceasta afacere, este statica.");
				if(GetPlayerCash(playerid) < bizInfo[i][bizFee]) return sendPlayerError(playerid, "Nu ai banii necesari pentru a intra in aceasta afacere.");
				if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Esti intr-un vehicul.");
				SetPlayerPos(playerid, bizInfo[i][bizX], bizInfo[i][bizY], bizInfo[i][bizZ]);
				SetPlayerInterior(playerid, bizInfo[i][bizInterior]);
				SetPlayerVirtualWorld(playerid, bizInfo[i][bizID]);
				GivePlayerCash(playerid, 0, bizInfo[i][bizFee]);
				GameTextForPlayer(playerid, string_fast("~r~-$%d", bizInfo[i][bizFee]), 1000, 1);
				playerInfo[playerid][pinBusiness] = i;
				bizInfo[i][bizBalance] += bizInfo[i][bizFee];
				mysql_format(SQL, gQuery, sizeof(gQuery),"UPDATE `server_business` SET `Balance`='%d' WHERE `ID`='%d' LIMIT 1",bizInfo[i][bizBalance], i);
				mysql_tquery(SQL, gQuery, "", "");	
				switch(bizInfo[i][bizType]) {
					case 1: SCM(playerid, -1, "Welcome in the business, commands available: /balance, /deposit, /withdraw, /transfer."); 
					case 2: {
						SCM(playerid, -1, "Welcome in the business, commands available: /buy.");
						if(FishWeight[playerid]) {
							new money = FishWeight[playerid] * 115;
							SCM(playerid, COLOR_GREY, string_fast("* Fish Notice: Ai vandut pestele , si ai castigat $%s.", formatNumber(money)));
							FishWeight[playerid] = 0;
							playerInfo[playerid][pFishTimes] ++;
							if(playerInfo[playerid][pFishSkill] < 5) {
								if(playerInfo[playerid][pFishTimes] >= returnNeededPoints(playerid, JOB_FISHER)) {
									playerInfo[playerid][pFishSkill] ++;
									SCM(playerid, COLOR_GREY, string_fast("* Fisherman Notice: Ai avansat in %d skill. Vei castiga probabil mai multi bani", playerInfo[playerid][pFishSkill]));
								}
							}
							GivePlayerCash(playerid, 1, money);
							for(new m; m < 2; m++) {
								if(playerInfo[playerid][pDailyMission][m] == 1) checkMission(playerid, m);
							}
							gQuery[0] = (EOS);
							mysql_format(SQL, gQuery, sizeof(gQuery), "UPDATE `server_users` SET `Money`= '%d', `MStore` = '%d', `FishTimes` = '%d', `FishSkill` = '%d' WHERE `ID`='%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pFishTimes], playerInfo[playerid][pFishSkill], playerInfo[playerid][pSQLID]);
							mysql_tquery(SQL, gQuery);
						}
					}
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.5, bizInfo[i][bizX], bizInfo[i][bizY], bizInfo[i][bizZ])) {
				if(IsPlayerInAnyVehicle(playerid)) return true;
				SetPlayerPos(playerid, bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ]);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				playerInfo[playerid][pinBusiness] = -1;
			}
		}
	}
	return true;
}

function totalAds() {
	new x;
	foreach(new i : loggedPlayers) {
		if(AdTimer[i] != 0) x++;
	}	
	return x;
}

timer advertismentTimer[totalAds() * 60000](playerid) {
	if(AdTimer[playerid] != 0) {
		gString[0] = (EOS);
		va_format(gString, sizeof(gString), "{00D900}Ad by %s (phone: {FFFFFF}%d{00D900}): %s", getName(playerid), playerInfo[playerid][pPhone], AdText[playerid]);
		sendSplitMessage(playerid, COLOR_WHITE, gString);
		AdTimer[playerid] = -1;
	}
	return true;
}


function LoadBusinesses() {
	if(!cache_num_rows()) return print("Businesses: 0 [From Database]");
	for(new i = 1, j = cache_num_rows() + 1; i != j; i++) {	
		Iter_Add(ServerBusinesses, i);

		cache_get_value_name(i - 1, "Title", bizInfo[i][bizTitle], 32);
		cache_get_value_name(i - 1, "Description", bizInfo[i][bizDescription], 64);
		cache_get_value_name(i - 1, "Owner", bizInfo[i][bizOwner], 32);
		cache_get_value_name_int(i - 1, "ID", bizInfo[i][bizID]);
		cache_get_value_name_float(i - 1, "X", bizInfo[i][bizX]);
		cache_get_value_name_float(i - 1, "Y", bizInfo[i][bizY]);
		cache_get_value_name_float(i - 1, "Z", bizInfo[i][bizZ]);
		cache_get_value_name_float(i - 1, "ExtX", bizInfo[i][bizExtX]);
		cache_get_value_name_float(i - 1, "ExtY", bizInfo[i][bizExtY]);
		cache_get_value_name_float(i - 1, "ExtZ", bizInfo[i][bizExtZ]);
		cache_get_value_name_int(i - 1, "Fee", bizInfo[i][bizFee]);
		cache_get_value_name_int(i - 1, "Static", bizInfo[i][bizStatic]);
		cache_get_value_name_int(i - 1, "Type", bizInfo[i][bizType]);
		cache_get_value_name_int(i - 1, "Interior", bizInfo[i][bizInterior]);
		cache_get_value_name_int(i - 1, "Owned", bizInfo[i][bizOwned]);
		cache_get_value_name_int(i - 1, "Price", bizInfo[i][bizPrice]);
		cache_get_value_name_int(i - 1, "OwnerID", bizInfo[i][bizOwnerID]);
		cache_get_value_name_int(i - 1, "Locked", bizInfo[i][bizLocked]);
		cache_get_value_name_int(i - 1, "Balance", bizInfo[i][bizBalance]);
		BusinessUpdate(i);
	}
	return printf("Businesses: %d [From Database]", Iter_Count(ServerBusinesses));
}

BusinessUpdate(businessid) {
	if(IsValidDynamic3DTextLabel(bizInfo[businessid][bizText]))
		DestroyDynamic3DTextLabel(bizInfo[businessid][bizText]);

	if(IsValidDynamicPickup(bizInfo[businessid][bizPickup])) 
		DestroyDynamicPickup(bizInfo[businessid][bizPickup]);

	if(IsValidDynamicArea(bizInfo[businessid][bizArea])) 
		DestroyDynamicArea(bizInfo[businessid][bizArea]);

	bizInfo[businessid][bizText] = CreateDynamic3DTextLabel(string_fast("Business ID: %d\nBusiness Title: %s\nBusiness Description: %s\nBusiness Owner: %s\nBusiness Price: $%s\nBusiness Fee: $%s", bizInfo[businessid][bizID], bizInfo[businessid][bizTitle], bizInfo[businessid][bizDescription], bizInfo[businessid][bizOwner], formatNumber(bizInfo[businessid][bizPrice]),formatNumber(bizInfo[businessid][bizFee])), -1, bizInfo[businessid][bizExtX],bizInfo[businessid][bizExtY],bizInfo[businessid][bizExtZ], 20.0, 0xFFFF, 0xFFFF, 0, 0, 0, -1, STREAMER_3D_TEXT_LABEL_SD);
	bizInfo[businessid][bizPickup] = CreateDynamicPickup(1239, 23, bizInfo[businessid][bizExtX],bizInfo[businessid][bizExtY],bizInfo[businessid][bizExtZ], 0, 0, -1, STREAMER_PICKUP_SD);					
	bizInfo[businessid][bizArea] = CreateDynamicSphere(bizInfo[businessid][bizExtX],bizInfo[businessid][bizExtY],bizInfo[businessid][bizExtZ], 2.0, 0, 0);
	Streamer_SetIntData(STREAMER_TYPE_AREA, bizInfo[businessid][bizArea], E_STREAMER_EXTRA_ID, (businessid + BUSINESS_STREAMER_START));	
	switch(bizInfo[businessid][bizType]) {
		case 1: CreateDynamicMapIcon(bizInfo[businessid][bizExtX], bizInfo[businessid][bizExtY], bizInfo[businessid][bizExtZ],52,0,-1,-1,-1,750.0);
		case 2: CreateDynamicMapIcon(bizInfo[businessid][bizExtX], bizInfo[businessid][bizExtY], bizInfo[businessid][bizExtZ],17,0,-1,-1,-1,750.0); 
		case 3: CreateDynamicMapIcon(bizInfo[businessid][bizExtX], bizInfo[businessid][bizExtY], bizInfo[businessid][bizExtZ],16,0,-1,-1,-1,750.0); 
	}
	return true;
}

Dialog:BIZ_OPTION(playerid, response, listitem) {
	if(!response) return true;
	switch(listitem) {
		case 0: Dialog_Show(playerid, BIZ_OPTION_TITLE, DIALOG_STYLE_INPUT, "Business: Option", "Introdu mai jos ce titlu doresti sa aiba afacerea ta", "Ok", "Cancel");
		case 1: Dialog_Show(playerid, BIZ_OPTION_DESCRIPTION, DIALOG_STYLE_INPUT, "Business: Description", "Introdu mai jos ce descriere doresti sa aiba afacerea ta", "Ok", "Cancel");
	}
	return true;
}

Dialog:BIZ_OPTION_TITLE(playerid, response, listitem, inputtext[]) {
	if(!response) return true;
	if(strlen(inputtext) < 3 || strlen(inputtext) > 32) return  Dialog_Show(playerid, BIZ_OPTION_TITLE, DIALOG_STYLE_INPUT, "Business: Title", "Introdu mai jos ce titlu doresti sa aiba afacerea ta\nMinim 3 caractere / Maxim 32 de caractere.", "Ok", "Cancel");
	new businessid = playerInfo[playerid][pBusinessID];
	format(bizInfo[businessid][bizTitle], 32, inputtext);
	SCM(playerid, COLOR_GREY, string_fast("* Business Notice: Ai schimbat titlul afacerii tale, in '%s'.", inputtext));
	mysql_format(SQL, gQuery, sizeof(gQuery),"UPDATE `server_business` SET `Title`='%s'  WHERE `ID`='%d' LIMIT 1", inputtext, businessid);
	mysql_tquery(SQL, gQuery, "", "");	
	BusinessUpdate(businessid);
	return true;
}

Dialog:BIZ_OPTION_DESCRIPTION(playerid, response, listitem,  inputtext[]) {
	if(!response) return true;
	if(strlen(inputtext) < 3 || strlen(inputtext) > 64) return Dialog_Show(playerid, BIZ_OPTION_DESCRIPTION, DIALOG_STYLE_INPUT, "Business: Description", "Introdu mai jos ce descriere doresti sa aiba afacerea ta\nMinim 3 caractere / Maxim 64 de caractere.", "Ok", "Cancel");
	new businessid = playerInfo[playerid][pBusinessID];
	format(bizInfo[businessid][bizDescription], 64, inputtext);	
	SCM(playerid, COLOR_GREY, string_fast("* Business Notice: Ai schimbat descrierea afacerii tale, in '%s'.", inputtext));
	mysql_format(SQL, gQuery, sizeof(gQuery),"UPDATE `server_business` SET `Description`='%s'  WHERE `ID`='%d' LIMIT 1", inputtext, businessid);
	mysql_tquery(SQL, gQuery, "", "");
	BusinessUpdate(businessid);
	return true;
}

Dialog:SELL_BIZ_STATE(playerid, response) {
	if(!response) return true;
	if(strcmp(getName(playerid), bizInfo[playerInfo[playerid][pBusinessID]][bizOwner], true) == 0) {	
		new businessid = playerInfo[playerid][pBusinessID], cash = 150000;
		gQuery[0] = (EOS);
		bizInfo[businessid][bizOwned] = 0;
		bizInfo[businessid][bizPrice] = 0;
		bizInfo[businessid][bizOwnerID] = -1;
		format(bizInfo[businessid][bizOwner], 32, "AdmBot");
		mysql_format(SQL, gQuery, sizeof(gQuery),"UPDATE `server_business` SET `Owned`='0',`Owner`='AdmBot',`OwnerID`='-1',`Price`='0' WHERE `ID`='%d'",businessid);
		mysql_tquery(SQL, gQuery, "", "");	
		BusinessUpdate(businessid);	
		GivePlayerCash(playerid, 1, cash);
		playerInfo[playerid][pBusiness] = 0;
		playerInfo[playerid][pBusinessID] = -1;
		update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d', `Business` = '0', `BusinessID` = '-1' WHERE `ID` = '%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSQLID]);
		SCM(playerid, COLOR_GREY, "* Business Notice: Ti-ai vandut cu succes afacerea la stat, si ai primit $150,000.");		
	}
	return true;
}

Dialog:BIZ_OPTION_ADMIN(playerid, response, listitem) {
	if(!response) return true;
	switch(listitem) {
		case 0: Dialog_Show(playerid, BIZ_OPTION_TITLEADMIN, DIALOG_STYLE_INPUT, "Business: Title", "Introdu mai jos ce titlu doresti sa aiba afacerea", "Ok", "Cancel");
		case 1: Dialog_Show(playerid, BIZ_OPTION_DESCADMIN, DIALOG_STYLE_INPUT, "Business: Description", "Introdu mai jos ce descriere doresti sa aiba afacerea", "Ok", "Cancel");
	}
	return true;
}

Dialog:BIZ_OPTION_TITLEADMIN(playerid, response, listitem, inputtext[]) {
	if(!response) return true;
	if(strlen(inputtext) < 3 || strlen(inputtext) > 32) return Dialog_Show(playerid, BIZ_OPTION_TITLEADMIN, DIALOG_STYLE_INPUT, "Business: Option", "Introdu mai jos ce titlu doresti sa aiba afacerea\nMinim 3 caractere / Maxim 32 caractere.", "Ok", "Cancel");
	format(bizInfo[IDSelected[playerid]][bizTitle], 32, inputtext);
	mysql_format(SQL, gQuery, sizeof(gQuery),"UPDATE `server_business` SET `Title`='%s'  WHERE `ID`='%d' LIMIT 1", inputtext, IDSelected[playerid]);
	mysql_tquery(SQL, gQuery, "", "");	
	BusinessUpdate(IDSelected[playerid]);	
	IDSelected[playerid] = -1;
	return true;
}

Dialog:BIZ_OPTION_DESCADMIN(playerid, response, listitem, inputtext[]) {
	if(!response) return true;
	if(strlen(inputtext) < 3 || strlen(inputtext) > 64) return Dialog_Show(playerid, BIZ_OPTION_TITLEADMIN, DIALOG_STYLE_INPUT, "Business: Option", "Introdu mai jos ce titlu doresti sa aiba afacerea\nMinim 3 caractere / Maxim 64 caractere.", "Ok", "Cancel");
	format(bizInfo[IDSelected[playerid]][bizDescription], 64, inputtext);
	mysql_format(SQL, gQuery, sizeof(gQuery),"UPDATE `server_business` SET `Description`='%s'  WHERE `ID`='%d' LIMIT 1", inputtext, IDSelected[playerid]);
	mysql_tquery(SQL, gQuery, "", "");	
	BusinessUpdate(IDSelected[playerid]);	
	IDSelected[playerid] = -1;
	return true;
}

Dialog:BUYBIZ(playerid, response, listitem) { 
	if(!response) return true;
	SCM(playerid, -1, "smeker 999");
	switch(listitem) {
		case 0: {
			SCM(playerid, -1, "smeker 1");
			if(GetPlayerCash(playerid) < 1500) return sendPlayerError(playerid, "Nu ai $1500.");
			if(playerInfo[playerid][pPhone] > 0) return sendPlayerError(playerid, "Ai deja telefon.");
			if(strlen(playerInfo[playerid][pPhone]) == 4) return sendPlayerError(playerid, "Nu poti cumpara alt telefon deoarece ai un iPhone.");
			new randphone = 5000 + random(9999) + 5000;
			GivePlayerCash(playerid, 0, 1500);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			bizInfo[2][bizBalance] += 1500;
			playerInfo[playerid][pPhone] = randphone;
			update("UPDATE `server_users` SET `Phone` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pPhone], playerInfo[playerid][pSQLID]);
			update("UPDATE `server_business` SET `Balance` = '%d' WHERE `ID` = '2'", bizInfo[2][bizBalance]);
			SCM(playerid, COLOR_GREY, string_fast("* Buy Notice: Ai cumparat un telefon, iar numarul tau este %d.", randphone));
		}
		case 1: {
			SCM(playerid, -1, "smeker 2");
			if(GetPlayerCash(playerid) < 3500) return sendPlayerError(playerid, "Nu ai $3500.");
			if(playerInfo[playerid][pPhoneBook] > 0) return sendPlayerError(playerid, "Ai deja agenda telefonica.");
			GivePlayerCash(playerid, 0, 3500);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			playerInfo[playerid][pPhoneBook] = 1;
			bizInfo[2][bizBalance] += 3500;
			update("UPDATE `server_users` SET `PhoneBook` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pPhoneBook], playerInfo[playerid][pSQLID]);
			update("UPDATE `server_business` SET `Balance` = '%d' WHERE `ID` = '2'", bizInfo[2][bizBalance]);
			SCM(playerid, COLOR_GREY, "* Buy Notice: Ai cumparat o agenda telefonica.");
		}
		case 2: {
			SCM(playerid, -1, "smeker 3");
			if(GetPlayerCash(playerid) < 5000) return sendPlayerError(playerid, "Nu ai $5000.");
			if(playerInfo[playerid][pWTalkie] == 1) return sendPlayerError(playerid, "Ai deja un walkie talkie.");
			GivePlayerCash(playerid, 0, 5000);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			playerInfo[playerid][pWTalkie] = 1;
			bizInfo[2][bizBalance] += 5000;
			update("UPDATE `server_users` SET `WTalkie` = '1' WHERE `ID` = '%d'", playerInfo[playerid][pSQLID]);
			update("UPDATE `server_business` SET `Balance` = '%d' WHERE `ID` = '2'", bizInfo[2][bizBalance]);
			SCM(playerid, COLOR_GREY, "* Buy Notice: Ai cumparat un walkie talkie.");			
		}
	}
	SCM(playerid, -1, "smeker 4");
	return true;
}

Dialog:TRANSFERBIZ(playerid, response) {
	if(!response) return true;	
	new taxBank = playerInfo[playerid][pTransferMoney]/75;
	if(playerInfo[playerid][pStoreBank] == 0 && playerInfo[playerid][pBank] < playerInfo[playerid][pTransferMoney]+taxBank) return sendPlayerError(playerid, "Nu ai suma necesara pentru a transfera banii.");
	new LastMoney[45];
	format(LastMoney, 45, GetBankMoney(playerid));
	GivePlayerBank(playerid, -playerInfo[playerid][pTransferMoney]+taxBank);
	GivePlayerBank(playerInfo[playerid][pTransferPlayer], playerInfo[playerid][pTransferMoney]);
	bizInfo[1][bizBalance] += taxBank;
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	SCM(playerid, COLOR_GREY, string_fast("* Bank Notice: Ai transferat in contul lui %s (%d) suma de $%s. In contul tau mai ai $%s. Taxa: $%s.", getName(playerInfo[playerid][pTransferPlayer]), playerInfo[playerid][pTransferPlayer], formatNumber(playerInfo[playerid][pTransferMoney]), formatNumber(playerInfo[playerid][pBank]), taxBank));
	SCM(playerInfo[playerid][pTransferPlayer], COLOR_GREY, string_fast("* Bank Notice: Ai primit in contul tau bancar suma de $%s de la %s (%d).", formatNumber(playerInfo[playerid][pTransferMoney]), getName(playerid), playerid));
	sendStaff(COLOR_SERVER, string_fast("(-$+) Transfer:{ffffff} %s a transferat $%s lui %s. [Last Bank Money: $%S].", getName(playerid), formatNumber(playerInfo[playerid][pTransferMoney]), getName(playerInfo[playerid][pTransferPlayer]), LastMoney));
	update("UPDATE `server_users` SET `Bank` = '%d', `MBank` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pBank], playerInfo[playerid][pStoreBank], playerInfo[playerid][pSQLID]);
	update("UPDATE `server_users` SET `Bank` = '%d', `MBank` = '%d' WHERE `ID` = '%d'", playerInfo[playerInfo[playerid][pTransferPlayer]][pBank], playerInfo[playerInfo[playerid][pTransferPlayer]][pStoreBank], playerInfo[playerInfo[playerid][pTransferPlayer]][pSQLID]);
	update("UPDATE `server_business` SET `Balance`='%d' WHERE `ID`='1'", bizInfo[1][bizBalance]);
	return true;
}

YCMD:buybusiness(playerid, params[], help) {
	if(playerInfo[playerid][pBusiness] != 0) return sendPlayerError(playerid, "Ai deja o afacere cumparata.");
	if(playerInfo[playerid][pLevel] < 5) return sendPlayerError(playerid, "Trebuie sa detii, minim level 5.");
	foreach(new i : ServerBusinesses) {
		if(IsPlayerInRangeOfPoint(playerid, 3.5, bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ])) {
			if(bizInfo[i][bizPrice] == 0) return sendPlayerError(playerid, "Aceasta afacere nu este de vanzare.");
			if(bizInfo[i][bizOwned] == 1) {
				new id = GetPlayerID(bizInfo[i][bizOwner]), moneys, newmoneys;
				gQuery[0] = (EOS);
				gString[0] = (EOS);
				if(id != INVALID_PLAYER_ID) { 
					playerInfo[id][pBusiness] = 0;
					playerInfo[id][pBusinessID] = -1;
					playerInfo[id][pBank] += bizInfo[i][bizPrice];
					SCM(playerid, COLOR_GREY, string_fast("* %s ti-a cumparat afacerea, si ai primit $%s, in banca.", getName(playerid), formatNumber(bizInfo[i][bizPrice])));
					update("UPDATE `server_users` SET `Bank` = '%d', `Business` = '0', `BusinessID` = '-1' WHERE `ID` = '%d'", playerInfo[id][pBank], playerInfo[id][pSQLID]);
				}
				else {
					format(gQuery, sizeof(gQuery), "SELECT * FROM `server_users` WHERE `Name` = '%s'", bizInfo[i][bizOwner]);
					new Cache: result = mysql_query(SQL, gQuery);
					if(cache_num_rows() != 0) {
						cache_get_value_name(0, "Bank", gString); moneys = strval(gString);
						newmoneys = moneys + bizInfo[i][bizPrice];
					}
					cache_delete(result);
					update("UPDATE `server_users` SET `Bank` = '%d', `Business` = '0', `BusinessID` = '-1' WHERE `ID` = '%d'", newmoneys, playerInfo[id][pSQLID]);
				}
				SCM(playerid, COLOR_GREY, string_fast("* Business Notice: Felicitari ! Ai cumparat afacerea cu id %d, si ai platit $%s.", i, formatNumber(bizInfo[i][bizPrice])));
				GivePlayerCash(playerid, 0, bizInfo[i][bizPrice]);
				format(bizInfo[i][bizOwner], 32, getName(playerid));
				playerInfo[playerid][pBusiness] = 1;
				playerInfo[playerid][pBusinessID] = i;
				bizInfo[i][bizOwned] = 1;
				bizInfo[i][bizPrice] = 0;
				BusinessUpdate(i);
				update("UPDATE `server_users` SET `Business` = '1', `BusinessID` = '%d' WHERE `ID` = '%d'", i, playerInfo[playerid][pSQLID]);
				mysql_format(SQL, gQuery, sizeof(gQuery),"UPDATE `server_business` SET `Owned`='1',`Owner`='%s',`OwnerID`='%d',`Price`='0' WHERE `ID`='%d'",bizInfo[i][bizOwner], playerInfo[playerid][pSQLID], i);
				mysql_tquery(SQL, gQuery, "", "");
			}
			else if(bizInfo[i][bizOwned] == 0) {
				gQuery[0] = (EOS);
				SCM(playerid, COLOR_GREY, string_fast("* Business Notice: Felicitari ! Ai cumparat afacerea cu id %d, si ai platit $%s.", i, formatNumber(bizInfo[i][bizPrice])));
				GivePlayerCash(playerid, 0, bizInfo[i][bizPrice]);
				format(bizInfo[i][bizOwner], 32, getName(playerid));
				playerInfo[playerid][pBusiness] = 1;
				playerInfo[playerid][pBusinessID] = i;
				playerInfo[playerid][pMoney] -= bizInfo[i][bizPrice];
				bizInfo[i][bizOwned] = 1;
				bizInfo[i][bizPrice] = 0;
				BusinessUpdate(i);
				update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d', `Business` = '1', `BusinessID` = '%d' WHERE `ID` = '%d'", MoneyMoney[playerid], StoreMoney[playerid], i, playerInfo[playerid][pSQLID]);
				mysql_format(SQL, gQuery, sizeof(gQuery),"UPDATE `server_business` SET `Owned`='1',`Owner`='%s',`OwnerID`='%d',`Price`='0' WHERE `ID`='%d'",bizInfo[i][bizOwner],playerInfo[playerid][pSQLID], i);
				mysql_tquery(SQL, gQuery, "", "");
			}
		}
	}
	return true;
}

YCMD:sellbizstate(playerid, params[], help) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti face aceasta actiune, deoarece esti in masina.");
	if(GetPlayerVirtualWorld(playerid) != 0 && GetPlayerInterior(playerid) != 0 && playerInfo[playerid][pinBusiness] != -1) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda deoarece, esti intr-un alt virtualworld / interior / esti intr-un business.");
	if(playerInfo[playerid][pBusiness] == 0 && playerInfo[playerid][pBusinessID] == -1) return sendPlayerError(playerid, "Nu detii o afacere.");
	Dialog_Show(playerid, SELL_BIZ_STATE, DIALOG_STYLE_MSGBOX, "Business:", "Esti sigur ca doresti sa-ti vinzi afacerea, pe $150,000?\nDaca apesi pe butonul 'da', nu mai exista cale de intoarcere.", "Da", "Nu");
	return true;
}

YCMD:bizbalance(playerid, params[], help) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pBusiness] == 0 && playerInfo[playerid][pBusinessID] == -1) return sendPlayerError(playerid, "Nu detii o afacere.");
	new businessid = playerInfo[playerid][pBusinessID];
	SCM(playerid, COLOR_GREY, string_fast("* Business Notice: Balanta ta la afacere este de $%s.", formatNumber(bizInfo[businessid][bizBalance])));
	return true;
}

YCMD:bizwithdraw(playerid, params[], help) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pBusiness] == 0 && playerInfo[playerid][pBusinessID] == -1) return sendPlayerError(playerid, "Nu detii o afacere.");
	new businessid = playerInfo[playerid][pBusinessID], suma;
	if(playerInfo[playerid][pinBusiness] != businessid) return sendPlayerError(playerid, "Poti folosi aceasta comanda doar din interiorul afacerii tale.");
	if(sscanf(params, "d", suma)) {
		sendPlayerSyntax(playerid, "/bizwithdraw <money>");
		SCM(playerid, COLOR_GREY, string_fast("* Business Notice: Balanta ta la afacere este de $%s.", formatNumber(bizInfo[businessid][bizBalance])));
		return true;
	}
	if(bizInfo[businessid][bizBalance] < suma) return sendPlayerError(playerid, "Nu ai suma aceasta de bani in balanta afacerii tale.");
	bizInfo[businessid][bizBalance] -= suma;
	GivePlayerCash(playerid, 1, suma);
	mysql_format(SQL, gQuery, sizeof(gQuery),"UPDATE `server_business` SET `Balance`='%d'  WHERE `ID`='%d' LIMIT 1", bizInfo[businessid][bizBalance], businessid);
	mysql_tquery(SQL, gQuery, "", "");	
	SCM(playerid, COLOR_GREY, string_fast("* Business Notice: Ai retras din balanta afacerii tale, $%s. Iar acum balanta afacerii tale este de $%s.", formatNumber(suma), formatNumber(bizInfo[businessid][bizBalance])));	
	return true;
}

YCMD:bizdeposit(playerid, params[], help) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pBusiness] == 0 && playerInfo[playerid][pBusinessID] == -1) return sendPlayerError(playerid, "Nu detii o afacere.");
	new businessid = playerInfo[playerid][pBusinessID], suma;
	if(playerInfo[playerid][pinBusiness] != businessid) return sendPlayerError(playerid, "Poti folosi aceasta comanda doar din interiorul afacerii tale.");
	if(sscanf(params, "d", suma)) return sendPlayerSyntax(playerid, "/bizdeposit <money>");
	if(GetPlayerCash(playerid) < suma) return sendPlayerError(playerid, "Nu ai suma aceasta de bani, pentru a adauga in balanta afacerii tale.");
	bizInfo[businessid][bizBalance] += suma;
	GivePlayerCash(playerid, 0, suma);
	mysql_format(SQL, gQuery, sizeof(gQuery),"UPDATE `server_business` SET `Balance`='%d'  WHERE `ID`='%d' LIMIT 1", bizInfo[businessid][bizBalance], businessid);
	mysql_tquery(SQL, gQuery, "", "");	
	SCM(playerid, COLOR_GREY, string_fast("* Business Notice: Ai bagat in balanta afacerii tale, $%s. Iar acum balanta afacerii tale este de $%s.", formatNumber(suma), formatNumber(bizInfo[businessid][bizBalance])));	
	return true;
}

YCMD:bizoption(playerid, params[], help) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pBusiness] == 0 && playerInfo[playerid][pBusinessID] == -1) return sendPlayerError(playerid, "Nu detii o afacere.");
	if(Dialog_Opened(playerid)) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda cat timp ai un dialog afisat.");
	Dialog_Show(playerid, BIZ_OPTION, DIALOG_STYLE_TABLIST_HEADERS, "Business:", "Option Name\tOption\nTitle\tSchimba Titlul Afacerii\nDescription\tSchimba Descrierea Afacerii", "Select", "Close");	
	return true;
}

YCMD:bizlock(playerid, params[], help) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pBusiness] == 0 && playerInfo[playerid][pBusinessID] == -1) return sendPlayerError(playerid, "Nu detii o afacere.");
	new businessid = playerInfo[playerid][pBusinessID];
	if(bizInfo[businessid][bizLocked] == 0) {
		bizInfo[businessid][bizLocked] = 1;
		SCM(playerid, COLOR_GREY, "* Business Notice: Ai inchis afacerea ta, acum playerii nu mai pot intra.");
	}
	else if(bizInfo[businessid][bizLocked] == 1) {
		bizInfo[businessid][bizLocked] = 0;
		SCM(playerid, COLOR_GREY, "* Business Notice: Ai deschis afacerea ta, acum playerii pot intra.");
	}
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof(gQuery),"UPDATE `server_business` SET `Locked`='%d'  WHERE `ID`='%d' LIMIT 1", bizInfo[businessid][bizLocked], businessid);
	mysql_tquery(SQL, gQuery, "", "");	
	return true;
}

YCMD:sellbiz(playerid, params[], help) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pBusiness] == 0 && playerInfo[playerid][pBusinessID] == -1) return sendPlayerError(playerid, "Nu detii o afacere.");
	new businessid = playerInfo[playerid][pBusinessID], suma;
	if(sscanf(params, "d", suma)) return sendPlayerSyntax(playerid, "/sellbiz <price>");
	bizInfo[businessid][bizPrice] = suma;
	SCM(playerid, COLOR_GREY, string_fast("* Business Notice: Ai pus la vanzare afacerea ta cu pretul $%s. Acum orice player iti poate cumpara afacerea.", formatNumber(suma)));
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof(gQuery),"UPDATE `server_business` SET `Price`='%d'  WHERE `ID`='%d' LIMIT 1", bizInfo[businessid][bizPrice], businessid);
	mysql_tquery(SQL, gQuery, "", "");	
	BusinessUpdate(businessid);
	return true;
}

YCMD:adminbusiness(playerid, params[], help) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pAdmin] < 4) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(Dialog_Opened(playerid)) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda cat timp ai un dialog afisat.");
	new idbiz;
	if(sscanf(params, "d", idbiz)) return sendPlayerSyntax(playerid, "/adminbusiness <business id>");
	if(!Iter_Contains(ServerBusinesses, idbiz)) return sendPlayerError(playerid, "Acest ID nu exista in baza de date.");
	IDSelected[playerid] = idbiz;
	Dialog_Show(playerid, BIZ_OPTION_ADMIN, DIALOG_STYLE_TABLIST_HEADERS, string_fast("Business: %d", idbiz), "Option Name\tOption Task\nTitlu\tSchimba titlul afacerii\nDescrierea\tSchimba descrierea afacerii", "Select", "Cancel");
	return true;
}

YCMD:buy(playerid, params[], help) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(Dialog_Opened(playerid)) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda cat timp ai un dialog afisat.");
	if(playerInfo[playerid][pinBusiness] != 2 && GetPlayerInterior(playerid) == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti intr-un biz de tip 24/7.");	
	Dialog_Show(playerid, BUYBIZ, DIALOG_STYLE_TABLIST_HEADERS, "SERVER: Buy", "Item\tPrice\nPhone\t$1,500\nPhone Book\t$3,500\nWalkie Talkie\t$5,000\n", "Select", "Close");
	return true;
}

YCMD:balance(playerid, params[], help) {
	if(playerInfo[playerid][pinBusiness] != 1 && GetPlayerInterior(playerid) == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti intr-un biz de tip banca.");	
	SCM(playerid, COLOR_GREY, string_fast("* Bank Notice: Ai $%s bani in contul tau bancar.", GetBankMoney(playerid)));
	return true;
}

YCMD:deposit(playerid, params[], help) {
	if(playerInfo[playerid][pinBusiness] != 1 && GetPlayerInterior(playerid) == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti intr-un biz de tip banca.");	
	new depositMoney;
	if(sscanf(params, "d", depositMoney)) return sendPlayerSyntax(playerid, "/deposit <money>");
	if(PlayerMoney(playerid, depositMoney) || depositMoney < 1 || depositMoney > 1000000000) return sendPlayerError(playerid, "Nu ai aceasta suma de bani pentru a deposita.");
	GivePlayerCash(playerid, 0, depositMoney);
	GivePlayerBank(playerid, depositMoney);
	SCM(playerid, COLOR_GREY, string_fast("* Bank Notice: Ai depositat $%s in contul tau. Acum ai in contul bancar: $%s.", formatNumbers(depositMoney), GetBankMoney(playerid)));
	update("UPDATE `server_users` SET `Bank` = '%d', `Money` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pBank], playerInfo[playerid][pMoney], playerInfo[playerid][pSQLID]);
	return true;
}

YCMD:withdraw(playerid, params[], help) {
	if(playerInfo[playerid][pinBusiness] != 1 && GetPlayerInterior(playerid) == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti intr-un biz de tip banca.");	
	new withdrawMoney;
	if(sscanf(params, "d", withdrawMoney)) return sendPlayerSyntax(playerid, "/withdraw <money>");
	if(withdrawMoney < 1 || withdrawMoney > 1000000000) return sendPlayerError(playerid, "Poti scoate din contul tau bancar minim 1$ maxim $1,000,000,000.");
	if(playerInfo[playerid][pStoreBank] == 0 && withdrawMoney > playerInfo[playerid][pBank])return sendPlayerError(playerid, "Nu ai aceasta suma de bani in contul tau. Momentan in contul tau detii $%s.", GetBankMoney(playerid));
	GivePlayerCash(playerid, 1, withdrawMoney);
	GivePlayerBank(playerid, -withdrawMoney);
	SCM(playerid, COLOR_GREY, string_fast("* Bank Notice: Ai scos $%s din contul tau. Acum ai in contul bancar: $%s.", formatNumbers(withdrawMoney), GetBankMoney(playerid)));
	update("UPDATE `server_users` SET `Bank` = '%d', `Money` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pBank], playerInfo[playerid][pMoney], playerInfo[playerid][pSQLID]);
	return true;
}

YCMD:transfer(playerid, params[], help) {
	if(playerInfo[playerid][pinBusiness] != 1 && GetPlayerInterior(playerid) == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti intr-un biz de tip banca.");	
	new userID, transferMoney;
	if(sscanf(params, "ud", userID, transferMoney)) return sendPlayerSyntax(playerid, "/transfer <name/id> <money>");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(Dialog_Opened(playerid)) return sendPlayerError(playerid, "Nu poti folosi comanda cat timp ai un dialog afisat.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel jucator nu este connectat.");
	if(transferMoney < 10000 || transferMoney > 5000000000) return sendPlayerError(playerid, "Poti transfera minim $10,000 si maxim $500,000,000.");
	if(GetPlayerBank(playerid) < transferMoney) return sendPlayerError(playerid, "Nu ai aceste fonduri in contul tau bancar.");
	playerInfo[playerid][pTransferPlayer] = userID;
	playerInfo[playerid][pTransferMoney] = transferMoney;
	Dialog_Show(playerid, TRANSFERBIZ, DIALOG_STYLE_MSGBOX, "Bank:", string_fast("Esti sigur ca vrei sa-i transferi lui %s, suma de $%s?", getName(playerInfo[playerid][pTransferPlayer]), formatNumbers(playerInfo[playerid][pTransferMoney])), "Ok", "Cancel");
	return true;
}

YCMD:ad(playerid, params[], help) {
	if(AdTimer[playerid] != 0) return sendPlayerError(playerid, "Ai pus un anunt recent. Foloseste comanda /myad pentru a-l vedea.");
	if(playerInfo[playerid][pMute] > 0) return sendPlayerError(playerid, "Nu pot folosi aceasta comanda deoarece ai mute.");
	if(playerInfo[playerid][pLevel] < 3) return sendPlayerError(playerid, "Nu ai l`Moevel 3 pentru a folosi aceasta comanda.");
	new idx, length = strlen(params), offset = idx, result[264], totalads = totalAds()+1;
	while ((idx < length) && (params[idx] <= ' ')) idx++;
	while ((idx < length) && ((idx - offset) < (sizeof(result) - 1))) {
		result[idx - offset] = params[idx];
		idx++;
	}
	result[idx - offset] = (EOS);
	if(IsPlayerInRangeOfPoint(playerid, 10, 1170.6370, -1489.7297, 22.7018)) {
		if(!strlen(result)) return sendPlayerSyntax(playerid, "/ad <text>");
		new payad = bizInfo[3][bizFee];
		if(GetPlayerCash(playerid) < payad) return sendPlayerError(playerid, "Nu ai bani necesari pentru a da un ad. Ai folosit %d caractere si anuntul costa $%s.", offset, formatNumber(payad));
		GivePlayerCash(playerid, 0, payad);
		AdTimer[playerid] = totalads*60;
		bizInfo[3][bizBalance] += payad;
		GameTextForPlayer(playerid, string_fast("~r~Ai platit $%d~n~~w~Mesajul contine: %d caractere~n~Acesta va fi afisat in %d minute (%d secunde)", payad, idx, AdTimer[playerid]/60, AdTimer[playerid]), 5000, 5);
		format(AdText[playerid], 256, result);
		sendStaff(COLOR_SERVER, "(Ad Preview): {00D900}Ad by %s ({FFFFFF}%d{00D900}): %s", getName(playerid), playerInfo[playerid][pPhone], result);
		defer advertismentTimer(playerid);
		update("UPDATE `server_business` SET `Balance` = '%d' WHERE `ID` = '3'", bizInfo[3][bizBalance]);	
	}
	return true;
}

YCMD:myad(playerid, params[], help) return SCM(playerid, COLOR_GREY, string_fast("* AD Notice: Ad-ul tau este '%s'", AdText[playerid]));
YCMD:deletemyad(playerid, params[], help) {
	if(AdTimer[playerid] == 0) return sendPlayerError(playerid, "Nu ai un ad pus.");
	AdText[playerid] = "";
	AdTimer[playerid] = 0;
	SCM(playerid, COLOR_GREY, "* AD Notice: Ad-ul tau a fost sters.");
	return true;
}

