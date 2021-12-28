#include <YSI\y_hooks>
new reverse[MAX_PLAYERS],
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

enum PersonalVehEnum {
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
new PersonalVeh[MAX_PLAYERS_PERSONAL_VEHICLES][PersonalVehEnum], Iterator:TotalPlayerVehicles<MAX_PLAYERS_PERSONAL_VEHICLES>,
    Iterator:PlayerVehicles[MAX_PLAYERS]<MAX_PLAYER_PERSONAL_VEHICLES>;

function LoadPersonalVeh(playerid) {
	if(!cache_num_rows()) return true;

	new id;
	gString[0] = (EOS);
	for(new i = 1; i < (cache_num_rows() + 1); i++) {
		id = Iter_Free(TotalPlayerVehicles);

		cache_get_value_name_int(i - 1, "ID", PersonalVeh[id][pvID]);
		cache_get_value_name_int(i - 1, "ModelID", PersonalVeh[id][pvModelID]);
		cache_get_value_name_int(i - 1, "OwnerID", PersonalVeh[id][pvOwnerID]);
		cache_get_value_name_int(i - 1, "ColorOne", PersonalVeh[id][pvColorOne]);
		cache_get_value_name_int(i - 1, "ColorTwo", PersonalVeh[id][pvColorTwo]);
		cache_get_value_name_float(i - 1, "X", PersonalVeh[id][pvX]);
		cache_get_value_name_float(i - 1, "Y", PersonalVeh[id][pvY]);
		cache_get_value_name_float(i - 1, "Z", PersonalVeh[id][pvZ]);
		cache_get_value_name_float(i - 1, "Angle", PersonalVeh[id][pvAngle]);
		cache_get_value_name_float(i - 1, "Odometer", PersonalVeh[id][pvOdometer]);
		cache_get_value_name_float(i - 1, "Fuel", PersonalVeh[id][pvFuel]);
		cache_get_value_name_float(i - 1, "Health", PersonalVeh[id][pvHealth]);
		cache_get_value_name_int(i - 1, "Age", PersonalVeh[id][pvAge]);
		cache_get_value_name_int(i - 1, "InsurancePoints", PersonalVeh[id][pvInsurancePoints]);
		cache_get_value_name_int(i - 1, "LockStatus", PersonalVeh[id][pvLock]);
		cache_get_value_name_int(i - 1, "VirtualWorld", PersonalVeh[id][pvVirtualWorld]);
		cache_get_value_name_int(i - 1, "Interior",PersonalVeh[id][pvInterior]);
		cache_get_value_name_int(i - 1, "DamagePanels", PersonalVeh[id][pvDamagePanels]);
		cache_get_value_name_int(i - 1, "DamageDoors", PersonalVeh[id][pvDamageDoors]);
		cache_get_value_name_int(i - 1, "DamageLights", PersonalVeh[id][pvDamageLights]);
		cache_get_value_name_int(i - 1, "DamageTires", PersonalVeh[id][pvDamageTires]);
		cache_get_value_name_int(i - 1, "PaintJob", PersonalVeh[id][pvPaintJob]);
		
		PersonalVeh[id][pvSpawnedID] = INVALID_VEHICLE_ID;
		PersonalVeh[id][pvDespawnTime] = 0;

		cache_get_value_name(i - 1, "CarPlate", PersonalVeh[id][pvCarPlate], 12);
		cache_get_value_name(i - 1, "Components", gString, 64);
		sscanf(gString, "p<|>ddddddddddddddddd", PersonalVeh[id][pvComponents][0],  PersonalVeh[id][pvComponents][1],  PersonalVeh[id][pvComponents][2],  PersonalVeh[id][pvComponents][3],  PersonalVeh[id][pvComponents][4],
			   PersonalVeh[id][pvComponents][5],  PersonalVeh[id][pvComponents][6],  PersonalVeh[id][pvComponents][7],  PersonalVeh[id][pvComponents][8],  PersonalVeh[id][pvComponents][9], PersonalVeh[id][pvComponents][10],
			   PersonalVeh[id][pvComponents][11],  PersonalVeh[id][pvComponents][12],  PersonalVeh[id][pvComponents][13],  PersonalVeh[id][pvComponents][14],  PersonalVeh[id][pvComponents][15],  PersonalVeh[id][pvComponents][16]);
		
		Iter_Add(TotalPlayerVehicles, id);
		Iter_Add(PlayerVehicles[playerid], id);
	}

	return printf("[ACCOUNT] %s loaded %d vehicles", getName(playerid), Iter_Count(PlayerVehicles[playerid]));
}


Dialog:MY_GARAGE(playerid, response, listitem) {
	if(!response) return true;
	SetPVarInt(playerid, "vehSelect", playerInfo[playerid][pSelectVehicle][listitem]);
	if(PersonalVeh[playerInfo[playerid][pSelectVehicle][listitem]][pvSpawnedID] == INVALID_VEHICLE_ID) 
		return Dialog_Show(playerid, MY_GARAGE_DESPAWNED, DIALOG_STYLE_LIST, "SERVER: My Garage", "Informatii\nSpawneaza", "Select", "Close");

	return Dialog_Show(playerid, MY_GARAGE_SPAWNED, DIALOG_STYLE_LIST, "SERVER: My Garage", "Informatii\nLocalizeaza\nRemorcheaza\nDespawneaza\nDebugeaza", "Select", "Close");	
}

Dialog:MY_GARAGE_DESPAWNED(playerid, response, listitem) {
	if(!response) return true;
	new id = GetPVarInt(playerid, "vehSelect");
	if(!listitem) {
		gString[0] = (EOS);
		format(gString, sizeof(gString), "Model: %s (%d)\nColor One: %d\nColor Two: %d\nOdometer: %.02f\nAge: %d days\nInsurance Points: %d\nInsurance Price: $%s", getVehicleName(PersonalVeh[id][pvModelID]), PersonalVeh[id][pvModelID], PersonalVeh[id][pvColorOne], PersonalVeh[id][pvColorTwo], PersonalVeh[id][pvOdometer], PersonalVeh[id][pvAge], PersonalVeh[id][pvInsurancePoints], formatNumber(getInsurancePrice(floatround(PersonalVeh[id][pvOdometer]), PersonalVeh[id][pvAge])));
		return Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "SERVER: Car Information", gString, "Close", "");
	}
	PersonalVeh[id][pvSpawnedID] = CreateVehicle(PersonalVeh[id][pvModelID], PersonalVeh[id][pvX], PersonalVeh[id][pvY], PersonalVeh[id][pvZ], PersonalVeh[id][pvAngle], PersonalVeh[id][pvColorOne], PersonalVeh[id][pvColorTwo], -1);
	SetVehicleVirtualWorld(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvVirtualWorld]);
	LinkVehicleToInterior(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvInterior]);
	SetVehicleHealth(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvHealth]);
	UpdateVehicleDamageStatus(PersonalVeh[id][pvSpawnedID],PersonalVeh[id][pvDamagePanels], PersonalVeh[id][pvDamageDoors], PersonalVeh[id][pvDamageLights], PersonalVeh[id][pvDamageTires]);
	SetVehicleNumberPlate(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvCarPlate]);
	vehFuel[PersonalVeh[id][pvSpawnedID]] = PersonalVeh[id][pvFuel];
	vehPersonal[PersonalVeh[id][pvSpawnedID]] = id;	
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(PersonalVeh[id][pvSpawnedID], engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(PersonalVeh[id][pvSpawnedID], engine, lights, alarm, PersonalVeh[id][pvLock], bonnet, boot, objective);
	ModVehicle(PersonalVeh[id][pvSpawnedID]);
	if(PersonalVeh[id][pvPaintJob] > -1) {
		ChangeVehiclePaintjob(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvPaintJob]);
	}
	PersonalVeh[id][pvDespawnTime] = (gettime() + 900);
	defer TimerCar(id);
	SCM(playerid, COLOR_BISQUE, string_fast("Vehiculul tau %s, a fost spawnat la locul sau de parcare.", getVehicleName(PersonalVeh[id][pvModelID])));
	return true;
}

