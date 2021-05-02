#include <YSI\y_hooks>
new 
vbase[1][0] = { {1086} },
hydraulics[1][0] = { {1087} },
bventr[2][0] = { {1142},{1144} },
bventl[2][0] = { {1143},{1145} },
fbbars[2][0] = { {1115},{1116} },
vlights[2][0] = { {1013},{1024} },
nitro[3][0] = { {1008},{1009},{1010} },
bscoop[4][0] = { {1004},{1005},{1011},{1012} },
rbbars[4][0] = { {1109},{1110},{1123},{1125} },
rscoop[17][0] = { {1006},{1032},{1033},{1035},{1038},{1053},{1054},{1055},{1061},{1067},{1068},{1088},{1091},{1103},{1128},{1130},{1131} },
wheels[17][0] = { {1025},{1073},{1074},{1075},{1076},{1077},{1078},{1079},{1080},{1081},{1082},{1083},{1084},{1085},{1096},{1097},{1098} },
lskirt[21][0] = { {1007},{1026},{1031},{1036},{1039},{1042},{1047},{1048},{1056},{1057},{1069},{1070},{1090},{1093},{1106},{1108},{1118},{1119},{1133},{1122},{1134} },
rskirt[21][0] = { {1017},{1027},{1030},{1040},{1041},{1051},{1052},{1062},{1063},{1071},{1072},{1094},{1095},{1099},{1101},{1102},{1107},{1120},{1121},{1124},{1137} },
rbumper[22][0] = { {1140},{1141},{1148},{1149},{1150},{1151},{1154},{1156},{1159},{1161},{1166},{1168},{1176},{1177},{1178},{1180},{1183},{1184},{1186},{1187},{1190},{1191} },
spoiler[20][0] = { {1000}, {1001}, {1002}, {1003},{1014}, {1015}, {1016}, {1023},{1058}, {1060}, {1049}, {1050},{1138}, {1139}, {1146}, {1147},{1158}, {1162}, {1163}, {1164} },
fbumper[23][0] = { {1117},{1152},{1153},{1155},{1157},{1160},{1165},{1167},{1169},{1170},{1171},{1172},{1173},{1174},{1175},{1179},{1181},{1182},{1185},{1188},{1189},{1192},{1193} },
exhaust[28][0] = { {1018},{1019},{1020},{1021},{1022},{1028},{1029},{1037},{1043},{1044},{1045},{1046},{1059},{1064},{1065},{1066},{1089},{1092},{1104},{1105},{1113},{1114},{1126},{1127},{1129},{1132},{1135},{1136} },
Float:DebugVehicles[5][4] = { {1404.7991, -2242.4053, 13.2740, 179.9745},{1408.0391, -2241.7424, 13.2739, 180.7533},{1411.2999, -2241.6965, 13.2740, 179.8135},{1414.5262, -2241.7778, 13.2740, 179.0950},{1401.4760, -2242.2036, 13.2740, 179.6247} };

enum personalVehicleEnum {
	pvID,
	pvModelID,
	pvOwnerID,
	pvColorOne,
	pvColorTwo,
	Float:pvX,
	Float:pvY,
	Float:pvZ,
	Float:pvAngle,
	Float:pvOdometer,
	Float:pvFuel,
	Float:pvHealth,
	pvAge,
	pvCarPlate[32],
	pvComponents[17],
	pvInsurancePoints,
	pvLock,
	pvVirtualWorld,
	pvInterior,
	pvDamagePanels,
	pvDamageDoors,
	pvDamageLights,
	pvDamageTires,
	pvPaintJob,

	pvSpawnedID,
	pvDespawnTime
};
new personalVehicle[MAX_PLAYERS_PERSONAL_VEHICLES][personalVehicleEnum], Iterator:TotalPlayerVehicles<MAX_PLAYERS_PERSONAL_VEHICLES>,
    Iterator:PlayerVehicles[MAX_PLAYERS]<MAX_PLAYER_PERSONAL_VEHICLES>;

function LoadPersonalVehicle(playerid) {
	if(!cache_num_rows()) return true;

	new id;
	gString[0] = (EOS);
	for(new i = 1; i < (cache_num_rows() + 1); i++) {
		id = Iter_Free(TotalPlayerVehicles);

		cache_get_value_name_int(i - 1, "ID", personalVehicle[id][pvID]);
		cache_get_value_name_int(i - 1, "ModelID", personalVehicle[id][pvModelID]);
		cache_get_value_name_int(i - 1, "OwnerID", personalVehicle[id][pvOwnerID]);
		cache_get_value_name_int(i - 1, "ColorOne", personalVehicle[id][pvColorOne]);
		cache_get_value_name_int(i - 1, "ColorTwo", personalVehicle[id][pvColorTwo]);
		cache_get_value_name_float(i - 1, "X", personalVehicle[id][pvX]);
		cache_get_value_name_float(i - 1, "Y", personalVehicle[id][pvY]);
		cache_get_value_name_float(i - 1, "Z", personalVehicle[id][pvZ]);
		cache_get_value_name_float(i - 1, "Angle", personalVehicle[id][pvAngle]);
		cache_get_value_name_float(i - 1, "Odometer", personalVehicle[id][pvOdometer]);
		cache_get_value_name_float(i - 1, "Fuel", personalVehicle[id][pvFuel]);
		cache_get_value_name_float(i - 1, "Health", personalVehicle[id][pvHealth]);
		cache_get_value_name_int(i - 1, "Age", personalVehicle[id][pvAge]);
		cache_get_value_name_int(i - 1, "InsurancePoints", personalVehicle[id][pvInsurancePoints]);
		cache_get_value_name_int(i - 1, "LockStatus", personalVehicle[id][pvLock]);
		cache_get_value_name_int(i - 1, "VirtualWorld", personalVehicle[id][pvVirtualWorld]);
		cache_get_value_name_int(i - 1, "Interior",personalVehicle[id][pvInterior]);
		cache_get_value_name_int(i - 1, "DamagePanels", personalVehicle[id][pvDamagePanels]);
		cache_get_value_name_int(i - 1, "DamageDoors", personalVehicle[id][pvDamageDoors]);
		cache_get_value_name_int(i - 1, "DamageLights", personalVehicle[id][pvDamageLights]);
		cache_get_value_name_int(i - 1, "DamageTires", personalVehicle[id][pvDamageTires]);
		cache_get_value_name_int(i - 1, "PaintJob", personalVehicle[id][pvPaintJob]);
		
		personalVehicle[id][pvSpawnedID] = INVALID_VEHICLE_ID;
		personalVehicle[id][pvDespawnTime] = 0;

		cache_get_value_name(i - 1, "CarPlate", personalVehicle[id][pvCarPlate], 12);
		cache_get_value_name(i - 1, "Components", gString, 64);
		sscanf(gString, "p<|>ddddddddddddddddd", personalVehicle[id][pvComponents][0],  personalVehicle[id][pvComponents][1],  personalVehicle[id][pvComponents][2],  personalVehicle[id][pvComponents][3],  personalVehicle[id][pvComponents][4],
			   personalVehicle[id][pvComponents][5],  personalVehicle[id][pvComponents][6],  personalVehicle[id][pvComponents][7],  personalVehicle[id][pvComponents][8],  personalVehicle[id][pvComponents][9], personalVehicle[id][pvComponents][10],
			   personalVehicle[id][pvComponents][11],  personalVehicle[id][pvComponents][12],  personalVehicle[id][pvComponents][13],  personalVehicle[id][pvComponents][14],  personalVehicle[id][pvComponents][15],  personalVehicle[id][pvComponents][16]);
		
		Iter_Add(TotalPlayerVehicles, id);
		Iter_Add(PlayerVehicles[playerid], id);
	}

	return printf("[ACCOUNT] %s loaded %d vehicles", getName(playerid), Iter_Count(PlayerVehicles[playerid]));
}


