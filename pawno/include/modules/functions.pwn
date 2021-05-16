function MySQLLoad() {
	mysql_log(ERROR | WARNING);
	switch(MYSQL) {
		case 0: { // LocalHost
			SQL = mysql_connect("localhost", "root", "", "from0");
		}
		case 1: { // MainHost
			SQL = mysql_connect("188.212.100.198", "client106_samp", "qyYw7BB2S4EFwWbu", "client106_samp"); 
		}
	}
	if(mysql_errno() != 0) {
		mysql_close(SQL);
		destroyServerTextDraws();
		SetGameModeText("MYSQL Error");
		SendRconCommand("password MYSQLError");
		print("[MYSQL] Baza de date, nu s-a conectat.");
	}
	else {
		mysql_tquery(SQL, "SELECT * FROM `server_exam_checkpoints`", "LoadExamCheckpoints", "");
		mysql_tquery(SQL, "SELECT * FROM `server_pickups`", "LoadPickups", "");
		mysql_tquery(SQL, "SELECT * FROM `server_labels`", "LoadLabels", "");
		mysql_tquery(SQL, "SELECT * FROM `server_jobs`", "LoadJobs", "");
		mysql_tquery(SQL, "SELECT * FROM `server_business`", "LoadBusinesses", "");
		mysql_tquery(SQL, "SELECT * FROM `server_houses`", "LoadHouses", "");
		mysql_tquery(SQL, "SELECT * FROM `server_ds`", "LoadDSVehicles", "");
		mysql_tquery(SQL, "SELECT * FROM `server_factions`", "LoadFactions", "");
		mysql_tquery(SQL, "SELECT * FROM `server_turfs`", "LoadTurfs", "");
		mysql_tquery(SQL, "SELECT * FROM `server_safes`", "LoadSafes", "");
		mysql_tquery(SQL, "SELECT * FROM `server_clans`", "LoadClans", "");
		print("[MYSQL] Baza de date, s-a conectat.");
		SetGameModeText("RPG "VERSION);
		serverTextDraws();
	}
	return true;
}

function MyHttpResponse(playerid, response_code, data[]) {
	if(response_code == 200) {
		switch(YHash(data)) {
			case _H<Y>: {
				sendAdmin(COLOR_LIGHTRED, "** MoonBot: {ffffff}%s a incercat sa se conecteze cu VPN.", getName(playerid));
				SCM(playerid, COLOR_LIGHTRED, "** MoonBot: {ffffff}Trebuie sa scoti VPN, pentru a te putea connecta pe acest server.");
				defer kickEx(playerid);
			}
			case _H<X>: sendAdmin(COLOR_LIGHTRED, "** MoonBot: {ffffff}%s posibil sa se fii conectat cu VPN.", getName(playerid));
			case _H<E>: sendAdmin(COLOR_LIGHTRED, "** MoonBot: {ffffff}%s are un ip gresit, posibil sa se fii conectat cu VPN.", getName(playerid));
			case _H<N>: {
				GameTextForPlayer(playerid, "~p~YOUR ACCOUNT IT'S GOOD", 1000, 3);
				gQuery[0] = (EOS);
				mysql_format(SQL, gQuery, 128, "SELECT * FROM `server_bans` WHERE `Active` = '1' AND `PlayerName` = '%s' LIMIT 1", getName(playerid));
				mysql_tquery(SQL, gQuery, "checkPlayerBan", "d", playerid);
			}
			default: printf("[ANTI-VPN] Eroare de request: %d", response_code);
		}
	}
    else printf("[ANTI-VPN] HTTP ERROR: %d", response_code);
	return 1;
}

function checkPlayerBan(playerid) {
	playerInfo[playerid][pLoginEnabled] = true;
	
	if(!cache_num_rows()) {
		gQuery[0] = (EOS);
		mysql_format(SQL, gQuery, 256, "SELECT * FROM `server_bans_ip` WHERE `Active` = '1' AND `PlayerIP` = '%s' LIMIT 1", getIp(playerid));
		mysql_tquery(SQL, gQuery, "checkPlayerBanIP", "d", playerid);
		return true;
	}

	new adminName[MAX_PLAYER_NAME], reason[64], date[32], days, playerID, permanent;
	cache_get_value_name(0, "AdminName", adminName, MAX_PLAYER_NAME);
	cache_get_value_name(0, "Reason", reason, 64);
	cache_get_value_name(0, "Date", date, 32);
	cache_get_value_name_int(0, "Permanent", permanent);
	cache_get_value_name_int(0, "Days", days);
	cache_get_value_name_int(0, "ID", playerID);
	
	if(permanent) {
		SCMf(playerid, COLOR_LIGHTRED, "System: Esti banat permanent pe acest server de catre Admin %s.", adminName);
		SCMf(playerid, COLOR_LIGHTRED, "System: Motivul banului: %s", reason);
		SCMf(playerid, COLOR_LIGHTRED, "System: Data banului: %s", date);
		defer kickEx(playerid);
		return true;
	}
	if(days >= 1)
	{
		SCMf(playerid, COLOR_LIGHTRED, "System: Esti banat temporar pe acest server de catre Admin %s.", adminName);
		SCMf(playerid, COLOR_LIGHTRED, "System: Motivul banului: %s", reason);
		SCMf(playerid, COLOR_LIGHTRED, "System: Data banului: %s", date);
		SCMf(playerid, COLOR_LIGHTRED, "System: Banul expira in: %d zile.",days);
		defer kickEx(playerid);
		return true;
	}

	update("UPDATE `server_bans` SET `Active` = '0' WHERE `ID` = '%d'", playerID);
	sendAdmin(COLOR_SERVER, "Ban System Notice: {ffffff}%s a primit unban automat.", getName(playerid));

	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, 256, "SELECT * FROM `server_bans_ip` WHERE `Active` = '1' AND `PlayerIP` = '%s' LIMIT 1", getIp(playerid));
	mysql_tquery(SQL, gQuery, "checkPlayerBanIP", "d", playerid);
	return true;
}

