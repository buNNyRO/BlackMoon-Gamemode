stock IsVehicleOccupied(vehicleid) {
	foreach(new i : PlayerInVehicle) if(IsPlayerInVehicle(i, vehicleid)) return true;
	return false;
}

stock string_fast(const varname[], va_args<>) {
    gFast[0] = (EOS);
    va_format(gFast, sizeof gFast, varname, va_start<1>);
    return gFast;
}

stock sendNearbyMessage(playerid, color, Float:distance, const text[], va_args<>)
{
	gString[0] = (EOS);
	va_format(gString, sizeof(gString), text, va_start<4>);

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	if(IsPlayerInRangeOfPoint(playerid, distance, x, y, z) && GetPlayerInterior(playerid) == GetPlayerInterior(playerid) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(playerid)) sendSplitMessage(playerid, color, gString);
	foreach(new i : StreamPlayer[playerid])
	{
		if(IsPlayerInRangeOfPoint(i, distance, x, y, z) && GetPlayerInterior(playerid) == GetPlayerInterior(i) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)) sendSplitMessage(i, color, gString);
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
		va_SendClientMessageToAll(COLOR_LIGHTRED, "AdmCmd: %s a primit ban 3 zile de la administratorul AdmBot, motiv: Acumulare 3/3 warns.", getName(playerid));	
		banPlayer(playerid, INVALID_PLAYER_ID, 3, "Acumulare 3/3 Warns");
	}

	update("UPDATE `server_users` SET `Warn` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pWarn], playerInfo[playerid][pSQLID]);
	SCMf(playerid, COLOR_GREY, "* Ai primit un warn pe motiv: %s", reason);

	update("INSERT INTO `server_warn_logs` (PlayerName, PlayerID, AdminName, AdminID, WarnReason) VALUES ('%s', '%d', '%s', '%d', '%s')", getName(playerid), playerInfo[playerid][pSQLID], adminName, (adminid != INVALID_PLAYER_ID) ? (playerInfo[adminid][pSQLID]) : (0), reason);
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

	update("INSERT INTO `server_bans` (PlayerName, PlayerID, AdminName, AdminID, Reason, Days, Permanent, Date) VALUES ('%s', '%d', '%s', '%d', '%s', '%d', '%d', '%s')", getName(playerid), playerInfo[playerid][pSQLID], adminName, (INVALID_PLAYER_ID == adminid) ? (0) : (playerInfo[adminid][pSQLID]), reason, days, (days == 0) ? (1) : (0), getDateTime());
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
	playerInfo[playerid][pMute] = gettime()+(minutes * 60);
	update("UPDATE `server_users` SET `Mute` = '%d' WHERE `ID` = '%d'", (minutes * 60), playerInfo[playerid][pSQLID]);

	if(!Iter_Contains(MutedPlayers, playerid))
		Iter_Add(MutedPlayers, playerid);

	update("INSERT INTO `server_mute_logs` (PlayerName, PlayerID, AdminName, AdminID, MuteReason, MuteMinutes) VALUES ('%s', '%d', '%s', '%d', '%s', '%d')", getName(playerid), playerInfo[playerid][pSQLID], adminName, (adminid != INVALID_PLAYER_ID) ? (playerInfo[adminid][pSQLID]) : (0), reason, minutes);
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
	SCMf(playerid, COLOR_SERVER, "------------------|{ffffff}%s's stats{cc66ff}|----------------------", getName(userID));
	SCMf(playerid, COLOR_SERVER, "Account: {ffffff}%s (%d) | Level: %d | Ore jucate: %0.1f | Warn-uri: %d/3 | Faction: %s (rank %d)", getName(userID), userID, playerInfo[userID][pLevel], playerInfo[userID][pHours], playerInfo[userID][pWarn], playerInfo[userID][pFaction] ? factionName(playerInfo[userID][pFaction]) : "None", playerInfo[userID][pFactionRank] ? playerInfo[userID][pFactionRank] : 0);
	SCMf(playerid, COLOR_SERVER, "Economy: {ffffff}Cash: %s$ | Banca: %s$ | Urmatorul nivel: $%s", GetCashStr(userID), GetBankMoney(userID), formatNumber(playerInfo[userID][pLevel] * 250));
	SCMf(playerid, COLOR_SERVER, "Points: {ffffff}Premium Points: %d | Puncte de respect: %d/%d", playerInfo[userID][pPremiumPoints], playerInfo[userID][pRespectPoints], (playerInfo[userID][pLevel] * 3));
	SCMf(playerid, COLOR_SERVER, "Other: {ffffff}Drugs:%d | Materiale:%s | Phone: %d | VIP: %s | Premium: %s", playerInfo[userID][pDrugs], formatNumber(playerInfo[userID][pMats]), playerInfo[userID][pPhone], playerInfo[userID][pVIP] ? "Yes" : "No", playerInfo[userID][pPremium] ? "Yes" : "No");
	if(playerInfo[userID][pAdmin]) {
		SCM(playerid, COLOR_SERVER, "------------------|{ffffff}Admin Statistics{cc66ff}|----------------------");
		SCMf(playerid, COLOR_SERVER, "Seconds: {ffffff}%0.f | Seconds AFK: %d | Virtual World: %d | Interior: %d | SQLID: %d | Admins: %d | Helpers: %d", playerInfo[userID][pSeconds], playerInfo[userID][pAFKSeconds], GetPlayerVirtualWorld(userID), GetPlayerInterior(userID), playerInfo[userID][pSQLID], Iter_Count(ServerAdmins), Iter_Count(ServerHelpers));
	}
	SCM(playerid, COLOR_SERVER, "----------------------------------------------------------------------------");
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

	if(playerInfo[userID][pCertificate][0] > 0) SCMf(playerid, COLOR_LIGHTRED, "Certificat 'ADR': Valid (%d zile)", playerInfo[userID][pCertificate][0]);
	
	SCM(playerid, COLOR_GREY, "----------------------------------------");
	return true;
}

