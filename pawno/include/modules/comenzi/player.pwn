YCMD:admins(playerid, params[], help)
{
	if(!Iter_Count(ServerAdmins))
		return sendPlayerError(playerid, "Nu sunt admini conectati.");

	SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	foreach(new i : ServerAdmins) {
		SCM(playerid, COLOR_WHITE, string_fast("* %s(%d) - Nivel: %d", getName(i), i, playerInfo[i][pAdmin]));
	}
	SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	return true;
}

YCMD:helpers(playerid, params[], help)
{
	if(!Iter_Count(ServerHelpers))
		return sendPlayerError(playerid, "Nu sunt helperi conectati.");

	SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	foreach(new i : ServerHelpers) {
		switch(HelperDuty[playerid]) {
			case 0: SCM(playerid, COLOR_WHITE, string_fast("* %s(%d) - Nivel: %d", getName(i), i, playerInfo[i][pHelper]));
			case 1: SCM(playerid, COLOR_WHITE, string_fast("* %s(%d) - Nivel: %d ON-DUTY", getName(i), i, playerInfo[i][pHelper]));
		}
	}
	SendClientMessage(playerid, COLOR_GREY, "-----------------------------------------------------------");
	return true;
}

YCMD:licenses(playerid, params[], help)
	return showLicenses(playerid, playerid);


YCMD:stats(playerid, params[], help)
	return showStats(playerid, playerid);

YCMD:showlicenses(playerid, params[], help) {
	extract params -> new userID; else return sendPlayerSyntax(playerid, "/showlicenses <name/id>");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este connectat.");
	showLicenses(playerid, userID);
	SCM(playerid, COLOR_LIMEGREEN, string_fast("* Ai aratat licentele tale lui %s.", getName(userID)));
	SCM(userID, COLOR_LIMEGREEN, string_fast("* %s ti-a aratat licentele.", getName(playerid)));
	return true;
}

YCMD:buylevel(playerid, params[], help)
{
	new money = (playerInfo[playerid][pLevel] * 250);
	if(GetPlayerCash(playerid) < money)
		return sendPlayerError(playerid, "Ai nevoie de $%s.", formatNumber(money));

	new respect = (playerInfo[playerid][pLevel] * 3);
	if(playerInfo[playerid][pRespectPoints] < respect)
		return sendPlayerError(playerid, "Ai nevoie de %d puncte de respect.", respect);

	playerInfo[playerid][pRespectPoints] -= respect;
	playerInfo[playerid][pLevel] ++;

	SetPlayerScore(playerid, playerInfo[playerid][pLevel]);
	GivePlayerCash(playerid, 0, money);
	updateLevelBar(playerid);

	update("UPDATE `server_users` SET `Level` = '%d', `Money` = '%d', `MStore` = '%d', `RespectPoints` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pLevel], MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pRespectPoints], playerInfo[playerid][pSQLID]);
	SCM(playerid, COLOR_YELLOW, string_fast("Felicitari, ai cumparat nivel %d.", playerInfo[playerid][pLevel]));
	return true;
}

YCMD:exam(playerid, params[], help) {
	if(playerInfo[playerid][pDrivingLicense] > 0) return sendPlayerError(playerid, "Ai deja licenta de condus.");
	if(playerInfo[playerid][pDrivingLicenseSuspend] > 0) return sendPlayerError(playerid, "Ai licenta suspendata pentru %d ore.", playerInfo[playerid][pDrivingLicenseSuspend]);
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 1111.0061, -1795.6694, 16.7100) && GetPlayerVirtualWorld(playerid) != 0) return sendPlayerError(playerid, "Nu te afli la pozitia in care poti da examen-ul, sau te afli in alt Virtual World"); 
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Te afli intr-un vehicul, coboara jos.");
	if(!Iter_Count(ExamenCheckpoints)) return sendPlayerError(playerid, "Momentan nu poti sustine acest examen, exista o eroare tehnica te rugam sa revii mai tarziu.");
	if(GetPlayerCash(playerid) < 500) return sendPlayerError(playerid, "Nu ai $500.");
	GivePlayerCash(playerid, 0, 500);
	update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d' WHERE `ID`='%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSQLID]);
	SetPlayerVirtualWorld(playerid, (playerid +1));
	playerInfo[playerid][pExamenVehicle] = CreateVehicle(589, 1110.1354, -1743.3287, 13.0742, -90, -1, -1, -1);
	SetVehicleVirtualWorld(playerInfo[playerid][pExamenVehicle], (playerid +1));
	PutPlayerInVehicle(playerid, playerInfo[playerid][pExamenVehicle], 0);
	vehicle_fuel[playerInfo[playerid][pExamenVehicle]] = 100.0;
	vehicle_personal[playerInfo[playerid][pExamenVehicle]] = -1;
	SetPlayerCheckpoint(playerid, examenInfo[Iter_First(ExamenCheckpoints)][dmvX], examenInfo[Iter_First(ExamenCheckpoints)][dmvY], examenInfo[Iter_First(ExamenCheckpoints)][dmvZ], 3.0);
	playerInfo[playerid][pExamenCheckpoint] = Iter_First(ExamenCheckpoints);
	PlayerTextDrawSetString(playerid, playerExamenPTD[playerid], string_fast("DMV Exam~n~Checkpoints:%d/%d~n~Stay Tuned !", (playerInfo[playerid][pExamenCheckpoint] - 1), Iter_Count(ExamenCheckpoints)));
	PlayerTextDrawShow(playerid, playerExamenPTD[playerid]);
	SCM(playerid, COLOR_AQUA, "DMV Exam: {ffffff} Examen-ul a inceput, te rugam sa intri in toate checkpoint-urile.");	
	return true;
}

YCMD:engine(playerid, params[], help) {
	if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return true;
	if(isBike(GetPlayerVehicleID(playerid))) return sendPlayerError(playerid, "Acest vehicul nu are un motor.");
	if(GetPVarInt(playerid, "engineDeelay") == gettime()) return true;
	if(vehicle_personal[GetPlayerVehicleID(playerid)] > -1) {
		if(personalVehicle[vehicle_personal[GetPlayerVehicleID(playerid)]][pvInsurancePoints] <= 0) return sendPlayerError(playerid, "Acest vehicul nu detine puncte de asigurare."); SetPVarInt(playerid, "engineDeelay", gettime());
	}
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);

	sendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "* %s a %s motorul unui %s", getName(playerid), (vehicle_engine[GetPlayerVehicleID(playerid)]) ? ("oprit") : ("pornit"), getVehicleName(GetVehicleModel(GetPlayerVehicleID(playerid))));
	SetPVarInt(playerid, "engineDeelay", gettime());

	if(vehicle_engine[GetPlayerVehicleID(playerid)] == false) {
		vehicle_engine[GetPlayerVehicleID(playerid)] = true;
		SetVehicleParamsEx(GetPlayerVehicleID(playerid), VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
		return true;
	}

	SetVehicleParamsEx(GetPlayerVehicleID(playerid), VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
	vehicle_engine[GetPlayerVehicleID(playerid)] = false;
	return true;
}

YCMD:lights(playerid, params[], help) {
	if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return sendPlayerError(playerid, "Nu esti soferul unui vehicul.");
	if(isBike(GetPlayerVehicleID(playerid)) && isPlane(GetPlayerVehicleID(playerid)) && isBoat(GetPlayerVehicleID(playerid))) return sendPlayerError(playerid, "Acest vehicul nu are faruri.");
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
	if(vehicle_lights[GetPlayerVehicleID(playerid)] == false) {
		vehicle_lights[GetPlayerVehicleID(playerid)] = true;
		SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective);
		return true;
	}
	SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective);
	vehicle_lights[GetPlayerVehicleID(playerid)] = false;
	return true;
}


