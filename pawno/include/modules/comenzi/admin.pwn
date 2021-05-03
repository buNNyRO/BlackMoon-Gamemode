CMD:addexamcp(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 6) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(Iter_Count(ExamenCheckpoints) >= MAX_EXAM_CHECKPOINTS) return sendPlayerError(playerid, "Eroare ! Database:Limita de checkpoint-uri a fost atinsa !");
	new i = Iter_Free(ExamenCheckpoints);
	GetPlayerPos(playerid, examenInfo[i][dmvX], examenInfo[i][dmvY], examenInfo[i][dmvZ]);
	gQuery[0] = (EOS);
	inline assignCheckpointID() {
		Iter_Add(ExamenCheckpoints, i);
		examenInfo[i][dmvID] = cache_insert_id();
		SCM(playerid, COLOR_LIGHTRED, string_fast("Ai adaugat un nou checkpoint in DMV cu succes. (SQLID: %d)", examenInfo[i][dmvID]));
		return true;
	}
	mysql_format(SQL, gQuery, 128, "INSERT INTO `server_exam_checkpoints` (X, Y, Z) VALUES ('%f', '%f', '%f')", examenInfo[i][dmvX], examenInfo[i][dmvY], examenInfo[i][dmvZ]);
	mysql_pquery_inline(SQL, gQuery, using inline assignCheckpointID, "");
	return true;
}

CMD:warn(playerid, params[])
{
	if(!Iter_Contains(ServerAdmins, playerid))
		return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");

	if(GetPVarInt(playerid, "warnDeelay") > gettime())
		return sendPlayerError(playerid, "Trebuie sa astepti %d secunde inainte sa folosesti aceasta comanda.", (GetPVarInt(playerid, "warnDeelay") - gettime()));	

	new userID, reason[64];
	if(sscanf(params, "us[64]", userID, reason))
		return sendPlayerSyntax(playerid, "/warn <name/id> <reason>");

	if(!isPlayerLogged(userID))
		return sendPlayerError(playerid, "Jucatorul nu este conectat.");

	SendClientMessageToAll(COLOR_LIGHTRED, string_fast("AdmCmd: %s a primit un warn de la administratorul %s, motiv: %s.", getName(userID), getName(playerid), reason));
	warnPlayer(userID, playerid, reason);
	return true;
}

CMD:unwarn(playerid, params[])
{
	if(playerInfo[playerid][pAdmin] < 3)
		return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");

	if(GetPVarInt(playerid, "unWarnDeelay") > gettime())
		return sendPlayerError(playerid, "Trebuie sa astepti %d secunde inainte sa folosesti aceasta comanda.", (GetPVarInt(playerid, "unWarnDeelay") - gettime()));

	new userID, reason[64];
	if(sscanf(params, "us[64]", userID, reason))
		return sendPlayerSyntax(playerid, "/unwarn <name/id> <reason>");

	if(!isPlayerLogged(userID))
		return sendPlayerError(playerid, "Jucatorul nu este conectat.");

	if(playerInfo[userID][pWarn] == 0)
		return sendPlayerError(playerid, "Jucatorul nu are nici-un warn.");

	playerInfo[userID][pWarn] --;
	update("UPDATE `server_users` SET `Warn` = '%d' WHERE `ID` = '%d'", playerInfo[userID][pWarn], playerInfo[userID][pSQLID]);

	sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}%s a primit un clear warn de la Admin %s, motiv: %s", getName(userID), getName(playerid), reason);
	SCM(userID, COLOR_GREY, string_fast("* Ai primit un clear warn pe motiv: %s", reason));

	SetPVarInt(playerid, "unWarnDeelay", (gettime() + 60));
	return true;
}

CMD:ban(playerid, params[])
{
	if(!Iter_Contains(ServerAdmins, playerid))
		return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");

	if(GetPVarInt(playerid, "banDeelay") > gettime())
		return sendPlayerError(playerid, "Trebuie sa astepti %d secunde inainte sa folosesti aceasta comanda.", (GetPVarInt(playerid, "banDeelay") - gettime()));

	new userID, days, reason[64];
	if(sscanf(params, "uds[64]", userID, days, reason) || days < 0)
		return sendPlayerSyntax(playerid, "/ban <name/id> <days (0 = permanent)> <reason>");

	if(!isPlayerLogged(userID))
		return sendPlayerError(playerid, "Jucatorul nu este conectat.");

	if(playerid == userID)
		return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");

	if(playerInfo[userID][pAdmin] >= playerInfo[playerid][pAdmin] && !strmatch(getName(playerid), "Vicentzo"))
		return sendPlayerError(playerid, "Nu poti sa-i dai ban acelui jucator.");

	SendClientMessageToAll(COLOR_LIGHTRED, string_fast("AdmCmd: %s a primit ban %s de la %s, motiv: %s.", getName(userID), (days == 0) ? ("permanent") : (string_fast("%d zile", days)), getName(playerid), days, reason));
	banPlayer(userID, playerid, days, reason);
	return true;
}

CMD:banoffline(playerid, params[])
{
	if(!Iter_Contains(ServerAdmins, playerid))
		return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");

	if(GetPVarInt(playerid, "banDeelay") > gettime())
		return sendPlayerError(playerid, "Trebuie sa astepti %d secunde inainte sa folosesti aceasta comanda.", (GetPVarInt(playerid, "banDeelay") - gettime()));

	new playerName[MAX_PLAYER_NAME], playerID, days, reason[64];
	if(sscanf(params, "s[24]ds[64]", playerName, days, reason) || days < 0)
		return sendPlayerSyntax(playerid, "/banoffline <name> <days (0 = permanent)> <reason>");

	foreach(new i : loggedPlayers)
	{
		if(strmatch(getName(i), playerName))
			return sendPlayerError(playerid, "Jucatorul este conectat.");
	}

	inline checkAccount()
	{
		if(!cache_num_rows())
			return sendPlayerError(playerid, "Acest cont nu exista.");

		cache_get_value_name(0, "Name", playerName, MAX_PLAYER_NAME);
		cache_get_value_name_int(0, "ID", playerID);

		if(days)
		{
			va_SendClientMessageToAll(COLOR_LIGHTRED, "AdmCmd: %s (offline) a primit ban %d zile de la %s, motiv: %s", playerName, days, getName(playerid), reason);
		}
		else
		{
			va_SendClientMessageToAll(COLOR_LIGHTRED, "AdmCmd: %s (offline) a primit ban permanent de la %s, motiv: %s", playerName, getName(playerid), reason);
		}

		gQuery[0] = (EOS);
		mysql_format(SQL, gQuery, 256, "INSERT INTO `server_bans` (PlayerName, PlayerID, AdminName, AdminID, Reason, Days, Date) VALUES ('%s', '%d', '%s', '%d', '%s', '%d', '%s')", playerName, playerID, getName(playerid), playerInfo[playerid][pSQLID], reason, days, getDateTime());
		mysql_pquery(SQL, gQuery, "", "");

		SetPVarInt(playerid, "banDeelay", (gettime() + 60));	
		return true;
	}

	inline checkAccountInBanDatabase()
	{
		if(cache_num_rows())
			return sendPlayerError(playerid, "Acest cont este deja banat.");

		gQuery[0] = (EOS);
		mysql_format(SQL, gQuery, sizeof gQuery, "SELECT * FROM `server_users` WHERE `Name` = '%s' LIMIT 1", playerName);
		mysql_pquery_inline(SQL, gQuery, using inline checkAccount, "");
		return true;
	}

	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof gQuery, "SELECT * FROM `server_bans` WHERE `PlayerName` = '%s' AND `Active` = '1' LIMIT 1", playerName);
	mysql_pquery_inline(SQL, gQuery, using inline checkAccountInBanDatabase, "");
	return true;
}