Dialog:MY_GARAGE_SPAWNED(playerid, response, listitem) {
	if(!response) return true;
	new id = GetPVarInt(playerid, "vehSelect");
	switch(listitem) {
		case 0: {
			gString[0] = (EOS);
			format(gString, sizeof(gString), "Model: %s (%d)\nColor One: %d\nColor Two: %d\nOdometer: %.02f\nAge: %d days\nInsurance Points: %d\nInsurance Price: $%s", getVehicleName(PersonalVeh[id][pvModelID]), PersonalVeh[id][pvModelID], PersonalVeh[id][pvColorOne], PersonalVeh[id][pvColorTwo], PersonalVeh[id][pvOdometer], PersonalVeh[id][pvAge], PersonalVeh[id][pvInsurancePoints], formatNumber(getInsurancePrice(floatround(PersonalVeh[id][pvOdometer]), PersonalVeh[id][pvAge])));
			return Dialog_Show(playerid, 0, DIALOG_STYLE_MSGBOX, "SERVER: Car Information", gString, "Close", "");		
		}
		case 1: {
			if(PersonalVeh[id][pvSpawnedID] == INVALID_VEHICLE_ID) return SCM(playerid, COLOR_ERROR, eERROR"Vehiculul nu este spawnat.");
			if(playerInfo[playerid][pCheckpointID] != -1) return SCM(playerid, COLOR_ERROR, eERROR"Ai deja un checkpoint, pe mini map.");
			new Float:x, Float:y, Float:z;
			GetVehiclePos(PersonalVeh[id][pvSpawnedID], x, y, z);
			new zone[32];
			Get3DZone(x, y, z, zone, 32);
			SCM(playerid, COLOR_BISQUE, string_fast("Vehiclul tau %s, a fost localizat in zona %s", getVehicleName(PersonalVeh[id][pvModelID]), zone));
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_FINDCAR;
			playerInfo[playerid][pCheckpointID] = PersonalVeh[id][pvSpawnedID];
			carFind[playerid] = repeat TimerCarFind(playerid);
			SetPlayerCheckpoint(playerid, x, y, z, 4.0);
		}
		case 2: {
			if(PersonalVeh[id][pvSpawnedID] == INVALID_VEHICLE_ID) return SCM(playerid, COLOR_ERROR, eERROR"Vehiculul nu este spawnat.");
			if(getVehicleHealth(PersonalVeh[id][pvSpawnedID]) < 250.1) return SCM(playerid, COLOR_ERROR, eERROR"Vehiculul este pe cale sa bubuie.");
			if(IsVehicleOccupied(PersonalVeh[id][pvSpawnedID])) return SCM(playerid, COLOR_ERROR, eERROR"Vehiculul este ocupat in acest moment.");
			if(GetPlayerCash(playerid) < 1000) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai $1,000 pentru a remorca vehiculul.");
			SetVehiclePos(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvX], PersonalVeh[id][pvY], PersonalVeh[id][pvZ]);
			SetVehicleVirtualWorld(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvVirtualWorld]);
			LinkVehicleToInterior(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvInterior]);
			vehPersonal[PersonalVeh[id][pvSpawnedID]] = id;
			PersonalVeh[id][pvDespawnTime] = (gettime() + 900);
			defer TimerCar(id);
			GivePlayerCash(playerid, 0, 1000);
			update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d' WHERE `ID` = '%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSQLID]);
			SCM(playerid, COLOR_GREY, string_fast("Vehiculul tau %s, a fost remorcat pentru $1,000.", getVehicleName(PersonalVeh[id][pvModelID])));
		}
		case 3: {
			if(PersonalVeh[id][pvSpawnedID] == INVALID_VEHICLE_ID) return SCM(playerid, COLOR_ERROR, eERROR"Vehiculul nu este spawnat.");
			if(getVehicleHealth(PersonalVeh[id][pvSpawnedID]) < 250.1) return SCM(playerid, COLOR_ERROR, eERROR"Vehiculul este pe cale sa bubuie.");
			if(IsVehicleOccupied(PersonalVeh[id][pvSpawnedID])) return SCM(playerid, COLOR_ERROR, eERROR"Vehiculul este ocupat in acest moment.");
			PersonalVeh[id][pvDespawnTime] = 0;
			vehEngine[PersonalVeh[id][pvSpawnedID]] = false;
			vehLights[PersonalVeh[id][pvSpawnedID]] = false;
			vehBonnet[PersonalVeh[id][pvSpawnedID]] = false;
			vehBoot[PersonalVeh[id][pvSpawnedID]] = false;	
			vehFuel[PersonalVeh[id][pvSpawnedID]] = 100.0;	
			vehPersonal[PersonalVeh[id][pvSpawnedID]] = -1;
			if(playerInfo[playerid][pCheckpoint] == CHECKPOINT_FINDCAR && playerInfo[playerid][pCheckpointID] == PersonalVeh[id][pvSpawnedID]) {
				playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
				playerInfo[playerid][pCheckpointID] = -1;
				DisablePlayerCheckpoint(playerid);
				stop carFind[playerid];
			}
			GetVehicleHealth(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvHealth]);
			GetVehicleDamageStatus(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvDamagePanels], PersonalVeh[id][pvDamageDoors], PersonalVeh[id][pvDamageLights], PersonalVeh[id][pvDamageTires]);
			gQuery[0] = (EOS);
			mysql_format(SQL, gQuery, sizeof(gQuery), "UPDATE `server_personal_vehicles` SET `Health` = '%f', `DamagePanels`='%d', `DamageDoors`='%d', `DamageLights`='%d', `DamageTires`='%d' WHERE `ID`='%d'", PersonalVeh[id][pvHealth], PersonalVeh[id][pvDamagePanels], PersonalVeh[id][pvDamageDoors], PersonalVeh[id][pvDamageLights], PersonalVeh[id][pvDamageTires],PersonalVeh[id][pvID]);
			mysql_tquery(SQL, gQuery, "", "");
			DestroyVehicle(PersonalVeh[id][pvSpawnedID]);		
			PersonalVeh[id][pvSpawnedID] =  INVALID_VEHICLE_ID;
			SCM(playerid, COLOR_GREY, string_fast("Vehiculul tau %s, a fost despawnat.", getVehicleName(PersonalVeh[id][pvModelID])));
		}
		case 4: {
			if(PersonalVeh[id][pvSpawnedID] == INVALID_VEHICLE_ID) return SCM(playerid, COLOR_ERROR, eERROR"Vehiculul nu este spawnat.");
			if(getVehicleHealth(PersonalVeh[id][pvSpawnedID]) < 250.1) return SCM(playerid, COLOR_ERROR, eERROR"Vehiculul este pe cale sa bubuie.");
			if(IsVehicleOccupied(PersonalVeh[id][pvSpawnedID])) return SCM(playerid, COLOR_ERROR, eERROR"Vehiculul este ocupat in acest moment.");
			if(playerInfo[playerid][pCheckpoint] != CHECKPOINT_NONE) return SCM(playerid, COLOR_ERROR, eERROR"Ai deja un checkpoint, pe mini map.");
			new Float:x, Float:y, Float:z;
			GetVehiclePos(PersonalVeh[id][pvSpawnedID], x, y, z);		
			if(!IsPlayerInRangeOfPoint(playerid, 75.0, x, y, z)) return SCM(playerid, COLOR_ERROR, eERROR"Trebuie sa te afli la o distanta de 75m de vehicul.");	
			new rand = random(5);
			SetVehiclePos(PersonalVeh[id][pvSpawnedID], DebugVehicles[rand][0], DebugVehicles[rand][1], DebugVehicles[rand][2]);
			SetVehicleZAngle(PersonalVeh[id][pvSpawnedID], DebugVehicles[rand][3]);
			SetVehicleVirtualWorld(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvVirtualWorld]);
			LinkVehicleToInterior(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvInterior]);
			GetVehiclePos(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvX], PersonalVeh[id][pvY], PersonalVeh[id][pvZ]);
			GetVehicleZAngle(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvAngle]);
			PersonalVeh[id][pvVirtualWorld] = 0;
			PersonalVeh[id][pvInterior] = 0;
			update("UPDATE `server_personal_vehicles` SET `X` = '%f', `Y` = '%f', `Z` = '%f', `Angle` = '%f' WHERE `ID` = '%d'", PersonalVeh[id][pvX], PersonalVeh[id][pvY], PersonalVeh[id][pvZ], PersonalVeh[id][pvAngle], PersonalVeh[id][pvID]);
			vehPersonal[PersonalVeh[id][pvSpawnedID]] = id;
			PersonalVeh[id][pvDespawnTime] = (gettime() + 900);
			defer TimerCar(id);
			new zone[32];
			Get3DZone(DebugVehicles[rand][0], DebugVehicles[rand][1], DebugVehicles[rand][2], zone, 32);
			SCM(playerid, COLOR_BISQUE, string_fast("Vehiclul tau %s, a fost mutat in parcarea din zona %s", getVehicleName(PersonalVeh[id][pvModelID]), zone));
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_FINDCAR;
			playerInfo[playerid][pCheckpointID] = PersonalVeh[id][pvSpawnedID];
			carFind[playerid] = repeat TimerCarFind(playerid);
			SetPlayerCheckpoint(playerid, DebugVehicles[rand][0], DebugVehicles[rand][1], DebugVehicles[rand][2], 4.0);
		}
	}

	return true;
}