Dialog:MY_GARAGE(playerid, response, listitem) {
	if(!response) return true;
	SetPVarInt(playerid, "vehSelect", playerInfo[playerid][pSelectVehicle][listitem]);
	if(personalVehicle[playerInfo[playerid][pSelectVehicle][listitem]][pvSpawnedID] == INVALID_VEHICLE_ID) 
		return Dialog_Show(playerid, MY_GARAGE_DESPAWNED, DIALOG_STYLE_LIST, "SERVER: My Garage", "Informatii\nSpawneaza", "Select", "Close");

	return Dialog_Show(playerid, MY_GARAGE_SPAWNED, DIALOG_STYLE_LIST, "SERVER: My Garage", "Informatii\nLocalizeaza\nRemorcheaza\nDespawneaza\nDebugeaza", "Select", "Close");	
}

Dialog:MY_GARAGE_DESPAWNED(playerid, response, listitem) {
	if(!response) return true;
	new id = GetPVarInt(playerid, "vehSelect");
	if(!listitem) {
		gString[0] = (EOS);
		format(gString, sizeof(gString), "Model: %s (%d)\nColor One: %d\nColor Two: %d\nOdometer: %.02f\nAge: %d days\nInsurance Points: %d\nInsurance Price: $%s", getVehicleName(personalVehicle[id][pvModelID]), personalVehicle[id][pvModelID], personalVehicle[id][pvColorOne], personalVehicle[id][pvColorTwo], personalVehicle[id][pvOdometer], personalVehicle[id][pvAge], personalVehicle[id][pvInsurancePoints], formatNumber(getInsurancePrice(floatround(personalVehicle[id][pvOdometer]), personalVehicle[id][pvAge])));
		return Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "SERVER: Car Information", gString, "Close", "");
	}
	personalVehicle[id][pvSpawnedID] = CreateVehicle(personalVehicle[id][pvModelID], personalVehicle[id][pvX], personalVehicle[id][pvY], personalVehicle[id][pvZ], personalVehicle[id][pvAngle], personalVehicle[id][pvColorOne], personalVehicle[id][pvColorTwo], -1);
	SetVehicleVirtualWorld(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvVirtualWorld]);
	LinkVehicleToInterior(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvInterior]);
	SetVehicleHealth(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvHealth]);
	UpdateVehicleDamageStatus(personalVehicle[id][pvSpawnedID],personalVehicle[id][pvDamagePanels], personalVehicle[id][pvDamageDoors], personalVehicle[id][pvDamageLights], personalVehicle[id][pvDamageTires]);
	SetVehicleNumberPlate(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvCarPlate]);
	vehicle_fuel[personalVehicle[id][pvSpawnedID]] = personalVehicle[id][pvFuel];
	vehicle_personal[personalVehicle[id][pvSpawnedID]] = id;	
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(personalVehicle[id][pvSpawnedID], engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(personalVehicle[id][pvSpawnedID], engine, lights, alarm, personalVehicle[id][pvLock], bonnet, boot, objective);
	ModVehicle(personalVehicle[id][pvSpawnedID]);
	if(personalVehicle[id][pvPaintJob] > -1) {
		ChangeVehiclePaintjob(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvPaintJob]);
	}
	personalVehicle[id][pvDespawnTime] = (gettime() + 900);
	defer TimerCar(id);
	SCM(playerid, COLOR_BISQUE, string_fast("Vehiculul tau %s, a fost spawnat la locul sau de parcare.", getVehicleName(personalVehicle[id][pvModelID])));
	return true;
}

