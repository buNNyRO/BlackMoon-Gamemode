function InsertEmail(playerid, const from[], const text[], type) {
 	update("INSERT INTO `panel_notifications` (`UserID`, `From`, `Text`, `Type`) VALUES('%d', '%s', '%s', '%d')", playerInfo[playerid][pSQLID], from, text, type);
   	if(isPlayerLogged(playerid)) SCM(playerid, COLOR_GOLD, "(*) You have unread email(s). Use /emails to read it. (*)");
   	return true;
} 

function ShowEmails(playerid) {
	if(!cache_num_rows()) return true;
	new text[144], from[MAX_PLAYER_NAME], date[64], id=0;
	gString[0] = (EOS);
	strcat(gString, "#. Email\tBy\tDate\n");
	for(new i = 0; i < cache_num_rows(); i++) {
		id++;
		cache_get_value_name(i, "Text", text, 144);
		cache_get_value_name(i, "From", from, MAX_PLAYER_NAME);
		cache_get_value_name(i, "Date", date, 64);
		playerInfo[playerid][pSelectedItem] = id;
		format(gString, sizeof gString, "%s%d. %s\t%s\t%s\n", gString, id, text, from, date);
	}
	Dialog_Show(playerid, DIALOG_EMAILS, DIALOG_STYLE_TABLIST_HEADERS, "Emails", gString, "Select", "Cancel");
	return true;
}

function CalculateEmails(playerid) {
    if(cache_num_rows()) return SCM(playerid, COLOR_GOLD, "(*) You have unread email(s). Use /emails to read it. (*)");
    return 1;
}

Dialog:DIALOG_EMAILS(playerid, response, listitem) {
	if(!response) return true;
	mysql_tquery(SQL, string_fast("SELECT * FROM `panel_notifications` WHERE `ID`='%s' AND `UserID` = '%d' LIMIT 1", playerInfo[playerid][pSelectedItem], playerInfo[playerid][pSQLID]), "showEmail", "dd", playerid, playerInfo[playerid][pSelectedItem]);
	playerInfo[playerid][pSelectedItem] = -1;
	return true;
}

function showEmail(playerid, id) {
	new text[144], from[MAX_PLAYER_NAME], date[30];
	cache_get_value_name(0, "Text", text, 144);
	cache_get_value_name(0, "From", from, MAX_PLAYER_NAME);
	cache_get_value_name(0, "Date", date, 30);	
	Dialog_Show(playerid, DIALOG_EMAIL2, DIALOG_STYLE_MSGBOX, string_fast("Email #%d", id), "%s\nFrom: %s\nDate: %s","Ok", "", text, from, date);
	return true;
}

Dialog:DIALOG_EMAILS2(playerid, response, listitem) {
	if(response) return true;		
	update("UPDATE `panel_notifications` SET `Read` = '1' WHERE `ID` = '%d' AND `UserID` = '%d' LIMTI 1", selName[playerid], playerInfo[playerid][pSQLID]);	
	return true;
}

CMD:emails(playerid, params[]) {
	if(Dialog_Opened(playerid)) return sendPlayerError(playerid, "Nu poti face acest lucru deoarece ai un dialog afisat.");
	mysql_tquery(SQL, string_fast("SELECT * FROM `panel_notifications` WHERE `UserID`='%d' ORDER BY `ID` DESC LIMIT 10", playerInfo[playerid][pSQLID]), "ShowEmails", "d", playerid);
	return true;
}

CMD:insertemail(playerid, params[], help) {
	if(playerInfo[playerid][pAdmin] < 6) return sendPlayerError(playerid, "Nu ai acces la aceasta comanda.");
	extract params -> new player:userID, string:text[144]; else return sendPlayerSyntax(playerid, "/insertemail <name/id> <text>");
	if(!isPlayerLogged(userID)) return sendPlayerError(playerid, "Acel player nu este connectat.");
	if(strlen(text) < 1 || strlen(text) > 144) return sendPlayerError(playerid, "Invalid text, min. 1 caracter max. 144 caractere");
	InsertEmail(userID, getName(playerid), text, 0);
	SCMf(playerid, COLOR_SERVER, "* Ai trimis un email catre %s (%d, %d sqlid) text '%s'.", getName(userID), userID, playerInfo[userID][pSQLID], text);
	return true;
}