Dialog:BUY_INSURANCE(playerid, response) {
	if(!response) return true;
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !Iter_Contains(PlayerVehicles[playerid], vehPersonal[GetPlayerVehicleID(playerid)])) return SCM(playerid, COLOR_ERROR, eERROR"Nu te afli intr-un vehicul.");
	new id = vehPersonal[GetPlayerVehicleID(playerid)];
	if(GetPlayerCash(playerid) < getInsurancePrice(floatround(PersonalVeh[id][pvOdometer]), PersonalVeh[id][pvAge])) return SCMf(playerid, COLOR_ERROR, eERROR"Nu ai $%s pentru a plati asigurarea.", formatNumber(getInsurancePrice(floatround(PersonalVeh[id][pvOdometer]), PersonalVeh[id][pvAge])));
	if(PersonalVeh[id][pvInsurancePoints] >= 5) return SCM(playerid, COLOR_ERROR, eERROR"Vehiculul tau are deja mai mult sau egal cu 5 puncte de asigurare");
	PersonalVeh[id][pvInsurancePoints] ++;
	update("UPDATE `server_personal_vehicles` SET `InsurancePoints` = '%d' WHERE `ID`='%d'", PersonalVeh[id][pvInsurancePoints], PersonalVeh[id][pvID]);
	SCM(playerid, COLOR_GREY, string_fast("* Notice Buy Insurance Points: Ai cumparat un punct de asigurare pentru $%s.", formatNumber(getInsurancePrice(floatround(PersonalVeh[id][pvOdometer]), PersonalVeh[id][pvAge]))));
    GivePlayerCash(playerid, 1, getInsurancePrice(floatround(PersonalVeh[id][pvOdometer]), PersonalVeh[id][pvAge]));
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
			if(PersonalVeh[vehPersonal[vehicleid]][pvComponents][i] > 0) {
				AddVehicleComponent(vehicleid, PersonalVeh[vehPersonal[vehicleid]][pvComponents][i]);
			}
		}
	}

	return true;
}