Dialog:MY_GARAGE_SPAWNED(playerid, response, listitem) {
	if(!response) return true;
	new id = GetPVarInt(playerid, "vehSelect");
	switch(listitem) {
		case 0: {
			gString[0] = (EOS);
			format(gString, sizeof(gString), "Model: %s (%d)\nColor One: %d\nColor Two: %d\nOdometer: %.02f\nAge: %d days\nInsurance Points: %d\nInsurance Price: $%s", getVehicleName(personalVehicle[id][pvModelID]), personalVehicle[id][pvModelID], personalVehicle[id][pvColorOne], personalVehicle[id][pvColorTwo], personalVehicle[id][pvOdometer], personalVehicle[id][pvAge], personalVehicle[id][pvInsurancePoints], formatNumber(getInsurancePrice(floatround(personalVehicle[id][pvOdometer]), personalVehicle[id][pvAge])));
			return Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "SERVER: Car Information", gString, "Close", "");		
		}
		case 1: {
			if(personalVehicle[id][pvSpawnedID] == INVALID_VEHICLE_ID) return sendPlayerError(playerid, "Vehiculul nu este spawnat.");
			if(playerInfo[playerid][pCheckpointID] != -1) return sendPlayerError(playerid, "Ai deja un checkpoint, pe mini map.");
			new Float:x, Float:y, Float:z;
			GetVehiclePos(personalVehicle[id][pvSpawnedID], x, y, z);
			new zone[32];
			Get3DZone(x, y, z, zone, 32);
			SCM(playerid, COLOR_BISQUE, string_fast("Vehiclul tau %s, a fost localizat in zona %s", getVehicleName(personalVehicle[id][pvModelID]), zone));
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_FINDCAR;
			playerInfo[playerid][pCheckpointID] = personalVehicle[id][pvSpawnedID];
			carFind[playerid] = repeat TimerCarFind(playerid);
			SetPlayerCheckpoint(playerid, x, y, z, 4.0);
		}
		case 2: {
			if(personalVehicle[id][pvSpawnedID] == INVALID_VEHICLE_ID) return sendPlayerError(playerid, "Vehiculul nu este spawnat.");
			if(getVehicleHealth(personalVehicle[id][pvSpawnedID]) < 250.1) return sendPlayerError(playerid, "Vehiculul este pe cale sa bubuie.");
			if(IsVehicleOccupied(personalVehicle[id][pvSpawnedID])) return sendPlayerError(playerid, "Vehiculul este ocupat in acest moment.");
			if(GetPlayerCash(playerid) < 1000) return sendPlayerError(playerid, "Nu ai $1,000 pentru a remorca vehiculul.");
			SetVehiclePos(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvX], personalVehicle[id][pvY], personalVehicle[id][pvZ]);
			SetVehicleVirtualWorld(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvVirtualWorld]);
			LinkVehicleToInterior(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvInterior]);
			vehicle_personal[personalVehicle[id][pvSpawnedID]] = id;
			personalVehicle[id][pvDespawnTime] = (gettime() + 900);
			defer TimerCar(id);
			GivePlayerCash(playerid, 0, 1000);
			update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d' WHERE `ID` = '%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSQLID]);
			SCM(playerid, COLOR_GREY, string_fast("Vehiculul tau %s, a fost remorcat pentru $1,000.", getVehicleName(personalVehicle[id][pvModelID])));
		}
		case 3: {
			if(personalVehicle[id][pvSpawnedID] == INVALID_VEHICLE_ID) return sendPlayerError(playerid, "Vehiculul nu este spawnat.");
			if(getVehicleHealth(personalVehicle[id][pvSpawnedID]) < 250.1) return sendPlayerError(playerid, "Vehiculul este pe cale sa bubuie.");
			if(IsVehicleOccupied(personalVehicle[id][pvSpawnedID])) return sendPlayerError(playerid, "Vehiculul este ocupat in acest moment.");
			personalVehicle[id][pvDespawnTime] = 0;
			vehicle_engine[personalVehicle[id][pvSpawnedID]] = false;
			vehicle_lights[personalVehicle[id][pvSpawnedID]] = false;
			vehicle_bonnet[personalVehicle[id][pvSpawnedID]] = false;
			vehicle_boot[personalVehicle[id][pvSpawnedID]] = false;	
			vehicle_fuel[personalVehicle[id][pvSpawnedID]] = 100.0;	
			vehicle_personal[personalVehicle[id][pvSpawnedID]] = -1;
			if(playerInfo[playerid][pCheckpoint] == CHECKPOINT_FINDCAR && playerInfo[playerid][pCheckpointID] == personalVehicle[id][pvSpawnedID]) {
				playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
				playerInfo[playerid][pCheckpointID] = -1;
				DisablePlayerCheckpoint(playerid);
				stop carFind[playerid];
			}
			GetVehicleHealth(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvHealth]);
			GetVehicleDamageStatus(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvDamagePanels], personalVehicle[id][pvDamageDoors], personalVehicle[id][pvDamageLights], personalVehicle[id][pvDamageTires]);
			gQuery[0] = (EOS);
			mysql_format(SQL, gQuery, sizeof(gQuery), "UPDATE `server_personal_vehicles` SET `Health` = '%f', `DamagePanels`='%d', `DamageDoors`='%d', `DamageLights`='%d', `DamageTires`='%d' WHERE `ID`='%d'", personalVehicle[id][pvHealth], personalVehicle[id][pvDamagePanels], personalVehicle[id][pvDamageDoors], personalVehicle[id][pvDamageLights], personalVehicle[id][pvDamageTires],personalVehicle[id][pvID]);
			mysql_tquery(SQL, gQuery, "", "");
			DestroyVehicle(personalVehicle[id][pvSpawnedID]);		
			personalVehicle[id][pvSpawnedID] =  INVALID_VEHICLE_ID;
			SCM(playerid, COLOR_GREY, string_fast("Vehiculul tau %s, a fost despawnat.", getVehicleName(personalVehicle[id][pvModelID])));
		}
		case 4: {
			if(personalVehicle[id][pvSpawnedID] == INVALID_VEHICLE_ID) return sendPlayerError(playerid, "Vehiculul nu este spawnat.");
			if(getVehicleHealth(personalVehicle[id][pvSpawnedID]) < 250.1) return sendPlayerError(playerid, "Vehiculul este pe cale sa bubuie.");
			if(IsVehicleOccupied(personalVehicle[id][pvSpawnedID])) return sendPlayerError(playerid, "Vehiculul este ocupat in acest moment.");
			if(playerInfo[playerid][pCheckpoint] != CHECKPOINT_NONE) return sendPlayerError(playerid, "Ai deja un checkpoint, pe mini map.");
			new Float:x, Float:y, Float:z;
			GetVehiclePos(personalVehicle[id][pvSpawnedID], x, y, z);		
			if(!IsPlayerInRangeOfPoint(playerid, 75.0, x, y, z)) return sendPlayerError(playerid, "Trebuie sa te afli la o distanta de 75m de vehicul.");	
			new rand = random(5);
			SetVehiclePos(personalVehicle[id][pvSpawnedID], DebugVehicles[rand][0], DebugVehicles[rand][1], DebugVehicles[rand][2]);
			SetVehicleZAngle(personalVehicle[id][pvSpawnedID], DebugVehicles[rand][3]);
			SetVehicleVirtualWorld(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvVirtualWorld]);
			LinkVehicleToInterior(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvInterior]);
			GetVehiclePos(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvX], personalVehicle[id][pvY], personalVehicle[id][pvZ]);
			GetVehicleZAngle(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvAngle]);
			personalVehicle[id][pvVirtualWorld] = 0;
			personalVehicle[id][pvInterior] = 0;
			update("UPDATE `server_personal_vehicles` SET `X` = '%f', `Y` = '%f', `Z` = '%f', `Angle` = '%f' WHERE `ID` = '%d'", personalVehicle[id][pvX], personalVehicle[id][pvY], personalVehicle[id][pvZ], personalVehicle[id][pvAngle], personalVehicle[id][pvID]);
			vehicle_personal[personalVehicle[id][pvSpawnedID]] = id;
			personalVehicle[id][pvDespawnTime] = (gettime() + 900);
			defer TimerCar(id);
			new zone[32];
			Get3DZone(DebugVehicles[rand][0], DebugVehicles[rand][1], DebugVehicles[rand][2], zone, 32);
			SCM(playerid, COLOR_BISQUE, string_fast("Vehiclul tau %s, a fost mutat in parcarea din zona %s", getVehicleName(personalVehicle[id][pvModelID]), zone));
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_FINDCAR;
			playerInfo[playerid][pCheckpointID] = personalVehicle[id][pvSpawnedID];
			carFind[playerid] = repeat TimerCarFind(playerid);
			SetPlayerCheckpoint(playerid, DebugVehicles[rand][0], DebugVehicles[rand][1], DebugVehicles[rand][2], 4.0);
		}
	}

	return true;
}

