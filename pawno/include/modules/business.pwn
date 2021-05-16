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
new bizInfo[MAX_BUSINESSES + 1][businessInfoEnum], Iterator:ServerBusinesses<MAX_BUSINESSES + 1>, Iterator:ServerAds<MAX_PLAYERS>;

hook OnGameModeInit() {
	Iter_Init(ServerBusinesses);
	return true;
}

hook OnPlayerConnect(playerid) {
	IDSelected[playerid] = -1;
	return true;
}

timer advertismentTimer[Iter_Count(ServerAds) * 60000](playerid) {
	sendSplitMessage(playerid, COLOR_SERVER, string_fast("Advertisment by {ffffff}%s{cc66ff}(phone: {ffffff}%d{cc66ff}): '{ffffff}%s{cc66ff}'", getName(playerid), playerInfo[playerid][pPhone], playerInfo[playerid][pAdText]));
	switch(MYSQL) {
		case 1: {
			if (_:MoonBot == 0) MoonBot = DCC_FindChannelById("842858866973737020");
			DCC_SendChannelMessage(MoonBot, string_fast(":newspaper: Ad by **%s[%d]** (phone: **%d**): %s", getName(playerid), playerid, playerInfo[playerid][pPhone], playerInfo[playerid][pAdText]));
		}
	}
	Iter_Remove(ServerAds, playerid);
	playerInfo[playerid][pAdText] = (EOS);
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

		bizInfo[i][bizText] = CreateDynamic3DTextLabel(string_fast("Business ID: %d\nBusiness Title: %s\nBusiness Description: %s\nBusiness Owner: %s\nBusiness Price: $%s\nBusiness Fee: $%s", bizInfo[i][bizID], bizInfo[i][bizTitle], bizInfo[i][bizDescription], bizInfo[i][bizOwner], formatNumber(bizInfo[i][bizPrice]),formatNumber(bizInfo[i][bizFee])), -1, bizInfo[i][bizExtX],bizInfo[i][bizExtY],bizInfo[i][bizExtZ], 20.0, 0xFFFF, 0xFFFF, 0, 0, 0, -1, STREAMER_3D_TEXT_LABEL_SD);
		bizInfo[i][bizPickup] = CreateDynamicPickup(1239, 23, bizInfo[i][bizExtX],bizInfo[i][bizExtY],bizInfo[i][bizExtZ], 0, 0, -1, STREAMER_PICKUP_SD);					
		PickInfo[bizInfo[i][bizPickup]][BIZZ] = i;
		bizInfo[i][bizArea] = CreateDynamicSphere(bizInfo[i][bizExtX],bizInfo[i][bizExtY],bizInfo[i][bizExtZ], 2.0, 0, 0);
		Streamer_SetIntData(STREAMER_TYPE_AREA, bizInfo[i][bizArea], E_STREAMER_EXTRA_ID, (i + BUSINESS_STREAMER_START));	
		switch(bizInfo[i][bizType]) {
			case 1: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],52,0,-1,-1,-1,750.0);
			case 2: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],17,0,-1,-1,-1,750.0); 
			case 3: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],49,0,-1,-1,-1,750.0); 
			case 4: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],16,0,-1,-1,-1,750.0);
			case 5: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],48,0,-1,-1,-1,750.0);
			case 6: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],38,0,-1,-1,-1,750.0);  
			case 7: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],63,0,-1,-1,-1,750.0); 
			case 8: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],7,0,-1,-1,-1,750.0); 
			case 9: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],39,0,-1,-1,-1,750.0); 
			case 10: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],54,0,-1,-1,-1,750.0); 
			case 11: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],45,0,-1,-1,-1,750.0); 
			case 12: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],6,0,-1,-1,-1,750.0); 
		}
	}
	return printf("Businesses: %d [From Database]", Iter_Count(ServerBusinesses));
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
	update("UPDATE `server_business` SET `Title`='%s'  WHERE `ID`='%d' LIMIT 1", inputtext, businessid);
	Update3DTextLabelText(bizInfo[businessid][bizText], COLOR_WHITE, string_fast("Business ID: %d\nBusiness Title: %s\nBusiness Description: %s\nBusiness Owner: %s\nBusiness Price: $%s\nBusiness Fee: $%s", bizInfo[businessid][bizID], bizInfo[businessid][bizTitle], bizInfo[businessid][bizDescription], bizInfo[businessid][bizOwner], formatNumber(bizInfo[businessid][bizPrice]),formatNumber(bizInfo[businessid][bizFee])));
	return true;
}