stock SaveComponent(vehicleid, componentid) {
	new id = vehPersonal[vehicleid];
	for(new s=0; s<20; s++) {
		if(componentid == spoiler[s][0]) {
			PersonalVeh[id][pvComponents][0] = componentid;
		}
	}
	for(new s=0; s<4; s++) {
		if(componentid == bscoop[s][0]) {
			PersonalVeh[id][pvComponents][1] = componentid;
		}
	}
	for(new s=0; s<17; s++) {
		if(componentid == rscoop[s][0]) {
			PersonalVeh[id][pvComponents][2] = componentid;
		}
	}
	for(new s=0; s<21; s++) {
		if(componentid == rskirt[s][0]) {
			PersonalVeh[id][pvComponents][3] = componentid;
		}
	}
	for(new s=0; s<21; s++) {
		if(componentid == lskirt[s][0]) {
			PersonalVeh[id][pvComponents][16] = componentid;
		}
	}
	for(new s=0; s<2; s++) {
		if(componentid == vlights[s][0]) {
			PersonalVeh[id][pvComponents][4] = componentid;
		}
	}
	for(new s=0; s<3; s++) {
		if(componentid == nitro[s][0]) {
			PersonalVeh[id][pvComponents][5] = componentid;
		}
	}
	for(new s=0; s<28; s++) {
		if(componentid == exhaust[s][0]) {
			PersonalVeh[id][pvComponents][6] = componentid;
		}
	}
	for(new s=0; s<17; s++) {
		if(componentid == wheels[s][0]) {
			PersonalVeh[id][pvComponents][7] = componentid;
		}
	}
	for(new s=0; s<1; s++) {
		if(componentid == vbase[s][0]) {
			PersonalVeh[id][pvComponents][8] = componentid;
		}
	}
	for(new s=0; s<1; s++) {
		if(componentid == hydraulics[s][0]) {
			PersonalVeh[id][pvComponents][9] = componentid;
		}
	}
	for(new s=0; s<23; s++) {
		if(componentid == fbumper[s][0]) {
			PersonalVeh[id][pvComponents][10] = componentid;
		}
	}
	for(new s=0; s<22; s++) {
		if(componentid == rbumper[s][0]) {
			PersonalVeh[id][pvComponents][11] = componentid;
		}
	}
	for(new s=0; s<2; s++) {
		if(componentid == bventr[s][0]) {
			PersonalVeh[id][pvComponents][12] = componentid;
		}
	}
	for(new s=0; s<2; s++) {
		if(componentid == bventl[s][0]) {
			PersonalVeh[id][pvComponents][13] = componentid;
		}
	}
	for(new s=0; s<2; s++) {
		if(componentid == fbbars[s][0]) {
			PersonalVeh[id][pvComponents][15] = componentid;
		}
	}	
	for(new s=0; s<4; s++) {
		if(componentid == rbbars[s][0]) {
			PersonalVeh[id][pvComponents][14] = componentid;
		}
	}
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof(gQuery), "UPDATE `server_personal_vehicles` SET `Components`='%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d|%d' WHERE `ID`='%d'", 
		PersonalVeh[id][pvComponents][0], PersonalVeh[id][pvComponents][1], PersonalVeh[id][pvComponents][2], PersonalVeh[id][pvComponents][3], PersonalVeh[id][pvComponents][4], PersonalVeh[id][pvComponents][5], PersonalVeh[id][pvComponents][6], PersonalVeh[id][pvComponents][7], PersonalVeh[id][pvComponents][8], 
		PersonalVeh[id][pvComponents][9], PersonalVeh[id][pvComponents][10], PersonalVeh[id][pvComponents][11], PersonalVeh[id][pvComponents][12], PersonalVeh[id][pvComponents][13], PersonalVeh[id][pvComponents][14], PersonalVeh[id][pvComponents][15], PersonalVeh[id][pvComponents][16], PersonalVeh[id][pvID]);
	mysql_tquery(SQL, gQuery, "", "");
	return true;
}
stock getInsurancePrice(x, y) return (x * 100) + (y / 100) + 100;
timer TimerCar[gettime() + 900](i) { 
	vehEngine[PersonalVeh[i][pvSpawnedID]] = false;
	vehLights[PersonalVeh[i][pvSpawnedID]] = false;
	vehBonnet[PersonalVeh[i][pvSpawnedID]] = false;
	vehBoot[PersonalVeh[i][pvSpawnedID]] = false;	
	vehFuel[PersonalVeh[i][pvSpawnedID]] = 100.0;	
	vehPersonal[PersonalVeh[i][pvSpawnedID]] = -1;
	new playerid = getVehicleOwner(PersonalVeh[i][pvOwnerID]);
	if(playerInfo[playerid][pCheckpoint] == CHECKPOINT_FINDCAR && playerInfo[playerid][pCheckpointID] == PersonalVeh[i][pvSpawnedID]) {
		playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
		playerInfo[playerid][pCheckpointID] = -1;
		DisablePlayerCheckpoint(playerid);
	}
	PersonalVeh[i][pvDespawnTime] = 0;
	DestroyVehicle(PersonalVeh[i][pvSpawnedID]);	
	PersonalVeh[i][pvSpawnedID] = INVALID_VEHICLE_ID;
	GetVehicleHealth(PersonalVeh[i][pvSpawnedID], PersonalVeh[i][pvHealth]);
	GetVehicleDamageStatus(PersonalVeh[i][pvSpawnedID], PersonalVeh[i][pvDamagePanels], PersonalVeh[i][pvDamageDoors], PersonalVeh[i][pvDamageLights], PersonalVeh[i][pvDamageTires]);
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof(gQuery), "UPDATE `server_personal_vehicles` SET `Health` = '%f', `DamagePanels`='%d', `DamageDoors`='%d', `DamageLights`='%d', `DamageTires`='%d' WHERE `ID`='%d", PersonalVeh[i][pvHealth], PersonalVeh[i][pvDamagePanels], PersonalVeh[i][pvDamageDoors], PersonalVeh[i][pvDamageLights], PersonalVeh[i][pvDamageTires],PersonalVeh[i][pvID]);
	mysql_tquery(SQL, gQuery, "", "");
	return true;
}

