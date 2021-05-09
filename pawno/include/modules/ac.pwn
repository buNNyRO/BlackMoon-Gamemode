// Dialog Higher GT
// Anti teleport foot
// Anti teleport mark
// Anti crasher
#include <YSI\y_hooks>

new Float:acVelocity[MAX_PLAYERS][3],
	acTime[MAX_PLAYERS],
	acDialog[MAX_PLAYERS];

hook resetVars(playerid) { acDialog[playerid] = -1; return 1;}

function ShowPlayerDialogEx(playerid, dialogid, style, caption[], info[], button1[], button2[]) {
    ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2);
	acDialog[playerid] = dialogid;
    return 1;
}

stock TrollDetect(playerid, hack=0){
	new Float:Velocity[3];
    // SendClientMessage(playerid, -1, string_fast("%f, %f, %f",Velocity[0], Velocity[1], Velocity[2]));
    if(hack == 1) { printf("%s debug troll veh ac!", getName(playerid)); Kick(playerid); }
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
        if(playerInfo[playerid][pFlymode] == false) {
   			GetPlayerVelocity(playerid, Velocity[0], Velocity[1], Velocity[2]);
            new Float:amount = Velocity[0]-acVelocity[playerid][0],
            Float:amount2 = Velocity[1]-acVelocity[playerid][1];
            if(amount > 3.0 || amount < -4.0 || amount2  > 10.0 || amount2 < -10.0 || Velocity[2] == 0.100000) { printf("%s debug2 ac!",getName(playerid)); Kick(playerid); }
        }
        GetPlayerVelocity(playerid, acVelocity[playerid][0], acVelocity[playerid][1], acVelocity[playerid][2]);
    }
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
    	GetPlayerVelocity(playerid, Velocity[0], Velocity[1], Velocity[2]);
        if(Velocity[1] == -90.000000 && Velocity[2] == 0.100000) { printf("%s da cu hacku!",getName(playerid)); Kick(playerid); }
    }
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if(newstate == PLAYER_STATE_DRIVER) {
        acTime[playerid] = gettime()+1;
        printf("%d", acTime[playerid]);
    }
    if(oldstate == PLAYER_STATE_DRIVER) {
        printf("%d si gettime = %d", acTime[playerid], gettime());
        if(acTime[playerid] > gettime()) { printf("%s lasa ceatu ratatulee!",getName(playerid)); Kick(playerid); }
    }
	return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
    if(IsPlayerInAnyVehicle(playerid)) return TrollDetect(playerid, 1);
    return 1;
}
// public OnPlayerUpdate(playerid) {
//     TrollDetect(playerid);
//     return 1;
// }