Dialog:BIZ_OPTION_DESCRIPTION(playerid, response, listitem,  inputtext[]) {
	if(!response) return true;
	if(strlen(inputtext) < 3 || strlen(inputtext) > 64) return Dialog_Show(playerid, BIZ_OPTION_DESCRIPTION, DIALOG_STYLE_INPUT, "Business: Description", "Introdu mai jos ce descriere doresti sa aiba afacerea ta\nMinim 3 caractere / Maxim 64 de caractere.", "Ok", "Cancel");
	new businessid = playerInfo[playerid][pBusinessID];
	format(bizInfo[businessid][bizDescription], 64, inputtext);	
	SCM(playerid, COLOR_GREY, string_fast("* Business Notice: Ai schimbat descrierea afacerii tale, in '%s'.", inputtext));
	update("UPDATE `server_business` SET `Description`='%s'  WHERE `ID`='%d' LIMIT 1", inputtext, businessid);
	Update3DTextLabelText(bizInfo[businessid][bizText], COLOR_WHITE, string_fast("Business ID: %d\nBusiness Title: %s\nBusiness Description: %s\nBusiness Owner: %s\nBusiness Price: $%s\nBusiness Fee: $%s", bizInfo[businessid][bizID], bizInfo[businessid][bizTitle], bizInfo[businessid][bizDescription], bizInfo[businessid][bizOwner], formatNumber(bizInfo[businessid][bizPrice]),formatNumber(bizInfo[businessid][bizFee])));
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
		update("UPDATE `server_business` SET `Owned`='0',`Owner`='AdmBot',`OwnerID`='-1',`Price`='0' WHERE `ID`='%d' LIMIT 1",businessid);
		Update3DTextLabelText(bizInfo[businessid][bizText], COLOR_WHITE, string_fast("Business ID: %d\nBusiness Title: %s\nBusiness Description: %s\nBusiness Owner: %s\nBusiness Price: $%s\nBusiness Fee: $%s", bizInfo[businessid][bizID], bizInfo[businessid][bizTitle], bizInfo[businessid][bizDescription], bizInfo[businessid][bizOwner], formatNumber(bizInfo[businessid][bizPrice]),formatNumber(bizInfo[businessid][bizFee])));
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
	if(listitem == 0) Dialog_Show(playerid, BIZ_OPTION_TITLEADMIN, DIALOG_STYLE_INPUT, "Business: Title", "Introdu mai jos ce titlu doresti sa aiba afacerea", "Ok", "Cancel");
	else if(listitem == 1) Dialog_Show(playerid, BIZ_OPTION_DESCADMIN, DIALOG_STYLE_INPUT, "Business: Description", "Introdu mai jos ce descriere doresti sa aiba afacerea", "Ok", "Cancel");
	return true;
}

Dialog:BIZ_OPTION_TITLEADMIN(playerid, response, listitem, inputtext[]) {
	if(!response) return true;
	if(strlen(inputtext) < 3 || strlen(inputtext) > 32) return Dialog_Show(playerid, BIZ_OPTION_TITLEADMIN, DIALOG_STYLE_INPUT, "Business: Option", "Introdu mai jos ce titlu doresti sa aiba afacerea\nMinim 3 caractere / Maxim 32 caractere.", "Ok", "Cancel");
	format(bizInfo[IDSelected[playerid]][bizTitle], 32, inputtext);
	update("UPDATE `server_business` SET `Title`='%s'  WHERE `ID`='%d' LIMIT 1", inputtext, IDSelected[playerid]);
	Update3DTextLabelText(bizInfo[IDSelected[playerid]][bizText], COLOR_WHITE, string_fast("Business ID: %d\nBusiness Title: %s\nBusiness Description: %s\nBusiness Owner: %s\nBusiness Price: $%s\nBusiness Fee: $%s", bizInfo[IDSelected[playerid]][bizID], bizInfo[IDSelected[playerid]][bizTitle], bizInfo[IDSelected[playerid]][bizDescription], bizInfo[IDSelected[playerid]][bizOwner], formatNumber(bizInfo[IDSelected[playerid]][bizPrice]),formatNumber(bizInfo[IDSelected[playerid]][bizFee])));
	IDSelected[playerid] = -1;
	return true;
}

Dialog:BIZ_OPTION_DESCADMIN(playerid, response, listitem, inputtext[]) {
	if(!response) return true;
	if(strlen(inputtext) < 3 || strlen(inputtext) > 64) return Dialog_Show(playerid, BIZ_OPTION_TITLEADMIN, DIALOG_STYLE_INPUT, "Business: Option", "Introdu mai jos ce titlu doresti sa aiba afacerea\nMinim 3 caractere / Maxim 64 caractere.", "Ok", "Cancel");
	format(bizInfo[IDSelected[playerid]][bizDescription], 64, inputtext);
	update("UPDATE `server_business` SET `Description`='%s'  WHERE `ID`='%d' LIMIT 1", inputtext, IDSelected[playerid]);
	Update3DTextLabelText(bizInfo[IDSelected[playerid]][bizText], COLOR_WHITE, string_fast("Business ID: %d\nBusiness Title: %s\nBusiness Description: %s\nBusiness Owner: %s\nBusiness Price: $%s\nBusiness Fee: $%s", bizInfo[IDSelected[playerid]][bizID], bizInfo[IDSelected[playerid]][bizTitle], bizInfo[IDSelected[playerid]][bizDescription], bizInfo[IDSelected[playerid]][bizOwner], formatNumber(bizInfo[IDSelected[playerid]][bizPrice]),formatNumber(bizInfo[IDSelected[playerid]][bizFee])));
	IDSelected[playerid] = -1;
	return true;
}

