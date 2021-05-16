#define MAX_GASCAN 25

enum gasCanEnum {
	gID,
	gBizID,
	Float:gX,
	Float:gY,
	Float:gZ,
	Float:gFull,
	Text3D:gLabel,
	gPickup
};
new gasInfo[MAX_GASCAN][gasCanEnum], Iterator:ServerGasCan<MAX_GASCAN>;

function LoadGasCan() {
	if(!cache_num_rows()) return print("Gas Can: 0 [From Database]");
    for(new i = 0; i < cache_num_rows(); i++) {
		cache_get_value_name_int(i, "ID", gasInfo[i][gID]);
		cache_get_value_name_int(i, "BizID", gasInfo[i][gBizID]);
		cache_get_value_name_float(i, "X", gasInfo[i][gX]);		
		cache_get_value_name_float(i, "Y", gasInfo[i][gY]);
		cache_get_value_name_float(i, "Z", gasInfo[i][gZ]);		
		cache_get_value_name_float(i, "Full", gasInfo[i][gFull]);
		Iter_Add(ServerGasCan, gasInfo[i][gID]);
		updateGasCan(gasInfo[i][gID]);
	}	
	return printf("Gas Can: %d [From Database]", Iter_Count(ServerGasCan));
}

function updateGasCan(gid) {
	gasInfo[gid][gPickup] = CreateDynamicPickup(1650, 23, gasInfo[gid][gX], gasInfo[gid][gY], gasInfo[gid][gZ], 0, 0, -1, 20.0);
	gasInfo[gid][gLabel] = CreateDynamic3DTextLabel(string_fast("GasCan (%d)\nFuel Available %.1f", gasInfo[gid][gBizID], gasInfo[gid][gFull]), -1, gasInfo[gid][gX], gasInfo[gid][gY], gasInfo[gid][gZ], 20.0, 0xFFFF, 0xFFFF, 0, 0, 0, -1, STREAMER_3D_TEXT_LABEL_SD);
	PickInfo[gasInfo[gid][gPickup]][GASCAN] = gid;
	return true;
}

CMD:addbizgas(playerid, params[]) {
	if(playerInfo[playerid][pAdmin] < 6) return SCM(playerid, COLOR_ERROR, "[ERROR] {FFFFFF}Nu ai acces la aceasta comanda.");
	if(Iter_Count(ServerGasCan) == MAX_GASCAN) return SCM(playerid, COLOR_ERROR, "[ERROR] {FFFFFF}Nu poti adauga un nou gascan deoarece s-a atins limita maxima.");
	extract params -> new id, fuel; else return sendPlayerSyntax(playerid, "/addbizgas <biz id> <fuel>");
	if(!Iter_Contains(ServerBusinesses, id)) return SCM(playerid, COLOR_ERROR, "[ERROR] {FFFFFF}Acest biz nu exista.");
	if(bizInfo[id][bizType] != 3) return SCM(playerid, COLOR_ERROR, "[ERROR] {FFFFFF}Acest business nu este de tip benzinarie.");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	new i = Iter_Free(ServerGasCan);
	gasInfo[i][gID] = i; 
	gasInfo[i][gBizID] = id; 
	gasInfo[i][gX] = x; 
	gasInfo[i][gY] = y; 
	gasInfo[i][gZ] = z; 
	gasInfo[i][gFull] = fuel;
	updateGasCan(i);
	SCMf(playerid, COLOR_GOLD, "* Ai adaugat un nou gascan (id %d | %.1f procentaj | biz id %d) de combustibil. Acum acesta este valabil pentru jucatori.", gasInfo[i][gID], gasInfo[i][gFull], gasInfo[i][gBizID]);
	update("INSERT INTO `server_gascan` (`BizID`, `X`, `Y`, `Z`, `Full`) VALUES ('%d', '%.2f', '%.2f', '%.2f', '%.2f')", id, x, y, z, fuel);
	return true;
}

CMD:fill(playerid, params[]) {
	SCM(playerid, -1, "debug fill by vicentzo #1");
	if(!IsPlayerInAnyVehicle(playerid)) return SCM(playerid, COLOR_ERROR, "[ERROR] {FFFFFF}Trebuie sa fi intr-un vehicul pentru a face acest lucru."); 
	extract params -> new Float:full; else return sendPlayerSyntax(playerid, "/fill <gas procent>");
	SCM(playerid, -1, "debug fill by vicentzo #2");
	if(playerInfo[playerid][areaGascan] != 0 && IsPlayerInRangeOfPoint(playerid, 3.5, gasInfo[playerInfo[playerid][areaGascan]][gX], gasInfo[playerInfo[playerid][areaGascan]][gY], gasInfo[playerInfo[playerid][areaGascan]][gZ])) {
		if(full + vehicle_fuel[GetPlayerVehicleID(playerid)] >= 100.0) return SCM(playerid, COLOR_ERROR, "[ERROR] {FFFFFF}Acest vehicul are rezervorul plin.");
		new Float:procent = 100.0 - vehicle_fuel[GetPlayerVehicleID(playerid)];
		SCM(playerid, -1, "debug fill by vicentzo #3");
		if(!PlayerMoney(playerid, 10 * 250)) return SCM(playerid, COLOR_ERROR, "[ERROR] {FFFFFF}Nu ai destui bani pentru a face acest lucru.");
		if(gasInfo[playerInfo[playerid][areaGascan]][gFull] < procent) return SCM(playerid, COLOR_ERROR, "[ERROR] {FFFFFF}Aceasta benzinarie nu detine procentajul necesar de combustibil");
		TogglePlayerControllable(playerid, 0);
		defer gasTimer(playerid, 10 * 250);
		SCM(playerid, -1, "debug fill by vicentzo #4");
		GameTextForPlayer(playerid, "Waiting for refuel...", 10000, 1);
	}
	SCM(playerid, -1, "debug fill by vicentzo #5");
	return true;
}

timer gasTimer[10000](playerid, procent) {
	vehicle_fuel[GetPlayerVehicleID(playerid)] += procent;
	if(vehicle_personal[GetPlayerVehicleID(playerid)] > -1) personalVehicle[vehicle_personal[GetPlayerVehicleID(playerid)]][pvFuel] += procent;
	gasInfo[playerInfo[playerid][areaGascan]][gFull] -= procent;
	TogglePlayerControllable(playerid, 1);
	GivePlayerCash(playerid, 0, procent * 250);
	SCMf(playerid, COLOR_LIGHTRED, "* (Gas): {ffffff}Ti-ai facut plinul la vehicul si ai platit $%s pentru %.1f.", formatNumber(procent), procent);
	return true;
}