Dialog:BUY_INSURANCE(playerid, response) {
	if(!response) return true;
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !Iter_Contains(PlayerVehicles[playerid], vehicle_personal[GetPlayerVehicleID(playerid)])) return sendPlayerError(playerid, "Nu te afli intr-un vehicul.");
	new id = vehicle_personal[GetPlayerVehicleID(playerid)];
	if(GetPlayerCash(playerid) < getInsurancePrice(floatround(personalVehicle[id][pvOdometer]), personalVehicle[id][pvAge])) return sendPlayerError(playerid, "Nu ai $%s pentru a plati asigurarea.", formatNumber(getInsurancePrice(floatround(personalVehicle[id][pvOdometer]), personalVehicle[id][pvAge])));
	if(personalVehicle[id][pvInsurancePoints] >= 5) return sendPlayerError(playerid, "Vehiculul tau are deja mai mult sau egal cu 5 puncte de asigurare");
	personalVehicle[id][pvInsurancePoints] ++;
	update("UPDATE `server_personal_vehicles` SET `InsurancePoints` = '%d' WHERE `ID`='%d'", personalVehicle[id][pvInsurancePoints], personalVehicle[id][pvID]);
	SCM(playerid, COLOR_GREY, string_fast("* Notice Buy Insurance Points: Ai cumparat un punct de asigurare pentru $%s.", formatNumber(getInsurancePrice(floatround(personalVehicle[id][pvOdometer]), personalVehicle[id][pvAge]))));
    GivePlayerCash(playerid, 1, getInsurancePrice(floatround(personalVehicle[id][pvOdometer]), personalVehicle[id][pvAge]));
    update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d' WHERE `ID`='%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSQLID]);
	return true;
}

stock getVehicleOwner(id) {
	foreach(new i : loggedPlayers) {
		if(playerInfo[i][pSQLID] == id) {
			return i;
		}
	}
	return true;
}

stock ModVehicle(vehicleid) {
	if(IsValidVehicle(vehicleid)) {
		for(new i = 0; i < 17; i++) {
			if(personalVehicle[vehicle_personal[vehicleid]][pvComponents][i] > 0) {
				AddVehicleComponent(vehicleid, personalVehicle[vehicle_personal[vehicleid]][pvComponents][i]);
			}
		}
	}

	return true;
}