YCMD:report(playerid, params[], help) {
	if(Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda, deoarece esti administrator.");
	if(playerInfo[playerid][pReportMute] > gettime()) return sendPlayerError(playerid, "Pentru a folosi aceasta comanda trebuie sa astepti %d secunde", (playerInfo[playerid][pReportMute] - gettime()));
	if(Iter_Count(Reports) >= MAX_REPORTS) return sendPlayerError(playerid, "Momentan sunt prea multe report-uri in asteptare.");
	if(!Iter_Count(ServerAdmins)) return sendPlayerError(playerid, "Nu sunt admini conectati.");
	if(PlayerHaveReport(playerid)) return sendPlayerError(playerid, "Ai deja un report in asteptare.");
	Dialog_Show(playerid, DIALOG_REPORT, DIALOG_STYLE_LIST, "Report:", "Normal\nCheater\nStuck", "Select", "Cancel");
	return true;
}

YCMD:spawnchange(playerid, params[], help) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a face aceasta actiune.");
	if(Dialog_Opened(playerid)) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda cat timp ai un dialog afisat.");
	Dialog_Show(playerid, SPAWNCHANGE, DIALOG_STYLE_LIST, "Spawnchange:", "Spawn\nHouse\nRent\nFaction", "Select", "Cancel");
	return true;
}

YCMD:killcp(playerid, params[], help) {
	if(playerInfo[playerid][pCheckpoint] == CHECKPOINT_NONE) return sendPlayerError(playerid, "Nu ai un checkpoint activ pe mini map.");
	DisablePlayerCheckpoint(playerid);
	playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
	playerInfo[playerid][pCheckpointID] = -1;
	SCM(playerid, COLOR_GREY, "* Checkpoint Notice: Ai dezactivat checkpoint-ul de pe mini map-ul tau.");
	return true;
}

