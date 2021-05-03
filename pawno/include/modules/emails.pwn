function InsertEmail(playerid, const from[], const text[], type) {
 	update("INSERT INTO `panel_notifications` (`UserID`, `From`, `Notification`, `Type`) VALUES('%d', '%s', '%s', '%d')", playerInfo[playerid][pSQLID], from, text, type);
   	if(isPlayerLogged(playerid)) SCM(playerid, COLOR_GOLD, "(*) You have unread email(s). Use /emails to read it. (*)");
   	return true;
} 

CMD:emails(playerid, params[]) {
	if(Dialog_Opened(playerid)) return sendPlayerError(playerid, "Nu poti face acest lucru deoarece ai un dialog afisat.");
	mysql_tquery(SQL, string_fast("SELECT `Text`, `From`, `Date` WHERE `panel_notifications`.`UserID` = '%d' ORDER BY `panel_notifications`.`ID` DESC LIMIT 10", playerInfo[playerid][pSQLID]), "ShowEmails", "");
	return true;
}

function ShowEmails(playerid) {
	if(!cache_num_rows()) return true;
	new text[144], from[MAX_PLAYER_NAME], date[64];
	gString[0] = (EOS);
	strcat(gString, "#. Email\tBy\tDate\n");
	for(new i = 1; i < cache_num_rows() +1; i++) {
		cache_get_value_name(i, "Text", text, 144);
		cache_get_value_name(i, "From", from, MAX_PLAYER_NAME);
		cache_get_value_name(i, "Date", date, 64);
		format(Selected[playerid][i], 144, text);
		strcat(gString, string_fast("%d. %s\t%s\t%s\n", i, text, from, date));
	}
	Dialog_Show(playerid, DIALOG_EMAILS, DIALOG_STYLE_TABLIST_HEADERS, "Emails", gString, "Select", "Cancel");
	return true;
}

Dialog:DIALOG_EMAILS(playerid, response, listitem) {
	if(!response) return true;
	format(selName[playerid], 30, Selected[playerid][listitem]);		
	new text[144], from[MAX_PLAYER_NAME], date[64], Cache: result = mysql_query(SQL, string_fast("SELECT * FROM `panel_notifications` WHERE `ID`='%s' AND `UserID` = '%d'", selName[playerid], playerInfo[playerid][pSQLID]));
	cache_get_value_name(0, "Text", text, 144);
	cache_get_value_name(0, "From", from, MAX_PLAYER_NAME);
	cache_get_value_name(0, "Date", date, 64);							
	Dialog_Show(playerid, DIALOG_EMAILS2, DIALOG_STYLE_MSGBOX, string_fast("Email #%d", selName[playerid]), string_fast("%s\nFrom: %s\nDate: %s", text, from, date), "Ok", "");
	cache_delete(result);
	return true;
}

Dialog:DIALOG_EMAILS2(playerid, response, listitem) {
	if(response) return true;		
	update("UPDATE `panel_notifications` SET `Read` = '1' WHERE `ID` = '%d' AND `UserID` = '%d'", selName[playerid], playerInfo[playerid][pSQLID]);	
	return true;
}

function CalculateEmails(playerid) {
    if(cache_num_rows()) return SCM(playerid, COLOR_GOLD, "(*) You have unread email(s). Use /emails to read it. (*)");
    return 1;
}