function onPlayerLogin(playerid)
{
	if(!cache_num_rows())
		return wrongPass(playerid);

	SpawnPlayer(playerid);
	playerInfo[playerid][pLogged] = true;
	playerInfo[playerid][pLoginEnabled] = false;
	playerInfo[playerid][pLoginTries] = 0;
	stop playerInfo[playerid][pLoginTimer];

	cache_get_value_name(0, "Password", playerInfo[playerid][pPassword], 65);
	cache_get_value_name(0, "EMail", playerInfo[playerid][pEMail], 128);
	cache_get_value_name(0, "IP", playerInfo[playerid][pIp], 16);

	cache_get_value_name_int(0, "ID", playerInfo[playerid][pSQLID]);
	cache_get_value_name_bool(0, "Tutorial", playerInfo[playerid][pTutorial]);
	cache_get_value_name_int(0, "Gender", playerInfo[playerid][pGender]);
 	cache_get_value_name_int(0, "Skin", playerInfo[playerid][pSkin]);
	cache_get_value_name_int(0, "Admin", playerInfo[playerid][pAdmin]);
	cache_get_value_name_int(0, "Helper", playerInfo[playerid][pHelper]);
	cache_get_value_name_int(0, "Level", playerInfo[playerid][pLevel]);
	cache_get_value_name_int(0, "RespectPoints", playerInfo[playerid][pRespectPoints]);
	cache_get_value_name_int(0, "Money", MoneyMoney[playerid]);
	cache_get_value_name_int(0, "MStore", StoreMoney[playerid]);
	cache_get_value_name_int(0, "Bank", playerInfo[playerid][pBank]);
	cache_get_value_name_int(0, "MBank", playerInfo[playerid][pStoreBank]);
 	cache_get_value_name_float(0, "Hours", playerInfo[playerid][pHours]);
	cache_get_value_name_float(0, "Seconds", playerInfo[playerid][pSeconds]);
	cache_get_value_name_int(0, "Mute", playerInfo[playerid][pMute]); 
	cache_get_value_name_int(0, "Warn", playerInfo[playerid][pWarn]);
 	cache_get_value_name_int(0, "Job", playerInfo[playerid][pJob]);
	cache_get_value_name_int(0, "Business", playerInfo[playerid][pBusiness]);
	cache_get_value_name_int(0, "BusinessID", playerInfo[playerid][pBusinessID]);
	cache_get_value_name_int(0, "House", playerInfo[playerid][pHouse]);
	cache_get_value_name_int(0, "HouseID", playerInfo[playerid][pHouseID]);
	cache_get_value_name_int(0, "SpawnChange", playerInfo[playerid][pSpawnChange]);
	cache_get_value_name_int(0, "Rent", playerInfo[playerid][pRent]);
	cache_get_value_name_int(0, "VehicleSlots", playerInfo[playerid][pVehicleSlots]);
	cache_get_value_name_int(0, "FishTimes", playerInfo[playerid][pFishTimes]);
	cache_get_value_name_int(0, "FishSkill", playerInfo[playerid][pFishSkill]);
	cache_get_value_name_int(0, "TruckTimes", playerInfo[playerid][pTruckTimes]);
	cache_get_value_name_int(0, "TruckSkill", playerInfo[playerid][pTruckSkill]);
	cache_get_value_name_int(0, "ArmsTimes", playerInfo[playerid][pArmsTimes]);
 	cache_get_value_name_int(0, "ArmsSkill", playerInfo[playerid][pArmsSkill]);
  	cache_get_value_name_int(0, "DrugsTimes", playerInfo[playerid][pDrugsTimes]);
	cache_get_value_name_int(0, "DrugsSkill", playerInfo[playerid][pDrugsSkill]);
	cache_get_value_name_int(0, "CarpenterTimes", playerInfo[playerid][pCarpenterTimes]);
	cache_get_value_name_int(0, "CarpenterSkill", playerInfo[playerid][pCarpenterSkill]);
	cache_get_value_name_int(0, "Drugs", playerInfo[playerid][pDrugs]);
	cache_get_value_name_int(0, "Mats", playerInfo[playerid][pMats]);
	cache_get_value_name_int(0, "ReportMute", playerInfo[playerid][pReportMute]);
	cache_get_value_name_int(0, "Faction", playerInfo[playerid][pFaction]);
	cache_get_value_name_int(0, "FPunish", playerInfo[playerid][pFactionPunish]);
	cache_get_value_name_int(0, "FWarns", playerInfo[playerid][pFactionWarns]);
	cache_get_value_name_int(0, "FAge", playerInfo[playerid][pFactionAge]);
	cache_get_value_name_int(0, "FRank", playerInfo[playerid][pFactionRank]);
	cache_get_value_name_int(0, "Phone", playerInfo[playerid][pPhone]);
	cache_get_value_name_int(0, "PhoneBook", playerInfo[playerid][pPhoneBook]);
	cache_get_value_name_int(0, "WantedLevel", playerInfo[playerid][pWantedLevel]);
	cache_get_value_name_int(0, "Jailed", playerInfo[playerid][pJailed]);
	cache_get_value_name_int(0, "JailTime", playerInfo[playerid][pJailTime]);
	cache_get_value_name_int(0, "Arrested", playerInfo[playerid][pArrested]);
	cache_get_value_name_int(0, "WantedDeaths", playerInfo[playerid][pWantedDeaths]);
 	cache_get_value_name_int(0, "Commands", playerInfo[playerid][pCommands]);
 	cache_get_value_name_int(0, "DailyMission", playerInfo[playerid][pDailyMission][0]);
 	cache_get_value_name_int(0, "DailyMission2", playerInfo[playerid][pDailyMission][1]);
 	cache_get_value_name_int(0, "NeedProgress1", playerInfo[playerid][pNeedProgress][0]);
 	cache_get_value_name_int(0, "NeedProgress2", playerInfo[playerid][pNeedProgress][1]);
 	cache_get_value_name_int(0, "Progress", playerInfo[playerid][pProgress][1]);
 	cache_get_value_name_int(0, "Progress2", playerInfo[playerid][pProgress][1]);
 	cache_get_value_name_int(0, "WTChannel", playerInfo[playerid][pWTChannel]);
 	cache_get_value_name_int(0, "WTalkie", playerInfo[playerid][pWTalkie]);
 	cache_get_value_name_int(0, "WToggle", playerInfo[playerid][pWToggle]);
 	cache_get_value_name_int(0, "WantedTime", playerInfo[playerid][pWantedTime]);
 	cache_get_value_name_int(0, "LiveToggle", playerInfo[playerid][pLiveToggle]);	
 	cache_get_value_name_int(0, "Clan", playerInfo[playerid][pClan]);
 	cache_get_value_name_int(0, "ClanRank", playerInfo[playerid][pClanRank]);
 	cache_get_value_name_int(0, "ClanAge", playerInfo[playerid][pClanAge]);
 	cache_get_value_name_int(0, "ClanWarns", playerInfo[playerid][pClanWarns]);
	cache_get_value_name_int(0, "ClanTag", playerInfo[playerid][pClanTag]);
	cache_get_value_name_int(0, "Premium", playerInfo[playerid][pPremium]);
	cache_get_value_name_int(0, "VIP", playerInfo[playerid][pVIP]);
	cache_get_value_name_int(0, "PremiumPoints", playerInfo[playerid][pPremiumPoints]);
	cache_get_value_name_int(0, "FPSShow", playerInfo[playerid][pFPSShow]);

 	new guns[32];
 	cache_get_value_name(0, "Guns", guns, 32);
	sscanf(guns, "p<|>iiiii", playerInfo[playerid][pGuns][0], playerInfo[playerid][pGuns][1], playerInfo[playerid][pGuns][2], playerInfo[playerid][pGuns][3], playerInfo[playerid][pGuns][4]);

	if(playerInfo[playerid][pFaction]) {
		Iter_Add(FactionMembers[playerInfo[playerid][pFaction]], playerid); 
		sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "** MoonBot: {ffffff}%s s-a connectat pe server (Total members online: %d).", getName(playerid), Iter_Count(FactionMembers[playerInfo[playerid][pFaction]]));		
	}
	if(playerInfo[playerid][pWantedLevel]) {
		Iter_Add(Wanteds, playerid);
		SetPlayerWantedLevel(playerid, playerInfo[playerid][pWantedLevel]);
		wantedTime[playerid] = repeat TimerWanted(playerid);
		SCM(playerid, COLOR_LIGHTRED, "* Deoarece te-ai deconectat, iar acum ai intrat wanted-ul ti-a fost restaurat.");
	}
	if(playerInfo[playerid][pClan]) {
		Iter_Add(TotalClanMembers, playerid);
		sendClanMessage(playerInfo[playerid][pClan], clanInfo[playerInfo[playerid][pClan]][cClanColor], "** MoonBot: {ffffff}%s s-a connectat pe server.", getName(playerid));
	}
	if(playerInfo[playerid][pDailyMission][0] == -1 || playerInfo[playerid][pDailyMission][1] == -1) giveQuest(playerid);
	if(playerInfo[playerid][pWTChannel] > 0) Iter_Add(Freqs[playerInfo[playerid][pWTChannel]], playerid);

	gString[0] = (EOS);
	cache_get_value_name(0, "Licenses", gString, 48);
	sscanf(gString, "p<|>dddddddd", playerInfo[playerid][pDrivingLicense], playerInfo[playerid][pDrivingLicenseSuspend], playerInfo[playerid][pWeaponLicense], playerInfo[playerid][pWeaponLicenseSuspend], playerInfo[playerid][pFlyLicense], playerInfo[playerid][pFlyLicenseSuspend], playerInfo[playerid][pBoatLicense], playerInfo[playerid][pBoatLicenseSuspend]);
	mysql_tquery(SQL, string_fast("SELECT * FROM `panel_notifications` WHERE `UserID` = '%d' AND `Read` = 0", playerInfo[playerid][pSQLID]), "CalculateEmails", "d", playerid);

	clearChat(playerid, 30);
	SCMf(playerid, COLOR_GREY, "* Bine ai venit, %s.", getName(playerid)); 

	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, 128, "SELECT * FROM `server_personal_vehicles` WHERE `OwnerID` = '%d'", playerInfo[playerid][pSQLID]);
	mysql_pquery(SQL, gQuery, "LoadPersonalVehicle", "d", playerid);

	new ipnew[16];
	GetPlayerIp(playerid, ipnew, 16);
	update("UPDATE `server_users` SET `LastLogin` = '%s', `LastIP` = '%s', `IP` = '%s' WHERE `ID` = '%d'", getDateTime(), playerInfo[playerid][pIp], ipnew, playerInfo[playerid][pSQLID]);

	if(playerInfo[playerid][pAdmin]) {
		Iter_Add(ServerAdmins, playerid);
		Iter_Add(ServerStaff, playerid);
		AllowPlayerTeleport(playerid, 1);

		PlayerTextDrawSetString(playerid, serverHud[1], "");
		PlayerTextDrawShow(playerid, serverHud[1]);
		sendStaff(COLOR_SERVER, "** MoonBot: {ffffff}%s s-a connectat pe server | Total Staff: %d [%d admins, %d helpers].", getName(playerid), Iter_Count(ServerStaff), Iter_Count(ServerAdmins), Iter_Count(ServerHelpers));
	}

	if(playerInfo[playerid][pHelper]) {
		Iter_Add(ServerHelpers, playerid);
		Iter_Add(ServerStaff, playerid);
		sendStaff(COLOR_SERVER, "** MoonBot: {ffffff}%s s-a connectat pe server | Total Staff: %d [%d admins, %d helpers].", getName(playerid), Iter_Count(ServerStaff), Iter_Count(ServerAdmins), Iter_Count(ServerHelpers));
	}

	playerInfo[playerid][pReportMute] += gettime();
	playerInfo[playerid][pIp] = ipnew;
	PlayerNumber[playerInfo[playerid][pPhone]] = playerid;
	Iter_Add(loggedPlayers, playerid);

	va_PlayerTextDrawSetString(playerid, serverHud[0], "%s/RPG.BLACK~p~MOON~w~.RO", getName(playerid));
	PlayerTextDrawShow(playerid, serverHud[0]);

	TextDrawShowForPlayer(playerid, ClockTD[0]);
	TextDrawShowForPlayer(playerid, ClockTD[1]);
	TextDrawShowForPlayer(playerid, ClockTD[2]);

	new hour, minute, second, year, month, day;
	gettime(hour, minute, second);
	getdate(year, month, day);

	TextDrawSetString(ClockTD[2], string_fast("%02d:%02d", hour, minute));
	TextDrawSetString(ClockTD[1], string_fast("%02d.%02d.%d", day, month, year));

	SetPlayerScore(playerid, playerInfo[playerid][pLevel]);
	updatePlayer(playerid);
	updateLevelBar(playerid);

	DCC_SetBotActivity(string_fast("%d / %d", Iter_Count(Player), MAX_PLAYERS));
	if(DCC_GetBotPresenceStatus() != DCC_BotPresenceStatus:IDLE) DCC_SetBotPresenceStatus(IDLE);
	return true;
}

