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

// if(GetPlayerCameraMode(playerid) == 53) {
//         new Float: x, Float: y, Float: z;
//         GetPlayerCameraPos(playerid, x, y, z);
//         if(z < -50000.0 || z > 50000.0) {
//             AdmBot(playerid, "possible weapon crash #3");
//             return 0;
//         }
//     }

stock TrollDetect(playerid, hack=0){
    new Float:Velocity[3];
    // SendClientMessage(playerid, -1, string_fast("%f, %f, %f",Velocity[0], Velocity[1], Velocity[2]));
    if(hack == 1) { sendAdmin(COLOR_ADMINCHAT, "%s debug troll veh ac!", getName(playerid)); Kick(playerid); }
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
        if(playerInfo[playerid][pFlymode] == false) {
            GetPlayerVelocity(playerid, Velocity[0], Velocity[1], Velocity[2]);
            new Float:amount = Velocity[0]-acVelocity[playerid][0],
            Float:amount2 = Velocity[1]-acVelocity[playerid][1];
            if(amount > 3.0 || amount < -4.0 || amount2  > 10.0 || amount2 < -10.0 || Velocity[2] == 0.100000) { sendAdmin(COLOR_ADMINCHAT, "%s debug2 ac!",getName(playerid)); Kick(playerid); }
        }
        GetPlayerVelocity(playerid, acVelocity[playerid][0], acVelocity[playerid][1], acVelocity[playerid][2]);
    }
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
        GetPlayerVelocity(playerid, Velocity[0], Velocity[1], Velocity[2]);
        if(Velocity[1] == -90.000000 && Velocity[2] == 0.100000) { sendAdmin(COLOR_ADMINCHAT, "%s da cu hacku!",getName(playerid)); Kick(playerid); }
    }
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) {
        va_SendClientMessage(playerid, -1, "%d,%d si time %d din %d", newstate, oldstate, acTime[playerid], gettime());
        if(acTime[playerid] != 0 && acTime[playerid] < gettime()) { sendAdmin(COLOR_ADMINCHAT, "%s lasa ceatu ratatulee!",getName(playerid)); Kick(playerid); }
        acTime[playerid] = gettime()+1;
    }
    return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
    if(IsPlayerInAnyVehicle(playerid)) return TrollDetect(playerid, 1);
    return 1;
}
public OnPlayerUpdate(playerid) {
    TrollDetect(playerid);
    printf("%d", GetPlayerCameraMode(playerid));
    return 1;
}