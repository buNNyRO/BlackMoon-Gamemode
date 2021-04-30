stock IsVehicleOccupied(vehicleid) {
	foreach(new i : PlayerInVehicle) if(IsPlayerInVehicle(i, vehicleid)) return true;
	return false;
}

stock string_fast(const varname[], va_args<>) {
    gString[0] = (EOS);
    va_format(gString, sizeof gString, varname, va_start<1>);
    return gString;
}

stock sendNearbyMessage(playerid, color, Float:distance, const text[], va_args<>)
{
	gString[0] = (EOS);
	va_format(gString, sizeof(gString), text, va_start<4>);

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	foreach(new i : loggedPlayers)
	{
		if(IsPlayerInRangeOfPoint(i, distance, x, y, z) && GetPlayerInterior(playerid) == GetPlayerInterior(i) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
		{
			sendSplitMessage(i, color, gString);
		}
	}
	return true;
}

stock sendSplitMessage(playerid, color, text[]) {
	new szText1[180], szText2[180];
	if(strlen(text) > 130) {
		strmid(szText1, text, 130, 256);
		strmid(szText2, text, 0, 130);
		SCMf(playerid, color, "%s", szText2);
		SCMf(playerid, color, "... %s", szText1);
	}
	else SCM(playerid, color, text);
	return true;
}

stock warnPlayer(playerid, adminid, const reason[])
{
	new adminName[MAX_PLAYER_NAME] = "AdmBot";
	if(adminid != INVALID_PLAYER_ID)
	{
		GetPlayerName(adminid, adminName, MAX_PLAYER_NAME);
		SetPVarInt(adminid, "warnDeelay", (gettime() + 60));
	}

	playerInfo[playerid][pWarn] ++;
	if(playerInfo[playerid][pWarn] == 3)
	{
		playerInfo[playerid][pWarn] = 0;
		SendClientMessageToAll(COLOR_LIGHTRED, string_fast("AdmCmd: %s a primit ban 3 zile de la administratorul AdmBot, motiv: Acumulare 3/3 warns.", getName(playerid)));	
		banPlayer(playerid, INVALID_PLAYER_ID, 3, "Acumulare 3/3 Warns");
	}

	update("UPDATE `server_users` SET `Warn` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pWarn], playerInfo[playerid][pSQLID]);
	SCMf(playerid, COLOR_GREY, "* Ai primit un warn pe motiv: %s", reason);

	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof gQuery, "INSERT INTO `server_warn_logs` (PlayerName, PlayerID, AdminName, AdminID, WarnReason) VALUES ('%s', '%d', '%s', '%d', '%s')", getName(playerid), playerInfo[playerid][pSQLID], adminName, (adminid != INVALID_PLAYER_ID) ? (playerInfo[adminid][pSQLID]) : (0), reason);
	mysql_pquery(SQL, gQuery, "", "");
	return true;
}


stock banPlayer(playerid, adminid, days, const reason[])
{
	new adminName[MAX_PLAYER_NAME] = "AdmBot";
	if(adminid != INVALID_PLAYER_ID)
	{
		GetPlayerName(adminid, adminName, MAX_PLAYER_NAME);
		SetPVarInt(adminid, "banDeelay", (gettime() + 60));
	}

	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, 256, "INSERT INTO `server_bans` (PlayerName, PlayerID, AdminName, AdminID, Reason, Days, Permanent, Date) VALUES ('%s', '%d', '%s', '%d', '%s', '%d', '%d', '%s')", getName(playerid), playerInfo[playerid][pSQLID], adminName, (INVALID_PLAYER_ID == adminid) ? (0) : (playerInfo[adminid][pSQLID]), reason, days, (days == 0) ? (1) : (0), getDateTime());
	mysql_pquery(SQL, gQuery, "", "");

	defer kickEx(playerid);
	return true;
}

stock mutePlayer(playerid, adminid, minutes, const reason[])
{
	new adminName[MAX_PLAYER_NAME] = "AdmBot";
	if(adminid != INVALID_PLAYER_ID)
	{
		GetPlayerName(adminid, adminName, MAX_PLAYER_NAME);
		SetPVarInt(adminid, "muteDeelay", (gettime() + 60));
	}
	
	SCMf(playerid, COLOR_GREY, "* Ai primit mute %d minute de la administratorul %s.", minutes, adminName);
	playerInfo[playerid][pMute] = (minutes * 60);
	muteTime[playerid] = repeat TimerMute(playerid);
	update("UPDATE `server_users` SET `Mute` = '%d' WHERE `ID` = '%d'", (minutes * 60), playerInfo[playerid][pSQLID]);

	if(!Iter_Contains(MutedPlayers, playerid))
		Iter_Add(MutedPlayers, playerid);

	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, 256, "INSERT INTO `server_mute_logs` (PlayerName, PlayerID, AdminName, AdminID, MuteReason, MuteMinutes) VALUES ('%s', '%d', '%s', '%d', '%s', '%d')", getName(playerid), playerInfo[playerid][pSQLID], adminName, (adminid != INVALID_PLAYER_ID) ? (playerInfo[adminid][pSQLID]) : (0), reason, minutes);
	mysql_pquery(SQL, gQuery, "", "");
	return true;
}

stock isPlane(carid) 
{
	switch(GetVehicleModel(carid)) 
	{
		case 417, 425, 447, 460, 469, 476, 487, 488, 497, 511, 512, 513, 519, 520, 548, 553, 563, 577, 592, 593: return true;
	}
	return false;
}

stock isBoat(carid) 
{
	switch(GetVehicleModel(carid)) 
	{
		case 430, 446, 452, 453, 454, 472, 473, 484, 493, 595: return true;
	}
	return false;
}

stock isBike(carid) 
{
	switch(GetVehicleModel(carid)) 
	{
		case 481, 509, 510: return true;
	}
	return false;
}

stock isMotor(carid)
{
	switch(GetVehicleModel(carid)) 
	{
		case 448, 461, 462, 463, 468, 471, 521, 522, 523, 581, 586: return true;
	}	
	return false;
}

stock setSkin(playerid, skin)
{
	playerInfo[playerid][pSkin] = skin;
	SetPlayerSkin(playerid, skin);
	return true;
}

stock showStats(playerid, userID)
{
	SCMf(playerid, COLOR_GREY, "------------------|%s's stats|----------------------", getName(playerid));
	SCMf(playerid, COLOR_WHITE, "(%d) %s | Ore Jucate: %.2f | Warn-uri: %d/3", userID, getName(userID), playerInfo[userID][pHours], playerInfo[userID][pWarn]);
	SCMf(playerid, COLOR_WHITE, "Nivel: %d | Puncte de Respect: %d/%d | Urmatorul nivel: $%s | Bani: $%s | Banca: $%s", playerInfo[userID][pLevel], playerInfo[userID][pRespectPoints], (playerInfo[userID][pLevel] * 3), formatNumber(playerInfo[userID][pLevel] * 250), GetCashStr(userID), GetBankMoney(userID));
	SCMf(playerid, COLOR_WHITE, "Droguri: %d | Materiale: %d | Phone: %d", playerInfo[userID][pDrugs], playerInfo[userID][pMats], playerInfo[userID][pPhone]);
	if(playerInfo[playerid][pAdmin]) {
		SCM(playerid, COLOR_GREY, "------------------admin statistics----------------------");
		SCMf(playerid, COLOR_LIGHTRED, "Secunde: %.0f | Secunde AFK: %d | Virtual World: %d | Interior: %d", playerInfo[userID][pSeconds], playerInfo[userID][pAFKSeconds], GetPlayerVirtualWorld(userID), GetPlayerInterior(userID));
	}
	SCM(playerid, COLOR_GREY, "--------------------------------------------------------------");
	return true;
}

