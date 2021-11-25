CMD:inventory(playerid, params[]) {
	for(new i = 0; i < sizeof Inventory_BG; i++) TextDrawShowForPlayer(playerid, Inventory_BG[i]);
	for(new i = 0; i < sizeof Inventory_BTN; i++) PlayerTextDrawShow(playerid, Inventory_BTN[i]);
	SelectTextDraw(playerid, COLOR_GREY);

	return 1;
}
CMD:inventory2(playerid, params[]) {
	for(new i = 0; i < sizeof Inventory_BG; i++) TextDrawHideForPlayer(playerid, Inventory_BG[i]);
	for(new i = 0; i < sizeof Inventory_BTN; i++) PlayerTextDrawHide(playerid, Inventory_BTN[i]);
	CancelSelectTextDraw(playerid);

	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid) {
    if(clickedid == Inventory_BG[9]) {
		for(new i = 0; i < sizeof Inventory_BG; i++) TextDrawHideForPlayer(playerid, Inventory_BG[i]);
		for(new i = 0; i < sizeof Inventory_BTN; i++) PlayerTextDrawHide(playerid, Inventory_BTN[i]);
		CancelSelectTextDraw(playerid);
    	return 1;
    }	
    return 1;
}