#include <YSI\y_hooks>
enum dInfo {
	dID, dModel, dPrice, dStock
};
new TestingModel[MAX_PLAYERS], Iterator:serverModelsDS<90>, DSModels[90][dInfo],SelectedCar[MAX_PLAYERS][150], TotalDealerCars[MAX_PLAYERS], DealerCar[MAX_PLAYERS], DealerID[MAX_PLAYERS], DealerCarType[MAX_PLAYERS];

function ShowCamera(playerid) {
	SetPlayerCameraPos(playerid, 1520.1910,-2399.9700,28.2862);
	SetPlayerCameraLookAt(playerid, 1523.7557,-2410.4419,25.5428);
	return true;
}


function ShowDealerShipTD(playerid) {
	if(GetPlayerCash(playerid) < DSModels[SelectedCar[playerid][DealerID[playerid]]][dPrice]) PlayerTextDrawSetString(playerid, serverDealerPTD[playerid][2], string_fast("Price: ~r~$%s~W~~H~~N~Stock: ~R~%d available~W~~H~~N~Max Speed: ~R~%dKM/H", formatNumber(DSModels[SelectedCar[playerid][DealerID[playerid]]][dPrice]), DSModels[SelectedCar[playerid][DealerID[playerid]]][dStock], getVehicleMaxSpeed(DSModels[SelectedCar[playerid][DealerID[playerid]]][dModel])));
	else if(GetPlayerCash(playerid) >= DSModels[SelectedCar[playerid][DealerID[playerid]]][dPrice]) PlayerTextDrawSetString(playerid, serverDealerPTD[playerid][2], string_fast("Price: ~g~$%s~W~~H~~N~Stock: ~R~%d available~W~~H~~N~Max Speed: ~R~%dKM/H", formatNumber(DSModels[SelectedCar[playerid][DealerID[playerid]]][dPrice]), DSModels[SelectedCar[playerid][DealerID[playerid]]][dStock], getVehicleMaxSpeed(DSModels[SelectedCar[playerid][DealerID[playerid]]][dModel])));
	PlayerTextDrawSetString(playerid, serverDealerPTD[playerid][1], string_fast("%s", getVehicleName(DSModels[SelectedCar[playerid][DealerID[playerid]]][dModel])));
	for(new i = 0; i < 3; i++) PlayerTextDrawShow(playerid, serverDealerPTD[playerid][i]);
	for(new i = 0; i < 9; i++) TextDrawShowForPlayer(playerid, serverDealerTD[i]);
	return true;
}

function HideDealerShipTD(playerid) {
	for(new i = 0; i < 3; i++) PlayerTextDrawHide(playerid, serverDealerPTD[playerid][i]);
	for(new i = 0; i < 9; i++) TextDrawHideForPlayer(playerid, serverDealerTD[i]);
	return true;
}

function LoadDSVehicles() {
	if(!cache_num_rows()) return printf("Dealership models: 0 [From Database]");
	for(new i = 1; i <= cache_num_rows(); i++) {
		cache_get_value_name_int(i - 1, "ID", DSModels[i][dID]);				
		cache_get_value_name_int(i - 1, "Model", DSModels[i][dModel]);             
		cache_get_value_name_int(i - 1, "Price", DSModels[i][dPrice]);             
		cache_get_value_name_int(i - 1, "Stock", DSModels[i][dStock]);     
		Iter_Add(serverModelsDS, i);     	
	}
	return printf("Dealership models: %d [From Database]", Iter_Count(serverModelsDS)); 
}

function LoadDsVehs(playerid) {
	for(new i = 0; i <= Iter_Count(serverModelsDS); i++) SelectedCar[playerid][i] = DSModels[i][dID];
	TotalDealerCars[playerid] = Iter_Count(serverModelsDS);
	return true;
}