function LoadExamCheckpoints() {
	if(!cache_num_rows()) return print("Exam Checkpoints: 0 [From DataBase]");
	for(new i = 1; i < cache_num_rows() +1; i++) {
		Iter_Add(ExamenCheckpoints, i);
		cache_get_value_name_int(i - 1, "ID", examenInfo[i][dmvID]);
		cache_get_value_name_float(i - 1, "X", examenInfo[i][dmvX]);
		cache_get_value_name_float(i - 1, "Y", examenInfo[i][dmvY]);
		cache_get_value_name_float(i - 1, "Z", examenInfo[i][dmvZ]);
	}
	return printf("Exam Checkpoints: %d [From Database]", Iter_Count(ExamenCheckpoints));
}

/*function LoadPickups() {
	if(!cache_num_rows()) return print("Pickups: 0 [From Database]");

	for(new i = 1; i < cache_num_rows() + 1; i++) {
		Iter_Add(Pickups, i);
		cache_get_value_name_int(i - 1, "ID", pickupInfo[i][pickupSQLID]);
		cache_get_value_name_int(i - 1, "Model", pickupInfo[i][pickupModel]);
		cache_get_value_name_float(i - 1, "X", pickupInfo[i][pickupX]);
		cache_get_value_name_float(i - 1, "Y", pickupInfo[i][pickupY]);
		cache_get_value_name_float(i - 1, "Z", pickupInfo[i][pickupZ]);
		cache_get_value_name_int(i - 1, "WorldID", pickupInfo[i][pickupWorldID] );
 		cache_get_value_name_int(i - 1, "Interior", pickupInfo[i][pickupInterior]);

		pickupInfo[i][pickupID] = CreateDynamicPickup(pickupInfo[i][pickupModel], 23, pickupInfo[i][pickupX], pickupInfo[i][pickupY], pickupInfo[i][pickupZ], pickupInfo[i][pickupWorldID], pickupInfo[i][pickupInterior]);
	}
	return printf("Pickups: %d [From Database]", Iter_Count(Pickups));
}
		

function LoadLabels() {
	if(!cache_num_rows()) return print("Labels: 0 [From Database]");

	for(new i = 1; i < cache_num_rows() + 1; i++) {
		Iter_Add(Labels, i);
		cache_get_value_name(i - 1, "Text", labelInfo[i][labelText], 128);
		cache_get_value_name_int(i - 1, "ID", labelInfo[i][labelSQLID]);
		cache_get_value_name_float(i - 1, "X", labelInfo[i][labelX]);
		cache_get_value_name_float(i - 1, "Y", labelInfo[i][labelY]);
		cache_get_value_name_float(i - 1, "Z", labelInfo[i][labelZ]);
		cache_get_value_name_int(i - 1, "WorldID", labelInfo[i][labelVirtualWorld]);
		cache_get_value_name_int(i - 1, "Interior", labelInfo[i][labelInterior]);
		labelInfo[i][labelID] = CreateDynamic3DTextLabel(labelInfo[i][labelText], -1, labelInfo[i][labelX], labelInfo[i][labelY], labelInfo[i][labelZ],  25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, labelInfo[i][labelVirtualWorld], labelInfo[i][labelInterior]);
	}
	return printf("Labels: %d [From Database]", Iter_Count(Labels));
}*/