hook OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	switch(newkeys) {
		case KEY_JUMP: if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) reverse[playerid] = 1;
		case KEY_SPRINT: if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) reverse[playerid] = 0;
	}
	return 1;
}


timer TimerSpeedo[1000](playerid) {
	new vehicleid = GetPlayerVehicleID(playerid), Float:he, sall[5];
	if(!vehEngine[vehicleid]) {
		stop speedo[playerid];
		PlayerTextDrawSetString(playerid, vehicleHud[10], "000");
		PlayerTextDrawSetString(playerid, vehicleHud[11], "n");
		PlayerTextDrawSetString(playerid, vehicleHud[14], "O");
		PlayerTextDrawSetString(playerid, vehicleHud[15], "C");
		PlayerTextDrawSetString(playerid, vehicleHud[16], "L");
		PlayerTextDrawSetString(playerid, vehicleHud[17], "0000000.0");

		PlayerTextDrawHide(playerid, vehicleHud[18]);
		PlayerTextDrawHide(playerid, vehicleHud[19]);
		return 1;
	}
	GetVehicleHealth(vehicleid, he);
	switch(strlen(string_fast("%d", getVehicleSpeed(vehicleid)))) {
		case 1: sall = "00";
		case 2: sall = "0";
		default: sall = "";
	}
	va_PlayerTextDrawSetString(playerid, vehicleHud[10], "%s", (getVehicleSpeed(vehicleid) >= 999 ? "~r~999" : string_fast("%s~r~%d", sall, getVehicleSpeed(vehicleid))));

	switch(getVehicleSpeed(vehicleid)) {
		case 0: sall = "~r~N";
		case 1..35: sall = "~r~1";
		case 36..65: sall = "~r~2";
		case 66..85: sall = "~r~3";
		case 86..105: sall = "~r~4";
		case 106..125: sall = "~r~5";
		default: sall = "~r~6";
	}
	va_PlayerTextDrawSetString(playerid, vehicleHud[11], "%s", (reverse[playerid] ? "~r~R" : sall));
	va_PlayerTextDrawSetString(playerid, vehicleHud[16], "%s", (!vehLights[vehicleid] ? "~y~L" : "L"));

	PlayerTextDrawTextSize(playerid, vehicleHud[18], -1.000000, (-1.000000)+(-0.024000*he));
	PlayerTextDrawShow(playerid, vehicleHud[18]);

	if(vehFuel[vehicleid] > 0) {
		PlayerTextDrawTextSize(playerid, vehicleHud[19], (1.000000)+(0.840000*vehFuel[vehicleid]), -4.000000);
		PlayerTextDrawShow(playerid, vehicleHud[19]);
	} 
	else if(vehEngine[vehicleid]) callcmd::engine(playerid, "\1");	

	if(vehPersonal[vehicleid] > -1) {
		va_PlayerTextDrawSetString(playerid, vehicleHud[14], "%sO", (!PersonalVeh[vehPersonal[vehicleid]][pvLock]) ? ("~g~") : ("~r~"));
		va_PlayerTextDrawSetString(playerid, vehicleHud[15], "%sC", (!PersonalVeh[vehPersonal[vehicleid]][pvLock]) ? ("~g~") : ("~r~"));
		va_PlayerTextDrawSetString(playerid, vehicleHud[17], "%.1f", PersonalVeh[vehPersonal[vehicleid]][pvOdometer]);
	}

	if(!isPlane(vehicleid) && !isBoat(vehicleid) && !isBike(vehicleid) && vehEngine[vehicleid] == true && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)  {
		new Float: fuel = 0.050, speed = getVehicleSpeed(vehicleid);
		if(speed >= 2) {
			fuel = (speed * 0.02) / 100;
		}
		vehFuel[vehicleid] -= fuel;
		if(vehPersonal[vehicleid] > -1) {
			new id = vehPersonal[vehicleid];
			PersonalVeh[id][pvFuel] -= fuel;
			PersonalVeh[id][pvOdometer] += (fuel == 0.050) ? (0.0) : (fuel);
		}	
	}
	return true;
}

