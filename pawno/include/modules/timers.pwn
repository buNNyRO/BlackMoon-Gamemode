
//////////////////////////////////////////////////
//////    Timers                           //////
////////////////////////////////////////////////

timer kickEx[1000](playerid) 
	return Kick(playerid);

timer TimerJail[1000](i) {
	playerInfo[i][pJailTime] --;
	PlayerTextDrawShow(i, jailTimeTD[i]);
	va_PlayerTextDrawSetString(i, jailTimeTD[i], "Jail Time: ~r~%d secunde", playerInfo[i][pJailTime]);
	if(playerInfo[i][pJailTime] <= 0) {
		stop jailTime[i];
		playerInfo[i][pJailTime] = 0;
		playerInfo[i][pJailed] = 0;
		SpawnPlayer(i);
		Iter_Remove(JailedPlayers, i);
		PlayerTextDrawHide(i, jailTimeTD[i]);
		SCMf(i, COLOR_LIGHTRED, "* Jail:{ffffff} Timpul de jail a expirat, acum esti liber.");
		update("UPDATE `server_users` SET `Jailed` = '0', `JailTime` = '0' WHERE `ID` = '%d' LIMIT 1", playerInfo[i][pSQLID]);
	}
	return true;
}

timer TimerWanted[1000](x) {
	playerInfo[x][pWantedTime] --;
	PlayerTextDrawShow(x, wantedTD[x]);
	va_PlayerTextDrawSetString(x, wantedTD[x], "Wanted Time: ~r~%d secunde", playerInfo[x][pWantedTime]);
	if(playerInfo[x][pWantedTime] <= 0 && playerInfo[x][pWantedLevel] > 0) {
		playerInfo[x][pWantedTime] = 300;
		playerInfo[x][pWantedLevel] --;
		SetPlayerWantedLevel(x, playerInfo[x][pWantedLevel]);
		SCM(x, COLOR_LIGHTRED, "* Wanted: Ti-a fost scazut un punct de urmarire.");	
		sendPolice(3, -1, x, playerInfo[x][pWantedLevel], "lose point wanted");
		update("UPDATE `server_users` SET `WantedLevel` = '%d', `WantedTime` = '%d' WHERE `ID` = '%d' LIMIT 1", playerInfo[x][pWantedLevel], playerInfo[x][pWantedTime], playerInfo[x][pSQLID]);
	}	
	else {
		playerInfo[x][pWantedLevel] = 0;
		playerInfo[x][pWantedTime] = 0;
		SetPlayerWantedLevel(x, playerInfo[x][pWantedLevel]);
		PlayerTextDrawHide(x, wantedTD[x]);
		stop wantedTime[x];
		SCM(x, COLOR_LIGHTRED, "* Wanted: Politistii ti-au pierdut urmele deoarece nu mai ai wanted.");
		update("UPDATE `server_users` SET `WantedLevel` = '%d', `WantedTime` = '%d' WHERE `ID` = '%d' LIMIT 1", playerInfo[x][pWantedLevel], playerInfo[x][pWantedTime], playerInfo[x][pSQLID]);
	}
	return true;
}

task TimerM[60000]() {
	new hour, minute, second, year, month, day;
	gettime(hour, minute, second);
	getdate(year, month, day);

	TextDrawSetString(ClockTD[2], string_fast("%02d:%02d", hour, minute));
	TextDrawSetString(ClockTD[1], string_fast("%02d.%02d.%d", day, month, year));
	return 1;
}