CMD:unban(playerid, params[])
{
	if(playerInfo[playerid][pAdmin] < 3)
		return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");

	if(GetPVarInt(playerid, "unbanDeelay") > gettime())
		return sendPlayerError(playerid, "Trebuie sa astepti %d secunde inainte sa folosesti aceasta comanda.", (GetPVarInt(playerid, "unbanDeelay") - gettime()));

	if(isnull(params) || strlen(params) > MAX_PLAYER_NAME)
		return sendPlayerSyntax(playerid, "/unban <name>");

	gQuery[0] = (EOS);
	inline checkBanPlayer()
	{
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

	mysql_format(SQL, gQuery, 128, "SELECT * FROM `server_bans` WHERE `PlayerName` = '%s' AND `Active` = '1' LIMIT 1", params);
	mysql_pquery_inline(SQL, gQuery, using inline checkBanPlayer, "");
	return true;
}

CMD:mute(playerid, params[])
{
	if(!Iter_Contains(ServerAdmins, playerid))
		return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");

	if(GetPVarInt(playerid, "muteDeelay") > gettime())
		return sendPlayerError(playerid, "Trebuie sa astepti %d secunde inainte sa folosesti aceasta comanda.", (GetPVarInt(playerid, "muteDeelay") - gettime()));

	new userID, minutes, reason[64];
	if(sscanf(params, "uds[64]", userID, minutes, reason))
		return sendPlayerSyntax(playerid, "/mute <name/id> <minutes> <reason>");

	if(!isPlayerLogged(userID))
		return sendPlayerError(playerid, "Jucatorul nu este conectat.");

	if(userID == playerid)
		return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");

	if(minutes < 1 || minutes > 120)
		return sendPlayerError(playerid, "Numarul de minute introdus nu este valid (1 - 120).");

	if(playerInfo[userID][pMute] > gettime() && playerInfo[playerid][pAdmin] < 2)
		return sendPlayerError(playerid, "Jucatorul are deja mute.");

	if(playerInfo[userID][pAdmin] >= playerInfo[playerid][pAdmin] && !strmatch(getName(playerid), "Vicentzo"))
		return sendPlayerError(playerid, "Nu poti sa-i dai mute acelui jucator.");

	SendClientMessageToAll(COLOR_LIGHTRED, string_fast("AdmCmd: %s a primit mute %d minute de la administratorul %s, motiv: %s.", getName(userID), minutes, getName(playerid), reason));
	mutePlayer(userID, playerid, minutes, reason);
	return true;
}

CMD:unmute(playerid, params[])
{
	if(!Iter_Contains(ServerAdmins, playerid))
		return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");

	new userID, reason[32];
	if(sscanf(params, "us[32]", userID, reason))
		return sendPlayerSyntax(playerid, "/unmute <name/id> <reason>");

	if(!isPlayerLogged(userID))
		return sendPlayerError(playerid, "Jucatorul nu este conectat.");

	if(playerInfo[userID][pMute] < gettime())
		return sendPlayerError(playerid, "Jucatorul nu are mute.");

	playerInfo[userID][pMute] = 0;
	update("UPDATE `server_users` SET `Mute` = '0' WHERE `ID` = '%d'", playerInfo[userID][pSQLID]);

	if(Iter_Contains(MutedPlayers, userID))
		Iter_Remove(MutedPlayers, userID);

	SCM(userID, COLOR_GREY, string_fast("* Ai primit unmute de la %s, motiv: %s.", getName(playerid), reason));
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s i-a dat unmute lui %s, motiv: %s.", getName(playerid), getName(userID), reason);
	return true;
}

CMD:mutedplayers(playerid, params[])
{
	if(!Iter_Contains(ServerAdmins, playerid))
		return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");

	if(!Iter_Count(MutedPlayers))
		return sendPlayerError(playerid, "Nu sunt jucatori cu mute.");

	SCM(playerid, COLOR_GREY, "----------------------------------------");
	foreach(new i : MutedPlayers) {
		if(playerInfo[i][pMute] > gettime()) {
			SCM(playerid, COLOR_WHITE, string_fast("%s (%d) - Mute %d %s.", getName(i), i, ((playerInfo[i][pMute] - gettime()) > 60) ? ((playerInfo[i][pMute] - gettime()) / 60) : (playerInfo[i][pMute] - gettime()), ((playerInfo[i][pMute] - gettime()) > 60) ? ("minute") : ("secunde")));
		}
	}
	SCM(playerid, COLOR_GREY, "----------------------------------------");
	return true;
}

CMD:adminchat(playerid, params[])
{
	if(!Iter_Contains(ServerAdmins, playerid))
		return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");

	if(isnull(params))
		return sendPlayerSyntax(playerid, "/adminchat [text]");

	sendAdmin(COLOR_ADMINCHAT, "(%d) Admin %s: %s", playerInfo[playerid][pAdmin], getName(playerid), params);
	return true;
}

CMD:helperchat(playerid, params[])
{
	if(!Iter_Contains(ServerAdmins, playerid) && !Iter_Contains(ServerHelpers, playerid))
		return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");

	if(isnull(params))
		return sendPlayerSyntax(playerid, "/helperchat [text]");

	sendStaff(COLOR_HELPERCHAT, "(%d) %s %s: %s", (Iter_Contains(ServerAdmins, playerid)) ? (playerInfo[playerid][pAdmin]) : (playerInfo[playerid][pHelper]), (Iter_Contains(ServerAdmins, playerid)) ? ("Admin") : ("Helper"), getName(playerid), params);
	return true;
}

CMD:setadmin(playerid, params[])
{
	if(playerInfo[playerid][pAdmin] < 6 && !strmatch(getName(playerid), "Vicentzo"))
		return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");

	new userID, admin;
	if(sscanf(params, "ud", userID, admin) || admin < 0 || admin > 6)
		return sendPlayerSyntax(playerid, "/setadmin <name/id> <level admin (0 - 6)>");

	if(!isPlayerLogged(userID))
		return sendPlayerError(playerid, "Jucatorul nu este conectat.");

	if(playerInfo[userID][pAdmin] == admin)
		return sendPlayerError(playerid, "Jucatorul are deja acest nivel de admin.");

	TextDrawHideForPlayer(userID, serverInfoTD);

	if(admin)
		TextDrawShowForPlayer(userID, serverInfoTD);

	if(Iter_Contains(ServerAdmins, userID) && !admin) {
		Iter_Remove(ServerAdmins, userID);
		AllowPlayerTeleport(playerid, 0);
	} 

	if(!Iter_Contains(ServerAdmins, userID) && admin) {
		Iter_Add(ServerAdmins, userID);
		AllowPlayerTeleport(playerid, 1);
	}

	playerInfo[userID][pAdmin] = admin;
	update("UPDATE `server_users` SET `Admin` = '%d' WHERE `ID` = '%d'", admin, playerInfo[userID][pSQLID]);
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s i-a setat lui %s admin nivel %d.", getName(playerid), getName(userID), admin);
	SCM(userID, COLOR_YELLOW, string_fast("* Admin %s ti-a setat admin %d.", getName(playerid), admin));
	return true;
}

CMD:sethelper(playerid, params[])
{
	if(playerInfo[playerid][pAdmin] < 6 && !strmatch(getName(playerid), "Vicentzo"))
		return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");

	new userID, helper;
	if(sscanf(params, "ud", userID, helper) || helper < 0 || helper > 3)
		return sendPlayerSyntax(playerid, "/setadmin <name/id> <level helper (0 - 3)>");

	if(!isPlayerLogged(userID))
		return sendPlayerError(playerid, "Jucatorul nu este conectat.");

	if(playerInfo[userID][pHelper] == helper)
		return sendPlayerError(playerid, "Jucatorul are deja acest nivel de helper.");

	if(Iter_Contains(ServerHelpers, userID) && !helper)
		Iter_Remove(ServerHelpers, userID);

	if(!Iter_Contains(ServerHelpers, userID) && helper)
		Iter_Add(ServerHelpers, userID);

	playerInfo[userID][pHelper] = helper;
	update("UPDATE `server_users` SET `Helper` = '%d' WHERE `ID` = '%d'", helper, playerInfo[userID][pSQLID]);
	sendStaff(COLOR_SERVER, "Notice: {ffffff}Admin %s i-a setat lui %s helper nivel %d.", getName(playerid), getName(userID), helper);
	SCM(userID, COLOR_YELLOW, string_fast("* Admin %s ti-a setat helper nivel %d.", getName(playerid), helper));
	return true;
}

CMD:givemoney(playerid, params[])
{
	if(playerInfo[playerid][pAdmin] < 5)
		return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");

	new userID, money[25];
	if(sscanf(params, "us[25]", userID, money))
		return sendPlayerSyntax(playerid, "/givemoney <name/id> <money>");

	if(!isPlayerLogged(userID))
		return sendPlayerError(playerid, "Jucatorul nu este conectat.");

	if(CheckerBigInt(money) != 0) return true;
	Translate32Bit(StoreMoney[userID], MoneyMoney[userID], money);

	update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d' WHERE `ID` = '%d'", MoneyMoney[userID], StoreMoney[userID], playerInfo[userID][pSQLID]);
	SCM(userID, COLOR_GREY, string_fast("* Admin %s ti-a dat $%s in mana.", getName(playerid), formatNumberss(money)));
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s i-a dat $%s in mana lui %s (%d).", getName(playerid), formatNumberss(money), getName(userID), userID);
	return true;
}

CMD:adminsuspendlicense(playerid, params[])
{
	if(playerInfo[playerid][pAdmin] < 4)
		return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");

	new userID, license[32], hours;
	if(sscanf(params, "us[32]d", userID, license, hours))
	{
		sendPlayerSyntax(playerid, "/adminsuspendlicense <name/id> <license> <hours>");
		return SCM(playerid, COLOR_GREY, "Licenses: Driving, Flying, Boat, Weapon.");
	}

	if(!isPlayerLogged(userID))
		return sendPlayerError(playerid, "Jucatorul nu este conectat.");

	if(hours < 1 || hours > 15)
		return sendPlayerError(playerid, "Numarul de ore este Invalid (1 - 15).");

	switch(YHash(license))
	{
		case _H<driving>:
		{
			if(playerInfo[userID][pDrivingLicenseSuspend] == hours)
				return sendPlayerError(playerid, "Jucatorul are deja licenta de condus suspendata pentru %d ore.", hours);

			playerInfo[userID][pDrivingLicenseSuspend] = hours;
			playerInfo[userID][pDrivingLicense] = 0;

			sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}Admin %s i-a suspendat lui %s licenta de condus pentru %d ore.", getName(playerid), getName(userID), hours);
			SCM(userID, COLOR_GREY, string_fast("* Admin %s ti-a suspendat licenta de condus pentru %d ore.", getName(playerid), hours));
		}
		case _H<flying>:
		{
			if(playerInfo[userID][pFlyLicenseSuspend] == hours)
				return sendPlayerError(playerid, "Jucatorul are deja licenta de pilot pentru %d ore.", hours);

			playerInfo[userID][pFlyLicenseSuspend] = hours;
			playerInfo[userID][pFlyLicense] = 0;

			sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}Admin %s i-a suspendat lui %s licenta de pilot pentru %d ore.", getName(playerid), getName(userID), hours);
			SCM(userID, COLOR_GREY, string_fast("* Admin %s ti-a suspendat licenta de pilot pentru %d ore.", getName(playerid), hours));
		}
		case _H<boat>:
		{
			if(playerInfo[userID][pBoatLicenseSuspend] == hours)
				return sendPlayerError(playerid, "Jucatorul are deja licenta de navigatie pentru %d ore.", hours);

			playerInfo[userID][pBoatLicenseSuspend] = hours;
			playerInfo[userID][pBoatLicense] = 0;

			sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}Admin %s i-a suspendat lui %s licenta de boat pentru %d ore.", getName(playerid), getName(userID), hours);
			SCM(userID, COLOR_GREY, string_fast("* Admin %s ti-a suspendat licenta de boat pentru %d ore.", getName(playerid), hours));
		}
		case _H<weapon>:
		{
			if(playerInfo[userID][pWeaponLicenseSuspend] == hours)
				return sendPlayerError(playerid, "Jucatorul are deja licenta de navigatie pentru %d ore.", hours);

			playerInfo[userID][pWeaponLicenseSuspend] = hours;
			playerInfo[userID][pWeaponLicense] = 0;

			sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}Admin %s i-a suspendat lui %s licenta de port-arma pentru %d ore.", getName(playerid), getName(userID), hours);
			SCM(userID, COLOR_GREY, string_fast("* Admin %s ti-a suspendat licenta de port-arma pentru %d ore.", getName(playerid), hours));
		}
		default:
		{
			sendPlayerSyntax(playerid, "/adminsuspendlicense <name/id> <license> <hours>");
			return SCM(playerid, COLOR_GREY, "Licente: Driving, Flying, Boat, Weapon, All.");
		}
	}

	update("UPDATE `server_users` SET `Licenses` = '%d|%d|%d|%d|%d|%d|%d|%d' WHERE `ID` = '%d'", playerInfo[userID][pDrivingLicense], playerInfo[userID][pDrivingLicenseSuspend], playerInfo[userID][pWeaponLicense], playerInfo[userID][pWeaponLicenseSuspend], playerInfo[userID][pFlyLicense], playerInfo[userID][pFlyLicenseSuspend], playerInfo[userID][pBoatLicense], playerInfo[userID][pBoatLicenseSuspend], playerInfo[userID][pSQLID]);
	return true;
}

