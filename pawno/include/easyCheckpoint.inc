#if defined _easyCheckpoints
	#endinput
#endif
#define _easyCheckpoints

#define Checkpoint:%0(%1) \
	forward checkpoint_%0(%1); \
	public checkpoint_%0(%1)

static 
	checkpointName[MAX_PLAYERS][32 char],
	checkpointActive[MAX_PLAYERS],
	checkpointDeelay[MAX_PLAYERS]
;

forward onCheckpointPerformed(playerid, checkpoint[], success);

forward checkpointIsActive(playerid);
public checkpointIsActive(playerid) return (checkpointActive[playerid]);

stock checkpointDestroy(playerid)
{
	checkpointActive[playerid] = 0;
	checkpointName[playerid]{ 0 } = 0;
	return DisablePlayerCheckpoint(playerid);
}

stock checkpointPlace(playerid, checkpoint[], Float: x, Float: y, Float: z, Float: size)
{
	checkpointActive[playerid] = 1;
	SetPlayerCheckpoint(playerid, x, y, z, size);
	strpack(checkpointName[playerid], checkpoint, 32 char);
	return true;
}

stock checkpointGet(playerid) {
	if(!checkpointIsActive(playerid)) return false;
	if(strlen(checkpointName[playerid]) < 1) return false;
	return checkpointName[playerid];
}

public OnPlayerEnterCheckpoint(playerid) {
    if(GetTickCount() < checkpointDeelay[playerid]) {
        va_SendClientMessageToAll(COLOR_LIGHTRED, "(AC) %s a primit kick pentru 'Teleport Checkpoint'.", getName(playerid));
        SendDiscordAC("%s a primit kick pentru **'Teleport Checkpoint'**", getName(playerid));
        Kick(playerid);
        return 1;
    }  
	static func = cellmax;
	if(func == cellmax) func = funcidx("onCheckpointPerformed");
	if(strlen(checkpointName[playerid]) > 0) {
		new string[64];
		strcat(string, "checkpoint_");
		strcat(string, checkpointName[playerid]);
		checkpointDestroy(playerid);

		if((func == -1) || (CallLocalFunction("onCheckpointPerformed", "dsd", playerid, string[11], funcidx(string) != -1))) CallLocalFunction(string, "d", playerid);
	}
    checkpointDeelay[playerid] = GetTickCount()+1000;    
	#if defined ecp_OnPlayerEnterCheckpoint
		return ecp_OnPlayerEnterCheckpoint(playerid);
	#else
		return false;
	#endif
}
#if defined _ALS_OnPlayerEnterCheckpoint
	#undef OnPlayerEnterCheckpoint
#else
	#define _ALS_OnPlayerEnterCheckpoint
#endif
#define OnPlayerEnterCheckpoint ecp_OnPlayerEnterCheckpoint
#if defined ecp_OnPlayerEnterCheckpoint
	forward ecp_OnPlayerEnterCheckpoint(playerid);
#endif