task Timers[1000]() {
	new hour, minute, second;
	gettime(hour, minute, second); 
	TextDrawSetString(ClockTD[0], string_fast("~p~PAYDAY~w~ IN: %s", PayDayTime-gettime() <= 0 ? "~p~PAYDAY~w~ SENDING..." : secinmin(PayDayTime-gettime())));
	if(hour == 12 && minute == 0 && second == 0) {
		MoveObject(gates[1], 1160.19, 1303.31, 5.71, 0.5, 0.00, 0.00, -90.00); 
		MoveObject(gates[2], 1160.18, 1312.26, 5.71,  0.5, 0.00, 0.00, -90.00);
		foreach(new i : JailedPlayers) SCM(i, COLOR_LIGHTRED, string_fast("* Jail Cells:{ffffff} Deoarece ora a ajuns la '12:00:00', celule se deschid."));	
	}
	if(hour == 0 && minute == 0 && second == 0) {
		mysql_tquery(SQL, "UPDATE server_bans SET Days = Days-1 WHERE Days > 0");	
		new rand = random(6);
		MoveObject(gates[1], 1160.19, 1303.31, 11.71, 0.5, 0.00, 0.00, -90.00);
		MoveObject(gates[2], 1160.18, 1312.26, 11.71, 0.5, 0.00, 0.00, -90.00);
		foreach(new i : JailedPlayers) {
			SetPlayerVirtualWorld(i, 1337);
			SetPlayerPos(i, cellRandom[rand][0], cellRandom[rand][1], cellRandom[rand][2]);
			SCM(i, COLOR_LIGHTRED, string_fast("* Jail Cells:{ffffff} Deoarece ora a ajuns la '00:00:00', celule se inchid."));
		}
		resetQuest();
		foreach(new i : TotalPlayerVehicles) personalVehicle[i][pvAge] ++;
		mysql_tquery(SQL, "UPDATE `server_personal_vehicles` SET `Age` = Age+1");
        foreach(new x : ServerClans) {
            if(clanInfo[x][cDays] == 0) {
            	mysql_tquery(SQL, string_fast("DELETE FROM `server_clans` WHERE `server_clans`.`ID` = %d", clanInfo[x][cDays]));
                Iter_Remove(ServerClans, x);
            }
            clanInfo[x][cDays] --;
        }
        mysql_tquery(SQL, "UPDATE `server_clans` SET `Days` = Days-1 WHERE `Days` > 0"); 		
	}
	if(CountTime > 0) {
		CountTime --;
		va_GameTextForAll("%d", 2500, 3, CountTime);
	}
	foreach(new playerid : loggedPlayers) {
		if(IsPlayerInRangeOfPoint(playerid, 1.0, playerInfo[playerid][pLastPosX], playerInfo[playerid][pLastPosY], playerInfo[playerid][pLastPosZ]) || IsPlayerPaused(playerid))
		playerInfo[playerid][pAFKSeconds] ++;

		else playerInfo[playerid][pAFKSeconds] = 0;

		if(playerInfo[playerid][pAFKSeconds] < 10)
			playerInfo[playerid][pSeconds] ++;
																				 
		if(playerInfo[playerid][pFPSShow] > 0) va_PlayerTextDrawSetString(playerid, serverHud[1], "%s", playerInfo[playerid][pAdmin] ? string_fast("%d~n~~r~%d~w~ / T~g~%d~w~ / A~b~%d~w~ / Q~p~%d", playerInfo[playerid][pFPS], GetPlayerPing(playerid), GetServerTickRate(), GetPlayerAnimationIndex(playerid), mysql_unprocessed_queries()) : string_fast("%d~n~~r~%d~w~", playerInfo[playerid][pFPS], GetPlayerPing(playerid)));

		if(GetPlayerDrunkLevel(playerid) < 100) SetPlayerDrunkLevel(playerid, 2000);
		else { 
			if(playerInfo[playerid][pDrunkLevel] != GetPlayerDrunkLevel(playerid)) {
				new playerFPS = playerInfo[playerid][pDrunkLevel] - GetPlayerDrunkLevel(playerid);
				if((playerFPS > 0) && (playerFPS < 200)) playerInfo[playerid][pFPS] = playerFPS;
				playerInfo[playerid][pDrunkLevel] = GetPlayerDrunkLevel(playerid);
			}
		}
	}
	return true;
}

// task panelTimer[10000]() {
// 	checkPanel(); 
// 	return true;
// }