stock showLicenses(playerid, userID)
{
	SCMf(playerid, COLOR_GREY, "------------------|%s's licenses|----------------------",getName(playerid));

	if(playerInfo[userID][pDrivingLicenseSuspend] > 0) SCMf(playerid, COLOR_LIGHTRED, "Licenta de Condus: Suspendata (%d ore)", playerInfo[userID][pDrivingLicenseSuspend]);
	else if(playerInfo[userID][pDrivingLicense] > 0) SCMf(playerid, COLOR_LIGHTRED, "Licenta de Condus: Valida (%d ore)", playerInfo[userID][pDrivingLicense]);
	else SCM(playerid, COLOR_GREY, "Licenta de Condus: Expirata");
	
	if(playerInfo[userID][pFlyLicenseSuspend] > 0) SCMf(playerid, COLOR_LIGHTRED, "Licenta de Pilot: Suspendata (%d ore)", playerInfo[userID][pFlyLicenseSuspend]);
	else if(playerInfo[userID][pFlyLicense] > 0) SCMf(playerid, COLOR_LIGHTRED, "Licenta de Pilot: Valida (%d ore)", playerInfo[userID][pFlyLicense]);
	else SCM(playerid, COLOR_GREY, "Licenta de Pilot: Expirata");
	
	if(playerInfo[userID][pWeaponLicenseSuspend] > 0) SCMf(playerid, COLOR_LIGHTRED, "Licenta de Port-Arma: Suspendata (%d ore)", playerInfo[userID][pWeaponLicenseSuspend]);
	else if(playerInfo[userID][pWeaponLicense] > 0) SCMf(playerid, COLOR_LIGHTRED, "Licenta de Port-Arma: Valida (%d ore)", playerInfo[userID][pWeaponLicense]);
	else SCM(playerid, COLOR_GREY, "Licenta de Port-Arma: Expirata");
	
	if(playerInfo[userID][pBoatLicenseSuspend] > 0) SCMf(playerid, COLOR_LIGHTRED, "Licenta de Navigatie: Suspendata (%d ore)", playerInfo[userID][pBoatLicenseSuspend]);
	else if(playerInfo[userID][pBoatLicense] > 0) SCMf(playerid, COLOR_LIGHTRED, "Licenta de Navigatie: Valida (%d ore)", playerInfo[userID][pBoatLicense]);
	else SCM(playerid, COLOR_GREY, "Licenta de Navigatie: Expirata");
	
	SCM(playerid, COLOR_GREY, "----------------------------------------");
	return true;
}

