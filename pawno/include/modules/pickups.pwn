#include <YSI\y_hooks>

enum pickInfo {
 	BIZZ,
 	HOUSE,
 	GASCAN,
 	FACTION,
 	JOB
};
new PickInfo[MAX_PICKUPS][pickInfo];

public OnPlayerPickUpDynamicPickup(playerid, STREAMER_TAG_PICKUP:pickupid) {
    if(PickInfo[pickupid][BIZZ] != 0) playerInfo[playerid][areaBizz] = PickInfo[pickupid][BIZZ];
    if(PickInfo[pickupid][HOUSE] != 0) playerInfo[playerid][areaHouse] = PickInfo[pickupid][HOUSE];
    if(PickInfo[pickupid][GASCAN] != 0) playerInfo[playerid][areaGascan] = PickInfo[pickupid][GASCAN]; 
    if(PickInfo[pickupid][FACTION] != 0) playerInfo[playerid][areaFaction] = PickInfo[pickupid][FACTION];
    if(PickInfo[pickupid][JOB] != 0) playerInfo[playerid][areaJob] = PickInfo[pickupid][JOB];
    return 1;
}
