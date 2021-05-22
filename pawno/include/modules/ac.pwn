#include <YSI\y_hooks>

enum enumAC {
    acTime,
    acTimeCrash,
    acSpawnTime,
    acCPTime,
    Float:acVelocity[3],
    acVehicleEnter,
    acVehicleEnterKey,
    acSpawn
}; new acInfo[MAX_PLAYERS][enumAC];

function acReset(playerid) {
    acInfo[playerid][acTime] = 
    acInfo[playerid][acTimeCrash] =
    acInfo[playerid][acSpawnTime] = 0;
    acInfo[playerid][acSpawn] = 1;

    acInfo[playerid][acVehicleEnter] = INVALID_VEHICLE_ID;
    return 1;
}

stock Hacker(playerid){
	new Float:Velocity[3];
    GetPlayerPos(playerid, Velocity[0], Velocity[1], Velocity[2]);
    if(playerInfo[playerid][pLastPosX] > 20010.0 || playerInfo[playerid][pLastPosY] > 20010.0 || playerInfo[playerid][pLastPosZ] > 1010.0 && GetPlayerInterior(playerid) == 0) return acKicked(playerid, "Troll Hack #3");
    // if(playerInfo[playerid][pLastPosZ] > 2010.0 && GetPlayerInterior(playerid) != 0) return acKicked(playerid, "Troll Hack #3");
    GetPlayerVelocity(playerid, Velocity[0], Velocity[1], Velocity[2]);
    if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
        if(playerInfo[playerid][pFlymode] == false) {

            if(Velocity[0] <= -0.800000 || Velocity[1] <= -0.800000 || Velocity[2] <= -0.800000) {
                if(GetPlayerAnimationIndex(playerid) == 1008) return acKicked(playerid, "Fly Hack #1");
                if(GetPlayerSurfingVehicleID(playerid) == INVALID_VEHICLE_ID) acKicked(playerid, "Fly Hack #2");
            }

            new Float:amount = Velocity[0]-acInfo[playerid][acVelocity][0],
            Float:amount2 = Velocity[1]-acInfo[playerid][acVelocity][1];
            if(amount > 3.0 || amount < -4.0 || amount2  > 10.0 || amount2 < -10.0 || Velocity[2] == 0.100000) return acKicked(playerid, "Troll Hack #1");
        }
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
        if(GetTickCount()-acInfo[playerid][acTimeCrash] < 500) return acKicked(playerid, "Vehicle Troll #1");
        if(oldstate == PLAYER_STATE_PASSENGER) return acKicked(playerid, "Vehicle Jacker #1");
        if(GetTickCount()-acInfo[playerid][acTime] < 500) return acKicked(playerid, "Troll Hack #2");
        acInfo[playerid][acTime] = GetTickCount()+500;

        if(acInfo[playerid][acVehicleEnter] == INVALID_VEHICLE_ID) return acKicked(playerid, "Vehicle Troll #2");
        acInfo[playerid][acVehicleEnter] = INVALID_VEHICLE_ID;
    }
	return 1;
}

hook OnPlayerEnterCheckpoint(playerid) {
    if(acInfo[playerid][acCPTime]-GetTickCount() < 1000) return acKicked(playerid, "Teleport to CP");

    new Float:distance = GetPlayerDistanceFromPoint(playerid, playerInfo[playerid][pLastPosX], playerInfo[playerid][pLastPosY], playerInfo[playerid][pLastPosZ]);
    if(distance < 15.0 || acInfo[playerid][acCPTime] > GetTickCount()) return acKicked(playerid, "Teleport hack #1");

    acInfo[playerid][acCPTime] = GetTickCount()+1000;
    return 1;
}

hook OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) {
    acInfo[playerid][acVehicleEnter] = vehicleid;

    if(GetTickCount()-acInfo[playerid][acTimeCrash] < 50 && acInfo[playerid][acVehicleEnterKey] != 1) return acKicked(playerid, "Crasher #1");
    acInfo[playerid][acVehicleEnterKey] = 0;
    acInfo[playerid][acTimeCrash] = GetTickCount()+50;
    if(IsPlayerInAnyVehicle(playerid) && !playerInfo[playerid][pAdmin]) return acKicked(playerid, "Crasher #2");
    return 1;
}

function PutPlayerInVehicleEx(playerid, vehicleid, seatid) {
    acInfo[playerid][acVehicleEnter] = vehicleid;
    PutPlayerInVehicle(playerid, vehicleid, seatid);
    return 1;
}

public OnPlayerUpdate(playerid) {
    Hacker(playerid);
    // new Float:Pos[3], veh = GetPlayerVehicleID(playerid);
    // if(IsPlayerInVehicle(playerid, veh)) {
    //     GetVehiclePos(veh, Pos[0], Pos[1], Pos[2]);
    //     va_SendClientMessageToAll(-1, "playerid %d : sec %d id %d | %f,%f,%f", playerid, GetTickCount()-acInfo[playerid][acTimeCrash], veh, Pos[0], Pos[1], Pos[2]);
    // }
    return 1;
}

function acKicked(playerid, const motiv[]) {
    va_SendClientMessageToAll(COLOR_LIGHTRED, "(AC) %s a primit kick pentru '%s'.", getName(playerid), motiv);
    printf("(AC) %s a primit kick pentru '%s'.", getName(playerid), motiv);
    SendDiscordAC("%s a primit kick pentru **'%s'**", getName(playerid), motiv);
    Kick(playerid);
    return 1;
}