/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// BBBBBBBBBBBBBBBBB   lllllll                                       kkkkkkkk           MMMMMMMM               MMMMMMMM                                                    //
// B::::::::::::::::B  l:::::l                                       k::::::k           M:::::::M             M:::::::M                                                    //
// B::::::BBBBBB:::::B l:::::l                                       k::::::k           M::::::::M           M::::::::M                                                    //
// BB:::::B     B:::::Bl:::::l                                       k::::::k           M:::::::::M         M:::::::::M                                                    //
//   B::::B     B:::::B l::::l   aaaaaaaaaaaaa       cccccccccccccccc k:::::k    kkkkkkkM::::::::::M       M::::::::::M   ooooooooooo      ooooooooooo   nnnn  nnnnnnnn    //
//   B::::B     B:::::B l::::l   a::::::::::::a    cc:::::::::::::::c k:::::k   k:::::k M:::::::::::M     M:::::::::::M oo:::::::::::oo  oo:::::::::::oo n:::nn::::::::nn  //
//   B::::BBBBBB:::::B  l::::l   aaaaaaaaa:::::a  c:::::::::::::::::c k:::::k  k:::::k  M:::::::M::::M   M::::M:::::::Mo:::::::::::::::oo:::::::::::::::on::::::::::::::nn //
//   B:::::::::::::BB   l::::l            a::::a c:::::::cccccc:::::c k:::::k k:::::k   M::::::M M::::M M::::M M::::::Mo:::::ooooo:::::oo:::::ooooo:::::onn:::::::::::::::n//
//   B::::BBBBBB:::::B  l::::l     aaaaaaa:::::a c::::::c     ccccccc k::::::k:::::k    M::::::M  M::::M::::M  M::::::Mo::::o     o::::oo::::o     o::::o  n:::::nnnn:::::n//
//   B::::B     B:::::B l::::l   aa::::::::::::a c:::::c              k:::::::::::k     M::::::M   M:::::::M   M::::::Mo::::o     o::::oo::::o     o::::o  n::::n    n::::n//
//   B::::B     B:::::B l::::l  a::::aaaa::::::a c:::::c              k:::::::::::k     M::::::M    M:::::M    M::::::Mo::::o     o::::oo::::o     o::::o  n::::n    n::::n//
//   B::::B     B:::::B l::::l a::::a    a:::::a c::::::c     ccccccc k::::::k:::::k    M::::::M     MMMMM     M::::::Mo::::o     o::::oo::::o     o::::o  n::::n    n::::n//
// BB:::::BBBBBB::::::Bl::::::la::::a    a:::::a c:::::::cccccc:::::ck::::::k k:::::k   M::::::M               M::::::Mo:::::ooooo:::::oo:::::ooooo:::::o  n::::n    n::::n//
// B:::::::::::::::::B l::::::la:::::aaaa::::::a  c:::::::::::::::::ck::::::k  k:::::k  M::::::M               M::::::Mo:::::::::::::::oo:::::::::::::::o  n::::n    n::::n//
// B::::::::::::::::B  l::::::l a::::::::::aa:::a  cc:::::::::::::::ck::::::k   k:::::k M::::::M               M::::::M oo:::::::::::oo  oo:::::::::::oo   n::::n    n::::n//
// BBBBBBBBBBBBBBBBB   llllllll  aaaaaaaaaa  aaaa    cccccccccccccccckkkkkkkk    kkkkkkkMMMMMMMM               MMMMMMMM   ooooooooooo      ooooooooooo     nnnnnn    nnnnnn//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#define MYSQL 1 // 0 - local | 1 - host

#include <discord>

#include <a_samp>
#include <a_zones>
#include <beaZone>

#include <YSI\y_iterate>
#include <profiler>
#include <YSI\y_timers>
#include <YSI\y_master>
#include <YSI\y_va>
#include <YSI\y_inline>
#include <YSI\y_stringhash>

#include <Pawn.CMD>
#include <a_mysql>
#include <a_http>
#include <sscanf2>
#include <timestamptodate>
#include <fly>
#include <callbacks>
#include <streamer>

#include <modules\natives.pwn>
#include <modules\defines.pwn>
#include <modules\enums.pwn>
#include <modules\variables.pwn>
#include <modules\ac.pwn> // anti-cheats
#include <easyDialog>
#include <modules\stocks.pwn>
#include <modules\dialogs.pwn>
#include <modules\pickups.pwn>
#include <modules\houses.pwn>
#include <modules\turfs.pwn>
#include <modules\factions.pwn>
#include <modules\safes.pwn>
#include <modules\jobs.pwn>
#include <modules\business.pwn>
#include <modules\comenzi\helper.pwn>
#include <modules\clans.pwn>
#include <modules\functions.pwn> 
#include <modules\personalvehicles.pwn>
#include <modules\gascan.pwn>
#include <modules\timers.pwn>
#include <modules\comenzi\admin.pwn>
#include <modules\comenzi\player.pwn>
#include <modules\dealership.pwn>
#include <modules\emails.pwn>

main() { }

alias:adminchat("a", "ac")
alias:helperchat("h", "hc")
alias:setrepsectpoints("setrp", "setrespect")
alias:admingivelicense("agl", "admingl")
alias:adminsuspendlicense("asl", "adminsl")
alias:vehicles("v", "g", "garage")
alias:fixveh("fv", "fixvehicle")
alias:addnos("nos", "addnitro")
alias:despawncar("vre")
alias:flipveh("flip", "flipvehicle")
alias:acceptreport("acr", "areport")
alias:closereport("cr", "clreport")
alias:reportmute("rmute", "repmute")
alias:set("setstats", "setstat")
alias:makeleader("setleader")
alias:setadmin("makeadmin")
alias:auninvite("fpk")
alias:announce("anno")
alias:clearchat("cc", "cchat")

public OnQueryError(errorid, const error[], const callback[], const query[], MySQL:handle)
{
	print("=========================================");
	printf("Error ID: %d, Error: %s", errorid, error);
	printf("Callback: %s", callback);
	printf("gQuery: %s", query);
	print("=========================================");
	return true;
}


public OnGameModeInit()
{
	PayDayTime = gettime()+3600;
	MySQLLoad();

	SetNameTagDrawDistance(20.0);
	EnableStuntBonusForAll(false);
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
   	ManualVehicleEngineAndLights();
    DisableInteriorEnterExits();
	AllowInteriorWeapons(true);
	UsePlayerPedAnims();

	loadMaps();

	DCC_SetBotActivity(string_fast("0 / %d", MAX_PLAYERS));
	if(DCC_GetBotPresenceStatus() != DCC_BotPresenceStatus:IDLE) DCC_SetBotPresenceStatus(IDLE);	
	return true;
}

public OnGameModeExit()
{
	mysql_close(SQL);
	destroyServerTextDraws();
	return true;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(playerInfo[playerid][pLogged] == true)
		return SpawnPlayer(playerid);


	if(playerInfo[playerid][pLoginEnabled] == true)
		return true;

	SetPlayerVirtualWorld(playerid, (playerid + 1));
	TogglePlayerControllable(playerid, false);

	InterpolateCameraPos(playerid, 1992.012207, 486.498046, 227.473190, 1141.062500, -1813.197387, 56.129741, 15000);
	InterpolateCameraLookAt(playerid, 1989.800537, 482.112274, 226.538528, 1139.465698, -1808.715454, 54.592548, 15000);
	return true;
}