Dialog:BUYBIZ(playerid, response, listitem) { 
	if(!response) return true;
	switch(listitem) {
		case 0: {
			if(GetPlayerCash(playerid) < 1500) return sendPlayerError(playerid, "Nu ai $1500.");
			if(playerInfo[playerid][pPhone] > 0) return sendPlayerError(playerid, "Ai deja telefon.");
			if(strlen(playerInfo[playerid][pPhone]) == 4) return sendPlayerError(playerid, "Nu poti cumpara alt telefon deoarece ai un iPhone.");
			new randphone = 5000 + random(9999) + 5000;
			GivePlayerCash(playerid, 0, 1500);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			bizInfo[2][bizBalance] += 1500;
			playerInfo[playerid][pPhone] = randphone;
			update("UPDATE `server_users` SET `Phone` = '%d' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerid][pPhone], playerInfo[playerid][pSQLID]);
			update("UPDATE `server_business` SET `Balance` = '%d' WHERE `ID` = '2' LIMIT 1", bizInfo[2][bizBalance]);
			SCMf(playerid, COLOR_GREY, "* Buy Notice: Ai cumparat un telefon, iar numarul tau este %d.", randphone);
		}
		case 1: {
			if(GetPlayerCash(playerid) < 3500) return sendPlayerError(playerid, "Nu ai $3500.");
			if(playerInfo[playerid][pPhoneBook] > 0) return sendPlayerError(playerid, "Ai deja agenda telefonica.");
			GivePlayerCash(playerid, 0, 3500);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			playerInfo[playerid][pPhoneBook] = 1;
			bizInfo[2][bizBalance] += 3500;
			update("UPDATE `server_users` SET `PhoneBook` = '%d' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerid][pPhoneBook], playerInfo[playerid][pSQLID]);
			update("UPDATE `server_business` SET `Balance` = '%d' WHERE `ID` = '2' LIMIT 1", bizInfo[2][bizBalance]);
			SCM(playerid, COLOR_GREY, "* Buy Notice: Ai cumparat o agenda telefonica.");
		}
		case 2: {
			if(GetPlayerCash(playerid) < 5000) return sendPlayerError(playerid, "Nu ai $5000.");
			if(playerInfo[playerid][pWTalkie] == 1) return sendPlayerError(playerid, "Ai deja un walkie talkie.");
			GivePlayerCash(playerid, 0, 5000);
			PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
			playerInfo[playerid][pWTalkie] = 1;
			bizInfo[2][bizBalance] += 5000;
			update("UPDATE `server_users` SET `WTalkie` = '1' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerid][pSQLID]);
			update("UPDATE `server_business` SET `Balance` = '%d' WHERE `ID` = '2' LIMIT 1", bizInfo[2][bizBalance]);
			SCM(playerid, COLOR_GREY, "* Buy Notice: Ai cumparat un walkie talkie.");			
		}
	}
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
	update("UPDATE `server_users` SET `Bank` = '%d', `MBank` = '%d' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerid][pBank], playerInfo[playerid][pStoreBank], playerInfo[playerid][pSQLID]);
	update("UPDATE `server_users` SET `Bank` = '%d', `MBank` = '%d' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerInfo[playerid][pTransferPlayer]][pBank], playerInfo[playerInfo[playerid][pTransferPlayer]][pStoreBank], playerInfo[playerInfo[playerid][pTransferPlayer]][pSQLID]);
	update("UPDATE `server_business` SET `Balance`='%d' WHERE `ID`='1' LIMIT 1", bizInfo[1][bizBalance]);
	return true;
}

CMD:buybusiness(playerid, params[]) {
	if(playerInfo[playerid][pBusiness] != 0) return sendPlayerError(playerid, "Ai deja o afacere cumparata.");
	if(playerInfo[playerid][pLevel] < 5) return sendPlayerError(playerid, "Trebuie sa detii, minim level 5.");
	if(playerInfo[playerid][areaBizz] != 0 && IsPlayerInRangeOfPoint(playerid, 3.5, bizInfo[playerInfo[playerid][areaBizz]][bizExtX], bizInfo[playerInfo[playerid][areaBizz]][bizExtY], bizInfo[playerInfo[playerid][areaBizz]][bizExtZ])) {
		if(bizInfo[playerInfo[playerid][areaBizz]][bizPrice] == 0) return sendPlayerError(playerid, "Aceasta afacere nu este de vanzare.");
		if(bizInfo[playerInfo[playerid][areaBizz]][bizOwned] == 1) {
			new id = GetPlayerID(bizInfo[playerInfo[playerid][areaBizz]][bizOwner]), moneys, newmoneys;
			gString[0] = (EOS);
			if(id != INVALID_PLAYER_ID) { 
				playerInfo[id][pBusiness] = 0;
				playerInfo[id][pBusinessID] = -1;
				playerInfo[id][pBank] += bizInfo[playerInfo[playerid][areaBizz]][bizPrice];
				SCM(playerid, COLOR_GREY, string_fast("* %s ti-a cumparat afacerea, si ai primit $%s, in banca.", getName(playerid), formatNumber(bizInfo[playerInfo[playerid][areaBizz]][bizPrice])));
				update("UPDATE `server_users` SET `Bank` = '%d', `Business` = '0', `BusinessID` = '-1' WHERE `ID` = '%d' LIMIT 1", playerInfo[id][pBank], playerInfo[id][pSQLID]);
			}
			else {
				new Cache: result = mysql_query(SQL, string_fast("SELECT * FROM `server_users` WHERE `Name` = '%s'", bizInfo[playerInfo[playerid][areaBizz]][bizOwner]));
				if(cache_num_rows() != 0) {
					cache_get_value_name(0, "Bank", gString); moneys = strval(gString);
					newmoneys = moneys + bizInfo[playerInfo[playerid][areaBizz]][bizPrice];
				}
				cache_delete(result);
				update("UPDATE `server_users` SET `Bank` = '%d', `Business` = '0', `BusinessID` = '-1' WHERE `ID` = '%d' LIMIT 1", newmoneys, playerInfo[id][pSQLID]);
			}
			SCM(playerid, COLOR_GREY, string_fast("* Business Notice: Felicitari ! Ai cumparat afacerea cu id %d, si ai platit $%s.", playerInfo[playerid][areaBizz], formatNumber(bizInfo[playerInfo[playerid][areaBizz]][bizPrice])));
			GivePlayerCash(playerid, 0, bizInfo[playerInfo[playerid][areaBizz]][bizPrice]);
			format(bizInfo[playerInfo[playerid][areaBizz]][bizOwner], 32, getName(playerid));
			playerInfo[playerid][pBusiness] = 1;
			playerInfo[playerid][pBusinessID] = playerInfo[playerid][areaBizz];
			bizInfo[playerInfo[playerid][areaBizz]][bizOwned] = 1;
			bizInfo[playerInfo[playerid][areaBizz]][bizPrice] = 0;
			Update3DTextLabelText(bizInfo[playerInfo[playerid][areaBizz]][bizText], COLOR_WHITE, string_fast("Business ID: %d\nBusiness Title: %s\nBusiness Description: %s\nBusiness Owner: %s\nBusiness Price: $%s\nBusiness Fee: $%s", bizInfo[playerInfo[playerid][areaBizz]][bizID], bizInfo[playerInfo[playerid][areaBizz]][bizTitle], bizInfo[playerInfo[playerid][areaBizz]][bizDescription], bizInfo[playerInfo[playerid][areaBizz]][bizOwner], formatNumber(bizInfo[playerInfo[playerid][areaBizz]][bizPrice]),formatNumber(bizInfo[playerInfo[playerid][areaBizz]][bizFee])));
			update("UPDATE `server_users` SET `Business` = '1', `BusinessID` = '%d' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerid][areaBizz], playerInfo[playerid][pSQLID]);
			update("UPDATE `server_business` SET `Owned`='1',`Owner`='%s',`OwnerID`='%d',`Price`='0' WHERE `ID`='%d' LIMIT 1",bizInfo[playerInfo[playerid][areaBizz]][bizOwner], playerInfo[playerid][pSQLID], playerInfo[playerid][areaBizz]);
		}
		else if(bizInfo[playerInfo[playerid][areaBizz]][bizOwned] == 0) {
			SCM(playerid, COLOR_GREY, string_fast("* Business Notice: Felicitari ! Ai cumparat afacerea cu id %d, si ai platit $%s.", playerInfo[playerid][areaBizz], formatNumber(bizInfo[playerInfo[playerid][areaBizz]][bizPrice])));
			GivePlayerCash(playerid, 0, bizInfo[playerInfo[playerid][areaBizz]][bizPrice]);
			format(bizInfo[playerInfo[playerid][areaBizz]][bizOwner], 32, getName(playerid));
			playerInfo[playerid][pBusiness] = 1;
			playerInfo[playerid][pBusinessID] = playerInfo[playerid][areaBizz];
			GivePlayerCash(playerid, 0, bizInfo[playerInfo[playerid][areaBizz]][bizPrice]);
			bizInfo[playerInfo[playerid][areaBizz]][bizOwned] = 1;
			bizInfo[playerInfo[playerid][areaBizz]][bizPrice] = 0;
			Update3DTextLabelText(bizInfo[playerInfo[playerid][areaBizz]][bizText], COLOR_WHITE, string_fast("Business ID: %d\nBusiness Title: %s\nBusiness Description: %s\nBusiness Owner: %s\nBusiness Price: $%s\nBusiness Fee: $%s", bizInfo[playerInfo[playerid][areaBizz]][bizID], bizInfo[playerInfo[playerid][areaBizz]][bizTitle], bizInfo[playerInfo[playerid][areaBizz]][bizDescription], bizInfo[playerInfo[playerid][areaBizz]][bizOwner], formatNumber(bizInfo[playerInfo[playerid][areaBizz]][bizPrice]),formatNumber(bizInfo[playerInfo[playerid][areaBizz]][bizFee])));
			update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d', `Business` = '1', `BusinessID` = '%d' WHERE `ID` = '%d' LIMIT 1", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][areaBizz], playerInfo[playerid][pSQLID]);
			update("UPDATE `server_business` SET `Owned`='1',`Owner`='%s',`OwnerID`='%d',`Price`='0' WHERE `ID`='%d' LIMIT 1",bizInfo[playerInfo[playerid][areaBizz]][bizOwner],playerInfo[playerid][pSQLID], playerInfo[playerid][areaBizz]);
		}
	}
	return true;
}

CMD:sellbizstate(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti face aceasta actiune, deoarece esti in masina.");
	if(GetPlayerVirtualWorld(playerid) != 0 && GetPlayerInterior(playerid) != 0 && playerInfo[playerid][pinBusiness] != -1) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda deoarece, esti intr-un alt virtualworld / interior / esti intr-un business.");
	if(playerInfo[playerid][pBusiness] == 0 && playerInfo[playerid][pBusinessID] == -1) return sendPlayerError(playerid, "Nu detii o afacere.");
	Dialog_Show(playerid, SELL_BIZ_STATE, DIALOG_STYLE_MSGBOX, "Business:", "Esti sigur ca doresti sa-ti vinzi afacerea, pe $150,000?\nDaca apesi pe butonul 'da', nu mai exista cale de intoarcere.", "Da", "Nu");
	return true;
}

CMD:bizbalance(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pBusiness] == 0 && playerInfo[playerid][pBusinessID] == -1) return sendPlayerError(playerid, "Nu detii o afacere.");
	new businessid = playerInfo[playerid][pBusinessID];
	SCM(playerid, COLOR_GREY, string_fast("* Business Notice: Balanta ta la afacere este de $%s.", formatNumber(bizInfo[businessid][bizBalance])));
	return true;
}

CMD:bizwithdraw(playerid, params[]) {
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
	update("UPDATE `server_business` SET `Balance`='%d'  WHERE `ID`='%d' LIMIT 1", bizInfo[businessid][bizBalance], businessid);
	SCM(playerid, COLOR_GREY, string_fast("* Business Notice: Ai retras din balanta afacerii tale, $%s. Iar acum balanta afacerii tale este de $%s.", formatNumber(suma), formatNumber(bizInfo[businessid][bizBalance])));	
	return true;
}

CMD:bizdeposit(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pBusiness] == 0 && playerInfo[playerid][pBusinessID] == -1) return sendPlayerError(playerid, "Nu detii o afacere.");
	new businessid = playerInfo[playerid][pBusinessID], suma;
	if(playerInfo[playerid][pinBusiness] != businessid) return sendPlayerError(playerid, "Poti folosi aceasta comanda doar din interiorul afacerii tale.");
	if(sscanf(params, "d", suma)) return sendPlayerSyntax(playerid, "/bizdeposit <money>");
	if(GetPlayerCash(playerid) < suma) return sendPlayerError(playerid, "Nu ai suma aceasta de bani, pentru a adauga in balanta afacerii tale.");
	bizInfo[businessid][bizBalance] += suma;
	GivePlayerCash(playerid, 0, suma);
	update("UPDATE `server_business` SET `Balance`='%d'  WHERE `ID`='%d' LIMIT 1", bizInfo[businessid][bizBalance], businessid);
	SCM(playerid, COLOR_GREY, string_fast("* Business Notice: Ai bagat in balanta afacerii tale, $%s. Iar acum balanta afacerii tale este de $%s.", formatNumber(suma), formatNumber(bizInfo[businessid][bizBalance])));	
	return true;
}

CMD:bizoption(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pBusiness] == 0 && playerInfo[playerid][pBusinessID] == -1) return sendPlayerError(playerid, "Nu detii o afacere.");
	if(Dialog_Opened(playerid)) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda cat timp ai un dialog afisat.");
	Dialog_Show(playerid, BIZ_OPTION, DIALOG_STYLE_TABLIST_HEADERS, "Business:", "Option Name\tOption\nTitle\tSchimba Titlul Afacerii\nDescription\tSchimba Descrierea Afacerii", "Select", "Close");	
	return true;
}

