enum pickInfo {
 	BIZZ,
 	HOUSE,
 	FACTION,
 	JOB,
 	SAFE
};
new PickInfo[MAX_PICKUPS][pickInfo];

public OnPlayerPickUpDynamicPickup(playerid, STREAMER_TAG_PICKUP:pickupid) {
    if(PickInfo[pickupid][BIZZ] != 0) playerInfo[playerid][areaBizz] = PickInfo[pickupid][BIZZ]; 
    if(PickInfo[pickupid][HOUSE] != 0) playerInfo[playerid][areaHouse] = PickInfo[pickupid][HOUSE]; 
    if(PickInfo[pickupid][FACTION] != 0) playerInfo[playerid][areaFaction] = PickInfo[pickupid][FACTION];
    if(PickInfo[pickupid][JOB] != 0) playerInfo[playerid][areaJob] = PickInfo[pickupid][JOB];
    if(PickInfo[pickupid][SAFE] != 0) playerInfo[playerid][areaSafe] = PickInfo[pickupid][SAFE];
    return 1;
}
