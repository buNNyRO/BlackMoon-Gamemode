//////////////////////////////////////////////////
//////    Dialogs                          //////
////////////////////////////////////////////////

Dialog:EMAIL(playerid, response, listitem, inputtext[])
{
	if(!response)
		return Dialog_Show(playerid, EMAIL, DIALOG_STYLE_INPUT, "E-Mail", "Scrie mai jos adresa ta de E-Mail:\n{afafaf}Trebuie sa completezi casuta de mai jos cu adresa ta de e-mail.", "Ok", "");

	if(!isValidEmail(inputtext))
		return Dialog_Show(playerid, EMAIL, DIALOG_STYLE_INPUT, "E-Mail", "Scrie mai jos adresa ta de E-Mail:\n{afafaf}Adresa de E-Mail introdusa nu este valid.", "Ok", "");
	
	format(playerInfo[playerid][pEMail], 128, inputtext);
	SCM(playerid, COLOR_YELLOWGREEN, string_fast("REGISTER: {ffffff}Adresa ta de E-Mail este: %s", inputtext));
	Dialog_Show(playerid, GENDER, DIALOG_STYLE_MSGBOX, "Gender", "Selecteaza mai jos sex-ul caracterului tau:", "Feminin", "Masculin");
	return true;
}

stock wrongPass(playerid)
{
	playerInfo[playerid][pLoginTries] ++;
	if(playerInfo[playerid][pLoginTries] == 3)
	{
		sendPlayerError(playerid, "Ai primit kick deoarece ai gresit parola de prea multe ori.");
		defer kickEx(playerid);
		return true;
	}

	Dialog_Show(playerid, LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Bine ai revenit, %s.\nScrie mai jos parola contului tau:\n{afafaf}Parola introdusa nu este corecta.", "Login", "Quit", getName(playerid));
	return true;
}

Dialog:GENDER(playerid, response, listitem, inputtext[])
{
	playerInfo[playerid][pGender] = FEMALE_GENDER;
	playerInfo[playerid][pSkin] = 12;
	playerInfo[playerid][pTutorialSeconds] = 4;
	playerInfo[playerid][pTutorialActive] = 1;
	tutorial[playerid] = repeat TimerTutorial(playerid);

	if(!response) {
		playerInfo[playerid][pGender] = MALE_GENDER;
		playerInfo[playerid][pSkin] = 250;
	}
	SetPlayerSkin(playerid, playerInfo[playerid][pSkin]);
	SCM(playerid, COLOR_YELLOWGREEN, string_fast("REGISTER: {ffffff}Sex-ul caracterului tau este: %s", (response) ? ("Feminin") : ("Masculin")));
	update("UPDATE `server_users` SET `EMail` = '%s', `Gender` = '%d', `Skin` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pEMail], playerInfo[playerid][pGender], playerInfo[playerid][pSkin], playerInfo[playerid][pSQLID]);
	return true;
}

Dialog:REGISTER(playerid, response, listitem, inputtext[])
{
	if(!response || playerInfo[playerid][pLogged] == true)
		return Kick(playerid);

	if(strlen(inputtext) < 6 || strlen(inputtext) > 32)
		return Dialog_Show(playerid, REGISTER, DIALOG_STYLE_PASSWORD, "Register", "Bine ai venit, %s.\nScrie mai jos parola pe care doresti sa o ai:\n\n{afafaf}Parola trebuie sa fie formata din 6 - 32 caractere.", "Register", "Quit", getName(playerid));
	
	SHA256_PassHash(inputtext, "fez9yGgHWUqF5hEw", playerInfo[playerid][pPassword], 65);

	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof(gQuery), "INSERT INTO `server_users` (Name, Password) VALUES ('%s', '%s')", getName(playerid), playerInfo[playerid][pPassword]);
	mysql_tquery(SQL, gQuery, "assignSQLID", "d", playerid);
	
	Dialog_Show(playerid, LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Te-ai inregistrat cu succes.\nScrie mai jos parola contului tau:", "Login", "Quit");
	return true;
}

Dialog:LOGIN(playerid, response, listitem, inputtext[])
{
	if(!response || playerInfo[playerid][pLogged] == true)
		return Kick(playerid);

	if(strlen(inputtext) < 6 || strlen(inputtext) > 32)
		return Dialog_Show(playerid, LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Bine ai revenit, %s.\nScrie mai jos parola contului tau:\n{afafaf}Parola introdusa nu este valida.", "Login", "Quit", getName(playerid));
	
	gQuery[0] = (EOS);
	SHA256_PassHash(inputtext, "fez9yGgHWUqF5hEw", playerInfo[playerid][pPassword], 65);
	mysql_format(SQL, gQuery, sizeof(gQuery), "SELECT * FROM `server_users` WHERE `Name` = '%s' AND `Password` = '%s' LIMIT 1", getName(playerid), playerInfo[playerid][pPassword]);
	mysql_pquery(SQL, gQuery, "onPlayerLogin", "d", playerid);
	return true;
}

Dialog:DIALOG_REPORT(playerid, response, listitem) {
	if(!response) return true;
	if(Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(playerInfo[playerid][pReportMute] > gettime()) return sendPlayerError(playerid, "Pentru a folosi aceasta comanda trebuie sa astepti %d secunde", (playerInfo[playerid][pReportMute] - gettime()));
	if(!Iter_Count(ServerAdmins)) return sendPlayerError(playerid, "Nu sunt admini conectati.");
	if(Iter_Count(Reports) >= MAX_REPORTS) return sendPlayerError(playerid, "Momentan sunt prea multe report-uri in asteptare.");
	switch(listitem) {
		case 0: Dialog_Show(playerid, DIALOG_REPORT_NORMAL, DIALOG_STYLE_INPUT, "Report: Normal", "Scrie mai jos problema pe care o ai:", "Ok", "Cancel");
		case 1: Dialog_Show(playerid, DIALOG_REPORT_CHEATER, DIALOG_STYLE_INPUT, "Report: Cheater", "Scrie mai jos numele/id-ul jucatorului care foloseste cheats:", "Ok", "Cancel");
		case 2: {
			new id = (Iter_Count(Reports) +1);
			reportInfo[id][reportID] = playerid;
			reportInfo[id][reportType] = REPORT_TYPE_STUCK;
			reportInfo[id][reportTimer] = defer ExpirationReport(id);
			format(reportInfo[id][reportText], 128, "Sunt blocat");
			Iter_Add(Reports, id);
			SCM(playerid, COLOR_GREY, "* Report trimis cu succes.");
			sendAdmin(COLOR_SERVER, "Notice Report: {ffffff}Report by %s (ID: %d | Level: %d): %s", getName(playerid), playerid, playerInfo[playerid][pLevel], reportInfo[id][reportText]);
			playerInfo[playerid][pReportMute] = (gettime() + 120);
		}
	}
	return true;
}

Dialog:DIALOG_REPORT_NORMAL(playerid, response, listitem, inputtext[]) {
	if(!response) return true;
	//if(Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	//if(playerInfo[playerid][pReportMute] > gettime()) return sendPlayerError(playerid, "Pentru a folosi aceasta comanda trebuie sa astepti %d secunde", (playerInfo[playerid][pReportMute] - gettime()));
	if(Iter_Count(Reports) >= MAX_REPORTS) return sendPlayerError(playerid, "Momentan sunt prea multe report-uri in asteptare.");
	if(!Iter_Count(ServerAdmins)) return sendPlayerError(playerid, "Nu sunt admini conectati.");
	if(strlen(inputtext) < 6 || strlen(inputtext) > 128) return Dialog_Show(playerid, DIALOG_REPORT_NORMAL, DIALOG_STYLE_INPUT, "Report: Normal", "Scrie mai jos problema pe care o ai:", "Ok", "Cancel");
	new id = (Iter_Count(Reports) +1);
	reportInfo[id][reportID] = playerid;
	reportInfo[id][reportType] = REPORT_TYPE_NORMAL;
	reportInfo[id][reportTimer] = defer ExpirationReport(id);
	format(reportInfo[id][reportText], 128, inputtext);
	Iter_Add(Reports, id);
	SCM(playerid, COLOR_GREY, "* Report trimis cu succes.");
	sendAdmin(COLOR_SERVER, "Notice Report: {ffffff}Report by %s (ID: %d | Level: %d): %s", getName(playerid), playerid, playerInfo[playerid][pLevel], reportInfo[id][reportText]);
	playerInfo[playerid][pReportMute] = (gettime() + 120);
	return true;
}

Dialog:DIALOG_REPORT_CHEATER(playerid, response, listitem, inputtext[]) {
	if(!response) return true;
	if(Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(playerInfo[playerid][pReportMute] > gettime()) return sendPlayerError(playerid, "Pentru a folosi aceasta comanda trebuie sa astepti %d secunde", (playerInfo[playerid][pReportMute] - gettime()));
	if(!Iter_Count(ServerAdmins)) return sendPlayerError(playerid, "Nu sunt admini conectati.");
	if(Iter_Count(Reports) >= MAX_REPORTS) return sendPlayerError(playerid, "Momentan sunt prea multe report-uri in asteptare.");
	if(isnull(inputtext)) return  Dialog_Show(playerid, DIALOG_REPORT_CHEATER, DIALOG_STYLE_INPUT, "Report: Cheater", "Scrie mai jos numele/id-ul jucatorului care foloseste cheats:", "Ok", "Cancel");
	new userid = INVALID_PLAYER_ID;
	if(sscanf(inputtext, "u", userid)) return Dialog_Show(playerid, DIALOG_REPORT_CHEATER, DIALOG_STYLE_INPUT, "Report: Cheater", "Scrie mai jos numele/id-ul jucatorului care foloseste cheats:", "Ok", "Cancel");
	if(!isPlayerLogged(userid)) return Dialog_Show(playerid, DIALOG_REPORT_CHEATER, DIALOG_STYLE_INPUT, "Report: Cheater", "Scrie mai jos numele/id-ul jucatorului care foloseste cheats:\n{afafaf} * Jucatorul nu este conectat.", "Ok", "Cancel");
	if(userid == playerid)  return Dialog_Show(playerid, DIALOG_REPORT_CHEATER, DIALOG_STYLE_INPUT, "Report: Cheater", "Scrie mai jos numele/id-ul jucatorului care foloseste cheats:\n{afafaf} * Nu iti poti da report singur.", "Ok", "Cancel");
	if(Iter_Contains(ServerAdmins, userid)) return Dialog_Show(playerid, DIALOG_REPORT_CHEATER, DIALOG_STYLE_INPUT, "Report: Cheater", "Scrie mai jos numele/id-ul jucatorului care foloseste cheats:\n{afafaf} * Nu poti da report unui administrator.", "Ok", "Cancel");
	new id = (Iter_Count(Reports) +1);
	reportInfo[id][reportID] = playerid;
	reportInfo[id][reportType] = REPORT_TYPE_CHEATER;
	reportInfo[id][reportPlayer] = userid;
	reportInfo[id][reportTimer] = defer ExpirationReport(id);
	format(reportInfo[id][reportText], 128, "%s ar putea folosi cheats", getName(userid));
	Iter_Add(Reports, id);
	SCM(playerid, COLOR_GREY, "* Jucatorul a fost raportat cu succes.");
	sendAdmin(COLOR_SERVER, "Notice Report: {ffffff}Report by %s (ID: %d | Level: %d): %s", getName(playerid), playerid, playerInfo[playerid][pLevel], reportInfo[id][reportText]);
	playerInfo[playerid][pReportMute] = (gettime() + 120);
	return true;
}

/*Dialog:DIALOG_CREATE_LABEL(playerid, response, listitem, inputtext[]) {
	if(!response) {
		DeletePVar(playerid, "LabelVW");
		DeletePVar(playerid, "LabelInt");
		return true;
	}
	if(playerInfo[playerid][pAdmin] < 6) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(Iter_Free(Labels) == -1) return sendPlayerError(playerid, "In acest moment, nu se pot creea pickup-uri, deoarece s-a atins numarul maxim.");
	if(isnull(inputtext) || strlen(inputtext) > 128) return Dialog_Show(playerid, DIALOG_CREATE_LABEL, DIALOG_STYLE_INPUT, "Create Label:", "Scrie mai jos ce text doresti sa aiba label-ul:", "Ok", "Cancel");
	new id = Iter_Free(Labels);
	labelInfo[id][labelInterior] = GetPVarInt(playerid, "LabelInt");
	labelInfo[id][labelVirtualWorld] = GetPVarInt(playerid, "LabelVW");
	GetPlayerPos(playerid, labelInfo[id][labelX],labelInfo[id][labelY],labelInfo[id][labelZ]);
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof gQuery, "INSERT INTO `server_labels` (`X`, `Y`, `Z`, `WorldID`, `Interior`, `Text`) VALUES('%f', '%f', '%f', '%d', '%d', '%s')", labelInfo[id][labelX],labelInfo[id][labelY],labelInfo[id][labelZ],labelInfo[id][labelVirtualWorld],labelInfo[id][labelInterior], inputtext);
	inline getLabelID() {
		if(!cache_affected_rows()) return sendPlayerError(playerid, "Nu s-a putut insera acest label in baza de date.");
		labelInfo[id][labelSQLID] = cache_insert_id();
		defer PickupLabel(playerid, id);
		return true;
	}
	mysql_pquery_inline(SQL, gQuery, using inline getLabelID, "");
	return true;
}*/

Dialog:SPAWNCHANGE(playerid, response, listitem) {
	if(!response) return true;
	switch(listitem) {
		case 0: {
			if(playerInfo[playerid][pSpawnChange] == 1) return sendPlayerError(playerid, "Ai deja selectat, spawn change-ul pe 'Spawn'.");
			playerInfo[playerid][pSpawnChange] = 1;	
		}
		case 1: {
			if(playerInfo[playerid][pHouse] == 0) return sendPlayerError(playerid, "Nu detii casa, nu poti selecta aceasta optiune.");
			if(playerInfo[playerid][pSpawnChange] == 2) return sendPlayerError(playerid, "Ai deja selectat, spawn change-ul pe 'House'.");
			playerInfo[playerid][pSpawnChange] = 2;	
		}
		case 2: {
			if(playerInfo[playerid][pRent] == -1) return sendPlayerError(playerid, "Nu detii rent, nu poti selecta aceasta optiune.");
			if(playerInfo[playerid][pSpawnChange] == 3) return sendPlayerError(playerid, "Ai deja selectat, spawn change-ul pe 'Rent'.");
			playerInfo[playerid][pSpawnChange] = 3;	
		}
		case 3: {
			if(playerInfo[playerid][pFaction] == 0) return sendPlayerError(playerid, "Nu ai o factiune, nu poti selecta aceasta optiune.");
			if(playerInfo[playerid][pSpawnChange] == 4) return sendPlayerError(playerid, "Ai deja selectat, spawn change-ul pe 'Faction'.");
			playerInfo[playerid][pSpawnChange] = 4;		
		}
	}
	update("UPDATE `server_users` SET `SpawnChange` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pSpawnChange], playerInfo[playerid][pSQLID]);
	SCM(playerid, COLOR_GREY, "* Spawn Change Notice: Actualizat.");
	return true;
}

Dialog:GPS(playerid, response, listitem) {
	if(!response) return true;
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	switch(listitem) {
		case 0: Dialog_Show(playerid, GPS1, DIALOG_STYLE_TABLIST_HEADERS, "SERVER: Locations - Los Santos", string_fast("Location\tDistance\nDMV\t%0.fm\nCNN\t%0.fm", GetDistanceBetweenPoints(X, Y, Z, 1111.0055,-1795.5551,16.5938), GetDistanceBetweenPoints(X, Y, Z, 1170.5859,-1489.6923,22.7554)), "Ok", "Cancel");
		case 1: Dialog_Show(playerid, GPS2, DIALOG_STYLE_TABLIST_HEADERS, "SERVER: Locations - Las Venturas", "Coming Soon ! Stay with us", "Ok", "Cancel");
		case 2: Dialog_Show(playerid, GPS3, DIALOG_STYLE_TABLIST_HEADERS, "SERVER: Locations - San Fierro", "Coming Soon ! Stay with us", "Ok", "Cancel");
		case 3: Dialog_Show(playerid, GPS4, DIALOG_STYLE_TABLIST_HEADERS, "SERVER: Locations - Special Locations", "Coming Soon ! Stay with us", "Ok", "Cancel");
	}
	return true;
}

Dialog:GPS1(playerid, response, listitem) {
	if(!response) return true;
	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(playerid, X, Y, Z);
	switch(listitem) {
		case 0: {
			SetPlayerCheckpoint(playerid, 1111.0055,-1795.5551,16.5938, 4.5);
			SCM(playerid, COLOR_LIGHTRED, string_fast("* GPS Notice:{ffffff} Locatia aleasa a fost {FF6347}'DMV'{ffffff}, distanta pana la checkpoint {FF6347}'%.2fm'{ffffff}.", GetDistanceBetweenPoints(X, Y, Z, 1111.0055,-1795.5551,16.5938)));
		}
		case 1: {
			SetPlayerCheckpoint(playerid, 1170.5859,-1489.6923,22.7554, 4.5);
			SCM(playerid, COLOR_LIGHTRED, string_fast("* GPS Notice:{ffffff} Locatia aleasa a fost {FF6347}'CNN'{ffffff}, distanta pana la checkpoint {FF6347}'%.2fm'{ffffff}.", GetDistanceBetweenPoints(X, Y, Z, 1170.5859,-1489.6923,22.7554)));
		}
	}
	playerInfo[playerid][pCheckpoint] = CHECKPOINT_GPS;
	playerInfo[playerid][pCheckpointID] = listitem;	
	return true;
}

Dialog:TOG(playerid, response, listitem) {
	if(!response) return true;
	switch(listitem) {
		case 0: {
			if(playerInfo[playerid][pLiveToggle] == 0) playerInfo[playerid][pLiveToggle] = 1;
			else if(playerInfo[playerid][pLiveToggle] == 1) playerInfo[playerid][pLiveToggle] = 0;
			update("UPDATE `server_users` SET `LiveToggle` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pLiveToggle], playerInfo[playerid][pSQLID]);
		}
	}
	SCM(playerid, COLOR_GREY, "* Tog Options: Actualizat.");
	return true;
}

Dialog:DIALOG_SHOP(playerid, response, listitem) {
	if(!response) return true;
	switch(listitem) {
		case 1: return true;
		case 2: {
			if(playerInfo[playerid][pPremium] == 0) return sendPlayerError(playerid, "Ai deja premium account.");
			if(playerInfo[playerid][pPremiumPoints] < 50) return sendPlayerError(playerid, "Nu ai 50 premium points.");
			playerInfo[playerid][pPremiumPoints] -= 50;
			playerInfo[playerid][pPremium] = 1;
			Iter_Add(PremiumPlayers, playerid);
			update("UPDATE `server_users` SET `Premium` = '1', `PremiumPoints`=PremiumPoints-50 WHERE `ID` = '%d'", playerInfo[playerid][pSQLID]);
			sendAdmin(COLOR_SERVER, "* Notice Shop: %s a cumparat 'Premium Account' cu 50 premium points.", getName(playerid));
			SCM(playerid, COLOR_SERVER, "* Shop: Ai cumparat 'Premium Account' cu 50 premium points.");
		}
		case 3: {
			if(playerInfo[playerid][pVIP] == 0) return sendPlayerError(playerid, "Ai deja VIP account.");
			if(playerInfo[playerid][pPremiumPoints] < 100) return sendPlayerError(playerid, "Nu ai 100 premium points.");
			playerInfo[playerid][pPremiumPoints] -= 100;
			playerInfo[playerid][pVIP] = 1;
			Iter_Add(VipPlayers, playerid);
			update("UPDATE `server_users` SET `VIP` = '1', `PremiumPoints`=PremiumPoints-100 WHERE `ID` = '%d'", playerInfo[playerid][pSQLID]);
			sendAdmin(COLOR_SERVER, "* Notice Shop: %s a cumparat 'VIP Account' cu 100 premium points.", getName(playerid));
			SCM(playerid, COLOR_SERVER, "* Shop: Ai cumparat 'VIP Account' cu 100 premium points.");			
		}
	}
	return true;
}

Dialog:DIALOG_HUD(playerid, response, listitem) {
	if(!response) return true;
	switch(listitem) {
		case 1: {
			if(playerInfo[playerid][pFPSShow]) {
				playerInfo[playerid][pFPSShow] = 1;
				//fpsShow[playerid] = repeat TimerFPS(playerid);
			}
			else {
				playerInfo[playerid][pFPSShow] = 0;
				//stop fpsShow[playerid];
			}	
		}
	}
	return true;
}