CMD:bizlock(playerid, params[]) {
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
	update("UPDATE `server_business` SET `Locked`='%d'  WHERE `ID`='%d' LIMIT 1", bizInfo[businessid][bizLocked], businessid);
	return true;
}

CMD:sellbiz(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(playerInfo[playerid][pBusiness] == 0 && playerInfo[playerid][pBusinessID] == -1) return sendPlayerError(playerid, "Nu detii o afacere.");
	new businessid = playerInfo[playerid][pBusinessID], suma;
	if(sscanf(params, "d", suma)) return sendPlayerSyntax(playerid, "/sellbiz <price>");
	bizInfo[businessid][bizPrice] = suma;
	SCMf(playerid, COLOR_GREY, "* Business Notice: Ai pus la vanzare afacerea ta cu pretul $%s. Acum orice player iti poate cumpara afacerea.", formatNumber(suma));
	update("UPDATE `server_business` SET `Price`='%d'  WHERE `ID`='%d' LIMIT 1", bizInfo[businessid][bizPrice], businessid);
	Update3DTextLabelText(bizInfo[businessid][bizText], COLOR_WHITE, string_fast("Business ID: %d\nBusiness Title: %s\nBusiness Description: %s\nBusiness Owner: %s\nBusiness Price: $%s\nBusiness Fee: $%s", bizInfo[businessid][bizID], bizInfo[businessid][bizTitle], bizInfo[businessid][bizDescription], bizInfo[businessid][bizOwner], formatNumber(bizInfo[businessid][bizPrice]),formatNumber(bizInfo[businessid][bizFee])));
	return true;
}

