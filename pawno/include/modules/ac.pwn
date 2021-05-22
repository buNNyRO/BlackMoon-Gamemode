#include <YSI\y_hooks>

enum enumAC {
    acTime,
    acTimeCrash,
    Float:acVelocity[3],
    Float:acvehPos[3],
    acSpawnTime,
    acCPTime,
    acSpawn
}; new acInfo[MAX_PLAYERS][enumAC];

function acReset(playerid) {
    acInfo[playerid][acTime] = 
    acInfo[playerid][acTimeCrash] =
    acInfo[playerid][acSpawnTime] = 0;
    acInfo[playerid][acSpawn] = 1;

    acInfo[playerid][acVelocity][0] =
    acInfo[playerid][acVelocity][1] =
    acInfo[playerid][acVelocity][2] = 0.0;
    return 1;
}

stock Hacker(playerid){
	new Float:Velocity[3];
    GetPlayerPos(playerid, Velocity[0], Velocity[1], Velocity[2]);
    if(Velocity[0] > 20010.0 || Velocity[1] > 20010.0 || Velocity[2] > 1010.0 && GetPlayerInterior(playerid) == 0) return acKicked(playerid, "Crasher #3");
    if(Velocity[2] > 2010.0 && GetPlayerInterior(playerid) != 0) return acKicked(playerid, "Crasher #3");
    GetPlayerVelocity(playerid, Velocity[0], Velocity[1], Velocity[2]);
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
        if(playerInfo[playerid][pFlymode] == false) {
   			GetPlayerVelocity(playerid, Velocity[0], Velocity[1], Velocity[2]);
            new Float:amount = Velocity[0]-acInfo[playerid][acVelocity][0],
            Float:amount2 = Velocity[1]-acInfo[playerid][acVelocity][1];
            if(amount > 3.0 || amount < -4.0 || amount2  > 10.0 || amount2 < -10.0 || Velocity[2] == 0.100000) return acKicked(playerid, "Troll Hack #1");
        }
        GetPlayerVelocity(playerid, acInfo[playerid][acVelocity][0], acInfo[playerid][acVelocity][1], acInfo[playerid][acVelocity][2]);
    }
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
    	GetPlayerVelocity(playerid, Velocity[0], Velocity[1], Velocity[2]);
        if(Velocity[1] == -90.000000 && Velocity[2] == 0.100000) return acKicked(playerid, "FlyMode");
    }
    if(GetPlayerCameraMode(playerid) == 53) {
        GetPlayerCameraPos(playerid, Velocity[0], Velocity[1], Velocity[2]);
        if(Velocity[2] < -50000.0 || Velocity[2] > 50000.0) return acKicked(playerid, "Weapon Crash");
    }
    return 1;
}

hook OnPlayerSpawn(playerid) {
    if(acInfo[playerid][acSpawn] < 1 || GetTickCount()-acInfo[playerid][acSpawnTime] < 1000) return acKicked(playerid, "Fake Spawn");
    else acInfo[playerid][acSpawn] = 0;
    return 1;
}

hook OnPlayerDeath(playerid, killerid, reason) {
    printf("#%d %d", killerid, reason);
    if(reason != WEAPON_COLLISION && reason != 255 || killerid != INVALID_PLAYER_ID) return acKicked(playerid, "Fake Death");

    if(acInfo[playerid][acSpawn] < 1) acInfo[playerid][acSpawnTime] = GetTickCount();
    acInfo[playerid][acSpawn] = 1;
    return 1;
}

hook OnPlayerRequestSpawn(playerid) {
    acInfo[playerid][acSpawnTime] = 0;
    acInfo[playerid][acSpawn] = 1;
    return 1;
}

function SpawnPlayerEx(playerid) {
    acInfo[playerid][acSpawnTime] = 0;
    acInfo[playerid][acSpawn] = 1;
    SpawnPlayer(playerid);
    return 1;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
    if(newstate == PLAYER_STATE_DRIVER) {
        if(GetTickCount()-acInfo[playerid][acTimeCrash] < 500) return acKicked(playerid, "Vehicle Jacker #2");
        if(oldstate == PLAYER_STATE_PASSENGER) return acKicked(playerid, "Vehicle Jacker #1");
        if(GetTickCount()-acInfo[playerid][acTime] < 500) return acKicked(playerid, "Troll Hack #2");
        acInfo[playerid][acTime] = GetTickCount()+500;
    }
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid) {
    if(acInfo[playerid][acCPTime]-GetTickCount() < 1000) return acKicked(playerid, "Teleport CP #1");
    acInfo[playerid][acCPTime] = GetTickCount()+1000;
    return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
    va_SendClientMessage(playerid, -1, "%d sexxxx", GetTickCount()-acInfo[playerid][acTimeCrash]);
    new Float:Pos[3];
    GetVehiclePos(vehicleid, Pos[0], Pos[1], Pos[2]);
    if(GetTickCount()-acInfo[playerid][acTimeCrash] < 500 && acInfo[playerid][acvehPos][0] != Pos[0] || acInfo[playerid][acvehPos][1] != Pos[1] || acInfo[playerid][acvehPos][2] != Pos[2]) return acKicked(playerid, "Crasher #1");
    acInfo[playerid][acTimeCrash] = GetTickCount()+500;
    GetVehiclePos(vehicleid, acInfo[playerid][acvehPos][0], acInfo[playerid][acvehPos][1], acInfo[playerid][acvehPos][2]);
    va_SendClientMessage(playerid, -1, "%d seyyyyy", GetTickCount()-acInfo[playerid][acTimeCrash]);
    if(IsPlayerInAnyVehicle(playerid) && !playerInfo[playerid][pAdmin]) return acKicked(playerid, "Crasher #2");
    return 1;
}

public OnPlayerUpdate(playerid) {
    Hacker(playerid);
    return 1;
}

function acKicked(playerid, const motiv[]) {
    va_SendClientMessageToAll(COLOR_LIGHTRED, "(AC) %s a primit kick pentru '%s'.", getName(playerid), motiv);
    printf("(AC) %s a primit kick pentru '%s'.", getName(playerid), motiv);
    SendDiscordAC("%s a primit kick pentru **'%s'**", getName(playerid), motiv);
    //Kick(playerid);
    return 1;
}