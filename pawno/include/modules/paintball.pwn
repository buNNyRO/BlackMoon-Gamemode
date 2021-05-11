new Iterator:PaintballMap[3]<MAX_PLAYERS>, PaintballTime[3];

#define MAX_PLAYERS_PAINTBALL 20

/*
	DE FACUT:
	SETARE POZITI IN ARENA,
	SETARE VIRTUALWORLD IN ARENA,
	SETARE INTERIOR IN ARENA,
*/

stock getPaintballRank(playerid) {
	new rank[25];
	switch(playerInfo[playerid][pPaintballKills]) {
		case 0..25: rank = "Rookie";
		case 25..50: rank = "Advanced";
		case 50..100: rank = "Legendary";
		case 100..200: rank = "Invincible";
		case 200..300: rank = "Unbeatable";
	}
	return rank;
}

stock sendPaintballMapMsg(map, color, const message[], va_args<>) {
	if(!Iter_Count(PaintballMap[map])) return true;
	gString[0] = (EOS);
	va_format(gString, 144, message, va_start<3>);			
	foreach(new id : PaintballMap[map]) sendSplitMessage(id, color, gString);
	return true;
}

stock mapName(map) {
	new nameMap[25];
	if(map == 1) nameMap = "Mapa #1";
	else if(map == 2) nameMap = "Mapa #2";
	else if(map == 3) nameMap = "Mapa #3";
	return nameMap;
}

timer timerPaintballMap[1000](map) {
	PaintballTime[map] --;
	if(PaintballTime[map] == 0) {
		stop paint[map];
		foreach(new i : PaintballMap[map]) {
			if(!Iter_Count(PaintballMap[map])) return true;
			new rand_money = 500000 + random(500000), rand_rp = 5 + random(5);
			playerInfo[i][pinPaintball] = 0;
			playerInfo[i][pRespectPoints] += rand_rp;
			GivePlayerCash(i, 1, rand_money);
			Iter_Remove(PaintballMap[map], i);
			SCMf(i, COLOR_SERVER, "* (Paintball): {ffffff}Deoarece runda s-a terminat pe mapa '%s' ati primit $%s si %dx respect points. Felicitari !", mapName(map), formatNumber(rand_money), rand_rp);
			if(Iter_Contains(FactionMembers[8], i) && Iter_Contains(FactionMembers[9], i)) {
				new rand_mats = 50000 + random(50000), rand_drugs = 10 + random(10);
				playerInfo[i][pMats] += rand_mats;
				playerInfo[i][pDrugs] += rand_drugs;
				SCMf(i, COLOR_SERVER, "* (Paintball): {ffffff}Deoarece faci parte dintr-o mafie, o sa primesti si o suma de %s materiale si %dx droguri.", formatNumber(rand_mats), rand_drugs);
			}
			update("UPDATE `server_users` SET `RespectPoints` = '%d', `Money`= '%d', `MStore` = '%d', `Mats` = '%d', `Drugs` = '%d' WHERE `ID` = '%d' LIMIT 1", playerInfo[i][pRespectPoints], MoneyMoney[i], StoreMoney[i], playerInfo[i][pMats], playerInfo[i][pDrugs], playerInfo[i][pSQLID]);
		}
	}
	return true;
}

Dialog:DIALOG_PAINTBALL(playerid, response, listitem) {
	if(!response) return true;
	switch(listitem) {
		case 0: {
			if(Iter_Count(PaintballMap[1]) == MAX_PLAYERS_PAINTBALL) return sendPlayerError(playerid, "In aceasta arena s-a atins limita maxima de jucatori.");
			if(Iter_Count(PaintballMap[1]) >= 2 && paint[0] != Timer:-1) {
				PaintballTime[1] = 500;
				paint[0] = repeat timerPaintballMap(1);
			}
			playerInfo[playerid][pinPaintball] = 1;
			Iter_Add(PaintballMap[1], playerid);
			sendPaintballMapMsg(1, COLOR_SERVER, "* (Paintball): {ffffff}%s (%d) a intrat in arena '%s' de paintball acum sunt %d/%d jucatori.", getName(playerid), playerid, mapName(1), Iter_Count(PaintballMap[1]), MAX_PLAYERS_PAINTBALL);
		}
	}
	return true;
}

CMD:enterpaint(playerid, params[]) {
	if(playerInfo[playerid][pinPaintball] > 0) return sendPlayerError(playerid, "Esti deja intr-o arena paintball.");
	if(playerInfo[playerid][pLevel] < 5) return sendPlayerError(playerid, "Nu ai minim level 5.");
	if(playerInfo[playerid][pWeaponLicense] == 0 && playerInfo[playerid][pWeaponLicenseSuspend] > 0) return sendPlayerError(playerid, "Nu ai licenta de gun sau o ai suspendata.");
	if(!IsPlayerInRangeOfPoint(playerid, 3.5, -92.3518,1189.1565,19.7422)) return sendPlayerError(playerid, "Nu esti la paintball.");
	Dialog_Show(playerid, DIALOG_PAINTBALL, DIALOG_STYLE_TABLIST_HEADERS, "Paintball - Select Map", string_fast("Map\tPlayers\tTime\n%s\t%d/%d\t%s", mapName(1), Iter_Count(PaintballMap[1]), MAX_PLAYERS_PAINTBALL, secinmin(PaintballTime[1])), "Select", "Close");
	return true;
}

CMD:leavepaint(playerid, params[]) {
	if(playerInfo[playerid][pinPaintball] == 0) return sendPlayerError(playerid, "Nu esti intr-o arena paintball.");
	for(new i = 0; i < 3; i++) {
		if(Iter_Contains(PaintballMap[i], playerid)) {
			Iter_Remove(PaintballMap[i], playerid);
			sendPaintballMapMsg(i, COLOR_SERVER, "* (Paintball): {ffffff}%s (%d) a iesit din arena '%s' de paintball acum sunt %d/%d jucatori.", getName(playerid), playerid, mapName(i), Iter_Count(PaintballMap[i]), MAX_PLAYERS_PAINTBALL);
		}
	}
	playerInfo[playerid][pinPaintball] = 0;
	return true;
}
