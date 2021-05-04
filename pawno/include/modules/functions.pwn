function MySQLLoad() {
	mysql_log(ERROR | WARNING);
	switch(Connection) {
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
		SetGameModeText("RPG V: 1.6.26");
		serverTextDraws();
		loadMaps();
	}
	return true;
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
	cache_get_value_name(0, "LastIP", playerInfo[playerid][pLastIp], 16);


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
	}
	if(playerInfo[playerid][pWantedLevel]) {
		Iter_Add(Wanteds, playerid);
		SetPlayerWantedLevel(playerid, playerInfo[playerid][pWantedLevel]);
		wantedTime[playerid] = repeat TimerWanted(playerid);
		SCM(playerid, COLOR_LIGHTRED, "* Deoarece te-ai deconectat, iar acum ai intrat wanted-ul ti-a fost restaurat.");
	}
	if(playerInfo[playerid][pClan]) Iter_Add(TotalClanMembers, playerid);
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
	mysql_format(SQL, gQuery, sizeof(gQuery), "UPDATE `server_users` SET `LastLogin` = '%s', `LastIP` = '%s', `IP` = '%s' WHERE `ID` = '%d'", getDateTime(), playerInfo[playerid][pIp], ipnew, playerInfo[playerid][pSQLID]);
	mysql_pquery(SQL, gQuery, "", "");

	if(playerInfo[playerid][pAdmin]) {
		Iter_Add(ServerAdmins, playerid);
		Iter_Add(ServerStaff, playerid);
		AllowPlayerTeleport(playerid, 1);
		TextDrawShowForPlayer(playerid, serverInfoTD);
	}

	if(playerInfo[playerid][pHelper]) {
		Iter_Add(ServerHelpers, playerid);
		Iter_Add(ServerStaff, playerid);
	}

	if(playerInfo[playerid][pMute] > 1) {
		Iter_Add(MutedPlayers, playerid);
		muteTime[playerid] = repeat TimerMute(playerid);
	}

	playerInfo[playerid][pReportMute] += gettime();
	playerInfo[playerid][pIp] = ipnew;
	PlayerNumber[playerInfo[playerid][pPhone]] = playerid;
	Iter_Add(loggedPlayers, playerid);

	va_PlayerTextDrawSetString(playerid, playerNamePTD[playerid], "%s ~R~(%d)", getName(playerid), playerid);
	PlayerTextDrawShow(playerid, playerNamePTD[playerid]);

	TextDrawShowForPlayer(playerid, serverDateTD);
	TextDrawShowForPlayer(playerid, serverNameTD);

	SetPlayerScore(playerid, playerInfo[playerid][pLevel]);
	GivePlayerMoney(playerid, GetPlayerCash(playerid));
	updateLevelBar(playerid);
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
		return sendPlayerError(playerid, "Acest cont este deja banat.");

	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof gQuery, "SELECT * FROM `server_users` WHERE `Name` = '%s' LIMIT 1", playerName);
	mysql_tquery(SQL, gQuery, "checkAccountBanDatabase", "dsds", playerid, playerName, days, reason);
	return true;
}

function checkAccountBanDatabase(playerid, playerName, days, reason)  {
	if(!cache_num_rows())
		return sendPlayerError(playerid, "Acest cont nu exista.");

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
		return sendPlayerError(playerid, "Nu a fost gasit nici-un jucator banat cu acest nume.");

	new playerName[MAX_PLAYER_NAME], playerID;
	cache_get_value_name(0, "PlayerName", playerName, MAX_PLAYER_NAME);
	cache_get_value_name_int(0, "ID", playerID);
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s i-a dat unban lui %s.", getName(playerid), playerName);
	update("UPDATE `server_bans` SET `Active` = '0' WHERE `ID` = '%d'", playerID);

	SetPVarInt(playerid, "unbanDeelay", (gettime() + 60));
	return true;
}

function BanIPPlayer(playerid, id, reason) {
	if(!cache_affected_rows()) return sendPlayerError(playerid, "Banul nu a putut fi acordat, eroare tehnica reveniti mai tarziu.");
	SendClientMessageToAll(COLOR_LIGHTRED, string_fast("AdmCmd: %s a primit ban ip de la administratorul %s, motiv: %s.", getName(id), getName(playerid), reason));
	SetPVarInt(playerid, "banDeelay", (gettime() + 60));
	defer kickEx(id);
	return true;
}

function CheckIP(playerid, params) {
	if(!cache_num_rows()) return sendPlayerError(playerid, "Acest ip nu este banat.");
	new playerID;
	cache_get_value_name_int(0, "ID", playerID);
	sendAdmin(COLOR_SERVER, "* Ban Notice: {ffffff}Admin %s a debanat ip-ul %s.", getName(playerid), params);
	SetPVarInt(playerid, "unbanDeelay", (gettime() + 60));	
	update("UPDATE `server_bans_ip` SET `Active` = '0' WHERE `ID` = '%d'", playerID);
	return true;
}

function BanIPOffline(playerid, ip, reason) {
	if(!cache_affected_rows()) return sendPlayerError(playerid, "Banul nu a putut fi acordat, eroare tehnica reveniti mai tarziu.");
	sendAdmin(COLOR_SERVER, "* Ban Notice: {ffffff}Admin %s a banat ip-ul %s, motiv: %s.", getName(playerid), ip, reason);
	SetPVarInt(playerid, "banDeelay", (gettime() + 60));
	return true;
}

function checkAccountInDatabase(playerid, playerName, reason) {
	if(!cache_num_rows()) return sendPlayerError(playerid, "Acest cont nu este in jail.");
	mysql_format(SQL, gQuery, sizeof gQuery, "SELECT * FROM `server_users` WHERE `Name` = '%s' LIMIT 1", playerName);
	mysql_tquery(SQL, gQuery, "checkAccountJail", "dss", playerid, playerName, reason);
	return true;
}

function checkAccountJail(playerid, playerName, reason) {
	if(!cache_num_rows()) return sendPlayerError(playerid, "Acest cont nu exista.");
	sendAdmin(COLOR_SERVER, "* Notice: {ffffff}Admin %s l-a eliberat din inchisoare pe %s. Motiv: %s.", getName(playerid), playerName, reason);
	update("UPDATE `server_users` SET `Jailed` = '0', `JailTime` = '0' WHERE `Name` = '%s' LIMIT 1", playerName);
	return true;
}

function checkAccountInDatabaseJailo(playerid, playerName, reason, minutes) {
	if(cache_num_rows()) return sendPlayerError(playerid, "Acest cont este deja in jail.");
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof gQuery, "SELECT * FROM `server_users` WHERE `Name` = '%s' LIMIT 1", playerName);
	mysql_tquery(SQL, gQuery, "checkAccountJailo", "dssd", playerid, playerName, reason, minutes);
	return true;
}

function checkAccountJailo(playerid, playerName, reason, minutes) {
	if(!cache_num_rows()) return sendPlayerError(playerid, "Acest cont nu exista.");
	sendAdmin(COLOR_SERVER, "* Notice: {ffffff}Admin %s l-a bagat in inchisoare pe %s, %d minute. Motiv: %s.", getName(playerid), playerName, minutes, reason);
	update("UPDATE `server_users` SET `Jailed` = '2', `JailTime` = '%d' WHERE `Name` = '%s' LIMIT 1", minutes*60, playerName);
	return true;
}

