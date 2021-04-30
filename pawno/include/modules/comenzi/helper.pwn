#include <YSI\y_hooks>
new HelperDuty[MAX_PLAYERS], HelperBusy[MAX_PLAYERS], HelperAtribut[MAX_PLAYERS], ConversationOpen[MAX_PLAYERS], QuestionStock[MAX_PLAYERS][128], Timer:helpTimer[MAX_PLAYERS];


hook OnPlayerConnect(playerid) {
	HelperDuty[playerid] = 0;
	HelperBusy[playerid] = -1;
	HelperAtribut[playerid] = -1;
	ConversationOpen[playerid] = 0;
	helpTimer[playerid] = Timer:-1;
	QuestionStock[playerid] = "None";
	return true;
}

hook OnPlayerDisconnect(playerid, reason) {
	if(helpTimer[playerid] != Timer:-1) {
		stop helpTimer[playerid];
		helpTimer[playerid] = Timer:-1;
	}
	return true;
}
stock CautaHelperNou(playerid, reason)
{
	new HelperAtribuit = HelperAtribut[playerid];
	switch(reason) {
		case 0: {
			SCM(playerid, COLOR_LIME, string_fast("Helperul %s (%d) a tastat /skipn. Se cauta un nou helper", getName(HelperAtribuit), HelperAtribuit));
			SCM(HelperAtribuit, COLOR_LIME, string_fast("Ai sarit peste cererea lui %s (%d).", getName(playerid), playerid));
		}
		case 1: {
			SCM(playerid, COLOR_LIME, string_fast("Helperul %s (%d) nu a raspuns in 30 de secunde. Se cauta un nou helper.", getName(HelperAtribuit), HelperAtribuit));
			SCM(HelperAtribuit, COLOR_LIME, string_fast("Nu ai raspuns in 30 de secunde lui %s (%d).", getName(playerid), playerid));
		}
	}	
	CautaHelper(playerid);
	HelperBusy[HelperAtribuit] = -1;
	HelperAtribut[playerid] = -1;
}

stock CautaHelper(playerid)
{
	new gasit = 0;
	foreach(new i : ServerHelpers)
	{
		if(HelperDuty[i] == 1 && HelperBusy[i] == -1 && ConversationOpen[i] == 0)
		{
			gasit = 1;
			SCM(playerid, COLOR_LIME, string_fast("Cererea ta a fost trimisa catre %s (%d). Asteapta un raspuns.", getName(i), i));
			SCM(i, COLOR_LIME, string_fast("O noua cerere de la %s (%d) (q:%s).", getName(playerid), playerid, QuestionStock[playerid]));
			SCM(i, COLOR_LIME,  string_fast("Scrie /ar pentru a accepta. Scrie /skipn pentru a anula. Dupa ce ai terminat scrie /ch."));
			SCM(i, COLOR_LIME,  string_fast("Ai 30 de secunde pentru a accepta."));
			
			HelperBusy[i] = playerid;
			HelperAtribut[playerid] = i;
			helpTimer[i] = defer helpnTimer(playerid);
		}	
		if(gasit == 1) break;
	}
	if(gasit == 0) SCM(playerid, COLOR_LIME, "Nici un helper disponibil momentan.");
}

timer helpnTimer[10 * 1000](playerid) {
	CautaHelperNou(playerid, 1);
	return true;
}	