CMD:admingivelicense(playerid, params[])
{
	if(playerInfo[playerid][pAdmin] < 4)
		return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");

	new userID, license[32], hours;
	if(sscanf(params, "us[32]d", userID, license, hours))
	{
		sendPlayerSyntax(playerid, "/admingivelicense <name/id> <license> <hours>");
		return SCM(playerid, COLOR_GREY, "Licente: Driving, Flying, Boat, Weapon, All.");
	}

	if(!isPlayerLogged(userID))
		return sendPlayerError(playerid, "Jucatorul nu este conectat.");

	if(hours < 1 || hours > 300)
		return sendPlayerError(playerid, "Numarul de ore este Invalid (1 - 300).");

	switch(YHash(license))
	{
		case _H<driving>:
		{
			if(playerInfo[userID][pDrivingLicense] == hours)
				return sendPlayerError(playerid, "Jucatorul are deja licenta de condus pentru %d ore.", hours);

			if(playerInfo[userID][pDrivingLicenseSuspend] > 0 && playerInfo[playerid][pAdmin] < 6)
				return sendPlayerError(playerid, "Jucatorul are licenta de condus suspendata.");

			playerInfo[userID][pDrivingLicense] = hours;
			playerInfo[userID][pDrivingLicenseSuspend] = 0;

			sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}Admin %s i-a setat lui %s licenta de condus pentru %d ore.", getName(playerid), getName(userID), hours);
			SCM(userID, COLOR_GREY, string_fast("* Admin %s ti-a setat licenta de condus pentru %d ore.", getName(playerid), hours));
		}
		case _H<flying>:
		{
			if(playerInfo[userID][pFlyLicense] == hours)
				return sendPlayerError(playerid, "Jucatorul are deja licenta de pilot pentru %d ore.", hours);

			if(playerInfo[userID][pFlyLicenseSuspend] > 0 && playerInfo[playerid][pAdmin] < 6)
				return sendPlayerError(playerid, "Jucatorul are licenta de pilot suspendata.");

			playerInfo[userID][pFlyLicense] = hours;
			playerInfo[userID][pFlyLicenseSuspend] = 0;

			sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}Admin %s i-a setat lui %s licenta de pilot pentru %d ore.", getName(playerid), getName(userID), hours);
			SCM(userID, COLOR_GREY, string_fast("* Admin %s ti-a setat licenta de pilot pentru %d ore.", getName(playerid), hours));
		}
		case _H<boat>:
		{
			if(playerInfo[userID][pBoatLicense] == hours)
				return sendPlayerError(playerid, "Jucatorul are deja licenta de navigatie pentru %d ore.", hours);

			if(playerInfo[userID][pBoatLicenseSuspend] > 0 && playerInfo[playerid][pAdmin] < 6)
				return sendPlayerError(playerid, "Jucatorul are licenta de navigatie suspendata.");

			playerInfo[userID][pBoatLicense] = hours;
			playerInfo[userID][pBoatLicenseSuspend] = 0;

			sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}Admin %s i-a setat lui %s licenta de boat pentru %d ore.", getName(playerid), getName(userID), hours);
			SCM(userID, COLOR_GREY, string_fast("* Admin %s ti-a setat licenta de boat pentru %d ore.", getName(playerid), hours));
		}
		case _H<weapon>:
		{
			if(playerInfo[userID][pWeaponLicense] == hours)
				return sendPlayerError(playerid, "Jucatorul are deja licenta de navigatie pentru %d ore.", hours);

			if(playerInfo[userID][pWeaponLicenseSuspend] > 0 && playerInfo[playerid][pAdmin] < 6)
				return sendPlayerError(playerid, "Jucatorul are licenta de navigatie suspendata.");

			playerInfo[userID][pWeaponLicense] = hours;
			playerInfo[userID][pWeaponLicenseSuspend] = 0;

			sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}Admin %s i-a setat lui %s licenta de port-arma pentru %d ore.", getName(playerid), getName(userID), hours);
			SCM(userID, COLOR_GREY, string_fast("* Admin %s ti-a setat licenta de port-arma pentru %d ore.", getName(playerid), hours));
		}
		case _H<all>:
		{
			if((playerInfo[userID][pDrivingLicenseSuspend] || playerInfo[userID][pFlyLicenseSuspend] || playerInfo[userID][pBoatLicenseSuspend] || playerInfo[userID][pWeaponLicenseSuspend]) && playerInfo[playerid][pAdmin] < 6)
				return sendPlayerError(playerid, "Jucatorul are o licenta suspendata.");

			playerInfo[userID][pDrivingLicense] = playerInfo[userID][pFlyLicense] = playerInfo[userID][pBoatLicense] = playerInfo[userID][pWeaponLicense] = hours;
			playerInfo[userID][pDrivingLicenseSuspend] = playerInfo[userID][pFlyLicenseSuspend] = playerInfo[userID][pBoatLicenseSuspend] = playerInfo[userID][pWeaponLicenseSuspend] = 0;
			
			sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}Admin %s i-a setat lui %s toate licentele pentru %d ore.", getName(playerid), getName(userID), hours);
			SCM(userID, COLOR_GREY, string_fast("* Admin %s ti-a setat toate licentele pentru %d ore.", getName(playerid), hours));
		}
		default:
		{
			sendPlayerSyntax(playerid, "/admingivelicense <name/id> <license> <hours>");
			return SCM(playerid, COLOR_GREY, "Licente: Driving, Flying, Boat, Weapon, All.");
		}
	}
	update("UPDATE `server_users` SET `Licenses` = '%d|%d|%d|%d|%d|%d|%d|%d' WHERE `ID` = '%d'", playerInfo[userID][pDrivingLicense], playerInfo[userID][pDrivingLicenseSuspend], playerInfo[userID][pWeaponLicense], playerInfo[userID][pWeaponLicenseSuspend], playerInfo[userID][pFlyLicense], playerInfo[userID][pFlyLicenseSuspend], playerInfo[userID][pBoatLicense], playerInfo[userID][pBoatLicenseSuspend], playerInfo[userID][pSQLID]);
	return true;
}

CMD:admintakelicense(playerid, params[])
{
	if(playerInfo[playerid][pAdmin] < 4)
		return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");

	new userID, license[32];
	if(sscanf(params, "us[32]d", userID, license))
	{
		sendPlayerSyntax(playerid, "/admintakelicense <name/id> <license>");
		return SCM(playerid, COLOR_GREY, "Licente: Driving, Flying, Boat, Weapon, All.");
	}

	if(!isPlayerLogged(userID))
		return sendPlayerError(playerid, "Jucatorul nu este conectat.");

	switch(YHash(license))
	{
		case _H<driving>:
		{
			if(playerInfo[userID][pDrivingLicense] == 0)
				return sendPlayerError(playerid, "Jucatorul nu are licenta de condus.");

			if(playerInfo[userID][pDrivingLicenseSuspend] > 0 && playerInfo[playerid][pAdmin] < 6)
				return sendPlayerError(playerid, "Jucatorul are licenta de condus suspendata.");

			playerInfo[userID][pDrivingLicense] = 0;
			playerInfo[userID][pDrivingLicenseSuspend] = 0;

			sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}Admin %s i-a sters lui %s licenta de condus.", getName(playerid), getName(userID));
			SCM(userID, COLOR_GREY, string_fast("* Admin %s ti-a sters licenta de condus.", getName(playerid)));
		}
		case _H<flying>:
		{
			if(playerInfo[userID][pFlyLicense] == 0)
				return sendPlayerError(playerid, "Jucatorul nu are licenta de pilot.");

			if(playerInfo[userID][pFlyLicenseSuspend] > 0 && playerInfo[playerid][pAdmin] < 6)
				return sendPlayerError(playerid, "Jucatorul are licenta de pilot suspendata.");

			playerInfo[userID][pFlyLicense] = 0;
			playerInfo[userID][pFlyLicenseSuspend] = 0;

			sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}Admin %s i-a sters lui %s licenta de pilot.", getName(playerid), getName(userID));
			SCM(userID, COLOR_GREY, string_fast("* Admin %s ti-a sters licenta de pilot.", getName(playerid)));
		}
		case _H<boat>:
		{
			if(playerInfo[userID][pBoatLicense] == 0)
				return sendPlayerError(playerid, "Jucatorul nu are licenta de navigatie.");

			if(playerInfo[userID][pBoatLicenseSuspend] > 0 && playerInfo[playerid][pAdmin] < 6)
				return sendPlayerError(playerid, "Jucatorul are licenta de navigatie suspendata.");

			playerInfo[userID][pBoatLicense] = 0;
			playerInfo[userID][pBoatLicenseSuspend] = 0;

			sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}Admin %s i-a sters lui %s licenta de navigatie.", getName(playerid), getName(userID));
			SCM(userID, COLOR_GREY, string_fast("* Admin %s ti-a sters licenta de navigatie.", getName(playerid)));
		}
		case _H<weapon>:
		{
			if(playerInfo[userID][pWeaponLicense] == 0)
				return sendPlayerError(playerid, "Jucatorul nu are licenta de port-arma.");

			if(playerInfo[userID][pWeaponLicenseSuspend] > 0 && playerInfo[playerid][pAdmin] < 6)
				return sendPlayerError(playerid, "Jucatorul are licenta de port-arma suspendata.");

			playerInfo[userID][pWeaponLicense] = 0;
			playerInfo[userID][pWeaponLicenseSuspend] = 0;

			sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}Admin %s i-a sters lui %s licenta de port-arma.", getName(playerid), getName(userID));
			SCM(userID, COLOR_GREY, string_fast("* Admin %s ti-a sters licenta de port-arma.", getName(playerid)));
		}
		case _H<all>:
		{
			if((playerInfo[userID][pDrivingLicenseSuspend] || playerInfo[userID][pFlyLicenseSuspend] || playerInfo[userID][pBoatLicenseSuspend] || playerInfo[userID][pWeaponLicenseSuspend]) && playerInfo[playerid][pAdmin] < 6)
				return sendPlayerError(playerid, "Jucatorul are o licenta suspendata.");

			playerInfo[userID][pDrivingLicense] = playerInfo[userID][pFlyLicense] = playerInfo[userID][pBoatLicense] = playerInfo[userID][pWeaponLicense] = 0;
			playerInfo[userID][pDrivingLicenseSuspend] = playerInfo[userID][pFlyLicenseSuspend] = playerInfo[userID][pBoatLicenseSuspend] = playerInfo[userID][pWeaponLicenseSuspend] = 0;
			
			sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}Admin %s i-a sters lui %s toate licentele.", getName(playerid), getName(userID));
			SCM(userID, COLOR_GREY, string_fast("* Admin %s ti-a sters toate licentele.", getName(playerid)));
		}
		default:
		{
			sendPlayerSyntax(playerid, "/admintakelicense <name/id> <license>");
			return SCM(playerid, COLOR_GREY, "Licente: Driving, Flying, Boat, Weapon, All.");
		}
	}
	update("UPDATE `server_users` SET `Licenses` = '%d|%d|%d|%d|%d|%d|%d|%d' WHERE `ID` = '%d'", playerInfo[userID][pDrivingLicense], playerInfo[userID][pDrivingLicenseSuspend], playerInfo[userID][pWeaponLicense], playerInfo[userID][pWeaponLicenseSuspend], playerInfo[userID][pFlyLicense], playerInfo[userID][pFlyLicenseSuspend], playerInfo[userID][pBoatLicense], playerInfo[userID][pBoatLicenseSuspend], playerInfo[userID][pSQLID]);
	return true;
}

CMD:kick(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(GetPVarInt(playerid, "kickDeelay") >= gettime()) return sendPlayerError(playerid, "Trebuie sa astepti %d secunde inainte de a folosi aceasta comanda.", (GetPVarInt(playerid, "kickDeelay") - gettime()));
	new id, silent, reason[64];
	if(sscanf(params, "uds[64]", id, silent, reason)) return sendPlayerSyntax(playerid, "/kick <name/id> <silent> <reason>");
	if(silent < 0 || silent > 1) return sendPlayerError(playerid, "Silent Invalid. ( 0 = Normal | 1 = Silent )");
	if(!isPlayerLogged(id)) return sendPlayerError(playerid, "Jucatorul nu este conectat.");
	if(id == playerid) return sendPlayerError(playerid, "Nu poti folosi comanda, asupra ta.");
	if(playerInfo[id][pAdmin] >= playerInfo[playerid][pAdmin] && !strmatch(getName(playerid), "Vicentzo")) return sendPlayerError(playerid, "Nu poti sa-i dai kick acestui jucator.");
	kickPlayer(id, playerid, silent, reason);
	return true;
}