function getVehicleMaxSpeed(model) {
	new speed;
	model -= 400;
	switch(model) {
		case 0: speed = 149; // model 400
		case 1: speed = 139; // model 401
		case 2: speed = 176; // model 402
		case 3: speed = 104; // model 403
		case 4: speed = 125; // model 404
		case 5: speed = 155; // model 405
		case 6: speed = 104; // model 406
		case 7: speed = 140; // model 407
		case 8: speed = 94;  // model 408
		case 9: speed = 149; // model 409
		case 10: speed = 122; // model 410
		case 11: speed = 209; // model 411
		case 12: speed = 159; // model 412
		case 13: speed = 104; // model 413
		case 14: speed = 100; // model 414
		case 15: speed = 181; // model 415
		case 16: speed = 145; // model 416
		case 17: speed = 127; // model 417
		case 18: speed = 109; // model 418
		case 19: speed = 141; // model 419
		case 20: speed = 137; // model 420
		case 21: speed = 145; // model 421
		case 22: speed = 132; // model 422
		case 23: speed = 93;  // model 423
		case 24: speed = 128; // model 424
		case 25: speed = 191; // model 425
		case 26: speed = 164; // model 426
		case 27: speed = 156; // model 427
		case 28: speed = 148; // model 428
		case 29: speed = 190; // model 429
		case 30: speed = 100; // model 430
		case 31: speed = 123; // model 431
		case 32: speed = 89;  // model 432
		case 33: speed = 104; // model 433
		case 34: speed = 158; // model 434
		case 35: speed = 0;   // model 435
		case 36: speed = 141; // model 436
		case 37: speed = 149; // model 437
		case 38: speed = 135; // model 438
		case 39: speed = 159; // model 439
		case 40: speed = 128; // model 440
		case 41: speed = 71;  // model 441
		case 42: speed = 131; // model 442
		case 43: speed = 119; // model 443
		case 44: speed = 104; // model 444
		case 45: speed = 155; // model 445
		case 46: speed = 140; // model 446
		case 47: speed = 126; // model 447
		case 48: speed = 106; // model 448
		case 49: speed = 169; // model 449
		case 50: speed = 0;   // model 450
		case 51: speed = 182; // model 451
		case 52: speed = 141; // model 452
		case 53: speed = 58;  // model 453
		case 54: speed = 115; // model 454
		case 55: speed = 119; // model 455
		case 56: speed = 100; // model 456
		case 57: speed = 90;  // model 457
		case 58: speed = 138; // model 458
		case 59: speed = 128; // model 459
		case 60: speed = 0;   // model 460
		case 61: speed = 151; // model 461
		case 62: speed = 105; // model 462
		case 63: speed = 136; // model 463
		case 64: speed = 0;   // model 464
		case 65: speed = 0;   // model 465
		case 66: speed = 139; // model 466
		case 67: speed = 132; // model 467
		case 68: speed = 136; // model 468
		case 69: speed = 0;   // model 469
		case 70: speed = 148; // model 470
		case 71: speed = 104; // model 471
		case 72: speed = 0;   // model 472
		case 73: speed = 0;   // model 473
		case 74: speed = 141; // model 474
		case 75: speed = 163; // model 475
		case 76: speed = 0;   // model 476
		case 77: speed = 176; // model 477
		case 78: speed = 111; // model 478
		case 79: speed = 132; // model 479
		case 80: speed = 174; // model 480
		case 81: speed = 68;  // model 481
		case 82: speed = 148; // model 482
		case 83: speed = 116; // model 483
		case 84: speed = 0;   // model 484
		case 85: speed = 94;  // model 485
		case 86: speed = 60;  // model 486
		case 87: speed = 0;   // model 487
		case 88: speed = 0;   // model 488
		case 89: speed = 132; // model 489
		case 90: speed = 148; // model 490
		case 91: speed = 141; // model 491
		case 92: speed = 132; // model 492
		case 93: speed = 0;   // model 493
		case 94: speed = 203; // model 494
		case 95: speed = 166; // model 495
		case 96: speed = 153; // model 496
		case 97: speed = 0;   // model 497
		case 98: speed = 115; // model 498
		case 99: speed = 116; // model 499
		case 100: speed = 132; // model 500
		case 101: speed = 0;   // model 501
		case 102: speed = 203; // model 502
		case 103: speed = 203; // model 503
		case 104: speed = 163; // model 504
		case 105: speed = 132; // model 505
		case 106: speed = 169; // model 506
		case 107: speed = 156; // model 507
		case 108: speed = 102; // model 508
		case 109: speed = 74;  // model 509
		case 110: speed = 95;  // model 510
		case 111: speed = 0;   // model 511
		case 112: speed = 0;   // model 512
		case 113: speed = 0;   // model 513
		case 114: speed = 113; // model 514
		case 115: speed = 126; // model 515
		case 116: speed = 148; // model 516
		case 117: speed = 148; // model 517
		case 118: speed = 155; // model 518
		case 119: speed = 0;   // model 519
		case 120: speed = 0;   // model 520
		case 121: speed = 150; // model 521
		case 122: speed = 166; // model 522
		case 123: speed = 142; // model 523
		case 124: speed = 123; // model 524
		case 125: speed = 151; // model 525
		case 126: speed = 149; // model 526
		case 127: speed = 141; // model 527
		case 128: speed = 166; // model 528
		case 129: speed = 141; // model 529
		case 130: speed = 57;  // model 530
		case 131: speed = 66;  // model 531
		case 132: speed = 104; // model 532
		case 133: speed = 157; // model 533
		case 134: speed = 159; // model 534
		case 135: speed = 149; // model 535
		case 136: speed = 163; // model 536
		case 137: speed = 0;   // model 537
		case 138: speed = 0;   // model 538
		case 139: speed = 94;  // model 539
		case 140: speed = 141; // model 540
		case 141: speed = 191; // model 541
		case 142: speed = 155; // model 542
		case 143: speed = 142; // model 543
		case 144: speed = 140; // model 544
		case 145: speed = 139; // model 545
		case 146: speed = 141; // model 546
		case 147: speed = 135; // model 547
		case 148: speed = 0;   // model 548
		case 149: speed = 145; // model 549
		case 150: speed = 137; // model 550
		case 151: speed = 148; // model 551
		case 152: speed = 114; // model 552
		case 153: speed = 0;   // model 553
		case 154: speed = 136; // model 554
		case 155: speed = 149; // model 555
		case 156: speed = 104; // model 556
		case 157: speed = 104; // model 557
		case 158: speed = 147; // model 558
		case 159: speed = 168; // model 559
		case 160: speed = 159; // model 560
		case 161: speed = 145; // model 561
		case 162: speed = 168; // model 562
		case 163: speed = 0;   // model 563
		case 164: speed = 83;  // model 564
		case 165: speed = 155; // model 565
		case 166: speed = 151; // model 566
		case 167: speed = 163; // model 567
		case 168: speed = 138; // model 568
		case 169: speed = 0;   // model 569
		case 170: speed = 0;   // model 570
		case 171: speed = 88;  // model 571
		case 172: speed = 58;  // model 572
		case 173: speed = 104; // model 573
		case 174: speed = 57;  // model 574
		case 175: speed = 149; // model 575
		case 176: speed = 140; // model 576  
		case 177: speed = 0;   // model 577
		case 178: speed = 123; // model 578
		case 179: speed = 149; // model 579
		case 180: speed = 144; // model 580
		case 181: speed = 101; // model 581
		case 182: speed = 115; // model 582
		case 183: speed = 66;  // model 583
		case 184: speed = 0;   // model 584
		case 185: speed = 144; // model 585
		case 186: speed = 132; // model 586
		case 187: speed = 155; // model 587
		case 188: speed = 102; // model 588
		case 189: speed = 153; // model 589
		case 190: speed = 0;   // model 590
		case 191: speed = 0;   // model 591
		case 192: speed = 0;   // model 592
		case 193: speed = 0;   // model 593
		case 194: speed = 57;  // model 594
		case 195: speed = 0;   // model 595
		case 196: speed = 166; // model 596
		case 197: speed = 166; // model 597
		case 198: speed = 166; // model 598
		case 199: speed = 149; // model 599
		case 200: speed = 142; // model 600
		case 201: speed = 104; // model 601
		case 202: speed = 160; // model 602
		case 203: speed = 162; // model 603
		case 204: speed = 139; // model 604
		case 205: speed = 142; // model 605
		case 206: speed = 0;   // model 606
		case 207: speed = 0;   // model 607
		case 208: speed = 0;   // model 608
		case 209: speed = 102; // model 609
		case 210: speed = 0;   // model 610
	}
	return speed;
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

/*LoadRemoveObjects(playerid)
{
	//Àâòîñàëîíû ìàïïèíã
	RemoveBuildingForPlayer(playerid, 17012, -542.00781, -522.84375, 29.59375, 47.142307); // removeWorldObject (cwsthseing26) (1)
	RemoveBuildingForPlayer(playerid, 17349, -542.00781, -522.84375, 29.59375, 47.142307); // (LOD) removeWorldObject (cwsthseing26) (1)
	RemoveBuildingForPlayer(playerid, 1440, -517.29407, -496.64197, 25.28182, 3.6364884); // removeWorldObject (DYN_BOX_PILE_3) (1)
	RemoveBuildingForPlayer(playerid, 17019, -606.03125, -528.82031, 30.52344, 33.533878); // removeWorldObject (cuntfrates1) (1)
	RemoveBuildingForPlayer(playerid, 17020, -475.97656, -544.85156, 28.11719, 25.477262); // removeWorldObject (cuntfrates02) (1)
	RemoveBuildingForPlayer(playerid, 1415, -503.04468, -528.96661, 26.85742, 3.9259243); // removeWorldObject (DYN_DUMPSTER) (1)
	RemoveBuildingForPlayer(playerid, 1441, -503.9577, -540.20068, 25.37274, 3.6971035); // removeWorldObject (DYN_BOX_PILE_4) (1)
	RemoveBuildingForPlayer(playerid, 1440, -502.7323, -521.13019, 25.04168, 3.6364884); // removeWorldObject (DYN_BOX_PILE_3) (2)
	RemoveBuildingForPlayer(playerid, 1441, -502.87076, -514.23639, 25.13281, 3.6971035); // removeWorldObject (DYN_BOX_PILE_4) (2)
	RemoveBuildingForPlayer(playerid, 1440, -503.63773, -510.20081, 25.28182, 3.6364884); // removeWorldObject (DYN_BOX_PILE_3) (3)
	RemoveBuildingForPlayer(playerid, 1440, -553.34729, -481.64856, 25.28182, 3.6364884); // removeWorldObject (DYN_BOX_PILE_3) (4)
	RemoveBuildingForPlayer(playerid, 1441, -553.89917, -496.1452, 25.07031, 3.6971035); // removeWorldObject (DYN_BOX_PILE_4) (3)
	RemoveBuildingForPlayer(playerid, 1441, -536.36157, -469.30817, 25.13281, 3.6971035); // removeWorldObject (DYN_BOX_PILE_4) (4)
	RemoveBuildingForPlayer(playerid, 1415, -541.13654, -560.90094, 25.79801, 3.9259243); // removeWorldObject (DYN_DUMPSTER) (2)
	RemoveBuildingForPlayer(playerid, 1278, -512.16406, -479.92187, 38.59375, 16.251438); // removeWorldObject (sub_floodlite) (1)
	RemoveBuildingForPlayer(playerid, 1278, -552.76562, -479.92187, 38.625, 16.251438); // removeWorldObject (sub_floodlite) (2)
	RemoveBuildingForPlayer(playerid, 1278, -573.05469, -479.92187, 38.57813, 16.251438); // removeWorldObject (sub_floodlite) (3)
	RemoveBuildingForPlayer(playerid, 1278, -532.46875, -479.92187, 38.64844, 16.251438); // removeWorldObject (sub_floodlite) (4)
	RemoveBuildingForPlayer(playerid, 1278, -491.85937, -479.92187, 38.58594, 16.251438); // removeWorldObject (sub_floodlite) (5)
	RemoveBuildingForPlayer(playerid, 1278, -471.55469, -479.92187, 38.625, 16.251438); // removeWorldObject (sub_floodlite) (6)
	RemoveBuildingForPlayer(playerid, 1415, -514.15717, -560.48889, 24.86114, 3.9259243); // removeWorldObject (DYN_DUMPSTER) (3)
	RemoveBuildingForPlayer(playerid, 1415, -619.89185, -490.4967, 25.37682, 3.9259243); // removeWorldObject (DYN_DUMPSTER) (4)
	RemoveBuildingForPlayer(playerid, 1415, -619.12201, -473.60846, 25.07011, 3.9259243); // removeWorldObject (DYN_DUMPSTER) (5)
	RemoveBuildingForPlayer(playerid, 7493, 966.35938, 2140.9688, 13.39844, 62.196331); // removeWorldObject (vgnabatbuild) (1)
	RemoveBuildingForPlayer(playerid, 7673, 966.35938, 2140.9688, 13.39844, 62.196331); // (LOD) removeWorldObject (vgnabatbuild) (1)
	RemoveBuildingForPlayer(playerid, 1497, 965.89465, 2160.8311, 10.7464, 3.4588091); // removeWorldObject (Gen_doorEXT02) (1)
	//new gorod
	RemoveBuildingForPlayer(playerid, 17910, 2916.765, -1877.648, 0.070, 0.250);
	RemoveBuildingForPlayer(playerid, 17953, 2916.765, -1877.648, 0.070, 0.250);
	//âîêçàë
	RemoveBuildingForPlayer(playerid, 4821, 1745.199, -1882.849, 26.140, 0.250);
	RemoveBuildingForPlayer(playerid, 4961, 1745.199, -1882.849, 26.140, 0.250);
	RemoveBuildingForPlayer(playerid, 5033, 1745.199, -1882.849, 26.140, 0.250);
	RemoveBuildingForPlayer(playerid, 5055, 1745.199, -1882.849, 26.140, 0.250);
	RemoveBuildingForPlayer(playerid, 5024, 1748.839, -1883.030, 14.187, 0.250);
	////////////
	//hotel
	RemoveBuildingForPlayer(playerid, 3695, 2239.9297, -1790.6953, 17.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 3695, 2282.9922, -1790.6953, 17.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 3695, 2314.8203, -1790.6953, 17.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 3695, 2352.7188, -1790.6953, 17.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 3695, 2387.8203, -1790.6953, 17.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 17854, 2492.7891, -1490.0156, 34.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2230.4141, -1815.1484, 11.3438, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2234.4844, -1817.9297, 12.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 3584, 2239.9297, -1790.6953, 17.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 1307, 2249.8672, -1815.4141, 12.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 2259.9453, -1796.0703, 16.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2258.3438, -1804.7422, 12.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 17886, 2264.0391, -1789.2578, 20.7734, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2265.2969, -1791.0000, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2265.2969, -1796.4531, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2265.2969, -1807.3281, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2265.2969, -1801.8672, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2275.3906, -1820.7266, 12.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2268.1875, -1810.0313, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2273.6953, -1810.0313, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 3584, 2282.9922, -1790.6953, 17.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2271.6484, -1772.3984, 8.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 2297.8984, -1793.8203, 16.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2297.3828, -1798.5391, 8.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2305.0625, -1810.0313, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2302.1719, -1807.3281, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2302.1719, -1801.8672, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2302.1719, -1791.0000, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2302.1719, -1796.4531, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 3584, 2314.8203, -1790.6953, 17.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2302.1719, -1775.5078, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2302.1719, -1770.0469, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2302.1719, -1780.9844, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2304.7813, -1767.3828, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 645, 2332.8281, -1817.7109, 12.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2341.7578, -1810.0313, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2338.8672, -1807.3281, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2341.7578, -1817.7266, 8.3594, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2338.8672, -1801.8672, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2338.8672, -1791.0000, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2338.8672, -1796.4531, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2334.7109, -1785.0625, 12.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 17887, 2343.6094, -1784.5078, 20.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 3584, 2352.7188, -1790.6953, 17.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2367.6484, -1802.7969, 8.3594, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2367.6484, -1780.7734, 11.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2378.3359, -1818.7266, 8.3594, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2374.1016, -1800.4688, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2374.1016, -1805.9297, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2374.1016, -1811.3828, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2374.1016, -1780.9844, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2374.1016, -1789.6016, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2374.1016, -1795.0547, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2376.6172, -1767.2734, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2374.1016, -1770.0469, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1408, 2374.1016, -1775.5078, 13.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 645, 2399.9766, -1815.9922, 11.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 3584, 2387.8203, -1790.6953, 17.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 3758, 2702.3984, -2324.2578, 3.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 5352, 2838.1953, -2488.6641, 29.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 3724, 2838.1953, -2488.6641, 29.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 3753, 2702.3984, -2324.2578, 3.0391, 0.25);
	// Most SF rabota
	RemoveBuildingForPlayer(playerid, 9484, -2681.585, 1316.062, 25.140, 0.250);
	RemoveBuildingForPlayer(playerid, 9582, -2657.921, 1409.710, 14.828, 0.250);
	RemoveBuildingForPlayer(playerid, 9683, -2681.492, 1384.664, 33.296, 0.250);
	RemoveBuildingForPlayer(playerid, 9684, -2681.492, 1529.109, 112.789, 0.250);
	RemoveBuildingForPlayer(playerid, 9685, -2681.492, 1529.109, 112.789, 0.250);
	RemoveBuildingForPlayer(playerid, 9686, -2681.492, 1595.007, 109.437, 0.250);
	RemoveBuildingForPlayer(playerid, 9687, -2681.492, 1684.460, 120.453, 0.250);
	RemoveBuildingForPlayer(playerid, 9688, -2681.500, 1764.843, 113.117, 0.250);
	RemoveBuildingForPlayer(playerid, 9689, -2681.492, 1684.460, 120.453, 0.250);
	RemoveBuildingForPlayer(playerid, 9690, -2681.492, 1595.007, 109.437, 0.250);
	RemoveBuildingForPlayer(playerid, 9691, -2681.492, 1847.937, 120.085, 0.250);
	RemoveBuildingForPlayer(playerid, 9692, -2681.492, 1933.867, 109.437, 0.250);
	RemoveBuildingForPlayer(playerid, 9693, -2681.492, 1847.937, 120.085, 0.250);
	RemoveBuildingForPlayer(playerid, 9694, -2681.492, 1933.867, 109.437, 0.250);
	RemoveBuildingForPlayer(playerid, 9695, -2681.492, 2042.156, 86.718, 0.250);
	RemoveBuildingForPlayer(playerid, 9696, -2681.492, 2042.156, 86.718, 0.250);
	RemoveBuildingForPlayer(playerid, 9755, -2657.921, 1409.710, 14.828, 0.250);
	RemoveBuildingForPlayer(playerid, 9837, -2681.492, 1933.867, 109.437, 0.250);
	RemoveBuildingForPlayer(playerid, 9838, -2681.492, 1595.007, 109.437, 0.250);
	RemoveBuildingForPlayer(playerid, 9866, -2681.492, 1384.664, 33.296, 0.250);
	RemoveBuildingForPlayer(playerid, 9868, -2681.351, 1274.609, 57.421, 0.250);
	RemoveBuildingForPlayer(playerid, 9869, -2681.585, 1316.062, 25.140, 0.250);
	RemoveBuildingForPlayer(playerid, 9870, -2655.242, 1372.859, 17.726, 0.250);
	RemoveBuildingForPlayer(playerid, 1290, -2682.031, 1284.437, 60.492, 0.250);
	RemoveBuildingForPlayer(playerid, 1290, -2681.585, 1352.062, 60.812, 0.250);
	RemoveBuildingForPlayer(playerid, 1290, -2681.585, 1421.726, 60.781, 0.250);
	RemoveBuildingForPlayer(playerid, 1290, -2681.585, 1609.882, 70.093, 0.250);
	RemoveBuildingForPlayer(playerid, 1290, -2681.585, 1860.750, 72.171, 0.250);
	RemoveBuildingForPlayer(playerid, 1290, -2681.585, 1798.031, 73.328, 0.250);
	RemoveBuildingForPlayer(playerid, 1290, -2681.585, 1923.468, 69.882, 0.250);
	RemoveBuildingForPlayer(playerid, 1290, -2681.585, 1986.187, 66.523, 0.250);
	RemoveBuildingForPlayer(playerid, 1290, -2681.585, 2111.617, 60.789, 0.250);
	RemoveBuildingForPlayer(playerid, 1290, -2681.585, 2048.906, 62.093, 0.250);
	RemoveBuildingForPlayer(playerid, 1290, -2681.585, 1547.164, 66.804, 0.250);
	RemoveBuildingForPlayer(playerid, 1290, -2681.585, 1484.445, 62.359, 0.250);
	RemoveBuildingForPlayer(playerid, 1290, -2681.585, 1735.312, 73.343, 0.250);
	RemoveBuildingForPlayer(playerid, 1290, -2681.585, 1672.601, 72.304, 0.250);
	RemoveBuildingForPlayer(playerid, 9623, -2681.351, 1274.609, 57.421, 0.250);
	RemoveBuildingForPlayer(playerid, 9766, -2659.156, 1494.976, 51.484, 0.250);
	RemoveBuildingForPlayer(playerid, 9767, -2655.531, 1422.664, 35.335, 0.250);
	RemoveBuildingForPlayer(playerid, 9618, -2655.242, 1372.859, 17.726, 0.250);
	RemoveBuildingForPlayer(playerid, 9817, -2655.242, 1372.859, 17.726, 0.250);
	RemoveBuildingForPlayer(playerid, 1501, -2626.242, 1412.773, 6.046, 0.250);
	RemoveBuildingForPlayer(playerid, 4510, -2676.304, 1541.343, 64.976, 0.250);
	RemoveBuildingForPlayer(playerid, 4511, -2687.000, 2058.203, 59.734, 0.250);
	RemoveBuildingForPlayer(playerid, 4512, -2676.304, 1234.601, 60.695, 0.250);
	//rabota otel ls
	RemoveBuildingForPlayer(playerid, 6456, 397.539, -1848.492, 12.148, 0.250);
	RemoveBuildingForPlayer(playerid, 1368, 378.023, -1821.992, 7.476, 0.250);
	RemoveBuildingForPlayer(playerid, 1368, 381.796, -1834.921, 7.476, 0.250);
	RemoveBuildingForPlayer(playerid, 1371, 387.132, -1831.445, 7.593, 0.250);
	RemoveBuildingForPlayer(playerid, 6457, 385.085, -1823.648, 10.281, 0.250);
	RemoveBuildingForPlayer(playerid, 1368, 381.796, -1809.359, 7.476, 0.250);
	RemoveBuildingForPlayer(playerid, 6288, 397.539, -1848.492, 12.148, 0.250);
	RemoveBuildingForPlayer(playerid, 1500, 387.562, -1817.085, 6.820, 0.250);
	////////////
	////////////
	RemoveBuildingForPlayer(playerid, 1258, 1510.8906, -1607.3125, 13.6953, 0.25);
	/////ÁÀÍÊ
	RemoveBuildingForPlayer(playerid, 4057, 1479.5547, -1693.1406, 19.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 4210, 1479.5625, -1631.4531, 12.0781, 0.25);
	RemoveBuildingForPlayer(playerid, 713, 1407.1953, -1749.3125, 13.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 713, 1457.9375, -1620.6953, 13.4531, 0.25);
//	RemoveBuildingForPlayer(playerid, 1266, 1353.6406, -1713.5703, 19.8438, 0.25);
//	RemoveBuildingForPlayer(playerid, 1266, 1538.5234, -1609.8047, 19.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 4229, 1597.9063, -1699.7500, 30.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 4230, 1597.9063, -1699.7500, 30.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 4236, 1387.0313, -1715.0234, 30.4141, 0.25);
//	RemoveBuildingForPlayer(playerid, 1261, 1413.6328, -1721.8203, 28.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 713, 1496.8672, -1707.8203, 13.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 713, 1405.2344, -1821.1172, 13.1016, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1325.7109, -1732.8281, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1335.1953, -1731.7813, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1357.5156, -1732.9375, 15.6250, 0.25);
//	RemoveBuildingForPlayer(playerid, 1260, 1353.6406, -1713.5703, 19.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1376.5156, -1731.8516, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 4235, 1387.0313, -1715.0234, 30.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1388.3594, -1745.4453, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1429.5313, -1748.4219, 12.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1447.9063, -1748.2266, 12.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1441.8594, -1733.0078, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1403.3672, -1733.0078, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1414.4141, -1731.4297, 15.6250, 0.25);
//	RemoveBuildingForPlayer(playerid, 1267, 1413.6328, -1721.8203, 28.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1430.1719, -1719.4688, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1451.6250, -1727.6719, 16.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1467.9844, -1727.6719, 16.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1485.1719, -1727.6719, 16.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1468.9844, -1713.5078, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 1479.6953, -1716.7031, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1505.1797, -1727.6719, 16.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1488.7656, -1713.7031, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1289, 1504.7500, -1711.8828, 13.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1513.2344, -1732.9219, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1516.0000, -1748.6016, 13.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1419.3281, -1710.2344, 11.8359, 0.25);
	RemoveBuildingForPlayer(playerid, 1258, 1445.0078, -1704.7656, 13.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 4195, 1381.5859, -1698.0156, 14.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 1258, 1445.0078, -1692.2344, 13.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1445.8125, -1650.0234, 22.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1428.9375, -1605.8203, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1443.2031, -1592.9453, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1457.7266, -1710.0625, 12.3984, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1461.6563, -1707.6875, 11.8359, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1468.9844, -1704.6406, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 1463.0625, -1701.5703, 13.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 1479.6953, -1702.5313, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1457.5547, -1697.2891, 12.3984, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1468.9844, -1694.0469, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 1479.3828, -1692.3906, 15.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 4186, 1479.5547, -1693.1406, 19.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1461.1250, -1687.5625, 11.8359, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 1463.0625, -1690.6484, 13.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 641, 1458.6172, -1684.1328, 11.1016, 0.25);
	RemoveBuildingForPlayer(playerid, 625, 1457.2734, -1666.2969, 13.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1468.9844, -1682.7188, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1471.4063, -1666.1797, 22.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 1479.3828, -1682.3125, 15.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 625, 1458.2578, -1659.2578, 13.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1449.8516, -1655.9375, 22.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 1477.9375, -1652.7266, 15.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1479.6094, -1653.2500, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 625, 1457.3516, -1650.5703, 13.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 625, 1454.4219, -1642.4922, 13.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1467.8516, -1646.5938, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1472.8984, -1651.5078, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1465.9375, -1639.8203, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1231, 1466.4688, -1637.9609, 15.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 625, 1449.5938, -1635.0469, 13.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1467.7109, -1632.8906, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1232, 1465.8906, -1629.9766, 15.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1472.6641, -1627.8828, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1479.4688, -1626.0234, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 3985, 1479.5625, -1631.4531, 12.0781, 0.25);
	RemoveBuildingForPlayer(playerid, 4206, 1479.5547, -1639.6094, 13.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 1232, 1465.8359, -1608.3750, 15.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 1229, 1466.4844, -1598.0938, 14.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1451.3359, -1596.7031, 16.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1488.7656, -1704.5938, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 1494.2109, -1694.4375, 13.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1488.7656, -1693.7344, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1496.9766, -1686.8516, 11.8359, 0.25);
	RemoveBuildingForPlayer(playerid, 641, 1494.1406, -1689.2344, 11.1016, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1488.7656, -1682.6719, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1480.6094, -1666.1797, 22.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1488.2266, -1666.1797, 22.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1486.4063, -1651.3906, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1491.3672, -1646.3828, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1493.1328, -1639.4531, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1486.1797, -1627.7656, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1491.2188, -1632.6797, 13.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 1232, 1494.4141, -1629.9766, 15.5313, 0.25);
	RemoveBuildingForPlayer(playerid, 1232, 1494.3594, -1608.3750, 15.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 1229, 1498.0547, -1598.0938, 14.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 1288, 1504.7500, -1705.4063, 13.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 1287, 1504.7500, -1704.4688, 13.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 1286, 1504.7500, -1695.0547, 13.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 1285, 1504.7500, -1694.0391, 13.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1498.9609, -1684.6094, 12.3984, 0.25);
	RemoveBuildingForPlayer(playerid, 625, 1504.1641, -1662.0156, 13.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 625, 1504.7188, -1670.9219, 13.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1503.1875, -1621.1250, 11.8359, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1501.2813, -1624.5781, 12.3984, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 1498.3594, -1616.9688, 12.3984, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1504.8906, -1596.7031, 16.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1508.4453, -1668.7422, 22.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 625, 1505.6953, -1654.8359, 13.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 625, 1508.5156, -1647.8594, 13.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 625, 1513.2734, -1642.4922, 13.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 1258, 1510.8906, -1607.3125, 13.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1516.1641, -1591.6563, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 4190, 1629.6484, -1765.8047, 15.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1533.2656, -1749.0234, 12.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1568.8828, -1745.4766, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1545.7656, -1731.6719, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1524.8281, -1721.6328, 16.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1530.1172, -1717.0078, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1229, 1524.2188, -1693.9688, 14.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 1229, 1524.2188, -1673.7109, 14.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1582.6719, -1733.1328, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1525.3828, -1611.1563, 16.4219, 0.25);
//	RemoveBuildingForPlayer(playerid, 1260, 1538.5234, -1609.8047, 19.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 1283, 1528.9531, -1605.8594, 15.6250, 0.25);
	///////////
	RemoveBuildingForPlayer(playerid, 1440, 1141.9844, -1346.1094, 13.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2744.5703, -2436.1875, 13.3438, 0.25);
	RemoveBuildingForPlayer(playerid, 3577, 2744.5703, -2427.3203, 13.3516, 0.25);

	RemoveBuildingForPlayer(playerid, 1411, 347.1953, 1799.2656, 18.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1411, 342.9375, 1796.2891, 18.7578, 0.25);


	RemoveBuildingForPlayer(playerid, 3276, -34.2969, 160.0156, 2.3203, 0.25);
	RemoveBuildingForPlayer(playerid, 10506, -2288.078, -98.125, 43.335, 0.250);
	RemoveBuildingForPlayer(playerid, 10741, -2341.828, -95.148, 42.445, 0.250);
	RemoveBuildingForPlayer(playerid, 1308, -2311.835, -80.070, 34.625, 0.250);
	RemoveBuildingForPlayer(playerid, 1308, -2311.695, -120.398, 34.632, 0.250);
	RemoveBuildingForPlayer(playerid, 10393, -2288.078, -98.125, 43.335, 0.250);

	RemoveBuildingForPlayer(playerid, 14847, 246.2344, 117.8047, 1005.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, -109.164, -1181.343, 1.671, 0.250);
	RemoveBuildingForPlayer(playerid, 1438, -84.242, -1180.265, 0.851, 0.250);
	RemoveBuildingForPlayer(playerid, 1415, -77.218, -1188.367, 0.835, 0.250);
	RemoveBuildingForPlayer(playerid, 1440, -103.687, -1172.578, 2.265, 0.250);
	RemoveBuildingForPlayer(playerid, 1438, -77.421, -1165.554, 1.023, 0.250);
	//////îãðàäêà ó áàíêà
	RemoveBuildingForPlayer(playerid, 713, 1304.7734, -1753.5859, 12.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 713, 1304.7734, -1729.9375, 12.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 713, 1304.7734, -1780.1094, 12.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 713, 1304.7734, -1808.4922, 12.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 713, 1304.7734, -1839.8672, 12.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1305.0078, -1702.3828, 18.2266, 0.25);
	///saduu

	RemoveBuildingForPlayer(playerid, 1290, 1177.0703, -1828.4063, 18.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1177.0703, -1767.3359, 18.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1177.0703, -1733.4063, 18.5781, 0.25);

	RemoveBuildingForPlayer(playerid, 700, 1792.750, -1974.554, 11.445, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 1794.593, -1980.750, 9.671, 0.250);
	RemoveBuildingForPlayer(playerid, 3744, 2313.046, -2008.539, 15.023, 0.250);
	RemoveBuildingForPlayer(playerid, 3574, 2313.046, -2008.539, 15.023, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 2352.046, -1898.164, 11.914, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2354.937, -1888.242, 10.804, 0.250);
	RemoveBuildingForPlayer(playerid, 620, 2357.851, -1917.968, 10.804, 0.250);
	RemoveBuildingForPlayer(playerid, 671, 2359.945, -1891.000, 11.945, 0.250);
	RemoveBuildingForPlayer(playerid, 1308, 2138.929, -1399.914, 23.054, 0.250);
	RemoveBuildingForPlayer(playerid, 1308, 2139.453, -1500.218, 23.054, 0.250);
	RemoveBuildingForPlayer(playerid, 1308, 2138.929, -1467.679, 23.054, 0.250);
	RemoveBuildingForPlayer(playerid, 1308, 2162.375, -1504.000, 23.054, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 2159.765, -1507.625, 22.398, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 2163.718, -1499.062, 26.773, 0.250);
	RemoveBuildingForPlayer(playerid, 1224, 2173.234, -1503.078, 23.531, 0.250);
	RemoveBuildingForPlayer(playerid, 1220, 2172.453, -1501.968, 23.281, 0.250);
	RemoveBuildingForPlayer(playerid, 1308, 2138.929, -1433.578, 23.054, 0.250);
	RemoveBuildingForPlayer(playerid, 5565, 2171.453, -1448.421, 28.804, 0.250);
	RemoveBuildingForPlayer(playerid, 1308, 2179.429, -1500.312, 23.054, 0.250);

	//avianos
	RemoveBuildingForPlayer(playerid, 966, -1526.3906, 481.3828, 6.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 968, -1526.4375, 481.3828, 6.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, -1411.109, 481.039, 20.375, 0.250);
	RemoveBuildingForPlayer(playerid, 1278, -1413.882, 481.109, 20.375, 0.250);
	RemoveBuildingForPlayer(playerid, 1278, -1298.578, 434.890, 20.375, 0.250);

	//braingang
	RemoveBuildingForPlayer(playerid, 1226, -1998.2734, 278.2500, 36.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 3699, 2471.671, -1428.132, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 3699, 2490.695, -1428.132, 30.515, 0.250);
	RemoveBuildingForPlayer(playerid, 3699, 2490.695, -1413.898, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 3699, 2471.671, -1413.898, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 3699, 2490.695, -1395.265, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 3699, 2471.671, -1395.265, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 3699, 2490.695, -1379.828, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 3699, 2471.671, -1379.828, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 3699, 2490.695, -1362.656, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 3699, 2471.671, -1362.656, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 700, 2462.710, -1386.179, 27.859, 0.250);
	RemoveBuildingForPlayer(playerid, 3698, 2471.671, -1428.132, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 3698, 2471.671, -1413.898, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 3698, 2471.671, -1395.265, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 3698, 2471.671, -1379.828, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 2481.695, -1431.515, 27.000, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 2485.546, -1372.554, 27.445, 0.250);
	RemoveBuildingForPlayer(playerid, 3698, 2490.695, -1428.132, 30.515, 0.250);
	RemoveBuildingForPlayer(playerid, 3698, 2490.695, -1413.898, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 2499.812, -1419.570, 23.992, 0.250);
	RemoveBuildingForPlayer(playerid, 3698, 2490.695, -1395.265, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 3698, 2490.695, -1379.828, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 3698, 2471.671, -1362.656, 30.812, 0.250);
	RemoveBuildingForPlayer(playerid, 3698, 2490.695, -1362.656, 30.812, 0.250);
	////
	RemoveBuildingForPlayer(playerid, 1235, -1961.9844, 132.6172, 27.1484, 0.25);

	RemoveBuildingForPlayer(playerid, 966, -1701.4297, 687.5938, 23.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 966, -1572.2031, 658.8359, 6.0781,10);

	RemoveBuildingForPlayer(playerid, 1346, 1574.7266, 736.9844, 11.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 1346, 1689.3906, 1266.9766, 11.1484, 0.25);

	RemoveBuildingForPlayer(playerid, 620, 1762.8281, -1846.7109, 10.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1778.4766, -1846.7109, 10.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1794.1172, -1846.7109, 10.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1809.7656, -1846.7109, 10.8047, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1747.1875, -1846.7109, 10.8047, 0.25);

	RemoveBuildingForPlayer(playerid, 10983, -2076.648, 222.851, 31.218, 0.250);
	RemoveBuildingForPlayer(playerid, 11143, -2076.648, 222.851, 31.218, 0.250);
	RemoveBuildingForPlayer(playerid, 11223, -2049.171, 250.320, 33.078, 0.250);
	RemoveBuildingForPlayer(playerid, 11311, -1968.562, 139.109, 31.867, 0.250);
	RemoveBuildingForPlayer(playerid, 11339, -2079.953, 159.203, 30.867, 0.250);
	RemoveBuildingForPlayer(playerid, 11354, -1921.890, 137.882, 29.757, 0.250);
	RemoveBuildingForPlayer(playerid, 3865, -2063.242, 258.750, 35.742, 0.250);
	RemoveBuildingForPlayer(playerid, 3869, -2123.289, 269.531, 41.851, 0.250);
	RemoveBuildingForPlayer(playerid, 3869, -2126.210, 231.976, 41.687, 0.250);
	RemoveBuildingForPlayer(playerid, 3869, -2116.679, 131.007, 42.148, 0.250);
	RemoveBuildingForPlayer(playerid, 3865, -2059.531, 256.523, 37.007, 0.250);
	RemoveBuildingForPlayer(playerid, 3888, -2128.179, 171.460, 42.429, 0.250);
	RemoveBuildingForPlayer(playerid, 3888, -2066.359, 301.914, 42.171, 0.250);
	RemoveBuildingForPlayer(playerid, 3887, -2066.359, 301.914, 42.171, 0.250);
	RemoveBuildingForPlayer(playerid, 3887, -2128.179, 171.460, 42.429, 0.250);
	RemoveBuildingForPlayer(playerid, 3866, -2116.679, 131.007, 42.148, 0.250);
	RemoveBuildingForPlayer(playerid, 11340, -2079.953, 159.203, 30.867, 0.250);
	RemoveBuildingForPlayer(playerid, 3872, -2079.820, 159.671, 40.890, 0.250);
	RemoveBuildingForPlayer(playerid, 3864, -2111.882, 172.468, 40.195, 0.250);
	RemoveBuildingForPlayer(playerid, 3872, -2116.750, 177.078, 40.984, 0.250);
	RemoveBuildingForPlayer(playerid, 1350, -2136.437, 213.421, 34.312, 0.250);
	RemoveBuildingForPlayer(playerid, 3872, -2064.210, 210.140, 41.257, 0.250);
	RemoveBuildingForPlayer(playerid, 3872, -2107.031, 226.039, 40.843, 0.250);
	RemoveBuildingForPlayer(playerid, 10984, -2126.156, 238.617, 35.265, 0.250);
	RemoveBuildingForPlayer(playerid, 3864, -2102.210, 230.703, 40.054, 0.250);
	RemoveBuildingForPlayer(playerid, 3866, -2126.210, 231.976, 41.687, 0.250);
	RemoveBuildingForPlayer(playerid, 10986, -2130.054, 275.562, 35.375, 0.250);
	RemoveBuildingForPlayer(playerid, 10987, -2137.820, 264.281, 35.781, 0.250);
	RemoveBuildingForPlayer(playerid, 3866, -2123.289, 269.531, 41.851, 0.250);
	RemoveBuildingForPlayer(playerid, 3872, -2118.132, 263.843, 41.359, 0.250);
	RemoveBuildingForPlayer(playerid, 10985, -2099.273, 292.914, 35.070, 0.250);
	RemoveBuildingForPlayer(playerid, 11305, -1968.562, 139.109, 31.867, 0.250);
	RemoveBuildingForPlayer(playerid, 1264, -1980.914, 149.562, 27.039, 0.250);
	RemoveBuildingForPlayer(playerid, 1264, -1980.914, 148.078, 27.039, 0.250);
	RemoveBuildingForPlayer(playerid, 1264, -1981.437, 148.921, 27.039, 0.250);
	RemoveBuildingForPlayer(playerid, 3872, -2048.453, 265.093, 41.656, 0.250);
	RemoveBuildingForPlayer(playerid, 3864, -2041.750, 265.101, 40.867, 0.250);
	RemoveBuildingForPlayer(playerid, 11353, -1921.890, 137.882, 29.757, 0.250);

	RemoveBuildingForPlayer(playerid, 11156, -2056.546, -91.421, 34.492, 0.250);
	RemoveBuildingForPlayer(playerid, 11371, -2028.132, -111.273, 36.132, 0.250);
	RemoveBuildingForPlayer(playerid, 11372, -2076.437, -107.929, 36.968, 0.250);
	RemoveBuildingForPlayer(playerid, 1278, -2094.343, -143.195, 48.351, 0.250);
	RemoveBuildingForPlayer(playerid, 11099, -2056.992, -184.546, 34.414, 0.250);
	RemoveBuildingForPlayer(playerid, 1497, -2029.015, -120.062, 34.257, 0.250);
	RemoveBuildingForPlayer(playerid, 11015, -2028.132, -111.273, 36.132, 0.250);
	RemoveBuildingForPlayer(playerid, 11014, -2076.437, -107.929, 36.968, 0.250);
	RemoveBuildingForPlayer(playerid, 1532, -2025.828, -102.468, 34.273, 0.250);
	RemoveBuildingForPlayer(playerid, 10976, -2056.546, -91.421, 34.492, 0.250);

	RemoveBuildingForPlayer(playerid, 3187, 26.4531, -2648.5703, 43.5078, 0.25);//àçñ â ñô

	RemoveBuildingForPlayer(playerid, 3509, 2057.531, 960.859, 9.554, 0.250);
	RemoveBuildingForPlayer(playerid, 713, 1376.117, 1917.476, 9.492, 0.250);
	RemoveBuildingForPlayer(playerid, 7694, 1758.8984, 2214.4688, 13.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 7554, 1758.8984, 2214.4688, 13.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 6146, 676.359, -1566.695, 16.335, 0.250);
	RemoveBuildingForPlayer(playerid, 1297, 670.046, -1581.734, 16.453, 0.250);
	RemoveBuildingForPlayer(playerid, 6145, 676.359, -1566.695, 16.335, 0.250);
	RemoveBuildingForPlayer(playerid, 1297, 700.406, -1581.734, 16.406, 0.250);
	RemoveBuildingForPlayer(playerid, 1297, 703.164, -1567.914, 16.265, 0.250);
	RemoveBuildingForPlayer(playerid, 1308, 173.1484, -271.8828, 0.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 2435.9453, -1481.1719, 26.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, 2427.8516, -18.1484, 27.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 1372, 1920.0547, -2122.4141, 12.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 1907.2578, -1971.5859, 13.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 3594, 2450.4609, -1890.7813, 13.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 3645, 2069.6172, -1556.7031, 15.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 3645, 2070.7578, -1586.0156, 15.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 1524, 2074.1797, -1579.1484, 14.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 3644, 2070.7578, -1586.0156, 15.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 3644, 2069.6172, -1556.7031, 15.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, 665.2266, -624.3750, 16.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 1345, 668.2109, -624.4453, 16.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 1687, 611.0000, -562.9531, 25.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 3696, 2336.9219, -1273.5469, 31.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 3696, 2336.9219, -1242.0859, 31.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 3696, 2336.9219, -1211.4219, 31.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 714, 2356.3516, -1283.4063, 26.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 3697, 2336.9219, -1273.5469, 31.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 3697, 2336.9219, -1242.0859, 31.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 3697, 2336.9219, -1211.4219, 31.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1647.6563, -1747.1563, 13.1250, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1658.2500, -1748.7109, 12.8984, 0.25);


	RemoveBuildingForPlayer(playerid, 3175, -143.5156, -51.3516, 1.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 3374, -91.9453, 47.8125, 3.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -94.5234, 31.6172, 2.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -90.5313, 42.1484, 2.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3374, -91.9453, 47.8125, 3.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 3718, 2023.4766, -1116.8438, 28.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 5671, 1996.3984, -1110.7891, 30.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 3639, 2023.4766, -1116.8438, 28.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 5520, 1996.3984, -1110.7891, 30.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 3562, 2232.3984, -1464.7969, 25.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 3562, 2247.5313, -1464.7969, 25.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 3562, 2263.7188, -1464.7969, 25.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 3562, 2243.7109, -1401.7813, 25.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 3562, 2230.6094, -1401.7813, 25.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 3562, 2256.6641, -1401.7813, 25.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 3582, 2230.6094, -1401.7813, 25.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 3582, 2243.7109, -1401.7813, 25.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 645, 2237.5313, -1395.4844, 23.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 3582, 2256.6641, -1401.7813, 25.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 3582, 2232.3984, -1464.7969, 25.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 2241.8906, -1458.9297, 22.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 3582, 2247.5313, -1464.7969, 25.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 3582, 2263.7188, -1464.7969, 25.4375, 0.25);

	RemoveBuildingForPlayer(playerid, 1308, 9.0234, 15.1563, -5.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 672, -35.7109, 18.1016, 3.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 672, -15.2109, 94.8438, 3.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 672, 153.1953, 23.0313, 0.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 13052, -69.0469, 86.8359, 2.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 13053, -59.9531, 110.4609, 13.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 672, -112.4766, -158.2422, 2.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 672, -149.3359, -160.5078, 3.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -108.0234, -114.6563, 2.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -119.0156, -112.8672, 2.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -88.6328, -112.6484, 2.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 672, 65.7891, -168.7266, 0.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -100.7813, -110.4609, 2.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -123.5156, -106.2266, 2.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 3276, -135.2734, -104.4453, 2.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 12915, -69.0469, 86.8359, 2.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 3374, -41.2500, 98.4141, 3.4609, 0.25);
	RemoveBuildingForPlayer(playerid, 3374, -36.0156, 96.1875, 3.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 12912, -59.9531, 110.4609, 13.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 405.3594, 2563.0859, 15.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 16374, 425.4688, 2531.0000, 22.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 1245, 2675.5234, 1172.9297, 11.1563, 0.25);
	//RemoveBuildingForPlayer(playerid, 4064, 1571.6016, -1675.7500, 35.6797, 0.25);
	//RemoveBuildingForPlayer(playerid, 3976, 1571.6016, -1675.7500, 35.6797, 0.25);
	RemoveBuildingForPlayer(playerid, 4063, 1578.4688, -1676.4219, 13.0703, 0.25);
	RemoveBuildingForPlayer(playerid, 3975, 1578.4688, -1676.4219, 13.0703, 0.25);
	RemoveBuildingForPlayer(playerid, 4192, 1591.6953, -1674.8516, 20.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 3366, 276.6563, 2023.7578, 16.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 16094, 191.1406, 1870.0391, 21.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 3268, 276.6563, 2023.7578, 16.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3377, -156.9453, -266.9141, 4.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 3378, -156.9453, -266.9141, 4.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 645, 986.8438, 1702.2734, 7.3906, 0.25);
	RemoveBuildingForPlayer(playerid, 1250, 997.4141, 1707.5234, 10.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 1251, 997.0469, 1710.9531, 11.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 652, 987.2031, 1763.5859, 7.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 1251, 998.0938, 1755.6875, 11.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 1250, 997.7266, 1759.1250, 10.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 8229, 1142.0313, 1362.5000, 12.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 621, 1153.8672, 1387.7656, 9.0859, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 1132.5938, 1389.6641, 19.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 9170, 2117.1250, 923.4453, 12.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3465, 2114.9063, 925.5078, 11.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 3465, 2109.0469, 925.5078, 11.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 3465, 2109.0469, 914.7188, 11.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 3465, 2114.9063, 914.7188, 11.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 9169, 2117.1250, 923.4453, 12.9219, 0.25);
	RemoveBuildingForPlayer(playerid, 3465, 2120.8203, 925.5078, 11.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 3465, 2120.8203, 914.7188, 11.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 3221, 112.3750, 1085.6719, 12.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 691, 160.6875, 1106.7344, 13.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 1257, 2449.6406, 2241.3672, 11.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 1257, 2083.0625, 2462.2500, 10.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 1257, 2391.9844, 2422.1797, 11.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 1257, 1698.5313, 1965.0625, 11.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, 161.8672, -175.5547, 1.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, 161.3438, -173.2891, 1.0625, 0.25);
	//	RemoveBuildingForPlayer(playerid, 4226, 1359.2813, -1796.4688, 24.3438, 0.25);
	//	RemoveBuildingForPlayer(playerid, 1265, 1336.1563, -1844.0156, 12.9844, 0.25);
	//	RemoveBuildingForPlayer(playerid, 1265, 1336.8750, -1818.2266, 12.9844, 0.25);
	//RemoveBuildingForPlayer(playerid, 1372, 1336.7891, -1816.3047, 12.6641, 0.25);
	//	RemoveBuildingForPlayer(playerid, 1220, 1338.1250, -1816.5781, 12.9297, 0.25);
	//	RemoveBuildingForPlayer(playerid, 1230, 1338.0781, -1815.7578, 12.9766, 0.25);
	//	RemoveBuildingForPlayer(playerid, 1220, 1338.8984, -1816.1641, 12.9297, 0.25);
	//RemoveBuildingForPlayer(playerid, 4023, 1359.2813, -1796.4688, 24.3438, 0.25);
	//RemoveBuildingForPlayer(playerid, 1372, 1337.6953, -1774.7344, 12.6641, 0.25);
	//	RemoveBuildingForPlayer(playerid, 1265, 1338.7891, -1775.3203, 12.9688, 0.25);
	//	RemoveBuildingForPlayer(playerid, 1265, 1337.0078, -1773.8672, 13.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 14606, 2150.5156, 1602.7891, 1009.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 14623, 2235.8828, 1677.0000, 1012.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 14624, 2253.4219, 1597.9219, 1011.1953, 0.25);
	RemoveBuildingForPlayer(playerid, 14625, 2192.4453, 1602.7891, 1009.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 14627, 2242.9531, 1603.4531, 1012.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2273.4609, 1596.4766, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2268.7188, 1596.4688, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2273.4609, 1589.7969, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2268.7188, 1589.7969, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2263.6563, 1589.7969, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2258.2578, 1589.7969, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2253.2344, 1589.7969, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2263.6563, 1596.4844, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2258.2578, 1596.4766, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2253.2344, 1596.4844, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2254.1797, 1596.4844, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2259.2188, 1596.4844, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2264.6250, 1596.4844, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2269.6719, 1596.4844, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2274.4063, 1596.4844, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2274.4063, 1589.7891, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2269.6563, 1589.7891, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2264.6094, 1589.7891, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2259.1875, 1589.7969, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2786, 2254.1563, 1589.7969, 1006.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2591, 2178.4922, 1574.8594, 1010.0547, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2185.8281, 1577.1875, 1014.3750, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2170.3203, 1577.1875, 1014.3750, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2151.5625, 1577.1875, 1014.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 2567, 2184.9375, 1578.6953, 1000.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 2567, 2178.1563, 1578.6953, 1000.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 2567, 2169.7188, 1578.6953, 1000.8828, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2199.4453, 1577.1875, 1014.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 2567, 2192.2188, 1578.6953, 1000.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 927, 2195.7031, 1580.4688, 1000.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 2567, 2201.7422, 1580.7266, 1000.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 2591, 2208.9375, 1574.8281, 1010.0547, 0.25);
	RemoveBuildingForPlayer(playerid, 2567, 2209.9297, 1580.7266, 1000.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 927, 2215.0703, 1580.4688, 1000.6719, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2214.8125, 1577.4531, 1014.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 923, 2215.5078, 1576.8594, 999.7734, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2139.1563, 1591.2344, 1014.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 2567, 2184.7031, 1591.2656, 1000.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 923, 2172.4844, 1591.3594, 999.8438, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2193.6328, 1589.5234, 1014.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 922, 2198.8984, 1589.8203, 999.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 2567, 2192.3750, 1591.2656, 1000.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 922, 2204.0391, 1589.8203, 999.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 1221, 2203.9766, 1589.7266, 1000.3594, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2216.5703, 1588.0938, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2216.5781, 1588.5703, 1006.0000, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2184.2578, 1592.8672, 1014.3750, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2202.5078, 1592.8906, 1014.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2216.5703, 1592.3984, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2216.5781, 1592.8750, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 923, 2215.6719, 1593.1953, 999.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 1221, 2179.1719, 1593.5859, 999.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 1221, 2178.1484, 1593.5859, 999.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 1221, 2178.3984, 1593.5859, 1000.3438, 0.25);
	RemoveBuildingForPlayer(playerid, 1220, 2178.1953, 1593.6328, 1001.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 2167.8125, 1596.1641, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 2163, 2160.6016, 1596.1484, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 2162.6250, 1596.2969, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 2008, 2164.8906, 1596.2109, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 2008, 2169.9219, 1596.2109, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 2008, 2163.7969, 1597.2109, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 2008, 2168.8359, 1597.2109, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 2170.8906, 1597.1016, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 2165.8359, 1597.2422, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 2163, 2160.6016, 1597.9219, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 2001, 2173.0781, 1595.9766, 998.9609, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2350, 2195.5547, 1598.4609, 1004.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 923, 2215.6875, 1595.2422, 999.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 2167.6328, 1599.5391, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 2171.8906, 1599.5156, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1998, 2166.2969, 1599.7500, 998.9453, 0.25);
	//RemoveBuildingForPlayer(playerid, 2350, 2191.9844, 1598.5234, 1004.4297, 0.25);
	//RemoveBuildingForPlayer(playerid, 2350, 2190.6406, 1599.2500, 1004.4297, 0.25);
	//RemoveBuildingForPlayer(playerid, 2350, 2197.1484, 1599.1719, 1004.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 2008, 2172.7969, 1600.5078, 998.9531, 0.25);
	//RemoveBuildingForPlayer(playerid, 2350, 2189.4219, 1600.5000, 1004.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 14577, 2204.7891, 1600.4688, 1005.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 14592, 2204.7891, 1600.4688, 1005.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 14601, 2204.7891, 1600.4688, 1005.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 14610, 2204.7891, 1600.4688, 1005.8906, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2350, 2198.3359, 1600.3750, 1004.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 2002, 2161.0859, 1600.7734, 998.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 2001, 2168.0703, 1600.9844, 998.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 1998, 2169.3594, 1601.7422, 998.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 2164.0938, 1601.6719, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 14621, 2204.4766, 1601.9922, 1010.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 1998, 2164.2578, 1602.7813, 998.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 2169.2578, 1602.8047, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1833, 2217.0156, 1602.8125, 1005.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1833, 2217.5469, 1602.7969, 1005.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 14618, 2166.1563, 1603.4766, 1008.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 2011, 2165.6797, 1603.6563, 998.9609, 0.25);
	//RemoveBuildingForPlayer(playerid, 2178, 2179.6875, 1603.7734, 1014.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 2011, 2161.0234, 1603.8359, 998.9609, 0.25);
	//RemoveBuildingForPlayer(playerid, 14582, 2193.9063, 1603.6875, 1007.5469, 0.25);
	//RemoveBuildingForPlayer(playerid, 14611, 2193.8281, 1603.6953, 1007.2656, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2208.4297, 1603.7813, 1014.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 14617, 2216.2734, 1603.5625, 1008.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 2172.0547, 1603.9766, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1998, 2167.3281, 1604.7969, 998.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 2008, 2172.7969, 1604.9141, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 2166.3203, 1604.8281, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 2167, 2160.5859, 1605.3906, 998.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 927, 2145.2734, 1605.8672, 1001.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 2670, 2200.2500, 1605.4844, 1000.2500, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2217.0234, 1603.9297, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1835, 2217.0156, 1605.0469, 1005.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 2592, 2217.0313, 1603.9219, 1006.0781, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2217.5469, 1603.8984, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 2592, 2217.5469, 1603.9141, 1006.0781, 0.25);
	RemoveBuildingForPlayer(playerid, 1834, 2217.5469, 1605.0391, 1005.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 2167, 2160.5859, 1606.3359, 998.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 2008, 2169.9219, 1606.8828, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 2008, 2164.8906, 1606.8828, 998.9531, 0.25);
	//RemoveBuildingForPlayer(playerid, 2350, 2198.3281, 1606.8984, 1004.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 1775, 2155.9063, 1606.7734, 1000.0547, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 2167.8750, 1606.9297, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 2162.8281, 1606.9297, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 2167, 2173.3203, 1607.0859, 998.9609, 0.25);
	//RemoveBuildingForPlayer(playerid, 2350, 2189.4375, 1606.9844, 1004.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 2002, 2198.9297, 1607.0859, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1775, 2209.9063, 1607.1953, 1000.0547, 0.25);
	RemoveBuildingForPlayer(playerid, 2163, 2160.6016, 1607.2813, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 2008, 2163.7969, 1607.8906, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1776, 2155.8438, 1607.8750, 1000.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 2008, 2168.8359, 1607.8906, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 2165.8750, 1607.8438, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 2170.8828, 1607.6016, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 2167, 2173.3203, 1608.0234, 998.9609, 0.25);
	//RemoveBuildingForPlayer(playerid, 2350, 2190.6250, 1608.2031, 1004.4297, 0.25);
	//RemoveBuildingForPlayer(playerid, 2350, 2195.6641, 1608.9375, 1004.4297, 0.25);
	//RemoveBuildingForPlayer(playerid, 2350, 2192.2266, 1608.9063, 1004.4297, 0.25);
	//RemoveBuildingForPlayer(playerid, 2178, 2139.1563, 1609.3750, 1014.3750, 0.25);
	//RemoveBuildingForPlayer(playerid, 2350, 2197.1172, 1608.1563, 1004.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2197.3047, 1609.2266, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2198.5078, 1609.2344, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2201.8125, 1609.2109, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1737, 2201.9297, 1610.1328, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1737, 2197.4219, 1610.1563, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2203.0156, 1609.2109, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1737, 2208.3516, 1610.1328, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2208.2344, 1609.2266, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2209.4375, 1609.2266, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2197.2813, 1610.6016, 999.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 14636, 2172.1250, 1611.3125, 1000.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2197.2422, 1613.1250, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 14578, 2148.3438, 1613.2422, 1003.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 14635, 2140.5781, 1614.0000, 1002.0781, 0.25);
	RemoveBuildingForPlayer(playerid, 1737, 2197.3594, 1614.0469, 998.9531, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2184.2578, 1614.6406, 1014.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2197.2500, 1614.9297, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2198.5078, 1611.0703, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2203.0156, 1611.0391, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2201.8125, 1611.0391, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2198.4453, 1613.1250, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2201.8203, 1613.0313, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2203.0156, 1612.9922, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1737, 2201.9297, 1613.9141, 998.9531, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2202.5313, 1614.6250, 1014.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2198.4531, 1614.9609, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2201.8203, 1614.7656, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2203.0234, 1614.8203, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2209.4609, 1613.0000, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2209.4375, 1611.0547, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2208.2578, 1613.0000, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2208.2344, 1611.0547, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1737, 2208.3750, 1613.9141, 998.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2209.4609, 1614.8359, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2208.2656, 1614.8359, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2216.5703, 1614.2422, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2216.5781, 1614.7188, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1733, 2184.3047, 1616.1250, 999.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 1733, 2179.6172, 1616.1250, 999.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 14583, 2181.8828, 1618.7344, 1000.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 14576, 2144.1797, 1619.4063, 1000.7578, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2151.8438, 1621.3281, 1014.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 927, 2145.0703, 1620.9688, 1001.8203, 0.25);
	RemoveBuildingForPlayer(playerid, 1733, 2180.6719, 1621.8984, 999.4375, 0.25);
	RemoveBuildingForPlayer(playerid, 2800, 2169.8984, 1625.6172, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 2799, 2169.8984, 1625.6172, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 2800, 2186.0391, 1625.6328, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 2799, 2186.0391, 1625.6328, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 2800, 2178.5859, 1625.6328, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 2799, 2178.5859, 1625.6328, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 14581, 2184.5703, 1626.5156, 1044.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 14638, 2187.4297, 1627.3125, 1042.4063, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2186.7109, 1627.8672, 1014.3828, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2170.2266, 1627.8906, 1014.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 2591, 2178.1094, 1630.7500, 1010.0547, 0.25);
	RemoveBuildingForPlayer(playerid, 1776, 2202.4531, 1617.0078, 1000.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2198.7969, 1617.0000, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2197.8906, 1617.0000, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2203.1875, 1617.0000, 999.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 2670, 2203.1563, 1617.0625, 999.0625, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2194.0391, 1617.9219, 1014.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 2800, 2200.9453, 1625.6328, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 2799, 2200.9453, 1625.6328, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 2800, 2193.5078, 1625.6484, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 2799, 2193.5078, 1625.6484, 1007.8672, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2199.7188, 1627.8672, 1014.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 2681, 2206.7266, 1615.7734, 998.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 1776, 2209.2422, 1621.2109, 1000.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 2002, 2211.0000, 1621.1094, 998.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 2800, 2211.9141, 1625.6328, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 2799, 2211.9141, 1625.6328, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 2800, 2206.9297, 1625.6172, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 2799, 2206.9297, 1625.6172, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 2591, 2209.8281, 1630.7656, 1010.0547, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2214.8125, 1627.8672, 1014.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2216.5703, 1618.5781, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2216.5781, 1619.0547, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2800, 2216.9375, 1625.6172, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 2799, 2216.9375, 1625.6172, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 927, 2227.0938, 1572.8594, 1000.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 2567, 2227.1563, 1575.5000, 1000.8828, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2230.4531, 1577.4531, 1014.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 2567, 2228.5781, 1583.5703, 1000.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 2567, 2232.6875, 1575.1641, 1000.8828, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2241.2031, 1562.9141, 1014.3828, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2241.2031, 1577.4531, 1014.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2220.7188, 1588.0938, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2218.6328, 1588.0781, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2218.6641, 1588.6016, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2220.6953, 1588.5703, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2784, 2218.6172, 1588.3359, 1006.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 2567, 2228.5781, 1589.4297, 1000.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1978, 2230.5703, 1589.1875, 1006.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1978, 2242.3672, 1589.1875, 1006.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2218.6328, 1592.3828, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2218.6641, 1592.9063, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 2784, 2218.6172, 1592.6406, 1006.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2220.7188, 1592.3984, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2220.6953, 1592.8750, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1978, 2230.5703, 1594.7578, 1006.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1978, 2242.3672, 1594.7578, 1006.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 2567, 2232.6797, 1595.4219, 1000.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 2567, 2219.0391, 1596.6641, 1000.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1833, 2220.6719, 1602.8125, 1005.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1833, 2221.2031, 1602.7969, 1005.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 2002, 2222.4688, 1601.7969, 998.9609, 0.25);
	RemoveBuildingForPlayer(playerid, 1776, 2222.3672, 1602.6406, 1000.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 2188, 2230.3750, 1602.7500, 1006.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 2188, 2241.3125, 1602.7500, 1006.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2220.6797, 1603.9297, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2221.2031, 1603.8984, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 2592, 2220.6875, 1603.9219, 1006.0781, 0.25);
	RemoveBuildingForPlayer(playerid, 2592, 2221.2031, 1603.9141, 1006.0781, 0.25);
	RemoveBuildingForPlayer(playerid, 14616, 2241.2109, 1603.5625, 1008.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 14626, 2236.1016, 1603.8750, 1013.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 2188, 2243.1250, 1604.4375, 1006.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 2188, 2232.1875, 1604.4375, 1006.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 2188, 2239.4297, 1604.4531, 1006.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 2188, 2228.4922, 1604.4531, 1006.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1834, 2221.2031, 1605.0391, 1005.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1835, 2220.6719, 1605.0469, 1005.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1775, 2222.2031, 1606.7734, 1000.0547, 0.25);
	RemoveBuildingForPlayer(playerid, 2670, 2222.3906, 1606.9063, 999.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 2188, 2241.3125, 1606.2734, 1006.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 2188, 2230.3750, 1606.2734, 1006.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2222.3203, 1610.2578, 999.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 2670, 2221.7656, 1611.0547, 999.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2222.3203, 1611.0234, 999.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 14629, 2241.2734, 1611.3750, 1016.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2219.0469, 1613.0156, 999.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2218.6328, 1614.2266, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1811, 2219.0469, 1613.9844, 999.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2220.7188, 1614.2422, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2784, 2218.6172, 1614.4844, 1006.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2218.6641, 1614.7500, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2220.6953, 1614.7188, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1978, 2230.5703, 1614.5938, 1006.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1978, 2241.4453, 1614.5547, 1006.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2220.7188, 1618.5781, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2218.6328, 1618.5625, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2218.6641, 1619.0859, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2220.6953, 1619.0547, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2784, 2218.6172, 1618.8203, 1006.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 2799, 2221.9219, 1625.6328, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 2800, 2221.9219, 1625.6328, 1007.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 1978, 2230.5703, 1619.6563, 1006.2266, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2230.4531, 1627.8672, 1014.3828, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2241.2031, 1627.8672, 1014.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1978, 2241.4453, 1619.6094, 1006.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 14579, 2222.9844, 1688.4766, 1008.8359, 0.25);
	RemoveBuildingForPlayer(playerid, 14609, 2222.9531, 1689.5781, 1008.8359, 0.25);
	RemoveBuildingForPlayer(playerid, 1557, 2232.4375, 1715.1094, 1011.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 14630, 2233.9688, 1716.8828, 1012.9766, 0.25);
	RemoveBuildingForPlayer(playerid, 1557, 2235.4609, 1715.1094, 1011.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 14580, 2235.8906, 1647.9844, 1010.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 14622, 2235.8984, 1703.7969, 1014.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 14628, 2235.8984, 1697.0469, 1014.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1895, 2252.0313, 1584.4219, 1007.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 1895, 2261.6328, 1584.4297, 1007.1094, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2263.2500, 1562.9141, 1014.3828, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2263.2500, 1577.4531, 1014.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 14642, 2262.7031, 1603.5000, 1013.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2253.1250, 1609.6406, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2255.1563, 1609.6016, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2257.2422, 1609.6406, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2784, 2255.2109, 1609.8750, 1006.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2253.1016, 1610.1172, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2257.2500, 1610.1172, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2255.1875, 1610.1250, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2253.1016, 1614.1641, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2253.1250, 1613.6875, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2255.1563, 1613.6484, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2257.2500, 1614.1641, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2257.2422, 1613.6875, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2255.1875, 1614.1719, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 2784, 2255.2109, 1613.9141, 1006.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2253.1250, 1617.5781, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2257.2422, 1617.5781, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2255.1563, 1617.5469, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 2784, 2255.2109, 1617.8125, 1006.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2253.1016, 1618.0547, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2257.2500, 1618.0547, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2255.1875, 1618.0703, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1497, 2263.9766, 1618.7734, 1089.4297, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2263.2500, 1627.8672, 1014.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 1497, 2263.9688, 1675.0313, 1089.4297, 0.25);
	RemoveBuildingForPlayer(playerid, 14591, 2265.9922, 1647.7031, 1088.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 14590, 2266.0078, 1647.7031, 1088.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 2802, 2270.2578, 1560.4141, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2801, 2270.2578, 1560.4141, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2802, 2270.2578, 1566.1484, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2801, 2270.2578, 1566.1484, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2802, 2270.2578, 1569.0859, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2801, 2270.2578, 1569.0859, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2801, 2270.2578, 1575.5234, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2802, 2270.2578, 1575.5234, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 1895, 2271.7266, 1584.4219, 1007.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2269.2578, 1604.5938, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2269.7344, 1604.6172, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2269.7734, 1606.6484, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2269.2578, 1608.7422, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2269.2500, 1606.6797, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2269.7344, 1608.7344, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2784, 2269.5078, 1606.7031, 1006.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 2074, 2266.8750, 1619.6172, 1093.1953, 0.25);
	RemoveBuildingForPlayer(playerid, 2801, 2273.4531, 1560.3984, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2802, 2273.4531, 1560.3984, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2802, 2273.4531, 1566.1328, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2801, 2273.4531, 1566.1328, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2801, 2273.4531, 1569.0781, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2802, 2273.4531, 1569.0781, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2802, 2273.4531, 1575.5078, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2801, 2273.4531, 1575.5078, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2273.2969, 1606.6797, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2273.3047, 1604.5938, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1837, 2273.3047, 1608.7422, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2784, 2273.5469, 1606.7031, 1006.4922, 0.25);
	RemoveBuildingForPlayer(playerid, 2325, 2273.8203, 1606.6484, 1006.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2273.7813, 1604.6172, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 1836, 2273.7813, 1608.7344, 1006.0000, 0.25);
	RemoveBuildingForPlayer(playerid, 2802, 2276.5234, 1560.3828, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2801, 2276.5234, 1560.3828, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2802, 2276.5234, 1569.0547, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2801, 2276.5234, 1569.0547, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2802, 2276.5234, 1566.1094, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2801, 2276.5234, 1566.1094, 1007.6953, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2278.2656, 1577.4531, 1014.3828, 0.25);
	RemoveBuildingForPlayer(playerid, 2802, 2276.5234, 1575.4844, 1007.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 2801, 2276.5234, 1575.4844, 1007.6953, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2278.2656, 1627.8672, 1014.3828, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2286.6484, 1604.8516, 1014.3750, 0.25);
	//	RemoveBuildingForPlayer(playerid, 2178, 2286.6484, 1585.3203, 1014.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 3286, 2042.1953, -1986.0859, 38.3281, 0.25);
	RemoveBuildingForPlayer(playerid, 8593, 2527.312, 1185.343, 20.710, 0.250);
	RemoveBuildingForPlayer(playerid, 9172, 2637.656, 1103.000, 12.921, 0.250);
	RemoveBuildingForPlayer(playerid, 3459, 2577.109, 1003.515, 17.320, 0.250);
	RemoveBuildingForPlayer(playerid, 3459, 2615.632, 1035.703, 17.320, 0.250);
	RemoveBuildingForPlayer(playerid, 8608, 2560.070, 1195.179, 23.453, 0.250);
	RemoveBuildingForPlayer(playerid, 3459, 2617.140, 1104.265, 17.320, 0.250);
	RemoveBuildingForPlayer(playerid, 9193, 2619.296, 1082.312, 15.054, 0.250);
	RemoveBuildingForPlayer(playerid, 3447, 2618.273, 1152.382, 17.320, 0.250);
	RemoveBuildingForPlayer(playerid, 3465, 2634.640, 1100.945, 11.250, 0.250);
	RemoveBuildingForPlayer(playerid, 3465, 2639.875, 1100.960, 11.250, 0.250);
	RemoveBuildingForPlayer(playerid, 3465, 2645.250, 1100.960, 11.250, 0.250);
	RemoveBuildingForPlayer(playerid, 9171, 2637.656, 1103.000, 12.921, 0.250);
	RemoveBuildingForPlayer(playerid, 3465, 2639.875, 1111.750, 11.250, 0.250);
	RemoveBuildingForPlayer(playerid, 3465, 2634.640, 1111.750, 11.250, 0.250);
	RemoveBuildingForPlayer(playerid, 3465, 2645.250, 1111.750, 11.250, 0.250);
	RemoveBuildingForPlayer(playerid, 956, 2647.695, 1129.664, 10.218, 0.250);
	RemoveBuildingForPlayer(playerid, 3447, 2635.757, 1152.382, 17.320, 0.250);
	RemoveBuildingForPlayer(playerid, 3447, 2653.406, 1152.382, 17.320, 0.250);
	RemoveBuildingForPlayer(playerid, 3447, 2670.882, 1152.382, 17.320, 0.250);
	RemoveBuildingForPlayer(playerid, 955, 2325.9766, -1645.1328, 14.2109, 2800);//???????? ? ????

	RemoveBuildingForPlayer(playerid, 1524, 1959.3984, -1577.7578, 13.7578, 20.0);
	RemoveBuildingForPlayer(playerid, 5516, 1977.8359, -1569.0469, 19.0703, 0.25);
	RemoveBuildingForPlayer(playerid, 5630, 1928.4922, -1575.9688, 20.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 5475, 1977.8359, -1569.0469, 19.0703, 0.25);
	RemoveBuildingForPlayer(playerid, 13298, 207.804, -249.148, 7.093, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 192.812, -263.843, 1.812, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 195.460, -271.820, 1.851, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 200.742, -271.820, 1.851, 0.250);
	RemoveBuildingForPlayer(playerid, 781, 196.773, -267.601, 0.453, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 192.906, -269.125, 1.843, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 209.570, -271.835, 1.851, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 222.789, -263.851, 1.851, 0.250);
	RemoveBuildingForPlayer(playerid, 1294, 223.921, -272.992, 5.031, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 214.843, -271.820, 1.851, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 220.125, -271.796, 1.851, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 222.804, -269.125, 1.851, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 192.812, -254.804, 1.828, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 222.796, -253.296, 1.851, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 222.796, -258.570, 1.851, 0.250);
	RemoveBuildingForPlayer(playerid, 13295, 207.804, -249.148, 7.093, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 192.812, -249.531, 1.828, 0.250);
	RemoveBuildingForPlayer(playerid, 1294, 191.132, -246.898, 5.031, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 222.781, -248.023, 1.851, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 192.812, -244.250, 1.828, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 192.914, -238.976, 1.820, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 222.804, -238.945, 1.851, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 215.000, -224.000, 2.023, 0.250);
	RemoveBuildingForPlayer(playerid, 1226, 327.2188, -1208.0703, 85.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 3244, 2758.4297, -2124.8594, 10.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 5256, 2768.4453, -2012.0938, 14.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 2739.9844, -2089.0547, 18.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 2739.9844, -2119.7891, 17.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 2768.0469, -2104.4844, 17.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 2794.8047, -2074.5156, 17.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 3683, 2766.5234, -2074.5156, 18.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 708, 2798.0547, -1993.2734, 12.3047, 0.25);
	RemoveBuildingForPlayer(playerid, 1528, 2763.0000, -2012.1094, 14.1328, 0.25);
	RemoveBuildingForPlayer(playerid, 1413, 2724.7813, -2062.0078, 13.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 1532, 2724.8594, -2025.7969, 12.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 2739.9844, -2119.7891, 17.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 2739.9844, -2089.0547, 18.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 2766.5234, -2074.5156, 18.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 2768.0469, -2104.4844, 17.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 2794.8047, -2074.5156, 17.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 946, 2768.1563, -2019.6172, 14.6016, 0.25);
	RemoveBuildingForPlayer(playerid, 5302, 2741.0703, -2004.7813, 14.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 5173, 2768.4453, -2012.0938, 14.7969, 0.25);
	RemoveBuildingForPlayer(playerid, 5358, 2783.0000, -2023.3203, 13.9297, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2792.1797, -2003.7266, 13.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 946, 2795.4922, -2019.6172, 14.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2802.8203, -2008.7734, 13.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2802.7266, -2003.4922, 13.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 5234, 2786.7734, -1970.0625, 20.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2794.7188, -2001.0313, 13.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 2800.0000, -2000.8906, 13.7500, 0.25);
	RemoveBuildingForPlayer(playerid, 671, 2808.9766, -2033.6094, 12.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 712, 2809.4531, -2017.9141, 21.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2806.5781, -2007.6953, 9.6719, 0.25);

	RemoveBuildingForPlayer(playerid, 1438, 670.1094, -550.6563, 15.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1451.6250, -1727.6719, 16.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1467.9844, -1727.6719, 16.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1485.1719, -1727.6719, 16.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1505.1797, -1727.6719, 16.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 3778, 337.453, -1875.000, 3.406, 0.250);
	RemoveBuildingForPlayer(playerid, 3615, 337.453, -1875.000, 3.406, 0.250);


	RemoveBuildingForPlayer(playerid, 13063, 321.851, -34.523, 4.898, 0.250);
	RemoveBuildingForPlayer(playerid, 13061, 321.851, -34.523, 4.898, 0.250);

	RemoveBuildingForPlayer(playerid, 1721, 1489.7656, 1306.0234, 1092.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 1721, 1491.1719, 1307.8906, 1092.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 3686, 2288.2656, -2342.0703, 15.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2359.4766, -2325.1484, 15.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 3627, 2288.2656, -2342.0703, 15.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 1306, 2343.9531, -2338.6406, 19.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 5323, 2336.4688, -2322.3984, 21.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2359.4766, -2325.1484, 15.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 3578, 2375.0000, -2300.4141, 13.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 1306, 2395.2344, -2290.0234, 19.1484, 0.25);
	RemoveBuildingForPlayer(playerid, 13192, 164.7109, -234.1875, 0.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 13193, 173.5156, -323.8203, 0.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 13194, 140.5938, -305.3906, 5.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 13195, 36.8281, -256.2266, 0.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 1431, 36.4297, -291.0625, 1.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, 29.2344, -286.0547, 1.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, 32.4063, -289.2188, 1.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 1438, 33.6016, -279.3516, 1.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 12861, 36.8281, -256.2266, 0.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 1450, 43.4844, -252.5703, 1.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 1449, 43.1094, -254.9609, 1.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 12859, 173.5156, -323.8203, 0.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 13198, 140.5938, -305.3906, 5.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 12956, 96.3281, -261.1953, 3.8594, 0.25);
	RemoveBuildingForPlayer(playerid, 12860, 164.7109, -234.1875, 0.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 5325, 2488.9922, -2509.2578, 18.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 3769, 2464.1250, -2571.6328, 15.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 3578, 2470.1406, -2628.2656, 13.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1306, 2469.6016, -2579.9844, 19.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 3625, 2464.1250, -2571.6328, 15.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 1306, 2498.3438, -2612.6563, 19.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2179.9219, -2334.8516, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2165.2969, -2317.5000, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 5305, 2198.8516, -2213.9219, 14.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2234.3906, -2244.8281, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2226.9688, -2252.1406, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2219.4219, -2259.5234, 14.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2212.0938, -2267.0703, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3747, 2204.6328, -2274.4141, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2179.9219, -2334.8516, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2165.2969, -2317.5000, 14.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 3578, 2165.0703, -2288.9688, 13.2578, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2204.6328, -2274.4141, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2212.0938, -2267.0703, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2219.4219, -2259.5234, 14.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 2217.2188, -2250.3594, 16.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2226.9688, -2252.1406, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 3569, 2234.3906, -2244.8281, 14.9375, 0.25);
	RemoveBuildingForPlayer(playerid, 5244, 2198.8516, -2213.9219, 14.8828, 0.25);

	RemoveBuildingForPlayer(playerid, 3689, 2685.3828, -2366.0547, 19.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 3690, 2685.3828, -2366.0547, 19.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2771.0703, -2372.4453, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2789.2109, -2377.6250, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2774.7969, -2386.8516, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3746, 2814.2656, -2356.5703, 25.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, 2626.2344, -2391.5234, 26.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 5326, 2661.5156, -2465.1406, 20.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 3578, 2639.1953, -2392.8203, 13.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 3578, 2663.8359, -2392.8203, 13.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 2637.1719, -2385.8672, 16.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 1306, 2669.9063, -2394.5078, 19.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 2692.6797, -2387.4766, 16.4141, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, 2708.4063, -2391.5234, 26.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2783.7813, -2501.8359, 14.6953, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2783.7813, -2486.9609, 14.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2783.7813, -2463.8203, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2783.7813, -2448.4766, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2783.7813, -2425.3516, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2774.7969, -2386.8516, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2771.0703, -2372.4453, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2783.7813, -2410.2109, 14.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2789.2109, -2377.6250, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, 2802.4297, -2556.5234, 26.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2791.9531, -2501.8359, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2797.5156, -2486.8281, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2791.9531, -2486.9609, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2791.9531, -2463.8203, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2797.5156, -2448.3438, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2791.9531, -2448.4766, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2791.9531, -2425.3516, 14.6719, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2791.9531, -2410.2109, 14.6563, 0.25);
	RemoveBuildingForPlayer(playerid, 3761, 2797.5156, -2410.0781, 14.6328, 0.25);
	RemoveBuildingForPlayer(playerid, 3620, 2814.2656, -2356.5703, 25.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 3744, 2771.0703, -2520.5469, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 3574, 2771.0703, -2520.5469, 15.2188, 0.25);
	RemoveBuildingForPlayer(playerid, 5313, 2043.9922, -2016.8672, 25.0547, 0.25);
	RemoveBuildingForPlayer(playerid, 5316, 2043.9922, -2016.8672, 25.0547, 0.25);
	RemoveBuildingForPlayer(playerid, 5346, 2016.3125, -1968.9219, 17.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 5312, 2068.9609, -2013.4766, 24.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 3567, 2008.6250, -1974.5469, 15.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 5152, 1997.7656, -1974.4688, 14.8750, 0.25);
	RemoveBuildingForPlayer(playerid, 5169, 2016.3125, -1968.9219, 17.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1307, 937.9375, -986.5391, 37.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 3769, 1961.4453, -2216.1719, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 3664, 1960.6953, -2236.4297, 19.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1965.1719, -2227.4141, 13.7578, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1959.8984, -2227.4453, 13.7266, 0.25);
	RemoveBuildingForPlayer(playerid, 3625, 1961.4453, -2216.1719, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1774.7578, -1901.5391, 16.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 14879, 308.3203, 305.9141, 1002.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 14878, 302.2422, 312.7578, 998.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 14879, 308.3203, 305.9141, 1002.6172, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 700.4063, -1581.7344, 16.4063, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 703.1641, -1567.9141, 16.2656, 0.25);
	RemoveBuildingForPlayer(playerid, 13133, 299.2031, -193.6250, 3.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 13203, 308.0938, -168.7266, 4.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 291.1563, -171.5000, 5.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 13190, 308.0938, -168.7266, 4.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1495, 293.7500, -194.6875, 0.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 13132, 299.2031, -193.6250, 3.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 1687, 303.9375, -194.9297, 4.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1691, 297.1016, -195.6094, 4.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, 312.6406, -199.8750, 1.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, 305.1328, -188.5625, 1.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 4044, 1481.187, -1785.070, 22.382, 0.250);
	RemoveBuildingForPlayer(playerid, 3980, 1481.187, -1785.070, 22.382, 0.250);

	RemoveBuildingForPlayer(playerid, 3425, -466.429, 2190.273, 55.992, 0.250);
	RemoveBuildingForPlayer(playerid, 16054, -427.773, 2238.257, 44.796, 0.250);
	RemoveBuildingForPlayer(playerid, 3350, -429.054, 2237.835, 41.210, 0.250);
	RemoveBuildingForPlayer(playerid, 16052, -338.789, 2218.296, 43.062, 0.250);
	RemoveBuildingForPlayer(playerid, 16629, -337.914, 2215.226, 42.015, 0.250);
	RemoveBuildingForPlayer(playerid, 16630, -341.453, 2225.500, 42.015, 0.250);
	RemoveBuildingForPlayer(playerid, 16635, -339.687, 2221.125, 42.015, 0.250);
	RemoveBuildingForPlayer(playerid, 16636, -340.125, 2228.125, 42.007, 0.250);
	RemoveBuildingForPlayer(playerid, 16628, -331.117, 2211.484, 42.382, 0.250);
	RemoveBuildingForPlayer(playerid, 16631, -335.523, 2229.609, 42.007, 0.250);
	RemoveBuildingForPlayer(playerid, 16634, -336.296, 2211.507, 41.968, 0.250);
	RemoveBuildingForPlayer(playerid, 16410, -327.492, 2218.484, 43.320, 0.250);
	RemoveBuildingForPlayer(playerid, 16627, -322.898, 2214.820, 44.343, 0.250);
	RemoveBuildingForPlayer(playerid, 16632, -329.796, 2231.687, 42.421, 0.250);
	RemoveBuildingForPlayer(playerid, 16633, -327.265, 2213.062, 43.062, 0.250);
	//CTO LV
	RemoveBuildingForPlayer(playerid, 8071, 1667.476, 723.085, 10.937, 0.250);
	RemoveBuildingForPlayer(playerid, 8087, 1667.742, 723.226, 21.093, 0.250);
	RemoveBuildingForPlayer(playerid, 8106, 1667.476, 723.085, 10.937, 0.250);
	RemoveBuildingForPlayer(playerid, 8113, 1665.171, 687.046, 14.390, 0.250);
	RemoveBuildingForPlayer(playerid, 8114, 1634.718, 772.843, 13.820, 0.250);
	RemoveBuildingForPlayer(playerid, 8115, 1695.492, 673.218, 13.820, 0.250);
	RemoveBuildingForPlayer(playerid, 8159, 1665.562, 753.828, 14.390, 0.250);
	RemoveBuildingForPlayer(playerid, 8254, 1665.171, 687.046, 14.390, 0.250);
	RemoveBuildingForPlayer(playerid, 8255, 1665.562, 753.828, 14.390, 0.250);
	RemoveBuildingForPlayer(playerid, 659, 1579.929, 695.078, 8.765, 0.250);
	RemoveBuildingForPlayer(playerid, 1215, 1577.835, 708.015, 10.156, 0.250);
	RemoveBuildingForPlayer(playerid, 1215, 1577.835, 718.523, 10.156, 0.250);
	RemoveBuildingForPlayer(playerid, 1215, 1579.835, 718.523, 10.156, 0.250);
	RemoveBuildingForPlayer(playerid, 1215, 1579.835, 708.015, 10.156, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1589.914, 671.945, 10.062, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1589.914, 669.117, 10.062, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1589.914, 674.843, 10.062, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1589.914, 677.664, 10.062, 0.250);
	RemoveBuildingForPlayer(playerid, 1421, 1620.632, 703.968, 10.500, 0.250);
	RemoveBuildingForPlayer(playerid, 676, 1579.093, 733.562, 10.070, 0.250);
	RemoveBuildingForPlayer(playerid, 673, 1579.742, 729.007, 8.226, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 1580.039, 783.250, 11.093, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 1585.320, 783.250, 11.093, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 1590.593, 783.250, 11.093, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 1595.867, 783.250, 11.093, 0.250);
	RemoveBuildingForPlayer(playerid, 3459, 1577.859, 786.195, 17.242, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 1601.148, 783.250, 11.093, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 1606.421, 783.250, 11.093, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 1611.703, 783.250, 11.093, 0.250);
	RemoveBuildingForPlayer(playerid, 1412, 1616.976, 783.250, 11.093, 0.250);
	RemoveBuildingForPlayer(playerid, 8310, 1624.789, 818.960, 27.312, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1648.546, 674.843, 10.062, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1648.546, 671.945, 10.062, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1648.546, 669.117, 10.062, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1648.546, 677.664, 10.062, 0.250);
	RemoveBuildingForPlayer(playerid, 1358, 1679.695, 767.429, 11.007, 0.250);
	RemoveBuildingForPlayer(playerid, 8078, 1634.718, 772.843, 13.820, 0.250);
	RemoveBuildingForPlayer(playerid, 1335, 1651.054, 774.804, 10.945, 0.250);
	RemoveBuildingForPlayer(playerid, 8077, 1695.492, 673.218, 13.820, 0.250);
	RemoveBuildingForPlayer(playerid, 3459, 1683.796, 784.203, 16.648, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1709.054, 744.429, 10.914, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1709.054, 745.617, 10.468, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1709.054, 744.375, 10.062, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1709.187, 745.492, 11.359, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1709.054, 742.718, 10.468, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1709.054, 741.546, 10.062, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1709.054, 747.078, 10.914, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1709.054, 747.273, 10.062, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1709.054, 748.437, 10.468, 0.250);
	RemoveBuildingForPlayer(playerid, 1219, 1709.054, 750.093, 10.062, 0.250);
	RemoveBuildingForPlayer(playerid, 736, 1679.382, 804.335, 18.476, 0.250);
	RemoveBuildingForPlayer(playerid, 736, 1689.234, 804.335, 19.703, 0.250);
	RemoveBuildingForPlayer(playerid, 736, 1706.671, 804.335, 20.992, 0.250);
	RemoveBuildingForPlayer(playerid, 736, 1698.398, 804.335, 19.703, 0.250);
	RemoveBuildingForPlayer(playerid, 1503, 1749.710, 776.437, 10.210, 0.250);
	RemoveBuildingForPlayer(playerid, 1440, 1754.593, 677.625, 10.210, 0.250);
	RemoveBuildingForPlayer(playerid, 1440, 1756.421, 678.960, 10.210, 0.250);
	return 1;
}*/

function loadMaps() {
	// new tmpobjid; 
	// #include army_lv
	// #include avtoscool
	// #include fbi
	// #include hotel_casino
	// #include map
	// #include map1
	// #include map2
	// #include map3
	// #include map4
	// #include ostalnoe
	// #include pirs
	// #include Redisson

	/*new drink;
	drink = CreateDynamicObjectEx(19377,1409.747,-1483.513,124.305,0.000,90.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 18031, "cj_exp", "mp_furn_floor", 0x00000000);
	drink = CreateDynamicObjectEx(19089,1405.980,-1488.348,127.307,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1413.444,-1488.351,127.307,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1413.446,-1488.352,127.279,0.000,90.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1413.365,-1488.342,127.278,0.000,90.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19087,1408.470,-1488.352,126.894,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19087,1408.470,-1488.352,124.453,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19087,1410.906,-1488.358,126.894,0.000,90.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19087,1410.886,-1488.362,126.894,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19087,1409.636,-1488.361,126.894,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19430,1414.252,-1488.308,126.052,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
	drink = CreateDynamicObjectEx(19430,1405.163,-1488.312,126.052,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
	drink = CreateDynamicObjectEx(19376,1409.767,-1486.196,124.304,0.000,90.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 9514, "711_sfw", "mono2_sfe", 0x00000000);
	drink = CreateDynamicObjectEx(19089,1411.853,-1491.014,125.320,0.000,90.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1404.510,-1483.656,124.835,0.000,90.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1415.056,-1491.018,125.320,0.000,90.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1404.526,-1491.016,125.329,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1415.015,-1491.018,125.329,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1415.045,-1483.657,125.326,0.000,90.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1415.045,-1483.657,124.835,0.000,90.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1415.056,-1491.018,124.835,0.000,90.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1411.853,-1491.014,124.835,0.000,90.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1404.510,-1483.656,125.320,0.000,90.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19449,1415.051,-1483.539,126.066,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
	drink = CreateDynamicObjectEx(19449,1409.871,-1488.320,129.039,180.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
	drink = CreateDynamicObjectEx(19087,1410.886,-1488.362,124.453,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19449,1404.483,-1483.487,126.066,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
	drink = CreateDynamicObjectEx(19356,1404.487,-1484.136,125.344,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF808080);
	drink = CreateDynamicObjectEx(2256,1404.590,-1484.593,126.151,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	SetDynamicObjectMaterial(drink, 1, -1, "none", "none", 0xFF000000);
	drink = CreateDynamicObjectEx(19450,1415.049,-1483.547,122.850,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1414.950,-1488.203,127.877,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19450,1418.255,-1488.300,122.850,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19450,1408.669,-1488.303,122.652,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19450,1401.163,-1488.311,122.850,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1404.578,-1488.220,127.877,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19450,1404.489,-1483.389,122.850,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1404.570,-1485.750,127.097,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1404.570,-1482.526,127.129,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19087,1404.577,-1483.294,127.093,0.000,90.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19087,1404.571,-1482.514,127.093,0.000,90.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(2291,1405.658,-1482.307,124.388,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 4828, "airport3_las", "gnhotelwall02_128", 0x00000000);
	drink = CreateDynamicObjectEx(2291,1406.598,-1482.293,124.388,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 4828, "airport3_las", "gnhotelwall02_128", 0x00000000);
	drink = CreateDynamicObjectEx(2292,1408.038,-1482.273,124.391,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 4828, "airport3_las", "gnhotelwall02_128", 0x00000000);
	drink = CreateDynamicObjectEx(2291,1408.017,-1482.757,124.388,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 4828, "airport3_las", "gnhotelwall02_128", 0x00000000);
	drink = CreateDynamicObjectEx(2291,1408.014,-1483.743,124.388,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 4828, "airport3_las", "gnhotelwall02_128", 0x00000000);
	drink = CreateDynamicObjectEx(2292,1408.031,-1485.212,124.388,0.000,0.000,-180.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 4828, "airport3_las", "gnhotelwall02_128", 0x00000000);
	drink = CreateDynamicObjectEx(1746,1407.061,-1485.234,124.393,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 4828, "airport3_las", "gnhotelwall02_128", 0x00000000);
	drink = CreateDynamicObjectEx(1823,1407.184,-1484.303,124.314,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 14650, "ab_trukstpc", "mp_CJ_WOOD5", 0xFF808080);
	drink = CreateDynamicObjectEx(1563,1406.659,-1482.251,125.028,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 4828, "airport3_las", "gnhotelwall02_128", 0xFF000000);
	SetDynamicObjectMaterial(drink, 1, 4828, "airport3_las", "gnhotelwall02_128", 0x00000000);
	drink = CreateDynamicObjectEx(1563,1408.055,-1485.207,125.028,47.000,0.000,40.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 4828, "airport3_las", "gnhotelwall02_128", 0xFF000000);
	SetDynamicObjectMaterial(drink, 1, 4828, "airport3_las", "gnhotelwall02_128", 0x00000000);
	drink = CreateDynamicObjectEx(2256,1404.591,-1483.682,126.151,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	SetDynamicObjectMaterial(drink, 1, -1, "none", "none", 0xFF000000);
	drink = CreateDynamicObjectEx(19449,1403.630,-1481.516,126.066,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
	drink = CreateDynamicObjectEx(19449,1407.032,-1476.668,126.066,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
	drink = CreateDynamicObjectEx(19450,1405.713,-1476.457,122.850,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19450,1407.050,-1476.779,122.850,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1404.583,-1481.633,127.877,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1408.445,-1481.596,127.877,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19377,1409.816,-1473.933,124.306,0.000,90.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 18031, "cj_exp", "mp_furn_floor", 0x00000000);
	drink = CreateDynamicObjectEx(19449,1415.064,-1474.231,126.066,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
	drink = CreateDynamicObjectEx(19450,1415.044,-1475.495,122.850,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19450,1403.664,-1481.492,122.850,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1408.448,-1481.436,127.877,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1407.140,-1481.410,127.877,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(2137,1407.609,-1479.989,124.396,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 4604, "buildblk555", "gm_labuld5_b", 0x00000000);
	SetDynamicObjectMaterial(drink, 1, 10765, "airportgnd_sfse", "white", 0xFF000000);
	SetDynamicObjectMaterial(drink, 2, 14650, "ab_trukstpc", "mp_CJ_WOOD5", 0xFF808080);
	SetDynamicObjectMaterial(drink, 3, 14650, "ab_trukstpc", "mp_CJ_WOOD5", 0xFF808080);
	drink = CreateDynamicObjectEx(2138,1407.623,-1479.007,124.396,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 4604, "buildblk555", "gm_labuld5_b", 0x00000000);
	SetDynamicObjectMaterial(drink, 2, 10765, "airportgnd_sfse", "white", 0xFF000000);
	SetDynamicObjectMaterial(drink, 3, 14650, "ab_trukstpc", "mp_CJ_WOOD5", 0xFF808080);
	drink = CreateDynamicObjectEx(2136,1407.624,-1478.051,124.396,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, -1, "none", "none", 0xFF808080);
	SetDynamicObjectMaterial(drink, 1, 4604, "buildblk555", "gm_labuld5_b", 0x00000000);
	SetDynamicObjectMaterial(drink, 2, 10765, "airportgnd_sfse", "white", 0xFF000000);
	SetDynamicObjectMaterial(drink, 3, 10765, "airportgnd_sfse", "white", 0xFF000000);
	SetDynamicObjectMaterial(drink, 4, 14650, "ab_trukstpc", "mp_CJ_WOOD5", 0xFF808080);
	drink = CreateDynamicObjectEx(19916,1407.378,-1480.928,124.390,0.000,0.000,-270.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, -1, "none", "none", 0xFFFFFFFF);
	drink = CreateDynamicObjectEx(19933,1407.613,-1478.018,124.922,0.000,0.000,-180.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, -1, "none", "none", 0xFFFFFFFF);
	drink = CreateDynamicObjectEx(19933,1407.367,-1477.989,125.021,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(2613,1407.616,-1477.098,125.085,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFFFF0000);
	drink = CreateDynamicObjectEx(2613,1407.918,-1477.095,125.085,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFFFF0000);
	drink = CreateDynamicObjectEx(19933,1407.509,-1477.989,125.021,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(1906,1407.723,-1477.735,125.464,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFFFF0000);
	drink = CreateDynamicObjectEx(19449,1405.714,-1476.440,126.066,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
	drink = CreateDynamicObjectEx(19450,1403.664,-1481.492,122.850,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19450,1403.618,-1476.408,122.850,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1407.129,-1476.553,127.877,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1410.547,-1476.521,127.084,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(2205,1414.437,-1481.645,124.309,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 14650, "ab_trukstpc", "mp_CJ_WOOD5", 0xFF808080);
	drink = CreateDynamicObjectEx(19449,1410.361,-1474.861,126.066,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
	drink = CreateDynamicObjectEx(19449,1418.374,-1476.425,126.066,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
	drink = CreateDynamicObjectEx(19449,1410.452,-1471.702,126.066,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
	drink = CreateDynamicObjectEx(19450,1410.469,-1471.709,122.850,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(1569,1410.557,-1474.914,124.392,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, -1, "none", "none", 0xFFFFFFFF);
	drink = CreateDynamicObjectEx(1569,1413.540,-1474.918,124.392,0.000,0.000,-180.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, -1, "none", "none", 0xFFFFFFFF);
	drink = CreateDynamicObjectEx(19449,1413.634,-1471.681,126.066,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
	drink = CreateDynamicObjectEx(19450,1418.358,-1476.433,122.850,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19450,1413.590,-1471.689,122.850,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1413.551,-1476.495,127.084,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19449,1410.762,-1474.727,127.158,0.000,90.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
	drink = CreateDynamicObjectEx(19449,1410.520,-1476.404,128.830,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0x00000000);
	drink = CreateDynamicObjectEx(19089,1414.612,-1476.490,127.084,0.000,90.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1413.540,-1469.126,127.064,0.000,90.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1410.563,-1469.170,127.064,0.000,90.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(1516,1409.742,-1478.543,124.476,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 14650, "ab_trukstpc", "mp_CJ_WOOD5", 0xFF808080);
	drink = CreateDynamicObjectEx(2123,1409.737,-1479.079,124.949,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 14650, "ab_trukstpc", "mp_CJ_WOOD5", 0xFF808080);
	drink = CreateDynamicObjectEx(2123,1410.364,-1478.520,124.949,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 14650, "ab_trukstpc", "mp_CJ_WOOD5", 0xFF808080);
	drink = CreateDynamicObjectEx(1547,1414.767,-1482.461,125.251,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF808080);
	drink = CreateDynamicObjectEx(1547,1414.767,-1482.461,125.466,0.000,-104.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF808080);
	drink = CreateDynamicObjectEx(1547,1414.763,-1482.441,125.466,0.000,-77.000,180.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF808080);
	drink = CreateDynamicObjectEx(2259,1414.220,-1481.977,125.951,0.000,90.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	SetDynamicObjectMaterial(drink, 1, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19814,1414.692,-1481.820,125.492,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF808080);
	drink = CreateDynamicObjectEx(1907,1414.674,-1482.463,125.482,0.000,-90.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19328,1406.596,-1481.617,126.347,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 3922, "bistro", "StainedGlass", 0x00000000);
	drink = CreateDynamicObjectEx(19328,1414.952,-1478.639,126.347,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 14489, "carlspics", "AH_landscap1", 0x00000000);
	drink = CreateDynamicObjectEx(19327,1404.598,-1484.047,126.207,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterialText(drink, 0, "G", 130, "Ariel", 199, 0, 0xFFFFFFFF, 0x00000000, 1);
	drink = CreateDynamicObjectEx(1581,1414.259,-1482.418,125.234,270.000,0.000,-82.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 16644, "a51_detailstuff", "Gen_Keyboard", 0x00000000);
	drink = CreateDynamicObjectEx(18865,1414.236,-1482.946,125.328,0.000,0.000,-55.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF808080);
	SetDynamicObjectMaterial(drink, 1, 10765, "airportgnd_sfse", "white", 0xFF808080);
	drink = CreateDynamicObjectEx(19450,1403.664,-1481.532,122.850,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19379,1409.747,-1483.513,127.786,0.000,90.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 11301, "carshow_sfse", "ws_officy_ceiling", 0x00000000);
	drink = CreateDynamicObjectEx(19379,1409.816,-1473.933,127.786,0.000,90.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 11301, "carshow_sfse", "ws_officy_ceiling", 0x00000000);
	drink = CreateDynamicObjectEx(1646,1407.998,-1489.723,124.633,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, -1, "none", "none", 0xFFFFFFFF);
	drink = CreateDynamicObjectEx(1646,1406.398,-1489.659,124.633,0.000,0.000,12.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 14668, "711c", "CJ_CHIP_M2", 0xFFFFFFFF);
	drink = CreateDynamicObjectEx(19087,1409.636,-1488.361,124.554,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(1906,1407.633,-1477.735,125.464,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFFFF0000);
	drink = CreateDynamicObjectEx(19089,1414.482,-1474.949,127.064,0.000,90.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1410.547,-1474.940,127.084,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19089,1413.547,-1474.940,127.084,0.000,0.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF000000);
	drink = CreateDynamicObjectEx(19814,1414.692,-1482.001,125.492,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF808080);
	drink = CreateDynamicObjectEx(19814,1414.692,-1482.231,125.492,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF808080);
	drink = CreateDynamicObjectEx(19814,1414.692,-1482.461,125.492,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF808080);
	drink = CreateDynamicObjectEx(19814,1414.692,-1482.691,125.492,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF808080);
	drink = CreateDynamicObjectEx(19814,1414.692,-1482.942,125.492,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF808080);
	drink = CreateDynamicObjectEx(19814,1414.692,-1483.062,125.492,0.000,0.000,-90.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFF808080);
	drink = CreateDynamicObjectEx(1907,1404.604,-1484.053,125.452,0.000,-90.000,0.000,300.000,300.000);
	SetDynamicObjectMaterial(drink, 0, 10765, "airportgnd_sfse", "white", 0xFFA82727);
	drink = CreateDynamicObjectEx(19327,1404.588,-1484.047,126.207,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterialText(drink, 0, "n", 130, "Webdings", 160, 0, 0xFFD32C4E, 0x00000000, 1);
	drink = CreateDynamicObjectEx(19327,1404.598,-1484.047,126.196,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterialText(drink, 0, "L", 130, "Ariel", 80, 0, 0xFFFFFFFF, 0x00000000, 1);
	drink = CreateDynamicObjectEx(19327,1404.598,-1484.147,126.367,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterialText(drink, 0, "n", 130, "Webdings", 15, 0, 0xFFFFFFFF, 0x00000000, 1);
	drink = CreateDynamicObjectEx(19327,1404.598,-1484.047,126.207,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterialText(drink, 0, "G", 130, "Ariel", 199, 0, 0xFFFFFFFF, 0x00000000, 1);
	drink = CreateDynamicObjectEx(19327,1404.598,-1484.047,125.746,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterialText(drink, 0, "LG", 140, "Ariel", 40, 1, 0xFF808080, 0x00000000, 1);
	drink = CreateDynamicObjectEx(19327,1404.598,-1484.047,125.636,0.000,0.000,90.000,300.000,300.000);
	SetDynamicObjectMaterialText(drink, 0, "Life is Good", 140, "Ariel", 40, 1, 0xFF808080, 0x00000000, 1);
	drink = CreateDynamicObjectEx(19327,1414.680,-1482.464,126.246,0.000,0.000,-90.099,300.000,300.000);
	SetDynamicObjectMaterialText(drink, 0, "iOS v0.3.7", 140, "Ariel", 40, 1, 0xFFFFFFFF, 0x00000000, 1);
	drink = CreateDynamicObjectEx(19327,1414.680,-1482.454,126.087,0.000,0.000,-90.099,300.000,300.000);
	SetDynamicObjectMaterialText(drink, 0, "-", 140, "Ariel", 199, 1, 0xFFFFFFFF, 0x00000000, 1);
	drink = CreateDynamicObjectEx(19327,1414.680,-1482.464,126.097,0.000,0.000,-90.099,300.000,300.000);
	SetDynamicObjectMaterialText(drink, 0, "username", 140, "Ariel", 15, 1, 0xFFFFFFFF, 0x00000000, 1);
	drink = CreateDynamicObjectEx(19327,1414.660,-1482.474,126.047,0.000,0.000,-90.099,300.000,300.000);
	SetDynamicObjectMaterialText(drink, 0, "kita123", 140, "Ariel", 14, 1, 0xFF000000, 0x00000000, 1);
	drink = CreateDynamicObjectEx(3857,1409.712,-1488.352,124.371,0.000,0.000,45.000,300.000,300.000);
	drink = CreateDynamicObjectEx(2233,1404.472,-1485.568,124.392,0.000,0.000,90.000,300.000,300.000);
	drink = CreateDynamicObjectEx(2233,1404.373,-1481.938,124.392,0.000,0.000,90.000,300.000,300.000);
	drink = CreateDynamicObjectEx(1670,1406.809,-1483.712,124.822,0.000,0.000,-47.000,300.000,300.000);
	drink = CreateDynamicObjectEx(2344,1406.779,-1484.066,124.808,0.000,0.000,-127.000,300.000,300.000);
	drink = CreateDynamicObjectEx(2260,1414.482,-1483.971,126.005,0.000,0.000,-90.000,300.000,300.000);
	drink = CreateDynamicObjectEx(2261,1414.455,-1484.802,126.064,0.000,0.000,-90.000,300.000,300.000);
	drink = CreateDynamicObjectEx(2262,1414.483,-1484.859,125.311,0.000,0.000,-90.000,300.000,300.000);
	drink = CreateDynamicObjectEx(2264,1414.458,-1485.608,126.184,0.000,0.000,-90.000,300.000,300.000);
	drink = CreateDynamicObjectEx(2265,1414.475,-1485.586,125.331,0.000,0.000,-90.000,300.000,300.000);
	drink = CreateDynamicObjectEx(1714,1413.458,-1482.259,124.392,0.000,0.000,76.000,300.000,300.000);
	drink = CreateDynamicObjectEx(2828,1414.486,-1481.629,125.234,0.000,0.000,97.000,300.000,300.000);
	drink = CreateDynamicObjectEx(2253,1414.657,-1476.769,124.639,0.000,0.000,0.000,300.000,300.000);
	drink = CreateDynamicObjectEx(2812,1409.855,-1478.676,125.002,0.000,0.000,55.000,300.000,300.000);	


	tmpobjid = CreateDynamicObject(18766, 1711.897, 732.640, 9.892, 90.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(18766, 1701.897, 732.638, 9.892, 90.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(18766, 1714.399, 725.140, 9.892, 90.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19379, 1711.568, 730.166, 10.310, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14479, !"skuzzy_motelmain", !"mp_CJ_Laminate1", 0);
	tmpobjid = CreateDynamicObject(19379, 1701.069, 730.164, 10.310, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14479, !"skuzzy_motelmain", !"mp_CJ_Laminate1", 0);
	tmpobjid = CreateDynamicObject(19379, 1692.418, 730.163, 10.305, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14479, !"skuzzy_motelmain", !"mp_CJ_Laminate1", 0);
	tmpobjid = CreateDynamicObject(19379, 1711.558, 720.533, 10.310, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14479, !"skuzzy_motelmain", !"mp_CJ_Laminate1", 0);
	tmpobjid = CreateDynamicObject(19379, 1701.068, 720.533, 10.310, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14479, !"skuzzy_motelmain", !"mp_CJ_Laminate1", 0);
	tmpobjid = CreateDynamicObject(19379, 1692.427, 720.528, 10.305, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14479, !"skuzzy_motelmain", !"mp_CJ_Laminate1", 0);
	tmpobjid = CreateDynamicObject(19325, 1713.501, 734.984, 12.447, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19325, 1706.864, 734.984, 12.447, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19325, 1700.227, 734.984, 12.447, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19325, 1716.819, 731.664, 12.447, 0.00, 0.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19325, 1716.819, 725.026, 12.447, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.824, 731.668, 14.559, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1702.322, 731.671, 14.559, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.824, 722.036, 14.559, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1702.322, 722.036, 14.559, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19172, 1717.136, 736.270, 15.824, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19172, 1717.873, 735.531, 15.824, 0.00, 90.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19172, 1717.873, 733.033, 15.824, 0.00, 90.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.156, 731.664, 14.562, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19172, 1717.873, 730.640, 15.824, 0.00, 90.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19172, 1717.873, 728.109, 15.824, 0.00, 90.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19172, 1717.873, 725.534, 15.824, 0.00, 90.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19172, 1717.873, 722.913, 15.824, 0.00, 90.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.822, 719.921, 14.564, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(18763, 1719.062, 721.614, 8.444, 0.00, 101.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19449, 1716.802, 721.372, 9.647, 90.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19449, 1716.322, 720.023, 9.680, 90.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19449, 1717.987, 718.357, 9.680, 90.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19449, 1717.984, 717.346, 9.680, 90.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19377, 1702.352, 719.916, 14.562, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.160, 719.901, 14.562, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19450, 1712.005, 723.038, 9.281, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6872, !"vgndwntwn5", !"fitzwallvgn2_256", 0);
	tmpobjid = CreateDynamicObject(19450, 1702.453, 723.033, 9.281, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6872, !"vgndwntwn5", !"fitzwallvgn2_256", 0);
	tmpobjid = CreateDynamicObject(19450, 1693.134, 723.028, 9.281, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6872, !"vgndwntwn5", !"fitzwallvgn2_256", 0);
	tmpobjid = CreateDynamicObject(19450, 1712.005, 723.035, 12.781, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6872, !"vgndwntwn5", !"fitzwallvgn2_256", 0);
	tmpobjid = CreateDynamicObject(19450, 1702.453, 723.032, 12.781, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6872, !"vgndwntwn5", !"fitzwallvgn2_256", 0);
	tmpobjid = CreateDynamicObject(19450, 1693.133, 723.028, 12.781, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6872, !"vgndwntwn5", !"fitzwallvgn2_256", 0);
	tmpobjid = CreateDynamicObject(19172, 1714.891, 736.270, 15.824, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19172, 1712.588, 736.270, 15.824, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19172, 1710.197, 736.270, 15.824, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19172, 1707.801, 736.270, 15.824, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19172, 1705.227, 736.270, 15.824, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19172, 1702.696, 736.270, 15.824, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19172, 1700.123, 736.270, 15.824, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19172, 1697.745, 736.270, 15.824, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19172, 1695.479, 736.270, 15.824, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19172, 1693.255, 736.270, 15.824, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.823, 731.668, 15.098, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.822, 731.668, 15.598, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.822, 731.668, 16.099, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.821, 731.668, 16.599, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1702.322, 731.669, 15.100, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1702.321, 731.669, 15.598, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1702.319, 731.669, 16.083, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1702.318, 731.669, 16.599, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.156, 731.664, 15.107, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.156, 731.663, 15.598, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.156, 731.661, 16.083, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.156, 731.661, 16.599, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.823, 722.034, 15.098, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.822, 722.033, 15.597, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.822, 722.033, 16.099, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.821, 722.031, 16.603, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.822, 719.921, 15.097, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.821, 719.921, 15.600, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.819, 719.921, 16.094, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.822, 719.921, 16.599, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1702.352, 719.916, 15.098, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1702.352, 719.916, 15.600, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1702.352, 719.916, 17.023, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1702.352, 719.916, 16.600, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.159, 719.909, 15.097, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.157, 719.913, 15.600, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.156, 719.901, 17.198, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.156, 719.901, 16.599, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.819, 731.668, 17.023, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.818, 731.668, 17.198, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1702.317, 731.669, 17.024, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1702.317, 731.669, 17.194, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.156, 731.669, 17.020, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.156, 731.669, 17.197, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.820, 722.031, 17.023, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.822, 719.921, 17.018, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1702.352, 719.916, 16.097, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.155, 719.900, 17.018, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.820, 722.031, 17.194, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1712.821, 719.921, 17.193, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1702.351, 719.916, 17.194, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.154, 719.899, 17.018, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(3078, 1717.848, 732.189, 15.717, 90.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1717.848, 726.405, 15.717, 90.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1717.842, 726.403, 16.177, 90.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1717.869, 731.924, 16.177, 90.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1713.797, 736.260, 16.177, 90.00, 90.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1706.230, 736.258, 16.177, 90.00, 90.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1699.390, 736.271, 16.177, 90.00, 90.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1696.112, 736.254, 16.177, 90.00, 90.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1696.107, 736.237, 15.651, 90.00, 90.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1704.619, 736.252, 15.651, 90.00, 90.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1712.558, 736.254, 15.651, 90.00, 90.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(19172, 1717.871, 720.419, 15.824, 0.00, 90.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(3078, 1717.859, 723.926, 16.177, 90.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1717.875, 723.927, 15.737, 90.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(19446, 1717.791, 717.978, 12.182, 90.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, !"libertyhi", !"indtendark64", 0);
	tmpobjid = CreateDynamicObject(19446, 1717.787, 717.356, 12.182, 90.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, !"libertyhi", !"indtendark64", 0);
	tmpobjid = CreateDynamicObject(19446, 1713.019, 715.693, 15.406, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, !"libertyhi", !"indtendark64", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.156, 719.901, 16.097, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19446, 1703.384, 715.693, 15.406, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, !"libertyhi", !"indtendark64", 0);
	tmpobjid = CreateDynamicObject(19446, 1694.379, 715.700, 15.406, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, !"libertyhi", !"indtendark64", 0);
	tmpobjid = CreateDynamicObject(19446, 1692.00, 715.692, 15.406, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, !"libertyhi", !"indtendark64", 0);
	tmpobjid = CreateDynamicObject(1491, 1696.921, 734.995, 10.395, 0.00, 0.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1649, !"wglass", !"carshowwin2", 0);
	tmpobjid = CreateDynamicObject(19449, 1690.933, 734.905, 9.647, 90.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(1491, 1693.900, 734.976, 10.395, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 1649, !"wglass", !"carshowwin2", 0);
	tmpobjid = CreateDynamicObject(19449, 1690.587, 734.736, 9.687, 90.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19449, 1688.921, 736.403, 9.687, 90.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19325, 1693.595, 734.982, 14.949, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(18766, 1699.660, 734.676, 7.895, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(18766, 1691.180, 734.677, 7.895, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19452, 1697.751, 734.200, 10.302, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, !"a51", !"ws_stationfloor", 0);
	tmpobjid = CreateDynamicObject(19452, 1693.317, 734.211, 10.302, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, !"a51", !"ws_stationfloor", 0);
	tmpobjid = CreateDynamicObject(19452, 1695.572, 734.213, 10.300, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, !"a51", !"ws_stationfloor", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.156, 727.062, 16.599, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.155, 727.062, 17.020, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.156, 727.062, 17.198, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1702.402, 726.776, 17.198, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19450, 1692.598, 730.159, 9.281, 0.00, 0.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6872, !"vgndwntwn5", !"fitzwallvgn2_256", 0);
	tmpobjid = CreateDynamicObject(19450, 1692.597, 720.531, 12.781, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6872, !"vgndwntwn5", !"fitzwallvgn2_256", 0);
	tmpobjid = CreateDynamicObject(19446, 1688.922, 736.215, 12.182, 90.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, !"libertyhi", !"indtendark64", 0);
	tmpobjid = CreateDynamicObject(19172, 1691.290, 736.265, 15.824, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 8396, !"sphinx01", !"luxorceiling02_128", 0);
	tmpobjid = CreateDynamicObject(19446, 1687.260, 731.484, 15.406, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, !"libertyhi", !"indtendark64", 0);
	tmpobjid = CreateDynamicObject(19446, 1687.260, 721.854, 15.406, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, !"libertyhi", !"indtendark64", 0);
	tmpobjid = CreateDynamicObject(19446, 1687.260, 720.421, 15.406, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 3897, !"libertyhi", !"indtendark64", 0);
	tmpobjid = CreateDynamicObject(18980, 1674.829, 733.153, 9.843, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(18980, 1649.834, 733.156, 15.626, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(18980, 1674.692, 718.583, 9.843, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(18980, 1649.698, 718.588, 9.843, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(18980, 1640.609, 733.158, 9.847, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(18980, 1640.609, 718.591, 9.847, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19325, 1691.854, 734.984, 9.567, 90.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19450, 1692.598, 730.158, 12.781, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6872, !"vgndwntwn5", !"fitzwallvgn2_256", 0);
	tmpobjid = CreateDynamicObject(19450, 1692.596, 720.530, 9.281, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 6872, !"vgndwntwn5", !"fitzwallvgn2_256", 0);
	tmpobjid = CreateDynamicObject(19381, 1685.504, 733.419, 10.923, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19380, 1713.255, 715.681, 9.331, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19380, 1703.621, 715.682, 9.331, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19380, 1693.989, 715.684, 9.331, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19380, 1691.979, 715.677, 9.331, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19380, 1687.250, 720.406, 9.331, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19380, 1687.246, 730.038, 9.331, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19380, 1687.244, 731.658, 9.331, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1668.487, 733.419, 10.923, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1650.479, 733.419, 10.923, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1633.187, 733.418, 10.923, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1684.157, 728.617, 10.923, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1684.145, 723.156, 10.923, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19545, 1659.649, 726.007, 10.340, 0.00, 0.00, 269.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 9514, !"711_sfw", !"ws_carpark2", 0);
	tmpobjid = CreateDynamicObject(19381, 1682.333, 718.427, 10.923, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1672.697, 718.435, 10.923, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1663.063, 718.434, 10.923, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1653.436, 718.434, 10.923, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1643.803, 718.437, 10.923, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1634.171, 718.432, 10.923, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1633.192, 718.434, 10.923, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1628.463, 723.172, 10.923, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1628.458, 728.685, 10.923, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1670.817, 723.333, 10.923, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1665.977, 723.333, 10.923, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(18766, 1668.400, 727.711, 11.173, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(18766, 1650.479, 727.711, 11.173, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19381, 1648.061, 723.341, 10.923, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1652.896, 723.333, 10.923, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1635.120, 723.250, 10.923, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19381, 1635.115, 728.659, 10.923, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(18766, 1677.469, 736.091, 9.583, 84.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(18766, 1659.313, 736.086, 9.583, 83.995, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(18766, 1641.817, 736.088, 9.583, 83.995, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(18766, 1659.301, 740.866, 9.352, 90.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(18766, 1677.449, 740.879, 9.347, 90.00, 180.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(18766, 1641.807, 740.929, 9.347, 90.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1681.667, 729.344, 16.083, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1671.168, 729.344, 16.597, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1660.671, 729.343, 16.083, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1650.170, 729.343, 16.597, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1639.668, 729.348, 16.083, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1632.875, 729.351, 16.086, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1681.667, 729.344, 16.597, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1671.168, 729.344, 16.083, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1660.670, 729.343, 16.597, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1650.169, 729.343, 16.083, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1639.668, 729.348, 16.597, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1632.875, 729.351, 17.024, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1681.667, 729.344, 17.197, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1671.168, 729.344, 17.020, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1660.670, 729.343, 17.020, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1650.169, 729.343, 17.020, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1639.668, 729.348, 17.020, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1632.875, 729.350, 16.600, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1681.667, 729.344, 17.020, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1671.168, 729.344, 17.197, 0.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1660.670, 729.343, 17.197, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1650.169, 729.343, 17.197, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1639.668, 729.348, 17.197, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1632.875, 729.351, 17.193, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(3078, 1683.211, 733.499, 16.198, 90.00, 90.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1675.088, 733.499, 16.198, 90.00, 90.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1666.965, 733.500, 16.193, 90.00, 90.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1658.857, 733.502, 16.211, 90.00, 90.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1650.954, 733.502, 16.211, 90.00, 90.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1642.838, 733.504, 16.211, 90.00, 90.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1634.722, 733.502, 16.211, 90.00, 90.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1632.458, 733.497, 16.211, 90.00, 90.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1628.394, 729.445, 16.211, 90.00, 90.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(18980, 1674.828, 733.151, 15.626, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(18980, 1649.834, 733.156, 9.843, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(18980, 1640.609, 733.156, 15.619, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(19377, 1681.718, 721.945, 16.099, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1671.233, 721.945, 16.099, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1660.741, 721.945, 16.099, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1650.251, 721.945, 16.099, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1639.755, 721.945, 16.099, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1632.873, 721.943, 16.100, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1681.718, 721.945, 16.599, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1671.232, 721.944, 16.599, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1660.741, 721.945, 16.599, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1650.251, 721.945, 16.599, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1639.755, 721.944, 16.599, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1632.873, 721.943, 16.599, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1681.718, 721.945, 17.020, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1671.232, 721.944, 17.198, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1660.741, 721.945, 17.198, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1650.251, 721.945, 17.020, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1639.755, 721.944, 17.198, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1632.871, 721.956, 17.024, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1681.718, 721.945, 17.198, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1671.232, 721.944, 17.020, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1660.741, 721.945, 17.020, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1650.251, 721.945, 17.198, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1639.755, 721.944, 17.020, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19377, 1632.870, 721.955, 17.201, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(3078, 1628.427, 722.435, 16.211, 90.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1632.458, 718.403, 16.211, 90.00, 90.00, 269.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1640.442, 718.406, 16.211, 90.00, 90.00, 269.989, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1648.500, 718.401, 16.211, 90.00, 90.00, 269.989, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1656.517, 718.406, 16.211, 90.00, 90.00, 269.989, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1664.603, 718.408, 16.211, 90.00, 90.00, 269.989, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1672.668, 718.408, 16.211, 90.00, 90.00, 269.989, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1680.702, 718.414, 16.211, 90.00, 90.00, 269.989, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(3078, 1688.792, 718.416, 16.211, 90.00, 90.00, 269.989, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(18980, 1649.698, 718.587, 15.626, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(18980, 1674.692, 718.583, 15.626, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(18980, 1640.609, 718.591, 15.626, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(18763, 1630.583, 726.047, 12.902, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(19377, 1692.084, 727.914, 14.567, 0.00, 90.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(19435, 1715.129, 734.961, 12.324, 90.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14708, !"labig1int2", !"GB_restaursmll38", 0);
	tmpobjid = CreateDynamicObject(19435, 1716.790, 733.301, 12.324, 90.00, 90.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14708, !"labig1int2", !"GB_restaursmll38", 0);
	tmpobjid = CreateDynamicObject(19435, 1713.036, 734.956, 12.324, 90.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 14708, !"labig1int2", !"GB_restaursmll38", 0);
	tmpobjid = CreateDynamicObject(19089, 1697.913, 734.984, 14.744, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(19089, 1700.193, 734.992, 14.744, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(19089, 1702.458, 734.989, 14.744, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(19089, 1704.853, 734.984, 14.744, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(19089, 1707.463, 734.984, 14.744, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(19089, 1709.886, 734.987, 14.744, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(19089, 1716.822, 730.622, 14.744, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(19089, 1716.827, 728.328, 14.744, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(19089, 1716.824, 725.828, 14.744, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(1849, 1695.318, 723.502, 10.397, 0.00, 0.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 3, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 4, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 5, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 6, 16640, !"a51", !"ws_stationfloor", 0);
	tmpobjid = CreateDynamicObject(1849, 1704.088, 723.502, 10.397, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 3, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 4, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 5, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 6, 16640, !"a51", !"ws_stationfloor", 0);
	tmpobjid = CreateDynamicObject(1849, 1713.061, 723.502, 10.397, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 2, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 3, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 4, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 5, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 6, 16640, !"a51", !"ws_stationfloor", 0);
	tmpobjid = CreateDynamicObject(1847, 1713.061, 730.122, 10.390, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(1847, 1713.061, 729.057, 10.390, 0.00, 0.00, 359.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(1847, 1704.088, 730.122, 10.390, 0.00, 0.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(1847, 1704.088, 729.057, 10.390, 0.00, 0.00, 359.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, !"a51", !"ws_stationfloor", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 17547, !"matarrows", !"red-2-2", 0);
	tmpobjid = CreateDynamicObject(19786, 1692.586, 728.846, 13.043, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10101, !"2notherbuildsfe", !"ferry_build14", 0);
	tmpobjid = CreateDynamicObject(2257, 1708.524, 723.132, 12.796, 0.00, 0.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14530, !"estate2", !"Auto_windsor", 0);
	tmpobjid = CreateDynamicObject(2257, 1699.635, 723.140, 12.796, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 14530, !"estate2", !"Auto_feltzer", 0);
	tmpobjid = CreateDynamicObject(3521, 1660.300, 788.432, 11.399, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10403, !"golf_sfs", !"golf_fairway1", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 9919, !"grnwht_sfe", !"whitgrn_sfe3", 0);
	SetDynamicObjectMaterial(tmpobjid, 3, 10765, !"airportgnd_sfse", !"black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 4, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(19893, 1695.333, 729.718, 11.336, 0.00, 0.00, 280.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 1, 10765, !"airportgnd_sfse", !"black64", 0);
	tmpobjid = CreateDynamicObject(19913, 1733.844, 660.552, 5.861, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19545, 1659.647, 726.007, 15.156, 0.00, 0.00, 269.989, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, !"a51", !"plaintarmac1", 0);
	tmpobjid = CreateDynamicObject(19451, 1659.402, 725.102, 10.258, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, !"a51", !"sl_metalwalk", 0);
	tmpobjid = CreateDynamicObject(19451, 1677.222, 725.102, 10.255, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, !"a51", !"sl_metalwalk", 0);
	tmpobjid = CreateDynamicObject(19451, 1642.046, 725.102, 10.274, 0.00, 90.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 16640, !"a51", !"sl_metalwalk", 0);
	tmpobjid = CreateDynamicObject(19325, 1677.240, 718.528, 12.642, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	SetDynamicObjectMaterialText(tmpobjid, 0, !"ÁÎÊÑ - ¹1", 140, !"Calibri", 100, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19325, 1659.418, 718.534, 12.642, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	SetDynamicObjectMaterialText(tmpobjid, 0, !"ÁÎÊÑ - ¹2", 140, !"Calibri", 90, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19325, 1641.573, 718.539, 12.642, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	SetDynamicObjectMaterialText(tmpobjid, 0, !"ÁÎÊÑ - ¹3", 140, !"Calibri", 90, 1, -1, 0, 1);
	tmpobjid = CreateDynamicObject(19913, 1683.848, 660.554, 5.861, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19913, 1633.848, 660.543, 5.861, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19913, 1602.311, 660.536, 5.866, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19913, 1577.364, 685.533, 5.866, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19913, 1577.364, 735.528, 5.866, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19913, 1577.362, 760.486, 5.866, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19913, 1602.336, 785.432, 5.866, 0.00, 0.00, 180.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19913, 1638.368, 785.434, 5.866, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19913, 1703.285, 785.552, 5.866, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19913, 1751.735, 785.546, 5.869, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10765, !"airportgnd_sfse", !"black64", 0);
	SetDynamicObjectMaterial(tmpobjid, 1, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	tmpobjid = CreateDynamicObject(19325, 1659.924, 788.593, 11.964, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(tmpobjid, 0, 10023, !"bigwhitesfe", !"sfe_arch8", 0);
	SetDynamicObjectMaterialText(tmpobjid, 0, !"ÑÒÎ", 140, !"Ariel", 160, 1, -1, 0, 1); */
	//
	CreateDynamicObject(19529, 1714.428, 723.005, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19529, 1639.854, 723.158, 9.840, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19545, 1670.823, 770.757, 9.859, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19545, 1697.432, 747.017, 9.852, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19545, 1727.213, 723.270, 9.859, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19545, 1640.883, 747.015, 9.855, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19545, 1617.118, 723.325, 9.852, 0.00, 0.00, 180.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19545, 1688.464, 699.512, 9.859, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19545, 1640.722, 699.515, 9.854, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19529, 1714.428, 723.005, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(14387, 1697.352, 740.148, 9.404, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(14387, 1693.068, 740.145, 9.402, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1703, 1709.496, 723.607, 10.397, 0.00, 0.00, 180.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1703, 1700.612, 723.661, 10.397, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1984, 1695.228, 729.664, 10.390, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1984, 1694.364, 727.674, 10.392, 0.00, 0.00, 180.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(2309, 1693.701, 729.348, 10.390, 0.00, 0.00, 260.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(2229, 1692.345, 727.645, 12.310, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(2229, 1692.307, 730.668, 12.310, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1085, 1702.124, 730.377, 11.482, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1082, 1703.369, 730.414, 11.503, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1084, 1704.619, 730.448, 11.527, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1081, 1705.921, 730.409, 11.500, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1080, 1711.083, 730.375, 11.465, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1080, 1712.269, 730.406, 11.465, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1080, 1713.574, 730.442, 11.512, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1080, 1714.979, 730.406, 11.512, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1079, 1711.422, 728.822, 11.479, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1079, 1712.682, 728.859, 11.479, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1079, 1713.770, 728.840, 11.479, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1079, 1714.961, 728.861, 11.479, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1073, 1705.937, 728.804, 11.458, 0.00, 0.00, 269.979, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1074, 1704.718, 728.851, 11.428, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1076, 1703.598, 728.903, 11.387, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1077, 1702.343, 728.866, 11.387, 0.00, 0.00, 268.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1060, 1694.076, 723.690, 10.758, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1060, 1696.324, 723.669, 10.758, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1058, 1694.378, 723.349, 11.217, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1058, 1696.453, 723.424, 11.217, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1056, 1695.229, 723.565, 11.659, 0.00, 180.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1050, 1694.318, 723.456, 12.013, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1050, 1696.415, 723.489, 12.013, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1049, 1714.546, 723.606, 10.744, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1049, 1711.770, 723.624, 10.744, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1048, 1713.166, 723.427, 11.279, 0.00, 103.999, 270.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1046, 1711.822, 721.663, 12.057, 0.00, 0.00, 180.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1046, 1714.149, 721.715, 12.057, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1045, 1712.149, 721.698, 12.484, 0.00, 0.00, 190.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1045, 1714.428, 721.807, 12.484, 0.00, 0.00, 189.997, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1023, 1704.182, 723.588, 10.678, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1016, 1704.213, 723.455, 11.128, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1015, 1704.175, 723.565, 11.572, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(1014, 1704.163, 723.564, 12.006, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(18075, 1698.707, 729.229, 14.442, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(18075, 1710.512, 729.265, 14.442, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19815, 1670.891, 720.517, 12.423, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19816, 1679.432, 718.966, 10.604, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19872, 1677.188, 725.034, 8.449, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19899, 1683.526, 731.379, 10.340, 0.00, 0.00, 180.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19900, 1671.292, 721.620, 10.340, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19903, 1662.725, 718.851, 10.340, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19815, 1670.891, 723.517, 12.423, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19815, 1647.978, 726.486, 12.642, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19899, 1683.534, 728.807, 10.340, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19899, 1683.535, 726.239, 10.340, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19899, 1683.530, 723.674, 10.340, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19899, 1683.536, 721.099, 10.340, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19903, 1674.681, 718.968, 10.340, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19816, 1679.217, 718.984, 10.604, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19816, 1679.328, 718.838, 10.604, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19816, 1675.395, 719.004, 10.604, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19816, 1675.649, 718.994, 10.604, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19816, 1675.520, 718.820, 10.604, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19900, 1671.308, 723.369, 10.340, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19900, 1647.636, 727.370, 10.340, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19899, 1665.438, 726.690, 10.340, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19899, 1665.432, 724.119, 10.340, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19899, 1665.452, 721.546, 10.340, 0.00, 0.00, 179.994, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19903, 1680.324, 718.869, 10.340, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19903, 1638.172, 718.872, 10.340, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19900, 1671.299, 725.117, 10.340, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19900, 1653.334, 723.765, 10.340, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19900, 1653.329, 720.794, 10.340, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19815, 1670.895, 726.514, 12.423, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19815, 1652.983, 723.448, 12.802, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19815, 1652.984, 720.447, 12.802, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19872, 1659.302, 725.034, 8.449, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19899, 1635.661, 731.369, 10.340, 0.00, 0.00, 359.994, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19899, 1635.659, 728.806, 10.340, 0.00, 0.00, 359.989, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19899, 1635.665, 726.236, 10.340, 0.00, 0.00, 359.989, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19899, 1635.672, 723.668, 10.340, 0.00, 0.00, 359.989, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19899, 1635.676, 721.088, 10.340, 0.00, 0.00, 359.989, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19815, 1652.982, 726.448, 12.802, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19815, 1647.982, 723.502, 12.642, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19815, 1647.982, 720.505, 12.642, 0.00, 0.00, 270.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19900, 1653.352, 726.863, 10.340, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19900, 1647.630, 723.715, 10.340, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19900, 1647.619, 719.435, 10.340, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19903, 1656.214, 718.867, 10.340, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19903, 1644.636, 718.909, 10.340, 0.00, 0.00, 90.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(19872, 1641.965, 725.034, 8.449, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(16779, 1677.180, 726.367, 15.272, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(16779, 1659.441, 724.716, 15.272, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(16779, 1641.808, 725.091, 15.272, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(746, 1749.886, 765.833, 9.781, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(746, 1751.733, 750.635, 9.781, 0.00, 0.00, 320.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(746, 1743.885, 731.844, 9.781, 0.00, 0.00, 319.998, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(746, 1758.813, 719.406, 9.781, 0.00, 0.00, 319.998, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(746, 1745.906, 695.645, 9.781, 0.00, 0.00, 319.998, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(746, 1743.887, 676.518, 9.781, 0.00, 0.00, 319.998, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(746, 1721.031, 673.734, 9.781, 0.00, 0.00, 79.998, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(746, 1680.527, 671.580, 9.781, 0.00, 0.00, 79.996, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(746, 1628.098, 673.765, 9.781, 0.00, 0.00, 79.996, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(746, 1589.899, 672.440, 9.781, 0.00, 0.00, 79.996, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(746, 1586.600, 717.715, 9.781, 0.00, 0.00, 19.996, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(746, 1592.833, 745.801, 9.781, 0.00, 0.00, 19.995, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(746, 1585.916, 778.00, 9.781, 0.00, 0.00, 19.995, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1743.843, 673.364, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1719.213, 682.971, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1723.020, 665.622, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1693.515, 665.046, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1698.821, 681.893, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1673.233, 684.286, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1672.322, 665.327, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1653.578, 674.715, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1640.520, 687.617, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1635.657, 665.883, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1614.402, 664.231, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1617.604, 685.421, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1604.510, 674.815, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1584.034, 666.013, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1587.256, 688.439, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1599.202, 705.369, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1583.666, 714.581, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1596.572, 736.122, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1584.121, 753.577, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1580.813, 776.213, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1599.991, 777.914, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1753.048, 700.760, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1744.036, 723.606, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1761.711, 739.619, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1741.802, 759.044, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1766.468, 779.137, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);
	CreateDynamicObject(777, 1730.113, 777.719, 9.845, 0.00, 0.00, 0.00, -1, -1, -1, 300.00, 300.00);

	// Iesirile LV
	CreateDynamicObject(4518, 1738.54089, 521.78296, 28.59834,   360.77997, -6.14000, 75.88000);
	CreateDynamicObject(4520, 2766.62354, 603.93372, 9.14063,   0.56160, -0.36001, 88.99719);
	CreateDynamicObject(4514, 437.74054, 591.05017, 19.92368,   358.65833, 0.18000, 37.15075);
	CreateDynamicObject(4516, -141.33594, 468.64844, 12.60057,   362.73816, -1.74000, -12.23980);
	CreateDynamicObject(4527, -1010.04584, 943.52643, 35.47656,   3.14159, 0.00000, -182.25642);
	CreateDynamicObject(4524, -1141.71875, 1098.05469, 39.41900,   360.51825, -0.66000, 1.82159);
	CreateDynamicObject(4511, -2686.70630, 2059.17188, 59.77920,   0.20160, 0.72000, 93.13080);
	return true;
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
		}
		playerInfo[playerid][pSpawnChange] = 1;
		playerInfo[playerid][pFaction] = 0;
		playerInfo[playerid][pFactionRank] = 0;
		playerInfo[playerid][pFactionAge] = 0;
		playerInfo[playerid][pFactionWarns] = 0;	
		playerInfo[playerid][pFactionPunish] = 30;
		if(playerInfo[playerid][pFactionDuty]) playerInfo[playerid][pFactionDuty] = 0;
		update("UPDATE `server_users` SET `Faction` = '0', `FRank` = '7', `FAge` = '0', `FWarns` = '0', `FPunish` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pFactionPunish], playerInfo[playerid][pSQLID]);
		whenPlayerLeaveFaction(playerid);
		sendStaff(COLOR_LIGHTRED, "* Remove Notice: %s a facut reclama folosind intermediul functiei. Acesta a luat remove automat.", getName(playerid));
		sendStaff(COLOR_LIGHTRED,"* Remove Notice: Text '%s'.", text);
	}
	return true;
}

function Reclama(playerid, text[]) {
	if(playerInfo[playerid][pAdmin] > 5) return true;
	playerInfo[playerid][pMute] += 120;
	update("UPDATE `server_users` SET `Mute` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pMute], playerInfo[playerid][pSQLID]);
	SCM(playerid, COLOR_LIGHTRED, "* Anti-Reclama: Deoarece ai facut reclama, ai primit mute timp de 2 minute.");
	sendStaff(COLOR_LIGHTRED, "* Notice Anti-reclama: %s este posibil sa faca reclama ('%s').", getName(playerid), text);
	return true;
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