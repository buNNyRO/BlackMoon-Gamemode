#define MAX_GASCAN 25
#define GASCAN_STREAMER_START 0

enum gasCanEnum {
	gID,
	gBizID,
	Float:gX,
	Float:gY,
	Float:gZ,
	Float:gFull,
	Text3D:gLabel,
	gArea,
	gPickup
};
new gasInfo[MAX_GASCAN][gasCanEnum], Iterator:ServerGasCan<MAX_GASCAN>, AreaGas[MAX_AREAS];

function LoadGasCan() {
	if(!cache_num_rows()) return print("Gas Can: 0 [From Database]");
	for(new i = 1, j = cache_num_rows() + 1; i != j; i++) {

		cache_get_value_name_int(i - 1, "ID", gasInfo[i][gID]);
		cache_get_value_name_int(i - 1, "BizID", gasInfo[i][gBizID]);
		cache_get_value_name_float(i - 1, "X", gasInfo[i][gX]);		
		cache_get_value_name_float(i - 1, "Y", gasInfo[i][gY]);
		cache_get_value_name_float(i - 1, "Z", gasInfo[i][gZ]);		
		cache_get_value_name_float(i - 1, "Full", gasInfo[i][gFull]);
		Iter_Add(ServerGasCan, gasInfo[i][gID]);
		gasInfo[i][gPickup] = CreateDynamicPickup(1650, 23, gasInfo[i][gX], gasInfo[i][gY], gasInfo[i][gZ], 0, 0, -1, 20.0);
		gasInfo[i][gLabel] = CreateDynamic3DTextLabel(string_fast("GasCan (%d)\nFuel Available %.1f", gasInfo[i][gBizID], gasInfo[i][gFull]), -1, gasInfo[i][gX], gasInfo[i][gY], gasInfo[i][gZ], 20.0, 0xFFFF, 0xFFFF, 0, 0, 0, -1, STREAMER_3D_TEXT_LABEL_SD);
		gasInfo[i][gArea] = CreateDynamicSphere(gasInfo[i][gX],gasInfo[i][gY],gasInfo[i][gZ], 4.0, 0, 0);
		AreaGas[gasInfo[i][gArea]] = i;
		Streamer_SetIntData(STREAMER_TYPE_AREA, gasInfo[i][gArea], E_STREAMER_EXTRA_ID, (i + GASCAN_STREAMER_START));
	}	
	return printf("Gas Can: %d [From Database]", Iter_Count(ServerGasCan));
}

CMD:addbizgas(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 6) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai acces la aceasta comanda.");
	if(Iter_Count(ServerGasCan) == MAX_GASCAN) return SCM(playerid, COLOR_ERROR, eERROR"Nu poti adauga un nou gascan deoarece s-a atins limita maxima.");
	extract params -> new id, fuel; else return sendPlayerSyntax(playerid, "/addbizgas <biz id> <fuel>");
	if(!Iter_Contains(ServerBusinesses, id)) return SCM(playerid, COLOR_ERROR, eERROR"Acest biz nu exista.");
	if(bizInfo[id][bizType] != 3) return SCM(playerid, COLOR_ERROR, eERROR"Acest business nu este de tip benzinarie.");
	new i = Iter_Free(ServerGasCan);
	GetPlayerPos(playerid, gasInfo[i][gX], gasInfo[i][gY], gasInfo[i][gZ]);
	gasInfo[i][gArea] = CreateDynamicSphere(gasInfo[i][gX],gasInfo[i][gY],gasInfo[i][gZ], 4.0, 0, 0);
	Streamer_SetIntData(STREAMER_TYPE_AREA, gasInfo[i][gArea], E_STREAMER_EXTRA_ID, (i + GASCAN_STREAMER_START));
	gasInfo[i][gID] = i; 
	gasInfo[i][gBizID] = id; 
	gasInfo[i][gFull] = fuel;
	gasInfo[i][gPickup] = CreateDynamicPickup(1650, 23, gasInfo[i][gX], gasInfo[i][gY], gasInfo[i][gZ], 0, 0, -1, 20.0);
	gasInfo[i][gLabel] = CreateDynamic3DTextLabel(string_fast("GasCan (%d)\nFuel Available %.1f", gasInfo[i][gBizID], gasInfo[i][gFull]), -1, gasInfo[i][gX], gasInfo[i][gY], gasInfo[i][gZ], 20.0, 0xFFFF, 0xFFFF, 0, 0, 0, -1, STREAMER_3D_TEXT_LABEL_SD);
	SCMf(playerid, COLOR_GOLD, "* Ai adaugat un nou gascan (id %d | %.1f procentaj | biz id %d) de combustibil. Acum acesta este valabil pentru jucatori.", gasInfo[i][gID], gasInfo[i][gFull], gasInfo[i][gBizID]);
	update("INSERT INTO `server_gascan` (`BizID`, `X`, `Y`, `Z`, `Full`) VALUES ('%d', '%.2f', '%.2f', '%.2f', '%.2f')", gasInfo[i][gID], gasInfo[i][gX], gasInfo[i][gY], gasInfo[i][gZ], gasInfo[i][gFull]);
	return true;
}