function checkPanel() {
	new giverid,playerid, actionid, actiontime, complaint, reason[64], name[25], givername[25];
	new Cache: stringresult = mysql_query(SQL, string_fast("SELECT * FROM `panelactions2`"), true);
	if(cache_num_rows() > 0) {
		for(new i, j = cache_num_rows(); i != j; ++i) {
			cache_get_value_name_int(i, "giverid", giverid);
			cache_get_value_name_int(i, "playerid", playerid);
			cache_get_value_name_int(i, "actionid", actionid);
			cache_get_value_name_int(i, "complaintid", complaint);
			cache_get_value_name_int(i, "actiontime", actiontime);
			cache_get_value_name(i, "playername", name, 25);
			cache_get_value_name(i, "givername", givername, 25);
			cache_get_value_name(i, "reason", reason, 64);	

			if(mysql_unprocessed_queries() >= 3) sendAdmin(COLOR_SERVER, "Panel Warning Notice:{ffffff} to many queries in queue, can't execute the actions from panel.");	
			switch(actionid) {
				case 1: {
					SendClientMessageToAll(COLOR_LIGHTRED, string_fast("AdmPanel: %s a primit un warn de la administratorul %s, motiv: %s [complaint: %d].", name, givername, reason, complaint));
					if(isPlayerLogged(playerid)) playerInfo[playerid][pWarn] += 1;
				}
				case 2: {
					SendClientMessageToAll(COLOR_LIGHTRED, string_fast("AdmPanel: %s a primit mute %d minute de la administratorul %s, motiv: %s [complaint: %d].", name, actiontime, givername, reason, complaint));
					update("UPDATE `server_users` SET `Mute` = '%d' WHERE `ID` = '%d'", (actiontime * 60), playerInfo[playerid][pSQLID]);
					if(isPlayerLogged(playerid)) playerInfo[playerid][pMute] += (actiontime * 60); Iter_Add(MutedPlayers, playerid);
				}
				case 3: {
					// jail next soon
				}
				case 4: {
					SendClientMessageToAll(COLOR_LIGHTRED, string_fast("AdmPanel: %s a primit ban de la administratorul %s pentru %d zile, motiv: %s [complaint: %d].", name, givername, actiontime, reason, complaint));
					defer kickEx(playerid);
				}
				case 5: {
					SendClientMessageToAll(COLOR_LIGHTRED, string_fast("AdmPanel: %s a primit ban permanent de la administratorul %s, motiv: %s [complaint: %d].", name, givername, reason, complaint));
					defer kickEx(playerid);
				}
				case 6: {
					sendAdmin(COLOR_SERVER, "* Panel Notice:{ffffff} user %s [id: %d] a primit un warn de la administratorul %s [id: %d] (profile-action).", name, playerid, givername, giverid);	
					if(isPlayerLogged(playerid)) playerInfo[playerid][pWarn] += 1;	
				}
				case 7: {
					sendAdmin(COLOR_SERVER, "* Panel Notice:{ffffff} user %s [id: %d] a primit un unmute de la administratorul %s [id: %d] (profile-action).", name, playerid, givername, giverid);	
					if(isPlayerLogged(playerid)) {
						Iter_Remove(MutedPlayers, playerid);
						playerInfo[playerid][pMute] = 0;
						SCM(playerid, COLOR_GREY, string_fast("* Panel Notice: Administratorul %s ti-a dat unmute.", givername));
					}				
				}
				case 8: {
					sendAdmin(COLOR_SERVER, "* Panel Notice:{ffffff} user %s [id: %d] a primit premium de la administratorul %s [id: %d] (profile-action).", name, playerid, givername, giverid);	
					if(isPlayerLogged(playerid)) {
						Iter_Add(PremiumPlayers, playerid);
						playerInfo[playerid][pPremium] = 1;
						SCM(playerid, COLOR_GREY, string_fast("* Panel Notice: Administratorul %s ti-a dat premium.", givername));
					}					
				}
				case 9: {
					sendAdmin(COLOR_SERVER, "* Panel Notice:{ffffff} user %s [id: %d] a primit vip de la administratorul %s [id: %d] (profile-action).", name, playerid, givername, giverid);	
					if(isPlayerLogged(playerid)) {
						Iter_Add(VipPlayers, playerid);
						playerInfo[playerid][pVIP] = 1;
						SCM(playerid, COLOR_GREY, string_fast("* Panel Notice: Administratorul %s ti-a dat vip.", givername));
					}					
				}
				case 10: {
					sendAdmin(COLOR_SERVER, "* Panel Notice:{ffffff} user %s [id: %d] a primit vehicle slot de la administratorul %s [id: %d] (profile-action).", name, playerid, givername, giverid);	
					if(isPlayerLogged(playerid)) {
						playerInfo[playerid][pVehicleSlots] += 1;
						SCM(playerid, COLOR_GREY, string_fast("* Panel Notice: Administratorul %s ti-a dat vehicle slot.", givername));
					}			
				}
				case 11: {
					sendAdmin(COLOR_SERVER, "* Panel Notice:{ffffff} user %s [id: %d] a primit remove helper de la administratorul %s [id: %d] (profile-action).", name, playerid, givername, giverid);	
					if(isPlayerLogged(playerid)) {
						playerInfo[playerid][pHelper] = 0; 
						Iter_Remove(ServerHelpers, playerid);
						SCM(playerid, COLOR_GREY, string_fast("* Panel Notice: Administratorul %s ti-a dat remove de la helper.", givername));
					}			
				}
				case 12: {
					sendAdmin(COLOR_SERVER, "* Panel Notice:{ffffff} user %s [id: %d] a primit beta tester de la administratorul %s [id: %d] (profile-action).", name, playerid, givername, giverid);	
					if(isPlayerLogged(playerid)) {
						playerInfo[playerid][pBeta] = 1; 
						Iter_Remove(BetaPlayers, playerid);
						SCM(playerid, COLOR_GREY, string_fast("* Panel Notice: Administratorul %s ti-a dat beta tester.", givername));
					}		
				}
				case 13: {
					sendAdmin(COLOR_SERVER, "* Panel Notice:{ffffff} user %s [id: %d] a primit remove admin de la administratorul %s [id: %d] (profile-action).", name, playerid, givername, giverid);	
					if(isPlayerLogged(playerid)) {
						playerInfo[playerid][pAdmin] = 0; 
						Iter_Remove(ServerAdmins, playerid);
						SCM(playerid, COLOR_GREY, string_fast("* Panel Notice: Administratorul %s ti-a dat remove de la admin.", givername));
					}			
				}
				case 14: {
					sendAdmin(COLOR_SERVER, "* Panel Notice:{ffffff} user %s [id: %d] a primit unban de la administratorul %s [id: %d] (profile-action).", name, playerid, givername, giverid);				
				}
				case 15: {
					sendAdmin(COLOR_SERVER, "* Panel Notice:{ffffff} user %s [id: %d] a primit reset aplicatiei pentru factiune de la administratorul %s [id: %d] (profile-action).", name, playerid, givername, giverid);				
				}
				case 16: {
					sendAdmin(COLOR_SERVER, "* Panel Notice:{ffffff} user %s [id: %d] a primit o masina de la administratorul %s [id: %d] (profile-action).", name, playerid, givername, giverid);	
					if(isPlayerLogged(playerid)) defer kickEx(playerid);			
				}
				case 17: {
					sendAdmin(COLOR_SERVER, "* Panel Notice:{ffffff} user %s [id: %d] a primit schimbare de nume de la administratorul %s [id: %d] (profile-action).", name, playerid, givername, giverid);	
					if(isPlayerLogged(playerid)) {
						SCM(playerid, COLOR_GREY, string_fast("* Panel Notice: Administratorul %s ti-a schimbat numele. Numele tau nou este: %s.", givername, actiontime));
						defer kickEx(playerid);		
					}
				}
				case 18: {
					sendAdmin(COLOR_SERVER, "* Panel Notice:{ffffff} user %s [id: %d] a primit un warn down de la administratorul %s [id: %d] (profile-action).", name, playerid, givername, giverid);	
					if(isPlayerLogged(playerid)) {
						playerInfo[playerid][pWarn] -= 1; 
						SCM(playerid, COLOR_GREY, string_fast("* Panel Notice: Administratorul %s ti-a dat warn down.", givername));
					}			
				}
				case 19: {
					sendAdmin(COLOR_SERVER, "* Panel Notice:{ffffff} user %s [id: %d] a primit un mute %d minute de la administratorul %s [id: %d] (profile-action).", name, playerid, actiontime, givername, giverid);	
					if(isPlayerLogged(playerid)) {
						playerInfo[playerid][pMute] += actiontime ; 
						Iter_Add(MutedPlayers, playerid);
						SCM(playerid, COLOR_GREY, string_fast("* Panel Notice: Administratorul %s ti-a dat mute %d minute.", givername, actiontime));
					}			
				}
			}
		}		
		gQuery[0] = (EOS);
		mysql_format(SQL, gQuery, sizeof(gQuery), "DELETE FROM `panelactions2` WHERE `actionid` = '%d'", actionid);
		mysql_tquery(SQL, gQuery, "", "");
	}	
	cache_delete(stringresult);
	return true;
}	