timer TimersWantedFind[5000](playerid) {
	new Float:x, Float:y, Float:z, id;
	id = GetPVarInt(playerid, "selectedPlayer");
	GetPlayerPos(id, x, y, z);
	SetPlayerCheckpoint(playerid, x, y, z, 3.5);
	return true;
}

timer TimerPos[1000](playerid) {
	GetPlayerPos(playerid, playerInfo[playerid][pLastPosX], playerInfo[playerid][pLastPosY], playerInfo[playerid][pLastPosZ]);
	return true;
}

timer TimerCarFind[5000](playerid) {
	if(IsValidVehicle(playerInfo[playerid][pCheckpointID])) {
		new Float:x, Float:y, Float:z;
		GetVehiclePos(playerInfo[playerid][pCheckpointID], x, y, z);
		SetPlayerCheckpoint(playerid, x, y, z, 4.0);
	}
	else {
		playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
		playerInfo[playerid][pCheckpointID] = -1;
		DisablePlayerCheckpoint(playerid);
	}
	return true;
}

timer TimerTutorial[1000](playerid) {
	playerInfo[playerid][pTutorialSeconds] ++;
	if(playerInfo[playerid][pTutorialSeconds] == 5) {
		PlayAudioStreamForPlayer(playerid, "https://uploadir.com/u/qo7dghrw");
		TogglePlayerControllable(playerid, 0);
		SetPlayerVirtualWorld(playerid, playerid+1);
		InterpolateCameraPos(playerid, 1359.698730, -1885.655029, 136.787368, 1067.923706, -1732.775756, 20.931539, 10000);
		InterpolateCameraLookAt(playerid, 1356.019531, -1882.768432, 135.017959, 1069.632568, -1728.127075, 20.246206, 10000);
		SCM(playerid, COLOR_SERVER, string_fast("* Tutorial: {ffffff} Salutare %s, bun venit pe rpg.fromzero.ro !", getName(playerid)));
		SCM(playerid, COLOR_WHITE,  "* In urmatoarele momente, iti vom prezenta cateva chestii pe care le poti face pe server-ul nostru.");
	}
	if(playerInfo[playerid][pTutorialSeconds] == 27) {
		InterpolateCameraPos(playerid, 1113.314697, -1778.134765, 64.311813, 394.953430, -2169.624755, 32.946147, 10000);
		InterpolateCameraLookAt(playerid, 1108.676025, -1778.955322, 62.635784, 394.136718, -2164.891845, 31.556360, 10000);	
		SCM(playerid, COLOR_WHITE, "* Pe server-ul nostru, poti lucra la diferite job-uri, in fata ta se afla job-ul Fisher.");
		SCM(playerid, COLOR_WHITE, "* Un job destul de profitabil, si iubit de catre jucatorii nostri.");
		SCM(playerid, COLOR_WHITE, "* Pentru a lucra la acest job ai nevoie de nivel 1. Pentru a-l localiza foloseste comanda /jobs.");
	}
	if(playerInfo[playerid][pTutorialSeconds] == 48) {
		playerInfo[playerid][pTutorialSeconds] = 0;
		playerInfo[playerid][pTutorialActive] = 0;
		playerInfo[playerid][pTutorial] = true;
		stop tutorial[playerid];
		update("UPDATE `server_users` SET `Tutorial` = '1' WHERE `ID` = '%d'",playerInfo[playerid][pSQLID]);
		InterpolateCameraPos(playerid, 566.603576, -1933.140747, 111.586578, 1090.810424, -1745.928100, 22.588699, 10000);
		InterpolateCameraLookAt(playerid, 571.101928, -1930.982055, 111.910568, 1089.508056, -1741.142089, 21.957574, 10000);
		SCM(playerid, COLOR_WHITE, "* Se pare ca am ajuns la finalul acestui tutorial.");
		SCM(playerid, COLOR_WHITE,  "* Daca doresti mai multe informatii sau ai nevoie de ajutor, foloseste comanda '/newbie(/n)' sau comanda '/help'.");
		SCM(playerid, COLOR_WHITE, "* Iti dorim un gameplay placut, sa ramai alaturi de noi, ai grija la orice faci, echipa rpg.fromzero.ro.");
		StopAudioStreamForPlayer(playerid);
		SetPlayerVirtualWorld(playerid, 0);
		TogglePlayerControllable(playerid, 1);
		SpawnPlayer(playerid);
	}
	return true;
}

