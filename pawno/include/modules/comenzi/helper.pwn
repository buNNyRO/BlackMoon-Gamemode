#include <YSI\y_hooks>
new HelperDuty[MAX_PLAYERS], HelperBusy[MAX_PLAYERS], HelperAtribut[MAX_PLAYERS], ConversationOpen[MAX_PLAYERS], QuestionStock[MAX_PLAYERS][144], Timer:helpTimer[MAX_PLAYERS];

hook OnPlayerConnect(playerid) {
	HelperDuty[playerid] = 0;
	HelperBusy[playerid] = -1;
	HelperAtribut[playerid] = -1;
	ConversationOpen[playerid] = 0;
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
	if(reason == 0) {
		SCMf(playerid, COLOR_LIME, "Helperul %s (%d) a tastat /skipn. Se cauta un nou helper", getName(HelperAtribuit), HelperAtribuit);
		SCMf(HelperAtribuit, COLOR_LIME, "Ai sarit peste cererea lui %s (%d).", getName(playerid), playerid);
	}
	else if(reason == 1) {
		SCMf(playerid, COLOR_LIME, "Helperul %s (%d) nu a raspuns in 60 de secunde. Se cauta un nou helper.", getName(HelperAtribuit), HelperAtribuit);
		SCMf(HelperAtribuit, COLOR_LIME, "Nu ai raspuns in 60 de secunde lui %s (%d).", getName(playerid), playerid);
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
			SCMf(playerid, COLOR_LIME, "Cererea ta a fost trimisa catre %s (%d). Asteapta un raspuns.", getName(i), i);
			SCMf(i, COLOR_LIME, "O noua cerere de la %s (%d) (q:%s).", getName(playerid), playerid, QuestionStock[playerid]);
			SCMf(i, COLOR_LIME, "Scrie /ar pentru a accepta. Scrie /skipn pentru a anula. Dupa ce ai terminat scrie /ch.");
			SCMf(i, COLOR_LIME, "Ai 60 de secunde pentru a accepta.");
			
			HelperBusy[i] = playerid;
			HelperAtribut[playerid] = i;
			helpTimer[i] = defer helpnTimer(playerid);
			break;
		}	
	}
	if(gasit == 0) SCM(playerid, COLOR_LIME, "Nici un helper disponibil momentan.");
	return true;
}

timer helpnTimer[60 * 1000](playerid) {
	CautaHelperNou(playerid, 1);
	return true;
}	