CMD:spawncar(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(Iter_Count(AdminVehicles) >= MAX_ADMIN_VEHICLES) return sendPlayerError(playerid, "Nu poti crea un vehicul deoarece s-a atins numarul maxim de vehicule (Vehicule Existente: %d | Numar Maxim: %d)", Iter_Count(AdminVehicles), MAX_ADMIN_VEHICLES);
	if(playerInfo[playerid][pDrivingLicense] == 0 && playerInfo[playerid][pFlyLicense] == 0 && playerInfo[playerid][pBoatLicense] == 0) return sendPlayerError(playerid, "Nu poti spawna o masina deoarece nu ai licenta de condus / navigatie / pilot.");
	new modelid, firstcolor, secondcolor, Float:x, Float:y, Float:z, Float:angle;
	if(sscanf(params, "ddd", modelid, firstcolor, secondcolor)) return sendPlayerSyntax(playerid, "/spawncar <model id> <first color> <second color>");
	if(modelid < 400 || modelid > 611) return sendPlayerError(playerid, "Invalid Model ID (400 - 611).");
	if(firstcolor < 0 || firstcolor > 255) return sendPlayerError(playerid, "Invalid First Color (0 - 255).");
	if(secondcolor < 0 || secondcolor > 255) return sendPlayerError(playerid, "Invalid Second Color (0 - 255).");
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);
	new carid = CreateVehicle(modelid, x, y, z, angle, firstcolor, secondcolor, -1);
	PutPlayerInVehicle(playerid, carid, 0);
	Iter_Add(AdminVehicles, carid);
	vehicle_fuel[carid] = 100.0;
	vehicle_personal[carid] = -1;
	sendAdmin(COLOR_SERVER, "Notice: {ffffff} Admin %s a creat un vehicul %s (ID: %d | Numar Vehicule Spawnate: %d)", getName(playerid), getVehicleName(modelid), carid, Iter_Count(AdminVehicles));
	return true;
}

CMD:despawncar(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(!IsPlayerInAnyVehicle(playerid)) {
		if(isnull(params)) return sendPlayerSyntax(playerid, "/despawncar <vehicle id>");
		if(!IsValidVehicle(strval(params))) return sendPlayerError(playerid, "Acest vehicul nu exista.");
		if(!Iter_Contains(AdminVehicles, strval(params))) return sendPlayerError(playerid, "Acest vehicul nu a fost creat de catre un admin.");
		sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s a distrus vehiculul %s (ID: %d | Numar Vehicule Spawnate: %d)", getName(playerid), getVehicleName(GetVehicleModel(strval(params))), strval(params), Iter_Count(AdminVehicles));
		Iter_Remove(AdminVehicles, strval(params));
		DestroyVehicle(strval(params));
		vehicle_engine[strval(params)] = false;	 
		vehicle_lights[strval(params)] = false;	 
		vehicle_bonnet[strval(params)] = false;	 
		vehicle_boot[strval(params)] = false;	
		vehicle_fuel[strval(params)] = 100.0;
		return true; 
	}	
	new vehicleid = GetPlayerVehicleID(playerid);
	if(!Iter_Contains(AdminVehicles, vehicleid)) return sendPlayerError(playerid, "Acest vehicul nu a fost spawnat de un admin.");
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s a distrus vehiculul %s (ID: %d | Numar Vehicule Spawnate: %d)", getName(playerid), getVehicleName(GetVehicleModel(vehicleid)), vehicleid, Iter_Count(AdminVehicles));
	Iter_Remove(AdminVehicles, vehicleid);
	DestroyVehicle(vehicleid);	
	vehicle_engine[vehicleid] = false;
	vehicle_lights[vehicleid] = false;
	vehicle_bonnet[vehicleid] = false;
	vehicle_boot[vehicleid] = false;	
	vehicle_fuel[vehicleid] = 100.0;
	return true;
}

CMD:despawncars(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(!Iter_Count(AdminVehicles)) return sendPlayerError(playerid, "Nu sunt vehicule create pe server.");
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s a sters toate vehiculele spawnate (Numar maxim masini: %d | Numar vehicule despawnate: %d)", getName(playerid), MAX_ADMIN_VEHICLES, Iter_Count(AdminVehicles));
	foreach(new x : AdminVehicles) {
		vehicle_engine[x] = false;
		vehicle_lights[x] = false;
		vehicle_bonnet[x] = false;
		vehicle_boot[x] = false;	
		vehicle_fuel[x] = 100.0;	
		DestroyVehicle(x);
	}
	Iter_Clear(AdminVehicles);	
	return true;
}

CMD:gotocar(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Trebuie sa cobori jos din vehicul.");
	if(isnull(params) || !IsNumeric(params)) return sendPlayerSyntax(playerid, "/gotocar <vehicle id>");
	if(!IsValidVehicle(strval(params))) return sendPlayerError(playerid, "Vehiculul nu exista.");
	new Float:x, Float:y, Float:z;
	GetVehiclePos(strval(params), x, y, z);
	SetPlayerPos(playerid, x, (y + 3), z);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, GetVehicleVirtualWorld(strval(params)));
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s s-a teleportat la vehiculul %s (ID: %d).", getName(playerid), getVehicleName(GetVehicleModel(strval(params))), strval(params));
	return true;
}

CMD:getcar(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Trebuie sa cobori jos din vehicul.");
	if(isnull(params) || !IsNumeric(params)) return sendPlayerSyntax(playerid, "/getcar <vehicle id>");
	if(!IsValidVehicle(strval(params))) return sendPlayerError(playerid, "Vehiculul nu exista.");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	SetVehiclePos(strval(params), x, (y + 2), z);
	SetVehicleVirtualWorld(strval(params), GetPlayerVirtualWorld(playerid));
	LinkVehicleToInterior(strval(params), GetPlayerInterior(playerid));
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s a teleportat vehiculul %s (ID: %d) la el.", getName(playerid), getVehicleName(GetVehicleModel(strval(params))), strval(params));
	return true;
}

CMD:slapcar(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(IsPlayerInAnyVehicle(playerid)) {
		new Float:x, Float:y, Float:z;
		GetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);	
		SetVehiclePos(GetPlayerVehicleID(playerid), x, y, (z +5));
		sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s a palmuit vehiculul %s (ID: %d).", getName(playerid), getVehicleName(GetVehicleModel(GetPlayerVehicleID(playerid))), GetPlayerVehicleID(playerid));	
		return true;
	}
	if(isnull(params) || !IsNumeric(params)) return sendPlayerSyntax(playerid, "/slapcar <vehicle id>");
	if(!IsValidVehicle(strval(params))) return sendPlayerError(playerid, "Vehiculul nu exista.");
	new Float:x, Float:y, Float:z;
	GetVehiclePos(strval(params), x, y, z);	
	SetVehiclePos(strval(params), x, y, (z +5));
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s a palmuit vehiculul %s (ID: %d).", getName(playerid), getVehicleName(GetVehicleModel(strval(params))), strval(params));		
	return true;
}

CMD:fixveh(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(IsPlayerInAnyVehicle(playerid)) {
		RepairVehicle(GetPlayerVehicleID(playerid));
		sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s a reparat vehiculul %s (ID: %d).", getName(playerid), getVehicleName(GetVehicleModel(GetPlayerVehicleID(playerid))), GetPlayerVehicleID(playerid));
		return true;
	}
	if(isnull(params) || !IsNumeric(params)) return sendPlayerSyntax(playerid, "/fixveh <vehicle id>");
	if(!IsValidVehicle(strval(params))) return sendPlayerError(playerid, "Vehiculul nu exista.");
	RepairVehicle(strval(params));
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s a reparat vehiculul %s (ID: %d).", getName(playerid), getVehicleName(GetVehicleModel(strval(params))), strval(params));		
	return true;
}

CMD:addnos(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(IsPlayerInAnyVehicle(playerid)) {
		AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
		sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s a adaugat nitro vehiculului %s (ID: %d).", getName(playerid), getVehicleName(GetVehicleModel(GetPlayerVehicleID(playerid))), GetPlayerVehicleID(playerid));
		return true;
	}
	if(isnull(params) || !IsNumeric(params)) return sendPlayerSyntax(playerid, "/addnos <vehicle id>");
	if(!IsValidVehicle(strval(params))) return sendPlayerError(playerid, "Vehiculul nu exista.");
	AddVehicleComponent(strval(params), 1010);	
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s a adaugat nitro vehiculului %s (ID: %d).", getName(playerid), getVehicleName(GetVehicleModel(strval(params))), strval(params));		
	return true;
}

CMD:flipveh(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(IsPlayerInAnyVehicle(playerid)) {
		new Float:vehAngle;
		GetVehicleZAngle(GetPlayerVehicleID(playerid), vehAngle);
		SetVehicleZAngle(GetPlayerVehicleID(playerid), vehAngle);
		sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s a dat flip la vehiculul %s (ID: %d).", getName(playerid), getVehicleName(GetVehicleModel(GetPlayerVehicleID(playerid))), GetPlayerVehicleID(playerid));
		return true;
	}	
	if(isnull(params) || !IsNumeric(params)) return sendPlayerSyntax(playerid, "/flipveh <vehicle id>");
	if(!IsValidVehicle(strval(params))) return sendPlayerError(playerid, "Vehiculul nu exista.");
	new Float:vehAngle;
	GetVehicleZAngle(strval(params), vehAngle);
	SetVehicleZAngle(strval(params), vehAngle);	
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s a dat flip la vehiculul %s (ID: %d).", getName(playerid), getVehicleName(GetVehicleModel(strval(params))), strval(params));		
	return true;
}

CMD:closestcar(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Trebuie sa cobori jos din vehicul.");
	new vehicleID = GetClosestVehicle(playerid);
	if(!IsValidVehicle(vehicleID)) return sendPlayerError(playerid, "Nu a fost gasit un vehicul in raza ta.");
	PutPlayerInVehicle(playerid, vehicleID, 0);
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s a intrat in vehiculul %s (ID: %d).", getName(playerid), getVehicleName(GetVehicleModel(vehicleID)), vehicleID);
	return true;
}

CMD:entercar(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Trebuie sa cobori jos din vehicul.");
	new vehicleid, seatid;
	if(sscanf(params, "dd", vehicleid, seatid)) return sendPlayerSyntax(playerid, "/entercar <vehicle id> <seat id>");
	if(!IsValidVehicle(vehicleid)) return sendPlayerError(playerid, "Invalid vehicle id.");
	if(seatid < 0 || seatid > 4) return sendPlayerError(playerid, "Invalid seat id.");
	if(isBike(vehicleid) && seatid > 0) return sendPlayerError(playerid, "Acel vehicul nu are mai mult de un loc disponibil.");
	if(isMotor(vehicleid) && seatid > 1) return sendPlayerError(playerid, "Acel vehicul nu are mai mult de doua locuri disponibile.");
	PutPlayerInVehicle(playerid, vehicleid, seatid);
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s s-a teleportat in vehiculul %s (ID: %d)", getName(playerid), getVehicleName(GetVehicleModel(vehicleid)), vehicleid);
	return true;
}