hook OnPlayerDisconnect(playerid, reason) {
	foreach(new i : PlayerVehicles[playerid]) {
		if(PersonalVeh[i][pvOwnerID] == playerInfo[playerid][pSQLID]) {
			update("UPDATE `server_personal_vehicles` SET  `Health` = '%f', `Fuel` = '%f', `Odometer`='%f', `DamageDoors`='%d', `DamageLights`='%d', `DamageTires`='%d' WHERE `ID`='%d'", PersonalVeh[i][pvHealth], PersonalVeh[i][pvFuel], PersonalVeh[i][pvOdometer], PersonalVeh[i][pvDamagePanels], PersonalVeh[i][pvDamageDoors], PersonalVeh[i][pvDamageLights], PersonalVeh[i][pvDamageTires],PersonalVeh[i][pvID]);

			PersonalVeh[i][pvID] = 0;
			PersonalVeh[i][pvModelID] = 0;
			PersonalVeh[i][pvOwnerID] = 0;
			PersonalVeh[i][pvColorOne] = 0;
			PersonalVeh[i][pvColorTwo] = 0;
			PersonalVeh[i][pvX] = 0;
			PersonalVeh[i][pvY] = 0;
			PersonalVeh[i][pvZ] = 0;
			PersonalVeh[i][pvAngle] = 0;
			PersonalVeh[i][pvOdometer] = 0;
			PersonalVeh[i][pvFuel] = 0;
			PersonalVeh[i][pvAge] = 0;
			PersonalVeh[i][pvInsurancePoints] = 0;
			PersonalVeh[i][pvLock] = 0;
			PersonalVeh[i][pvHealth] = 0.0;
			PersonalVeh[i][pvVirtualWorld] = 0;
			PersonalVeh[i][pvInterior] = 0;
			PersonalVeh[i][pvDamagePanels] = 0;
			PersonalVeh[i][pvDamageDoors] = 0;
			PersonalVeh[i][pvDamageLights] = 0;
			PersonalVeh[i][pvDamageTires] = 0;
			PersonalVeh[i][pvCarPlate] = (EOS);
			PersonalVeh[i][pvDespawnTime] = 0;

			for(new x = 0; x < 17; x++) {
				PersonalVeh[i][pvComponents][x] = 0;
			}

			if(PersonalVeh[i][pvSpawnedID] != INVALID_PLAYER_ID) {
				DestroyVehicle(PersonalVeh[i][pvSpawnedID]);
				PersonalVeh[i][pvSpawnedID] = INVALID_VEHICLE_ID;
			}

			Iter_Remove(TotalPlayerVehicles, i);
			Iter_SafeRemove(PlayerVehicles[playerid], i, i);
		}
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
	if(vehPersonal[vehicleid] == -1) return SCM(playerid, COLOR_ERROR, eERROR"Acest vehicul nu este unul personal.");
	new engine, lights, alarm, doors, bonnet, boot, objective, id = vehPersonal[vehicleid];
	if(PersonalVeh[id][pvLock] == 0) {
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		SetVehicleParamsEx(vehicleid, engine, lights, alarm, VEHICLE_PARAMS_ON, bonnet, boot, objective);
		PersonalVeh[id][pvLock] = 1;
		update("UPDATE `server_personal_vehicles` SET `LockStatus` = '1' WHERE `ID` = '%d'", PersonalVeh[id][pvID]);
		GameTextForPlayer(playerid, string_fast("~w~%s~n~~r~INCUIAT", getVehicleName(PersonalVeh[id][pvModelID])), 5000, 4);
		return true;
	}
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, engine, lights, alarm, VEHICLE_PARAMS_OFF, bonnet, boot, objective);
	PersonalVeh[id][pvLock] = 0;
	update("UPDATE `server_personal_vehicles` SET `LockStatus` = '0' WHERE `ID` = '%d'", PersonalVeh[id][pvID]);
	GameTextForPlayer(playerid, string_fast("~w~%s~n~~g~DESCUIAT", getVehicleName(PersonalVeh[id][pvModelID])), 5000, 4);
	return true;
}

CMD:swapcolors(playerid, params[]) {
	if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !Iter_Contains(PlayerVehicles[playerid], vehPersonal[GetPlayerVehicleID(playerid)])) return SCM(playerid, COLOR_ERROR, eERROR"Nu te afli intr-un vehicul.");
	if(GetPlayerCash(playerid) < 2000) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai $2,000.");
	new id = vehPersonal[GetPlayerVehicleID(playerid)], color = PersonalVeh[id][pvColorOne];
	PersonalVeh[id][pvColorOne] = PersonalVeh[id][pvColorTwo];
	PersonalVeh[id][pvColorTwo] = color;
	update("UPDATE `server_personal_vehicles` SET `ColorOne` = '%d', `ColorTwo` = '%d' WHERE `ID`='%d'", PersonalVeh[id][pvColorOne], PersonalVeh[id][pvColorTwo], PersonalVeh[id][pvID]);
	ChangeVehicleColor(GetPlayerVehicleID(playerid), PersonalVeh[id][pvColorOne], PersonalVeh[id][pvColorTwo]);
	SCM(playerid, COLOR_GREY, "* Notice SwapColors: Ti-ai inversat culorile cu succes.");
	GivePlayerCash(playerid, 0, 1000);
	update("UPDATE `server_users` SET `Money` = '%d' `MStore` = '%d' WHERE `ID`='%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSQLID]);
	return true;
}