task PayDay[3600000]() {
	foreach(new playerid : loggedPlayers) {
		PayDayTime = gettime()+3600;
		SCM(playerid, COLOR_GREY, "--------------- Payday ---------------");

		SCM(playerid, COLOR_WHITE, string_fast("Paycheck: $%s", formatNumber(playerInfo[playerid][pLevel] * 125)));
		SCM(playerid, COLOR_WHITE, string_fast("Ore Jucate: +%.2f (%.0f minute).", (playerInfo[playerid][pSeconds] / 3600), (playerInfo[playerid][pSeconds] / 60)));

		playerInfo[playerid][pHours] += (playerInfo[playerid][pSeconds] / 3600);
		playerInfo[playerid][pSeconds] = 0;
		playerInfo[playerid][pRespectPoints] ++;

		GivePlayerCash(playerid, 1, (playerInfo[playerid][pLevel] * 125));
		updateLevelBar(playerid);

		update("UPDATE `server_users` SET `Hours` = '%f', `Seconds` = '0', `RespectPoints` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pHours], playerInfo[playerid][pRespectPoints], playerInfo[playerid][pSQLID]);
		if((playerInfo[playerid][pLevel] * 3) <= playerInfo[playerid][pRespectPoints])
		SCM(playerid, COLOR_GREY, string_fast("* Ai numarul necesar de puncte de respect pentru a avansa la nivel %d, foloseste (/buylevel).", (playerInfo[playerid][pLevel] + 1)));

		// Licente
		if(playerInfo[playerid][pDrivingLicense] > 0)
			playerInfo[playerid][pDrivingLicense]--;

		if(playerInfo[playerid][pDrivingLicenseSuspend] > 0)
			playerInfo[playerid][pDrivingLicenseSuspend]--;

		if(playerInfo[playerid][pWeaponLicense] > 0)
			playerInfo[playerid][pWeaponLicense]--;

		if(playerInfo[playerid][pWeaponLicenseSuspend] > 0)
			playerInfo[playerid][pWeaponLicenseSuspend]--;

		if(playerInfo[playerid][pFlyLicense] > 0)
			playerInfo[playerid][pFlyLicense]--;

		if(playerInfo[playerid][pFlyLicenseSuspend] > 0)
			playerInfo[playerid][pFlyLicenseSuspend]--;

		if(playerInfo[playerid][pBoatLicense] > 0)
			playerInfo[playerid][pBoatLicense]--;

		if(playerInfo[playerid][pBoatLicenseSuspend] > 0)
			playerInfo[playerid][pBoatLicenseSuspend]--;

		if(playerInfo[playerid][pFactionPunish]) 
			playerInfo[playerid][pFactionPunish]--;

		if(playerInfo[playerid][pRent] != -1) {
			new houseid = playerInfo[playerid][pRent];
			if(houseInfo[houseid][hRentPrice] != 1 && playerInfo[playerid][pBank] <= houseInfo[houseid][hRentPrice]) {
				houseInfo[houseid][hRenters] --;
				update("UPDATE `server_houses` SET `Renters` = '%d' WHERE `ID` = '%d'", houseInfo[houseid][hRenters], houseInfo[houseid][hID]);
				playerInfo[playerid][pRent] = -1;
				if(playerInfo[playerid][pSpawnChange] == 3) playerInfo[playerid][pSpawnChange] = 1;
				update("UPDATE `server_users` SET `Rent` = '%d', `SpawnChange` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pRent], playerInfo[playerid][pSpawnChange], playerInfo[playerid][pSQLID]);
				SCM(playerid, COLOR_GREY, "* House Notice: Ai fost dat afara din chiria ta deoarece nu ai destui bani in banca.");
			}
			else if(houseInfo[houseid][hRentPrice] >= 1 && playerInfo[playerid][pBank] >= houseInfo[houseid][hRentPrice]) {
				GivePlayerBank(playerid, -houseInfo[houseid][hRentPrice]);
				houseInfo[houseid][hBalance] += houseInfo[houseid][hRentPrice];
				update("UPDATE `server_houses` SET `Balance` = '%d' WHERE `ID` = '%d'", houseInfo[houseid][hBalance], houseInfo[houseid][hID]);
				SCM(playerid, COLOR_GREY, string_fast("* Ai platit chiria $%s *", formatNumber(houseInfo[houseid][hRentPrice])));
			}
		}
		update("UPDATE `server_users` SET `Licenses` = '%d|%d|%d|%d|%d|%d|%d|%d', `Bank` = '%d', `MBank` = '%d',  `Money` = '%d', `MStore` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pDrivingLicense], playerInfo[playerid][pDrivingLicenseSuspend], playerInfo[playerid][pWeaponLicense], playerInfo[playerid][pWeaponLicenseSuspend], playerInfo[playerid][pFlyLicense], playerInfo[playerid][pFlyLicenseSuspend], playerInfo[playerid][pBoatLicense], playerInfo[playerid][pBoatLicenseSuspend], playerInfo[playerid][pBank], playerInfo[playerid][pStoreBank], MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSQLID]);
		SCM(playerid, COLOR_GREY, "--------------------------------------");
	}
}

timer respawnTimer[500](playerid, Float:x, Float:y, Float:z, virtual_world, interior) {
	SetPlayerPos(playerid, x, y, z);
	SetPlayerVirtualWorld(playerid, virtual_world);
	SetPlayerInterior(playerid, interior);
	return true;
}

timer ExpirationReport[120000](id) {
	SCM(reportInfo[id][reportID], COLOR_GREY, "* Report-ul tau a fost anulat.");
	sendAdmin(COLOR_SERVER, "Notice Report: {ffffff}Report-ul lui %s a fost anulat automat.", getName(reportInfo[id][reportID]));
	reportInfo[id][reportID] = INVALID_PLAYER_ID;
	reportInfo[id][reportPlayer] = INVALID_PLAYER_ID;
	reportInfo[id][reportType] = REPORT_TYPE_NONE;
	reportInfo[id][reportText] = (EOS);
	Iter_Remove(Reports, id);
	return true;
}
/*timer PickupLabel[500](playerid, label_id) {
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof gQuery, "SELECT * FROM `server_labels` WHERE `ID`='%d'", labelInfo[label_id][labelSQLID]);
	inline getText() {
		if(!cache_num_rows()) return sendPlayerError(playerid, "Nu s-au gasit randuri in baza de date.");
		cache_get_value_name(0, "Text", labelInfo[label_id][labelText], 128);
		labelInfo[label_id][labelID] = CreateDynamic3DTextLabel(labelInfo[label_id][labelText], -1, labelInfo[label_id][labelX], labelInfo[label_id][labelY], labelInfo[label_id][labelZ],  25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, labelInfo[label_id][labelVirtualWorld], labelInfo[label_id][labelInterior]);
		SCM(playerid, COLOR_SERVER, string_fast("* Notice Label: Ai creat un 3D Text Label (id: %d, sqlid: %d, worldid: %d, interior: %d)", labelInfo[label_id][labelID], labelInfo[label_id][labelSQLID], labelInfo[label_id][labelVirtualWorld], labelInfo[label_id][labelInterior]));
		return true;
	}
	mysql_pquery_inline(SQL, gQuery, using inline getText, "");
	return true;
}*/

timer closeGate[6000](gate) {
	switch(gate) {
		case 1: {
			MoveDynamicObject(gates[0], 1544.71, -1630.99, 13.28,  2.0, 0.00, -90.00, -90.00);
			print("bos bos hah");
		}
	}
	return true;
}

timer tazerTimer[10000](playerid) {
	TogglePlayerControllable(playerid, 1);
	return true;
}