CMD:fly(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(playerInfo[playerid][pFlymode] == true) {
		playerInfo[playerid][pFlymode] = false;
		StopFly(playerid);
		SetPlayerHealthEx(playerid, 100);
		return true;
	}
	playerInfo[playerid][pFlymode] = true;
	SetPlayerHealthEx(playerid, 999999999);
	StartFly(playerid);
	return true;
}

CMD:goto(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	new id = INVALID_PLAYER_ID, Float:x, Float:y, Float:z;
	if(sscanf(params, "u", id)) return sendPlayerSyntax(playerid, "/goto <name/id>");
	if(!isPlayerLogged(id)) return sendPlayerError(playerid, "Jucatorul nu este conectat.");
	if(id == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
	SetPlayerInterior(playerid, GetPlayerInterior(id));
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s s-a teleportat la %s.", getName(playerid), getName(id));
	SCM(id, COLOR_GREY, string_fast("* Admin %s s-a teleportat la tine.", getName(playerid)));
	GetPlayerPos(id, x, y, z);
	if(GetPlayerState(id) == PLAYER_STATE_DRIVER) {
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), GetPlayerVirtualWorld(id));
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(id));
		return SetVehiclePos(GetPlayerVehicleID(playerid), x, (y + 4), z);
	}
	if(GetPlayerState(id) == PLAYER_STATE_DRIVER || GetPlayerState(id) == PLAYER_STATE_PASSENGER) {
		if(getVehicleMaxSeats(GetVehicleModel(GetPlayerVehicleID(playerid))) > 0) {
			for(new i = 0; i < getVehicleMaxSeats(GetVehicleModel(GetPlayerVehicleID(playerid))); i++) {
				if(IsSeatTaked(GetPlayerVehicleID(id), i)) return PutPlayerInVehicle(playerid, GetPlayerVehicleID(id), i);
			}
		}
	}
	SetPlayerPos(playerid, x, (y +4), z);
	return true;
}

CMD:gethere(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	new id = INVALID_PLAYER_ID, Float:x, Float:y, Float:z;
	if(sscanf(params, "u", id)) return sendPlayerSyntax(playerid, "/gethere <name/id>");
	if(!isPlayerLogged(id)) return sendPlayerError(playerid, "Jucatorul nu este conectat.");
	if(id == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	SetPlayerVirtualWorld(id, GetPlayerVirtualWorld(playerid));
	SetPlayerInterior(id, GetPlayerInterior(playerid));
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s l-a teleportat pe %s la el.", getName(playerid), getName(id));
	SCM(id, COLOR_GREY, string_fast("* Admin %s te-a teleportat la el.", getName(playerid)));
	GetPlayerPos(playerid, x, y, z);
	if(GetPlayerState(id) == PLAYER_STATE_DRIVER) {
		SetVehicleVirtualWorld(GetPlayerVehicleID(id), GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(GetPlayerVehicleID(id), GetPlayerInterior(playerid));
		return SetVehiclePos(GetPlayerVehicleID(id), x, (y + 4), z);
	}
	SetPlayerPos(id, x, (y +4), z);
	return true;
}

CMD:slap(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	new id = INVALID_PLAYER_ID, Float:x, Float:y, Float:z, Float:health;
	if(sscanf(params, "u", id)) return sendPlayerSyntax(playerid, "/slap <name/id>");
	if(!isPlayerLogged(id)) return sendPlayerError(playerid, "Jucatorul nu este conectat.");
	GetPlayerPos(id, x, y, z);
	SetPlayerPos(id, x, y, (z + 5));
	GetPlayerHealthEx(id, health);
	SetPlayerHealthEx(id, health - 5);
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s i-a dat slap lui %s.", getName(playerid), getName(id));
	SCM(id, COLOR_GREY, string_fast("* Admin %s ti-a dat slap.", getName(playerid)));
	return true;
}

CMD:freeze(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	new id = INVALID_PLAYER_ID;
	if(sscanf(params, "u", id)) return sendPlayerSyntax(playerid, "/freeze <name/id>");
	if(!isPlayerLogged(id)) return sendPlayerError(playerid, "Jucatorul nu este conectat.");
	TogglePlayerControllable(id, false);
	playerInfo[playerid][pFreeze] = true;
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s i-a dat freeze lui %s.", getName(playerid), getName(id));
	SCM(id, COLOR_GREY, string_fast("* Admin %s ti-a dat freeze.", getName(playerid)));
	return true;
}

CMD:unfreeze(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	new id = INVALID_PLAYER_ID;
	if(sscanf(params, "u", id)) return sendPlayerSyntax(playerid, "/unfreeze <name/id>");
	if(!isPlayerLogged(id)) return sendPlayerError(playerid, "Jucatorul nu este conectat.");
	TogglePlayerControllable(id, true);
	playerInfo[playerid][pFreeze] = false;
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s i-a dat unfreeze lui %s.", getName(playerid), getName(id));
	SCM(id, COLOR_GREY, string_fast("* Admin %s ti-a dat unfreeze.", getName(playerid)));
	return true;
}

CMD:set(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 6) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	new id = INVALID_PLAYER_ID, option[32], value;
	if(sscanf(params, "us[32]d", id, option, value)) {
		sendPlayerSyntax(playerid, "/set <name/id> <option> <result>");
		return SCM(playerid, COLOR_GREY, "Optiuni: Money, Billion, MBank, Bank, Health, Armour, Level, RespectPoints, Skin.");
	}
	if(!isPlayerLogged(id)) return sendPlayerError(playerid, "Jucatorul nu este conectat.");
	switch(YHash(option)) {
		case _H<money>: {
			if(value < 0 || value > 2000000000) return sendPlayerError(playerid, "Result Invalid (0 - 2,000,000,000).");
			if(id != INVALID_PLAYER_ID) MoneyMoney[id] = value;
			update("UPDATE `server_users` SET `Money` = '%d' WHERE `ID` = '%d'", value, playerInfo[id][pSQLID]);
		}
		case _H<billion>: {
			if(value < 0 || value > 100) return sendPlayerError(playerid, "Result Invalid (0 - 100).");
			if(id != INVALID_PLAYER_ID) StoreMoney[id] = value;
			update("UPDATE `server_users` SET `MStore` = '%d' WHERE `ID` = '%d'", value, playerInfo[id][pSQLID]);
		}
		case _H<bank>: {
			if(id != INVALID_PLAYER_ID) playerInfo[id][pBank] =  value;
			update("UPDATE `server_users` SET `Bank` = '%d' WHERE `ID` = '%d'", playerInfo[id][pBank], playerInfo[id][pSQLID]);
		}
		case _H<mbank>: {
			if(id != INVALID_PLAYER_ID) playerInfo[id][pStoreBank] =  value;
			update("UPDATE `server_users` SET `MBank` = '%d' WHERE `ID` = '%d'", playerInfo[id][pBank], playerInfo[id][pSQLID]);
		}
		case _H<health>: {
			if(value < 0 || value > 100) return sendPlayerError(playerid, "Result Invalid (0 - 100).");
			SetPlayerHealthEx(id, value);
		}
		case _H<armour>: {
			if(value < 0 || value > 100) return sendPlayerError(playerid, "Result Invalid (0 - 100).");
			SetPlayerArmourEx(id, value);
		}
		case _H<respectpoints>, _H<rp>: {
			if(value < 0 || value > 150) return sendPlayerError(playerid, "Result Invalid (0 - 150).");
			if(playerInfo[id][pRespectPoints] == value) return sendPlayerError(playerid, "Jucatorul are deja %d puncte de respect.", value);			
			playerInfo[id][pRespectPoints] = value;
			updateLevelBar(id);
			update("UPDATE `server_users` SET `RespectPoints` = '%d' WHERE `ID` = '%d'", playerInfo[id][pRespectPoints], playerInfo[id][pSQLID]);
		}
		case _H<level>: {
			if(value < 0 || value > 150) return sendPlayerError(playerid, "Result Invalid (0 - 150).");
			if(playerInfo[id][pLevel] == value) return sendPlayerError(playerid, "Jucatorul are deja nivel %d.", value);			
			playerInfo[id][pLevel] = value;
			updateLevelBar(id);
			SetPlayerScore(id, playerInfo[id][pLevel]);
			update("UPDATE `server_users` SET `Level` = '%d' WHERE `ID` = '%d'", playerInfo[id][pLevel], playerInfo[id][pSQLID]);	
		}
		case _H<skin>: {
			if(value < 0 || value > 311) return sendPlayerError(playerid, "Result Invalid (0 - 311).");
			if(playerInfo[id][pSkin] == value) return sendPlayerError(playerid, "Jucatorul are deja skin %d.", value);			
			setSkin(id, value);
			update("UPDATE `server_users` SET `Skin` = '%d' WHERE `ID` = '%d'", playerInfo[id][pSkin], playerInfo[id][pSQLID]);					
		}	
	}
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s a setat '%s' lui %s in '%d'.", getName(playerid), option, getName(id), value);
	return true;
}

CMD:respawn(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	new id = INVALID_PLAYER_ID;	
	if(sscanf(params, "u", id)) return sendPlayerSyntax(playerid, "/respawn <name/id>");
	if(!isPlayerLogged(id)) return sendPlayerError(playerid, "Jucatorul nu este conectat.");
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s l-a respawnat pe %s", getName(playerid), getName(id));
	SCM(id, COLOR_GREY, string_fast("* Admin %s ti-a dat respawn.", getName(playerid)));	
	if(IsPlayerInAnyVehicle(id)) {
		new Float:x, Float:y, Float:z;
		GetPlayerPos(id, x, y, z);
		SetPlayerPos(id, x, y, z + 5);
	}
	SpawnPlayer(id);	
	return true;
}

CMD:respawnhere(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	new id = INVALID_PLAYER_ID, Float:x, Float:y, Float:z;
	if(sscanf(params, "u", id)) return sendPlayerSyntax(playerid, "/respawnhere <name/id>");
	if(!isPlayerLogged(id)) return sendPlayerError(playerid, "Jucatorul nu este conectat.");
	GetPlayerPos(id, x, y, z);
	defer respawnTimer(id, x, y, z, GetPlayerVirtualWorld(id), GetPlayerInterior(id));
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s l-a respawnat pe %s in aceeasi pozitie.", getName(playerid), getName(id));
	SCM(id, COLOR_GREY, string_fast("* Admin %s ti-a dat respawn in aceeasi pozitie.", getName(playerid)));			
	if(IsPlayerInAnyVehicle(id)) {
		SetPlayerPos(id, x, y, z + 5);
	}
	return true;
}

CMD:pm(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid) && !Iter_Contains(ServerHelpers, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	new id = INVALID_PLAYER_ID, text[128];
	if(sscanf(params, "us[128]", id, text)) return sendPlayerSyntax(playerid, "/pm <name/id> <text>");
	if(!isPlayerLogged(id)) return sendPlayerError(playerid, "Jucatorul nu este conectat.");
	if(id == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	SCM(playerid, COLOR_LIGHTRED, string_fast("* (( {ffffff}PM Catre: %s: %s {FF6347} )) *", getName(id), text));
	SCM(id, COLOR_LIGHTRED, string_fast("* (( {ffffff}PM de la: %s: %s {FF6347} )) *", getName(playerid), text));
	return true;
}

CMD:mark(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	GetPlayerPos(playerid, playerInfo[playerid][pMarkX], playerInfo[playerid][pMarkY], playerInfo[playerid][pMarkZ]);
	playerInfo[playerid][pMark] = true;
	playerInfo[playerid][pMarkInterior] = GetPlayerInterior(playerid);
	SCM(playerid, COLOR_GREY, "* Pozitii salvate. Acum poti folosi comanda (/gotomark).");
	return true;
}

CMD:gotomark(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(playerInfo[playerid][pMark] == false) return sendPlayerError(playerid, "Nu ai pozitii salvate, foloseste comanda (/mark) pentru a salva pozitiile.");
	SetPlayerPos(playerid, playerInfo[playerid][pMarkX], playerInfo[playerid][pMarkY], playerInfo[playerid][pMarkZ]);
	SetPlayerInterior(playerid, playerInfo[playerid][pMarkInterior]);
	SCM(playerid, COLOR_GREY, "* Te-ai teleportat cu succes la pozitiile salvate, pentru a salva o noua pozitie foloseste comanda (/mark).");
	return true;
}

CMD:healme(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	SCM(playerid, COLOR_GREY, "* Ai primit viata folosind comanda (/healme).");
	SetPlayerHealthEx(playerid, 100);
	return true;
}

CMD:area(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 2) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	extract params -> new string:option[32], Float:value, value1 = -1; else {
		sendPlayerSyntax(playerid, "/area <option> <range> <result>");
		SCM(playerid, COLOR_GREY, "Optiuni: Disarm, Gun, Heal, Armour.");
		return true;
	}
	new Float:x, Float:y, Float:z;
	switch(YHash(option)) {
		case _H<disarm>: {
			if(value < 1 || value > 200) return sendPlayerError(playerid, "Invalid Range (1 - 200).");
			GetPlayerPos(playerid, x, y, z);		
			foreach(new i : loggedPlayers) {
				if(IsPlayerInRangeOfPoint(i, value, x, y, z) && GetPlayerInterior(playerid) == GetPlayerInterior(i) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)) {
					ResetPlayerWeapons(i);
					SCM(i, COLOR_GREY, string_fast("* Area Admin %s ti-a dat disarm.", getName(playerid)));
				}
			}	
		}
		case _H<gun>: {
			if(value < 1 || value > 200) return sendPlayerError(playerid, "Invalid Range (1 - 200).");
			if(value1 < 1 || value1 > 46) return sendPlayerError(playerid, "Invalid Value (1 - 46).");
			GetPlayerPos(playerid, x, y, z);
			foreach(new i : loggedPlayers) {
				if(IsPlayerInRangeOfPoint(i, value, x, y, z) && playerInfo[i][pWeaponLicense] > 0 && GetPlayerInterior(playerid) == GetPlayerInterior(i) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)) {
					serverWeapon(i, value1, 999);
					SCM(i, COLOR_GREY, string_fast("* Area Admin %s ti-a dat un %s.", getName(playerid), getWeaponName(value1)));
				}
			}
		}
		case _H<heal>: {
			if(value < 1 || value > 200) return sendPlayerError(playerid, "Invalid Range (1 - 200).");
			if(value1 < 0 || value1 > 100) return sendPlayerError(playerid, "Invalid Value (0 - 100).");
			GetPlayerPos(playerid, x, y, z);
			foreach(new i : loggedPlayers) {
				if(IsPlayerInRangeOfPoint(i, value, x, y, z) && GetPlayerInterior(playerid) == GetPlayerInterior(i) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)) {
					SetPlayerHealthEx(i, value1);
					SCM(i, COLOR_GREY, string_fast("* Area Admin %s ti-a setat %d heal.", getName(i), value1));
				}
			}
		}
		case _H<armour>: {
			if(value < 1 || value > 200) return sendPlayerError(playerid, "Invalid Range (1 - 200).");
			if(value1 < 0 || value1 > 100) return sendPlayerError(playerid, "Invalid Value (0 - 100).");
			GetPlayerPos(playerid, x, y, z);
			foreach(new i : loggedPlayers) {
				if(IsPlayerInRangeOfPoint(i, value, x, y, z) && GetPlayerInterior(playerid) == GetPlayerInterior(i) && GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i)) {
					SetPlayerArmourEx(i, value1);
					SCM(i, COLOR_GREY, string_fast("* Admin %s ti-a setat %d armura", getName(i), value1));
				}
			}
		}
	}
	sendAdmin(COLOR_SERVER, "Area Notice: {ffffff}Admin %s a folosit optiunea '%s' %s si raza de '%0.fm'", getName(playerid), option, value1 ? (string_fast("cu valoarea '%d'", value1)) : ("fara valoare"), value);
	return true;
}