public OnPlayerConnect(playerid)
{
	resetVars(playerid);
	removeMaps(playerid);	
	GameTextForPlayer(playerid, "PLEASE WAIT~n~CHECKING YOUR ~p~ACCOUNT", 10000, 5);

	switch(MYSQL) {
		case 0: {
			GameTextForPlayer(playerid, "~p~YOUR ACCOUNT IT'S GOOD", 1000, 3);
			mysql_tquery(SQL, string_fast("SELECT * FROM `server_bans` WHERE `Active` = '1' AND `PlayerName` = '%s' LIMIT 1", getName(playerid)), "checkPlayerBan", "d", playerid);
		}
		default: HTTP(playerid, HTTP_GET, string_fast("blackbox.ipinfo.app/lookup/%s", playerInfo[playerid][pLastIp]), "", "MyHttpResponse");
	}
	return true;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(Iter_Contains(ServerAdmins, playerid)) 
		Iter_Remove(ServerAdmins, playerid);

	if(Iter_Contains(ServerHelpers, playerid)) 
		Iter_Remove(ServerHelpers, playerid);

	if(Iter_Contains(ServerStaff, playerid)) {
		Iter_Remove(ServerStaff, playerid);
		sendStaff(COLOR_SERVER, "** MoonBot: {ffffff}%s s-a deconnectat de pe server | Total Staff: %d [%d admins, %d helpers].", getName(playerid), Iter_Count(ServerStaff), Iter_Count(ServerAdmins), Iter_Count(ServerHelpers));
	}

	if(Iter_Contains(MutedPlayers, playerid))
		Iter_Remove(MutedPlayers, playerid);

	if(Iter_Contains(loggedPlayers, playerid))
		Iter_Remove(loggedPlayers, playerid);

	if(playerInfo[playerid][pClan]) {
		Iter_Remove(TotalClanMembers, playerid);
		sendClanMessage(playerInfo[playerid][pClan], clanInfo[playerInfo[playerid][pClan]][cClanColor], "** MoonBot: {ffffff}%s s-a deconnectat de pe server.", getName(playerid));
	}

	foreach(new x : Reports) {
		if(reportInfo[x][reportID] == playerid) {
			sendAdmin(COLOR_SERVER, "Notice Report: {ffffff}Report-ul lui %s a fost anulat automat, deoarece s-a deconectat.", getName(playerid));
			reportInfo[x][reportID] = INVALID_PLAYER_ID;
			reportInfo[x][reportPlayer] = INVALID_PLAYER_ID;
			reportInfo[x][reportType] = REPORT_TYPE_NONE;
			reportInfo[x][reportText] = (EOS);
			Iter_Remove(Reports, x);
			break;
		}
	}

	if(playerInfo[playerid][pReportChat] != INVALID_PLAYER_ID) {
		SCMf(playerid, COLOR_YELLOW, "* Conversatia a fost inchisa deoarece %s s-a deconectat.", getName(playerid));
		playerInfo[playerInfo[playerid][pReportChat]][pReportChat] = INVALID_PLAYER_ID;
		playerInfo[playerid][pReportChat] = INVALID_PLAYER_ID;
	}
	if(Working[playerid]) CancelJob(playerid, Working[playerid]);
    if(reason == 0) sendNearbyMessage(playerid, COLOR_SERVER, 20.0, "(*) {ffffff}%s a iesit de pe server (Crash).", getName(playerid));
    else if(reason == 1) sendNearbyMessage(playerid, COLOR_SERVER, 20.0, "(*) {ffffff}%s a iesit de pe server (Quit).", getName(playerid));
    else if(reason == 2) sendNearbyMessage(playerid, COLOR_SERVER, 20.0, "(*) {ffffff}%s a iesit de pe server (Kicked/Banned).", getName(playerid));
	destroyPlayerTextDraws(playerid);
	update("UPDATE `server_users` SET `Seconds` = '%f', `Mute` = '%d', `ReportMute` = '%d', `Money` = '%d', `MStore` = '%d', `SpawnChange` = '%d', `Jailed` = '%d', `JailTime` = '%d', `WantedLevel` = '%d' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerid][pSeconds], playerInfo[playerid][pMute], (playerInfo[playerid][pReportMute] > gettime()) ? (playerInfo[playerid][pReportMute] - gettime()) : (0), MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSpawnChange], playerInfo[playerid][pJailed], playerInfo[playerid][pJailTime], playerInfo[playerid][pWantedLevel], playerInfo[playerid][pSQLID]);
	
	DCC_SetBotActivity(string_fast("%d / %d", Iter_Count(Player), MAX_PLAYERS));
	if(DCC_GetBotPresenceStatus() != DCC_BotPresenceStatus:IDLE) DCC_SetBotPresenceStatus(IDLE);
	return true;
}

public OnPlayerSpawn(playerid) {
	TogglePlayerControllable(playerid, true);
	SetPlayerFacingAngle(playerid, 180.0000);
	SetCameraBehindPlayer(playerid);
	SetPlayerColor(playerid, COLOR_WHITE);
	SetPlayerHealthEx(playerid, 100.0);
	SetPlayerArmourEx(playerid, 0.0);
	SetPlayerSkin(playerid, playerInfo[playerid][pSkin]);
	SetPlayerToFactionColor(playerid);

	if(!playerInfo[playerid][pAnimLibLoaded]) {
   		PreloadAnimLib(playerid,"BOMBER");
   		PreloadAnimLib(playerid,"RAPPING");
    	PreloadAnimLib(playerid,"SHOP");
   		PreloadAnimLib(playerid,"BEACH");
   		PreloadAnimLib(playerid,"SMOKING");
    	PreloadAnimLib(playerid,"FOOD");
    	PreloadAnimLib(playerid,"ON_LOOKERS");
    	PreloadAnimLib(playerid,"DEALER");
    	PreloadAnimLib(playerid,"MISC");
    	PreloadAnimLib(playerid,"SWEET");
    	PreloadAnimLib(playerid,"RIOT");
    	PreloadAnimLib(playerid,"PED");
    	PreloadAnimLib(playerid,"POLICE");
		PreloadAnimLib(playerid,"CRACK");
		PreloadAnimLib(playerid,"CARRY");
		PreloadAnimLib(playerid,"COP_AMBIENT");
		PreloadAnimLib(playerid,"PARK");
		PreloadAnimLib(playerid,"INT_HOUSE");
		PreloadAnimLib(playerid,"FOOD");
		playerInfo[playerid][pAnimLibLoaded] = 1;
	}
	
	if(!playerInfo[playerid][pTutorial])
	{
		SetPlayerVirtualWorld(playerid, (playerid + 1));
		SetPlayerInterior(playerid, 0);

		InterpolateCameraPos(playerid, 1120.062622, -1439.079589, 79.911842, 1298.314819, -1393.612182, 27.859663, 60000);
		InterpolateCameraLookAt(playerid, 1124.491699, -1437.385620, 78.326316, 1300.316772, -1389.690429, 25.490781, 60000);
	
		clearChat(playerid, 50);
		SCM(playerid, COLOR_GREY, "Completeaza casutele de mai jos pentru a finaliza inregistrarea.");
		Dialog_Show(playerid, EMAIL, DIALOG_STYLE_INPUT, "E-Mail", "Scrie mai jos adresa ta de E-Mail:", "Ok", "");
		return true;
	}
	if(IsValidVehicle(playerInfo[playerid][pExamenVehicle])) examenFail(playerid);
	if(Working[playerid]) CancelJob(playerid, Working[playerid]);
	if(playerInfo[playerid][pFlymode] == true)  {
		playerInfo[playerid][pFlymode] = false;
		StopFly(playerid);
	}
	if(playerInfo[playerid][pJailed]) {
		new rand = random(6);
		SetPlayerPos(playerid, cellRandom[rand][0], cellRandom[rand][1], cellRandom[rand][2]);
		SetPlayerVirtualWorld(playerid, 1337);
		return true;
	}
	switch(playerInfo[playerid][pSpawnChange]) {
		case 1: {
			new spawn = random(4);
			SetPlayerPos(playerid, SpawnPos[spawn][0], SpawnPos[spawn][1], SpawnPos[spawn][2]);
			SetPlayerFacingAngle(playerid, SpawnPos[spawn][0]);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			return true;		
		}
		case 2: {
			SetPlayerPos(playerid, houseInfo[playerInfo[playerid][pHouseID]][hX], houseInfo[playerInfo[playerid][pHouseID]][hY], houseInfo[playerInfo[playerid][pHouseID]][hZ]);
			SetPlayerInterior(playerid, houseInfo[playerInfo[playerid][pHouseID]][hInterior]);
			SetPlayerVirtualWorld(playerid, houseInfo[playerInfo[playerid][pHouseID]][hID]);
			playerInfo[playerid][pinHouse] = playerInfo[playerid][pHouseID];
			return true;
		}
		case 3: {
			new rentid = playerInfo[playerid][pRent];
			SetPlayerPos(playerid, houseInfo[rentid][hX], houseInfo[rentid][hY], houseInfo[rentid][hZ]);
			SetPlayerInterior(playerid, houseInfo[rentid][hInterior]);
			SetPlayerVirtualWorld(playerid, houseInfo[rentid][hID]);
			playerInfo[playerid][pinHouse] = rentid;
			return true;
		}
		case 4: {
			new fid = playerInfo[playerid][pFaction];
			SetPlayerPos(playerid, factionInfo[fid][fExitX], factionInfo[fid][fExitY], factionInfo[fid][fExitZ]);
			SetPlayerInterior(playerid, factionInfo[fid][fInterior]);
			SetPlayerVirtualWorld(playerid, factionInfo[fid][fID]);
			playerInfo[playerid][pinFaction] = fid;	
			return true;
		}
	}
	return true;
}

public OnPlayerDeath(playerid, killerid) 
{
	if(Working[playerid]) CancelJob(playerid, Working[playerid]);
	if(playerInfo[playerid][pOnTurf] == 1) playerInfo[playerid][pOnTurf] = 0;
	if(playerInfo[playerid][pFactionDuty]) playerInfo[playerid][pFactionDuty] = 0;
	if(playerInfo[playerid][pWantedLevel] != 0) {
		new count = 0, names[180];	
		foreach(new i : loggedPlayers) {
			if(Iter_Contains(FactionMembers[2], i) && Iter_Contains(FactionMembers[3], i) && Iter_Contains(FactionMembers[4], i) && ProxDetectorS(75.0, playerid,i) && playerInfo[i][pFactionDuty] == 1) {
				count = 1;
				GameTextForPlayer(i, "catching suspect bonus!", 3000, 1);
				GivePlayerCash(i, 1, playerInfo[playerid][pWantedLevel] * 2000);
				SCMf(i, COLOR_LIGHTRED, "* Catching suspect bonus:{ffffff} Ai primit $%d bonus pentru prinderea suspectului %s.", playerInfo[playerid][pWantedLevel] * 2000, getName(playerid));
				format(names, 180, "%s %s", names, getName(i));
			}	
			if(count == 1) {
				if(ProxDetectorS(30.0, i, playerid)) SCMf(i, COLOR_PURPLE, "* %s is now in jail thanks to: %s.", getName(playerid), names);
				if(killerid != INVALID_PLAYER_ID) sendPolice(3, playerid, killerid, playerInfo[playerid][pWantedLevel], "catching suspect bonus");
				else sendPolice(3, playerid, -1, playerInfo[playerid][pWantedLevel], "none");
				new rand = random(6); 
				if(playerInfo[playerid][pCuffed] == 1) {
					SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
					RemovePlayerAttachedObject(playerid,1);
					TogglePlayerControllable(playerid, 1);
					playerInfo[playerid][pCuffed] = 0;
				}
				SetPlayerPos(playerid, cellRandom[rand][0], cellRandom[rand][1], cellRandom[rand][2]);
				SetPlayerVirtualWorld(playerid, 1337);
				GivePlayerCash(playerid, 0, playerInfo[playerid][pWantedLevel] * 2000);
				jailTime[playerid] = repeat TimerJail(playerid);
				playerInfo[playerid][pWantedDeaths] += 1;
				playerInfo[playerid][pJailTime] = playerInfo[playerid][pWantedLevel] * 250;
				playerInfo[playerid][pJailed] = 1;
				playerInfo[playerid][pWantedTime] = 0;
				playerInfo[playerid][pWantedLevel] = 0;
				stop wantedTime[playerid];
				update("UPDATE `server_users` SET `Jailed` = '%d', `JailTime` = '%d', `WantedTime` = '0', `WantedDeaths` = '%d', `WantedLevel` = '0' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerid][pJailed], playerInfo[playerid][pJailTime], playerInfo[playerid][pWantedDeaths], playerInfo[playerid][pSQLID]);
				SCMf(playerid, COLOR_LIGHTRED, "* Deoarece ai murit, ai pierdut $%s si vei fi dus la inchisoare. Acum nu mai esti criminal.", formatNumber(playerInfo[playerid][pWantedLevel] * 2000));
				TogglePlayerControllable(playerid, 0);
				SetPlayerFreeze(playerid, 1);
				SetPlayerWantedLevel(playerid, 0);						
			}			
		}	
		if(count == 0) { 
			if(killerid != INVALID_PLAYER_ID) sendPolice(3, playerid, killerid, playerInfo[playerid][pWantedLevel], "catching suspect bonus");
			else sendPolice(3, playerid, -1, playerInfo[playerid][pWantedLevel], "none");
			new rand = random(6); 
			if(playerInfo[playerid][pCuffed] == 1) {
				SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
				RemovePlayerAttachedObject(playerid,1);
				TogglePlayerControllable(playerid, 1);
				playerInfo[playerid][pCuffed] = 0;
			}
			SetPlayerPos(playerid, cellRandom[rand][0], cellRandom[rand][1], cellRandom[rand][2]);
			SetPlayerVirtualWorld(playerid, 1337);
			GivePlayerCash(playerid, 0, playerInfo[playerid][pWantedLevel] * 2000);
			jailTime[playerid] = repeat TimerJail(playerid);
			playerInfo[playerid][pWantedDeaths] += 1;
			playerInfo[playerid][pJailTime] = playerInfo[playerid][pWantedLevel] * 250;
			playerInfo[playerid][pJailed] = 1;
			playerInfo[playerid][pWantedTime] = 0;
			playerInfo[playerid][pWantedLevel] = 0;
			stop wantedTime[playerid];
			update("UPDATE `server_users` SET `Jailed` = '%d', `JailTime` = '%d', `WantedTime` = '0', `WantedDeaths` = '%d', `WantedLevel` = '0' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerid][pJailed], playerInfo[playerid][pJailTime], playerInfo[playerid][pWantedDeaths], playerInfo[playerid][pSQLID]);
			SCMf(playerid, COLOR_LIGHTRED, "* Deoarece ai murit, ai pierdut $%s si vei fi dus la inchisoare. Acum nu mai esti criminal.", formatNumber(playerInfo[playerid][pWantedLevel] * 2000));
			TogglePlayerControllable(playerid, 0);
			SetPlayerFreeze(playerid, 1);
			SetPlayerWantedLevel(playerid, 0);				
		}
	}	
	return true;
}

public OnPlayerText(playerid, text[]) {
	if(!isPlayerLogged(playerid)) defer kickEx(playerid);
	if(strmatch(Diley[playerid], text)) return 0;
	format(Diley[playerid], 144, text);
	if(faceReclama(text)) {
		Reclama(playerid, text);
		return 0;
	}
	if(playerInfo[playerid][pMute] > gettime()) {
		SCMf(playerid, COLOR_LIGHTRED, "[ERROR] {FFFFFF}Ai mute pentru inca %s.", secinmin(playerInfo[playerid][pMute]-gettime()));
		return 0;
	}
	if(playerInfo[playerid][pTalkingLive] != -1) {
		oocNews(COLOR_LIGHTGREEN, "* %s %s: %s", playerInfo[playerid][pFaction] == 6 ? "Reporter" : "Jucator", getName(playerid), text);
		return 0;
	}
	sendNearbyMessage(playerid, COLOR_WHITE, 25.0, "%s spune: %s", getName(playerid), text); 
	SetPlayerChatBubble(playerid, text, COLOR_WHITE, 25.0, 5000);
	update("INSERT INTO `server_chat_logs` (PlayerName, PlayerID, ChatText) VALUES ('%s', '%d', '%s')", getName(playerid), playerInfo[playerid][pSQLID], string_fast("* (chat log): %s.", text));
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(!ispassenger)
	{
		if(playerInfo[playerid][pFlyLicense] == 0 && isPlane(vehicleid))
		{
			sendPlayerError(playerid, "Nu ai licenta de pilot.");
			ClearAnimations(playerid);
			return true;
		}

		if(playerInfo[playerid][pBoatLicense] == 0 && isBoat(vehicleid))
		{
			sendPlayerError(playerid, "Nu ai licenta de navigatie.");
			ClearAnimations(playerid);
			return true;
		}

		if(playerInfo[playerid][pDrivingLicense] == 0 && !isBike(vehicleid) && !isBoat(vehicleid) && !isPlane(vehicleid) && vehicleid != playerInfo[playerid][pExamenVehicle])
		{
			sendPlayerError(playerid, "Nu ai licenta de condus.");
			ClearAnimations(playerid);
			return true;
		}
	}
	return true;
}

public OnVehicleSpawn(vehicleid) {
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, alarm, doors, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, objective);
	if(vehicle_personal[vehicleid] > -1) {
		new id = vehicle_personal[vehicleid];
		ModVehicle(personalVehicle[id][pvSpawnedID]);
		if(personalVehicle[id][pvPaintJob] > -1) {
			ChangeVehiclePaintjob(personalVehicle[id][pvSpawnedID], personalVehicle[id][pvPaintJob]);
		}
		#pragma unused id
	}
	vehicle_engine[vehicleid] = false;
	vehicle_lights[vehicleid] = false;
	vehicle_bonnet[vehicleid] = false;
	vehicle_boot[vehicleid] = false;
	vehicle_fuel[vehicleid] = 100.0;
	return true;
}

public OnVehicleMod(playerid, vehicleid, componentid) {
	if(vehicle_personal[vehicleid] > -1 && Iter_Contains(PlayerVehicles[playerid], vehicle_personal[vehicleid])) {
		SaveComponent(vehicleid, componentid);
	}
	return true;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid) {
	if(vehicle_personal[vehicleid] > -1 && Iter_Contains(PlayerVehicles[playerid], vehicle_personal[vehicleid])) {
		personalVehicle[vehicle_personal[vehicleid]][pvPaintJob] = paintjobid;
		update("UPDATE `server_personal_vehicles` SET `PaintJob`='%d' WHERE `ID`='%d' LIMIT 1", paintjobid, personalVehicle[vehicle_personal[vehicleid]][pvID]);
	}
	return true;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2) {
	if(vehicle_personal[vehicleid] > -1 && Iter_Contains(PlayerVehicles[playerid], vehicle_personal[vehicleid])) {
		personalVehicle[vehicle_personal[vehicleid]][pvHealth] = 1000;
		update("UPDATE `server_personal_vehicles` SET `Health`= '%f' WHERE `ID`='%d' LIMIT 1", personalVehicle[vehicle_personal[vehicleid]][pvHealth], personalVehicle[vehicle_personal[vehicleid]][pvID]);
	}
	return true;
}

public OnVehicleDeath(vehicleid, killerid) {
	new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, alarm, doors, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, objective);
	if(Iter_Contains(AdminVehicles, vehicleid)) {
		Iter_Remove(AdminVehicles, vehicleid);
		DestroyVehicle(vehicleid);
	}

	if(vehicle_personal[vehicleid] > -1) {
		new id = vehicle_personal[vehicleid];
		personalVehicle[id][pvInsurancePoints] --;
		update("UPDATE `server_personal_vehicles` SET `InsurancePoints`='%d' WHERE `ID`='%d' LIMIT 1", personalVehicle[id][pvInsurancePoints], personalVehicle[id][pvID]);
		SCMf(getVehicleOwner(personalVehicle[id][pvOwnerID]), -1, "Vehiculul tau %s a pierdut un punct de asigurare.", getVehicleName(personalVehicle[id][pvModelID]));
	}

	vehicle_engine[vehicleid] = false;
	vehicle_lights[vehicleid] = false;
	vehicle_bonnet[vehicleid] = false;
	vehicle_boot[vehicleid] = false;
	vehicle_fuel[vehicleid] = 100.0;
	return true;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if(PRESSED(KEY_LOOK_BEHIND)) {
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || !isBike(GetPlayerVehicleID(playerid)) || GetPVarInt(playerid, "engineDeelay") != gettime()) callcmd::engine(playerid, "\1");
	}
	if(PRESSED(KEY_SECONDARY_ATTACK)) {
		new b = GetPlayerVirtualWorld(playerid);
	    if(PRESSED(KEY_SECONDARY_ATTACK)) {
	        if(playerInfo[playerid][areaBizz] != 0 && IsPlayerInRangeOfPoint(playerid, 3.5, bizInfo[playerInfo[playerid][areaBizz]][bizExtX], bizInfo[playerInfo[playerid][areaBizz]][bizExtY], bizInfo[playerInfo[playerid][areaBizz]][bizExtZ]) && bizInfo[playerInfo[playerid][areaBizz]][bizStatic] != 1 && bizInfo[playerInfo[playerid][areaBizz]][bizLocked] != 1) {
				SetPlayerPos(playerid, bizInfo[playerInfo[playerid][areaBizz]][bizX], bizInfo[playerInfo[playerid][areaBizz]][bizY], bizInfo[playerInfo[playerid][areaBizz]][bizZ]);
				SetPlayerInterior(playerid, bizInfo[playerInfo[playerid][areaBizz]][bizInterior]);
				SetPlayerVirtualWorld(playerid, bizInfo[playerInfo[playerid][areaBizz]][bizID]);
				GivePlayerCash(playerid, 0, bizInfo[playerInfo[playerid][areaBizz]][bizFee]);
				va_GameTextForPlayer(playerid, "~r~-$%d", bizInfo[playerInfo[playerid][areaBizz]][bizFee], 1000, 1);
				playerInfo[playerid][pinBusiness] = playerInfo[playerid][areaBizz];
				bizInfo[playerInfo[playerid][areaBizz]][bizBalance] += bizInfo[playerInfo[playerid][areaBizz]][bizFee];
				update("UPDATE `server_business` SET `Balance`='%d' WHERE `ID`='%d' LIMIT 1",bizInfo[playerInfo[playerid][areaBizz]][bizBalance], playerInfo[playerid][areaBizz]);
				switch(bizInfo[playerInfo[playerid][areaBizz]][bizType]) {
					case 1: SCM(playerid, -1, "Welcome in the business, commands available: /balance, /deposit, /withdraw, /transfer."); 
					case 2: {
						SCM(playerid, -1, "Welcome in the business, commands available: /buy.");
						if(FishWeight[playerid]) {
							new money = FishWeight[playerid] * 115;
							SCM(playerid, COLOR_GREY, string_fast("* Fish Notice: Ai vandut pestele , si ai castigat $%s.", formatNumber(money)));
							FishWeight[playerid] = 0;
							playerInfo[playerid][pFishTimes] ++;
							if(playerInfo[playerid][pFishSkill] < 5) {
								if(playerInfo[playerid][pFishTimes] >= returnNeededPoints(playerid, JOB_FISHER)) {
									playerInfo[playerid][pFishSkill] ++;
									SCM(playerid, COLOR_GREY, string_fast("* Fisherman Notice: Ai avansat in %d skill. Vei castiga probabil mai multi bani", playerInfo[playerid][pFishSkill]));
								}
							}
							GivePlayerCash(playerid, 1, money);
							for(new m; m < 2; m++) {
								if(playerInfo[playerid][pDailyMission][m] == 1) checkMission(playerid, m);
							}
							gQuery[0] = (EOS);
							mysql_format(SQL, gQuery, sizeof(gQuery), "UPDATE `server_users` SET `Money`= '%d', `MStore` = '%d', `FishTimes` = '%d', `FishSkill` = '%d' WHERE `ID`='%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pFishTimes], playerInfo[playerid][pFishSkill], playerInfo[playerid][pSQLID]);
							mysql_tquery(SQL, gQuery);
						}
					}
				}
				playerInfo[playerid][areaBizz] = 0;
				return true;
	        }
	        else if(IsPlayerInRangeOfPoint(playerid, 3.0, bizInfo[b][bizX], bizInfo[b][bizY], bizInfo[b][bizZ])) {
	        	SetPlayerPos(playerid, bizInfo[b][bizExtX], bizInfo[b][bizExtY], bizInfo[b][bizExtZ]);
	            SetPlayerInterior(playerid, 0);
	            SetPlayerVirtualWorld(playerid, 0);
	            playerInfo[playerid][pinBusiness] = -1;
	            return true;
	        }
    	}

		if(playerInfo[playerid][areaHouse] != 0 && IsPlayerInRangeOfPoint(playerid, 3.5, bizInfo[playerInfo[playerid][areaHouse]][bizExtX], bizInfo[playerInfo[playerid][areaHouse]][bizExtY], bizInfo[playerInfo[playerid][areaHouse]][bizExtZ])) {
			if(houseInfo[playerInfo[playerid][areaHouse]][hLocked] == 1) return sendPlayerError(playerid, "Acesta casa, este inchisa.");
			if(IsPlayerInAnyVehicle(playerid)) return sendPlayerError(playerid, "Esti intr-un vehicul.");
			SetPlayerPos(playerid, houseInfo[playerInfo[playerid][areaHouse]][hX], houseInfo[playerInfo[playerid][areaHouse]][hY], houseInfo[playerInfo[playerid][areaHouse]][hZ]);
			SetPlayerInterior(playerid, houseInfo[playerInfo[playerid][areaHouse]][hInterior]);
			SetPlayerVirtualWorld(playerid, houseInfo[playerInfo[playerid][areaHouse]][hID]);
			playerInfo[playerid][pinHouse] = playerInfo[playerid][areaHouse];
			SCMf(playerid, COLOR_GREY, "* House Notice: Welcome to %s's house. Commands available: /eat, /sleep.", houseInfo[playerInfo[playerid][areaHouse]][hOwner]);
			playerInfo[playerid][areaHouse] = 0;
			return true;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.5, houseInfo[b][hX], houseInfo[b][hY], houseInfo[b][hZ])) {
			SetPlayerPos(playerid, houseInfo[b][hExtX], houseInfo[b][hExtY], houseInfo[b][hExtZ]);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			playerInfo[playerid][pinHouse] = -1;
			return true;
		}

		if(playerInfo[playerid][areaFaction] != 0 && IsPlayerInRangeOfPoint(playerid, 3.5, factionInfo[playerInfo[playerid][areaFaction]][fEnterX],factionInfo[playerInfo[playerid][areaFaction]][fEnterY], factionInfo[playerInfo[playerid][areaFaction]][fEnterZ])) {
			if(playerInfo[playerid][pFaction] != playerInfo[playerid][areaFaction] && factionInfo[playerInfo[playerid][areaFaction]][fLocked]) return sendPlayerError(playerid, "Nu faci parte din factiunea %s.", factionName(playerInfo[playerid][areaFaction]));						
			SetPlayerPos(playerid, factionInfo[playerInfo[playerid][areaFaction]][fExitX], factionInfo[playerInfo[playerid][areaFaction]][fExitY], factionInfo[playerInfo[playerid][areaFaction]][fExitZ]);
			SetPlayerInterior(playerid, factionInfo[playerInfo[playerid][areaFaction]][fInterior]);
			SetPlayerVirtualWorld(playerid, factionInfo[playerInfo[playerid][areaFaction]][fID]);
			playerInfo[playerid][pinFaction] = playerInfo[playerid][areaFaction];	
			playerInfo[playerid][areaFaction] = 0;
			return true;
		}
		else if(IsPlayerInRangeOfPoint(playerid, 3.5, factionInfo[b][fExitX], factionInfo[b][fExitY], factionInfo[b][fExitZ])) {
			SetPlayerPos(playerid, factionInfo[b][fEnterX],factionInfo[b][fEnterY], factionInfo[b][fEnterZ]);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			playerInfo[playerid][pinFaction] = 0;
			return true;
		}

		if(playerInfo[playerid][pFlymode] == true)  {
			playerInfo[playerid][pFlymode] = false;
			SetPlayerHealthEx(playerid, 100);
			StopFly(playerid);
		}		
		if(Working[playerid] == 2 && IsPlayerInVehicle(playerid, JobVehicle[playerid])) {
			if(!IsTrailerAttachedToVehicle(JobVehicle[playerid])) {
				AttachTrailer(playerid);
			}
		}
		if(!IsPlayerInAnyVehicle(playerid)) {
			new Float:x, Float:y, Float:z;
			foreach(new i : PlayerVehicles[playerid]) {
				if(personalVehicle[i][pvSpawnedID] != INVALID_VEHICLE_ID) {
					GetVehiclePos(personalVehicle[i][pvSpawnedID], x, y, z);
					if(IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z)) {
						SetVehicleParamsForPlayer(personalVehicle[i][pvSpawnedID], playerid, 0, 0);
						break;
					}
				}
			}
		}
	}
	if(PRESSED(KEY_ACTION)) {
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
			callcmd::lights(playerid, "\1");
		}
	}
	if(PRESSED(KEY_FIRE)) {
        if(playerInfo[playerid][pEnableBoost] == 1 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
            new Float:vx,Float:vy,Float:vz;
            GetVehicleVelocity(GetPlayerVehicleID(playerid),vx,vy,vz);
            SetVehicleVelocity(GetPlayerVehicleID(playerid), vx * 1.8, vy *1.8, vz * 1.8);
        }
	}
	if(PRESSED(KEY_ANALOG_DOWN)) {
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || !isBike(GetPlayerVehicleID(playerid)) ||  !isPlane(GetPlayerVehicleID(playerid)) ||  !isBoat(GetPlayerVehicleID(playerid))) {
			new engine, lights, alarm, doors, bonnet, boot, objective;
			GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
			if(vehicle_boot[GetPlayerVehicleID(playerid)] == true) {
				vehicle_boot[GetPlayerVehicleID(playerid)] = false;
				SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_OFF, objective);
				return true;
			}
			vehicle_boot[GetPlayerVehicleID(playerid)] = true;
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_ON, objective);
		}
	}
	if(PRESSED(KEY_ANALOG_UP)) {
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || !isBike(GetPlayerVehicleID(playerid)) ||  !isPlane(GetPlayerVehicleID(playerid)) ||  !isBoat(GetPlayerVehicleID(playerid))) {
			new engine, lights, alarm, doors, bonnet, boot, objective;
			GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
			if(vehicle_bonnet[GetPlayerVehicleID(playerid)] == true) {
				vehicle_bonnet[GetPlayerVehicleID(playerid)] = false;
				SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, VEHICLE_PARAMS_OFF, boot, objective);
				return true;
			}
			vehicle_bonnet[GetPlayerVehicleID(playerid)] = true;
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, VEHICLE_PARAMS_ON, boot, objective);
		}
	}
	if(PRESSED(KEY_NO)) callcmd::lock(playerid, "\1");
	if(PRESSED(KEY_CROUCH)) {
		if(Iter_Contains(FactionMembers[2], playerid) || Iter_Contains(FactionMembers[3], playerid) || Iter_Contains(FactionMembers[4], playerid)) {
			if(IsPlayerInRangeOfPoint(playerid, 15.0, 1542.2355, -1628.0953, 13.4154)) {
				if(IsPlayerInAnyVehicle(playerid) && vehicleFaction[GetPlayerVehicleID(playerid)] == playerInfo[playerid][pFaction]) {
					MoveDynamicObject(gates[0], 1544.7126, -1630.9910, 13.2769, 2.0, 0.0000, -00.0000, -90.0000);
					defer closeGate(1);
				}
			}
	   	}
	}
	if(PRESSED(KEY_SPRINT)) {
		if(playerInfo[playerid][pAnimLooping]) StopLoopingAnim(playerid);
    }
	return true;
}

