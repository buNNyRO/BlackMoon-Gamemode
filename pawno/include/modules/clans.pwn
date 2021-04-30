#include <YSI\y_hooks>

#define MAX_CLANS 30

enum clanInfoEnum {
	cID,
	cOwnerID,
	cName[MAX_PLAYER_NAME],
	cTag[16],
	cClanColor[32],
	cMotd[128],
	cRank1[32],
	cRank2[32],
	cRank3[32],
	cRank4[32],
	cRank5[32],
	cRank6[32],
	cRank7[32],
	cDays,
	cSlots,
	cTotal
};
new clanInfo[MAX_CLANS][clanInfoEnum], Iterator:ServerClans<MAX_CLANS>, Iterator:TotalClanMembers<MAX_PLAYERS>, clanInvitedBy[MAX_PLAYERS], clanChat[MAX_CLANS];

hook OnPlayerConnect(playerid) {
	clanInvitedBy[playerid] = -1;
	return true;
}

stock sendClanMessage(cid, color, const message[], va_args<>) {
	if(!Iter_Contains(ServerClans, cid) || !Iter_Count(TotalClanMembers)) return false;
	gString[0] = (EOS);
	va_format(gString, 256, message, va_start<3>);			
	foreach(new id : TotalClanMembers) if(playerInfo[id][pClan] == cid) sendSplitMessage(id, color, gString);
	return true;
}

function LoadClans() {
	if(!cache_num_rows()) return print("Clans: 0 [From Database]");
	for(new i = 1, j = cache_num_rows() + 1; i != j; i++) {	
		Iter_Add(ServerClans, i);
		cache_get_value_name(i - 1, "Tag", clanInfo[i][cTag], 16);
		cache_get_value_name(i - 1, "Color", clanInfo[i][cClanColor], 32);
		cache_get_value_name(i - 1, "Motd", clanInfo[i][cMotd], 128);
	 	new rank[32];
	 	cache_get_value_name(0, "Rank", rank, 32);
		sscanf(rank, "p<|>sssssss", clanInfo[i][cRank1], clanInfo[i][cRank2], clanInfo[i][cRank3], clanInfo[i][cRank4], clanInfo[i][cRank5], clanInfo[i][cRank6], clanInfo[i][cRank7]);
		cache_get_value_name_int(i - 1, "ID", clanInfo[i][cID]);
		cache_get_value_name_int(i - 1, "OwnerID", clanInfo[i][cOwnerID]);		
		cache_get_value_name_int(i - 1, "Days", clanInfo[i][cDays]);
		cache_get_value_name_int(i - 1, "Slots", clanInfo[i][cSlots]);	
		cache_get_value_name_int(i - 1, "Total", clanInfo[i][cTotal]);		
	}
	return printf("Clans: %d [From Database]", Iter_Count(ServerClans));
}

YCMD:cinvite(playerid, params[], help) {
	if(!playerInfo[playerid][pClan]) return sendPlayerError(playerid, "Nu esti intr-un clan pentru a face acest lucru.");
	if(playerInfo[playerid][pClanRank] < 5) return sendPlayerError(playerid, "Nu ai rank-ul 5+ pentru a face acest lucru.");
	if(clanInfo[playerInfo[playerid][pClan]][cTotal] == clanInfo[playerInfo[playerid][pClan]][cSlots]) return sendPlayerError(playerid, "Nu poti invita membrii in clan deoarece nu mai sunt locuri libere.");
	extract params -> new player:userID, string:reason[32]; else return sendPlayerSyntax(playerid, "/cinvite <name/id> <reason>");
	if(userID == playerid) return sendPlayerError(playerid, "Nu poti folosi comanda asupra ta.");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel jucator nu este connectat.");
	if(!ProxDetectorS(5.0, playerid, userID)) return sendPlayerError(playerid, "Nu esti langa acel jucator.");
	if(strlen(reason) < 1 || strlen(reason) > 32) return sendPlayerError(playerid, "Invalid reason, min. 1 caracter max. 32 caractere.");
	SCM(playerid, COLOR_GOLD, string_fast("* (Clan): L-ai invitat pe %s (%d) in clanul tau pe motiv: %s.", getName(userID), userID, reason));
	SCM(userID, COLOR_GOLD, string_fast("* (Clan): Ai fost invitat de %s (%d) in clanul sau pe motiv: %s.", getName(playerid), playerid, reason));
	clanInvitedBy[playerid] = userID;
	clanInvitedBy[userID] = playerid;
	return true;
}