YCMD:sms(playerid, params[], help) {
	if(playerInfo[playerid][pMute] > 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece ai mute inca %d secunde.", playerInfo[playerid][pMute]);
	extract params -> new phonenumber, string:smstext[180]; else return sendPlayerSyntax(playerid, "/sms <number> <text>");	
	if(playerInfo[playerid][pPhone] == 0) return sendPlayerError(playerid, "Nu ai un telefon.");
	if(playerInfo[playerid][pPhoneOnline] == 0) return sendPlayerError(playerid, "Telefonul tau este inchis.");
	if(playerInfo[PlayerNumber[phonenumber]][pPhone] == playerInfo[playerid][pPhone]) return sendPlayerError(playerid, "Nu iti poti trimite sms tie.");
	new giveplayerid;
	if(playerInfo[PlayerNumber[phonenumber]][pPhone] == phonenumber && phonenumber != 0) {
		giveplayerid = PlayerNumber[phonenumber];
		if(isPlayerLogged(giveplayerid) && giveplayerid == INVALID_PLAYER_ID) return sendPlayerError(playerid, "Numar de telefon invalid.");
		if(playerInfo[giveplayerid][pPhoneOnline] == 0) return sendPlayerError(playerid, "Telefonul lui este inchis.");
		SCM(giveplayerid, COLOR_YELLOW, string_fast("(*) SMS de la %s (%d): %s.", getName(playerid), playerid, smstext));
		SCM(playerid, COLOR_YELLOW, string_fast("(*) SMS trimis lui %s (%d): %s.", getName(giveplayerid), giveplayerid, smstext));
		sendToAdmin(playerid, COLOR_LIGHTRED, "(SMS Log): {FFFFFF} %s(%d) catre %s(%d): %s.", getName(playerid), playerid, getName(giveplayerid), giveplayerid, smstext);
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		PlayerPlaySound(giveplayerid, 1138, 0.0, 0.0, 0.0);
		playerInfo[giveplayerid][pReply] = playerid;
	}
	SCM(playerid, COLOR_GREY, "Numar de telefon invalid !");
	return true;
}

YCMD:number(playerid, params[], help) {
	extract params -> new player:targetid; else return sendPlayerSyntax(playerid, "/number <name/id>");
	if(!isPlayerLogged(targetid)) return sendPlayerError(playerid, "Acel player nu este connectat.");
	if(playerInfo[playerid][pPhoneBook] == 0) return sendPlayerError(playerid, "Nu ai o agenda telefonica.");
	if(targetid == playerid) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda asupra ta.");
	if(playerInfo[targetid][pPhone] > 0)
	SCM(playerid, COLOR_GREY, string_fast("(&) %s's phone number: %s", getName(targetid), playerInfo[targetid][pPhone] ? (string_fast("%d", playerInfo[targetid][pPhone])) : ("None")));
	return true;
}

YCMD:reply(playerid, params[], help) {
	if(playerInfo[playerid][pMute] > 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece ai mute inca %d secunde.", playerInfo[playerid][pMute]);
	extract params -> new string:smstext[180]; else return sendPlayerSyntax(playerid, "/reply <text>");	
	if(playerInfo[playerid][pPhone] == 0) return sendPlayerError(playerid, "Nu ai un telefon.");
	if(strlen(playerInfo[playerid][pPhone]) != 4) return sendPlayerError(playerid, "Nu ai un iPhone.");
	if(playerInfo[playerid][pPhoneOnline] == 0) return sendPlayerError(playerid, "Telefonul tau este inchis.");
	new giveplayerid, phonenumber = playerInfo[playerInfo[playerid][pReply]][pPhone];
	if(playerInfo[PlayerNumber[phonenumber]][pPhone] == phonenumber && phonenumber != 0) {
		giveplayerid = PlayerNumber[phonenumber];
		if(isPlayerLogged(giveplayerid) && giveplayerid == INVALID_PLAYER_ID) return sendPlayerError(playerid, "Numar de telefon invalid.");
		if(playerInfo[giveplayerid][pPhoneOnline] == 0) return sendPlayerError(playerid, "Telefonul lui este inchis.");
		SCM(giveplayerid, COLOR_YELLOW, string_fast("(*) SMS de la %s (%d): %s.", getName(playerid), playerid, smstext));
		SCM(playerid, COLOR_YELLOW, string_fast("(*) SMS trimis lui %s (%d): %s.", getName(giveplayerid), giveplayerid, smstext));
		sendToAdmin(playerid, COLOR_LIGHTRED, "(SMS Log): {FFFFFF} %s(%d) catre %s(%d): %s.", getName(playerid), playerid, getName(giveplayerid), giveplayerid, smstext);
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		PlayerPlaySound(giveplayerid, 1138, 0.0, 0.0, 0.0);
		playerInfo[giveplayerid][pReply] = playerid;
	}
	SCM(playerid, COLOR_GREY, "Numar de telefon invalid !");
	return true;
}

YCMD:gps(playerid, params[], help) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti conectat.");
	if(Dialog_Opened(playerid)) return sendPlayerError(playerid, "Nu poti folosi comanda, deoarece ai un dialog afisat.");
	if(playerInfo[playerid][pCheckpoint] != CHECKPOINT_NONE) return sendPlayerError(playerid, "Ai un checkpoint activ pe harta.");
	Dialog_Show(playerid, GPS, DIALOG_STYLE_LIST, "SERVER: Locations", "Los Santos\nLas Venturas\nSan Fierro\nSpecial Locations", "Ok", "Cancel");
	return true;
}

YCMD:cancel(playerid, params[], help) {
	extract params -> new player:targetid = 1001, string:item[32]; else {
		sendPlayerSyntax(playerid, "/cancel <name/id> <service>");
		SCM(playerid, COLOR_GREY, "Available service: Medic, Taxi, Instructor.");
		return true;
	}
	if(!isPlayerLogged(targetid) && targetid != 1001) return sendPlayerError(playerid, "Player not connected.");
	if(strmatch(item, "medic")) {
		if(MedicAcceptedCall[playerid] == -1 && !Iter_Contains(ServiceCalls[SERVICE_PARAMEDICS], playerid)) return sendPlayerError(playerid, "You don't have an call.");
		if(Iter_Contains(ServiceCalls[SERVICE_PARAMEDICS], playerid)) {
			sendFactionMessage(1, COLOR_LIMEGREEN, "(*) %s a anulat apelul.", getName(playerid));
			SCM(playerid, COLOR_LIGHTRED, string_fast("* (Paramedic Call): {FFFFFF}You canceled the call."));
			Iter_Remove(ServiceCalls[SERVICE_PARAMEDICS], playerid);
			return true;
		}
		if(Iter_Contains(FactionMembers[1], playerid) && MedicAcceptedCall[playerid] != -1) {
			MedicAcceptedCall[playerid] = -1;
			MedicAcceptedCall[MedicAcceptedCall[playerid]] = -1;
			sendFactionMessage(1, COLOR_LIMEGREEN, "(*) %s a anulat apelul lui %s.", getName(playerid), getName(MedicAcceptedCall[playerid]));
			SCM(MedicAcceptedCall[playerid], COLOR_LIGHTRED, string_fast("{FF6347}(Paramedic Call): {FFFFFF}Your call has been canceled by %s.", getName(playerid)));
			DisablePlayerCheckpoint(playerid);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			return true;
		}
		if(MedicAcceptedCall[playerid] != INVALID_PLAYER_ID) {
			MedicAcceptedCall[playerid] = -1;
			MedicAcceptedCall[MedicAcceptedCall[playerid]] = -1;	
			sendFactionMessage(1, COLOR_LIMEGREEN, "(*) %s a anulat apelul preluat de medic %s.", getName(playerid), getName(MedicAcceptedCall[playerid]));
			SCM(playerid, COLOR_LIGHTRED, string_fast("{FF6347}(Paramedic Call): {FFFFFF}Your call has been canceled."));
			if(playerInfo[MedicAcceptedCall[playerid]][pCheckpoint] == CHECKPOINT_FACTION_DUTY && playerInfo[MedicAcceptedCall[playerid]][pCheckpointID] == playerid) {
				DisablePlayerCheckpoint(MedicAcceptedCall[playerid]);
				playerInfo[MedicAcceptedCall[playerid]][pCheckpoint] = CHECKPOINT_NONE;
				playerInfo[MedicAcceptedCall[playerid]][pCheckpointID] = -1;
			}
		}
		return true;
	}
	if(strmatch(item, "taxi")) {
		if(TaxiAcceptedCall[playerid] == -1 && !Iter_Contains(ServiceCalls[SERVICE_TAXI], playerid)) return sendPlayerError(playerid, "You don't have an call.");
		if(Iter_Contains(ServiceCalls[SERVICE_TAXI], playerid)) {
			sendFactionMessage(5, COLOR_LIMEGREEN, "(*) %s a anulat apelul.", getName(playerid));
			SCM(playerid, COLOR_YELLOW, string_fast("* (Taxi Call): {FFFFFF}You canceled the call."));
			Iter_Remove(ServiceCalls[SERVICE_TAXI], playerid);
			return true;
		}
		if(Iter_Contains(FactionMembers[5], playerid) && TaxiAcceptedCall[playerid] != -1) {
			TaxiAcceptedCall[playerid] = -1;
			TaxiAcceptedCall[TaxiAcceptedCall[playerid]] = -1;
			sendFactionMessage(5, COLOR_LIMEGREEN, "(*) %s a anulat apelul lui %s.", getName(playerid), getName(TaxiAcceptedCall[playerid]));
			SCM(TaxiAcceptedCall[playerid], COLOR_YELLOW, string_fast("{FF6347}(Taxi Call): {FFFFFF}Your call has been canceled by %s.", getName(playerid)));
			DisablePlayerCheckpoint(playerid);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			return true;
		}
		if(TaxiAcceptedCall[playerid] != INVALID_PLAYER_ID) {
			TaxiAcceptedCall[playerid] = -1;
			TaxiAcceptedCall[TaxiAcceptedCall[playerid]] = -1;	
			sendFactionMessage(5, COLOR_LIMEGREEN, "(*) %s a anulat apelul preluat de medic %s.", getName(playerid), getName(TaxiAcceptedCall[playerid]));
			SCM(playerid, COLOR_YELLOW, string_fast("{FF6347}(Taxi Call): {FFFFFF}Your call has been canceled."));
			if(playerInfo[TaxiAcceptedCall[playerid]][pCheckpoint] == CHECKPOINT_FACTION_DUTY && playerInfo[TaxiAcceptedCall[playerid]][pCheckpointID] == playerid) {
				DisablePlayerCheckpoint(TaxiAcceptedCall[playerid]);
				playerInfo[TaxiAcceptedCall[playerid]][pCheckpoint] = CHECKPOINT_NONE;
				playerInfo[TaxiAcceptedCall[playerid]][pCheckpointID] = -1;
			}
		}
		return true;
	}
	if(strmatch(item, "instructor")) {
		if(InstructorAcceptedCall[playerid] == -1 && !Iter_Contains(ServiceCalls[SERVICE_INSTRUCTOR], playerid)) return sendPlayerError(playerid, "You don't have an call.");
		if(Iter_Contains(ServiceCalls[SERVICE_INSTRUCTOR], playerid)) {
			sendFactionMessage(5, COLOR_LIMEGREEN, "(*) %s a anulat apelul.", getName(playerid));
			SCM(playerid, COLOR_LIGHTGREEN, string_fast("* (Instructor Call): {FFFFFF}You canceled the call."));
			Iter_Remove(ServiceCalls[SERVICE_INSTRUCTOR], playerid);
			return true;
		}
		if(Iter_Contains(FactionMembers[5], playerid) && InstructorAcceptedCall[playerid] != -1) {
			InstructorAcceptedCall[playerid] = -1;
			InstructorAcceptedCall[InstructorAcceptedCall[playerid]] = -1;
			sendFactionMessage(5, COLOR_LIMEGREEN, "(*) %s a anulat apelul lui %s.", getName(playerid), getName(InstructorAcceptedCall[playerid]));
			SCM(InstructorAcceptedCall[playerid], COLOR_LIGHTGREEN, string_fast("{FF6347}(Instructor Call): {FFFFFF}Your call has been canceled by %s.", getName(playerid)));
			DisablePlayerCheckpoint(playerid);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			return true;
		}
		if(InstructorAcceptedCall[playerid] != INVALID_PLAYER_ID) {
			InstructorAcceptedCall[playerid] = -1;
			InstructorAcceptedCall[InstructorAcceptedCall[playerid]] = -1;	
			sendFactionMessage(5, COLOR_LIMEGREEN, "(*) %s a anulat apelul preluat de medic %s.", getName(playerid), getName(InstructorAcceptedCall[playerid]));
			SCM(playerid, COLOR_LIGHTGREEN, string_fast("{FF6347}(Instructor Call): {FFFFFF}Your call has been canceled."));
			if(playerInfo[InstructorAcceptedCall[playerid]][pCheckpoint] == CHECKPOINT_FACTION_DUTY && playerInfo[InstructorAcceptedCall[playerid]][pCheckpointID] == playerid) {
				DisablePlayerCheckpoint(InstructorAcceptedCall[playerid]);
				playerInfo[InstructorAcceptedCall[playerid]][pCheckpoint] = CHECKPOINT_NONE;
				playerInfo[InstructorAcceptedCall[playerid]][pCheckpointID] = -1;
			}
		}
		return true;
	}
	return true;
}
YCMD:accept(playerid, params[], help) {
	extract params-> new player:targetid = 1001, string:item[32]; else {
		sendPlayerSyntax(playerid, "/accept <name/id> <service>");
		SCM(playerid, COLOR_GREY, "Available service: medic, taxi, instructor, invite, ticket, live, lesson, cinvite.");
		return true;
	}
	if(strmatch(item, "medic")) {
		if(!Iter_Contains(FactionMembers[1], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'Paramedic Department' pentru a folosi aceasta comanda.");
		if(MedicAcceptedCall[playerid] != -1) return sendPlayerError(playerid, "Ai deja un apel acceptat.");
		if(vehicleFaction[GetPlayerVehicleID(playerid)] != playerInfo[playerid][pFaction]) return sendPlayerError(playerid, "Nu esti intr-un vehicul al factiunii.");
		if(!Iter_Contains(ServiceCalls[SERVICE_PARAMEDICS], targetid)) return sendPlayerError(playerid, "Acel player nu are un apel.");
		if(playerInfo[playerid][pCheckpoint] != CHECKPOINT_NONE) return sendPlayerError(playerid, "Ai un checkpoint activ.");
		sendFactionMessage(1, COLOR_LIMEGREEN, "(*) %s a acceptat apelul lui %s.", getName(playerid), getName(targetid));
		SCM(targetid, COLOR_LIGHTRED, string_fast("* (Paramedic Call): {FFFFFF}Your call has been accepted by %s, please wait.", getName(playerid)));
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		SetPlayerCheckpoint(playerid, x, y, z, 4.0);
		playerInfo[playerid][pCheckpoint] = CHECKPOINT_FACTION_DUTY;
		playerInfo[playerid][pCheckpointID] = targetid;
		Iter_Remove(ServiceCalls[SERVICE_PARAMEDICS], targetid);
		MedicAcceptedCall[playerid] = targetid;
		MedicAcceptedCall[targetid] = playerid;
		return true;
	}
	if(strmatch(item, "taxi")) {
		if(!Iter_Contains(FactionMembers[5], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'Taxi Company' pentru a folosi aceasta comanda.");
		if(TaxiAcceptedCall[playerid] != -1) return sendPlayerError(playerid, "Ai deja un apel acceptat.");
		if(vehicleFaction[GetPlayerVehicleID(playerid)] != playerInfo[playerid][pFaction]) return sendPlayerError(playerid, "Nu esti intr-un vehicul al factiunii.");
		if(!Iter_Contains(ServiceCalls[SERVICE_TAXI], targetid)) return sendPlayerError(playerid, "Acel player nu are un apel.");
		if(playerInfo[playerid][pCheckpoint] != CHECKPOINT_NONE) return sendPlayerError(playerid, "Ai un checkpoint activ.");
		sendFactionMessage(5, COLOR_LIMEGREEN, "(*) %s a acceptat apelul lui %s.", getName(playerid), getName(targetid));
		SCM(targetid, COLOR_YELLOW, string_fast("* (Taxi Call): {FFFFFF}Your call has been accepted by %s, please wait.", getName(playerid)));
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		SetPlayerCheckpoint(playerid, x, y, z, 4.0);
		playerInfo[playerid][pCheckpoint] = CHECKPOINT_FACTION_DUTY;
		playerInfo[playerid][pCheckpointID] = targetid;
		Iter_Remove(ServiceCalls[SERVICE_TAXI], targetid);
		TaxiAcceptedCall[playerid] = targetid;
		TaxiAcceptedCall[targetid] = playerid;
		return true;
	}
	if(strmatch(item, "instructor")) {
		if(!Iter_Contains(FactionMembers[7], playerid)) return sendPlayerError(playerid, "Nu esti in factiunea 'School Instructors' pentru a folosi aceasta comanda.");
		if(InstructorAcceptedCall[playerid] != -1) return sendPlayerError(playerid, "Ai deja un apel acceptat.");
		if(vehicleFaction[GetPlayerVehicleID(playerid)] != playerInfo[playerid][pFaction]) return sendPlayerError(playerid, "Nu esti intr-un vehicul al factiunii.");
		if(!Iter_Contains(ServiceCalls[SERVICE_INSTRUCTOR], targetid)) return sendPlayerError(playerid, "Acel player nu are un apel.");
		if(playerInfo[playerid][pCheckpoint] != CHECKPOINT_NONE) return sendPlayerError(playerid, "Ai un checkpoint activ.");
		sendFactionMessage(7, COLOR_LIMEGREEN, "(*) %s a acceptat apelul lui %s.", getName(playerid), getName(targetid));
		SCM(targetid, COLOR_LIGHTGREEN, string_fast("* (Instructor Call): {FFFFFF}Your call has been accepted by %s, please wait.", getName(playerid)));
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		SetPlayerCheckpoint(playerid, x, y, z, 4.0);
		playerInfo[playerid][pCheckpoint] = CHECKPOINT_FACTION_DUTY;
		playerInfo[playerid][pCheckpointID] = targetid;
		Iter_Remove(ServiceCalls[SERVICE_INSTRUCTOR], targetid);
		InstructorAcceptedCall[playerid] = targetid;
		InstructorAcceptedCall[targetid] = playerid;
		return true;
	}
	if(strmatch(item, "invite")) {
		if(invitedByPlayer[playerid] == -1) return sendPlayerError(playerid, "Nu ai fost invitat de nimeni intr-o factiune.");
		SCM(invitedByPlayer[playerid], COLOR_WHITE, string_fast("{32CD32}*{ffffff} Jucatorul {32CD32}'%s'{ffffff} (%d) pe care l-ai invitat in factiunea ta a acceptat.", getName(playerid), playerid));
		SCM(playerid, COLOR_WHITE, string_fast("{32CD32}*{ffffff} Ai acceptat invitatia lui {32CD32}'%s'{ffffff} (%d) in factiunea lui.", getName(invitedByPlayer[playerid]), invitedByPlayer[playerid]));
		SCM(playerid, COLOR_WHITE, string_fast("{32CD32}*{ffffff} Deoarece ai acceptat invitatia in factiune, spawn-ul tau a fost schimbat la {32CD32}'Factiune'{ffffff}."));
		Iter_Add(FactionMembers[playerInfo[invitedByPlayer[playerid]][pFaction]], playerid);
		playerInfo[playerid][pFaction] = playerInfo[invitedByPlayer[playerid]][pFaction];
		playerInfo[playerid][pFactionRank] = 1;
		playerInfo[playerid][pFactionAge] = 0;
		playerInfo[playerid][pFactionWarns] = 0;
		playerInfo[playerid][pSpawnChange] = 4;
		playerInfo[playerid][pSkin] = fSkins[playerInfo[playerid][pFaction]][playerInfo[playerid][pFactionRank]];
		SetPlayerSkin(playerid, playerInfo[playerid][pSkin]);
		update("UPDATE `server_users` SET `Faction` = '%d', `FRank` = '7', `FAge` = '%d', `FWarns` = '0', `SpawnChange` = '4', `Skin` = '%d' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerid][pFaction], playerInfo[playerid][pFactionAge], playerInfo[playerid][pSkin], playerInfo[playerid][pSQLID]);
		sendFactionMessage(playerInfo[playerid][pFaction], COLOR_LIMEGREEN, "(+) %s (%d) a fost invitat de %s (%d) in factiune.", getName(playerid), playerid, getName(invitedByPlayer[playerid]), invitedByPlayer[playerid]);
		factionLog(playerInfo[playerid][pFaction], getName(playerid), string_fast("%s a intrat in factiune invitat de %s.", getName(playerid), getName(invitedByPlayer[playerid])));
		invitedPlayer[invitedByPlayer[playerid]] = -1;
		invitedByPlayer[playerid] = -1;	
		return true;
	}
	if(strmatch(item, "cinvite")) {
		if(clanInvitedBy[playerid] == -1) return sendPlayerError(playerid, "Nu ai fost invitat de nimeni intr-un clan.");
		SCM(clanInvitedBy[playerid], COLOR_GOLD, string_fast("* (Clan): Jucatorul '%s' (%d) pe care l-ai invitat in clanul tau a acceptat.", getName(playerid), playerid));
		SCM(playerid, COLOR_GOLD, string_fast("* (Clan): Ai acceptat invitatia de intrare in clan oferita de %S (%d).", getName(clanInvitedBy[playerid]), clanInvitedBy[playerid]));
		playerInfo[playerid][pClan] = playerInfo[clanInvitedBy[playerid]][pClan];
		playerInfo[playerid][pClanRank] = 1;
		playerInfo[playerid][pClanAge] = 0;
		playerInfo[playerid][pClanWarns] = 0;
		Iter_Add(TotalClanMembers, playerid);
		clanInfo[playerInfo[clanInvitedBy[playerid]][pClan]][cTotal]++;
		update("UPDATE `server_users` SET `Clan` = '%d', `ClanRank` = '0', `ClanAge` = '0', `Total` = Total+1, `ClanWarns` = '0' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerid][pClan], playerInfo[playerid][pSQLID]);
		clanInvitedBy[clanInvitedBy[playerid]] = -1;
		clanInvitedBy[playerid] = -1;
		return true;
	}
	if(strmatch(item, "ticket")) {
		if(ticketPlayer[playerid] == -1) return sendPlayerError(playerid, "Nu ai primit o amenda.");
		if(!ProxDetectorS(8.0, playerid, ticketPlayer[playerid])) return sendPlayerError(playerid, "Acel player nu se afla in raza ta.");
		sendNearbyMessage(playerid, COLOR_GREY, 30.0, "*- %s i-a platit lui %s amenda. -*", getName(playerid), getName(ticketPlayer[playerid]));
		GivePlayerCash(playerid, 0, ticketMoney[playerid]);
		GivePlayerCash(ticketPlayer[playerid], 1, ticketMoney[playerid]);
		addRaportPoint(ticketPlayer[playerid]);
		ticketPlayer[ticketPlayer[playerid]] = -1;
		ticketPlayer[playerid] = -1;
		ticketMoney[playerid] = -1;
		return true;
	}
	if(strmatch(item, "live")) {
		if(playerInfo[playerid][pLiveOffer] == -1) return sendPlayerError(playerid, "Nu ai primit o invitatie de conversatie 'Live'.");
		if(playerInfo[playerid][pLiveOffer] != targetid) return sendPlayerError(playerid, "Acest player nu ti-a oferit o invitatie de conversatie 'Live'.");
		if(!IsPlayerInVehicle(playerid, GetPlayerVehicleID(playerInfo[playerid][pLiveOffer]))) return sendPlayerError(playerid, "Nu esti in masina cu acest player.");
		SCM(playerid, COLOR_GREY, "* Ai primit freeze pana la terminarea conversatiei 'Live'.");
		SCM(playerInfo[playerid][pLiveOffer], COLOR_GREY, "* Ai primit freeze pana la terminarea conversatiei 'Live'. Pentru a opri foloseste comanda (/endlive).");
		TogglePlayerControllable(playerid, 0);
		TogglePlayerControllable(playerInfo[playerid][pLiveOffer], 0);
		playerInfo[playerid][pTalkingLive] = playerInfo[playerid][pLiveOffer];
		playerInfo[playerInfo[playerid][pLiveOffer]][pTalkingLive] = playerid;
		playerInfo[playerid][pLiveOffer] = -1;
		return true;
	}
	if(strmatch(item, "lesson")) {
		if(playerInfo[playerid][pInLesson] > 0) return sendPlayerError(playerid, "Esti deja intr-o lectie.");
		if(playerInfo[targetid][pInLesson] != playerid) return sendPlayerError(playerid, "Nu ai primit o oferta");
		if(playerInfo[targetid][pInLesson] > 0) return sendPlayerError(playerid, "Acel instructor are deja o lectie activa.");
		if(playerInfo[targetid][pFaction] != 7) return sendPlayerError(playerid, "Acel player nu face parte din factiunea 'School Instructors'.");
		playerInfo[playerid][pInLesson] = 0;
		playerInfo[targetid][pInLesson] = 0;
		playerInfo[targetid][pLesson] = 1;
		sendFactionMessage(playerInfo[targetid][pFaction], COLOR_LIMEGREEN, "* (SI Dispatch: %s (%d) a inceput o lectie cu %s (%d).) *", getName(targetid), targetid, getName(playerid), playerid);
		SCM(playerid, COLOR_GREY, string_fast("* Ai acceptat o lectie oferita de instructorul %s (%d).", getName(targetid), targetid));
		SCM(targetid, COLOR_GREY, string_fast("* %s (%d) ti-a acceptat cererea de lectie.", getName(playerid), playerid));		
		return true;
	}
	if(strmatch(item, "license")) {
		if(playerInfo[playerid][pLicenseOffer] == -1) return sendPlayerError(playerid, "Nu ai primit o oferta.");
		if(playerInfo[playerid][pLicenseOffer] != targetid) return sendPlayerError(playerid, "Acel player nu ti-a facut o oferta.");
		if(playerInfo[targetid][pFaction] != 7) return sendPlayerError(playerid, "Acel player nu face parte din factiunea 'School Instructors'.");
		switch(playerInfo[playerid][pLicense]) {
			case 1: {
				if(PlayerMoney(playerid, 100000)) return sendPlayerError(playerid, "Nu ai aceasta suma de bani.");
				GivePlayerCash(playerid, 0, 100000);
				GivePlayerCash(targetid, 1, 100000);
				
				playerInfo[playerid][pFlyLicense] = 50;
				update("UPDATE `server_users` SET `Licenses` = '%d|%d|%d|%d|%d|%d|%d|%d' WHERE `ID` = '%d'", playerInfo[playerid][pDrivingLicense], playerInfo[playerid][pDrivingLicenseSuspend], playerInfo[playerid][pWeaponLicense], playerInfo[playerid][pWeaponLicenseSuspend], playerInfo[playerid][pFlyLicense], playerInfo[playerid][pFlyLicenseSuspend], playerInfo[playerid][pBoatLicense], playerInfo[playerid][pBoatLicenseSuspend], playerInfo[playerid][pSQLID]);
				sendFactionMessage(playerInfo[targetid][pFaction], COLOR_LIMEGREEN, "* (SI Dispatch: %s (%d) i-a oferit licenta de 'Fly' lui %s (%d) pentru suma de $100,000.", getName(targetid), targetid, getName(playerid), playerid);
			}
			case 2: {
				if(PlayerMoney(playerid, 200000)) return sendPlayerError(playerid, "Nu ai aceasta suma de bani.");
				GivePlayerCash(playerid, 0, 200000);
				GivePlayerCash(targetid, 1, 200000);
				
				playerInfo[playerid][pBoatLicense] = 50;
				update("UPDATE `server_users` SET `Licenses` = '%d|%d|%d|%d|%d|%d|%d|%d' WHERE `ID` = '%d'", playerInfo[playerid][pDrivingLicense], playerInfo[playerid][pDrivingLicenseSuspend], playerInfo[playerid][pWeaponLicense], playerInfo[playerid][pWeaponLicenseSuspend], playerInfo[playerid][pFlyLicense], playerInfo[playerid][pFlyLicenseSuspend], playerInfo[playerid][pBoatLicense], playerInfo[playerid][pBoatLicenseSuspend], playerInfo[playerid][pSQLID]);
				sendFactionMessage(playerInfo[targetid][pFaction], COLOR_LIMEGREEN, "* (SI Dispatch: %s (%d) i-a oferit licenta de 'Boat' lui %s (%d) pentru suma de $200,000.", getName(targetid), targetid, getName(playerid), playerid);
			}
			case 3: {
				if(PlayerMoney(playerid, 300000)) return sendPlayerError(playerid, "Nu ai aceasta suma de bani.");
				GivePlayerCash(playerid, 0, 300000);
				GivePlayerCash(targetid, 1, 300000);
				
				playerInfo[playerid][pWeaponLicense] = 50;
				update("UPDATE `server_users` SET `Licenses` = '%d|%d|%d|%d|%d|%d|%d|%d' WHERE `ID` = '%d'", playerInfo[playerid][pDrivingLicense], playerInfo[playerid][pDrivingLicenseSuspend], playerInfo[playerid][pWeaponLicense], playerInfo[playerid][pWeaponLicenseSuspend], playerInfo[playerid][pFlyLicense], playerInfo[playerid][pFlyLicenseSuspend], playerInfo[playerid][pBoatLicense], playerInfo[playerid][pBoatLicenseSuspend], playerInfo[playerid][pSQLID]);
				sendFactionMessage(playerInfo[targetid][pFaction], COLOR_LIMEGREEN, "* (SI Dispatch: %s (%d) i-a oferit licenta de 'Gun' lui %s (%d) pentru suma de $300,000.", getName(targetid), targetid, getName(playerid), playerid);
			}
		}
		return true;
	}
	if(!isPlayerLogged(targetid) && targetid != 1001) return sendPlayerError(playerid, "Player not connected.");
	return true;
}

YCMD:animlist(playerid, params[], help) {
    SCM(playerid,COLOR_LIMEGREEN,"Anim list:");
    SCM(playerid,COLOR_LIMEGREEN,"Lifejump, Robman, Exhaust, Carlock, Rcarjack1, Lcarjack1, Rcarjack2, Lcarjack2, Hoodfrisked;");
    SCM(playerid,COLOR_LIMEGREEN,"Lightcig, Tapcig, Bat, Lean, Clearanim, Dancing, Box, Lowthrow, Highthrow;");
    SCM(playerid,COLOR_LIMEGREEN,"Leftslap, Handsup, Fall, Fallback, Sup, Rap, Push, Akick, Lowbodypush;");
    SCM(playerid,COLOR_LIMEGREEN,"Spray, Headbutt, Pee, Koface, Kostomach, Kiss, Rollfall, Lay2, Hitch;");
    SCM(playerid,COLOR_LIMEGREEN,"Beach, Medic, Scratch, Sit, Drunk, Bomb, Getarrested, Laugh, Lookout;");
    SCM(playerid,COLOR_LIMEGREEN,"Aim, Crossarms, Lay, Hide, Vomit, Eating, Wave, Shouting, Chant;");
    SCM(playerid,COLOR_LIMEGREEN,"Frisked, Exhausted, Injured, Slapass, Deal, Dealstance, Crack, Wank, Gro;");
    SCM(playerid,COLOR_LIMEGREEN,"Sit, Chat, Fucku, Taichi, Knife, Basket, JumpWater.");
    return true;
}

YCMD:carhand(playerid, params[], help) {
    if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    ApplyAnimation(playerid,"CAR","Tap_hand",4.1,0,1,1 ,1,1);
	return true;
}
YCMD:lifejump(playerid, params[], help) {
    if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	LoopingAnim(playerid,"PED","EV_dive",4.0,0,1,1,1,0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:robman(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
 	LoopingAnim(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0);
 	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:exhaust(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	LoopingAnim(playerid,"PED","IDLE_tired",3.0,1,0,0,0,0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:rcarjack1(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	OnePlayAnim(playerid,"PED","CAR_pulloutL_LHS",4.0,0,0,0,0,0);
	return true;
}
YCMD:lcarjack1(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
 	OnePlayAnim(playerid,"PED","CAR_pulloutL_RHS",4.0,0,0,0,0,0);
	return true;
}
YCMD:rcarjack2(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
 	OnePlayAnim(playerid,"PED","CAR_pullout_LHS",4.0,0,0,0,0,0);
	return true;
}
YCMD:lcarjack2(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
 	OnePlayAnim(playerid,"PED","CAR_pullout_RHS",4.0,0,0,0,0,0);
	return true;
}
YCMD:hoodfrisked(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
 	LoopingAnim(playerid,"POLICE","crm_drgbst_01",4.0,0,1,1,1,0);
 	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:lightcig(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
 	OnePlayAnim(playerid,"SMOKING","M_smk_in",3.0,0,0,0,0,0);
	return true;
}
YCMD:tapcig(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
 	OnePlayAnim(playerid,"SMOKING","M_smk_tap",3.0,0,0,0,0,0);
	return true;
}
YCMD:bat(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
 	LoopingAnim(playerid,"BASEBALL","Bat_IDLE",4.0,1,1,1,1,0);
 	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:lean(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    extract params -> new test; else return sendPlayerSyntax(playerid, "/lean <1-2>");
    switch (test)
    {
	    case 1: {
	    	LoopingAnim(playerid,"GANGS","leanIDLE",4.0,0,1,1,1,0);
	    	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	    }
	    case 2: {
	    	LoopingAnim(playerid,"MISC","Plyrlean_loop",4.0,0,1,1,1,0);
	    	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	    }
	    default: sendPlayerSyntax(playerid, "/lean <1-2>");
	}
	return true;
}
YCMD:clearanim(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 1.0, 0, 0, 0, 0, 0);
	return true;
}
YCMD:dancing(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	extract params -> new test; else return sendPlayerSyntax(playerid, "/dancing <1-7>");
   	switch (test) {
	    case 1: {
	    	LoopingAnim(playerid,"STRIP", "strip_A", 4.1, 1, 1, 1, 1, 1 );
	    	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	    }
        case 2: {
        	LoopingAnim(playerid,"STRIP", "strip_B", 4.1, 1, 1, 1, 1, 1 );
        	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
        }
     	case 3: {
     		LoopingAnim(playerid,"STRIP", "strip_C", 4.1, 1, 1, 1, 1, 1 );
     		if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
     	}
    	case 4: {
    		LoopingAnim(playerid,"STRIP", "strip_D", 4.1, 1, 1, 1, 1, 1 );
    		if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
    	}
    	case 5: {
    		LoopingAnim(playerid,"STRIP", "strip_E", 4.1, 1, 1, 1, 1, 1 );
    		if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
    	}
    	case 6: {
    		LoopingAnim(playerid,"STRIP", "strip_F", 4.1, 1, 1, 1, 1, 1 );
    		if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
    	}
     	case 7: {
     		LoopingAnim(playerid,"STRIP", "strip_G", 4.1, 1, 1, 1, 1, 1 );
     		if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
     	}
     	default: sendPlayerSyntax(playerid, "/dancing <1-7>");
	}
	return true;
}
YCMD:box(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
 	LoopingAnim(playerid,"GYMNASIUM","GYMshadowbox",4.0,1,1,1,1,0);
 	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:lowthrow(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	OnePlayAnim(playerid,"GRENADE","WEAPON_throwu",3.0,0,0,0,0,0);
	return true;
}
YCMD:highthrow(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
 	OnePlayAnim(playerid,"GRENADE","WEAPON_throw",4.0,0,0,0,0,0);
	return true;
}
YCMD:leftslap(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	OnePlayAnim(playerid,"PED","BIKE_elbowL",4.0,0,0,0,0,0);
	return true;
}
YCMD:handsup(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	if(playerInfo[playerid][pFreezed] == 1) return true;
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
	return true;
}
YCMD:fall(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	LoopingAnim(playerid,"PED","KO_skid_front",4.1,0,1,1,1,0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1;
	return true;
}
YCMD:fallback(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    LoopingAnim(playerid, "PED","FLOOR_hit_f", 4.0, 1, 0, 0, 0, 0);
    if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1;
    return true;
}
YCMD:laugh(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
 	OnePlayAnim(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0);
	return true;
}
YCMD:lookout(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    OnePlayAnim(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0);
	return true;
}
YCMD:aim(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    LoopingAnim(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1;
	return true;
}
YCMD:crossarms(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    LoopingAnim(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1;
	return true;
}
YCMD:lay(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
 	LoopingAnim(playerid,"BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1;
	return true;
}
YCMD:hide(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
 	LoopingAnim(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:vomit(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
 	OnePlayAnim(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0);
	return true;
}
YCMD:wave(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    LoopingAnim(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1;
	return true;
}
YCMD:shouting(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    LoopingAnim(playerid,"RIOT","RIOT_shout",4.0,1,0,0,0,0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1;
	return true;
}
YCMD:chant(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    LoopingAnim(playerid,"RIOT","RIOT_CHANT",4.0,1,1,1,1,0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1;
	return true;
}
YCMD:frisked(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    LoopingAnim(playerid,"POLICE","crm_drgbst_01",4.0,0,1,1,1,0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1;    
	return true;

}
YCMD:exhausted(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    LoopingAnim(playerid,"PED","IDLE_tired",3.0,1,0,0,0,0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1;
	return true;
}
YCMD:injured(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    LoopingAnim(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1;
	return true;
}
YCMD:slapass(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    OnePlayAnim(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0);
	return true;
}
YCMD:deal(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    OnePlayAnim(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
	return true;
}
YCMD:dealstance(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    LoopingAnim(playerid,"DEALER","DEALER_IDLE",4.0,1,0,0,0,0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1;
	return true;
}
YCMD:crack(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    LoopingAnim(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1;    
	return true;
}
YCMD:wank(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    LoopingAnim(playerid,"PAULNMAC", "wank_loop", 1.800001, 1, 0, 0, 1, 600);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1;
	return true;
}
YCMD:salute(playerid, params[], help) {
    if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    ApplyAnimation(playerid, "ON_LOOKERS", "Pointup_loop", 4.0, 1, 0, 0, 0, 0, 1);
    return true;
}
YCMD:gro(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
 	LoopingAnim(playerid,"BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:sup(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    extract params -> new test; else return sendPlayerSyntax(playerid, "/sup <1-3>");
	switch (test)
  	{
    	case 1: OnePlayAnim(playerid,"GANGS","hndshkba",4.0,0,0,0,0,0);
     	case 2: OnePlayAnim(playerid,"GANGS","hndshkda",4.0,0,0,0,0,0);
     	case 3: OnePlayAnim(playerid,"GANGS","hndshkfa_swt",4.0,0,0,0,0,0);
    	default: sendPlayerSyntax(playerid, "/sup <1-3>");
	}
    return true;
}
YCMD:rap(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    extract params -> new test; else return sendPlayerSyntax(playerid, "/rap <1-4>");
	switch (test)
	{
	    case 1: {
	    	LoopingAnim(playerid,"RAPPING","RAP_A_Loop",4.0,1,0,0,0,0);
	    	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
    	}
    	case 2: {
    		LoopingAnim(playerid,"RAPPING","RAP_C_Loop",4.0,1,0,0,0,0);
    		if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
    	}
    	case 3: {
    		LoopingAnim(playerid,"GANGS","prtial_gngtlkD",4.0,1,0,0,0,0);
			if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
		}
     	case 4: {
     		LoopingAnim(playerid,"GANGS","prtial_gngtlkH",4.0,1,0,0,1,1);
			if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
		}
    	default: sendPlayerSyntax(playerid, "/rap <1-4>");
	}
    return true;
}
YCMD:push(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
 	OnePlayAnim(playerid,"GANGS","shake_cara",4.0,0,0,0,0,0);
	return true;
}
YCMD:akick(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	OnePlayAnim(playerid,"POLICE","Door_Kick",4.0,0,0,0,0,0);
	return true;
}
YCMD:lowbodypush(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	OnePlayAnim(playerid,"GANGS","shake_carSH",4.0,0,0,0,0,0);
	return true;
}
YCMD:headbutt(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	OnePlayAnim(playerid,"WAYFARER","WF_Fwd",4.0,0,0,0,0,0);
	return true;
}
YCMD:pee(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	if(playerInfo[playerid][pFreezed] == 1) return true;
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_PISSING);
	return true;
}
YCMD:koface(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	LoopingAnim(playerid,"PED","KO_shot_face",4.0,0,1,1,1,0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:kostomach(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	LoopingAnim(playerid,"PED","KO_shot_stom",4.0,0,1,1,1,0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:kiss(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	LoopingAnim(playerid,"KISSING", "Grlfrd_Kiss_02", 1.800001, 1, 0, 0, 1, 600);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:rollfall(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	LoopingAnim(playerid,"PED","BIKE_fallR",4.0,0,1,1,1,0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:lay2(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	LoopingAnim(playerid,"SUNBATHE","Lay_Bac_in",3.0,0,1,1,1,0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 		
	return true;
}
YCMD:hitch(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	LoopingAnim(playerid,"MISC","Hiker_Pose", 4.0, 1, 0, 0, 0, 0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:beach(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	LoopingAnim(playerid,"BEACH","SitnWait_loop_W",4.1,0,1,1,1,1);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:medic(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	LoopingAnim(playerid,"MEDIC","CPR",4.1,0,1,1,1,1);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:scratch(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	LoopingAnim(playerid,"MISC","Scratchballs_01", 4.0, 1, 0, 0, 0, 0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:sit(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	LoopingAnim(playerid,"PED","SEAT_idle", 4.0, 1, 0, 0, 0, 0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 		
	return true;
}
YCMD:drunk(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	LoopingAnim(playerid,"PED","WALK_DRUNK",4.0,1,1,1,1,0);
	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:bomb(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
   	ClearAnimations(playerid);
   	OnePlayAnim(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
	return true;
}
YCMD:getarrested(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    LoopingAnim(playerid,"ped", "ARRESTgun", 4.0, 0, 1, 1, 1, -1);
    if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:chat(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    OnePlayAnim(playerid,"PED","IDLE_CHAT",4.0,0,0,0,0,0);
	return true;
}
YCMD:fucku(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    OnePlayAnim(playerid,"PED","fucku",4.0,0,0,0,0,0);
	return true;
}
YCMD:taichi(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    LoopingAnim(playerid,"PARK","Tai_Chi_Loop",4.0,1,0,0,0,0);
    if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	return true;
}
YCMD:knife(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
    extract params -> new test; else return sendPlayerSyntax(playerid, "/knife <1-4>");
	switch (test)
	{
	    case 1: {
	    	LoopingAnim(playerid,"KNIFE","KILL_Knife_Ped_Damage",4.0,0,1,1,1,0);
	    	if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
	    }
     	case 2: {
     		LoopingAnim(playerid,"KNIFE","KILL_Knife_Ped_Die",4.0,0,1,1,1,0);
     		if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
     	}
      	case 3: OnePlayAnim(playerid,"KNIFE","KILL_Knife_Player",4.0,0,0,0,0,0);
     	case 4: {
     		LoopingAnim(playerid,"KNIFE","KILL_Partial",4.0,0,1,1,1,1);
     		if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
     	}
    	default: sendPlayerSyntax(playerid, "/knife <1-4>");
	}
	return true;
}
YCMD:basket(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Nu poti folosi animatii in timp ce esti intr-un vehicul.");
	extract params -> new test; else return sendPlayerSyntax(playerid, "/basket <1-6>");
	switch (test)
 	{
    	case 1: {
    		LoopingAnim(playerid,"BSKTBALL","BBALL_idleloop",4.0,1,0,0,0,0); 
    		if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
    	}
    	case 2: OnePlayAnim(playerid,"BSKTBALL","BBALL_Jump_Shot",4.0,0,0,0,0,0);
     	case 3: OnePlayAnim(playerid,"BSKTBALL","BBALL_pickup",4.0,0,0,0,0,0);
     	case 4: {
     		LoopingAnim(playerid,"BSKTBALL","BBALL_run",4.1,1,1,1,1,1); 
     		if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
     	}
    	case 5: {
    		LoopingAnim(playerid,"BSKTBALL","BBALL_def_loop",4.0,1,0,0,0,0); 
    		if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
    	}
       	case 6: {
       		LoopingAnim(playerid,"BSKTBALL","BBALL_Dnk",4.0,1,0,0,0,0); 
       		if(!playerInfo[playerid][pAnimLooping]) playerInfo[playerid][pAnimLooping] = 1; 	
       	}
    	default: sendPlayerSyntax(playerid, "/basket <1-6>");
	}
	return true;
}
YCMD:dance(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid, COLOR_GREY, "Nu poti folosi animatia aceasta atata timp cat esti intr-un vehicul.");
	extract params -> new test; else return sendPlayerSyntax(playerid, "/dance <1-4>");
	switch(test) {
		case 1: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE1);
		case 2: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE2);
		case 3: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE3);
		case 4: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE4);
		default: sendPlayerSyntax(playerid, "/dance <1-4>");
	}
	return true;
}
YCMD:jumpwater(playerid, params[], help) {
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid, COLOR_GREY, "Nu poti folosi animatia aceasta atata timp cat esti intr-un vehicul.");
    ApplyAnimation(playerid,"DAM_JUMP","DAM_LAUNCH",2,0,1,1,0,0);
	return true;
}

YCMD:quests(playerid, params[], help) {
	new status1[45], status2[45];
	if(playerInfo[playerid][pProgress][0] >= getNeedProgress(playerid, 0)) format(status1, sizeof(status1), "Misiune terminata");
	else format(status1, sizeof(status1), "%d/%d", playerInfo[playerid][pProgress][0], getNeedProgress(playerid, 0));
	if(playerInfo[playerid][pProgress][1] >= getNeedProgress(playerid, 1)) format(status2, sizeof(status2), "Misiune terminata");
	else format(status2, sizeof(status2), "%d/%d", playerInfo[playerid][pProgress][1], getNeedProgress(playerid, 1));
	SCM(playerid, COLOR_ORANGE, "--> Daily Missions <--");
	SCM(playerid, COLOR_ORANGE, string_fast("* -> (1) '%s' (Progres: %s).", missionName(playerid, playerInfo[playerid][pDailyMission][0], 0), status1));
	SCM(playerid, COLOR_ORANGE, string_fast("* -> (2) '%s' (Progres: %s).",  missionName(playerid, playerInfo[playerid][pDailyMission][1], 1), status2));
	return true;
}

YCMD:wthelp(playerid, params[], help) {
	if(playerInfo[playerid][pWTalkie] == 0) return sendPlayerError(playerid, "Nu ai un walkie talkie.");
	SCM(playerid,COLOR_GREY,"* Walkie Talkie: /setfreq /wt /freqmembers.");
	return true;
}

YCMD:setfreq(playerid, params[], help) {	
	if(playerInfo[playerid][pWTalkie] == 0) return sendPlayerError(playerid, "Nu ai un walkie talkie.");
	extract params -> new freq; else return sendPlayerSyntax(playerid, "/setfreq <freq>");
	if(freq < 0 || freq > 10) return sendPlayerError(playerid, "Frecvente disponibile: 1-10.");
	if(playerInfo[playerid][pWToggle] == 1) return sendPlayerError(playerid, "Statia ta a fost oprita. Foloseste comanda /tog pentru a o activa.");
	if(playerInfo[playerid][pWTChannel] == freq) return sendPlayerError(playerid, "Esti deja in aceasta frecventa.");
	if(freq == 0) {
		SCM(playerid, COLOR_GREY, "* Freq: Ai inchis frecventa.");
		return true;
	}
	playerInfo[playerid][pWTChannel] = freq;
	Iter_Add(Freqs[freq], playerid);
	update("UPDATE `server_users` SET `WTChannel` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pWTChannel], playerInfo[playerid][pSQLID]);		
    SCM(playerid, COLOR_LIGHTBLUE, string_fast("* Freq: Ai intrat pe frecventa %d.", freq));
	return true;
}

YCMD:wt(playerid, params[], help) {
	if(playerInfo[playerid][pWTalkie] == 0) return sendPlayerError(playerid, "Nu ai un walkie talkie.");
	if(playerInfo[playerid][pMute] > 0) return sendPlayerError(playerid, "Nu poti folosi aceasta comanda, deoarece ai mute inca %d secunde.", playerInfo[playerid][pMute]);
    extract params -> new string:msg[128];
    if(faceReclama(msg)) return removeFunction(playerid, msg);
    if(faceReclama(msg)) return Reclama(playerid, msg);
    if(strlen(msg) < 1 || strlen(msg) > 128) return sendPlayerError(playerid, "Mesaj invalid. Minim 1 caracter, maxim 128 caractere.");
	if(playerInfo[playerid][pWToggle] == 1) return sendPlayerError(playerid, "Statia ta a fost oprita. Foloseste comanda /tog pentru a o activa.");
	if(playerInfo[playerid][pWTChannel] == 0) return sendPlayerError(playerid, "Nu esti pe o frecventa.");
	foreach(new i : Freqs[playerInfo[playerid][pWTChannel]]) SCM(i, COLOR_FREQ, string_fast("[FREQ %d] %s: %s", playerInfo[playerid][pWTChannel], getName(playerid), msg));
	return true;
}

YCMD:freqmembers(playerid, params[], help) {
	if(playerInfo[playerid][pWTalkie] == 0) return sendPlayerError(playerid, "Nu ai un walkie talkie.");
	if(playerInfo[playerid][pWTChannel] == 0) return sendPlayerError(playerid, "Nu esti pe o frecventa.");
	if(Iter_Count(Freqs[playerInfo[playerid][pWTChannel]]) == 0) return sendPlayerError(playerid, "Nu sunt jucatori pe aceasta frecventa.");
	SCM(playerid, COLOR_FREQ, string_fast("* Jucatori pe frecventa %d", playerInfo[playerid][pWTChannel]));
	foreach(new i : Freqs[playerInfo[playerid][pWTChannel]]) {
		SCM(playerid, COLOR_FREQ, string_fast("* -> %s (%d)", getName(i), i));
	}
	SCM(playerid, COLOR_FREQ, string_fast("* Au fost gasiti %d jucatori pe aceasta frecventa.", Iter_Count(Freqs[playerInfo[playerid][pWTChannel]])));	
	return true;
}

YCMD:tog(playerid, params[], help) {
	gString[0] = (EOS);
	strcat(gString, "Function\tStatus\n");
	strcat(gString, playerInfo[playerid][pLiveToggle] ? "Live Conversation\t{3BBF0B}Enabled\n" : "Live Conversation\t{FF0000}Disabled\n");
	Dialog_Show(playerid, TOG, DIALOG_STYLE_TABLIST_HEADERS, "Tog Option", gString, "Select", "Close");
	return true;
}

YCMD:finalquest(playerid, params[], help) {
	if(!isPlayerLogged(playerid)) return sendPlayerError(playerid, "Nu esti logat, pentru a folosi aceasta comanda.");
	if(IsPlayerInRangeOfPoint(playerid, 50, -2304.2849,-1663.8442,483.6583)) {
		for(new m; m < 2; m++) {
			if(playerInfo[playerid][pDailyMission][m] == 2) checkMission(playerid, m);
		}	
	}
	if(IsPlayerInRangeOfPoint(playerid, 50, 1503.3143,2218.4546,10.8203)) {
		for(new m; m < 2; m++) {
			if(playerInfo[playerid][pDailyMission][m] == 3) checkMission(playerid, m);
		}	
	}
	if(IsPlayerInRangeOfPoint(playerid, 50, 2615.9443,-2403.4568,13.5256)) {
		for(new m; m < 2; m++) {
			if(playerInfo[playerid][pDailyMission][m] == 4) checkMission(playerid, m);
		}	
	}	
	if(IsPlayerInRangeOfPoint(playerid, 50, 1797.5958,842.8816,10.6328)) {
		for(new m; m < 2; m++) {
			if(playerInfo[playerid][pDailyMission][m] == 5) checkMission(playerid, m);
		}	
	}
	return true;
}