CMD:helduty(playerid, params[]) {
	if(!Iter_Contains(ServerHelpers, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	HelperDuty[playerid] = HelperDuty[playerid] ? 0 : 1;
	sendHelper(COLOR_ADMINCHAT, "(Helper System): Helper %s is now %s", getName(playerid), HelperDuty[playerid] ? "on-duty" : "off-duty");
	return true;
}

CMD:n(playerid, params[])
{
	if(HelperAtribut[playerid] != -1) return sendPlayerError(playerid, "Ai deja un helper atribuit.");
	extract params -> new string:message[144]; else return sendPlayerSyntax(playerid, "/n <message>");
	QuestionStock[playerid] = message;
	CautaHelper(playerid);
	return 1;
}

CMD:ar(playerid, params[])
{
	if(!Iter_Contains(ServerHelpers, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(HelperBusy[playerid] == -1) return sendPlayerError(playerid, "Nu ai atribuit nici un jucator.");
	if(ConversationOpen[playerid] == 1) return sendPlayerError(playerid, "Ai acceptat deja cererea.");
	ConversationOpen[playerid] = 1;
	SCMf(HelperBusy[playerid], COLOR_LIME, "(Help Question): {ffffff}Cererea ta a fost acceptata, poti vorbii prin /hl.");
	SCMf(playerid, COLOR_LIME, "(Help Question): {ffffff}Ai acceptat cererea.");
	return 1;
}

CMD:ch(playerid, params[])
{
	if(!Iter_Contains(ServerHelpers, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(HelperBusy[playerid] == -1) return sendPlayerError(playerid, "Nu ai atribuit nici un jucator.");
	extract params -> new string:message[144]; else return sendPlayerSyntax(playerid, "/ch <reason>");
	new playerAtribut = HelperBusy[playerid];
	if(ConversationOpen[playerid] == 0) {
		va_SendClientMessageToAll(COLOR_LIME, "(* Newbie *) %s (%d) intreaba: %s", getName(playerAtribut), playerAtribut, QuestionStock[playerAtribut]);
		va_SendClientMessageToAll(COLOR_LIME, "(* Helper *) %s (%d) a raspuns: %s", getName(playerid), playerid, message);	
		HelperBusy[playerid] = -1;
		HelperAtribut[playerAtribut] = -1;	
	}
	else if(ConversationOpen[playerid] == 1) {
		SCMf(playerAtribut, COLOR_LIME, "Helperul %s (%d) a inchis conversatia cu tine. Mesaj: %s", getName(playerid), playerid, message);
		SCMf(playerid, COLOR_LIME, "Ai inchis conversatia cu %s (%d). Mesaj: %s", getName(playerAtribut), playerAtribut, message);	
		HelperBusy[playerid] = -1;
		HelperAtribut[playerAtribut] = -1;
		ConversationOpen[playerid] = 0;
		stop helpTimer[playerid];
	}
	return 1;
}

CMD:hl(playerid, params[])
{
	if(HelperBusy[playerid] == -1 && playerInfo[playerid][pHelper] > 0) return sendPlayerError(playerid, "Niciun jucator nu ti-a fost atribuit.");
	if(HelperAtribut[playerid] == -1 && playerInfo[playerid][pHelper] == 0) return sendPlayerError(playerid, "Niciun helper nu ti-a fost atribuit.");
	if(playerInfo[playerid][pHelper] == 0 && ConversationOpen[HelperAtribut[playerid]] == 0) return sendPlayerError(playerid, "Helperul nu a deschis conversatia cu tine.");
	if(playerInfo[playerid][pHelper] > 0 && ConversationOpen[playerid] == 0) return sendPlayerError(playerid, "Nu ai deschis prin /ar conversatia cu jucatorul.");
	extract params -> new string:message[144]; else return sendPlayerSyntax(playerid, "/hl <message>");
	switch(playerInfo[playerid][pHelper]) {
		case 0: {
			new HelperAtribuit = HelperAtribut[playerid];
			SCMf(playerid, COLOR_LIME, "Jucator %s (%d): %s", getName(playerid), playerid, message);
			SCMf(HelperAtribuit, COLOR_LIME, "Jucator %s (%d): %s", getName(playerid), playerid, message);
		}
		case 1..3: {
			new jucatorAtribuit = HelperBusy[playerid];
			SCMf(playerid, COLOR_LIME, "Helper %s (%d): %s", getName(playerid), playerid, message);
			SCMf(jucatorAtribuit, COLOR_LIME, "Helper %s (%d): %s", getName(playerid), playerid, message);
		}
	}
	return 1;
}

CMD:skipn(playerid, params[])
{
	if(!Iter_Contains(ServerHelpers, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	if(HelperBusy[playerid] == -1) return sendPlayerError(playerid, "Nu ai atribuit nici un jucator.");
	CautaHelperNou(HelperBusy[playerid], 0);
	return 1;
}

CMD:deletead(playerid, params[]) {
	if(!Iter_Contains(ServerHelpers, playerid) && !Iter_Contains(ServerAdmins, playerid)) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	extract params -> new player:deletePlayer, string:reason[32]; else return sendPlayerSyntax(playerid, "/deletead <name/id> <reason>");
	if(strlen(reason) < 1 || strlen(reason) > 32) return sendPlayerError(playerid, "Reason invalid.");
	if(AdTimer[deletePlayer] == 0) return sendPlayerError(playerid, "Acel player nu are un ad.");
	AdText[deletePlayer] = "";
	AdTimer[deletePlayer] = 0;
	SCMf(deletePlayer, COLOR_GREY, "* AD Notice: Ad-ul tau a fost sters de %s (%d), motiv: %s.", getName(playerid), playerid, reason);
	sendStaff(COLOR_SERVER, "Notice: {ffffff}%s a sters ad-ul lui %s, motiv: %s.", getName(playerid), getName(deletePlayer), reason);	
	return true;
}