function InsertCarDS(playerid, model) {
	new idcar = Iter_Free(TotalPlayerVehicles), rand = random(5);
	Iter_Add(TotalPlayerVehicles, idcar);
	Iter_Add(PlayerVehicles[playerid], idcar);	
	personalVehicle[idcar][pvID] = cache_insert_id();
	personalVehicle[idcar][pvOwnerID] = playerInfo[playerid][pSQLID];
	personalVehicle[idcar][pvModelID] = model;
	personalVehicle[idcar][pvColorOne] = 1;
	personalVehicle[idcar][pvColorTwo] = 1;
	personalVehicle[idcar][pvX] = DebugVehicles[rand][0];
	personalVehicle[idcar][pvY] = DebugVehicles[rand][1]; 
	personalVehicle[idcar][pvZ] = DebugVehicles[rand][2];
	personalVehicle[idcar][pvAngle] = DebugVehicles[rand][3];
	personalVehicle[idcar][pvVirtualWorld] = 0;
	personalVehicle[idcar][pvInterior] = 0;
	personalVehicle[idcar][pvFuel] = 100;
	personalVehicle[idcar][pvPaintJob] = -1;
	personalVehicle[idcar][pvLock] = 1;
	personalVehicle[idcar][pvHealth] = 1000;
	personalVehicle[idcar][pvInsurancePoints] = 10;
	personalVehicle[idcar][pvSpawnedID] = INVALID_VEHICLE_ID;
	personalVehicle[idcar][pvDespawnTime] = 0;
	strmid(personalVehicle[idcar][pvCarPlate], "DS Car", 0, 6, 255);
	update("UPDATE `server_personal_vehicles` SET `OwnerID` = '%d', `ColorOne` = '1', `ColorTwo` = '1', `X` = '%f', `Y` = '%f', `Z` = '%f', `Angle` = '%f', `CarPlate` = '%s', `InsurancePoints` = '10' WHERE `ID` = '%d'", personalVehicle[idcar][pvOwnerID], DebugVehicles[rand][0], DebugVehicles[rand][1], DebugVehicles[rand][2], DebugVehicles[rand][3], personalVehicle[idcar][pvCarPlate], personalVehicle[idcar][pvID]);
	gString[0] = (EOS);
	va_format(gString, sizeof(gString), "{ccaa2d}* (Dealership){ffffff}: Ti-ai cumparat o masina %s (%d) pentru $%s. Aceasta o poti vedea tastand comanda /vehicles (/v), aceasta nu a fost spawnata pentru a evita lagul.", getVehicleName(personalVehicle[idcar][pvModelID]), personalVehicle[idcar][pvModelID], formatNumber(DSModels[SelectedCar[playerid][DealerID[playerid]]][dPrice]));
	sendSplitMessage(playerid, COLOR_WHITE, gString);
	playerInfo[playerid][pinDealer] = 0;
	DealerCarType[playerid] = 0;
	DealerID[playerid] = -1;
	DestroyVehicle(DealerCar[playerid]);	
	TogglePlayerControllable(playerid, 1);
	SetCameraBehindPlayer(playerid);
	SetPlayerVirtualWorld(playerid, 0);
	return true;
}