function checkPlayerAccount(playerid) {
	if(!cache_num_rows())
		return Dialog_Show(playerid, REGISTER, DIALOG_STYLE_PASSWORD, "Register", "Bine ai venit, %s.\nScrie mai jos parola pe care doresti sa o ai:", "Register", "Quit", getName(playerid));

	new lastLogin[64];
	cache_get_value_name(0, "LastLogin", lastLogin, 64);

	Dialog_Show(playerid, LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Bine ai revenit, %s.\nScrie mai jos parola contului tau:\n\n{ffffff}* Ultima logare: %s", "Login", "Quit", getName(playerid), lastLogin);
	return true;
}

function assignSQLID(playerid) {
	playerInfo[playerid][pSQLID] = cache_insert_id();
	return printf("%s (%d) s-a inregistrat.", getName(playerid), playerid);
}

function assignCheckpointID(i) {
	Iter_Add(ExamenCheckpoints, i);
	examenInfo[i][dmvID] = cache_insert_id();
	return true;	
}

function checkAccountInBanDatabase(playerid, playerName, days, reason) {
	if(cache_num_rows())
		return SCM(playerid, COLOR_ERROR, eERROR"Acest cont este deja banat.");

	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof gQuery, "SELECT * FROM `server_users` WHERE `Name` = '%s' LIMIT 1", playerName);
	mysql_tquery(SQL, gQuery, "checkAccountBanDatabase", "dsds", playerid, playerName, days, reason);
	return true;
}