CMD:givegun(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	new id, weapon_id, weapon_ammo;
	if(sscanf(params, "udd", id , weapon_id, weapon_ammo)) return sendPlayerSyntax(playerid, "/givegun <name/id> <weapon id> <ammo>");
	if(!isPlayerLogged(id)) return sendPlayerError(playerid, "Jucatorul nu este conectat.");
	if(weapon_id < 1 || weapon_id > 46 || weapon_id == 19 || weapon_id == 20 || weapon_id == 21 || weapon_id == 44 || weapon_id == 45) return sendPlayerError(playerid, "Invalid Weapon ID.");
	if(weapon_ammo < 1 || weapon_ammo > 999) return sendPlayerError(playerid, "Invalid Ammo (1 - 999).");
	if(playerInfo[id][pWeaponLicense] == 0) return sendPlayerError(playerid, "Jucatorul nu detine licenta de port-arma.");
	serverWeapon(id, weapon_id, weapon_ammo);
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s i-a dat arma %s (%d ammo) lui %s", getName(playerid), getWeaponName(weapon_id), weapon_ammo, getName(id));
	SCM(id, COLOR_GREY,  string_fast("* Admin %s ti-a dat un %s cu %d gloante.", getName(playerid), getWeaponName(weapon_id), weapon_ammo));
	return true;
}

CMD:disarm(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	new id = INVALID_PLAYER_ID;
	if(sscanf(params, "u", id)) return sendPlayerSyntax(playerid, "/disarm <name/id>");
	if(!isPlayerLogged(id)) return sendPlayerError(playerid, "Jucatorul nu este conectat.");
	if(!GetPlayerWeapons(id)) return sendPlayerError(playerid, "Jucatorul nu are arme.");
	ResetPlayerWeapons(id);
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s i-a dat disarm lui %s.", getName(playerid), getName(id));
	SCM(id, COLOR_GREY, string_fast("* Admin %s ti-a dat disarm.", getName(playerid)));	
	return true;
}


CMD:reports(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(!Iter_Count(Reports)) return sendPlayerError(playerid, "Nu sunt report-uri.");
	SCM(playerid, COLOR_GREY, "* Report-uri active: *");
	foreach(new report : Reports) {
		SCM(playerid, COLOR_TOMATO, string_fast("Report by %s (ID: %d | Level: %d): %s", getName(reportInfo[report][reportID]), reportInfo[report][reportID], playerInfo[reportInfo[report][reportID]][pLevel], reportInfo[report][reportText]));
	}
	return true;
}

CMD:acceptreport(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(!Iter_Count(Reports)) return sendPlayerError(playerid, "Nu sunt report-uri.");
	if(playerInfo[playerid][pReportChat] != INVALID_PLAYER_ID) return sendPlayerError(playerid, "Ai deja o conversatie deschisa.");
	new id = INVALID_PLAYER_ID;
	if(sscanf(params, "u", id)) return sendPlayerSyntax(playerid, "/acceptreport <name/id>");
	if(!isPlayerLogged(id)) return sendPlayerError(playerid, "Jucatorul nu este conectat.");
	if(!PlayerHaveReport(id)) return sendPlayerError(playerid, "Jucatorul nu are un report activ.");
	if(playerInfo[id][pReportChat] != INVALID_PLAYER_ID) return sendPlayerError(playerid, "Jucatorul are deja o conversatie deschisa.");
	new reportid = GetReportID(id);
	reportInfo[reportid][reportID] = INVALID_PLAYER_ID;
	reportInfo[reportid][reportPlayer] = INVALID_PLAYER_ID;
	reportInfo[reportid][reportType] = REPORT_TYPE_NONE;
	reportInfo[reportid][reportText] = (EOS);
	stop reportInfo[reportid][reportTimer];
	Iter_Remove(Reports, reportid);
	playerInfo[playerid][pReportChat] = id;
	playerInfo[id][pReportChat] = playerid;
	SCM(playerid, COLOR_YELLOW, string_fast("* Ai acceptat report-ul lui %s, foloseste (/rchat) pentru a comunica.", getName(id)));
	SCM(id, COLOR_YELLOW, string_fast("* Admin %s ti-a acceptat report-ul , foloseste (/rchat) pentru a comunica.", getName(playerid)));	
	sendAdmin(COLOR_SERVER, "Notice Report: {ffffff}Admin %s a acceptat report-ul lui %s", getName(playerid), getName(id));
	return true;
}

CMD:rchat(playerid, params[]) {
	if(playerInfo[playerid][pReportChat] == INVALID_PLAYER_ID) return sendPlayerError(playerid, "Nu ai o conversatie deschisa.");
	if(isnull(params) || strlen(params) > 128) return sendPlayerSyntax(playerid, "/reportchat <text>");
	SCM(playerid, COLOR_YELLOW, string_fast("%s %s spune: %s", (Iter_Contains(ServerAdmins, playerid)) ? ("Admin") : ("Jucator"), getName(playerid), params));
	SCM(playerInfo[playerid][pReportChat], COLOR_YELLOW, string_fast("%s %s spune: %s", (Iter_Contains(ServerAdmins, playerid)) ? ("Admin") : ("Jucator"), getName(playerid), params));
	return true;
}