stock cancelDriveTest(playerid, reason) {
	switch(reason) {
		case 1: {
			SetPlayerPos(playerid, 1449.9297,-2287.0208,13.5469);
			SetPlayerInterior(playerid, 0);
			ShowCamera(playerid);
			TestingModel[playerid] = 0;
			DestroyVehicle(DealerCar[playerid]);
			DealerCar[playerid] = CreateVehicle(DSModels[DealerID[playerid]][dModel], 1524.8397,-2412.6653,24.4380,35.8937,1,1,-1,0); 
			SetVehicleVirtualWorld(DealerCar[playerid],playerid+1);
			LinkVehicleToInterior(DealerCar[playerid], 0);
			ShowDealerShipTD(playerid);
			SelectTextDraw(playerid, 0x15B864FF);
			TogglePlayerControllable(playerid, 0);
			SetPlayerVirtualWorld(playerid, playerid+1);
			new e,l,a,d,b,bo,o;
			GetVehicleParamsEx(DealerCar[playerid],e,l,a,d,b,bo,o);
			SetVehicleParamsEx(DealerCar[playerid],e,l,a,d,b,bo,o);
			SCM(playerid, -1, string_fast("{ccaa2d}* (Dealership){ffffff}: Test-Drive-ul a fost anulat, deoarece timpul a expirat."));
		}
		case 2: {
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			DestroyVehicle(DealerCar[playerid]);
			HideDealerShipTD(playerid);
			TogglePlayerControllable(playerid, 1);
			TestingModel[playerid] = 0;
			SCM(playerid, -1, string_fast("{ccaa2d}* (Dealership){ffffff}: Test-Drive-ul a fost anulat, deoarece ai murit."));	
		}
		case 3: {
			SetPlayerPos(playerid, 1449.9297,-2287.0208,13.5469);
			SetPlayerInterior(playerid, 0);
			ShowCamera(playerid);
			TestingModel[playerid] = 0;
			DestroyVehicle(DealerCar[playerid]);
			DealerCar[playerid] = CreateVehicle(DSModels[DealerID[playerid]][dModel], 1524.8397,-2412.6653,24.4380,35.8937,1,1,-1,0); 
			SetVehicleVirtualWorld(DealerCar[playerid],playerid+1);
			LinkVehicleToInterior(DealerCar[playerid], 0);
			ShowDealerShipTD(playerid);
			SelectTextDraw(playerid, 0x15B864FF);
			TogglePlayerControllable(playerid, 0);
			SetPlayerVirtualWorld(playerid, playerid+1);
			new e,l,a,d,b,bo,o;
			GetVehicleParamsEx(DealerCar[playerid],e,l,a,d,b,bo,o);
			SetVehicleParamsEx(DealerCar[playerid],e,l,a,d,b,bo,o);
			SCM(playerid, -1, string_fast("{ccaa2d}* (Dealership){ffffff}: Test-Drive-ul a fost anulat, deoarece ai iesit din masina."));		
		}
	}
	return true;
}

hook OnPlayerConnect(playerid) {
	TestingModel[playerid] = -1;
	return true;
}

hook OnPlayerDeath(playerid) {
	if(playerInfo[playerid][pinDealer] == 1 && TestingModel[playerid] == 1) cancelDriveTest(playerid, 2);
	return true;
}

hook OnPlayerStateChange(playerid, newstate, oldstate) {
	if(newstate == PLAYER_STATE_ONFOOT) {
		if(TestingModel[playerid] == 1) cancelDriveTest(playerid, 3);
	}
	return true;
}