public OnPlayerStateChange(playerid, newstate, oldstate) {
    print("merge cehats u 2");
	if(newstate == 2 && oldstate == 3) return 1;
	if(newstate == PLAYER_STATE_SPECTATING && playerInfo[playerid][pAdmin] == 0) return va_SendClientMessageToAll(COLOR_LIGHTRED, "(AC) %s a primit kick pentru 'Invisibile Hack'.", getName(playerid)), Kick(playerid);
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) if(Iter_Contains(PlayerInVehicle, playerid)) Iter_Add(PlayerInVehicle, playerid);
	if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER) {
		if(Iter_Contains(PlayerInVehicle, playerid)) Iter_Remove(PlayerInVehicle, playerid);

		new vehicleid = playerInfo[playerid][pinVehicle];
		if(vehicle_personal[vehicleid] > -1) {
			new i = vehicle_personal[vehicleid];
			personalVehicle[i][pvDespawnTime] = (gettime() + 900);
			update("UPDATE `server_personal_vehicles` SET  `Health` = '%f', `Fuel` = '%f', `Odometer`='%f', `DamageDoors`='%d', `DamageLights`='%d', `DamageTires`='%d' WHERE `ID`='%d' LIMIT 1", personalVehicle[i][pvHealth], personalVehicle[i][pvFuel], personalVehicle[i][pvOdometer], personalVehicle[i][pvDamagePanels], personalVehicle[i][pvDamageDoors], personalVehicle[i][pvDamageLights], personalVehicle[i][pvDamageTires],personalVehicle[i][pvID]);
		}	
		playerInfo[playerid][pinVehicle] = -1;
		PlayerTextDrawHide(playerid, fareTD[playerid]);
		if(playerInfo[playerid][pTaxiDriver] != -1) {
		    if(playerInfo[playerid][pTaxiMoney] != 0) {
				if(playerInfo[playerid][pTaxiMoney] >= 100) addRaportPoint(playerInfo[playerid][pTaxiDriver]);
				sendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "%s a platit taximetristului %s suma de $%s pentru cursa efectuata.", getName(playerid), getName(playerInfo[playerid][pTaxiDriver]), formatNumber(playerInfo[playerid][pTaxiMoney]));
				playerInfo[playerid][pTaxiMoney] = 0;
		    }
	        playerInfo[playerid][pTaxiDriver] = -1;
		    PlayerTextDrawHide(playerid, fareTD[playerid]);
			stop taxi[playerid];
		}
		if(playerInfo[playerid][pTaxiDuty] == 1) {
			foreach(new i : loggedPlayers) {
				if(playerInfo[i][pTaxiDriver] == playerid) {
					PlayerTextDrawHide(i, fareTD[playerid]);
					playerInfo[i][pTaxiDriver] = -1;
					playerInfo[playerid][pTaxiMoney] = 0;
					stop taxi[i];
				}
			}
			SCMf(playerid, COLOR_LIMEGREEN, "* Fare: Acum nu mai esti la datorie si ai primit $%s, banii facuti pana in acest moment.", formatNumber(playerInfo[playerid][pTaxiMoney]));
			PlayerTextDrawHide(playerid, fareTD[playerid]);
			GivePlayerCash(playerid, 1, playerInfo[playerid][pTaxiMoney]);
			playerInfo[playerid][pTaxiFare] = 0;
			playerInfo[playerid][pTaxiDuty] = 0;
			playerInfo[playerid][pTaxiMoney] = 0;
		}
	}
	if(newstate == PLAYER_STATE_ONFOOT)
	{	
		stop speedo[playerid];
		PlayerTextDrawSetString(playerid, vehicleHud[10], "000");
		PlayerTextDrawSetString(playerid, vehicleHud[11], "n");
		PlayerTextDrawSetString(playerid, vehicleHud[14], "O");
		PlayerTextDrawSetString(playerid, vehicleHud[15], "C");
		PlayerTextDrawSetString(playerid, vehicleHud[16], "L");
		PlayerTextDrawSetString(playerid, vehicleHud[17], "0000000.0");

		for(new i; i < sizeof vehicleHud; i++) PlayerTextDrawHide(playerid, vehicleHud[i]);
	}
	if(newstate == PLAYER_STATE_DRIVER)
	{
		new vehicleid = playerInfo[playerid][pinVehicle] = GetPlayerVehicleID(playerid);
		if(playerInfo[playerid][pFlyLicense] == 0 && isPlane(vehicleid))
		{
			sendPlayerError(playerid, "Nu ai licenta de pilot.");
			ClearAnimations(playerid);
			return true;
		}

		if(playerInfo[playerid][pBoatLicense] == 0 && isBoat(vehicleid))
		{
			sendPlayerError(playerid, "Nu ai licenta de navigatie.");
			ClearAnimations(playerid);
			return true;
		}

		if(playerInfo[playerid][pDrivingLicense] == 0 && !isBike(vehicleid) && !isBoat(vehicleid) && !isPlane(vehicleid) && vehicleid != playerInfo[playerid][pExamenVehicle])
		{
			sendPlayerError(playerid, "Nu ai licenta de condus.");
			ClearAnimations(playerid);
			return true;
		}
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
		if(vehicle_engine[vehicleid]) {
			SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
		}
		SetVehicleParamsEx(vehicleid, engine, VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective);
		if(vehicle_lights[vehicleid]) {
			SetVehicleParamsEx(vehicleid, engine, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective);
		}
		SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_OFF, objective);
		if(vehicle_boot[vehicleid]) {
			SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_ON, objective);
		}
		SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, VEHICLE_PARAMS_OFF, boot, objective);
		if(vehicle_bonnet[vehicleid]) {
			SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, VEHICLE_PARAMS_ON, boot, objective);
		}
		if(isBike(vehicleid)) {
			SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
			vehicle_engine[vehicleid] =  true;
		}
		if(vehicle_personal[vehicleid] > -1) {
            new id = vehicle_personal[vehicleid];
            SCMf(playerid, COLOR_WHITE, "Acest %s (ID: %d) este detinut de %s | Age: %d zile | Kilometraj: %.02f km | Culori: %d, %d", getVehicleName(personalVehicle[id][pvModelID]), personalVehicle[id][pvID], getName(getVehicleOwner(personalVehicle[id][pvOwnerID])), personalVehicle[id][pvAge], personalVehicle[id][pvOdometer], personalVehicle[id][pvColorOne], personalVehicle[id][pvColorTwo]);
            personalVehicle[id][pvDespawnTime] = 0;
            #pragma unused id
        }

		if(vehicle_engine[GetPlayerVehicleID(playerid)] == true) speedo[playerid] = repeat TimerSpeedo(playerid);
		for(new i; i < 18; i++) PlayerTextDrawShow(playerid, vehicleHud[i]);
	}
	if(newstate == PLAYER_STATE_ONFOOT || oldstate == PLAYER_STATE_DRIVER) {
		if(IsValidVehicle(playerInfo[playerid][pExamenVehicle])) examenFail(playerid);
		if(Working[playerid]) CancelJob(playerid, Working[playerid]);
	}
	if(newstate == PLAYER_STATE_PASSENGER) {
		foreach(new i : FactionMembers[5]) {
			if(playerInfo[i][pTaxiDuty] == 1 && IsPlayerInAnyVehicle(i) && vehicleFaction[GetPlayerVehicleID(i)] == playerInfo[i][pFaction]) {
				if(PlayerMoney(playerid, playerInfo[i][pTaxiFare])) {
			 		SCMf(playerid, COLOR_GREY, "Nu ai $%s pentru a intra in acest taxi.", formatNumber(playerInfo[i][pTaxiFare]));
			 		RemovePlayerFromVehicle(playerid);
				}
				else {
					playerInfo[playerid][pTaxiDriver] = i;
					playerInfo[playerid][pTaxiMoney] = 0;
					taxi[playerid] = repeat fareUpdateTimer(playerid);
					updateTaxiTextdraw(playerid);
				}
			}
		}
	}
	return true;
}