function checkAccountBanDatabase(playerid, playerName, days, reason)  {
	if(!cache_num_rows())
		return SCM(playerid, COLOR_ERROR, eERROR"Acest cont nu exista.");

	new playerID;
	cache_get_value_name_int(0, "ID", playerID);

	if(days) va_SendClientMessageToAll(COLOR_LIGHTRED, "AdmCmd: %s (offline) a primit ban %d zile de la %s, motiv: %s", playerName, days, getName(playerid), reason);
	else va_SendClientMessageToAll(COLOR_LIGHTRED, "AdmCmd: %s (offline) a primit ban permanent de la %s, motiv: %s", playerName, getName(playerid), reason);
	
	update("INSERT INTO `server_bans` (PlayerName, PlayerID, AdminName, AdminID, Reason, Days, Date) VALUES ('%s', '%d', '%s', '%d', '%s', '%d', '%s')", playerName, playerID, getName(playerid), playerInfo[playerid][pSQLID], reason, days, getDateTime());
	SetPVarInt(playerid, "banDeelay", (gettime() + 60));	
	return true;	
}

function checkPlayerBanIP(playerid) {
	if(!cache_num_rows()) {
		gQuery[0] = (EOS);
		mysql_format(SQL, gQuery, 256, "SELECT * FROM `server_users` WHERE `Name` = '%s' LIMIT 1", getName(playerid));
		mysql_tquery(SQL, gQuery, "checkPlayerAccount", "d", playerid);
		return true;
	}
	new AdminName[MAX_PLAYER_NAME], Reason[64], Date[32];
	cache_get_value_name(0, "AdminName", AdminName, MAX_PLAYER_NAME);
	cache_get_value_name(0, "Reason", Reason, 64);
	cache_get_value_name(0, "Date", Date, 32);
	SCMf(playerid, COLOR_LIGHTRED, "System: Acest IP este banat pe acest server de catre Admin %s.", AdminName);
	SCMf(playerid, COLOR_LIGHTRED, "System: Motivul banului: %s", Reason);
	SCMf(playerid, COLOR_LIGHTRED, "System: Data banului: %s", Date);
	return true;
}

function checkBanPlayer(playerid) {
	if(!cache_num_rows())
		return SCM(playerid, COLOR_ERROR, eERROR"Nu a fost gasit nici-un jucator banat cu acest nume.");

	new playerName[MAX_PLAYER_NAME], playerID;
	cache_get_value_name(0, "PlayerName", playerName, MAX_PLAYER_NAME);
	cache_get_value_name_int(0, "ID", playerID);
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s i-a dat unban lui %s.", getName(playerid), playerName);
	update("UPDATE `server_bans` SET `Active` = '0' WHERE `ID` = '%d'", playerID);

	SetPVarInt(playerid, "unbanDeelay", (gettime() + 60));
	return true;
}

function BanIPPlayer(playerid, id, reason) {
	if(!cache_affected_rows()) return SCM(playerid, COLOR_ERROR, eERROR"Banul nu a putut fi acordat, eroare tehnica reveniti mai tarziu.");
	SendClientMessageToAll(COLOR_LIGHTRED, string_fast("AdmCmd: %s a primit ban ip de la administratorul %s, motiv: %s.", getName(id), getName(playerid), reason));
	SetPVarInt(playerid, "banDeelay", (gettime() + 60));
	defer kickEx(id);
	return true;
}

function CheckIP(playerid, params) {
	if(!cache_num_rows()) return SCM(playerid, COLOR_ERROR, eERROR"Acest ip nu este banat.");
	new playerID;
	cache_get_value_name_int(0, "ID", playerID);
	sendAdmin(COLOR_SERVER, "* Ban Notice: {ffffff}Admin %s a debanat ip-ul %s.", getName(playerid), params);
	SetPVarInt(playerid, "unbanDeelay", (gettime() + 60));	
	update("UPDATE `server_bans_ip` SET `Active` = '0' WHERE `ID` = '%d'", playerID);
	return true;
}

function BanIPOffline(playerid, ip, reason) {
	if(!cache_affected_rows()) return SCM(playerid, COLOR_ERROR, eERROR"Banul nu a putut fi acordat, eroare tehnica reveniti mai tarziu.");
	sendAdmin(COLOR_SERVER, "* Ban Notice: {ffffff}Admin %s a banat ip-ul %s, motiv: %s.", getName(playerid), ip, reason);
	SetPVarInt(playerid, "banDeelay", (gettime() + 60));
	return true;
}

function checkAccountInDatabase(playerid, playerName, reason) {
	if(!cache_num_rows()) return SCM(playerid, COLOR_ERROR, eERROR"Acest cont nu este in jail.");
	mysql_format(SQL, gQuery, sizeof gQuery, "SELECT * FROM `server_users` WHERE `Name` = '%s' LIMIT 1", playerName);
	mysql_tquery(SQL, gQuery, "checkAccountJail", "dss", playerid, playerName, reason);
	return true;
}

function checkAccountJail(playerid, playerName, reason) {
	if(!cache_num_rows()) return SCM(playerid, COLOR_ERROR, eERROR"Acest cont nu exista.");
	sendAdmin(COLOR_SERVER, "* Notice: {ffffff}Admin %s l-a eliberat din inchisoare pe %s. Motiv: %s.", getName(playerid), playerName, reason);
	update("UPDATE `server_users` SET `Jailed` = '0', `JailTime` = '0' WHERE `Name` = '%s' LIMIT 1", playerName);
	return true;
}

function checkAccountInDatabaseJailo(playerid, playerName, reason, minutes) {
	if(cache_num_rows()) return SCM(playerid, COLOR_ERROR, eERROR"Acest cont este deja in jail.");
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof gQuery, "SELECT * FROM `server_users` WHERE `Name` = '%s' LIMIT 1", playerName);
	mysql_tquery(SQL, gQuery, "checkAccountJailo", "dssd", playerid, playerName, reason, minutes);
	return true;
}

function checkAccountJailo(playerid, playerName, reason, minutes) {
	if(!cache_num_rows()) return SCM(playerid, COLOR_ERROR, eERROR"Acest cont nu exista.");
	sendAdmin(COLOR_SERVER, "* Notice: {ffffff}Admin %s l-a bagat in inchisoare pe %s, %d minute. Motiv: %s.", getName(playerid), playerName, minutes, reason);
	update("UPDATE `server_users` SET `Jailed` = '2', `JailTime` = '%d' WHERE `Name` = '%s' LIMIT 1", minutes*60, playerName);
	return true;
}

