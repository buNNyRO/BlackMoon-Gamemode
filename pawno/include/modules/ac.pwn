// Dialog Higher GT
// Anti teleport foot
// Anti teleport mark
// Anti crasher
#include <YSI\y_hooks>

new Float:acVelocity[MAX_PLAYERS][3],
    acTime[MAX_PLAYERS],
    acTimeCrash[MAX_PLAYERS],
	acDialog[MAX_PLAYERS];

hook resetVars(playerid) { acDialog[playerid] = -1; return 1;}

function ShowPlayerDialogEx(playerid, dialogid, style, caption[], info[], button1[], button2[]) {
    ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2);
	acDialog[playerid] = dialogid;
    return 1;
}

stock TrollDetect(playerid){
	new Float:Velocity[3];
    GetPlayerVelocity(playerid, Velocity[0], Velocity[1], Velocity[2]);
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
        if(playerInfo[playerid][pFlymode] == false) {
   			GetPlayerVelocity(playerid, Velocity[0], Velocity[1], Velocity[2]);
            new Float:amount = Velocity[0]-acVelocity[playerid][0],
            Float:amount2 = Velocity[1]-acVelocity[playerid][1];
            if(amount > 3.0 || amount < -4.0 || amount2  > 10.0 || amount2 < -10.0 || Velocity[2] == 0.100000) { 
                va_SendClientMessageToAll(COLOR_LIGHTRED, "(AC) %s a primit kick pentru 'Troll Hack #1'.", getName(playerid));
                SendDiscordAC("%s a primit kick pentru **'Troll Hack #1'**", getName(playerid));
                Kick(playerid);
            }
        }
        GetPlayerVelocity(playerid, acVelocity[playerid][0], acVelocity[playerid][1], acVelocity[playerid][2]);
    }
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
    	GetPlayerVelocity(playerid, Velocity[0], Velocity[1], Velocity[2]);
        if(Velocity[1] == -90.000000 && Velocity[2] == 0.100000) { 
            va_SendClientMessageToAll(COLOR_LIGHTRED, "(AC) %s a primit kick pentru 'FlyMode'.", getName(playerid));
            SendDiscordAC("%s a primit kick pentru **'FlyMode'**", getName(playerid));
            Kick(playerid); 
        }
    }
    if(GetPlayerCameraMode(playerid) == 53) {
        GetPlayerCameraPos(playerid, Velocity[0], Velocity[1], Velocity[2]);
        if(Velocity[2] < -50000.0 || Velocity[2] > 50000.0) {
            va_SendClientMessageToAll(COLOR_LIGHTRED, "(AC) %s a primit kick pentru 'Weapon Crash'.", getName(playerid));
            SendDiscordAC("%s a primit kick pentru **'Weapon Crash'**", getName(playerid));
            Kick(playerid); 
            return 0;
        }
    }
    return 1;
}

// task xtest[750]() {
//     foreach(new playerid : loggedPlayers) TrollDetect(playerid);
// }

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if(newstate == PLAYER_STATE_DRIVER) {
        if(oldstate == PLAYER_STATE_PASSENGER) {
            va_SendClientMessageToAll(COLOR_LIGHTRED, "(AC) %s a primit kick pentru 'Vehicle Jacker'.", getName(playerid));
            SendDiscordAC("%s a primit kick pentru **'Vehicle Jacker'**", getName(playerid));
            Kick(playerid);
            return 1;
        }
        if(GetTickCount() < acTime[playerid]) {
            va_SendClientMessageToAll(COLOR_LIGHTRED, "(AC) %s a primit kick pentru 'Troll Hack'.", getName(playerid));
            SendDiscordAC("%s a primit kick pentru **'Troll Hack'**", getName(playerid));
            Kick(playerid);
            return 1;
        }
        acTime[playerid] = GetTickCount()+500;
    }
    if(oldstate == PLAYER_STATE_DRIVER) print("a fost inveh");
	return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
    if(GetTickCount() < acTimeCrash[playerid]) {
        va_SendClientMessageToAll(COLOR_LIGHTRED, "(AC) %s a primit kick pentru 'Crasher #1'.", getName(playerid));
        SendDiscordAC("%s a primit kick pentru **'Crasher #1'**", getName(playerid));
        Kick(playerid);
        return 1;
    }
    acTimeCrash[playerid] = GetTickCount()+500;    
    if(IsPlayerInAnyVehicle(playerid) && !playerInfo[playerid][pAdmin]) {
        va_SendClientMessageToAll(COLOR_LIGHTRED, "(AC) %s a primit kick pentru 'Crasher #2'.", getName(playerid));
        SendDiscordAC("%s a primit kick pentru **'Crasher #2'**", getName(playerid));
        Kick(playerid);
    }
    return 1;
}

public OnPlayerUpdate(playerid) {
    TrollDetect(playerid);
    return 1;
}