hook OnPlayerClickTextDraw(playerid, Text:clickedid) {
	if(clickedid == serverDealerTD[1]) {
	    if(DealerID[playerid] == 1) DealerID[playerid] = TotalDealerCars[playerid]+1;
		DealerID[playerid] -= 1;
		DestroyVehicle(DealerCar[playerid]);
		DealerCar[playerid] = CreateVehicle(DSModels[DealerID[playerid]][dModel],1524.8397,-2412.6653,24.4380,35.8937,1,1,-1,0); 
		vehicle_personal[DealerCar[playerid]] = -1;
		SetVehicleVirtualWorld(DealerCar[playerid], playerid+1);
		if(GetPlayerCash(playerid) < DSModels[SelectedCar[playerid][DealerID[playerid]]][dPrice]) PlayerTextDrawSetString(playerid, serverDealerPTD[playerid][2], string_fast("Price: ~r~$%s~W~~H~~N~Stock: ~R~%d available~W~~H~~N~Max Speed: ~R~%dKM/H", formatNumber(DSModels[SelectedCar[playerid][DealerID[playerid]]][dPrice]), DSModels[SelectedCar[playerid][DealerID[playerid]]][dStock], getVehicleMaxSpeed(DSModels[SelectedCar[playerid][DealerID[playerid]]][dModel])));
		else if(GetPlayerCash(playerid) >= DSModels[SelectedCar[playerid][DealerID[playerid]]][dPrice]) PlayerTextDrawSetString(playerid, serverDealerPTD[playerid][2], string_fast("Price: ~g~$%s~W~~H~~N~Stock: ~R~%d available~W~~H~~N~Max Speed: ~R~%dKM/H", formatNumber(DSModels[SelectedCar[playerid][DealerID[playerid]]][dPrice]), DSModels[SelectedCar[playerid][DealerID[playerid]]][dStock], getVehicleMaxSpeed(DSModels[SelectedCar[playerid][DealerID[playerid]]][dModel])));
		PlayerTextDrawSetString(playerid, serverDealerPTD[playerid][1], string_fast("%s", getVehicleName(DSModels[SelectedCar[playerid][DealerID[playerid]]][dModel])));		
		PlayerTextDrawSetPreviewModel(playerid, serverDealerPTD[playerid][0], DSModels[DealerID[playerid]][dModel]);
		PlayerTextDrawShow(playerid, serverDealerPTD[playerid][0]);
	}
	if(clickedid == serverDealerTD[2]) {
		if(DealerID[playerid] == TotalDealerCars[playerid]) DealerID[playerid] = 0;
        DealerID[playerid] += 1;
		DestroyVehicle(DealerCar[playerid]);
		DealerCar[playerid] = CreateVehicle(DSModels[DealerID[playerid]][dModel],1524.8397,-2412.6653,24.4380,35.8937,1,1,-1,0); 
		vehicle_personal[DealerCar[playerid]] = -1;
		SetVehicleVirtualWorld(DealerCar[playerid], playerid+1);
		if(GetPlayerCash(playerid) < DSModels[SelectedCar[playerid][DealerID[playerid]]][dPrice]) PlayerTextDrawSetString(playerid, serverDealerPTD[playerid][2], string_fast("Price: ~r~$%s~W~~H~~N~Stock: ~R~%d available~W~~H~~N~Max Speed: ~R~%dKM/H", formatNumber(DSModels[SelectedCar[playerid][DealerID[playerid]]][dPrice]), DSModels[SelectedCar[playerid][DealerID[playerid]]][dStock], getVehicleMaxSpeed(DSModels[SelectedCar[playerid][DealerID[playerid]]][dModel])));
		else if(GetPlayerCash(playerid) >= DSModels[SelectedCar[playerid][DealerID[playerid]]][dPrice]) PlayerTextDrawSetString(playerid, serverDealerPTD[playerid][2], string_fast("Price: ~g~$%s~W~~H~~N~Stock: ~R~%d available~W~~H~~N~Max Speed: ~R~%dKM/H", formatNumber(DSModels[SelectedCar[playerid][DealerID[playerid]]][dPrice]), DSModels[SelectedCar[playerid][DealerID[playerid]]][dStock], getVehicleMaxSpeed(DSModels[SelectedCar[playerid][DealerID[playerid]]][dModel])));
		PlayerTextDrawSetString(playerid, serverDealerPTD[playerid][1], string_fast("%s", getVehicleName(DSModels[SelectedCar[playerid][DealerID[playerid]]][dModel])));
		PlayerTextDrawSetPreviewModel(playerid, serverDealerPTD[playerid][0], DSModels[DealerID[playerid]][dModel]);
		PlayerTextDrawShow(playerid, serverDealerPTD[playerid][0]);
	}
	if(clickedid == serverDealerTD[6]) {
		if(DSModels[SelectedCar[playerid][DealerID[playerid]]][dStock] < 1) return sendPlayerError(playerid, "Momentan nu exista stock valabil pentru aceasta masina.");
		if(GetPlayerCash(playerid) < DSModels[SelectedCar[playerid][DealerID[playerid]]][dPrice]) return sendPlayerError(playerid, "Nu ai destui bani, pentru a cumpara aceasta masina.");
		if(playerInfo[playerid][pVehicleSlots] == Iter_Count(PlayerVehicles[playerid])) return sendPlayerError(playerid, "Momentan nu ai slot-uri valabile, pentru a cumpara aceasta masina.");
		gQuery[0] = (EOS);
		mysql_format(SQL, gQuery, sizeof(gQuery), "INSERT INTO `server_personal_vehicles` (ModelID) VALUES (%d)", DSModels[DealerID[playerid]][dModel]);
		mysql_tquery(SQL, gQuery, "InsertCarDS", "ii", playerid, DSModels[SelectedCar[playerid][DealerID[playerid]]][dModel]);
		DSModels[SelectedCar[playerid][DealerID[playerid]]][dStock] --;
		update("UPDATE `server_ds` SET `Stock`='%d' WHERE `ID`='%d'", DSModels[SelectedCar[playerid][DealerID[playerid]]][dStock], SelectedCar[playerid][DealerID[playerid]]);
		playerInfo[playerid][pinDealer] = 0;
		GivePlayerCash(playerid, 0, DSModels[SelectedCar[playerid][DealerID[playerid]]][dPrice]);
		CancelSelectTextDraw(playerid);
		HideDealerShipTD(playerid);
	}
	if(clickedid == serverDealerTD[7]) {
		TestingModel[playerid] = 1;
		CancelSelectTextDraw(playerid);
		HideDealerShipTD(playerid);
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid, 1);
		SetPlayerInterior(playerid, 0);
		LinkVehicleToInterior(DealerCar[playerid], 0);
		SetVehicleVirtualWorld(DealerCar[playerid], playerid+1);
		SetVehiclePos(DealerCar[playerid], 1416.1704,-2284.2883,13.1099);
		PutPlayerInVehicle(playerid, DealerCar[playerid], 0);
		vehicle_fuel[DealerCar[playerid]] = 100;
		defer testDriveTimer(playerid);
	}
	if(clickedid == serverDealerTD[8]) {
		TestingModel[playerid] = 0;
		DealerCarType[playerid] = 0;
		DealerID[playerid] = -1;
		playerInfo[playerid][pinDealer] = 0;	
		DestroyVehicle(DealerCar[playerid]);
		HideDealerShipTD(playerid);
		CancelSelectTextDraw(playerid);
		TogglePlayerControllable(playerid, 1);
		SetPlayerVirtualWorld(playerid, 0);
		SetCameraBehindPlayer(playerid);
	}
	return true;
}