YCMD:helduty(playerid, params[], help) {
	if(!Iter_Contains(ServerHelpers, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(GetPVarInt(playerid, "helDuty") > gettime())
		return sendPlayerError(playerid, "Trebuie sa astepti %d secunde inainte sa folosesti aceasta comanda.", (GetPVarInt(playerid, "helDuty") - gettime()));
	switch(HelperDuty[playerid]) {
		case 0: {
			HelperDuty[playerid] = 1;
			sendHelper(COLOR_ADMINCHAT, "(Helper System): Helper %s is now duty.", getName(playerid));
			SetPVarInt(playerid, "helDuty", (gettime() + 60));
		}
		case 1: {
			HelperDuty[playerid] = 0;
			sendHelper(COLOR_ADMINCHAT, "(Helper System): Helper %s is now off-duty.", getName(playerid));
			SetPVarInt(playerid, "helDuty", (gettime() + 60));
		}
	}
	return true;
}

YCMD:n(playerid, params[], help)
{
	new message[128];
	if(sscanf(params, "s[128]", message)) return sendPlayerSyntax(playerid, "/n <question>");
	if(HelperAtribut[playerid] != -1) return sendPlayerError(playerid, "Ai deja un helper atribuit.");
	QuestionStock[playerid] = message;
	CautaHelper(playerid);
	return 1;
}

YCMD:ar(playerid, params[], help)
{
	new playerAtribut;
	if(!Iter_Contains(ServerHelpers, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(HelperBusy[playerid] == -1) return sendPlayerError(playerid, "Nu ai atribuit nici un jucator.");
	if(ConversationOpen[playerid] == 1) return sendPlayerError(playerid, "Ai acceptat deja cererea.");
	playerAtribut = HelperBusy[playerid];
	ConversationOpen[playerid] = 1;
	SCM(playerAtribut, COLOR_LIME, string_fast("{81e622}(Help Question){ffffff}: Cererea ta a fost acceptata, poti vorbii prin /hl."));
	SCM(playerid, COLOR_LIME, string_fast("{81e622}(Help Question){ffffff}: Ai acceptat cererea."));
	return 1;
}

YCMD:ch(playerid, params[], help)
{
	new message[128];
	if(!Iter_Contains(ServerHelpers, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(HelperBusy[playerid] == -1) return sendPlayerError(playerid, "Nu ai atribuit nici un jucator.");
	if(sscanf(params, "s[128]", message)) return sendPlayerSyntax(playerid, "/ch <reason>");
	
	new playerAtribut = HelperBusy[playerid];
	switch(ConversationOpen[playerid]) {
		case 0: {
			SCM(playerAtribut, COLOR_LIME, string_fast("Helper %s (%d): %s", getName(playerid), playerid, message));
			SendClientMessageToAll(COLOR_BROWN, string_fast("%s (%d) intreaba: %s", getName(playerAtribut), playerAtribut, QuestionStock[playerAtribut]));
			SendClientMessageToAll(COLOR_BROWN, string_fast("%s (%d) a raspuns: %s", getName(playerid), playerid, message));	
			HelperBusy[playerid] = -1;
			HelperAtribut[playerAtribut] = -1;	
		}
		case 1: {
			SCM(playerAtribut, COLOR_LIME, string_fast("{81e622}Helperul %s (%d) a inchis conversatia cu tine. Mesaj: %s", getName(playerid), playerid, message));
			SCM(playerid, COLOR_LIME, string_fast("{81e622}Ai inchis conversatia cu %s (%d). Mesaj: %s", getName(playerAtribut), playerAtribut, message));	
			HelperBusy[playerid] = -1;
			HelperAtribut[playerAtribut] = -1;
			ConversationOpen[playerid] = 0;
		}
	}	
	stop helpTimer[playerid];
	return 1;
}

YCMD:hl(playerid, params[], help)
{
	new message[128];
	if(HelperBusy[playerid] == -1 && playerInfo[playerid][pHelper] > 0) return sendPlayerError(playerid, "Niciun jucator nu ti-a fost atribuit.");
	if(HelperAtribut[playerid] == -1 && playerInfo[playerid][pHelper] == 0) return sendPlayerError(playerid, "Niciun helper nu ti-a fost atribuit.");
	if(playerInfo[playerid][pHelper] == 0 && ConversationOpen[HelperAtribut[playerid]] == 0) return sendPlayerError(playerid, "Helperul nu a deschis conversatia cu tine.");
	if(playerInfo[playerid][pHelper] > 0 && ConversationOpen[playerid] == 0) return sendPlayerError(playerid, "Nu ai deschis prin /ar conversatia cu jucatorul.");
	if(sscanf(params, "s[128]", message)) return sendPlayerSyntax(playerid, "/hl <message>");
	
	gString[0] = (EOS);
	switch(playerInfo[playerid][pHelper]) {
		case 0: {
			new HelperAtribuit = HelperAtribut[playerid];
			SCM(playerid, COLOR_LIME, string_fast("Jucator %s (%d): %s", getName(playerid), playerid, message));
			SCM(HelperAtribuit, COLOR_LIME, string_fast("Jucator %s (%d): %s", getName(playerid), playerid, message));
		}
		case 1,2,3: {
			new jucatorAtribuit = HelperBusy[playerid];
			SCM(playerid, COLOR_LIME, string_fast("Helper %s (%d): %s", getName(playerid), playerid, message));
			SCM(jucatorAtribuit, COLOR_LIME, string_fast("Helper %s (%d): %s", getName(playerid), playerid, message));
		}
	}
	return 1;
}

YCMD:skipn(playerid, params[], help)
{
	new jucatorAtribuit;
	if(!Iter_Contains(ServerHelpers, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(HelperBusy[playerid] == -1) return sendPlayerError(playerid, "Nu ai atribuit nici un jucator.");
	jucatorAtribuit = HelperBusy[playerid];
	CautaHelperNou(jucatorAtribuit, 0);
	return 1;
}

YCMD:deletead(playerid, params[], help) {
	if(!Iter_Contains(ServerHelpers, playerid) && !Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	new deletePlayer, reason[32];
	if(sscanf(params, "us[32]", deletePlayer, reason)) return sendPlayerSyntax(playerid, "/deletead <name/id> <reason>");
	if(strlen(reason) < 1 || strlen(reason) > 32) return sendPlayerError(playerid, "Reason invalid.");
	if(AdTimer[deletePlayer] == 0) return sendPlayerError(playerid, "Acel player nu are un ad.");
	AdText[deletePlayer] = "";
	AdTimer[deletePlayer] = 0;
	SCM(deletePlayer, COLOR_GREY, string_fast("* AD Notice: Ad-ul tau a fost sters de %s (%d), motiv: %s.", getName(playerid), playerid, reason));
	sendStaff(COLOR_SERVER, "Notice: {ffffff}%s a sters ad-ul lui %s, motiv: %s.", getName(playerid), getName(deletePlayer), reason);	
	return true;
}