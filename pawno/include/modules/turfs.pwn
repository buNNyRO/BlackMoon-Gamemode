#include <YSI\y_hooks>

enum turfsEnum {
	tID,
	tOwned,
	Float:tMinX,
	Float:tMaxX,
	Float:tMinY,
	Float:tMaxY
};
new turfInfo[MAX_TURFS][turfsEnum], Iterator:ServerTurfs<MAX_TURFS>;


enum warInfoEnum {
    wFaction, 
    wAttacker,
    wTime
};

new warInfo[sizeof(turfInfo)][warInfoEnum], Float: WarScore[3][sizeof(turfInfo)], Float:WarScore2[MAX_PLAYERS][sizeof(turfInfo)], ucideri[MAX_PLAYERS][sizeof(turfInfo)], decese[MAX_PLAYERS][sizeof(turfInfo)], InWar[10];

function LoadTurfs() {
	if(!cache_num_rows()) return print("Turfs: 0 [From Database]");
	for(new i = 1, j = cache_num_rows() + 1; i != j; i++) {	
		cache_get_value_name_int(i, "ID", turfInfo[i][tID]);
		cache_get_value_name_int(i, "Owned", turfInfo[i][tOwned]);
		cache_get_value_name_float(i, "MinX", turfInfo[i][tMinX]);
		cache_get_value_name_float(i, "MaxX", turfInfo[i][tMaxX]);
		cache_get_value_name_float(i, "MinY", turfInfo[i][tMinY]);
		cache_get_value_name_float(i, "MaxY", turfInfo[i][tMaxY]);
		Iter_Add(ServerTurfs, i);
		turfInfo[i][tID] = GangZoneCreateEx(turfInfo[i][tMinX], turfInfo[i][tMinY], turfInfo[i][tMaxX], turfInfo[i][tMaxY], turfInfo[i][tID], 1.0);
	}
	return printf("Turfs: %d [From Database]", Iter_Count(ServerTurfs));
}

CMD:turfs(playerid, params[]) {
	if(!isPlayerLogged(playerid)) return SCM(playerid, COLOR_ERROR, "[ERROR] {FFFFFF}Trebuie sa fi logat pentru a folosi aceasta comanda.");
	if(playerInfo[playerid][pShowTurfs] == 0) {
		playerInfo[playerid][pShowTurfs] = 1;
		for(new i = 0; i < Iter_Count(ServerTurfs); i++) {
			switch(turfInfo[i][tOwned]) {
				case 8: GangZoneShowForPlayerEx(playerid, turfInfo[i][tID], 0x0CAB3C99); 
				case 9: GangZoneShowForPlayerEx(playerid, turfInfo[i][tID], 0xc22da999); 
			}
		}
		SCM(playerid, COLOR_GREY, "* Turfs: Ai activat optiunea de a vizualiza turfurile.");
	} 
	else {
		playerInfo[playerid][pShowTurfs] = 0;
		for(new i = 0; i < Iter_Count(ServerTurfs); i++) GangZoneHideForPlayerEx(playerid, turfInfo[i][tID]);
		SCM(playerid,  COLOR_GREY, "* Turfs: Ai dezactivat optiunea de a vizualiza turfurile.");
	}
	return true;
}