CMD:buyinsurance(playerid, params[]) {
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !Iter_Contains(PlayerVehicles[playerid], vehPersonal[GetPlayerVehicleID(playerid)])) return SCM(playerid, COLOR_ERROR, eERROR"Nu te afli intr-un vehicul.");
	if(PersonalVeh[vehPersonal[GetPlayerVehicleID(playerid)]][pvInsurancePoints] >= 5) return SCM(playerid, COLOR_ERROR, eERROR"Vehiculul tau are deja mai mult sau egal cu 5 puncte de asigurare");
	Dialog_Show(playerid, BUY_INSURANCE, DIALOG_STYLE_MSGBOX, "SERVER: Buy Insurance", "Esti sigur ca doresti sa cumperi un punct de asigurare pentru $%s?", "Da", "Nu", formatNumber(getInsurancePrice(floatround(PersonalVeh[vehPersonal[GetPlayerVehicleID(playerid)]][pvOdometer]), PersonalVeh[vehPersonal[GetPlayerVehicleID(playerid)]][pvAge])));
	return true;
}

CMD:carplate(playerid, params[]) {
	if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !Iter_Contains(PlayerVehicles[playerid], vehPersonal[GetPlayerVehicleID(playerid)])) return SCM(playerid, COLOR_ERROR, eERROR"Nu te afli intr-un vehicul.");
	if(isnull(params) || strlen(params) > 12) return sendPlayerSyntax(playerid, "/carplate <plate>");
	if(GetPlayerCash(playerid) < 4000) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai $4,000.");
	new vehicleid = GetPlayerVehicleID(playerid);
	format(PersonalVeh[vehPersonal[vehicleid]][pvCarPlate], 12, params);
	update("UPDATE `server_personal_vehicles` SET `CarPlate` = '%s' WHERE `ID`='%d'", PersonalVeh[vehPersonal[vehicleid]][pvCarPlate], PersonalVeh[vehPersonal[vehicleid]][pvID]);
	SetVehicleNumberPlate(vehicleid, params);
	SCM(playerid, COLOR_GREY, string_fast("* Notice CarPlate: Numarul de inmatriculare este %s.", params));
	SCM(playerid, COLOR_GREY, "Acesta va fi vizibil dupa ce vehiculul va fi respawnat.");
	GivePlayerCash(playerid, 0, 4000);
	update("UPDATE `server_users` SET `Money` = '%d' `MStore` = '%d' WHERE `ID`='%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSQLID]);
	return true;
}

CMD:carcolor(playerid, params[]) {
	if(!IsPlayerInAnyVehicle(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !Iter_Contains(PlayerVehicles[playerid], vehPersonal[GetPlayerVehicleID(playerid)])) return SCM(playerid, COLOR_ERROR, eERROR"Nu te afli intr-un vehicul.");
	if(!Iter_Contains(PlayerVehicles[playerid], vehPersonal[GetPlayerVehicleID(playerid)])) return SCM(playerid, COLOR_ERROR, eERROR"Acest vehicul nu iti apartine.");
	if(GetPlayerCash(playerid) < 2000) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai $2,000.");
	new firstColor, secondColor;
	if(sscanf(params, "dd", firstColor, secondColor)) return sendPlayerSyntax(playerid, "/carcolor <first color> <second color>");
	if(firstColor < 0 || firstColor > 255) return SCM(playerid, COLOR_ERROR, eERROR"Culoarea principala, nu este valida.");
	if(secondColor < 0 || secondColor > 255) return SCM(playerid, COLOR_ERROR, eERROR"Culoarea secundara, nu este valida.");
	new id = vehPersonal[GetPlayerVehicleID(playerid)];
	if(PersonalVeh[id][pvColorOne] == firstColor) return SCM(playerid, COLOR_ERROR, eERROR"Culoarea principala este deja pe vehiculul tau.");
	if(PersonalVeh[id][pvColorTwo] == secondColor) return SCM(playerid, COLOR_ERROR, eERROR"Culoarea secundara este deja pe vehiculul tau.");
	PersonalVeh[id][pvColorOne] = firstColor;
	PersonalVeh[id][pvColorTwo] = secondColor;
	update("UPDATE `server_personal_vehicles` SET `ColorOne` = '%d', `ColorTwo` = '%d' WHERE `ID`='%d'", firstColor, secondColor, PersonalVeh[id][pvID]);
	ChangeVehicleColor(PersonalVeh[id][pvSpawnedID], firstColor, secondColor);
	SCM(playerid, COLOR_GREY, "* Notice Car Color: Culorile au fost actualizate.");
	GivePlayerCash(playerid, 0, 2000);
	update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d' WHERE `ID`='%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSQLID]);
	return true;
}