YCMD:clanchat(playerid, params[], help) {
	if(playerInfo[playerid][pClan] == 0) return sendPlayerError(playerid, "Nu esti intr-un clan pentru a face acest lucru.");
	if(clanChat[playerInfo[playerid][pClan]] == 1 && playerInfo[playerid][pClanRank] < 6) return sendPlayerError(playerid, "Chatul clanului a fost oprit.");
	extract params -> new string:result[144]; else return sendPlayerSyntax(playerid, "/clanchat <text>");
	if(faceReclama(result)) return removeFunction(playerid, result);
    if(faceReclama(result)) return Reclama(playerid, result);	
	switch(playerInfo[playerid][pClanRank]) {
		case 1: sendClanMessage(playerInfo[playerid][pClan], clanInfo[playerInfo[playerid][pClan]][cClanColor], "* [CLAN] %s %s (%d): %s", clanInfo[playerInfo[playerid][pClan]][cRank1], getName(playerid), playerid, result);
		case 2: sendClanMessage(playerInfo[playerid][pClan], clanInfo[playerInfo[playerid][pClan]][cClanColor], "* [CLAN] %s %s (%d): %s", clanInfo[playerInfo[playerid][pClan]][cRank2], getName(playerid), playerid, result);
		case 3: sendClanMessage(playerInfo[playerid][pClan], clanInfo[playerInfo[playerid][pClan]][cClanColor], "* [CLAN] %s %s (%d): %s", clanInfo[playerInfo[playerid][pClan]][cRank3], getName(playerid), playerid, result);
		case 4: sendClanMessage(playerInfo[playerid][pClan], clanInfo[playerInfo[playerid][pClan]][cClanColor], "* [CLAN] %s %s (%d): %s", clanInfo[playerInfo[playerid][pClan]][cRank4], getName(playerid), playerid, result);
		case 5: sendClanMessage(playerInfo[playerid][pClan], clanInfo[playerInfo[playerid][pClan]][cClanColor], "* [CLAN] %s %s (%d): %s", clanInfo[playerInfo[playerid][pClan]][cRank5], getName(playerid), playerid, result);
		case 6: sendClanMessage(playerInfo[playerid][pClan], clanInfo[playerInfo[playerid][pClan]][cClanColor], "* [CLAN] %s %s (%d): %s", clanInfo[playerInfo[playerid][pClan]][cRank6], getName(playerid), playerid, result);
		default: sendClanMessage(playerInfo[playerid][pClan], clanInfo[playerInfo[playerid][pClan]][cClanColor], "* [CLAN] %s %s (%d): %s", clanInfo[playerInfo[playerid][pClan]][cRank7], getName(playerid), playerid, result);
	}
	return true;
}

YCMD:leaveclan(playerid, params[], help) {
	if(playerInfo[playerid][pClan] == 0) return sendPlayerError(playerid, "Nu esti intr-un clan pentru a face acest lucru.");
	if(playerInfo[playerid][pClanRank] == 7) return sendPlayerError(playerid, "Nu poti iesi din clan, deoarece ai rank 7.");
	sendClanMessage(playerInfo[playerid][pClan], clanInfo[playerInfo[playerid][pClan]][cClanColor], "* [CLAN] %s a iesit din clan.", getName(playerid));
	SCM(playerid, COLOR_GOLD, "* (Clan): Ai iesit din clan.");
	Iter_Remove(TotalClanMembers, playerid);
	clanInfo[playerInfo[playerid][pClan]][cTotal] --;
	playerInfo[playerid][pClan] = 0;
	playerInfo[playerid][pClanRank] = 0;
	playerInfo[playerid][pClanAge] = 0;
	playerInfo[playerid][pClanWarns] = 0;
	return true;
}

YCMD:clan(playerid, params[], help) {
	if(playerInfo[playerid][pClan] == 0) return sendPlayerError(playerid, "Nu esti intr-un clan pentru a face acest lucru.");
	Dialog_Show(playerid, DIALOG_CLAN, DIALOG_STYLE_LIST, "Clan Menu", "Comenzile Clanului\nMembrii clanului\nTag\nSetari", "Select", "Close");
	return true;
}

Dialog:DIALOG_CLAN(playerid, response, listitem) {
	if(!response) return true;
	switch(listitem) {
		case 0: SCM(playerid, COLOR_GOLD, "* (Clan): Comenzile clanului sunt /clanchat (/c), /leaveclan, /clan, /clanmembers.");
		case 1: SCM(playerid, -1, "* Coming Soon");
		case 2: Dialog_Show(playerid, DIALOG_CLANTAG, DIALOG_STYLE_LIST , "Clan Tag Settings", string_fast("%s\n%s%s\n%s%s", getName(playerid), clanInfo[playerInfo[playerid][pClan]][cTag], getName(playerid), getName(playerid), clanInfo[playerInfo[playerid][pClan]][cTag]), "Select", "Back");
		case 3: Dialog_Show(playerid, DIALOG_CLANSETTINGS, DIALOG_STYLE_LIST, "Clan Settings", "Clan Color\nClan Motd", "Select", "Back");
	}
	return true;
}