function serverWeapon(playerid, weaponid, ammo) {
	if(playerInfo[playerid][pWeaponLicense] == 0 && weaponid >= 8 && weaponid != 43 || weaponid == 9 && playerInfo[playerid][pJob] == 0 && Working[playerid] == 0) return true;
	Weapons[playerid][weaponid] = 1;
	WeaponAmmo[playerid][getWeaponSlot(weaponid)] += ammo;
	GivePlayerWeapon(playerid, weaponid, ammo);
	return true;
}

function ProxDetectorS(Float:radi, playerid, targetid) {
	new Float:posx, Float:posy, Float:posz, Float:oldposx, Float:oldposy, Float:oldposz, Float:tempposx, Float:tempposy, Float:tempposz;
	GetPlayerPos(playerid, oldposx, oldposy, oldposz);
	GetPlayerPos(targetid, posx, posy, posz);
	tempposx = (oldposx -posx);
	tempposy = (oldposy -posy);
	tempposz = (oldposz -posz);
	if(((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi))) return true;
	return false;
}

function haveWeapons(playerid) {
	new x, Player_Weapons[13], Player_Ammos[13];
	for(new i = 1;i <= 12;i++) {
		GetPlayerWeaponData(playerid,i,Player_Weapons[i],Player_Ammos[i]);
		if(Player_Weapons[i] != 0) x++;
	}	
	return x;
}

function SetPlayerFreeze(playerid, time) {
	playerInfo[playerid][pUnFreezeTime] = gettime()+time;
	TogglePlayerControllable(playerid, false);
	return true;
}
OnePlayAnim(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp) 
	return ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp);
StopLoopingAnim(playerid) {
	playerInfo[playerid][pAnimLooping] = 0;
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
}
PreloadAnimLib(playerid, animlib[]) ApplyAnimation(playerid,animlib,"Null",0.0,0,0,0,0,0);
LoopingAnim(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp) {
	ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp);
}

function getNeedProgress(playerid, id) {
	return playerInfo[playerid][pNeedProgress][id];
}


function questProgress(playerid, type, id) {
	new progress;
	switch(type) {
		case 0..1: progress = 1 + random(10);
		case 2..5: progress = 1;
	}
	playerInfo[playerid][pNeedProgress][id] = progress;
	playerInfo[playerid][pProgress][id] = 0;
	update("UPDATE `server_users` SET `NeedProgress%d` = '%d' WHERE `ID` = '%d'", id+1, progress, playerInfo[playerid][pSQLID]);
	return true;
}