CMD:park(playerid, params[]) {
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SCM(playerid, COLOR_ERROR, eERROR"Nu te afli intr-un vehicul ca sofer.");
	if(IsPlayerInRangeOfPoint(playerid, 50.0, 1310.1444, -1369.5681, 13.5640)) return SCM(playerid, COLOR_ERROR, eERROR"Nu poti parca masina in zona spawnului.");
	new vehicleid = GetPlayerVehicleID(playerid);
	if(getVehicleSpeed(vehicleid)) return SCM(playerid, COLOR_ERROR, eERROR"Nu poti parca un vehicul ce se afla in deplasare.");
	if(vehPersonal[vehicleid] == -1) return SCM(playerid, COLOR_ERROR, eERROR"Nu te afli intr-un vehicul personal.");
	new id = vehPersonal[vehicleid];
	if(PersonalVeh[id][pvOwnerID] != playerInfo[playerid][pSQLID])  return SCM(playerid, COLOR_ERROR, eERROR"Acest vehicul nu iti apartine.");
	GetVehicleHealth(vehicleid, PersonalVeh[id][pvHealth]);
	if(PersonalVeh[id][pvHealth] < 400.0) return SCM(playerid, COLOR_ERROR, eERROR"Acest vehicul este prea avariat.");
	GetVehicleDamageStatus(vehicleid, PersonalVeh[id][pvDamagePanels], PersonalVeh[id][pvDamageDoors], PersonalVeh[id][pvDamageLights], PersonalVeh[id][pvDamageTires]);
	GetVehiclePos(vehicleid, PersonalVeh[id][pvX], PersonalVeh[id][pvY], PersonalVeh[id][pvZ]);
	GetVehicleZAngle(vehicleid, PersonalVeh[id][pvAngle]);
	#pragma unused vehicleid
	PersonalVeh[id][pvVirtualWorld] = GetPlayerVirtualWorld(playerid);
	PersonalVeh[id][pvInterior] = GetPlayerInterior(playerid);
	gQuery[0] = (EOS);
	mysql_format(SQL, gQuery, sizeof(gQuery), "UPDATE `server_personal_vehicles` SET `DamagePanels`='%d', `DamageDoors`='%d', `DamageLights`='%d', `DamageTires`='%d', `X` ='%f', `Y`='%f', `Z`='%f', `Angle`='%f', `VirtualWorld`='%d', `Interior`='%d' WHERE `ID`='%d'",
	PersonalVeh[id][pvDamagePanels], PersonalVeh[id][pvDamageDoors], PersonalVeh[id][pvDamageLights], PersonalVeh[id][pvDamageTires], PersonalVeh[id][pvX], PersonalVeh[id][pvY], PersonalVeh[id][pvZ],
	PersonalVeh[id][pvAngle], PersonalVeh[id][pvVirtualWorld], PersonalVeh[id][pvInterior], PersonalVeh[id][pvID]);
	mysql_tquery(SQL, gQuery, "", "");
	vehEngine[PersonalVeh[id][pvSpawnedID]] = false;
	vehLights[PersonalVeh[id][pvSpawnedID]] = false;
	vehBonnet[PersonalVeh[id][pvSpawnedID]] = false;
	vehBoot[PersonalVeh[id][pvSpawnedID]] = false;	
	vehFuel[PersonalVeh[id][pvSpawnedID]] = 100.0;	
	vehPersonal[PersonalVeh[id][pvSpawnedID]] = -1;
	PersonalVeh[id][pvDespawnTime] = 0;
	DestroyVehicle(PersonalVeh[id][pvSpawnedID]);		
	PersonalVeh[id][pvSpawnedID] = CreateVehicle(PersonalVeh[id][pvModelID], PersonalVeh[id][pvX], PersonalVeh[id][pvY], PersonalVeh[id][pvZ], PersonalVeh[id][pvAngle], PersonalVeh[id][pvColorOne], PersonalVeh[id][pvColorTwo], -1);
	SetVehicleVirtualWorld(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvVirtualWorld]);
	LinkVehicleToInterior(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvInterior]);
	SetVehicleNumberPlate(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvCarPlate]);
	vehFuel[PersonalVeh[id][pvSpawnedID]] = PersonalVeh[id][pvFuel];
	vehPersonal[PersonalVeh[id][pvSpawnedID]] = id;	
	PutPlayerInVehicleEx(playerid, PersonalVeh[id][pvSpawnedID], 0);
	ModVehicle(PersonalVeh[id][pvSpawnedID]);
	if(PersonalVeh[id][pvPaintJob] > -1) {
		ChangeVehiclePaintjob(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvPaintJob]);
	}
	SetVehicleHealth(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvHealth]);
	UpdateVehicleDamageStatus(PersonalVeh[id][pvSpawnedID],PersonalVeh[id][pvDamagePanels], PersonalVeh[id][pvDamageDoors], PersonalVeh[id][pvDamageLights], PersonalVeh[id][pvDamageTires]);
	return true;
}

CMD:vehicles(playerid, params[]) {
	if(!Iter_Count(PlayerVehicles[playerid])) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai nici un vehicul personal.");
	new count = 0;
	gString[0] = (EOS);
	foreach(new i : PlayerVehicles[playerid]) {
		if(PersonalVeh[i][pvModelID] == 0) return SCM(playerid, COLOR_ERROR, eERROR"S-a creeat un bug la sistemul de vehicule, te rog sa raportezi pe /report.");
		if(PersonalVeh[i][pvSpawnedID] == INVALID_VEHICLE_ID) {
			format(gString, sizeof gString, "%s{FFFFFF}[%d] %d\t%s\tHidden\t-\n", gString, PersonalVeh[i][pvID], (count + 1), getVehicleName(PersonalVeh[i][pvModelID]));
		}
		else {
			format(gString, sizeof gString, "%s{FFFFFF}[%d] %d\t%s\t%s\t%d min\n", gString, PersonalVeh[i][pvID], (count + 1), getVehicleName(PersonalVeh[i][pvModelID]), (IsVehicleOccupied(PersonalVeh[i][pvSpawnedID])) ? ("{E5913E}Occupied{FFFFFF}") : ("{4DFF00}Available{FFFFFF}"), (!PersonalVeh[i][pvDespawnTime] ? (0) : ((PersonalVeh[i][pvDespawnTime] - gettime()) / 60)));	
		}
		playerInfo[playerid][pSelectVehicle][count] = i;
		count ++;
	}
	Dialog_Show(playerid, MY_GARAGE, DIALOG_STYLE_TABLIST, string_fast("Personal garage (%d/%d slots)", count, playerInfo[playerid][pVehicleSlots]), gString, "Select", "Close");
	return true;
}