Dialog:DIALOG_CLANTAG(playerid, response, listitem) {
	if(!response) return Dialog_Show(playerid, DIALOG_CLAN, DIALOG_STYLE_LIST, "Clan Menu", "Comenzile Clanului\nMembrii clanului\nTag\nSetari", "Select", "Close");
	switch(listitem) {
		case 0:{
			playerInfo[playerid][pClanTag] = 1;
			SetClanTag(playerid);
		}
		case 1:{
			playerInfo[playerid][pClanTag] = 2;
			SetClanTag(playerid);
		}
		case 2:{
			playerInfo[playerid][pClanTag] = 3;
			SetClanTag(playerid);
		}
	}
	return true;
}

function SetClanTag(playerid) {
    switch(playerInfo[playerid][pClanTag]) {
        case 0: SetPlayerName(playerid, string_fast("%s", getName(playerid)));
        case 1: SetPlayerName(playerid, string_fast("%s%s", clanInfo[playerInfo[playerid][pClan]][cTag],getName(playerid)));
        case 2: SetPlayerName(playerid, string_fast("%s%s", getName(playerid),clanInfo[playerInfo[playerid][pClan]][cTag]));
    }
    return true;
}

Dialog:DIALOG_CLANSETTINGS(playerid, response, listitem) {
	if(!response) return Dialog_Show(playerid, DIALOG_CLAN, DIALOG_STYLE_LIST, "Clan Menu", "Comenzile Clanului\nMembrii clanului\nTag\nSetari", "Select", "Close");
	switch(listitem) {
		case 0: Dialog_Show(playerid, DIALOG_CLANSETTINGS1, DIALOG_STYLE_INPUT, "Clan Settings - Colors", "Scrie mai jos codul culorii\nTe poti folosi de anumite website-uri pentru a lua codul culorii", "Ok", "Close");
		case 1: Dialog_Show(playerid, DIALOG_CLANSETTINGS2, DIALOG_STYLE_INPUT, "Clan Settings - Motd", "Scrie mai jos motd-ul pe care doresti sa-l setezi\nMin 1 caracter Max 128 caractere", "Ok", "Close");	
	}	
	return true;
}

Dialog:DIALOG_CLANSETTINGS1(playerid, response, listitem, inputtext[])  {
	if(!response) return true;
	if(strlen(inputtext) <= 0 || strlen(inputtext) > 6) return Dialog_Show(playerid, DIALOG_CLANSETTINGS1, DIALOG_STYLE_INPUT, "Clan Settings - Colors", "Scrie mai jos codul culorii\nTe poti folosi de anumite website-uri pentru a lua codul culorii", "Ok", "Close");
	format(clanInfo[playerInfo[playerid][pClan]][cClanColor], 32, inputtext);
	sendClanMessage(playerInfo[playerid][pClan], clanInfo[playerInfo[playerid][pClan]][cClanColor], "* [CLAN]: %s (%d) a schimbat culoarea clanului.", getName(playerid), playerid);
	update("UPDATE `server_clans` SET `Color` = '%s' WHERE `ID` = '%d' LIMIT 1", clanInfo[playerInfo[playerid][pClan]][cClanColor], clanInfo[playerInfo[playerid][pClan]][cID]);
	return true;
}

Dialog:DIALOG_CLANSETTINGS2(playerid, response, listitem, inputtext[])  {
	if(!response) return true;
	if(strlen(inputtext) < 1 || strlen(inputtext) > 128) return Dialog_Show(playerid, DIALOG_CLANSETTINGS1, DIALOG_STYLE_INPUT, "Clan Settings - Colors", "Scrie mai jos codul culorii\nTe poti folosi de anumite website-uri pentru a lua codul culorii", "Ok", "Close");
	format(clanInfo[playerInfo[playerid][pClan]][cMotd], 128, inputtext);
	sendClanMessage(playerInfo[playerid][pClan], clanInfo[playerInfo[playerid][pClan]][cClanColor], "* [CLAN]: %s (%d) a schimbat motd-ul clanului in '%s'.", getName(playerid), playerid, clanInfo[playerInfo[playerid][pClan]][cMotd]);	
	update("UPDATE `server_clans` SET `Motd` = '%s' WHERE `ID` = '%d' LIMIT 1", clanInfo[playerInfo[playerid][pClan]][cMotd], clanInfo[playerInfo[playerid][pClan]][cID]);
	return true;
}