stock playerTextDraws(playerid) {
	fishTD[playerid][0] = CreatePlayerTextDraw(playerid, 13.000073, 158.982315, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, fishTD[playerid][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, fishTD[playerid][0], 53.000000, 146.000000);
	PlayerTextDrawAlignment(playerid, fishTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, fishTD[playerid][0], 1581711742);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, fishTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, fishTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, fishTD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, fishTD[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][0], 0);

	fishTD[playerid][1] = CreatePlayerTextDraw(playerid, 14.000077, 159.882369, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, fishTD[playerid][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, fishTD[playerid][1], 51.000000, 103.000000);
	PlayerTextDrawAlignment(playerid, fishTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, fishTD[playerid][1], 454761471);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, fishTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, fishTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, fishTD[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, fishTD[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][1], 0);

	fishTD[playerid][2] = CreatePlayerTextDraw(playerid, 39.288986, 262.424652, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, fishTD[playerid][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, fishTD[playerid][2], 1.000000, 41.000000);
	PlayerTextDrawAlignment(playerid, fishTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, fishTD[playerid][2], 454761471);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, fishTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, fishTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, fishTD[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, fishTD[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][2], 0);

	fishTD[playerid][3] = CreatePlayerTextDraw(playerid, 5.999966, 276.171173, "");
	PlayerTextDrawLetterSize(playerid, fishTD[playerid][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, fishTD[playerid][3], 37.000000, 16.000000);
	PlayerTextDrawAlignment(playerid, fishTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, fishTD[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, fishTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, fishTD[playerid][3], 0);
	PlayerTextDrawFont(playerid, fishTD[playerid][3], 5);
	PlayerTextDrawSetProportional(playerid, fishTD[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][3], 0);
	PlayerTextDrawSetPreviewModel(playerid, fishTD[playerid][3], 19468);
	PlayerTextDrawSetPreviewRot(playerid, fishTD[playerid][3], 0.000000, 0.000000, 180.000000, 0.716272);

	fishTD[playerid][4] = CreatePlayerTextDraw(playerid, 13.444416, 259.544647, "");
	PlayerTextDrawLetterSize(playerid, fishTD[playerid][4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, fishTD[playerid][4], 29.000000, 34.000000);
	PlayerTextDrawAlignment(playerid, fishTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, fishTD[playerid][4], -1);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, fishTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, fishTD[playerid][4], 0);
	PlayerTextDrawFont(playerid, fishTD[playerid][4], 5);
	PlayerTextDrawSetProportional(playerid, fishTD[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][4], 0);
	PlayerTextDrawSetPreviewModel(playerid, fishTD[playerid][4], 19630);
	PlayerTextDrawSetPreviewRot(playerid, fishTD[playerid][4], 360.000000, 46.000000, 180.000000, 0.764951);

	fishTD[playerid][5] = CreatePlayerTextDraw(playerid, 35.777725, 260.242218, "");
	PlayerTextDrawLetterSize(playerid, fishTD[playerid][5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, fishTD[playerid][5], 34.000000, 36.000000);
	PlayerTextDrawAlignment(playerid, fishTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, fishTD[playerid][5], 202);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, fishTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, fishTD[playerid][5], 0);
	PlayerTextDrawFont(playerid, fishTD[playerid][5], 5);
	PlayerTextDrawSetProportional(playerid, fishTD[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][5], 0);
	PlayerTextDrawSetPreviewModel(playerid, fishTD[playerid][5], 18631);
	PlayerTextDrawSetPreviewRot(playerid, fishTD[playerid][5], 0.000000, 0.000000, 232.000000, 1.050069);

	fishTD[playerid][6] = CreatePlayerTextDraw(playerid, 14.211205, 292.789001, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, fishTD[playerid][6], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, fishTD[playerid][6], 51.000000, 11.000000);
	PlayerTextDrawAlignment(playerid, fishTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, fishTD[playerid][6], 454761471);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, fishTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, fishTD[playerid][6], 255);
	PlayerTextDrawFont(playerid, fishTD[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, fishTD[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][6], 0);

	fishTD[playerid][7] = CreatePlayerTextDraw(playerid, 25.111099, 291.648864, "13");
	PlayerTextDrawLetterSize(playerid, fishTD[playerid][7], 0.271555, 1.291377);
	PlayerTextDrawAlignment(playerid, fishTD[playerid][7], 2);
	PlayerTextDrawColor(playerid, fishTD[playerid][7], -1);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, fishTD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, fishTD[playerid][7], 255);
	PlayerTextDrawFont(playerid, fishTD[playerid][7], 2);
	PlayerTextDrawSetProportional(playerid, fishTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][7], 0);

	fishTD[playerid][8] = CreatePlayerTextDraw(playerid, 51.310829, 291.648864, "13");
	PlayerTextDrawLetterSize(playerid, fishTD[playerid][8], 0.271555, 1.291377);
	PlayerTextDrawAlignment(playerid, fishTD[playerid][8], 2);
	PlayerTextDrawColor(playerid, fishTD[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, fishTD[playerid][8], 0);
	PlayerTextDrawBackgroundColor(playerid, fishTD[playerid][8], 255);
	PlayerTextDrawFont(playerid, fishTD[playerid][8], 2);
	PlayerTextDrawSetProportional(playerid, fishTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][8], 0);

	fishTD[playerid][9] = CreatePlayerTextDraw(playerid, 14.333283, 160.475585, ""); 
	PlayerTextDrawLetterSize(playerid, fishTD[playerid][9], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, fishTD[playerid][9], 25.000000, 29.000000);
	PlayerTextDrawAlignment(playerid, fishTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, fishTD[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, fishTD[playerid][9], 0);
	PlayerTextDrawBackgroundColor(playerid, fishTD[playerid][9], -1061109740);
	PlayerTextDrawFont(playerid, fishTD[playerid][9], 5);
	PlayerTextDrawSetProportional(playerid, fishTD[playerid][9], 0);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][9], 0);
	PlayerTextDrawSetSelectable(playerid, fishTD[playerid][9], true);
	PlayerTextDrawSetPreviewModel(playerid, fishTD[playerid][9], 3054);
	PlayerTextDrawSetPreviewRot(playerid, fishTD[playerid][9], 0.000000, 0.000000, 0.000000, 1.529902);

	fishTD[playerid][10] = CreatePlayerTextDraw(playerid, 40.577793, 160.475616, ""); 
	PlayerTextDrawLetterSize(playerid, fishTD[playerid][10], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, fishTD[playerid][10], 24.000000, 29.000000);
	PlayerTextDrawAlignment(playerid, fishTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, fishTD[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, fishTD[playerid][10], 0);
	PlayerTextDrawBackgroundColor(playerid, fishTD[playerid][10], -1061109740);
	PlayerTextDrawFont(playerid, fishTD[playerid][10], 5);
	PlayerTextDrawSetProportional(playerid, fishTD[playerid][10], 0);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][10], 0);
	PlayerTextDrawSetSelectable(playerid, fishTD[playerid][10], true);
	PlayerTextDrawSetPreviewModel(playerid, fishTD[playerid][10], 18633);
	PlayerTextDrawSetPreviewRot(playerid, fishTD[playerid][10], 0.000000, 49.000000, 270.000000, 1.063977);

	fishTD[playerid][11] = CreatePlayerTextDraw(playerid, 14.333320, 190.777420, ""); 
	PlayerTextDrawLetterSize(playerid, fishTD[playerid][11], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, fishTD[playerid][11], 25.000000, 29.000000);
	PlayerTextDrawAlignment(playerid, fishTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, fishTD[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, fishTD[playerid][11], 0);
	PlayerTextDrawBackgroundColor(playerid, fishTD[playerid][11], -1061109740);
	PlayerTextDrawFont(playerid, fishTD[playerid][11], 5);
	PlayerTextDrawSetProportional(playerid, fishTD[playerid][11], 0);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][11], 0);
	PlayerTextDrawSetSelectable(playerid, fishTD[playerid][11], true);
	PlayerTextDrawSetPreviewModel(playerid, fishTD[playerid][11], 11722);
	PlayerTextDrawSetPreviewRot(playerid, fishTD[playerid][11], 306.000000, 196.000000, 0.000000, 1.000000);

	fishTD[playerid][12] = CreatePlayerTextDraw(playerid, 40.555522, 190.775131, ""); 
	PlayerTextDrawLetterSize(playerid, fishTD[playerid][12], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, fishTD[playerid][12], 24.000000, 29.000000);
	PlayerTextDrawAlignment(playerid, fishTD[playerid][12], 1);
	PlayerTextDrawColor(playerid, fishTD[playerid][12], -1);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, fishTD[playerid][12], 0);
	PlayerTextDrawBackgroundColor(playerid, fishTD[playerid][12], -1061109740);
	PlayerTextDrawFont(playerid, fishTD[playerid][12], 5);
	PlayerTextDrawSetProportional(playerid, fishTD[playerid][12], 0);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][12], 0);
	PlayerTextDrawSetSelectable(playerid, fishTD[playerid][12], true);
	PlayerTextDrawSetPreviewModel(playerid, fishTD[playerid][12], 11708);
	PlayerTextDrawSetPreviewRot(playerid, fishTD[playerid][12], 72.000000, 149.000000, 0.000000, 1.000000);

	fishTD[playerid][13] = CreatePlayerTextDraw(playerid, 13.999977, 146.786590, "FISH");
	PlayerTextDrawLetterSize(playerid, fishTD[playerid][13], 0.342222, 1.286400);
	PlayerTextDrawAlignment(playerid, fishTD[playerid][13], 1);
	PlayerTextDrawColor(playerid, fishTD[playerid][13], -1);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][13], 0);
	PlayerTextDrawSetOutline(playerid, fishTD[playerid][13], 1);
	PlayerTextDrawBackgroundColor(playerid, fishTD[playerid][13], 45);
	PlayerTextDrawFont(playerid, fishTD[playerid][13], 3);
	PlayerTextDrawSetProportional(playerid, fishTD[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][13], 0);

	fishTD[playerid][14] = CreatePlayerTextDraw(playerid, 14.566635, 250.508514, "");
	PlayerTextDrawLetterSize(playerid, fishTD[playerid][14], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, fishTD[playerid][14], 50.000000, 12.000000);
	PlayerTextDrawAlignment(playerid, fishTD[playerid][14], 1);
	PlayerTextDrawColor(playerid, fishTD[playerid][14], -1);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][14], 0);
	PlayerTextDrawSetOutline(playerid, fishTD[playerid][14], 0);
	PlayerTextDrawBackgroundColor(playerid, fishTD[playerid][14], -1061109740);
	PlayerTextDrawFont(playerid, fishTD[playerid][14], 5);
	PlayerTextDrawSetProportional(playerid, fishTD[playerid][14], 0);
	PlayerTextDrawSetShadow(playerid, fishTD[playerid][14], 0);
	PlayerTextDrawSetSelectable(playerid, fishTD[playerid][14], true);
	PlayerTextDrawSetPreviewModel(playerid, fishTD[playerid][14], 338);
	PlayerTextDrawSetPreviewRot(playerid, fishTD[playerid][14], 83.000000, 32.000000, 0.000000, 0.799721);

	specTD[playerid]  = CreatePlayerTextDraw(playerid, 318.500000, 329.377838, "Nume:~p~Vicentzo (0)~n~~w~Health:~p~59.29~w~~n~Armour:~p~29.59~w~~n~Vehicle:~p~411~w~[Health:~p~999.5~w~]Packet Loss:~p~59.29");
	PlayerTextDrawLetterSize(playerid, specTD[playerid] , 0.296500, 1.295110);
	PlayerTextDrawAlignment(playerid, specTD[playerid] , 2);
	PlayerTextDrawColor(playerid, specTD[playerid] , -1);
	PlayerTextDrawSetShadow(playerid, specTD[playerid] , 0);
	PlayerTextDrawSetOutline(playerid, specTD[playerid] , 1);
	PlayerTextDrawBackgroundColor(playerid, specTD[playerid] , 255);
	PlayerTextDrawFont(playerid, specTD[playerid] , 1);
	PlayerTextDrawSetProportional(playerid, specTD[playerid] , 1);
	PlayerTextDrawSetShadow(playerid, specTD[playerid] , 0);

	notificationTD[playerid]= CreatePlayerTextDraw(playerid, 322.444519, 390.115509, "Stiu casdadsaStiu casdadsaxx~n~Stiu casdadsaStiu casdadsaxx~n~Stiu casdadsaStiu casdadsaxx");
	PlayerTextDrawLetterSize(playerid, notificationTD[playerid], 0.198666, 1.186844);
	PlayerTextDrawAlignment(playerid, notificationTD[playerid], 2);
	PlayerTextDrawColor(playerid, notificationTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, notificationTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, notificationTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, notificationTD[playerid], 95);
	PlayerTextDrawFont(playerid, notificationTD[playerid], 2);
	PlayerTextDrawSetProportional(playerid, notificationTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, notificationTD[playerid], 0);

	vehicleHud[0] = CreatePlayerTextDraw(playerid, 528.143859, 365.662231, "LD_CARD:cd1s");
	PlayerTextDrawLetterSize(playerid, vehicleHud[0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, vehicleHud[0], 28.000000, 47.000000);
	PlayerTextDrawAlignment(playerid, vehicleHud[0], 1);
	PlayerTextDrawColor(playerid, vehicleHud[0], 336860415);
	PlayerTextDrawSetShadow(playerid, vehicleHud[0], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[0], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[0], 255);
	PlayerTextDrawFont(playerid, vehicleHud[0], 4);
	PlayerTextDrawSetProportional(playerid, vehicleHud[0], 0);
	PlayerTextDrawSetShadow(playerid, vehicleHud[0], 0);

	vehicleHud[1] = CreatePlayerTextDraw(playerid, 596.443664, 365.459991, "LD_CARD:cd1s");
	PlayerTextDrawLetterSize(playerid, vehicleHud[1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, vehicleHud[1], 28.000000, 47.000000);
	PlayerTextDrawAlignment(playerid, vehicleHud[1], 1);
	PlayerTextDrawColor(playerid, vehicleHud[1], 336860415);
	PlayerTextDrawSetShadow(playerid, vehicleHud[1], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[1], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[1], 255);
	PlayerTextDrawFont(playerid, vehicleHud[1], 4);
	PlayerTextDrawSetProportional(playerid, vehicleHud[1], 0);
	PlayerTextDrawSetShadow(playerid, vehicleHud[1], 0);

	vehicleHud[2] = CreatePlayerTextDraw(playerid, 528.111328, 370.049011, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, vehicleHud[2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, vehicleHud[2], 96.000000, 45.000000);
	PlayerTextDrawAlignment(playerid, vehicleHud[2], 1);
	PlayerTextDrawColor(playerid, vehicleHud[2], 336860415);
	PlayerTextDrawSetShadow(playerid, vehicleHud[2], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[2], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[2], 255);
	PlayerTextDrawFont(playerid, vehicleHud[2], 4);
	PlayerTextDrawSetProportional(playerid, vehicleHud[2], 0);
	PlayerTextDrawSetShadow(playerid, vehicleHud[2], 0);

	vehicleHud[3] = CreatePlayerTextDraw(playerid, 529.710937, 365.748748, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, vehicleHud[3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, vehicleHud[3], 93.000000, 5.000000);
	PlayerTextDrawAlignment(playerid, vehicleHud[3], 1);
	PlayerTextDrawColor(playerid, vehicleHud[3], 336860415);
	PlayerTextDrawSetShadow(playerid, vehicleHud[3], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[3], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[3], 255);
	PlayerTextDrawFont(playerid, vehicleHud[3], 4);
	PlayerTextDrawSetProportional(playerid, vehicleHud[3], 0);
	PlayerTextDrawSetShadow(playerid, vehicleHud[3], 0);

	vehicleHud[4] = CreatePlayerTextDraw(playerid, 533.155639, 377.408935, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, vehicleHud[4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, vehicleHud[4], 85.000000, 1.000000);
	PlayerTextDrawAlignment(playerid, vehicleHud[4], 1);
	PlayerTextDrawColor(playerid, vehicleHud[4], 858993663);
	PlayerTextDrawSetShadow(playerid, vehicleHud[4], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[4], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[4], 255);
	PlayerTextDrawFont(playerid, vehicleHud[4], 4);
	PlayerTextDrawSetProportional(playerid, vehicleHud[4], 0);
	PlayerTextDrawSetShadow(playerid, vehicleHud[4], 0);

	vehicleHud[5] = CreatePlayerTextDraw(playerid, 533.055603, 382.927246, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, vehicleHud[5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, vehicleHud[5], 26.000000, 25.000000);
	PlayerTextDrawAlignment(playerid, vehicleHud[5], 1);
	PlayerTextDrawColor(playerid, vehicleHud[5], 235802367);
	PlayerTextDrawSetShadow(playerid, vehicleHud[5], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[5], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[5], 255);
	PlayerTextDrawFont(playerid, vehicleHud[5], 4);
	PlayerTextDrawSetProportional(playerid, vehicleHud[5], 0);
	PlayerTextDrawSetShadow(playerid, vehicleHud[5], 0);

	vehicleHud[6] = CreatePlayerTextDraw(playerid, 568.497192, 383.025024, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, vehicleHud[6], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, vehicleHud[6], 14.000000, 15.000000);
	PlayerTextDrawAlignment(playerid, vehicleHud[6], 1);
	PlayerTextDrawColor(playerid, vehicleHud[6], 235802367);
	PlayerTextDrawSetShadow(playerid, vehicleHud[6], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[6], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[6], 255);
	PlayerTextDrawFont(playerid, vehicleHud[6], 4);
	PlayerTextDrawSetProportional(playerid, vehicleHud[6], 0);
	PlayerTextDrawSetShadow(playerid, vehicleHud[6], 0);

	vehicleHud[7] = CreatePlayerTextDraw(playerid, 586.292846, 383.025024, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, vehicleHud[7], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, vehicleHud[7], 14.000000, 15.000000);
	PlayerTextDrawAlignment(playerid, vehicleHud[7], 1);
	PlayerTextDrawColor(playerid, vehicleHud[7], 235802367);
	PlayerTextDrawSetShadow(playerid, vehicleHud[7], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[7], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[7], 255);
	PlayerTextDrawFont(playerid, vehicleHud[7], 4);
	PlayerTextDrawSetProportional(playerid, vehicleHud[7], 0);
	PlayerTextDrawSetShadow(playerid, vehicleHud[7], 0);

	vehicleHud[8] = CreatePlayerTextDraw(playerid, 604.188476, 383.025024, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, vehicleHud[8], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, vehicleHud[8], 14.000000, 15.000000);
	PlayerTextDrawAlignment(playerid, vehicleHud[8], 1);
	PlayerTextDrawColor(playerid, vehicleHud[8], 235802367);
	PlayerTextDrawSetShadow(playerid, vehicleHud[8], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[8], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[8], 255);
	PlayerTextDrawFont(playerid, vehicleHud[8], 4);
	PlayerTextDrawSetProportional(playerid, vehicleHud[8], 0);
	PlayerTextDrawSetShadow(playerid, vehicleHud[8], 0);

	vehicleHud[9] = CreatePlayerTextDraw(playerid, 538.499511, 399.873443, "KM/H");
	PlayerTextDrawLetterSize(playerid, vehicleHud[9], 0.164000, 0.733867);
	PlayerTextDrawAlignment(playerid, vehicleHud[9], 1);
	PlayerTextDrawColor(playerid, vehicleHud[9], 858993663);
	PlayerTextDrawSetShadow(playerid, vehicleHud[9], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[9], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[9], 88);
	PlayerTextDrawFont(playerid, vehicleHud[9], 1);
	PlayerTextDrawSetProportional(playerid, vehicleHud[9], 1);
	PlayerTextDrawSetShadow(playerid, vehicleHud[9], 0);

	vehicleHud[10] = CreatePlayerTextDraw(playerid, 546.541503, 383.933288, "000");
	PlayerTextDrawLetterSize(playerid, vehicleHud[10], 0.266667, 1.804088);
	PlayerTextDrawAlignment(playerid, vehicleHud[10], 2);
	PlayerTextDrawColor(playerid, vehicleHud[10], 858993663);
	PlayerTextDrawSetShadow(playerid, vehicleHud[10], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[10], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[10], 255);
	PlayerTextDrawFont(playerid, vehicleHud[10], 2);
	PlayerTextDrawSetProportional(playerid, vehicleHud[10], 1);
	PlayerTextDrawSetShadow(playerid, vehicleHud[10], 0);

	vehicleHud[11] = CreatePlayerTextDraw(playerid, 575.687927, 382.442321, "n");
	PlayerTextDrawLetterSize(playerid, vehicleHud[11], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, vehicleHud[11], 2);
	PlayerTextDrawColor(playerid, vehicleHud[11], 858993663);
	PlayerTextDrawSetShadow(playerid, vehicleHud[11], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[11], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[11], 255);
	PlayerTextDrawFont(playerid, vehicleHud[11], 2);
	PlayerTextDrawSetProportional(playerid, vehicleHud[11], 1);
	PlayerTextDrawSetShadow(playerid, vehicleHud[11], 0);

	vehicleHud[12] = CreatePlayerTextDraw(playerid, 560.069641, 407.818359, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, vehicleHud[12], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, vehicleHud[12], -1.000000, -25.000000);
	PlayerTextDrawAlignment(playerid, vehicleHud[12], 1);
	PlayerTextDrawColor(playerid, vehicleHud[12], 858993493);
	PlayerTextDrawSetShadow(playerid, vehicleHud[12], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[12], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[12], 255);
	PlayerTextDrawFont(playerid, vehicleHud[12], 4);
	PlayerTextDrawSetProportional(playerid, vehicleHud[12], 0);
	PlayerTextDrawSetShadow(playerid, vehicleHud[12], 0);

	vehicleHud[13] = CreatePlayerTextDraw(playerid, 533.214782, 377.333587, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, vehicleHud[13], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, vehicleHud[13], 85.000000, -4.000000);
	PlayerTextDrawAlignment(playerid, vehicleHud[13], 1);
	PlayerTextDrawColor(playerid, vehicleHud[13], 858993493);
	PlayerTextDrawSetShadow(playerid, vehicleHud[13], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[13], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[13], 255);
	PlayerTextDrawFont(playerid, vehicleHud[13], 4);
	PlayerTextDrawSetProportional(playerid, vehicleHud[13], 0);
	PlayerTextDrawSetShadow(playerid, vehicleHud[13], 0);

	vehicleHud[14] = CreatePlayerTextDraw(playerid, 593.765625, 385.735534, "O");
	PlayerTextDrawLetterSize(playerid, vehicleHud[14], 0.308000, 1.186844);
	PlayerTextDrawAlignment(playerid, vehicleHud[14], 2);
	PlayerTextDrawColor(playerid, vehicleHud[14], 858993663);
	PlayerTextDrawSetShadow(playerid, vehicleHud[14], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[14], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[14], 255);
	PlayerTextDrawFont(playerid, vehicleHud[14], 2);
	PlayerTextDrawSetProportional(playerid, vehicleHud[14], 1);
	PlayerTextDrawSetShadow(playerid, vehicleHud[14], 0);

	vehicleHud[15] = CreatePlayerTextDraw(playerid, 593.376586, 393.899932, "C");
	PlayerTextDrawLetterSize(playerid, vehicleHud[15], -0.284777, -1.063109);
	PlayerTextDrawAlignment(playerid, vehicleHud[15], 2);
	PlayerTextDrawColor(playerid, vehicleHud[15], 858993663);
	PlayerTextDrawSetShadow(playerid, vehicleHud[15], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[15], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[15], 255);
	PlayerTextDrawFont(playerid, vehicleHud[15], 2);
	PlayerTextDrawSetProportional(playerid, vehicleHud[15], 1);
	PlayerTextDrawSetShadow(playerid, vehicleHud[15], 0);

	vehicleHud[16] = CreatePlayerTextDraw(playerid, 611.679138, 382.542327, "L");
	PlayerTextDrawLetterSize(playerid, vehicleHud[16], 0.400000, 1.600000);
	PlayerTextDrawAlignment(playerid, vehicleHud[16], 2);
	PlayerTextDrawColor(playerid, vehicleHud[16], 858993663);
	PlayerTextDrawSetShadow(playerid, vehicleHud[16], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[16], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[16], 255);
	PlayerTextDrawFont(playerid, vehicleHud[16], 2);
	PlayerTextDrawSetProportional(playerid, vehicleHud[16], 1);
	PlayerTextDrawSetShadow(playerid, vehicleHud[16], 0);

	vehicleHud[17] = CreatePlayerTextDraw(playerid, 618.894226, 398.875732, "0000000");
	PlayerTextDrawLetterSize(playerid, vehicleHud[17], 0.223555, 1.107200);
	PlayerTextDrawAlignment(playerid, vehicleHud[17], 3);
	PlayerTextDrawColor(playerid, vehicleHud[17], 858993663);
	PlayerTextDrawSetShadow(playerid, vehicleHud[17], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[17], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[17], 255);
	PlayerTextDrawFont(playerid, vehicleHud[17], 2);
	PlayerTextDrawSetProportional(playerid, vehicleHud[17], 1);
	PlayerTextDrawSetShadow(playerid, vehicleHud[17], 0);

	vehicleHud[18] = CreatePlayerTextDraw(playerid, 560.069641, 407.818359, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, vehicleHud[18], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, vehicleHud[18], -1.000000, -1.000000);
	PlayerTextDrawAlignment(playerid, vehicleHud[18], 1);
	PlayerTextDrawColor(playerid, vehicleHud[18], -13749419);
	PlayerTextDrawSetShadow(playerid, vehicleHud[18], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[18], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[18], 255);
	PlayerTextDrawFont(playerid, vehicleHud[18], 4);
	PlayerTextDrawSetProportional(playerid, vehicleHud[18], 0);
	PlayerTextDrawSetShadow(playerid, vehicleHud[18], 0);

	vehicleHud[19] = CreatePlayerTextDraw(playerid, 533.214782, 377.333587, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, vehicleHud[19], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, vehicleHud[19], 1.000000, -4.000000);
	PlayerTextDrawAlignment(playerid, vehicleHud[19], 1);
	PlayerTextDrawColor(playerid, vehicleHud[19], -7403684);
	PlayerTextDrawSetShadow(playerid, vehicleHud[19], 0);
	PlayerTextDrawSetOutline(playerid, vehicleHud[19], 0);
	PlayerTextDrawBackgroundColor(playerid, vehicleHud[19], 255);
	PlayerTextDrawFont(playerid, vehicleHud[19], 4);
	PlayerTextDrawSetProportional(playerid, vehicleHud[19], 0);
	PlayerTextDrawSetShadow(playerid, vehicleHud[19], 0);

	serverHud[0] = CreatePlayerTextDraw(playerid, 638.755981, 436.022460, "RPG.BLACK~p~MOON~w~.RO");
	PlayerTextDrawLetterSize(playerid, serverHud[0], 0.202221, 1.311288);
	PlayerTextDrawAlignment(playerid, serverHud[0], 3);
	PlayerTextDrawColor(playerid, serverHud[0], -1);
	PlayerTextDrawSetShadow(playerid, serverHud[0], 0);
	PlayerTextDrawSetOutline(playerid, serverHud[0], 1);
	PlayerTextDrawBackgroundColor(playerid, serverHud[0], 59);
	PlayerTextDrawFont(playerid, serverHud[0], 2);
	PlayerTextDrawSetProportional(playerid, serverHud[0], 1);
	PlayerTextDrawSetShadow(playerid, serverHud[0], 0);

	serverHud[1] = CreatePlayerTextDraw(playerid, 1.211715, 426.077789, "100~n~~r~100~w~ / T~g~198~w~ / A~b~1002~w~ / Q~p~23");
	PlayerTextDrawLetterSize(playerid, serverHud[1], 0.209332, 1.147019);
	PlayerTextDrawAlignment(playerid, serverHud[1], 1);
	PlayerTextDrawColor(playerid, serverHud[1], -65281);
	PlayerTextDrawSetShadow(playerid, serverHud[1], 0);
	PlayerTextDrawSetOutline(playerid, serverHud[1], 1);
	PlayerTextDrawBackgroundColor(playerid, serverHud[1], 59);
	PlayerTextDrawFont(playerid, serverHud[1], 2);
	PlayerTextDrawSetProportional(playerid, serverHud[1], 1);
	PlayerTextDrawSetShadow(playerid, serverHud[1], 0);

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

	levelBar[0] = CreatePlayerTextDraw(playerid, 497.888549, 101.637939, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, levelBar[0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, levelBar[0], 109.000000, 7.000000);
	PlayerTextDrawAlignment(playerid, levelBar[0], 1);
	PlayerTextDrawColor(playerid, levelBar[0], 149);
	PlayerTextDrawSetShadow(playerid, levelBar[0], 0);
	PlayerTextDrawSetOutline(playerid, levelBar[0], 0);
	PlayerTextDrawBackgroundColor(playerid, levelBar[0], 255);
	PlayerTextDrawFont(playerid, levelBar[0], 4);
	PlayerTextDrawSetProportional(playerid, levelBar[0], 0);
	PlayerTextDrawSetShadow(playerid, levelBar[0], 0);

	levelBar[1] = CreatePlayerTextDraw(playerid, 498.389068, 102.237838, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, levelBar[1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, levelBar[1], 108.000000, 6.000000);
	PlayerTextDrawAlignment(playerid, levelBar[1], 1);
	PlayerTextDrawColor(playerid, levelBar[1], -2139062180);
	PlayerTextDrawSetShadow(playerid, levelBar[1], 0);
	PlayerTextDrawSetOutline(playerid, levelBar[1], 0);
	PlayerTextDrawBackgroundColor(playerid, levelBar[1], 255);
	PlayerTextDrawFont(playerid, levelBar[1], 4);
	PlayerTextDrawSetProportional(playerid, levelBar[1], 0);
	PlayerTextDrawSetShadow(playerid, levelBar[1], 0);

	levelBar[2] = CreatePlayerTextDraw(playerid, 498.633209, 102.137870, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, levelBar[2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, levelBar[2], 0.000000, 6.000000);
	PlayerTextDrawAlignment(playerid, levelBar[2], 1);
	PlayerTextDrawColor(playerid, levelBar[2], -2139062180);
	PlayerTextDrawSetShadow(playerid, levelBar[2], 0);
	PlayerTextDrawSetOutline(playerid, levelBar[2], 0);
	PlayerTextDrawBackgroundColor(playerid, levelBar[2], 255);
	PlayerTextDrawFont(playerid, levelBar[2], 4);
	PlayerTextDrawSetProportional(playerid, levelBar[2], 0);
	PlayerTextDrawSetShadow(playerid, levelBar[2], 0);

	levelBar[3] = CreatePlayerTextDraw(playerid, 551.036071, 109.430572, "");
	PlayerTextDrawLetterSize(playerid, levelBar[3], 0.174222, 1.127110);
	PlayerTextDrawAlignment(playerid, levelBar[3], 2);
	PlayerTextDrawColor(playerid, levelBar[3], -1);
	PlayerTextDrawSetShadow(playerid, levelBar[3], 0);
	PlayerTextDrawSetOutline(playerid, levelBar[3], 1);
	PlayerTextDrawBackgroundColor(playerid, levelBar[3], 27);
	PlayerTextDrawFont(playerid, levelBar[3], 2);
	PlayerTextDrawSetProportional(playerid, levelBar[3], 1);
	PlayerTextDrawSetShadow(playerid, levelBar[3], 0);

	examenTD[playerid][0] = CreatePlayerTextDraw(playerid, 330.333160, 168.439956, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, examenTD[playerid][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, examenTD[playerid][0], 271.000000, 114.000000);
	PlayerTextDrawAlignment(playerid, examenTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, examenTD[playerid][0], 1419188479);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, examenTD[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, examenTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, examenTD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, examenTD[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][0], 0);

	examenTD[playerid][1] = CreatePlayerTextDraw(playerid, 331.133209, 169.540023, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, examenTD[playerid][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, examenTD[playerid][1], 269.000000, 112.000000);
	PlayerTextDrawAlignment(playerid, examenTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, examenTD[playerid][1], 387389439);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, examenTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, examenTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, examenTD[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, examenTD[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][1], 0);

	examenTD[playerid][2] = CreatePlayerTextDraw(playerid, 330.333160, 168.439956, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, examenTD[playerid][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, examenTD[playerid][2], 34.000000, -15.000000);
	PlayerTextDrawAlignment(playerid, examenTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, examenTD[playerid][2], 1419188479);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, examenTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, examenTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, examenTD[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, examenTD[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][2], 0);

	examenTD[playerid][3] = CreatePlayerTextDraw(playerid, 331.222015, 198.399856, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, examenTD[playerid][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, examenTD[playerid][3], 270.000000, -1.000000);
	PlayerTextDrawAlignment(playerid, examenTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, examenTD[playerid][3], 1419188479);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, examenTD[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, examenTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, examenTD[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, examenTD[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][3], 0);

	examenTD[playerid][4] = CreatePlayerTextDraw(playerid, 331.133178, 154.604415, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, examenTD[playerid][4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, examenTD[playerid][4], 32.000000, 14.000000);
	PlayerTextDrawAlignment(playerid, examenTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, examenTD[playerid][4], 387389439);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, examenTD[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, examenTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, examenTD[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, examenTD[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][4], 0);

	examenTD[playerid][5] = CreatePlayerTextDraw(playerid, 336.000000, 203.400177, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, examenTD[playerid][5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, examenTD[playerid][5], 260.000000, 22.000000);
	PlayerTextDrawAlignment(playerid, examenTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, examenTD[playerid][5], 1419188479);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, examenTD[playerid][5], 0);
	PlayerTextDrawBackgroundColor(playerid, examenTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, examenTD[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, examenTD[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][5], 0);
	PlayerTextDrawSetSelectable(playerid, examenTD[playerid][5], true);

	examenTD[playerid][6] = CreatePlayerTextDraw(playerid, 335.944885, 228.686050, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, examenTD[playerid][6], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, examenTD[playerid][6], 260.000000, 22.000000);
	PlayerTextDrawAlignment(playerid, examenTD[playerid][6], 1);
	PlayerTextDrawColor(playerid, examenTD[playerid][6], 1419188479);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, examenTD[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, examenTD[playerid][6], 255);
	PlayerTextDrawFont(playerid, examenTD[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, examenTD[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][6], 0);
	PlayerTextDrawSetSelectable(playerid, examenTD[playerid][6], true);

	examenTD[playerid][7] = CreatePlayerTextDraw(playerid, 335.989135, 253.883972, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, examenTD[playerid][7], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, examenTD[playerid][7], 260.000000, 22.000000);
	PlayerTextDrawAlignment(playerid, examenTD[playerid][7], 1);
	PlayerTextDrawColor(playerid, examenTD[playerid][7], 1419188479);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][7], 0);
	PlayerTextDrawSetOutline(playerid, examenTD[playerid][7], 0);
	PlayerTextDrawBackgroundColor(playerid, examenTD[playerid][7], 255);
	PlayerTextDrawFont(playerid, examenTD[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, examenTD[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][7], 0);
	PlayerTextDrawSetSelectable(playerid, examenTD[playerid][7], true);

	examenTD[playerid][8] = CreatePlayerTextDraw(playerid, 334.455688, 173.386856, "Iti place pula?Iti place pula?Iti place pula?~n~Iti place pula?Iti place pula?Iti place pula pula?");
	PlayerTextDrawLetterSize(playerid, examenTD[playerid][8], 0.242222, 1.057422);
	PlayerTextDrawAlignment(playerid, examenTD[playerid][8], 1);
	PlayerTextDrawColor(playerid, examenTD[playerid][8], -1);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][8], 0);
	PlayerTextDrawSetOutline(playerid, examenTD[playerid][8], 1);
	PlayerTextDrawBackgroundColor(playerid, examenTD[playerid][8], 86);
	PlayerTextDrawFont(playerid, examenTD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, examenTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][8], 0);

	examenTD[playerid][9] = CreatePlayerTextDraw(playerid, 334.366851, 155.857894, "05:29");
	PlayerTextDrawLetterSize(playerid, examenTD[playerid][9], 0.200000, 1.161955);
	PlayerTextDrawAlignment(playerid, examenTD[playerid][9], 1);
	PlayerTextDrawColor(playerid, examenTD[playerid][9], -1);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][9], 0);
	PlayerTextDrawSetOutline(playerid, examenTD[playerid][9], 1);
	PlayerTextDrawBackgroundColor(playerid, examenTD[playerid][9], 86);
	PlayerTextDrawFont(playerid, examenTD[playerid][9], 2);
	PlayerTextDrawSetProportional(playerid, examenTD[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][9], 0);

	examenTD[playerid][10] = CreatePlayerTextDraw(playerid, 338.811340, 208.422363, "a) da");
	PlayerTextDrawLetterSize(playerid, examenTD[playerid][10], 0.200000, 1.161955);
	PlayerTextDrawAlignment(playerid, examenTD[playerid][10], 1);
	PlayerTextDrawColor(playerid, examenTD[playerid][10], -1);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][10], 0);
	PlayerTextDrawSetOutline(playerid, examenTD[playerid][10], 1);
	PlayerTextDrawBackgroundColor(playerid, examenTD[playerid][10], 86);
	PlayerTextDrawFont(playerid, examenTD[playerid][10], 2);
	PlayerTextDrawSetProportional(playerid, examenTD[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][10], 0);

	examenTD[playerid][11] = CreatePlayerTextDraw(playerid, 339.477905, 234.006805, "B) NU");
	PlayerTextDrawLetterSize(playerid, examenTD[playerid][11], 0.200000, 1.161955);
	PlayerTextDrawAlignment(playerid, examenTD[playerid][11], 1);
	PlayerTextDrawColor(playerid, examenTD[playerid][11], -1);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][11], 0);
	PlayerTextDrawSetOutline(playerid, examenTD[playerid][11], 1);
	PlayerTextDrawBackgroundColor(playerid, examenTD[playerid][11], 86);
	PlayerTextDrawFont(playerid, examenTD[playerid][11], 2);
	PlayerTextDrawSetProportional(playerid, examenTD[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][11], 0);

	examenTD[playerid][12] = CreatePlayerTextDraw(playerid, 339.911193, 259.495727, "C) Poate");
	PlayerTextDrawLetterSize(playerid, examenTD[playerid][12], 0.200000, 1.161955);
	PlayerTextDrawAlignment(playerid, examenTD[playerid][12], 1);
	PlayerTextDrawColor(playerid, examenTD[playerid][12], -1);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][12], 0);
	PlayerTextDrawSetOutline(playerid, examenTD[playerid][12], 1);
	PlayerTextDrawBackgroundColor(playerid, examenTD[playerid][12], 86);
	PlayerTextDrawFont(playerid, examenTD[playerid][12], 2);
	PlayerTextDrawSetProportional(playerid, examenTD[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, examenTD[playerid][12], 0);

	Inventory_BTN[0] = CreatePlayerTextDraw(playerid, 2.333290, 156.991104, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[0], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[0], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[0], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[0], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[0], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[0], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[0], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[0], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[0], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[0], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[0], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[0], true);

	Inventory_BTN[1] = CreatePlayerTextDraw(playerid, 33.933345, 156.991104, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[1], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[1], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[1], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[1], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[1], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[1], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[1], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[1], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[1], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[1], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[1], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[1], true);

	Inventory_BTN[2] = CreatePlayerTextDraw(playerid, 66.032859, 156.991104, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[2], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[2], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[2], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[2], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[2], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[2], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[2], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[2], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[2], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[2], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[2], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[2], true);

	Inventory_BTN[3] = CreatePlayerTextDraw(playerid, 97.432380, 156.991104, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[3], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[3], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[3], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[3], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[3], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[3], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[3], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[3], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[3], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[3], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[3], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[3], true);

	Inventory_BTN[4] = CreatePlayerTextDraw(playerid, 2.333290, 191.493209, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[4], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[4], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[4], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[4], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[4], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[4], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[4], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[4], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[4], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[4], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[4], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[4], true);

	Inventory_BTN[5] = CreatePlayerTextDraw(playerid, 33.933345, 191.493209, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[5], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[5], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[5], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[5], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[5], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[5], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[5], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[5], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[5], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[5], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[5], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[5], true);

	Inventory_BTN[6] = CreatePlayerTextDraw(playerid, 65.432868, 191.493209, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[6], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[6], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[6], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[6], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[6], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[6], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[6], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[6], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[6], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[6], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[6], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[6], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[6], true);

	Inventory_BTN[7] = CreatePlayerTextDraw(playerid, 97.632377, 191.493209, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[7], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[7], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[7], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[7], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[7], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[7], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[7], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[7], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[7], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[7], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[7], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[7], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[7], true);

	Inventory_BTN[8] = CreatePlayerTextDraw(playerid, 2.333290, 225.695297, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[8], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[8], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[8], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[8], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[8], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[8], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[8], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[8], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[8], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[8], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[8], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[8], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[8], true);

	Inventory_BTN[9] = CreatePlayerTextDraw(playerid, 33.833347, 225.695297, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[9], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[9], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[9], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[9], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[9], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[9], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[9], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[9], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[9], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[9], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[9], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[9], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[9], true);

	Inventory_BTN[10] = CreatePlayerTextDraw(playerid, 65.632865, 225.695297, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[10], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[10], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[10], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[10], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[10], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[10], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[10], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[10], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[10], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[10], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[10], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[10], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[10], true);

	Inventory_BTN[11] = CreatePlayerTextDraw(playerid, 97.732376, 225.695297, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[11], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[11], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[11], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[11], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[11], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[11], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[11], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[11], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[11], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[11], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[11], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[11], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[11], true);

	Inventory_BTN[12] = CreatePlayerTextDraw(playerid, 2.333290, 260.497406, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[12], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[12], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[12], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[12], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[12], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[12], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[12], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[12], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[12], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[12], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[12], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[12], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[12], true);

	Inventory_BTN[13] = CreatePlayerTextDraw(playerid, 33.833347, 260.497406, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[13], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[13], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[13], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[13], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[13], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[13], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[13], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[13], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[13], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[13], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[13], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[13], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[13], true);

	Inventory_BTN[14] = CreatePlayerTextDraw(playerid, 65.532867, 260.497406, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[14], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[14], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[14], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[14], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[14], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[14], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[14], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[14], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[14], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[14], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[14], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[14], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[14], true);

	Inventory_BTN[15] = CreatePlayerTextDraw(playerid, 97.432380, 260.497406, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[15], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[15], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[15], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[15], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[15], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[15], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[15], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[15], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[15], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[15], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[15], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[15], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[15], true);

	Inventory_BTN[16] = CreatePlayerTextDraw(playerid, 2.333290, 294.899505, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[16], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[16], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[16], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[16], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[16], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[16], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[16], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[16], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[16], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[16], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[16], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[16], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[16], true);

	Inventory_BTN[17] = CreatePlayerTextDraw(playerid, 33.833347, 294.899505, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[17], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[17], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[17], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[17], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[17], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[17], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[17], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[17], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[17], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[17], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[17], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[17], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[17], true);

	Inventory_BTN[18] = CreatePlayerTextDraw(playerid, 65.532867, 294.899505, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[18], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[18], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[18], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[18], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[18], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[18], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[18], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[18], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[18], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[18], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[18], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[18], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[18], true);

	Inventory_BTN[19] = CreatePlayerTextDraw(playerid, 97.232383, 294.899505, "");
	PlayerTextDrawLetterSize(playerid, Inventory_BTN[19], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, Inventory_BTN[19], 28.000000, 31.000000);
	PlayerTextDrawAlignment(playerid, Inventory_BTN[19], 1);
	PlayerTextDrawColor(playerid, Inventory_BTN[19], -1);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[19], 0);
	PlayerTextDrawSetOutline(playerid, Inventory_BTN[19], 0);
	PlayerTextDrawBackgroundColor(playerid, Inventory_BTN[19], 255);
	PlayerTextDrawFont(playerid, Inventory_BTN[19], 5);
	PlayerTextDrawSetProportional(playerid, Inventory_BTN[19], 0);
	PlayerTextDrawSetShadow(playerid, Inventory_BTN[19], 0);
	PlayerTextDrawSetPreviewModel(playerid, Inventory_BTN[19], 30000);
	PlayerTextDrawSetPreviewRot(playerid, Inventory_BTN[19], 0.000000, 0.000000, 0.000000, 1.000000);
	PlayerTextDrawSetSelectable(playerid, Inventory_BTN[19], true);

	return true;
}

stock updateLevelBar(playerid) {
	new Float:level;
	if(playerInfo[playerid][pLevel] <= 0) return 1;
	if(float((playerInfo[playerid][pRespectPoints]*100)/(playerInfo[playerid][pLevel] * 3)) > 100) level = 100.0;
	else level = float((playerInfo[playerid][pRespectPoints]*100)/(playerInfo[playerid][pLevel] * 3));

	PlayerTextDrawTextSize(playerid, levelBar[2], (1.080000 * level), 6.000000);
	va_PlayerTextDrawSetString(playerid, levelBar[3], "LEVEL %d ~p~(%d%s)", playerInfo[playerid][pLevel], (playerInfo[playerid][pRespectPoints]*100)/(playerInfo[playerid][pLevel] * 3), "%");
	for(new i = 0; i < sizeof levelBar; i++) PlayerTextDrawShow(playerid, levelBar[i]);
	return true;
}

stock serverTextDraws()
{
	Inventory_BG[0] = TextDrawCreate(94.032951, 152.613372, "LD_CARD:cd1h");
	TextDrawLetterSize(Inventory_BG[0], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[0], 36.000000, 42.000000);
	TextDrawAlignment(Inventory_BG[0], 1);
	TextDrawColor(Inventory_BG[0], -2139062017);
	TextDrawSetShadow(Inventory_BG[0], 0);
	TextDrawSetOutline(Inventory_BG[0], 0);
	TextDrawBackgroundColor(Inventory_BG[0], 255);
	TextDrawFont(Inventory_BG[0], 4);
	TextDrawSetProportional(Inventory_BG[0], 0);
	TextDrawSetShadow(Inventory_BG[0], 0);

	Inventory_BG[1] = TextDrawCreate(-8.777791, 152.908920, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[1], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[1], 117.000000, 177.000000);
	TextDrawAlignment(Inventory_BG[1], 1);
	TextDrawColor(Inventory_BG[1], -2139062017);
	TextDrawSetShadow(Inventory_BG[1], 0);
	TextDrawSetOutline(Inventory_BG[1], 0);
	TextDrawBackgroundColor(Inventory_BG[1], 255);
	TextDrawFont(Inventory_BG[1], 4);
	TextDrawSetProportional(Inventory_BG[1], 0);
	TextDrawSetShadow(Inventory_BG[1], 0);

	Inventory_BG[2] = TextDrawCreate(94.132949, 288.213531, "LD_CARD:cd1h");
	TextDrawLetterSize(Inventory_BG[2], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[2], 36.000000, 42.000000);
	TextDrawAlignment(Inventory_BG[2], 1);
	TextDrawColor(Inventory_BG[2], -2139062017);
	TextDrawSetShadow(Inventory_BG[2], 0);
	TextDrawSetOutline(Inventory_BG[2], 0);
	TextDrawBackgroundColor(Inventory_BG[2], 255);
	TextDrawFont(Inventory_BG[2], 4);
	TextDrawSetProportional(Inventory_BG[2], 0);
	TextDrawSetShadow(Inventory_BG[2], 0);

	Inventory_BG[3] = TextDrawCreate(13.588875, 157.513702, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[3], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[3], 116.190040, 144.000000);
	TextDrawAlignment(Inventory_BG[3], 1);
	TextDrawColor(Inventory_BG[3], -2139062017);
	TextDrawSetShadow(Inventory_BG[3], 0);
	TextDrawSetOutline(Inventory_BG[3], 0);
	TextDrawBackgroundColor(Inventory_BG[3], 255);
	TextDrawFont(Inventory_BG[3], 4);
	TextDrawSetProportional(Inventory_BG[3], 0);
	TextDrawSetShadow(Inventory_BG[3], 0);

	Inventory_BG[4] = TextDrawCreate(93.732955, 153.213409, "LD_CARD:cd1h");
	TextDrawLetterSize(Inventory_BG[4], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[4], 36.000000, 42.000000);
	TextDrawAlignment(Inventory_BG[4], 1);
	TextDrawColor(Inventory_BG[4], 255);
	TextDrawSetShadow(Inventory_BG[4], 0);
	TextDrawSetOutline(Inventory_BG[4], 0);
	TextDrawBackgroundColor(Inventory_BG[4], 255);
	TextDrawFont(Inventory_BG[4], 4);
	TextDrawSetProportional(Inventory_BG[4], 0);
	TextDrawSetShadow(Inventory_BG[4], 0);

	Inventory_BG[5] = TextDrawCreate(-8.777791, 153.508956, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[5], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[5], 117.000000, 176.000000);
	TextDrawAlignment(Inventory_BG[5], 1);
	TextDrawColor(Inventory_BG[5], 255);
	TextDrawSetShadow(Inventory_BG[5], 0);
	TextDrawSetOutline(Inventory_BG[5], 0);
	TextDrawBackgroundColor(Inventory_BG[5], 255);
	TextDrawFont(Inventory_BG[5], 4);
	TextDrawSetProportional(Inventory_BG[5], 0);
	TextDrawSetShadow(Inventory_BG[5], 0);

	Inventory_BG[6] = TextDrawCreate(93.632957, 287.713500, "LD_CARD:cd1h");
	TextDrawLetterSize(Inventory_BG[6], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[6], 36.000000, 42.000000);
	TextDrawAlignment(Inventory_BG[6], 1);
	TextDrawColor(Inventory_BG[6], 255);
	TextDrawSetShadow(Inventory_BG[6], 0);
	TextDrawSetOutline(Inventory_BG[6], 0);
	TextDrawBackgroundColor(Inventory_BG[6], 255);
	TextDrawFont(Inventory_BG[6], 4);
	TextDrawSetProportional(Inventory_BG[6], 0);
	TextDrawSetShadow(Inventory_BG[6], 0);

	Inventory_BG[7] = TextDrawCreate(13.144433, 157.513702, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[7], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[7], 116.190040, 144.000000);
	TextDrawAlignment(Inventory_BG[7], 1);
	TextDrawColor(Inventory_BG[7], 255);
	TextDrawSetShadow(Inventory_BG[7], 0);
	TextDrawSetOutline(Inventory_BG[7], 0);
	TextDrawBackgroundColor(Inventory_BG[7], 255);
	TextDrawFont(Inventory_BG[7], 4);
	TextDrawSetProportional(Inventory_BG[7], 0);
	TextDrawSetShadow(Inventory_BG[7], 0);

	Inventory_BG[8] = TextDrawCreate(129.622299, 142.235824, "(30/30 KG) Inventory");
	TextDrawLetterSize(Inventory_BG[8], 0.213778, 1.241600);
	TextDrawAlignment(Inventory_BG[8], 3);
	TextDrawColor(Inventory_BG[8], -1);
	TextDrawSetShadow(Inventory_BG[8], 0);
	TextDrawSetOutline(Inventory_BG[8], 1);
	TextDrawBackgroundColor(Inventory_BG[8], 81);
	TextDrawFont(Inventory_BG[8], 2);
	TextDrawSetProportional(Inventory_BG[8], 1);
	TextDrawSetShadow(Inventory_BG[8], 0);

	Inventory_BG[9] = TextDrawCreate(130.477813, 156.006805, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[9], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[9], 11.000000, 172.000000);
	TextDrawAlignment(Inventory_BG[9], 1);
	TextDrawColor(Inventory_BG[9], -2139062272);
	TextDrawSetShadow(Inventory_BG[9], 0);
	TextDrawSetOutline(Inventory_BG[9], 0);
	TextDrawBackgroundColor(Inventory_BG[9], 255);
	TextDrawFont(Inventory_BG[9], 4);
	TextDrawSetProportional(Inventory_BG[9], 0);
	TextDrawSetShadow(Inventory_BG[9], 0);
	TextDrawSetSelectable(Inventory_BG[9], true);

	Inventory_BG[10] = TextDrawCreate(1.811282, 156.493377, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[10], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[10], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[10], 1);
	TextDrawColor(Inventory_BG[10], -2139062017);
	TextDrawSetShadow(Inventory_BG[10], 0);
	TextDrawSetOutline(Inventory_BG[10], 0);
	TextDrawBackgroundColor(Inventory_BG[10], 255);
	TextDrawFont(Inventory_BG[10], 4);
	TextDrawSetProportional(Inventory_BG[10], 0);
	TextDrawSetShadow(Inventory_BG[10], 0);

	Inventory_BG[11] = TextDrawCreate(33.611248, 156.391143, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[11], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[11], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[11], 1);
	TextDrawColor(Inventory_BG[11], -2139062017);
	TextDrawSetShadow(Inventory_BG[11], 0);
	TextDrawSetOutline(Inventory_BG[11], 0);
	TextDrawBackgroundColor(Inventory_BG[11], 255);
	TextDrawFont(Inventory_BG[11], 4);
	TextDrawSetProportional(Inventory_BG[11], 0);
	TextDrawSetShadow(Inventory_BG[11], 0);

	Inventory_BG[12] = TextDrawCreate(65.411186, 156.493377, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[12], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[12], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[12], 1);
	TextDrawColor(Inventory_BG[12], -2139062017);
	TextDrawSetShadow(Inventory_BG[12], 0);
	TextDrawSetOutline(Inventory_BG[12], 0);
	TextDrawBackgroundColor(Inventory_BG[12], 255);
	TextDrawFont(Inventory_BG[12], 4);
	TextDrawSetProportional(Inventory_BG[12], 0);
	TextDrawSetShadow(Inventory_BG[12], 0);

	Inventory_BG[13] = TextDrawCreate(97.211509, 156.493377, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[13], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[13], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[13], 1);
	TextDrawColor(Inventory_BG[13], -2139062017);
	TextDrawSetShadow(Inventory_BG[13], 0);
	TextDrawSetOutline(Inventory_BG[13], 0);
	TextDrawBackgroundColor(Inventory_BG[13], 255);
	TextDrawFont(Inventory_BG[13], 4);
	TextDrawSetProportional(Inventory_BG[13], 0);
	TextDrawSetShadow(Inventory_BG[13], 0);

	Inventory_BG[14] = TextDrawCreate(1.811282, 190.693725, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[14], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[14], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[14], 1);
	TextDrawColor(Inventory_BG[14], -2139062017);
	TextDrawSetShadow(Inventory_BG[14], 0);
	TextDrawSetOutline(Inventory_BG[14], 0);
	TextDrawBackgroundColor(Inventory_BG[14], 255);
	TextDrawFont(Inventory_BG[14], 4);
	TextDrawSetProportional(Inventory_BG[14], 0);
	TextDrawSetShadow(Inventory_BG[14], 0);

	Inventory_BG[15] = TextDrawCreate(33.611248, 190.891494, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[15], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[15], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[15], 1);
	TextDrawColor(Inventory_BG[15], -2139062017);
	TextDrawSetShadow(Inventory_BG[15], 0);
	TextDrawSetOutline(Inventory_BG[15], 0);
	TextDrawBackgroundColor(Inventory_BG[15], 255);
	TextDrawFont(Inventory_BG[15], 4);
	TextDrawSetProportional(Inventory_BG[15], 0);
	TextDrawSetShadow(Inventory_BG[15], 0);

	Inventory_BG[16] = TextDrawCreate(65.111183, 190.891494, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[16], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[16], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[16], 1);
	TextDrawColor(Inventory_BG[16], -2139062017);
	TextDrawSetShadow(Inventory_BG[16], 0);
	TextDrawSetOutline(Inventory_BG[16], 0);
	TextDrawBackgroundColor(Inventory_BG[16], 255);
	TextDrawFont(Inventory_BG[16], 4);
	TextDrawSetProportional(Inventory_BG[16], 0);
	TextDrawSetShadow(Inventory_BG[16], 0);

	Inventory_BG[17] = TextDrawCreate(96.911506, 190.891494, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[17], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[17], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[17], 1);
	TextDrawColor(Inventory_BG[17], -2139062017);
	TextDrawSetShadow(Inventory_BG[17], 0);
	TextDrawSetOutline(Inventory_BG[17], 0);
	TextDrawBackgroundColor(Inventory_BG[17], 255);
	TextDrawFont(Inventory_BG[17], 4);
	TextDrawSetProportional(Inventory_BG[17], 0);
	TextDrawSetShadow(Inventory_BG[17], 0);

	Inventory_BG[18] = TextDrawCreate(1.811282, 225.194076, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[18], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[18], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[18], 1);
	TextDrawColor(Inventory_BG[18], -2139062017);
	TextDrawSetShadow(Inventory_BG[18], 0);
	TextDrawSetOutline(Inventory_BG[18], 0);
	TextDrawBackgroundColor(Inventory_BG[18], 255);
	TextDrawFont(Inventory_BG[18], 4);
	TextDrawSetProportional(Inventory_BG[18], 0);
	TextDrawSetShadow(Inventory_BG[18], 0);

	Inventory_BG[19] = TextDrawCreate(33.611248, 225.194076, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[19], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[19], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[19], 1);
	TextDrawColor(Inventory_BG[19], -2139062017);
	TextDrawSetShadow(Inventory_BG[19], 0);
	TextDrawSetOutline(Inventory_BG[19], 0);
	TextDrawBackgroundColor(Inventory_BG[19], 255);
	TextDrawFont(Inventory_BG[19], 4);
	TextDrawSetProportional(Inventory_BG[19], 0);
	TextDrawSetShadow(Inventory_BG[19], 0);

	Inventory_BG[20] = TextDrawCreate(65.111183, 225.194076, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[20], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[20], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[20], 1);
	TextDrawColor(Inventory_BG[20], -2139062017);
	TextDrawSetShadow(Inventory_BG[20], 0);
	TextDrawSetOutline(Inventory_BG[20], 0);
	TextDrawBackgroundColor(Inventory_BG[20], 255);
	TextDrawFont(Inventory_BG[20], 4);
	TextDrawSetProportional(Inventory_BG[20], 0);
	TextDrawSetShadow(Inventory_BG[20], 0);

	Inventory_BG[21] = TextDrawCreate(96.911506, 225.194076, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[21], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[21], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[21], 1);
	TextDrawColor(Inventory_BG[21], -2139062017);
	TextDrawSetShadow(Inventory_BG[21], 0);
	TextDrawSetOutline(Inventory_BG[21], 0);
	TextDrawBackgroundColor(Inventory_BG[21], 255);
	TextDrawFont(Inventory_BG[21], 4);
	TextDrawSetProportional(Inventory_BG[21], 0);
	TextDrawSetShadow(Inventory_BG[21], 0);

	Inventory_BG[22] = TextDrawCreate(1.811282, 259.994232, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[22], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[22], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[22], 1);
	TextDrawColor(Inventory_BG[22], -2139062017);
	TextDrawSetShadow(Inventory_BG[22], 0);
	TextDrawSetOutline(Inventory_BG[22], 0);
	TextDrawBackgroundColor(Inventory_BG[22], 255);
	TextDrawFont(Inventory_BG[22], 4);
	TextDrawSetProportional(Inventory_BG[22], 0);
	TextDrawSetShadow(Inventory_BG[22], 0);

	Inventory_BG[23] = TextDrawCreate(33.611248, 259.994232, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[23], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[23], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[23], 1);
	TextDrawColor(Inventory_BG[23], -2139062017);
	TextDrawSetShadow(Inventory_BG[23], 0);
	TextDrawSetOutline(Inventory_BG[23], 0);
	TextDrawBackgroundColor(Inventory_BG[23], 255);
	TextDrawFont(Inventory_BG[23], 4);
	TextDrawSetProportional(Inventory_BG[23], 0);
	TextDrawSetShadow(Inventory_BG[23], 0);

	Inventory_BG[24] = TextDrawCreate(65.111183, 259.994232, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[24], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[24], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[24], 1);
	TextDrawColor(Inventory_BG[24], -2139062017);
	TextDrawSetShadow(Inventory_BG[24], 0);
	TextDrawSetOutline(Inventory_BG[24], 0);
	TextDrawBackgroundColor(Inventory_BG[24], 255);
	TextDrawFont(Inventory_BG[24], 4);
	TextDrawSetProportional(Inventory_BG[24], 0);
	TextDrawSetShadow(Inventory_BG[24], 0);

	Inventory_BG[25] = TextDrawCreate(96.911506, 259.994232, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[25], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[25], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[25], 1);
	TextDrawColor(Inventory_BG[25], -2139062017);
	TextDrawSetShadow(Inventory_BG[25], 0);
	TextDrawSetOutline(Inventory_BG[25], 0);
	TextDrawBackgroundColor(Inventory_BG[25], 255);
	TextDrawFont(Inventory_BG[25], 4);
	TextDrawSetProportional(Inventory_BG[25], 0);
	TextDrawSetShadow(Inventory_BG[25], 0);

	Inventory_BG[26] = TextDrawCreate(1.811282, 294.492828, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[26], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[26], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[26], 1);
	TextDrawColor(Inventory_BG[26], -2139062017);
	TextDrawSetShadow(Inventory_BG[26], 0);
	TextDrawSetOutline(Inventory_BG[26], 0);
	TextDrawBackgroundColor(Inventory_BG[26], 255);
	TextDrawFont(Inventory_BG[26], 4);
	TextDrawSetProportional(Inventory_BG[26], 0);
	TextDrawSetShadow(Inventory_BG[26], 0);

	Inventory_BG[27] = TextDrawCreate(33.466804, 294.288421, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[27], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[27], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[27], 1);
	TextDrawColor(Inventory_BG[27], -2139062017);
	TextDrawSetShadow(Inventory_BG[27], 0);
	TextDrawSetOutline(Inventory_BG[27], 0);
	TextDrawBackgroundColor(Inventory_BG[27], 255);
	TextDrawFont(Inventory_BG[27], 4);
	TextDrawSetProportional(Inventory_BG[27], 0);
	TextDrawSetShadow(Inventory_BG[27], 0);

	Inventory_BG[28] = TextDrawCreate(64.966735, 294.288421, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[28], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[28], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[28], 1);
	TextDrawColor(Inventory_BG[28], -2139062017);
	TextDrawSetShadow(Inventory_BG[28], 0);
	TextDrawSetOutline(Inventory_BG[28], 0);
	TextDrawBackgroundColor(Inventory_BG[28], 255);
	TextDrawFont(Inventory_BG[28], 4);
	TextDrawSetProportional(Inventory_BG[28], 0);
	TextDrawSetShadow(Inventory_BG[28], 0);

	Inventory_BG[29] = TextDrawCreate(96.467056, 294.288421, "LD_SPAC:white");
	TextDrawLetterSize(Inventory_BG[29], 0.000000, 0.000000);
	TextDrawTextSize(Inventory_BG[29], 29.000000, 32.000000);
	TextDrawAlignment(Inventory_BG[29], 1);
	TextDrawColor(Inventory_BG[29], -2139062017);
	TextDrawSetShadow(Inventory_BG[29], 0);
	TextDrawSetOutline(Inventory_BG[29], 0);
	TextDrawBackgroundColor(Inventory_BG[29], 255);
	TextDrawFont(Inventory_BG[29], 4);
	TextDrawSetProportional(Inventory_BG[29], 0);
	TextDrawSetShadow(Inventory_BG[29], 0);

	ClockTD[0] = TextDrawCreate(544.358215, 19.871158, "~p~PAYDAY~w~ IN: 12:00");
	TextDrawLetterSize(ClockTD[0], 0.174222, 1.127111);
	TextDrawAlignment(ClockTD[0], 1);
	TextDrawColor(ClockTD[0], -1);
	TextDrawSetShadow(ClockTD[0], 0);
	TextDrawSetOutline(ClockTD[0], 1);
	TextDrawBackgroundColor(ClockTD[0], 59);
	TextDrawFont(ClockTD[0], 2);
	TextDrawSetProportional(ClockTD[0], 1);
	TextDrawSetShadow(ClockTD[0], 0);

	ClockTD[1] = TextDrawCreate(576.577941, 46.157867, "12.12.1212");
	TextDrawLetterSize(ClockTD[1], 0.263999, 1.445689);
	TextDrawAlignment(ClockTD[1], 2);
	TextDrawColor(ClockTD[1], -1);
	TextDrawSetShadow(ClockTD[1], 0);
	TextDrawSetOutline(ClockTD[1], 1);
	TextDrawBackgroundColor(ClockTD[1], 59);
	TextDrawFont(ClockTD[1], 2);
	TextDrawSetProportional(ClockTD[1], 1);
	TextDrawSetShadow(ClockTD[1], 0);

	ClockTD[2] = TextDrawCreate(577.011352, 26.313432, "24:00");
	TextDrawLetterSize(ClockTD[2], 0.509777, 2.555733);
	TextDrawAlignment(ClockTD[2], 2);
	TextDrawColor(ClockTD[2], -1);
	TextDrawSetShadow(ClockTD[2], 0);
	TextDrawSetOutline(ClockTD[2], 1);
	TextDrawBackgroundColor(ClockTD[2], 59);
	TextDrawFont(ClockTD[2], 3);
	TextDrawSetProportional(ClockTD[2], 1);
	TextDrawSetShadow(ClockTD[2], 0);

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
	gFast[0] = (EOS);
	va_format(gFast, sizeof gFast, text, va_start<1>);
	return mysql_tquery(SQL, gFast);
}

stock isValidEmail(const email[])
{
	if(strlen(email) < 8 || strlen(email) > 128) return false;

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
	if(Iter_Contains(loggedPlayers, playerid)) return true;
	return false;
}

stock resetVars(playerid)
{
	GetPlayerName(playerid, playerInfo[playerid][pName], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, playerInfo[playerid][pLastIp], 16);
		
	playerInfo[playerid][pLogged] =
	playerInfo[playerid][pLoginEnabled] =
	playerInfo[playerid][pFlymode] =
	playerInfo[playerid][pMark] =
	playerInfo[playerid][pTutorial] = false;	

	playerInfo[playerid][pHours] =
	playerInfo[playerid][pSeconds] =
	playerInfo[playerid][pAFKSeconds] =
	playerInfo[playerid][pDrivingLicense] =
	playerInfo[playerid][pDrivingLicenseSuspend] =
	playerInfo[playerid][pFlyLicense] =
	playerInfo[playerid][pFlyLicenseSuspend] =
	playerInfo[playerid][pBoatLicense] =
	playerInfo[playerid][pBoatLicenseSuspend] =
	playerInfo[playerid][pWeaponLicense] =
	playerInfo[playerid][pWeaponLicenseSuspend] =
	playerInfo[playerid][pWarn] =
	playerInfo[playerid][pCuffed] =
	playerInfo[playerid][pTazer] =
	playerInfo[playerid][pAnimLooping] =
	playerInfo[playerid][pTaxiDuty] =
	playerInfo[playerid][pTaxiFare] =
	playerInfo[playerid][pInLesson] =
	playerInfo[playerid][pLesson] =
	playerInfo[playerid][pLicense] =
	playerInfo[playerid][pShowTurfs] =
	playerInfo[playerid][pOnTurf] =
	playerInfo[playerid][pFactionDuty] =
	playerInfo[playerid][pEnableBoost] =
	playerInfo[playerid][pDrunkLevel] =
	playerInfo[playerid][pFPS] =	
	playerInfo[playerid][pAdminDuty] =
	playerInfo[playerid][pLoginTries] =
	playerInfo[playerid][pHelper] =
	playerInfo[playerid][pRespectPoints] =
	playerInfo[playerid][pMute] = 0;	
	
	playerInfo[playerid][pCheckpointID] =
	playerInfo[playerid][pinVehicle] =
	playerInfo[playerid][pLiveOffer] =
	playerInfo[playerid][pTalkingLive] =
	playerInfo[playerid][pLicenseOffer] =
	playerInfo[playerid][pSafeID] =
	playerInfo[playerid][pSelectedItem] =
	playerInfo[playerid][pSpectate] = -1;

	playerInfo[playerid][pLastPosX] =
	playerInfo[playerid][pLastPosY] =
	playerInfo[playerid][pLastPosZ] =
	playerInfo[playerid][pMarkX] =
	playerInfo[playerid][pMarkY] =
	playerInfo[playerid][pMarkZ] = 0.0;

	playerInfo[playerid][pGender] = 1;
	playerInfo[playerid][pLevel] = 1;
	playerInfo[playerid][pMoney] = 2500;
	playerInfo[playerid][pBank] = 5000;
	playerInfo[playerid][pReportChat] = INVALID_PLAYER_ID;
	playerInfo[playerid][pVehicleSlots] = 2;
	playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
	playerInfo[playerid][pQuestionText] = (EOS);
	playerInfo[playerid][pAdminCover] = (EOS);
	playerInfo[playerid][pAdText] = (EOS);
	playerInfo[playerid][pContract] = -1;
	playerInfo[playerid][pContractID] = -1;
	playerInfo[playerid][pWorking] = 0;
	playerInfo[playerid][pFishSteps] = 0;
	playerInfo[playerid][pFishMoney] = 0;
	playerInfo[playerid][pFishCaught] = 0;
	playerInfo[playerid][pCertificateStep] = 0;
	playerInfo[playerid][pCertificateSeconds] = 0;

	if(IsValidVehicle(playerInfo[playerid][pExamVeh])) DestroyVehicle(playerInfo[playerid][pExamVeh]);

	playerInfo[playerid][pExamVeh] = INVALID_VEHICLE_ID;
	playerInfo[playerid][pExamenCP] = 0;

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
    return floatround(((floatsqroot(((x*x)+(y*y)+(z*z)))*(!mode ? 105.0 : 170.0 )))*0.98);
}

stock secinmin(secunde) {
	new hour = secunde / 60, minutes = secunde / 60 % 60, seconds = secunde % 60, secs[10];
	if(secunde >= 3600) format(secs, sizeof secs, "%02d:%02d.%d", hour, minutes, seconds);
	else format(secs, sizeof secs, "%02d:%02d", minutes, seconds);
	return secs;
}

stock sendPlayerSyntax(playerid, const text[], va_args<>) {
	gString[0] = (EOS);
	va_format(gString, sizeof gString, "Command: {FFFFFF}%s", text, va_start<2>);
	return SCM(playerid, COLOR_SYNTAX, gString);
}

stock va_PlayerTextDrawSetString(playerid, PlayerText:text, const string[], va_args<>) {
	gString[0] = (EOS);
	va_format(gString, sizeof gString, string, va_start<3>);
	return PlayerTextDrawSetString(playerid, text, gString);
}

stock clearChat(playerid, lines = 20) {
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
	gFast[0] = (EOS);
	va_format(gFast, 256, text, va_start<2>);
	foreach(new playerid : ServerAdmins) SCM(playerid, color, gFast);
	return true;
}

stock sendHelper(color, const text[], va_args<>)
{
	gFast[0] = (EOS);
	va_format(gFast, 256, text, va_start<2>);
	foreach(new playerid : ServerHelpers)  SCM(playerid, color, gFast);
	return true;
}

stock sendStaff(color, const text[], va_args<>)
{
	gFast[0] = (EOS);
	va_format(gFast, 256, text, va_start<2>);
	foreach(new playerid : ServerStaff)  SCM(playerid, color, gFast);
	return true;
}

stock oocNews(color, const text[], va_args<>) {
	gFast[0] = (EOS);
	va_format(gFast, 256, text, va_start<2>);
	foreach(new playerid : loggedPlayers) {
		if(playerInfo[playerid][pLiveToggle] == 0) SCM(playerid, color, gFast);
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
	return string_fast("%02d:%02d:%02d", hour, minute, second);
}

stock IsNumeric(const string:str[]) return !sscanf(str, "{i}");

stock examenFail(playerid) {
	if(IsValidVehicle(playerInfo[playerid][pExamVeh])) DestroyVehicle(playerInfo[playerid][pExamVeh]);
	DisablePlayerCheckpoint(playerid);
	playerInfo[playerid][pExamenCP] = 0;
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
		if(ReportInfo[x][reportID] == playerid) {
			haveReport = true;
			break;
		}
	}
	return haveReport;
}

stock GetReportID(playerid) {
	new id = INVALID_PLAYER_ID;
	foreach(new x : Reports) {
		if(ReportInfo[x][reportID] == playerid) {
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
	RemoveBuildingForPlayer(playerid, 16565, -318.7656, 1046.4688, 18.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, -308.2422, 1013.4609, 23.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, -308.2422, 1030.6719, 23.2031, 0.25);
	RemoveBuildingForPlayer(playerid, 16564, -318.7656, 1046.4688, 18.7344, 0.25);

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

stock PlayerMoney(playerid, amount) return GetPlayerCash(playerid) > amount ? (true) : (false);
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
		case 0: Add64Bit(StoreMoney[playerid], MoneyMoney[playerid], -money);
		case 1: Add64Bit(StoreMoney[playerid], MoneyMoney[playerid], money); 
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
	if(StoreMoney[playerid] > 0) return MoneyMoney[playerid] + (StoreMoney[playerid] * 1000000000);
	else return MoneyMoney[playerid];
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

stock Float:DistanceToPlayer(playerid, targetid) {
    new Float: X, Float: Y, Float: Z;
    GetPlayerPos(targetid, X, Y, Z);
    return GetPlayerDistanceFromPoint(playerid, X, Y, Z);
}