stock SaveComponent(vehicleid, componentid) {
	new id = vehicle_personal[vehicleid];
	for(new s=0; s<20; s++) {
		if(componentid == spoiler[s][0]) {
			personalVehicle[id][pvComponents][0] = componentid;
		}
	}
	for(new s=0; s<4; s++) {
		if(componentid == bscoop[s][0]) {
			personalVehicle[id][pvComponents][1] = componentid;
		}
	}
	for(new s=0; s<17; s++) {
		if(componentid == rscoop[s][0]) {
			personalVehicle[id][pvComponents][2] = componentid;
		}
	}
	for(new s=0; s<21; s++) {
		if(componentid == rskirt[s][0]) {
			personalVehicle[id][pvComponents][3] = componentid;
		}
	}
	for(new s=0; s<21; s++) {
		if(componentid == lskirt[s][0]) {
			personalVehicle[id][pvComponents][16] = componentid;
		}
	}
	for(new s=0; s<2; s++) {
		if(componentid == vlights[s][0]) {
			personalVehicle[id][pvComponents][4] = componentid;
		}
	}
	for(new s=0; s<3; s++) {
		if(componentid == nitro[s][0]) {
			personalVehicle[id][pvComponents][5] = componentid;
		}
	}
	for(new s=0; s<28; s++) {
		if(componentid == exhaust[s][0]) {
			personalVehicle[id][pvComponents][6] = componentid;
		}
	}
	for(new s=0; s<17; s++) {
		if(componentid == wheels[s][0]) {
			personalVehicle[id][pvComponents][7] = componentid;
		}
	}
	for(new s=0; s<1; s++) {
		if(componentid == vbase[s][0]) {
			personalVehicle[id][pvComponents][8] = componentid;
		}
	}
	for(new s=0; s<1; s++) {
		if(componentid == hydraulics[s][0]) {
			personalVehicle[id][pvComponents][9] = componentid;
		}
	}
	for(new s=0; s<23; s++) {
		if(componentid == fbumper[s][0]) {
			personalVehicle[id][pvComponents][10] = componentid;
		}
	}
	for(new s=0; s<22; s++) {
		if(componentid == rbumper[s][0]) {
			personalVehicle[id][pvComponents][11] = componentid;
		}
	}
	for(new s=0; s<2; s++) {
		if(componentid == bventr[s][0]) {
			personalVehicle[id][pvComponents][12] = componentid;
		}
	}
	for(new s=0; s<2; s++) {
		if(componentid == bventl[s][0]) {
			personalVehicle[id][pvComponents][13] = componentid;
		}
	}
	for(new s=0; s<2; s++) {
		if(componentid == fbbars[s][0]) {
			personalVehicle[id][pvComponents][15] = componentid;
		}
	}	
	for(new s=0; s<4; s++) {
		if(componentid == rbbars[s][0]) {
			personalVehicle[id][pvComponents][14] = componentid;
		}
	}
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof(gQuery), "UPDATE `server_personal_vehicles` SET `Components`='%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d' WHERE `ID`='%d'", 
		personalVehicle[id][pvComponents][0], personalVehicle[id][pvComponents][1], personalVehicle[id][pvComponents][2], personalVehicle[id][pvComponents][3], personalVehicle[id][pvComponents][4], personalVehicle[id][pvComponents][5], personalVehicle[id][pvComponents][6], personalVehicle[id][pvComponents][7], personalVehicle[id][pvComponents][8], 
		personalVehicle[id][pvComponents][9], personalVehicle[id][pvComponents][10], personalVehicle[id][pvComponents][11], personalVehicle[id][pvComponents][12], personalVehicle[id][pvComponents][13], personalVehicle[id][pvComponents][14], personalVehicle[id][pvComponents][15], personalVehicle[id][pvComponents][16], personalVehicle[id][pvID]);
	mysql_tquery(SQL, gQuery, "", "");
	return true;
}

stock getInsurancePrice(km, days) {
	return (days * 100) + (km / 100) + 100;
}


timer TimerCar[gettime() + 900](i) { 
	vehicle_engine[personalVehicle[i][pvSpawnedID]] = false;
	vehicle_lights[personalVehicle[i][pvSpawnedID]] = false;
	vehicle_bonnet[personalVehicle[i][pvSpawnedID]] = false;
	vehicle_boot[personalVehicle[i][pvSpawnedID]] = false;	
	vehicle_fuel[personalVehicle[i][pvSpawnedID]] = 100.0;	
	vehicle_personal[personalVehicle[i][pvSpawnedID]] = -1;
	new playerid = getVehicleOwner(personalVehicle[i][pvOwnerID]);
	if(playerInfo[playerid][pCheckpoint] == CHECKPOINT_FINDCAR && playerInfo[playerid][pCheckpointID] == personalVehicle[i][pvSpawnedID]) {
		playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
		playerInfo[playerid][pCheckpointID] = -1;
		DisablePlayerCheckpoint(playerid);
	}
	personalVehicle[i][pvDespawnTime] = 0;
	DestroyVehicle(personalVehicle[i][pvSpawnedID]);	
	personalVehicle[i][pvSpawnedID] = INVALID_VEHICLE_ID;
	GetVehicleHealth(personalVehicle[i][pvSpawnedID], personalVehicle[i][pvHealth]);
	GetVehicleDamageStatus(personalVehicle[i][pvSpawnedID], personalVehicle[i][pvDamagePanels], personalVehicle[i][pvDamageDoors], personalVehicle[i][pvDamageLights], personalVehicle[i][pvDamageTires]);
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof(gQuery), "UPDATE `server_personal_vehicles` SET `Health` = '%f', `DamagePanels`='%d', `DamageDoors`='%d', `DamageLights`='%d', `DamageTires`='%d' WHERE `ID`='%d", personalVehicle[i][pvHealth], personalVehicle[i][pvDamagePanels], personalVehicle[i][pvDamageDoors], personalVehicle[i][pvDamageLights], personalVehicle[i][pvDamageTires],personalVehicle[i][pvID]);
	mysql_tquery(SQL, gQuery, "", "");
	return true;
}

