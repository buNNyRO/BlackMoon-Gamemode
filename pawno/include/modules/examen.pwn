CMD:certificate(playerid, params[]) {
	if(!IsPlayerInRangeOfPoint(playerid, 3.5, -322.8313,1025.3314,19.7422)) return SCM(playerid, COLOR_ERROR, eERROR"Nu esti la locul unde iti poti lua certificate.");
	if(playerInfo[playerid][pCertificateStep] > 0) return SCM(playerid, COLOR_ERROR, eERROR"Esti deja intr-un examen pentru un certificat.");
	extract params -> new string:certificate[10]; else {
		SCM(playerid, COLOR_GREY, "* Certificate Available: ADR (For Community Transporter).");
		return sendPlayerSyntax(playerid, "/certificate <certificate>");
	}
	if(strmatch(certificate, "adr")) {
		if(playerInfo[playerid][pCertificate][0] > 0) return SCM(playerid, COLOR_ERROR, eERROR"Ai deja acest certificat.");
		if(!PlayerMoney(playerid, 50000)) return SCM(playerid, COLOR_ERROR, eERROR"Trebuie sa ai minim $50,000 pentru a cumpara certificatul 'ADR'");
		PlayerTextDrawSetString(playerid, examenTD[playerid][8], "Question #1~n~Cu cate placi de culoare portocalie trebuie sa fie dotat un tir?");
		PlayerTextDrawSetString(playerid, examenTD[playerid][10], "a) 2 (1 fata, 1 spate)");
		PlayerTextDrawSetString(playerid, examenTD[playerid][11], "b) 1 doar pe spate");
		PlayerTextDrawSetString(playerid, examenTD[playerid][12], "c) niciuna");
		for(new i = 0; i < 13; i++) PlayerTextDrawShow(playerid, examenTD[playerid][i]);
		SelectTextDraw(playerid, COLOR_LIMEGREEN);
		playerInfo[playerid][pCertificateStep] = 1;
		examen[playerid] = repeat timerExamen(playerid);
		SCM(playerid, COLOR_SERVER, "* (Certificate): {ffffff}Ai intrat in examenul pentru certificatul de 'ADR'.");
	}
	return true;
}