function giveQuest(playerid) {
	playerInfo[playerid][pDailyMission][0] = random(5);
	playerInfo[playerid][pDailyMission][1] = 1+random(4);
	if(playerInfo[playerid][pDailyMission][0] == playerInfo[playerid][pDailyMission][1]) playerInfo[playerid][pDailyMission][1] = 0;
	update("UPDATE `server_users` SET `DailyMission` = '%d', `DailyMission2` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pDailyMission][0], playerInfo[playerid][pDailyMission][1], playerInfo[playerid][pSQLID]);
	questProgress(playerid, playerInfo[playerid][pDailyMission][0], 0);
	questProgress(playerid, playerInfo[playerid][pDailyMission][1], 1);
	return true;
}

function resetQuest() {
	update("UPDATE `server_users` SET `DailyMission`='-1', `Progress`='0', `DailyMission2`='-1', `Progress2`='0', `NeedProgress1`='0', `NeedProgress2`='0'");
    foreach(new i : loggedPlayers) {
        if(IsPlayerConnected(i) && playerInfo[i][pLogged] == true) {
			playerInfo[i][pDailyMission][0] = random(5);
			playerInfo[i][pDailyMission][1] = 1+random(4);
			if(playerInfo[i][pDailyMission][0] == playerInfo[i][pDailyMission][1]) playerInfo[i][pDailyMission][1] = 1+random(4);
			update("UPDATE `server_users` SET `DailyMission` = '%d', `DailyMission2` = '%d' WHERE `ID` = '%d'", playerInfo[i][pDailyMission][0], playerInfo[i][pDailyMission][1], playerInfo[i][pSQLID]);
			questProgress(i, playerInfo[i][pDailyMission][0], 0);
			questProgress(i, playerInfo[i][pDailyMission][1], 1);
			SCM(i, COLOR_ORANGE, "* Misiunile zilei au fost resetate. Foloseste comanda /quests pentru a vedea noile misiuni.");
        }
    }
	return true;
}

function checkMission(playerid, id) {
	new money = 50000 + playerInfo[playerid][pLevel] * 1000 + random(50000), rp = 1 + random(4);
	if(playerInfo[playerid][pDailyMission][id] != -1) {
		playerInfo[playerid][pProgress][id] ++;	
		if(playerInfo[playerid][pProgress][id] == playerInfo[playerid][pNeedProgress][id]) {
			SCM(playerid, COLOR_ORANGE, string_fast("* Mission: Misiunea '%s' a fost terminata.", missionName(playerid, playerInfo[playerid][pDailyMission][id], id)));
			SCM(playerid, COLOR_ORANGE, string_fast("* Mission: Ai primit $%s si %dx respect points.", formatNumber(money), rp));
			playerInfo[playerid][pRespectPoints] += rp;
			playerInfo[playerid][pProgress][id] ++;
			GivePlayerCash(playerid, 1, money);
			updateLevelBar(playerid);
		}
		else if(playerInfo[playerid][pProgress][id] < playerInfo[playerid][pNeedProgress][id]) SCM(playerid, COLOR_ORANGE, string_fast("* Mission: Progres pentru misiunea '%s': %d/%d", missionName(playerid, playerInfo[playerid][pDailyMission][id], id), playerInfo[playerid][pProgress][id], playerInfo[playerid][pNeedProgress][id]));
	    if(id == 0) update("UPDATE `server_users` SET `Progress` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pProgress][id], playerInfo[playerid][pSQLID]);
	    else if(id == 1) update("UPDATE `server_users` SET `Progress2` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pProgress][id], playerInfo[playerid][pSQLID]);
	}
	update("UPDATE `server_users` SET `RespectPoints` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pRespectPoints], playerInfo[playerid][pSQLID]);    
	return true;
}

function faceReclama(text[]) {
	if(strfind(text, "u-network", true) != -1 || strfind(text, "unnic", true) != -1 || strfind(text, "ne-am mutat pe rpg.", true) != -1 || strfind(text, "t4p", true) != -1 || strfind(text, "og-times", true) != -1 ||
		strfind(text, "ruby", true) != -1 || strfind(text, "union-zone", true) != -1 || strfind(text, "nephrite", true) != -1 || strfind(text, "pro-gaming", true) != -1 || strfind(text, "playnion", true) != -1 || strfind(text, "just2play", true) != -1 ||
		strfind(text, "b-game", true) != -1 || strfind(text, "b-gaming", true) != -1 || strfind(text, "egaming", true) != -1 || strfind(text, "dty", true) != -1 || strfind(text, "lupmax", true) != -1 || strfind(text, "bhood", true) != -1 ||
		strfind(text, "bugged", true) != -1 || strfind(text, "b-zone", true) != -1 || strfind(text, "b-zone", true) != -1 || strfind(text, "nolimit", true) != -1 || strfind(text, "nqgaming", true) != -1 || strfind(text, "b-hood", true) != -1 ||
		strfind(text, "t4p", true) != -1 || strfind(text, "time4play", true) != -1 || strfind(text, "redgame", true) != -1 || strfind(text, "blue-game", true) != -1 || strfind(text, "egaming", true) != -1 || strfind(text, "bigzone", true) != -1 ||
		strfind(text, "evil-zone", true) != -1 || strfind(text, "expertgame", true) != -1 || strfind(text, "ogtimes", true) != -1 || strfind(text, "red-game", true) != -1 || strfind(text, ":7777", true) != -1 || strfind(text, "jadenephrite", true) != -1 || 
		strfind(text, "tryhard", true) != -1 || strfind(text, "jadenephrite", true) != -1 || strfind(text, "old times", true) != -1 || strfind(text, "oldtimes", true) != -1 || strfind(text, "redtimes", true) != -1 || strfind(text, "red-times", true) != -1) return true;
	return false;
}	

function removeFunction(playerid, text[]) {
	if(playerInfo[playerid][pAdmin] != 0) {
		playerInfo[playerid][pAdmin] = 0;
		Iter_Remove(ServerAdmins, playerid);
		Iter_Remove(ServerStaff, playerid);
		if(playerInfo[playerid][pFlymode] == true) {
			playerInfo[playerid][pFlymode] = false;
			StopFly(playerid);
			SetPlayerHealthEx(playerid, 100);
		}
		sendStaff(COLOR_LIGHTRED, "* Remove Notice: %s a facut reclama folosind intermediul functiei. Acesta a luat remove automat.", getName(playerid));
		sendStaff(COLOR_LIGHTRED, "* Remove Notice: Text '%s'.", text);
	}
	if(playerInfo[playerid][pHelper] != 0) {
		playerInfo[playerid][pHelper] = 0;
		Iter_Remove(ServerHelpers, playerid);
		Iter_Remove(ServerStaff, playerid);
		if(HelperBusy[playerid] > -1) {
			HelperAtribut[HelperBusy[playerid]] = -1;
			HelperBusy[playerid] = -1;
			helpTimer[playerid] = defer helpnTimer(playerid);
		}
		sendStaff(COLOR_LIGHTRED, "* Remove Notice: %s a facut reclama folosind intermediul functiei. Acesta a luat remove automat.", getName(playerid));
		sendStaff(COLOR_LIGHTRED,"* Remove Notice: Text '%s'.", text);
	}
	if(playerInfo[playerid][pFaction] != 0 && playerInfo[playerid][pFactionRank] == 7) {
		if(playerVehicle[playerid] != -1) {
			sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "(*) %s a fost scos din factiune de admin AdmBot, iar vehiculul spawnat de el a fost distrus.", getName(playerid));
			DestroyVehicle(playerVehicle[playerid]); 
			vehicleFaction[playerVehicle[playerid]] = 0;  
			vehiclePlayerID[playerVehicle[playerid]] = -1;
			vehicleRank[playerVehicle[playerid]] = 0;
			playerVehicle[playerid] = -1;
			if(IsValidObject(svfVehicleObjects[0])) DestroyObject(svfVehicleObjects[0]); 
			if(IsValidObject(svfVehicleObjects[1])) DestroyObject(svfVehicleObjects[1]);
		}
		playerInfo[playerid][pFaction] = 0;
		playerInfo[playerid][pFactionRank] = 0;
		playerInfo[playerid][pFactionAge] = 0;
		playerInfo[playerid][pFactionWarns] = 0;	
		playerInfo[playerid][pFactionPunish] = 30;
		if(playerInfo[playerid][pFactionDuty]) playerInfo[playerid][pFactionDuty] = 0;
		update("UPDATE `server_users` SET `SpawnChange` = '1', `Faction` = '0', `FRank` = '7', `FAge` = '0', `FWarns` = '0', `FPunish` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pFactionPunish], playerInfo[playerid][pSQLID]);
		sendStaff(COLOR_LIGHTRED, "* Remove Notice: %s a facut reclama folosind intermediul functiei. Acesta a luat remove automat.", getName(playerid));
		sendStaff(COLOR_LIGHTRED,"* Remove Notice: Text '%s'.", text);
	}
	return true;
}

function Reclama(playerid, text[]) {
	if(playerInfo[playerid][pAdmin] > 5) return true;
	playerInfo[playerid][pMute] = gettime()+120;
	update("UPDATE `server_users` SET `Mute` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pMute], playerInfo[playerid][pSQLID]);
	SCM(playerid, COLOR_LIGHTRED, "* Anti-Reclama: Deoarece ai facut reclama, ai primit mute timp de 2 minute.");
	sendStaff(COLOR_LIGHTRED, "* Notice Anti-reclama: %s este posibil sa faca reclama ('%s').", getName(playerid), text);
	return 1;
}

function PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z) {
	new Float:oldposx, Float:oldposy, Float:oldposz;
	GetPlayerPos(playerid, oldposx, oldposy, oldposz);
	if((((oldposx -x) < radi) && ((oldposx -x) > -radi)) && (((oldposy -y) < radi) && ((oldposy -y) > -radi)) && (((oldposz -z) < radi) && ((oldposz -z) > -radi))) return true;
	return false;
}

function IsPlayerInTurf(playerid, turfid) {
	if(turfid == -1) return false;
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid,x,y,z);
	if(x >= turfInfo[turfid][tMinX] && x < turfInfo[turfid][tMaxX] && y >= turfInfo[turfid][tMinY] && y < turfInfo[turfid][tMaxY]) return true;
	return false;
}

function SendDiscordAC(const text[], va_args<>) {
	switch(MYSQL) {
		case 1: {
			if (_:MoonBotAC == 0) MoonBotAC = DCC_FindChannelById("843145109977825310");

			new Discord[100];
			va_format(Discord, sizeof Discord, text, va_start<1>);
			DCC_SendChannelMessage(MoonBotAC, string_fast(":warning: %s", Discord));
		}
	}
	return 1;
}

function showNotification(playerid, from[], const text[]) {
	va_PlayerTextDrawSetString(playerid, notificationTD[playerid], "%s~n~From: %s", text, from);
	PlayerTextDrawShow(playerid, notificationTD[playerid]);
	defer notificationTimer(playerid);
	return true;
}