stock playerTextDraws(playerid)
{
	playerNamePTD[playerid] = CreatePlayerTextDraw(playerid, 639.499511, 422.266052, "");
	PlayerTextDrawLetterSize(playerid, playerNamePTD[playerid], 0.202001, 1.320000);
	PlayerTextDrawAlignment(playerid, playerNamePTD[playerid], 3);
	PlayerTextDrawColor(playerid, playerNamePTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, playerNamePTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, playerNamePTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, playerNamePTD[playerid], 255);
	PlayerTextDrawFont(playerid, playerNamePTD[playerid], 2);
	PlayerTextDrawSetProportional(playerid, playerNamePTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, playerNamePTD[playerid], 0);

	playerLevelPTD[playerid] = CreatePlayerTextDraw(playerid, 86.600028, 287.592864, "");
	PlayerTextDrawLetterSize(playerid, playerLevelPTD[playerid], 0.159666, 1.131777);
	PlayerTextDrawAlignment(playerid, playerLevelPTD[playerid], 2);
	PlayerTextDrawColor(playerid, playerLevelPTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, playerLevelPTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, playerLevelPTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, playerLevelPTD[playerid], 255);
	PlayerTextDrawFont(playerid, playerLevelPTD[playerid], 2);
	PlayerTextDrawSetProportional(playerid, playerLevelPTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, playerLevelPTD[playerid], 0);	

	playerExamenPTD[playerid] = CreatePlayerTextDraw(playerid, 582.083435, 144.888854, "");
	PlayerTextDrawLetterSize(playerid, playerExamenPTD[playerid], 0.267500, 1.138518);
	PlayerTextDrawTextSize(playerid, playerExamenPTD[playerid], 0.000000, 98.000000);
	PlayerTextDrawAlignment(playerid, playerExamenPTD[playerid], 2);
	PlayerTextDrawColor(playerid, playerExamenPTD[playerid], -1);
	PlayerTextDrawUseBox(playerid, playerExamenPTD[playerid], 1);
	PlayerTextDrawBoxColor(playerid, playerExamenPTD[playerid], 52);
	PlayerTextDrawSetShadow(playerid, playerExamenPTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, playerExamenPTD[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, playerExamenPTD[playerid], 52);
	PlayerTextDrawFont(playerid, playerExamenPTD[playerid], 1);
	PlayerTextDrawSetProportional(playerid, playerExamenPTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, playerExamenPTD[playerid], 0);

	playerSpeedPTD[playerid] = CreatePlayerTextDraw(playerid, 581.250183, 333.629516, "");
	PlayerTextDrawLetterSize(playerid, playerSpeedPTD[playerid], 0.260416, 1.117778);
	PlayerTextDrawAlignment(playerid, playerSpeedPTD[playerid], 2);
	PlayerTextDrawColor(playerid, playerSpeedPTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, playerSpeedPTD[playerid], 1);
	PlayerTextDrawSetOutline(playerid, playerSpeedPTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, playerSpeedPTD[playerid], 255);
	PlayerTextDrawFont(playerid, playerSpeedPTD[playerid], 1);
	PlayerTextDrawSetProportional(playerid, playerSpeedPTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, playerSpeedPTD[playerid], 1);

	serverDealerPTD[playerid][0] = CreatePlayerTextDraw(playerid, 202.666656, 307.948120, "");
	PlayerTextDrawLetterSize(playerid, serverDealerPTD[playerid][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, serverDealerPTD[playerid][0], 90.000000, 90.000000);
	PlayerTextDrawAlignment(playerid, serverDealerPTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, serverDealerPTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, serverDealerPTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, serverDealerPTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, serverDealerPTD[playerid][0], 0);
	PlayerTextDrawFont(playerid, serverDealerPTD[playerid][0], 5);
	PlayerTextDrawSetProportional(playerid, serverDealerPTD[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, serverDealerPTD[playerid][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, serverDealerPTD[playerid][0], 509);
	PlayerTextDrawSetPreviewRot(playerid, serverDealerPTD[playerid][0], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetPreviewVehCol(playerid, serverDealerPTD[playerid][0], 1, 1);
	 
	serverDealerPTD[playerid][1] = CreatePlayerTextDraw(playerid, 248.666641, 372.933349, "Monster Truck A");
	PlayerTextDrawLetterSize(playerid, serverDealerPTD[playerid][1], 0.303000, 1.289999);
	PlayerTextDrawAlignment(playerid, serverDealerPTD[playerid][1], 2);
	PlayerTextDrawColor(playerid, serverDealerPTD[playerid][1], -1);	
	PlayerTextDrawSetShadow(playerid, serverDealerPTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, serverDealerPTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, serverDealerPTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, serverDealerPTD[playerid][1], 0);
	PlayerTextDrawSetProportional(playerid, serverDealerPTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, serverDealerPTD[playerid][1], 0);
	 
	serverDealerPTD[playerid][2] = CreatePlayerTextDraw(playerid, 303.866882, 320.830047, "Price: ~G~$400.000~W~~H~~N~Stock: ~R~250~W~~H~~N~Max Speed: ~R~120KM/H");
	PlayerTextDrawLetterSize(playerid, serverDealerPTD[playerid][2], 0.179500, 1.240000);
	PlayerTextDrawAlignment(playerid, serverDealerPTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, serverDealerPTD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, serverDealerPTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, serverDealerPTD[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, serverDealerPTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, serverDealerPTD[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, serverDealerPTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, serverDealerPTD[playerid][2], 0);

	wantedTD[playerid] = CreatePlayerTextDraw(playerid, 553.999877, 124.874084, "Nivel wanted actual: ~y~%d~n~~w~~h~Scade un nivel in: ~y~%d min.");
	PlayerTextDrawLetterSize(playerid, wantedTD[playerid], 0.211999, 1.056593);
	PlayerTextDrawAlignment(playerid, wantedTD[playerid], 2);
	PlayerTextDrawColor(playerid, wantedTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, wantedTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, wantedTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, wantedTD[playerid], 61);
	PlayerTextDrawFont(playerid, wantedTD[playerid], 1);
	PlayerTextDrawSetProportional(playerid, wantedTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, wantedTD[playerid], 0);

	fareTD[playerid] = CreatePlayerTextDraw(playerid, 33.265197, 305.083160, ""); 
	PlayerTextDrawLetterSize(playerid, fareTD[playerid], 0.321155, 1.308333);
	PlayerTextDrawAlignment(playerid, fareTD[playerid], 1);
	PlayerTextDrawColor(playerid, fareTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, fareTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, fareTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, fareTD[playerid], 255);
	PlayerTextDrawFont(playerid, fareTD[playerid], 3);
	PlayerTextDrawSetProportional(playerid, fareTD[playerid], 1);

	warTD[playerid] = CreatePlayerTextDraw(playerid, 550.500000, 305.111236, "War System~n~Grove Street - The Ballas~n~Score:3 - Score:4~n~Kills: 3 - Deaths:4~n~Score:4");
	PlayerTextDrawLetterSize(playerid, warTD[playerid], 0.339000, 1.338666);
	PlayerTextDrawTextSize(playerid, warTD[playerid], 0.000000, 176.000000);
	PlayerTextDrawAlignment(playerid, warTD[playerid], 2);
	PlayerTextDrawColor(playerid, warTD[playerid], -1);
	PlayerTextDrawUseBox(playerid, warTD[playerid], 1);
	PlayerTextDrawBoxColor(playerid, warTD[playerid], 255);
	PlayerTextDrawSetShadow(playerid, warTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, warTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, warTD[playerid], 255);
	PlayerTextDrawFont(playerid, warTD[playerid], 3);
	PlayerTextDrawSetProportional(playerid, warTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, warTD[playerid], 0);

	jailTimeTD[playerid] = CreatePlayerTextDraw(playerid, 553.555236, 98.906677, "Jail time: ~r~20 minute");
	PlayerTextDrawLetterSize(playerid, jailTimeTD[playerid], 0.261333, 1.336176);
	PlayerTextDrawAlignment(playerid, jailTimeTD[playerid], 2);
	PlayerTextDrawColor(playerid, jailTimeTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, jailTimeTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, jailTimeTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, jailTimeTD[playerid], 255);
	PlayerTextDrawFont(playerid, jailTimeTD[playerid], 2);
	PlayerTextDrawSetProportional(playerid, jailTimeTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, jailTimeTD[playerid], 0);
	return true;
}

stock updateLevelBar(playerid)
{
	if(playerBarPTD[playerid] != INVALID_PLAYER_BAR_ID)
		DestroyPlayerProgressBar(playerid, playerBarPTD[playerid]);

	playerBarPTD[playerid] = CreatePlayerProgressBar(playerid, 38.0000, 302.0000, 97.5000, 3.2000, -65281, 1000);
	SetPlayerProgressBarMaxValue(playerid, playerBarPTD[playerid], (playerInfo[playerid][pLevel] * 3));
	SetPlayerProgressBarValue(playerid, playerBarPTD[playerid], playerInfo[playerid][pRespectPoints]);
	ShowPlayerProgressBar(playerid, playerBarPTD[playerid]);

	PlayerTextDrawSetString(playerid, playerLevelPTD[playerid], string_fast("Nivel %d (%d/%d RP)", playerInfo[playerid][pLevel], playerInfo[playerid][pRespectPoints], (playerInfo[playerid][pLevel] * 3)));
	PlayerTextDrawShow(playerid, playerLevelPTD[playerid]);
	return true;
}

stock destroyPlayerTextDraws(playerid)
{
	PlayerTextDrawDestroy(playerid, playerNamePTD[playerid]);
	PlayerTextDrawDestroy(playerid, playerLevelPTD[playerid]);
	PlayerTextDrawDestroy(playerid, playerSpeedPTD[playerid]);
	PlayerTextDrawDestroy(playerid, serverDealerPTD[playerid][0]);
	PlayerTextDrawDestroy(playerid, serverDealerPTD[playerid][1]);
	PlayerTextDrawDestroy(playerid, serverDealerPTD[playerid][2]);	
	PlayerTextDrawDestroy(playerid, wantedTD[playerid]);
	PlayerTextDrawDestroy(playerid, fareTD[playerid]);
	PlayerTextDrawDestroy(playerid, warTD[playerid]);
	DestroyPlayerProgressBar(playerid, playerBarPTD[playerid]);
	return true;
}

stock serverTextDraws()
{
	serverNameTD = TextDrawCreate(638.899658, 433.266723, "rpg.fromzero.ro");
	TextDrawLetterSize(serverNameTD, 0.363000, 1.490000);
	TextDrawAlignment(serverNameTD, 3);
	TextDrawColor(serverNameTD, -1);
	TextDrawSetShadow(serverNameTD, 0);
	TextDrawSetOutline(serverNameTD, 1);
	TextDrawBackgroundColor(serverNameTD, 255);
	TextDrawFont(serverNameTD, 3);
	TextDrawSetProportional(serverNameTD, 1);
	TextDrawSetShadow(serverNameTD, 0);

	serverDateTD = TextDrawCreate(576.333557, 9.599999, "");
	TextDrawLetterSize(serverDateTD, 0.355333, 1.467259);
	TextDrawAlignment(serverDateTD, 2);
	TextDrawColor(serverDateTD, -1);
	TextDrawSetShadow(serverDateTD, 0);
	TextDrawSetOutline(serverDateTD, 1);
	TextDrawBackgroundColor(serverDateTD, 255);
	TextDrawFont(serverDateTD, 3);
	TextDrawSetProportional(serverDateTD, 1);
	TextDrawSetShadow(serverDateTD, 0);

	serverInfoTD = TextDrawCreate(399.333038, 11.629631, "");
	TextDrawLetterSize(serverInfoTD, 0.250666, 1.128592);
	TextDrawAlignment(serverInfoTD, 2);
	TextDrawColor(serverInfoTD, -1);
	TextDrawSetShadow(serverInfoTD, 0);
	TextDrawSetOutline(serverInfoTD, 1);
	TextDrawBackgroundColor(serverInfoTD, 255);
	TextDrawFont(serverInfoTD, 1);
	TextDrawSetProportional(serverInfoTD, 1);
	TextDrawSetShadow(serverInfoTD, 0);

	serverDealerTD[0] = TextDrawCreate(319.866424, 316.933319, "box");
	TextDrawLetterSize(serverDealerTD[0], 0.000000, 9.213327);
	TextDrawTextSize(serverDealerTD[0], 0.000000, 229.800018);
	TextDrawAlignment(serverDealerTD[0], 2);
	TextDrawColor(serverDealerTD[0], -1);
	TextDrawUseBox(serverDealerTD[0], 1);
	TextDrawBoxColor(serverDealerTD[0], 80);
	TextDrawSetShadow(serverDealerTD[0], 0);
	TextDrawSetOutline(serverDealerTD[0], 0);
	TextDrawBackgroundColor(serverDealerTD[0], 255);
	TextDrawFont(serverDealerTD[0], 1);
	TextDrawSetProportional(serverDealerTD[0], 1);
	TextDrawSetShadow(serverDealerTD[0], 0);
	 
	serverDealerTD[1] = TextDrawCreate(214.333358, 349.288909, "<");
	TextDrawLetterSize(serverDealerTD[1], 0.314999, 1.450000);
	TextDrawTextSize(serverDealerTD[1], 5.000000, 10.000000);
	TextDrawAlignment(serverDealerTD[1], 2);
	TextDrawColor(serverDealerTD[1], -1);
	TextDrawUseBox(serverDealerTD[1], 0);
	TextDrawBoxColor(serverDealerTD[1], 255);
	TextDrawSetShadow(serverDealerTD[1], 1);
	TextDrawSetOutline(serverDealerTD[1], 0);
	TextDrawBackgroundColor(serverDealerTD[1], 255);
	TextDrawFont(serverDealerTD[1], 1);
	TextDrawSetProportional(serverDealerTD[1], 1);
	TextDrawSetShadow(serverDealerTD[1], 1);
	TextDrawSetSelectable(serverDealerTD[1], true);
	 
	serverDealerTD[2] = TextDrawCreate(282.333374, 349.288909, ">");
	TextDrawLetterSize(serverDealerTD[2], 0.314999, 1.450000);
	TextDrawTextSize(serverDealerTD[2], 5.000000, 10.000000);
	TextDrawAlignment(serverDealerTD[2], 2);
	TextDrawColor(serverDealerTD[2], -1);
	TextDrawUseBox(serverDealerTD[2], 0);
	TextDrawBoxColor(serverDealerTD[2], 255);
	TextDrawSetShadow(serverDealerTD[2], 1);
	TextDrawSetOutline(serverDealerTD[2], 0);
	TextDrawBackgroundColor(serverDealerTD[2], 255);
	TextDrawFont(serverDealerTD[2], 1);
	TextDrawSetProportional(serverDealerTD[2], 1);
	TextDrawSetShadow(serverDealerTD[2], 1);
	TextDrawSetSelectable(serverDealerTD[2], true);
	 
	serverDealerTD[3] = TextDrawCreate(319.866424, 316.933319, "box");
	TextDrawLetterSize(serverDealerTD[3], 0.000000, -0.126672);
	TextDrawTextSize(serverDealerTD[3], 0.000000, 229.800018);
	TextDrawAlignment(serverDealerTD[3], 2);
	TextDrawColor(serverDealerTD[3], -1);
	TextDrawUseBox(serverDealerTD[3], 1);
	TextDrawBoxColor(serverDealerTD[3], 80);
	TextDrawSetShadow(serverDealerTD[3], 0);
	TextDrawSetOutline(serverDealerTD[3], 0);
	TextDrawBackgroundColor(serverDealerTD[3], 255);
	TextDrawFont(serverDealerTD[3], 1);
	TextDrawSetProportional(serverDealerTD[3], 1);
	TextDrawSetShadow(serverDealerTD[3], 0);
	 
	serverDealerTD[4] = TextDrawCreate(319.866424, 400.934173, "box");
	TextDrawLetterSize(serverDealerTD[4], 0.000000, -0.126672);
	TextDrawTextSize(serverDealerTD[4], 0.000000, 229.800018);
	TextDrawAlignment(serverDealerTD[4], 2);
	TextDrawColor(serverDealerTD[4], -1);
	TextDrawUseBox(serverDealerTD[4], 1);
	TextDrawBoxColor(serverDealerTD[4], 80);
	TextDrawSetShadow(serverDealerTD[4], 0);
	TextDrawSetOutline(serverDealerTD[4], 0);
	TextDrawBackgroundColor(serverDealerTD[4], 255);
	TextDrawFont(serverDealerTD[4], 1);
	TextDrawSetProportional(serverDealerTD[4], 1);
	TextDrawSetShadow(serverDealerTD[4], 0);
	 
	serverDealerTD[5] = TextDrawCreate(297.966735, 317.403625, "box");
	TextDrawLetterSize(serverDealerTD[5], 0.000000, 9.128344);
	TextDrawTextSize(serverDealerTD[5], 0.000000, -1.900001);
	TextDrawAlignment(serverDealerTD[5], 2);
	TextDrawColor(serverDealerTD[5], -1);
	TextDrawUseBox(serverDealerTD[5], 1);
	TextDrawBoxColor(serverDealerTD[5], 150);
	TextDrawSetShadow(serverDealerTD[5], 0);
	TextDrawSetOutline(serverDealerTD[5], 0);
	TextDrawBackgroundColor(serverDealerTD[5], 255);
	TextDrawFont(serverDealerTD[5], 1);
	TextDrawSetProportional(serverDealerTD[5], 1);
	TextDrawSetShadow(serverDealerTD[5], 0);
	 
	serverDealerTD[6] = TextDrawCreate(367.399353, 391.519683, "BUY");
	TextDrawLetterSize(serverDealerTD[6], 0.209666, 0.893408);
	TextDrawTextSize(serverDealerTD[6], 5.000000, 134.830642);
	TextDrawAlignment(serverDealerTD[6], 2);
	TextDrawColor(serverDealerTD[6], -1);
	TextDrawUseBox(serverDealerTD[6], 1);
	TextDrawBoxColor(serverDealerTD[6], -2147483393);
	TextDrawSetShadow(serverDealerTD[6], 0);
	TextDrawSetOutline(serverDealerTD[6], 0);
	TextDrawBackgroundColor(serverDealerTD[6], 255);
	TextDrawFont(serverDealerTD[6], 1);
	TextDrawSetProportional(serverDealerTD[6], 1);
	TextDrawSetShadow(serverDealerTD[6], 0);
	TextDrawSetSelectable(serverDealerTD[6], true);
	 
	serverDealerTD[7] = TextDrawCreate(367.399353, 379.118927, "TEST DRIVE");
	TextDrawLetterSize(serverDealerTD[7], 0.209666, 0.893408);
	TextDrawTextSize(serverDealerTD[7], 5.000000, 134.830642);
	TextDrawAlignment(serverDealerTD[7], 2);
	TextDrawColor(serverDealerTD[7], -1);
	TextDrawUseBox(serverDealerTD[7], 1);
	TextDrawBoxColor(serverDealerTD[7], -2139094785);
	TextDrawSetShadow(serverDealerTD[7], 0);
	TextDrawSetOutline(serverDealerTD[7], 0);
	TextDrawBackgroundColor(serverDealerTD[7], 255);
	TextDrawFont(serverDealerTD[7], 1);
	TextDrawSetProportional(serverDealerTD[7], 1);
	TextDrawSetShadow(serverDealerTD[7], 0);
	TextDrawSetSelectable(serverDealerTD[7], true);

	serverDealerTD[8] = TextDrawCreate(367.399353, 366.718171, "EXIT");
	TextDrawLetterSize(serverDealerTD[8], 0.209666, 0.893408);
	TextDrawTextSize(serverDealerTD[8], 5.000000, 134.830642);
	TextDrawAlignment(serverDealerTD[8], 2);
	TextDrawColor(serverDealerTD[8], -1);
	TextDrawUseBox(serverDealerTD[8], 1);
	TextDrawBoxColor(serverDealerTD[8], -2147483393); 
	TextDrawSetShadow(serverDealerTD[8], 0);
	TextDrawSetOutline(serverDealerTD[8], 0);
	TextDrawBackgroundColor(serverDealerTD[8], 255);
	TextDrawFont(serverDealerTD[8], 1);
	TextDrawSetProportional(serverDealerTD[8], 1);
	TextDrawSetShadow(serverDealerTD[8], 0);
	TextDrawSetSelectable(serverDealerTD[8], true);
	return true;
}

stock destroyServerTextDraws()
{
	TextDrawDestroy(serverNameTD);
	TextDrawDestroy(serverDateTD);
	TextDrawDestroy(serverInfoTD);
	for(new i = 0; i < 8; i++) TextDrawDestroy(serverDealerTD[i]);
	return true;
}

stock formatNumber(number) 
{
	gString[0] = (EOS);
	format(gString, sizeof(gString), "%d", number);
	if(strlen(gString) < 4) return gString;
	for(new i = (strlen(gString) - 3); i > 0; i -= 3) strins(gString, ".", i);
	return gString;
}

stock strmatch(stringone[], stringtwo[]) 
{
	if((strcmp(stringone, stringtwo, true, strlen(stringtwo)) == 0) && (strlen(stringone) == strlen(stringtwo))) return true;
	return false;
}

stock update(const text[], va_args<>)
{
	gQuery[0] = (EOS);
	va_format(gQuery, 256, text, va_start<1>);
	return mysql_tquery(SQL, gQuery);
}

stock isValidEmail(const email[])
{
	if(strlen(email) < 8 || strlen(email) > 128)
		return false;

    new at_pos = strfind(email, "@", true);
    if(at_pos >= 1)
    {
        new offset = (at_pos + 1), dot_pos = strfind(email, ".", true, offset);
        
        if(dot_pos > offset)
        	return true;
    }
    return false;
}

stock isPlayerLogged(playerid)
{
	if(Iter_Contains(Player, playerid) && playerInfo[playerid][pLogged] == true) return true;
	return false;
}

stock resetVars(playerid)
{
	GetPlayerName(playerid, playerInfo[playerid][pName], MAX_PLAYER_NAME);
		
	playerInfo[playerid][pLogged] = false;
	playerInfo[playerid][pLoginEnabled] = false;
	playerInfo[playerid][pFlymode] = false;
	playerInfo[playerid][pMark] = false;

	playerInfo[playerid][pLoginTries] = 0;
	playerInfo[playerid][pGender] = 1;
	playerInfo[playerid][pTutorial] = false;
	playerInfo[playerid][pAdmin] = 0;
	playerInfo[playerid][pHelper] = 0;
	playerInfo[playerid][pRespectPoints] = 0;
	playerInfo[playerid][pLevel] = 1;
	playerInfo[playerid][pMoney] = 2500;
	playerInfo[playerid][pBank] = 5000;
	playerInfo[playerid][pMute] = 0;
	playerInfo[playerid][pHours] = 0;
	playerInfo[playerid][pSeconds] = 0;
	playerInfo[playerid][pAFKSeconds] = 0;
	playerInfo[playerid][pLastPosX] = 0.0;
	playerInfo[playerid][pLastPosY] = 0.0;
	playerInfo[playerid][pLastPosZ] = 0.0;
	playerInfo[playerid][pDrivingLicense] = 0;
	playerInfo[playerid][pDrivingLicenseSuspend] = 0;
	playerInfo[playerid][pFlyLicense] = 0;
	playerInfo[playerid][pFlyLicenseSuspend] = 0;
	playerInfo[playerid][pBoatLicense] = 0;
	playerInfo[playerid][pBoatLicenseSuspend] = 0;
	playerInfo[playerid][pWeaponLicense] = 0;
	playerInfo[playerid][pWeaponLicenseSuspend] = 0;
	playerInfo[playerid][pWarn] = 0;
	playerInfo[playerid][pMarkX] = 0.0;
	playerInfo[playerid][pMarkY] = 0.0;
	playerInfo[playerid][pMarkZ] = 0.0;
	playerInfo[playerid][pReportChat] = INVALID_PLAYER_ID;
	playerInfo[playerid][pVehicleSlots] = 2;
	playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
	playerInfo[playerid][pCheckpointID] = -1;
	playerInfo[playerid][pinVehicle] = -1;
	playerInfo[playerid][pCuffed] = 0;
	playerInfo[playerid][pTazer] = 0;
	playerInfo[playerid][pAnimLooping] = 0;
	playerInfo[playerid][pTaxiDuty] = 0;
	playerInfo[playerid][pTaxiFare] = 0;
	playerInfo[playerid][pLiveOffer] = -1;
	playerInfo[playerid][pTalkingLive] = -1;
	format(playerInfo[playerid][pQuestionText], 4, "None");
	playerInfo[playerid][pInLesson] = 0;
	playerInfo[playerid][pLesson] = 0;
	playerInfo[playerid][pLicense] = 0;
	playerInfo[playerid][pLicenseOffer] = -1;
	playerInfo[playerid][pShowTurfs] = 0;
	playerInfo[playerid][pSafeID] = -1;
	playerInfo[playerid][pSelectedItem] = -1;
	playerInfo[playerid][pOnTurf] = 0;

	if(IsValidVehicle(playerInfo[playerid][pExamenVehicle])) DestroyVehicle(playerInfo[playerid][pExamenVehicle]);

	playerInfo[playerid][pExamenVehicle] = INVALID_VEHICLE_ID;
	playerInfo[playerid][pExamenCheckpoint] = 0;

	DeletePVar(playerid, "muteDeelay");
	DeletePVar(playerid, "banDeelay");
	DeletePVar(playerid, "unbanDeelay");
	DeletePVar(playerid, "warnDeelay");
	DeletePVar(playerid, "unWarnDeelay");
	DeletePVar(playerid, "kickDeelay");
	DeletePVar(playerid, "LabelVW");
	DeletePVar(playerid, "LabelInt");
	SetPlayerScore(playerid, playerInfo[playerid][pLevel]);
	playerTextDraws(playerid);
	InitFly(playerid);
	return true;
}

stock getVehicleHealth(vehicleid) {
	new Float:health;
	GetVehicleHealth(vehicleid, health);
	return floatround(health);
}

stock getVehicleSpeed(vehicleid,mode = 1) {
    new Float: x, Float: y, Float: z;
    GetVehicleVelocity(vehicleid , x , y , z);
    printf("%f,%f,%f", x,y,z);
    printf("x%f*%f=%d", x,x,x*x);
    printf("y%f*%f=%d", y,y,y*y);
    printf("z%f*%f=%d", z,z,z*z);
    printf("%d", (x*x)+(y*y)+(z*z));

    return floatround(((floatsqroot(((x*x)+(y*y)+(z*z)))*(!mode ? 105.0 : 170.0 )))*1);
}

stock sendPlayerError(playerid, const text[], va_args<>)
{
	gString[0] = (EOS);
	va_format(gString, sizeof gString, "Eroare: {FFFFFF}%s", text, va_start<2>);
	return SCM(playerid, COLOR_ERROR, gString);
}

stock sendPlayerSyntax(playerid, const text[], va_args<>)
{
	gString[0] = (EOS);
	va_format(gString, sizeof gString, "Sintaxa: {FFFFFF}%s", text, va_start<2>);
	return SCM(playerid, COLOR_SYNTAX, gString);
}

stock clearChat(playerid, lines = 20)
{
	for(new i = 0; i < lines; i++) SCM(playerid, -1, "");
	return true;
}

stock getDateTime()
{
	new hour, minute, second, year, month, day;
	gettime(hour, minute, second); getdate(year, month, day);
	gString[0] = (EOS);
	va_format(gString, sizeof(gString), "%02d:%02d - %02d/%02d/%d", hour, minute, day, month, year);
	return gString;
}
stock sendAdmin(color, const text[], va_args<>)
{
	gString[0] = (EOS);
	va_format(gString, 256, text, va_start<2>);
	foreach(new playerid : ServerAdmins) SCM(playerid, color, gString);
	return true;
}

stock sendHelper(color, const text[], va_args<>)
{
	gString[0] = (EOS);
	va_format(gString, 256, text, va_start<2>);
	foreach(new playerid : ServerHelpers)  SCM(playerid, color, gString);
	return true;
}

stock sendStaff(color, const text[], va_args<>)
{
	gString[0] = (EOS);
	va_format(gString, 256, text, va_start<2>);
	foreach(new playerid : ServerStaff)  SCM(playerid, color, gString);
	return true;
}

stock oocNews(color, const text[], va_args<>) {
	gString[0] = (EOS);
	va_format(gString, 256, text, va_start<2>);
	foreach(new playerid : Player) {
		if(playerInfo[playerid][pLiveToggle] == 0) SCM(playerid, color, gString);
	}
	return true;
}

stock GetClosestVehicle(playerid, dontsearchthis = INVALID_VEHICLE_ID) {
	new Float:distance = 0.0, target = -1;
	foreach(new i : Vehicle) {
		if(i != dontsearchthis && (target < 0 || distance > GetDistancePlayerToVeh(playerid, i))) {
			target = i;
			distance = GetDistancePlayerToVeh(playerid, i);
		}
	}
	return target;
}

stock GetDistancePlayerToVeh(playerid, vehicleid) {
	new Float:x, Float:y, Float:z, Float:_x, Float:_y, Float:_z;
	GetPlayerPos(playerid, x, y, z);
	GetVehiclePos(vehicleid, _x, _y, _z);	
	return floatround(floatsqroot((_x - x) * (_x - x) * (_y - y) * (_y - y) * (_z -  z) * (_z - z)));
}

stock Calculate(seconds)
{
	new hour, minute, second;
	if(seconds < 3600)
	{
		seconds = seconds % 3600;
		minute = seconds / 60;
		seconds = seconds % 60;
		second = seconds;
		return string_fast("%02d:%02d", minute, second);
	}

	hour = seconds / 3600;
	seconds = seconds % 3600;
	minute = seconds / 60;
	seconds = seconds % 60;
	second = seconds;
	return spritnf("%02d:%02d:%02d", hour, minute, second);
}

stock IsNumeric(const string[]) {
    for (new i = 0, j = strlen(string); i < j; i++) {
        if (string[i] > '9' || string[i] < '0') return 0;
    }
    return true;
}

stock examenFail(playerid) {
	if(IsValidVehicle(playerInfo[playerid][pExamenVehicle])) DestroyVehicle(playerInfo[playerid][pExamenVehicle]);
	DisablePlayerCheckpoint(playerid);
	playerInfo[playerid][pExamenCheckpoint] = 0;
	PlayerTextDrawHide(playerid, playerExamenPTD[playerid]);
	SetPlayerPos(playerid, 1286.1072,-1349.8607,13.5684);
	SetPlayerVirtualWorld(playerid, 0);
	SCM(playerid, COLOR_AQUA, "DMV Exam: {ffffff} Ai picat examenul auto.");
	return true;
}

stock kickPlayer(playerid, adminid, silent,  const reason[]) {
	new adminName[MAX_PLAYER_NAME] = "AdmBot";
	if(adminid != INVALID_PLAYER_ID)  {
		GetPlayerName(adminid, adminName, 24);
		SetPVarInt(adminid, "kickDeelay", (gettime() +60));
	}
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof gQuery, "INSERT INTO `server_kick_logs` (PlayerName, PlayerID, AdminName, AdminID, Reason, Date) VALUES('%s', '%d', '%s', '%d', '%s', '%s')", getName(playerid), playerInfo[playerid][pSQLID], adminName, (adminid == INVALID_PLAYER_ID) ? (0) : (playerInfo[adminid][pSQLID]), (silent) ? ("(silent) ") : (""), reason, getDateTime());
	mysql_pquery(SQL, gQuery, "", "");
	if(!silent) va_SendClientMessageToAll(COLOR_LIGHTRED, "AdmCmd: %s a primit kick de la administratorul %s, motiv: %s", getName(playerid), adminName, reason);
	SCM(playerid, COLOR_GREY, "* Ai primit kick.");
	defer kickEx(playerid);
	return true;
}

stock IsSeatTaked(vehicleid, seatid) {
	foreach(new playerid : Player) {
		if(IsPlayerInVehicle(playerid, vehicleid) && GetPlayerVehicleSeat(playerid) == seatid) return true;
	}
	return false;
}

stock getWeaponName(weapon_id) {
	gString[0] = (EOS);
	GetWeaponName(weapon_id, gString, 32);
	return gString;
}

stock GetPlayerWeapons(playerid) {
	new x = 0, weapons[13], ammo[13];
	for(new i = 1; i <= 12; i++) {
		GetPlayerWeaponData(playerid, i, weapons[i], ammo[i]);
		if(weapons[i]) x ++;
	}
	return true;
}

stock PlayerHaveReport(playerid) {
	new bool: haveReport = false;
	foreach(new x : Reports) {
		if(reportInfo[x][reportID] == playerid) {
			haveReport = true;
			break;
		}
	}
	return haveReport;
}

stock GetReportID(playerid) {
	new id = INVALID_PLAYER_ID;
	foreach(new x : Reports) {
		if(reportInfo[x][reportID] == playerid) {
			id = x;
			break;
		}
	}
	return id;
}

stock GetPlayerID(playerName[]) {
  	foreach(new i : loggedPlayers) {
    	if(IsPlayerConnected(i) && playerInfo[i][pLogged] == true) {
      		if(strcmp(playerInfo[i][pName], playerName, true) == 0) return i;
    	}
  	}
  	return INVALID_PLAYER_ID;
}

stock slapPlayer(playerid) {
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	SetPlayerPos(playerid, x, y, z + 5);
	return 1;
}

stock sendToAdmin(playerid, color, const text[], &level, va_args<>) {
	if(!Iter_Contains(ServerAdmins, playerid)) return true;
	if(playerInfo[playerid][pAdmin] < level) return true;
	gString[0] = (EOS);
	va_format(gString, 256, text, va_start<3>);
	sendSplitMessage(playerid, color, gString);
	return true;
}

IsPlayerInArea(playerid, Float:MinX, Float:MinY, Float:MaxX, Float:MaxY) {
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	if(X >= MinX && X <= MaxX && Y >= MinY && Y <= MaxY) return 1;
	return 0;
}

stock SetPlayerHealthEx(playerid, Float:health) {
	SetPlayerHealth(playerid, health);
	playerInfo[playerid][pHealth] = health;
	return true;
}
stock GetPlayerHealthEx(playerid, &Float:health) {
	health = playerInfo[playerid][pHealth];
	return 1;
}
stock SetPlayerArmourEx(playerid, Float:armour) {
	SetPlayerArmour(playerid, armour);
	playerInfo[playerid][pArmour] =  armour;
	return true;
}
stock GetPlayerArmourEx(playerid, &Float:armour) {
	armour = playerInfo[playerid][pArmour];
	return 1;
}
stock resetWeapons(playerid) {
	ResetPlayerWeapons(playerid);
	for(new i = 0; i < 47; i++) {
		Weapons[playerid][i] = 0;
		WeaponAmmo[playerid][i] = 0;
	}
	return 1;
}
stock getWeaponSlot(weaponid) {
	new slot;
	switch(weaponid) {
		case 0,1: slot = 0;
		case 2 .. 9: slot = 1;
		case 10 .. 15: slot = 10;
		case 16 .. 18, 39: slot = 8;
		case 22 .. 24: slot =2;
		case 25 .. 27: slot = 3;
		case 28, 29, 32: slot = 4;
		case 30, 31: slot = 5;
		case 33, 34: slot = 6;
		case 35 .. 38: slot = 7;
		case 40: slot = 12;
		case 41 .. 43: slot = 9;
		case 44 .. 46: slot = 11;
	}
	return slot;
}
stock removeMaps(playerid) {
	RemoveBuildingForPlayer(playerid, 8229, 1142.0313, 1362.5000, 12.4844, 0.25);
	RemoveBuildingForPlayer(playerid, 1368, 1165.1719, 1222.8047, 10.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 1368, 1169.6250, 1222.8047, 10.5078, 0.25);
	RemoveBuildingForPlayer(playerid, 1300, 1163.0313, 1222.7969, 10.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1166.7969, 1223.2031, 14.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1161.5156, 1223.2031, 14.1016, 0.25);
	RemoveBuildingForPlayer(playerid, 1412, 1172.1094, 1223.2031, 14.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 1300, 1171.7813, 1222.7969, 10.1719, 0.25);
	return true;
}
function Float:GetDistanceBetweenPoints(Float:x1,Float:y1,Float:z1,Float:x2,Float:y2,Float:z2) return floatsqroot(floatpower(floatabs(floatsub(x2,x1)),2)+floatpower(floatabs(floatsub(y2,y1)),2)+floatpower(floatabs(floatsub(z2,z1)),2));

stock PlayerMoney(playerid, amount) return GetPlayerCash(playerid) < amount ? (true) : (false);

stock Value64Bit(ammount_store, ammount_more, value[]) {
	if(ammount_store == 0) format(value, 128, "#%d", ammount_more);
	else format(value, 128, "#%d%09d", ammount_store, ammount_more);
}

stock GetCashStr(playerid) {
	new rezult[64], string[128];
	Value64Bit(StoreMoney[playerid], MoneyMoney[playerid], string);
	format(rezult, 64, formatNumbers2(string));
	return rezult;
}

stock FormatBigInt(ammount_store, ammount_more) {
	new rezult[70], values[64];
	Value64Bit(ammount_store, ammount_more, values);
	format(rezult, 70, formatNumbers2(values));
	return rezult;
}

stock GetBankMoney(playerid) {
	new string[64], rezult[64];
	Value64Bit(playerInfo[playerid][pStoreBank], playerInfo[playerid][pBank], string);
	format(rezult, 64, formatNumbers2(string));
	return rezult;
}

stock Add64Bit(&ammount_store, &ammount_more, value) {
	if(value == 0) return true;
	new rest = 0;
	new allowed = 2000000000-ammount_more;
	if(value <= allowed) ammount_more += value;
	else ammount_more += allowed, value -= allowed, rest = value;
	if(ammount_more >= 1000000000) {
		ammount_more -= 1000000000;
		ammount_store++;
	}
	else if(ammount_store > 0 && ammount_more < 1000000000) {
		ammount_store--;
		ammount_more+= 1000000000;
	}
	if(rest > 0) {
		if(ammount_more+rest > 2000000000) allowed = 2000000000-ammount_more, ammount_more += allowed, rest -= allowed;
		else ammount_more += rest, rest = 0;
	}
	for(new i = 0; i < 3; i++) {
		if(ammount_more >= 1000000000) {
			ammount_more -= 1000000000;
			ammount_store++;
		}	
	}
	if(ammount_more < 0) ammount_more = 0;
	return true;
}


stock GivePlayerCash(playerid, type, money) {
	switch(type) {
		case 0: Add64Bit(StoreMoney[playerid], MoneyMoney[playerid], -money);/* ArataMoney(playerid, 1, money);*/
		case 1: Add64Bit(StoreMoney[playerid], MoneyMoney[playerid], money); /*ArataMoney(playerid, 0, money);*/
 	}
 	updatePlayer(playerid);
	return true;
}

function updatePlayer(playerid) {
	ResetMoneyBar(playerid);
	switch(StoreMoney[playerid]) {
		case 0: UpdateMoneyBar(playerid, MoneyMoney[playerid]);
		case 1: UpdateMoneyBar(playerid, MoneyMoney[playerid]+1000000000);
		default: UpdateMoneyBar(playerid, 2147483647);
	}
	return true;
}

stock GetPlayerCash(playerid) {
	new money;
	switch(StoreMoney[playerid]) {
		case 0: money = MoneyMoney[playerid];
		case 1: money = MoneyMoney[playerid] + 1000000000;
		default: money = 2147483647;
	}
	return money;
}
GivePlayerBank(playerid, amount) return Add64Bit(playerInfo[playerid][pStoreBank], playerInfo[playerid][pBank], amount);
GetPlayerBank(playerid) {
	if(playerInfo[playerid][pStoreBank] > 1) return 2000000000;
	return playerInfo[playerid][pBank] + 1000000000;
}
stock ResetPlayerCash(playerid) return StoreMoney[playerid] = 0, MoneyMoney[playerid] = 0;
stock CheckerBigInt(const BigInt[]) {
	new rchar[20];
	format(rchar, 20, "%s", BigInt);
	if(strfind(rchar, "-", true) != -1) {
		strmid(rchar, BigInt, 1, 20);
		if(!IsNumeric(rchar)) return true;
	}
	else if(!IsNumeric(BigInt)) return true;
	return false;
}
stock Translate32Bit(&store_money, &more_int, BigInt[]) {
	new value32[25], value64[10], int = 0, rchar[20];
	format(rchar, 20, "%s", BigInt);
	if(strfind(rchar, "-", true) != -1) int = 1;

	switch(int) {
		case 0: {
			if(strlen(BigInt) > 9) {
				strmid(value64, BigInt, 0, strlen(BigInt)-9);
				strmid(value32, BigInt, strlen(BigInt)-9, 25);
				store_money += strval(value64);
				Add64Bit(store_money, more_int, strval(value32));
			}
			else {
				new moneys[25];
				format(moneys, 25, "%d", strval(BigInt));
				Add64Bit(store_money, more_int, strval(moneys));
			}
		}
		case 1: {
			if(strlen(BigInt) > 10) {
				strmid(value64, BigInt, 1, strlen(BigInt)-9);
				strmid(value32, BigInt, strlen(BigInt)-9, 25);
				store_money -= strval(value64);
				Add64Bit(store_money, more_int, -strval(value32));
			}
			else Add64Bit(store_money, more_int, strval(BigInt));		
		}
	}
	return true;
}
formatNumbers(number) {

   new Str[15];
   format(Str, 15, "%d", number);
   if(strlen(Str) < sizeof(Str)) {
      if(number >= 1000 && number < 10000) strins( Str, ".", 1, sizeof(Str));
      else if(number >= 10000 && number < 100000) strins(Str, ".", 2, sizeof(Str));
      else if(number >= 100000 && number < 1000000) strins(Str, ".", 3, sizeof(Str));
      else if(number >= 1000000 && number < 10000000) strins(Str, ".", 1, sizeof(Str)),strins(Str, ".", 5, sizeof(Str));
      else if(number >= 10000000 && number < 100000000) strins(Str, ".", 2, sizeof(Str)),strins(Str, ".", 6, sizeof(Str));
      else if(number >= 100000000 && number < 1000000000) strins(Str, ".", 3, sizeof(Str)),strins(Str, ".", 7, sizeof(Str));
      else if(number >= 1000000000)
           strins(Str, ".", 1, sizeof(Str)),
           strins(Str, ".", 5, sizeof(Str)),
           strins(Str, ".", 9, sizeof(Str));
      else format(Str, 10, "%d", number);
   }
   return Str;
}
formatNumbers2(...)
{
	new Number[128], int_str = 0, firstchar[4];
	format(firstchar, sizeof firstchar, "%s", getarg(0, 0));
	if(strfind(firstchar, "#", true) == 0)
	{
		int_str = 1;
		new nr = 0;
		for(new i = 0; i < 128; i++)
		{
			Number[nr] = getarg(0, i); 
			nr++;
		}
	}	
	if(int_str == 1)
	{
		strdel(Number, 0, 1); 
		for(new i = strlen(Number) - 3; i > 0; i -= 3)
		{
			strins(Number, ".", i, strlen(Number));
		}
	}
	if(int_str == 0)
	{
		format(Number, sizeof Number, "%s", FormatIntNumber(getarg(0)));
	}
	return Number;
}

FormatIntNumber(Number, const Delimitator[] = ".")
{
    new Result[16], bool:NegativeNumber = false;

    if (Number < 0)
    {
        Number *= -1;
        NegativeNumber = true;
    }

    format(Result, sizeof(Result), "%i", Number);

    for (new i = strlen(Result) - 3; i > 0; i -= 3)
    {
        strins(Result, Delimitator, i);
    }

    if (NegativeNumber == true)
    {
        strins(Result, "", 0);
    }
	
    return Result;
}

formatNumberss(number[]) {
    new Str[25];
	format(Str, 25, "%s", number);
	switch(strlen(number)) {
		case 4: strins(Str, ".", 1, sizeof(Str));
		case 5: strins(Str, ".", 2, sizeof(Str));
		case 6: strins(Str, ".", 3, sizeof(Str));
		case 7: strins(Str, ".", 1, sizeof(Str)), strins(Str, ".", 5, sizeof(Str));
		case 8: strins(Str, ".", 2, sizeof(Str)), strins(Str, ".", 6, sizeof(Str));
		case 9: strins(Str, ".", 3, sizeof(Str)), strins(Str, ".", 7, sizeof(Str));
		case 10: strins(Str, ".", 1, sizeof(Str)), strins(Str, ".", 5, sizeof(Str)), strins(Str, ".", 9, sizeof(Str));
		case 11: strins(Str, ".", 2, sizeof(Str)), strins(Str, ".", 6, sizeof(Str)), strins(Str, ".", 10, sizeof(Str));
		case 12: strins(Str, ".", 3, sizeof(Str)), strins(Str, ".", 7, sizeof(Str)), strins(Str, ".", 11, sizeof(Str));
		case 13: strins(Str, ".", 1, sizeof(Str)), strins(Str, ".", 5, sizeof(Str)), strins(Str, ".", 9, sizeof(Str)), strins(Str, ".", 14, sizeof(Str));
		case 14: strins(Str, ".", 2, sizeof(Str)), strins(Str, ".", 6, sizeof(Str)), strins(Str, ".", 10, sizeof(Str)), strins(Str, ".", 15, sizeof(Str));
		case 15: strins(Str, ".", 3, sizeof(Str)), strins(Str, ".", 7, sizeof(Str)), strins(Str, ".", 11, sizeof(Str)), strins(Str, ".", 16, sizeof(Str));
		case 16: strins(Str, ".", 1, sizeof(Str)), strins(Str, ".", 5, sizeof(Str)), strins(Str, ".", 9, sizeof(Str)), strins(Str, ".", 14, sizeof(Str)), strins(Str, ".", 18, sizeof(Str));
		case 17: strins(Str, ".", 2, sizeof(Str)), strins(Str, ".", 6, sizeof(Str)), strins(Str, ".", 10, sizeof(Str)), strins(Str, ".", 15, sizeof(Str)), strins(Str, ".", 19, sizeof(Str));
		case 18: strins(Str, ".", 3, sizeof(Str)), strins(Str, ".", 7, sizeof(Str)), strins(Str, ".", 11, sizeof(Str)), strins(Str, ".", 16, sizeof(Str)), strins(Str, ".", 20, sizeof(Str));
		case 19: strins(Str, ".", 1, sizeof(Str)), strins(Str, ".", 5, sizeof(Str)), strins(Str, ".", 9, sizeof(Str)), strins(Str, ".", 14, sizeof(Str)), strins(Str, ".", 18, sizeof(Str)), strins(Str, ".", 22, sizeof(Str));
		case 20: strins(Str, ".", 2, sizeof(Str)), strins(Str, ".", 6, sizeof(Str)), strins(Str, ".", 10, sizeof(Str)), strins(Str, ".", 15, sizeof(Str)), strins(Str, ".", 19, sizeof(Str)), strins(Str, ".", 23, sizeof(Str));
		case 21: strins(Str, ".", 3, sizeof(Str)), strins(Str, ".", 7, sizeof(Str)), strins(Str, ".", 11, sizeof(Str)), strins(Str, ".", 16, sizeof(Str)), strins(Str, ".", 20, sizeof(Str)), strins(Str, ".", 24, sizeof(Str));
		case 22: strins(Str, ".", 1, sizeof(Str)), strins(Str, ".", 5, sizeof(Str)), strins(Str, ".", 9, sizeof(Str)), strins(Str, ".", 14, sizeof(Str)), strins(Str, ".", 18, sizeof(Str)), strins(Str, ".", 22, sizeof(Str)), strins(Str, ".", 26, sizeof(Str));
		case 23: strins(Str, ".", 2, sizeof(Str)), strins(Str, ".", 6, sizeof(Str)), strins(Str, ".", 10, sizeof(Str)), strins(Str, ".", 15, sizeof(Str)), strins(Str, ".", 19, sizeof(Str)), strins(Str, ".", 23, sizeof(Str)), strins(Str, ".", 27, sizeof(Str));
		case 24: strins(Str, ".", 3, sizeof(Str)), strins(Str, ".", 7, sizeof(Str)), strins(Str, ".", 11, sizeof(Str)), strins(Str, ".", 16, sizeof(Str)), strins(Str, ".", 20, sizeof(Str)), strins(Str, ".", 24, sizeof(Str)), strins(Str, ".", 28, sizeof(Str));
		default: format(Str, 25, "%s", number);
	}
	return Str;
}

stock missionName(playerid, type, id) {
	new string[65];
	switch(type) {
		case 0: format(string, sizeof(string), "Omoara %d jucatori la arena de paintball", playerInfo[playerid][pNeedProgress][id]);
		case 1: format(string, sizeof(string), "Prinde %d pesti", playerInfo[playerid][pNeedProgress][id]);
		case 2: format(string, sizeof(string), "Viziteaza muntele Chilliad");
		case 3: format(string, sizeof(string), "Viziteaza stadionul de baseball din Las Venturas");
		case 4: format(string, sizeof(string), "Viziteaza Dooks din Los Santos");
		case 5: format(string, sizeof(string), "Viziteaza intersectia autostrazii Los Santos - Las Venturas.");
	}
	return string;
}

stock DistanceToPlayer(playerid, targetid) {
	new Float: X, Float: Y, Float: Z;
	GetPlayerPos(targetid, X, Y, Z);
	return floatround(GetPlayerDistanceFromPoint(playerid, X, Y, Z));
}