timer testDriveTimer[120000](playerid) cancelDriveTest(playerid, 1); 

CMD:buycar(playerid, params[]) {
	if(playerInfo[playerid][pinDealer] > 1) return sendPlayerError(playerid, "Momentan esti deja in dealer-ul de masini.");
	if(TestingModel[playerid] > 0) return sendPlayerError(playerid, "Esti in modul de 'test drive' momentan.");
	LoadDsVehs(playerid);
	TestingModel[playerid] = 0;
	DealerCarType[playerid] = 1;
	DealerID[playerid] = 1;
	playerInfo[playerid][pinDealer] = 1;
	TogglePlayerControllable(playerid, 0);
	SetPlayerVirtualWorld(playerid, playerid+1);
	SetPlayerInterior(playerid, 0);
	DealerCar[playerid] = CreateVehicle(DSModels[DealerID[playerid]][dModel],1524.8397,-2412.6653,24.4380,35.8937,1,1,-1,0); 
	vehicle_personal[DealerCar[playerid]] = -1;
	SetVehicleVirtualWorld(DealerCar[playerid], playerid+1);
	LinkVehicleToInterior(DealerCar[playerid], 0);
	PlayerTextDrawSetPreviewModel(playerid, serverDealerPTD[playerid][0], DSModels[DealerID[playerid]][dModel]);
	PlayerTextDrawShow(playerid, serverDealerPTD[playerid][0]);
	ShowDealerShipTD(playerid);
	SelectTextDraw(playerid, 0x15B864FF);
	ShowCamera(playerid);
	return true;
}