timer TimerSpeedo[1000](playerid) { 

	new vehicleid = GetPlayerVehicleID(playerid), Float:he;
	GetVehicleHealth(vehicleid, he);
	va_PlayerTextDrawSetString(playerid, vehicleHud[4], "%d", getVehicleSpeed(vehicleid));
	va_PlayerTextDrawSetString(playerid, vehicleHud[9], "%.1f%s", he/10, "%");
	va_PlayerTextDrawSetString(playerid, vehicleHud[12], "%d", getVehicleSpeed(vehicleid)/30);
	va_PlayerTextDrawSetString(playerid, vehicleHud[13], "Bunny manelistu'", he, "%");
	
	if(vehicle_fuel[vehicleid] > 0) {
		PlayerTextDrawLetterSize(playerid, vehicleHud[10], 0.000000, (-0.533344)+(-0.03644447*vehicle_fuel[vehicleid]));
		PlayerTextDrawShow(playerid, vehicleHud[10]);
	} else {
		new engine, lights, alarm, doors, bonnet, boot, objective;
		sendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "* %s a %s motorul unui %s", getName(playerid), (vehicle_engine[vehicleid]) ? ("oprit") : ("pornit"), getVehicleName(GetVehicleModel(vehicleid)));
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		SetVehicleParamsEx(GetPlayerVehicleID(playerid), VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
		vehicle_engine[GetPlayerVehicleID(playerid)] = false;	
	}
	if(vehicle_personal[vehicleid] > -1) {
		va_PlayerTextDrawSetString(playerid, vehicleHud[7], "%s", (personalVehicle[vehicle_personal[vehicleid]][pvLock]) ? ("~g~UNLOCKED") : ("~r~LOCKED"));
		va_PlayerTextDrawSetString(playerid, vehicleHud[8], "%.1f", personalVehicle[vehicle_personal[vehicleid]][pvOdometer]);
	}

	if(!isPlane(vehicleid) && !isBoat(vehicleid) && !isBike(vehicleid) && vehicle_engine[vehicleid] == true && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)  {
		new Float: fuel = 0.050, speed = getVehicleSpeed(vehicleid);
		if(speed >= 5) {
			fuel = (speed * 0.15) / 100;
		}
		vehicle_fuel[vehicleid] -= fuel;
		if(vehicle_personal[vehicleid] > -1) {
			new id = vehicle_personal[vehicleid];
			personalVehicle[id][pvFuel] -= fuel;
			personalVehicle[id][pvOdometer] += (fuel == 0.050) ? (0.0) : (fuel);
		}	
	}
	return true;
}

hook OnPlayerDisconnect(playerid, reason) {
	foreach(new i : PlayerVehicles[playerid]) {
		update("UPDATE `server_personal_vehicles` SET  `Health` = '%f', `Fuel` = '%f', `Odometer`='%f', `DamageDoors`='%d', `DamageLights`='%d', `DamageTires`='%d' WHERE `ID`='%d'", personalVehicle[i][pvHealth], personalVehicle[i][pvFuel], personalVehicle[i][pvOdometer], personalVehicle[i][pvDamagePanels], personalVehicle[i][pvDamageDoors], personalVehicle[i][pvDamageLights], personalVehicle[i][pvDamageTires],personalVehicle[i][pvID]);

		personalVehicle[i][pvID] = 0;
		personalVehicle[i][pvModelID] = 0;
		personalVehicle[i][pvOwnerID] = 0;
		personalVehicle[i][pvColorOne] = 0;
		personalVehicle[i][pvColorTwo] = 0;
		personalVehicle[i][pvX] = 0;
		personalVehicle[i][pvY] = 0;
		personalVehicle[i][pvZ] = 0;
		personalVehicle[i][pvAngle] = 0;
		personalVehicle[i][pvOdometer] = 0;
		personalVehicle[i][pvFuel] = 0;
		personalVehicle[i][pvAge] = 0;
		personalVehicle[i][pvInsurancePoints] = 0;
		personalVehicle[i][pvLock] = 0;
		personalVehicle[i][pvHealth] = 0.0;
		personalVehicle[i][pvVirtualWorld] = 0;
		personalVehicle[i][pvInterior] = 0;
		personalVehicle[i][pvDamagePanels] = 0;
		personalVehicle[i][pvDamageDoors] = 0;
		personalVehicle[i][pvDamageLights] = 0;
		personalVehicle[i][pvDamageTires] = 0;
		personalVehicle[i][pvCarPlate] = (EOS);
		personalVehicle[i][pvDespawnTime] = 0;

		for(new x = 0; x < 17; x++) {
			personalVehicle[i][pvComponents][x] = 0;
		}

		if(personalVehicle[i][pvSpawnedID] != INVALID_PLAYER_ID) {
			DestroyVehicle(personalVehicle[i][pvSpawnedID]);
			personalVehicle[i][pvSpawnedID] = INVALID_VEHICLE_ID;
		}

		Iter_Clear(TotalPlayerVehicles);
		Iter_Clear(PlayerVehicles[playerid]);
		break;
	}
	return true;
}

CMD:lock(playerid, params[]) {
	new vehicleid = INVALID_VEHICLE_ID;
	if(IsPlayerInAnyVehicle(playerid)) {
		vehicleid = GetPlayerVehicleID(playerid);	
	}
	else {
		vehicleid = GetClosestVehicle(playerid);
		if(IsValidVehicle(vehicleid)) return true;
		new Float:x, Float:y, Float:z;
		GetVehiclePos(vehicleid, x, y, z);
		if(!IsPlayerInRangeOfPoint(playerid, 7.5, x, y, z)) return true;
	}
	if(vehicle_personal[vehicleid] == -1) return sendPlayerError(playerid, "Acest vehicul nu este unul personal.");
	new engine, lights, alarm, doors, bonnet, boot, objective, id = vehicle_personal[vehicleid];
	if(personalVehicle[id][pvLock] == 0) {
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		SetVehicleParamsEx(vehicleid, engine, lights, alarm, VEHICLE_PARAMS_ON, bonnet, boot, objective);
		personalVehicle[id][pvLock] = 1;
		update("UPDATE `server_personal_vehicles` SET `LockStatus` = '1' WHERE `ID` = '%d'", personalVehicle[id][pvID]);
		GameTextForPlayer(playerid, string_fast("~w~%s~n~~r~INCUIAT", getVehicleName(personalVehicle[id][pvModelID])), 5000, 4);
		return true;
	}
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, engine, lights, alarm, VEHICLE_PARAMS_OFF, bonnet, boot, objective);
	personalVehicle[id][pvLock] = 0;
	update("UPDATE `server_personal_vehicles` SET `LockStatus` = '0' WHERE `ID` = '%d'", personalVehicle[id][pvID]);
	GameTextForPlayer(playerid, string_fast("~w~%s~n~~g~DESCUIAT", getVehicleName(personalVehicle[id][pvModelID])), 5000, 4);
	return true;
}