CMD:fill(playerid, params[]) {
	if(!IsPlayerInAnyVehicle(playerid)) return SCM(playerid, COLOR_ERROR, eERROR"Trebuie sa fi intr-un vehicul pentru a face acest lucru."); 
	extract params -> new Float:full; else return sendPlayerSyntax(playerid, "/fill <gas procent>");
	new area = AreaGas[GetPlayerNumberDynamicAreas(playerid)];
	if(IsPlayerInRangeOfPoint(playerid, 3.5, gasInfo[area][gX], gasInfo[area][gY], gasInfo[area][gZ])) {
		if(full + vehFuel[GetPlayerVehicleID(playerid)] >= 100.0) return SCM(playerid, COLOR_ERROR, eERROR"Acest vehicul are rezervorul plin.");
		new Float:procent = 100.0 - vehFuel[GetPlayerVehicleID(playerid)];
		if(!PlayerMoney(playerid, 10 * 250)) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai destui bani pentru a face acest lucru.");
		if(gasInfo[area][gFull] < procent) return SCM(playerid, COLOR_ERROR, eERROR"Aceasta benzinarie nu detine procentajul necesar de combustibil");
		TogglePlayerControllable(playerid, 0);
		playerInfo[playerid][pGasTimer] = defer gasTimer(playerid, 10 * 250);
		GameTextForPlayer(playerid, "Waiting for refuel...", 10000, 1);
	}
	return true;
}

timer gasTimer[10000](playerid, procent) {
	vehFuel[GetPlayerVehicleID(playerid)] += procent;
	if(vehPersonal[GetPlayerVehicleID(playerid)] > -1) PersonalVeh[vehPersonal[GetPlayerVehicleID(playerid)]][pvFuel] += procent;
	gasInfo[AreaGas[GetPlayerNumberDynamicAreas(playerid)]][gFull] -= procent;
	stop playerInfo[playerid][pGasTimer];
	TogglePlayerControllable(playerid, 1);
	GivePlayerCash(playerid, 0, procent * 250);
	UpdateDynamic3DTextLabelText(gasInfo[AreaGas[GetPlayerNumberDynamicAreas(playerid)]][gLabel], -1, string_fast("GasCan (%d)\nFuel Available %.1f", gasInfo[GetPlayerNumberDynamicAreas(playerid)][gBizID], gasInfo[GetPlayerNumberDynamicAreas(playerid)][gFull]));
	SCMf(playerid, COLOR_LIGHTRED, "* (Gas): {ffffff}Ti-ai facut plinul la vehicul si ai platit $%s pentru %.1f.", formatNumber(procent), procent);
	return true;
}