CMD:adminbusiness(playerid, params[]) {
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

CMD:buy(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(Dialog_Opened(playerid)) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda cat timp ai un dialog afisat.");
	if(playerInfo[playerid][pinBusiness] == 0 && bizInfo[playerInfo[playerid][pinBusiness]][bizType] != 2) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti intr-un biz de tip 24/7.");	
	Dialog_Show(playerid, BUYBIZ, DIALOG_STYLE_TABLIST_HEADERS, "SERVER: Buy", "Item\tPrice\nPhone\t$1,500\nPhone Book\t$3,500\nWalkie Talkie\t$5,000\n", "Select", "Close");
	return true;
}

CMD:balance(playerid, params[]) {
	if(playerInfo[playerid][pinBusiness] != 1 && GetPlayerInterior(playerid) == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti intr-un biz de tip banca.");	
	SCMf(playerid, COLOR_GREY, "* Bank Notice: Ai $%s bani in contul tau bancar.", GetBankMoney(playerid));
	return true;
}

CMD:deposit(playerid, params[]) {
	if(playerInfo[playerid][pinBusiness] != 1 && GetPlayerInterior(playerid) == 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece nu esti intr-un biz de tip banca.");	
	new depositMoney;
	if(sscanf(params, "d", depositMoney)) return sendPlayerSyntax(playerid, "/deposit <money>");
	if(PlayerMoney(playerid, depositMoney) || depositMoney < 1 || depositMoney > 1000000000) return sendPlayerError(playerid, "Nu ai aceasta suma de bani pentru a deposita.");
	GivePlayerCash(playerid, 0, depositMoney);
	GivePlayerBank(playerid, depositMoney);
	SCM(playerid, COLOR_GREY, string_fast("* Bank Notice: Ai depositat $%s in contul tau. Acum ai in contul bancar: $%s.", formatNumbers(depositMoney), GetBankMoney(playerid)));
	update("UPDATE `server_users` SET `Bank` = '%d', `Money` = '%d' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerid][pBank], playerInfo[playerid][pMoney], playerInfo[playerid][pSQLID]);
	return true;
}

CMD:withdraw(playerid, params[]) {
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

CMD:transfer(playerid, params[]) {
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

CMD:ad(playerid, params[]) {
	if(!IsPlayerInRangeOfPoint(playerid, 10, bizInfo[3][bizExtX],bizInfo[3][bizExtY],bizInfo[3][bizExtZ])) return sendPlayerError(playerid, "Nu te afli in fata unui CNN.");
	if(strlen(playerInfo[playerid][pPhone]) == 0) return sendPlayerError(playerid, "Nu ai un telefon.");
	if(strlen(playerInfo[playerid][pAdText]) > 0) return sendPlayerError(playerid, "Ai pus un anunt recent. Foloseste comanda /myad pentru a-l vedea.");
	if(playerInfo[playerid][pMute] > gettime()) return sendPlayerError(playerid, "Nu pot folosi aceasta comanda deoarece ai mute.");
	if(playerInfo[playerid][pLevel] < 3) return sendPlayerError(playerid, "Nu ai level 3+ pentru a folosi aceasta comanda.");
	printf("are atat %d si trebuie %d bani", GetPlayerCash(playerid), bizInfo[3][bizFee]);
	if(!PlayerMoney(playerid, bizInfo[3][bizFee])) return SCMf(playerid, COLOR_ERROR, "[ERROR] {FFFFFF}Trebuie sa ai minim $%s pentru a pune un anunt.", formatNumber(bizInfo[3][bizFee]));
	if(!strlen(params)) return sendPlayerSyntax(playerid, "/ad <text>");
	format(playerInfo[playerid][pAdText], 256, params);
	sendStaff(COLOR_SERVER, "(Ad Preview): {ffffff}Ad by %s (%d): %s", getName(playerid), playerInfo[playerid][pPhone], params);
	va_GameTextForPlayer(playerid, "Ai platit ~p~$%s~w~~n~Mesajul contine: ~p~%d~w~ caractere~n~Acesta va fi afisat in ~p~%s", 10000, 5, formatNumber(bizInfo[3][bizFee]), strlen(params), secinmin(Iter_Count(ServerAds) * 60));
	defer advertismentTimer(playerid);
	Iter_Add(ServerAds, playerid);
	GivePlayerCash(playerid, 0, bizInfo[3][bizFee]);
	bizInfo[3][bizBalance] += bizInfo[3][bizFee];
	update("UPDATE `server_business` SET `Balance` = '%d' WHERE `ID` = '3' LIMIT 1", bizInfo[3][bizBalance]);
	return true;
}

CMD:myad(playerid, params[]) {
	if(strlen(playerInfo[playerid][pAdText]) == 0) return sendPlayerError(playerid, "Nu ai un advertisment pus.");
	SCMf(playerid, COLOR_SERVER, "* (Advertisment): {ffffff}Advertisment-ul tau este '%s'.", playerInfo[playerid][pAdText]);
	return true;
}

CMD:deletemyad(playerid, params[]) {
	if(strlen(playerInfo[playerid][pAdText]) == 0) return sendPlayerError(playerid, "Nu ai un advertisment pus.");
	playerInfo[playerid][pAdText] = (EOS);
	stop advertismentTimer(playerid);
	Iter_Remove(ServerAds, playerid);
	SCM(playerid, COLOR_SERVER, "* (Advertisment): {ffffff}Advertisment-ul tau a fost sters.");
	return true;
}

CMD:createbusiness(playerid, params[], help) {
	if(playerInfo[playerid][pAdmin] < 6) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(Iter_Count(ServerBusinesses) >= MAX_BUSINESSES) return sendPlayerError(playerid, "Database:Limita de business-uri a fost atinsa !");
	extract params -> new string:type[32], level, price, bizbalance, locked; else {
		SCM(playerid, COLOR_GREY, "Optiuni Type: bank, shop, bar, cnn, club, sexshop, pns, barber, tatoo, gym, binco, gunshop.| Price: 0$ - not for sale ; > 0$ for sale");
		return sendPlayerSyntax(playerid, "/createbusiness <type> <level> <price> <biz balance> <locked (0 - no | 1 - yes)");
	}
	if(!(1 <= level <= 30)) return sendPlayerError(playerid, "Invalid level (1 - 30).");
	if(!(0 <= price <= 100000000)) return sendPlayerError(playerid, "Invalid price (0$ - 100,000,000$).");
	if(!(0 <= locked <= 1)) return sendPlayerError(playerid, "Invalid locked (0 - no | 1 - yes).");
	new i = Iter_Count(ServerBusinesses) + 1;
	Iter_Add(ServerBusinesses, i);
	bizInfo[i][bizID] = i;
	bizInfo[i][bizLocked] = locked;
	GetPlayerPos(playerid, bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ]);
	switch(YHash(type)) {
		case _H<bank>: {
			bizInfo[i][bizType] = 1; bizInfo[i][bizX] = 2315.952880; bizInfo[i][bizY] = -1.618174; bizInfo[i][bizZ] = 26.742187; bizInfo[i][bizInterior] = 0; bizInfo[i][bizStatic] = 0;
		}
		case _H<shop>: {
			bizInfo[i][bizType] = 2; bizInfo[i][bizX] = -25.884498; bizInfo[i][bizY] = -185.868988; bizInfo[i][bizZ] = 1003.546875; bizInfo[i][bizInterior] = 17; bizInfo[i][bizStatic] = 0;
		}
		case _H<bar>: { 
			bizInfo[i][bizType] = 3; bizInfo[i][bizX] = 501.980987; bizInfo[i][bizY] = -69.150199; bizInfo[i][bizZ] = 998.757812;bizInfo[i][bizInterior] = 11; bizInfo[i][bizStatic] = 0;
		}
		case _H<cnn>: { 
			bizInfo[i][bizType] = 4; bizInfo[i][bizX] = 0; bizInfo[i][bizY] = 0; bizInfo[i][bizZ] = 0; bizInfo[i][bizInterior] = 0; bizInfo[i][bizStatic] = 1;
		}
		case _H<club>: { 
			bizInfo[i][bizType] = 5;  bizInfo[i][bizX] = 493.390991; bizInfo[i][bizY] = -22.722799; bizInfo[i][bizZ] = 1000.679687; bizInfo[i][bizInterior] = 17; bizInfo[i][bizStatic] = 0;
		}
		case _H<sexshop>: {
			bizInfo[i][bizType] = 6;  bizInfo[i][bizX] = -103.559165; bizInfo[i][bizY] = -24.225606; bizInfo[i][bizZ] = 1000.718750; bizInfo[i][bizInterior] = 3; bizInfo[i][bizStatic] = 0;
		}
		case _H<pns>: {
			bizInfo[i][bizType] = 7;  bizInfo[i][bizX] = 0; bizInfo[i][bizY] = 0; bizInfo[i][bizZ] = 0; bizInfo[i][bizInterior] = 0; bizInfo[i][bizStatic] = 1;	
		}
		case _H<barber>: {
			bizInfo[i][bizType] = 8;  bizInfo[i][bizX] = 411.625976; bizInfo[i][bizY] = -21.433298; bizInfo[i][bizZ] = 1001.804687; bizInfo[i][bizInterior] = 2; bizInfo[i][bizStatic] = 0;	
		}
		case _H<tatoo>: {
			bizInfo[i][bizType] = 9;  bizInfo[i][bizX] = -204.439987; bizInfo[i][bizY] = -26.453998; bizInfo[i][bizZ] = 1002.273437; bizInfo[i][bizInterior] = 16; bizInfo[i][bizStatic] = 0;	
		}
		case _H<gym>: {
			bizInfo[i][bizType] = 10;  bizInfo[i][bizX] = 773.579956; bizInfo[i][bizY] = -77.096694; bizInfo[i][bizZ] = 1000.655029; bizInfo[i][bizInterior] = 7; bizInfo[i][bizStatic] = 0;	
		} 
		case _H<binco>: {
			bizInfo[i][bizType] = 11;  bizInfo[i][bizX] = 207.737991; bizInfo[i][bizY] = -109.019996; bizInfo[i][bizZ] = 1005.132812; bizInfo[i][bizInterior] = 15; bizInfo[i][bizStatic] = 0;			
		}
		case _H<gunshop>: {
			bizInfo[i][bizType] = 12;  bizInfo[i][bizX] = 286.800994; bizInfo[i][bizY] = -82.547599; bizInfo[i][bizZ] = 1001.515625; bizInfo[i][bizInterior] = 4; bizInfo[i][bizStatic] = 0;					
		} 
		default: {
			SCM(playerid, COLOR_GREY, "Optiuni Type: bank, shop, bar, cnn, club, sexshop, pns, barber, tatoo, gym, binco, gunshop. | Price: 0$ - not for sale ; > 0$ for sale");
			return sendPlayerSyntax(playerid, "/createbusiness <type> <level> <price> <biz balance> <locked (0 - no | 1 - yes)");
		}
	}
	format(bizInfo[i][bizOwner], 32, "Admbot");
	format(bizInfo[i][bizDescription], 64, "A new business");
	format(bizInfo[i][bizTitle], 32, "A new business %s", type);
	bizInfo[i][bizFee] = 500; bizInfo[i][bizOwned] = 1; bizInfo[i][bizPrice] = price; bizInfo[i][bizOwnerID] = -1; bizInfo[i][bizBalance] = bizBalance; 
	bizInfo[i][bizText] = CreateDynamic3DTextLabel(string_fast("Business ID: %d\nBusiness Title: %s\nBusiness Description: %s\nBusiness Owner: %s\nBusiness Price: $%s\nBusiness Fee: $%s", bizInfo[i][bizID], bizInfo[i][bizTitle], bizInfo[i][bizDescription], bizInfo[i][bizOwner], formatNumber(bizInfo[i][bizPrice]),formatNumber(bizInfo[i][bizFee])), -1, bizInfo[i][bizExtX],bizInfo[i][bizExtY],bizInfo[i][bizExtZ], 20.0, 0xFFFF, 0xFFFF, 0, 0, 0, -1, STREAMER_3D_TEXT_LABEL_SD);
	bizInfo[i][bizPickup] = CreateDynamicPickup(1239, 23, bizInfo[i][bizExtX],bizInfo[i][bizExtY],bizInfo[i][bizExtZ], 0, 0, -1, STREAMER_PICKUP_SD);					
	PickInfo[bizInfo[i][bizPickup]][BIZZ] = i;
	bizInfo[i][bizArea] = CreateDynamicSphere(bizInfo[i][bizExtX],bizInfo[i][bizExtY],bizInfo[i][bizExtZ], 2.0, 0, 0);
	Streamer_SetIntData(STREAMER_TYPE_AREA, bizInfo[i][bizArea], E_STREAMER_EXTRA_ID, (i + BUSINESS_STREAMER_START));	
	switch(bizInfo[i][bizType]) {
		case 1: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],52,0,-1,-1,-1,750.0);
		case 2: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],17,0,-1,-1,-1,750.0); 
		case 3: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],49,0,-1,-1,-1,750.0); 
		case 4: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],16,0,-1,-1,-1,750.0);
		case 5: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],48,0,-1,-1,-1,750.0);
		case 6: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],38,0,-1,-1,-1,750.0);  
		case 7: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],63,0,-1,-1,-1,750.0); 
		case 8: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],7,0,-1,-1,-1,750.0); 
		case 9: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],39,0,-1,-1,-1,750.0); 
		case 10: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],54,0,-1,-1,-1,750.0); 
		case 11: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],45,0,-1,-1,-1,750.0); 
		case 12: CreateDynamicMapIcon(bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ],6,0,-1,-1,-1,750.0); 
	}
	update("INSERT INTO `server_business` (`Title`, `Description`, `Owner`, `X`, `Y`, `Z`, `ExtX`, `ExtY`, `ExtZ`, `Static`, `Type`, `Interior`, `Price`) VALUES('%s', '%s', '%s', '%.2f', '%.2f', '%.2f', '%.2f', '%.2f', '%.2f', '%d', '%d', '%d', '%d')", bizInfo[i][bizTitle], bizInfo[i][bizDescription], bizInfo[i][bizOwner], bizInfo[i][bizX], bizInfo[i][bizY], bizInfo[i][bizZ], bizInfo[i][bizExtX], bizInfo[i][bizExtY], bizInfo[i][bizExtZ], bizInfo[i][bizStatic], bizInfo[i][bizType], bizInfo[i][bizInterior], bizInfo[i][bizPrice]);
	SCMf(playerid, COLOR_SERVER, "* Notice: {ffffff}Ai creat un business de tip '%s' (id: %d | level: %d | price: $%s | biz balance: $%s | locked: %s).", type, bizInfo[i][bizID], bizInfo[i][bizPrice], formatNumber(bizInfo[i][bizPrice]), formatNumber(bizInfo[i][bizBalance]), bizInfo[i][bizLocked] ? "yes" : "no");
	return true;
}