CMD:swapcolors(playerid, params[]) {
	if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !Iter_Contains(PlayerVehicles[playerid], vehicle_personal[GetPlayerVehicleID(playerid)])) return sendPlayerError(playerid, "Nu te afli intr-un vehicul.");
	if(GetPlayerCash(playerid) < 2000) return sendPlayerError(playerid, "Nu ai $2,000.");
	new id = vehicle_personal[GetPlayerVehicleID(playerid)], color = personalVehicle[id][pvColorOne];
	personalVehicle[id][pvColorOne] = personalVehicle[id][pvColorTwo];
	personalVehicle[id][pvColorTwo] = color;
	update("UPDATE `server_personal_vehicles` SET `ColorOne` = '%d', `ColorTwo` = '%d' WHERE `ID`='%d'", personalVehicle[id][pvColorOne], personalVehicle[id][pvColorTwo], personalVehicle[id][pvID]);
	ChangeVehicleColor(GetPlayerVehicleID(playerid), personalVehicle[id][pvColorOne], personalVehicle[id][pvColorTwo]);
	SCM(playerid, COLOR_GREY, "* Notice SwapColors: Ti-ai inversat culorile cu succes.");
	GivePlayerCash(playerid, 0, 1000);
	update("UPDATE `server_users` SET `Money` = '%d' `MStore` = '%d' WHERE `ID`='%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSQLID]);
	return true;
}

CMD:buyinsurance(playerid, params[]) {
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !Iter_Contains(PlayerVehicles[playerid], vehicle_personal[GetPlayerVehicleID(playerid)])) return sendPlayerError(playerid, "Nu te afli intr-un vehicul.");
	if(personalVehicle[vehicle_personal[GetPlayerVehicleID(playerid)]][pvInsurancePoints] >= 5) return sendPlayerError(playerid, "Vehiculul tau are deja mai mult sau egal cu 5 puncte de asigurare");
	Dialog_Show(playerid, BUY_INSURANCE, DIALOG_STYLE_MSGBOX, "SERVER: Buy Insurance", "Esti sigur ca doresti sa cumperi un punct de asigurare pentru $%s?", "Da", "Nu", formatNumber(getInsurancePrice(floatround(personalVehicle[vehicle_personal[GetPlayerVehicleID(playerid)]][pvOdometer]), personalVehicle[vehicle_personal[GetPlayerVehicleID(playerid)]][pvAge])));
	return true;
}

CMD:carplate(playerid, params[]) {
	if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !Iter_Contains(PlayerVehicles[playerid], vehicle_personal[GetPlayerVehicleID(playerid)])) return sendPlayerError(playerid, "Nu te afli intr-un vehicul.");
	if(isnull(params) || strlen(params) > 12) return sendPlayerSyntax(playerid, "/carplate <plate>");
	if(GetPlayerCash(playerid) < 4000) return sendPlayerError(playerid, "Nu ai $4,000.");
	new vehicleid = GetPlayerVehicleID(playerid);
	format(personalVehicle[vehicle_personal[vehicleid]][pvCarPlate], 12, params);
	update("UPDATE `server_personal_vehicles` SET `CarPlate` = '%s' WHERE `ID`='%d'", personalVehicle[vehicle_personal[vehicleid]][pvCarPlate], personalVehicle[vehicle_personal[vehicleid]][pvID]);
	SetVehicleNumberPlate(vehicleid, params);
	SCM(playerid, COLOR_GREY, string_fast("* Notice CarPlate: Numarul de inmatriculare este %s.", params));
	SCM(playerid, COLOR_GREY, "Acesta va fi vizibil dupa ce vehiculul va fi respawnat.");
	GivePlayerCash(playerid, 0, 4000);
	update("UPDATE `server_users` SET `Money` = '%d' `MStore` = '%d' WHERE `ID`='%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSQLID]);
	return true;
}

CMD:carcolor(playerid, params[]) {
	if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !Iter_Contains(PlayerVehicles[playerid], vehicle_personal[GetPlayerVehicleID(playerid)])) return sendPlayerError(playerid, "Nu te afli intr-un vehicul.");
	if(!Iter_Contains(PlayerVehicles[playerid], vehicle_personal[GetPlayerVehicleID(playerid)])) return sendPlayerError(playerid, "Acest vehicul nu iti apartine.");
	if(GetPlayerCash(playerid) < 2000) return sendPlayerError(playerid, "Nu ai $2,000.");
	new firstColor, secondColor;
	if(sscanf(params, "dd", firstColor, secondColor)) return sendPlayerSyntax(playerid, "/carcolor <first color> <second color>");
	if(firstColor < 0 || firstColor > 255) return sendPlayerError(playerid, "Culoarea principala, nu este valida.");
	if(secondColor < 0 || secondColor > 255) return sendPlayerError(playerid, "Culoarea secundara, nu este valida.");
	new id = vehicle_personal[GetPlayerVehicleID(playerid)];
	if(personalVehicle[id][pvColorOne] == firstColor) return sendPlayerError(playerid, "Culoarea principala este deja pe vehiculul tau.");
	if(personalVehicle[id][pvColorTwo] == secondColor) return sendPlayerError(playerid, "Culoarea secundara este deja pe vehiculul tau.");
	personalVehicle[id][pvColorOne] = firstColor;
	personalVehicle[id][pvColorTwo] = secondColor;
	update("UPDATE `server_personal_vehicles` SET `ColorOne` = '%d', `ColorTwo` = '%d' WHERE `ID`='%d'", firstColor, secondColor, personalVehicle[id][pvID]);
	ChangeVehicleColor(personalVehicle[id][pvSpawnedID], firstColor, secondColor);
	SCM(playerid, COLOR_GREY, "* Notice Car Color: Culorile au fost actualizate.");
	GivePlayerCash(playerid, 0, 2000);
	update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d' WHERE `ID`='%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSQLID]);
	return true;
}