CMD:closereport(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(playerInfo[playerid][pReportChat] != INVALID_PLAYER_ID) {
		SCM(playerInfo[playerid][pReportChat], COLOR_YELLOW, string_fast("* Admin %s a inchis conversatia.", getName(playerid)));
		playerInfo[playerInfo[playerid][pReportChat]][pReportChat] = INVALID_PLAYER_ID;	
		SCM(playerid, COLOR_YELLOW, string_fast("* Ai inchis conversatia cu %s.", getName(playerInfo[playerid][pReportChat])));
		playerInfo[playerid][pReportChat] = INVALID_PLAYER_ID;
		return true;
	}
	if(!Iter_Count(Reports)) return sendPlayerError(playerid, "Nu sunt report-uri.");
	new id = INVALID_PLAYER_ID, reason[64];
	if(sscanf(params, "us[64]", id, reason)) return sendPlayerSyntax(playerid, "/cancelreport <name/id> <reason>");
	if(!isPlayerLogged(id)) return sendPlayerError(playerid, "Jucatorul nu este conectat.");
	if(!PlayerHaveReport(id)) return sendPlayerError(playerid, "Jucatorul nu are un report activ.");
	new reportid = GetReportID(id);
	reportInfo[reportid][reportID] = INVALID_PLAYER_ID;
	reportInfo[reportid][reportPlayer] = INVALID_PLAYER_ID;
	reportInfo[reportid][reportType] = REPORT_TYPE_NONE;
	reportInfo[reportid][reportText] = (EOS);
	stop reportInfo[reportid][reportTimer];
	Iter_Remove(Reports, reportid);	
	sendAdmin(COLOR_SERVER, "Notice Report: {ffffff}Admin %s a inchis report-ul lui %s, motiv: %s.", getName(playerid), getName(id), reason);
	SCM(playerid, COLOR_YELLOW, string_fast("* Ai inchis cu succes report-ul lui %s.", getName(id)));
	SCM(id, COLOR_YELLOW, string_fast("* Admin %s ti-a inchis report-ul, motiv: %s", getName(playerid), reason));
	return true;
}

CMD:reportmute(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	new id = INVALID_PLAYER_ID, minutes = 0, reason[64];
	if(sscanf(params, "uds[64]", id, minutes, reason)) return sendPlayerSyntax(playerid, "/reportmute <name/id> <minutes> <reason>");
	if(!isPlayerLogged(id)) return sendPlayerError(playerid, "Jucatorul nu este conectat.");
	if(minutes < 0 || minutes > 240) return sendPlayerError(playerid, "Numar de minute Invalid (0 - 240");
	if(minutes == 0) {
		if(playerInfo[id][pReportMute] < gettime()) return sendPlayerError(playerid, "Jucatorul nu are mute pe report.");
		playerInfo[id][pReportMute] = 0;
		update("UPDATE `server_users` SET `ReportMute` = '0' WHERE `ID` = '%d'", playerInfo[id][pSQLID]);
		sendAdmin(COLOR_SERVER, "Notice Report: {ffffff}Admin %s i-a dat unmute pe report lui %s, motiv: %s.", getName(playerid), getName(id), reason);
		SCM(id, COLOR_GREY, string_fast("* Admin %s ti-a dat unmute pe report, motiv: %s", getName(playerid), reason));	
		return true;
	}
	playerInfo[id][pReportMute] = (gettime() + (minutes * 60));
	update("UPDATE `server_users` SET `ReportMute` = '0' WHERE `ID` = '%d'", playerInfo[id][pReportMute], playerInfo[id][pSQLID]);	
	sendAdmin(COLOR_SERVER, "Notice Report: {ffffff}Admin %s i-a dat mute %d minute pe report lui %s, motiv: %s.", getName(playerid), minutes, getName(id), reason);
	SCM(id, COLOR_GREY, string_fast("* Admin %s ti-a dat mute %d minute pe report, motiv: %s", getName(playerid), minutes, reason));	
	return true;
}

/*CMD:createpickup(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 6) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(Iter_Free(Pickups) == -1) return sendPlayerError(playerid, "In acest moment, nu se pot creea pickup-uri, deoarece s-a atins numarul maxim.");
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Trebuie sa cobori din vehicul.");
	if(playerInfo[playerid][pFlymode] == true) return sendPlayerError(playerid, "Nu poti face acest lucru deoarece esti in fly mode.");
	new model, worldid, interior;
	if(sscanf(params, "ddd", model, worldid, interior)) return sendPlayerSyntax(playerid, "/createpickup <model> <virtual world> <interior>");
	if(worldid < -1 || worldid > 2147483647) return sendPlayerError(playerid, "Virtual World Invalid (0 - 2,147,483,647).");
	if(interior < -1 || interior > 255) return sendPlayerError(playerid, "Interior Invalid (0 - 255)");
	new id = Iter_Free(Pickups);
	pickupInfo[id][pickupModel] = model;
	pickupInfo[id][pickupWorldID] = worldid;
	pickupInfo[id][pickupInterior] = interior;
	GetPlayerPos(playerid, pickupInfo[id][pickupX], pickupInfo[id][pickupY], pickupInfo[id][pickupZ]); 
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, 256, "INSERT INTO `server_pickups` (Model, X, Y, Z, WorldID, Interior) VALUES ('%d', '%f', '%f', '%f', '%d', '%d')", model, pickupInfo[id][pickupX], pickupInfo[id][pickupY], pickupInfo[id][pickupZ], worldid, interior);
   	inline getSQLPickupID() {
   		if(!cache_affected_rows()) return sendPlayerError(playerid, "Nu s-a putut creea pickup-ul.");
   		pickupInfo[id][pickupSQLID] = cache_insert_id();
   		Iter_Add(Pickups, id);
   		if(IsValidDynamicPickup(pickupInfo[id][pickupID])) DestroyDynamicPickup(pickupInfo[id][pickupID]);
   		pickupInfo[id][pickupID] = CreateDynamicPickup(model, 23, pickupInfo[id][pickupX], pickupInfo[id][pickupY], pickupInfo[id][pickupZ], worldid, interior);
   		SCM(playerid, COLOR_SERVER, string_fast("* Notice Pickup: Ai creat un Pickup (id: %d, sqlid: %d, worldid: %d, interior:%d)", id, cache_insert_id(), worldid, interior));
 		return true;
 	}
   	mysql_pquery_inline(SQL, gQuery, using inline getSQLPickupID, "");
	return true;
}

CMD:createlabel(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 6) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(Iter_Free(Labels) == -1) return sendPlayerError(playerid, "In acest moment, nu se pot creea pickup-uri, deoarece s-a atins numarul maxim.");
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Trebuie sa cobori din vehicul.");
	if(playerInfo[playerid][pFlymode] == true) return sendPlayerError(playerid, "Nu poti face acest lucru deoarece esti in fly mode.");
	new worldid, interior;
	if(sscanf(params, "dd", worldid, interior)) return sendPlayerSyntax(playerid, "/createlabel <virtual world> <interior>");
	if(worldid < -1 || worldid > 2147483647) return sendPlayerError(playerid, "Virtual World Invalid (0 - 2,147,483,647).");
	if(interior < -1 || interior > 255) return sendPlayerError(playerid, "Interior Invalid (0 - 255)");
	SetPVarInt(playerid, "LabelVW", worldid);
	SetPVarInt(playerid, "LabelInt", interior);
	Dialog_Show(playerid, DIALOG_CREATE_LABEL, DIALOG_STYLE_INPUT, "Create Label:", "Scrie mai jos ce text doresti sa aiba label-ul:", "Ok", "Cancel");
	return true;
}*/
	
CMD:banip(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 2) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(GetPVarInt(playerid, "banDeelay") > gettime()) return sendPlayerError(playerid, "Trebuie sa astepti %d secunde inainte sa folosesti aceasta comanda.", (GetPVarInt(playerid, "banDeelay") - gettime()));
	new id = INVALID_PLAYER_ID, reason[64];
	if(sscanf(params, "us[64]", id, reason)) return sendPlayerSyntax(playerid, "/banip <name/id> <reason>");
	if(!isPlayerLogged(id)) return sendPlayerError(playerid, "Jucatorul nu este conectat.");
	if(id == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(playerInfo[id][pAdmin] >= playerInfo[playerid][pAdmin] && !strmatch(getName(playerid), "Vicentzo")) return sendPlayerError(playerid, "Nu poti sa-i dai ban acelui jucator.");
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, 256, "INSERT INTO `server_bans_ip` (PlayerName, PlayerID, PlayerIP, AdminName, AdminID, Reason, Date) VALUES ('%s', '%d', '%s', '%s', '%d', '%s', '%s)",getName(id), playerInfo[id][pSQLID], getIp(id), getName(playerid), playerInfo[playerid][pSQLID], reason, getDateTime());
	inline BanIPPlayer() {
		if(!cache_affected_rows()) return sendPlayerError(playerid, "Banul nu a putut fi acordat, eroare tehnica reveniti mai tarziu.");
		SendClientMessageToAll(COLOR_LIGHTRED, string_fast("AdmCmd: %s a primit ban ip de la administratorul %s, motiv: %s.", getName(id), getName(playerid), reason));
		SetPVarInt(playerid, "banDeelay", (gettime() + 60));
		defer kickEx(id);
	}
	mysql_pquery_inline(SQL, gQuery, using inline BanIPPlayer, "");
	return true;
}

CMD:unbanip(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 2) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(GetPVarInt(playerid, "unbanDeelay") > gettime()) return sendPlayerError(playerid, "Trebuie sa astepti %d secunde inainte sa folosesti aceasta comanda.", (GetPVarInt(playerid, "unbanDeelay") - gettime()));
	if(isnull(params) || strlen(params) > 16) return sendPlayerSyntax(playerid, "/unbanip <ip>");
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, 256, "SELECT * FROM `server_bans_ip` WHERE `PlayerIP` = '%s' AND `Active` = '1' LIMIT 1", params);
	inline CheckIP() {
		new playerID;
		cache_get_value_name_int(0, "ID", playerID);
		if(!cache_num_rows()) return sendPlayerError(playerid, "Acest ip nu este banat.");
		sendAdmin(COLOR_SERVER, "* Ban Notice: {ffffff}Admin %s a debanat ip-ul %s.", getName(playerid), params);
		SetPVarInt(playerid, "unbanDeelay", (gettime() + 60));
		
		mysql_format(SQL, gQuery, 256, "UPDATE `server_bans_ip` SET `Active` = '0' WHERE `ID` = '%d'", playerID);
		mysql_tquery(SQL, gQuery, "", "");
	}
	mysql_pquery_inline(SQL, gQuery, using inline CheckIP, "");
	return true;
}

CMD:banipoffline(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 2) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(GetPVarInt(playerid, "banDeelay") > gettime()) return sendPlayerError(playerid, "Trebuie sa astepti %d secunde inainte sa folosesti aceasta comanda.", (GetPVarInt(playerid, "banDeelay") - gettime()));
	new ip[16], reason[64];
	if(sscanf(params, "s[16]s[64]", ip, reason)) return sendPlayerError(playerid, "/banipoffline <ip> <reason>");
	foreach(new i : loggedPlayers) {
		if(strmatch(getIp(i), ip)) return sendPlayerError(playerid, "Exista deja un jucator cu acest ip, nume: %s (id: %d).", getName(i), i);
	}
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, 256, "INSERT INTO `server_bans_ip` (PlayerIP, AdminName, AdminID, Reason, Date) VALUES ('%s', '%s', '%d', '%s', '%s')",ip, getName(playerid), playerInfo[playerid][pSQLID], reason, getDateTime());
	inline BanIPOffline() {
		if(!cache_affected_rows()) return sendPlayerError(playerid, "Banul nu a putut fi acordat, eroare tehnica reveniti mai tarziu.");
		sendAdmin(COLOR_SERVER, "* Ban Notice: {ffffff}Admin %s a banat ip-ul %s, motiv: %s.", getName(playerid), ip, reason);
		SetPVarInt(playerid, "banDeelay", (gettime() + 60));
	}
	mysql_pquery_inline(SQL, gQuery, using inline BanIPOffline, "");
	return true;
}