public OnPlayerRequestSpawn(playerid)
{
	if(playerInfo[playerid][pLogged] == true) 
		return SpawnPlayer(playerid);
	return false;
}

public OnPlayerEnterCheckpoint(playerid) 
{
	if(playerInfo[playerid][pExamenCheckpoint] > 0 && IsPlayerInVehicle(playerid, playerInfo[playerid][pExamenVehicle])) {
		DisablePlayerCheckpoint(playerid);
		playerInfo[playerid][pExamenCheckpoint] ++;
		if(!Iter_Contains(ExamenCheckpoints, playerInfo[playerid][pExamenCheckpoint])) {
			playerInfo[playerid][pDrivingLicense] = 100;
			update("UPDATE `server_users` SET `Licenses` = '%d|%d|%d|%d|%d|%d|%d|%d' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerid][pDrivingLicense], playerInfo[playerid][pDrivingLicenseSuspend], playerInfo[playerid][pWeaponLicense], playerInfo[playerid][pWeaponLicenseSuspend], playerInfo[playerid][pFlyLicense], playerInfo[playerid][pFlyLicenseSuspend], playerInfo[playerid][pBoatLicense], playerInfo[playerid][pBoatLicenseSuspend], playerInfo[playerid][pSQLID]);
			DestroyVehicle(playerInfo[playerid][pExamenVehicle]);
			PlayerTextDrawHide(playerid, playerExamenPTD[playerid]);
			playerInfo[playerid][pExamenVehicle] = INVALID_VEHICLE_ID;
			playerInfo[playerid][pExamenCheckpoint] = 0;
			SetPlayerPos(playerid, 1111.0055,-1795.5551,16.5938);
			SetPlayerVirtualWorld(playerid, 0);
			SCM(playerid, COLOR_AQUA, "DMV Exam: {ffffff} Ai trecut cu succes examenul auto, ai primit licenta de condus pentru 100 de payday-uri.");
			return true;
		}
		SetPlayerCheckpoint(playerid, examenInfo[playerInfo[playerid][pExamenCheckpoint]][dmvX], examenInfo[playerInfo[playerid][pExamenCheckpoint]][dmvY], examenInfo[playerInfo[playerid][pExamenCheckpoint]][dmvZ], 3.0);
		va_PlayerTextDrawSetString(playerid, playerExamenPTD[playerid], "DMV Exam~n~Checkpoints:%d/%d~n~Stay Tuned !", (playerInfo[playerid][pExamenCheckpoint] - 1),  Iter_Count(ExamenCheckpoints));
		return true;
	}
	switch(playerInfo[playerid][pCheckpoint]) {
		case CHECKPOINT_FINDCAR: {
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			DisablePlayerCheckpoint(playerid);	
			stop carFind[playerid];
		}
		case CHECKPOINT_GPS: {
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			DisablePlayerCheckpoint(playerid);		
			SCM(playerid, COLOR_SERVER, "* (GPS): {ffffff}Ai ajuns la locatia aleasa.");		
		}
	}
	return true;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)  {
	if(weaponid != 38 && weaponid > 18 && weaponid < 34 && hittype == 1) {
		new Float:codX, Float:codY, Float:codZ, Float:codMX, Float:codMY,  Float:codMZ, Float:DistantaAim, weaponname[25];
		GetPlayerPos(hitid, codX, codY, codZ);
		GetWeaponName(weaponid, weaponname, sizeof(weaponname));
		DistantaAim = GetPlayerDistanceFromPoint(playerid, codX, codY, codZ);
		if(GetPlayerTargetPlayer(playerid) == INVALID_PLAYER_ID && DistantaAim > 1 && DistantaAim < 31 && playerInfo[playerid][pTintaApasata] == 1) {
			AntiCheatWarnings ++;
			if(AntiCheatWarnings >= 10) {
				AntiCheatWarnings = 0;
				sendAdmin(COLOR_SERVER, "Anti-Cheat Notice: {FFFFFF}%s(%d) este posibil sa foloseasca SilentAim (Arma: %s | Distanta: %i m)", getName(playerid), playerid, weaponname, floatround(DistantaAim));
			}
		}
		GetPlayerLastShotVectors(playerid,codX,codY,codZ,codMX,codMY,codMZ);
		if(IsPlayerInRangeOfPoint(playerid, 1, codMX, codMY, codMZ)) {
			AntiCheatWarnings ++;
			if(AntiCheatWarnings >= 5) {
				AntiCheatWarnings = 0;
				sendAdmin(COLOR_SERVER, "Anti-Cheat Notice: {FFFFFF}%s(%d) este posibil sa foloseasca ProAimbot (Arma: %s | Distanta: %i m)", getName(playerid), playerid, weaponname, floatround(DistantaAim));
			}
		}
	}
	if(weaponid == 24 && playerInfo[playerid][pTazer] == 1) {
		TogglePlayerControllable(hitid, 0);
		defer tazerTimer(hitid);
		sendNearbyMessage(playerid, COLOR_GREY, 30.0, "*- %s l-a electrizat pe %s. -*", getName(playerid), getName(hitid));
	}
	if(Iter_Contains(FactionMembers[10], playerid) && Contract[playerid] == hitid) {
        new Float:x, Float:y, Float:z;
        GetPlayerPos(hitid, x, y, z);
        switch(playerInfo[playerid][pFactionRank]) {
            case 1..3: if(weaponid == 34 && GetPlayerDistanceFromPoint(playerid, x, y, z) < 50) return true;
            default: if(weaponid == 34 && GetPlayerDistanceFromPoint(playerid, x, y, z) < 100) return true;
        }
        if(playerInfo[playerid][pCheckpoint] != CHECKPOINT_NONE) {
        	DisablePlayerCheckpoint(playerid);
        	playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
        	playerInfo[playerid][pCheckpointID] = -1;
        }
        addRaportPoint(playerid);
        Iter_Remove(Contracts, contractInfo[Contract[playerid]][cID]);
        ShowPlayerNameTagForPlayer(contractInfo[Contract[playerid]][cAgainst], playerid, true);
        contractInfo[Contract[playerid]][cID] = -1;
        contractInfo[Contract[playerid]][cAgainst] = -1;
        contractInfo[Contract[playerid]][cMoney] = -1;
        new weaponName[25];
        GetWeaponName(weaponid, weaponName, 25);
        Contract[playerid] = -1;
        SCMf(playerid, COLOR_GOLD, "* (Contracts): {ffffff}Ti-ai indeplinit misiunea pe %s (%d) folosind arma %s de la distanta %.1f m.", getName(hitid), hitid, weaponName, GetPlayerDistanceFromPoint(playerid, x, y, z));
    }
	return true;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags) {
	if(!isPlayerLogged(playerid)) defer kickEx(playerid);
	if(DileyCMD[playerid] > gettime()) {
		SCMf(playerid, COLOR_SERVER, "* (Deelay): {ffffff}Poti folosi o comanda peste %d secunde.", DileyCMD[playerid]-gettime());
		return 0;
	}
    return 1; 
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags) {
    if(result == -1) {
        SCMf(playerid, COLOR_SERVER, "* (/%s): {ffffff}Aceasta comanda nu exista pe server.", cmd);
        return 0; 
    }
    DileyCMD[playerid] = gettime()+1;
    return 1; 
}


function loadMaps() {
	#include map/other
	// #include map/spawn
	// #include map/admin_house
	// #include map/CNN
	// #include map/hospital
	// #include map/demorgan
	// #include map/cont
	// #include map/waxta
	// #include map/lspd
	// #include map/avtoscool
	// #include map/ostalnoeb
	// #include map/ferma
	// #include map/mapping
	// #include map/bank
	// #include map/kazik
	// #include map/centerrinok
	// #include map/army_lv
	// #include map/armylvint
	// #include map/armySF
	// #include map/map
	// #include map/map1
	// #include map/map2
	// #include map/map3
	// #include map/map4
	// #include map/kpp
	// #include map/intaksioma
	// #include map/pirs
	// #include map/inter
	// #include map/meria
	// #include map/russianmafia
	// #include map/bayker
	// #include map/podval
	// #include map/newyearhouse1
	// #include map/newyearhouse2
	// #include map/newyearhouse_int
	// #include map/halloweenhouse1
	// #include map/halloweenhouse2
	// #include map/halloweenhouse_int
	// #include map/viphouse1
	// #include map/door
	// #include map/24_7
	// #include map/zapravka
	// #include map/arizonashow
	// #include map/parking
	// #include map/eventsobirateli
	// #include map/radio
	// #include map/vip_house_1
	// #include map/vip_house_2
	// #include map/vip_house_3
	// #include map/vip_house_4
	// #include map/vip_house_5
	// #include map/vip_house_6
	// #include map/vip_house_7
	// #include map/vip_house_8
	// #include map/vip_house_9
	// #include map/vip_house_10
	// #include map/newhouse
	// #include map/GarageInt1
	// #include map/GarageInt2
	// #include map/GarageInt3
	// #include map/GarageInt4
	// #include map/GarageInt5
	// #include map/GarageInt6
}