CMD:park(playerid, params[]) {
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return sendPlayerError(playerid, "Nu te afli intr-un vehicul ca sofer.");
	if(IsPlayerInRangeOfPoint(playerid, 50.0, 1310.1444, -1369.5681, 13.5640)) return sendPlayerError(playerid, "Nu poti parca masina in zona spawnului.");
	new vehicleid = GetPlayerVehicleID(playerid);
	if(getVehicleSpeed(vehicleid)) return sendPlayerError(playerid, "Nu poti parca un vehicul ce se afla in deplasare.");
	if(vehicle_personal[vehicleid] == -1) return sendPlayerError(playerid, "Nu te afli intr-un vehicul personal.");
	new id = vehicle_personal[vehicleid];
	if(personalVehicle[id][pvOwnerID] != playerInfo[playerid][pSQLID])  return sendPlayerError(playerid, "Acest vehicul nu iti apartine.");
	GetVehicleHealth(vehicleid, personalVehicle[id][pvHealth]);
	if(personalVehicle[id][pvHealth] < 400.0) return sendPlayerError(playerid, "Acest vehicul este prea avariat.");
	GetVehicleDamageStatus(vehicleid, personalVehicle[id][pvDamagePanels], personalVehicle[id][pvDamageDoors], personalVehicle[id][pvDamageLights], personalVehicle[id][pvDamageTires]);
	GetVehiclePos(vehicleid, personalVehicle[id][pvX], personalVehicle[id][pvY], personalVehicle[id][pvZ]);
	GetVehicleZAngle(vehicleid, personalVehicle[id][pvAngle]);
	#pragma unused vehicleid
	personalVehicle[id][pvVirtualWorld] = GetPlayerVirtualWorld(playerid);
	personalVehicle[id][pvInterior] = GetPlayerInterior(playerid);
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof(gQuery), "UPDATE `server_personal_vehicles` SET `DamagePanels`='%d', `DamageDoors`='%d', `DamageLights`='%d', `DamageTires`='%d', `X` ='%f', `Y`='%f', `Z`='%f', `Angle`='%f', `VirtualWorld`='%d', `Interior`='%d' WHERE `ID`='%d'",
	personalVehicle[id][pvDamagePanels], personalVehicle[id][pvDamageDoors], personalVehicle[id][pvDamageLights], personalVehicle[id][pvDamageTires], personalVehicle[id][pvX], personalVehicle[id][pvY], personalVehicle[id][pvZ],
	personalVehicle[id][pvAngle], personalVehicle[id][pvVirtualWorld], personalVehicle[id][pvInterior], personalVehicle[id][pvID]);
	mysql_tquery(SQL, gQuery, "", "");
	vehicle_engine[personalVehicle[id][pvSpawnedID]] = false;
	vehicle_lights[personalVehicle[id][pvSpawnedID]] = false;
	vehicle_bonnet[personalVehicle[id][pvSpawnedID]] = false;
	vehicle_boot[personalVehicle[id][pvSpawnedID]] = false;	
	vehicle_fuel[personalVehicle[id][pvSpawnedID]] = 100.0;	
	vehicle_personal[personalVehicle[id][pvSpawnedID]] = -1;
	personalVehicle[id][pvDespawnTime] = 0;
	DestroyVehicle(personalVehicle[id][pvSpawnedID]);		
	personalVehicle[id][pvSpawnedID] = CreateVehicle(personalVehicle[id][pvModelID], personalVehicle[id][pvX], personalVehicle[id][pvY], personalVehicle[id][pvZ], personalVehicle[id][pvAngle], personalVehicle[id][pvColorOne], personalVehicle[id][pvColorTwo], -1);
	SetVehicleVirtualWorld(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvVirtualWorld]);
	LinkVehicleToInterior(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvInterior]);
	SetVehicleNumberPlate(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvCarPlate]);
	vehicle_fuel[personalVehicle[id][pvSpawnedID]] = personalVehicle[id][pvFuel];
	vehicle_personal[personalVehicle[id][pvSpawnedID]] = id;	
	PutPlayerInVehicle(playerid, personalVehicle[id][pvSpawnedID], 0);
	ModVehicle(personalVehicle[id][pvSpawnedID]);
	if(personalVehicle[id][pvPaintJob] > -1) {
		ChangeVehiclePaintjob(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvPaintJob]);
	}
	SetVehicleHealth(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvHealth]);
	UpdateVehicleDamageStatus(personalVehicle[id][pvSpawnedID],personalVehicle[id][pvDamagePanels], personalVehicle[id][pvDamageDoors], personalVehicle[id][pvDamageLights], personalVehicle[id][pvDamageTires]);
	return true;
}

CMD:vehicles(playerid, params[]) {
	if(!Iter_Count(PlayerVehicles[playerid])) return sendPlayerError(playerid, "Nu ai nici un vehicul personal.");
	new count = 0;
	gString[0] = (EOS);
	foreach(new i : PlayerVehicles[playerid]) {
		if(personalVehicle[i][pvModelID] == 0) return sendPlayerError(playerid, "S-a creeat un bug la sistemul de vehicule, te rog sa raportezi pe /report.");
		if(personalVehicle[i][pvSpawnedID] == INVALID_VEHICLE_ID) {
			format(gString, sizeof gString, "%s{FFFFFF}%d\t%s\tHidden\t-\n", gString, (count + 1), getVehicleName(personalVehicle[i][pvModelID]));
		}
		else {
			format(gString, sizeof gString, "%s{FFFFFF}%d\t%s\t%s\t%d min\n", gString, (count + 1), getVehicleName(personalVehicle[i][pvModelID]), (IsVehicleOccupied(personalVehicle[i][pvSpawnedID])) ? ("{E5913E}Occupied{FFFFFF}") : ("{4DFF00}Available{FFFFFF}"), (!personalVehicle[i][pvDespawnTime] ? (0) : ((personalVehicle[i][pvDespawnTime] - gettime()) / 60)));	
		}
		playerInfo[playerid][pSelectVehicle][count] = i;
		count ++;
	}
	Dialog_Show(playerid, MY_GARAGE, DIALOG_STYLE_TABLIST, string_fast("Personal garage (%d/%d slots)", playerInfo[playerid][pVehicleSlots], MAX_PLAYER_PERSONAL_VEHICLES), gString, "Select", "Close");
	return true;
}