CMD:gotojob(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Trebuie sa cobori jos din vehicul.");
	if(isnull(params) || !IsNumeric(params)) return sendPlayerSyntax(playerid, "/gotojob <job id>");
	if(!Iter_Contains(ServerJobs, strval(params))) return sendPlayerError(playerid, "Acest job nu exista.");
	SetPlayerPos(playerid, jobInfo[strval(params)][jobX], jobInfo[strval(params)][jobY], jobInfo[strval(params)][jobZ]);
	sendAdmin(COLOR_SERVER, "Notice: {ffffff}Admin %s s-a teleportat la jobul %s (ID: %d).", getName(playerid), jobInfo[strval(params)][jobName], jobInfo[strval(params)][jobID]);
	return true;
}
 
CMD:ah(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(playerInfo[playerid][pAdmin] >= 1) {
		SCM(playerid, 0x32a8a0FF, "Admin 1{FFFFFF}: /ban | /banoffline | /mute | /unmute | /mutedplayers | /adminchat(/a) | /kick | /spawncar");
		SCM(playerid, 0x32a8a0FF, "Admin 1{FFFFFF}: /despawncar | /gethere | /slap | /freeze | /unfreeze | /gotomark | /healme");
		SCM(playerid, 0x32a8a0FF, "Admin 1{FFFFFF}: /despawncars | /gotocar | /getcar | /slapcar | /fixveh | /addnos | /flipveh | /closestcar");
		SCM(playerid, 0x32a8a0FF, "Admin 1{FFFFFF}: /entercar | /fly | /goto | /respawn | /respawnhere | /mark | /givegun | /disarm");
	}
	if(playerInfo[playerid][pAdmin] >= 2) SCM(playerid, 0x32a8a0FF, "Admin 2{FFFFFF}: /area  | /banip | /unbanip | /banipoffline");
	if(playerInfo[playerid][pAdmin] >= 3) SCM(playerid, 0x32a8a0FF, "Admin 3{FFFFFF}: /unwarn | /unban | /jail | /jailo | /unjail | /unjailo");
	if(playerInfo[playerid][pAdmin] >= 4) SCM(playerid, 0x32a8a0FF, "Admin 4{FFFFFF}: /adminsuspendlicense(/asl) | /admingivelicense(/agl) | /admintakelicense(/atl)"); 
	if(playerInfo[playerid][pAdmin] >= 5) SCM(playerid, 0x32a8a0FF, "Admin 5{FFFFFF}: /givemoney");
	if(playerInfo[playerid][pAdmin] >= 6) SCM(playerid, 0x32a8a0FF, "Admin 6{FFFFFF}: /addexamcp | /setadmin | /sethelper | /createpickup | /createlabel | /resetquests");
	return true;
}

CMD:gotoxyz(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	extract params -> new Float:x, Float:y, Float:z, vw, interior; else {
		sendPlayerSyntax(playerid, "/gotoxyz <x> <y> <z> <virtual world> <interior>");
		return true;
	}
	SetPlayerPos(playerid, x, y, z);
	SetPlayerInterior(playerid, interior);
	SetPlayerVirtualWorld(playerid, vw);
	SCM(playerid, COLOR_LIGHTRED, string_fast("GotoXYZ:{ffffff} Ai fost teleportat la coordonate cu interior %d si virtual world %d.", interior, vw));
	return true;
}

CMD:unjail(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 3) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	extract params -> new player:userID, string:reason[32]; else return sendPlayerSyntax(playerid, "/unjail <name/id> <reason>");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(strlen(reason) < 1 || strlen(reason) > 32) return sendPlayerError(playerid, "Reason invalid, min. 1 caracter max. 32 caractere.");
	if(!Iter_Contains(JailedPlayers, userID)) return sendPlayerError(playerid, "Acel player nu are jail.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este logat.");
	playerInfo[userID][pJailed] = 0;
	playerInfo[userID][pJailTime] = 0;
	stop jailTime[userID];
	SpawnPlayer(userID);
	SetPlayerVirtualWorld(playerid, 0);
	PlayerTextDrawHide(userID, jailTimeTD[userID]);
	Iter_Remove(JailedPlayers, userID);
	sendAdmin(COLOR_SERVER, "Notice:{ffffff} Admin %s a eliberat pe %s din jail. Motiv: %s.", getName(playerid), getName(userID), reason);
	SCM(userID, COLOR_LIGHTRED, string_fast("* Jail:{ffffff} Ai fost scos din jail de catre admin %s. Motiv: %s.", getName(playerid), reason));
	update("UPDATE `server_users` SET `Jailed` = '0', `JailTime` = '0' WHERE `ID` = '%d'", playerInfo[userID][pSQLID]);
	return true;
}

CMD:unjailo(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 3) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	extract params -> new string:playerName[MAX_PLAYER_NAME], string:reason[32]; else return sendPlayerSyntax(playerid, "/unjailo <name> <reason>");
	if(strlen(reason) < 1 || strlen(reason) > 32) return sendPlayerError(playerid, "Reason invalid, min. 1 caracter max. 32 caractere.");
	foreach(new i : loggedPlayers) if(strmatch(getName(i), playerName)) return sendPlayerError(playerid, "Jucatorul este conectat.");
	gQuery[0] = (EOS);
	inline checkAccount()
	{
		if(!cache_num_rows()) return sendPlayerError(playerid, "Acest cont nu exista.");
		cache_get_value_name(0, "Name", playerName, MAX_PLAYER_NAME);
		sendAdmin(COLOR_SERVER, "* Notice: {ffffff}Admin %s l-a eliberat din inchisoare pe %s. Motiv: %s.", getName(playerid), playerName, reason);
		update("UPDATE `server_users` SET `Jailed` = '0', `JailTime` = '0' WHERE `Name` = '%s' LIMIT 1", playerName);
		return true;
	}
	inline checkAccountInDatabase()
	{
		if(!cache_num_rows()) return sendPlayerError(playerid, "Acest cont nu este in jail.");
		mysql_format(SQL, gQuery, sizeof gQuery, "SELECT * FROM `server_users` WHERE `Name` = '%s' LIMIT 1", playerName);
		mysql_pquery_inline(SQL, gQuery, using inline checkAccount, "");
		return true;
	}
	mysql_format(SQL, gQuery, sizeof gQuery, "SELECT * FROM `server_users` WHERE `Name` = '%s' AND `Jailed` = '1' OR `Jailed` = '2' LIMIT 1", playerName);
	mysql_pquery_inline(SQL, gQuery, using inline checkAccountInDatabase, "");
	return true;
}

CMD:jail(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 3) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	extract params -> new player:userID, minutes, string:reason[32]; else return sendPlayerSyntax(playerid, "/jail <name/id> <minutes> <reason>");
	if(minutes < 1 || minutes > 500) return sendPlayerError(playerid, "Minute invalide, min. 1 min. max. 500 min.");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(strlen(reason) < 1 || strlen(reason) > 32) return sendPlayerError(playerid, "Reason invalid, min. 1 caracter max. 32 caractere.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este logat.");
	if(Iter_Contains(JailedPlayers, userID)) return sendPlayerError(playerid, "Acel player este deja in jail.");
	new rand = random(6); 
	if(rand == 0) rand = 1;
	if(playerInfo[userID][pCuffed] == 1) {
		SetPlayerSpecialAction(userID,SPECIAL_ACTION_NONE);
		RemovePlayerAttachedObject(userID,1);
		TogglePlayerControllable(userID, 1);
		playerInfo[userID][pCuffed] = 0;
	}
	SetPlayerPos(playerid, cellRandom[rand][0], cellRandom[rand][1], cellRandom[rand][2]);
	SetPlayerVirtualWorld(playerid, 1337);
	jailTime[userID] = repeat TimerJail(userID);
	playerInfo[userID][pJailed] = 1;
	playerInfo[userID][pJailTime] = minutes*60;
	playerInfo[userID][pWantedLevel] = 0;
	SetPlayerWantedLevel(userID, 0);
	SetPlayerInterior(userID, 0);
	SetPlayerVirtualWorld(userID, 0);
	Iter_Add(JailedPlayers, userID);
	update("UPDATE `server_users` SET `Jailed` = '%d', `JailTime` = '%d', `WantedLevel` = '0' WHERE `ID` = '%d'", playerInfo[userID][pJailed], playerInfo[userID][pJailTime], playerInfo[userID][pSQLID]);
	sendAdmin(COLOR_SERVER, "Notice: {FFFFFF}%s l-a bagat in inchisoare pe %s pentru %d minute. Motiv: %s.", getName(playerid), getName(userID), minutes, reason);
	SCM(userID, COLOR_LIGHTRED, string_fast("* Jail:{ffffff} %s ti-a dat jail pentru %d minute. Motiv: %s.", getName(playerid), minutes, reason));
	return true;
}

CMD:jailo(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 3) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	extract params -> new string:playerName[MAX_PLAYER_NAME], minutes, string:reason[32]; else return sendPlayerSyntax(playerid, "/unjailo <name> <minutes> <reason>");
	if(strlen(reason) < 1 || strlen(reason) > 32) return sendPlayerError(playerid, "Reason invalid, min. 1 caracter max. 32 caractere.");
	foreach(new i : loggedPlayers) if(strmatch(getName(i), playerName)) return sendPlayerError(playerid, "Jucatorul este conectat.");
	gQuery[0] = (EOS);
	inline checkAccount()
	{
		if(!cache_num_rows()) return sendPlayerError(playerid, "Acest cont nu exista.");
		cache_get_value_name(0, "Name", playerName, MAX_PLAYER_NAME);
		sendAdmin(COLOR_SERVER, "* Notice: {ffffff}Admin %s l-a bagat in inchisoare pe %s, %d minute. Motiv: %s.", getName(playerid), playerName, minutes, reason);
		update("UPDATE `server_users` SET `Jailed` = '2', `JailTime` = '%d' WHERE `Name` = '%s' LIMIT 1", minutes*60, playerName);
		return true;
	}
	inline checkAccountInDatabase()
	{
		if(cache_num_rows()) return sendPlayerError(playerid, "Acest cont este deja in jail.");
		mysql_format(SQL, gQuery, sizeof gQuery, "SELECT * FROM `server_users` WHERE `Name` = '%s' LIMIT 1", playerName);
		mysql_pquery_inline(SQL, gQuery, using inline checkAccount, "");
		return true;
	}
	mysql_format(SQL, gQuery, sizeof gQuery, "SELECT * FROM `server_users` WHERE `Name` = '%s' AND `Jailed` = '0' LIMIT 1", playerName);
	mysql_pquery_inline(SQL, gQuery, using inline checkAccountInDatabase, "");
	return true;
}

CMD:resetquests(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 6) return true;
	resetQuest();
	return true;
}

CMD:showfreq(playerid, params[]) {
	if(!Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	extract params -> new userID; else return sendPlayerSyntax(playerid, "/showfreq <name/id>");
    if(playerInfo[userID][pWTalkie] == 0) return sendPlayerError(playerid, "Acel player nu are un walkie talkie.");
    SCM(playerid, COLOR_WHITE, string_fast("* Jucatorul are frecventa %d.", playerInfo[userID][pWTChannel]));
    return true;
}
