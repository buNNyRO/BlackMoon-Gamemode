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

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//		<->,<->						 A CONTRIBUTION OF VICENTZO & BUNNY 				<->,<->			//						
//									  -= BLACKMOON GAMEMODE =-											//	
//																										//
//								IDEAS: ROLEX & XSH3D0W TESTING: ROLEX & XSH3D0W							//
//							PROGRAMMING: VICENTZO & BUNNY | WEB-DEVELOPING: BUNNY						//
//						SPECIAL THANKS TO: ASGOOD ADRYAN DANI3L (FOR SUGESSTS)							//
//											AND MANY OTHERS         									//
//						---------> CODEUP.RO <----------> BLACKMOON.RO <-----------						//
// </> In semn de respect lasa acest mesaj aici, iti multumim si spor la coding pe acest gamemode !	</> //
//////////////////////////////////////////////////////////////////////////////////////////////////////////


#define MYSQL 1 // 0 - local | 1 - host
#define VERSION "v1.6.50"

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
#include <easyCheckpoint>
#include <modules\inventory.pwn>
#include <modules\stocks.pwn>
#include <modules\dialogs.pwn>
#include <modules\pickups.pwn>
#include <modules\houses.pwn>
#include <modules\turfs.pwn>
#include <modules\factions.pwn>
#include <modules\safes.pwn>
#include <modules\newjobs.pwn>
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
#include <modules\examen.pwn>

main() { }

alias:adminchat("a", "ac")
alias:helperchat("h", "hc")
alias:setrepsectpoints("setrp", "setrespect")
alias:givelicenseadmin("agl", "admingl")
alias:takelicense("atl", "admintl")
alias:suspendlicense("asl", "adminsl")
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
alias:fly("flymode")

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
	return true;
}

public OnGameModeExit()
{
	mysql_close(SQL);
	return true;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(playerInfo[playerid][pLogged] == true) return SpawnPlayerEx(playerid);


	if(playerInfo[playerid][pLoginEnabled] == true) return true;

	SetPlayerVirtualWorld(playerid, (playerid + 1));
	TogglePlayerControllable(playerid, false);

	InterpolateCameraPos(playerid, 1992.012207, 486.498046, 227.473190, 1141.062500, -1813.197387, 56.129741, 15000);
	InterpolateCameraLookAt(playerid, 1989.800537, 482.112274, 226.538528, 1139.465698, -1808.715454, 54.592548, 15000);
	return true;
}

public OnPlayerConnect(playerid)
{ 
	acReset(playerid);

	resetVars(playerid);
	removeMaps(playerid);	
	GameTextForPlayer(playerid, "PLEASE WAIT~n~CHECKING YOUR ~p~ACCOUNT", 10000, 5);

	switch(MYSQL) {
		case 0: {
			GameTextForPlayer(playerid, "~p~YOUR ACCOUNT IT'S GOOD", 1000, 3);
			mysql_tquery(SQL, string_fast("SELECT * FROM `server_bans` WHERE `Active` = '1' AND `PlayerName` = '%s' LIMIT 1", getName(playerid)), "checkPlayerBan", "d", playerid);
		}
		default: HTTP(playerid, HTTP_GET, string_fast("blackbox.ipinfo.app/lookup/%s", playerInfo[playerid][pLastIp]), "", "TestVPN");
	}
	return true;
}

public OnPlayerDisconnect(playerid, reason)
{
	Iter_Clear(StreamPlayer[playerid]);
	if(Iter_Contains(ServerAdmins, playerid)) 
		Iter_Remove(ServerAdmins, playerid);

	if(Iter_Contains(ServerHelpers, playerid)) 
		Iter_Remove(ServerHelpers, playerid);

	if(Iter_Contains(ServerStaff, playerid)) {
		Iter_Remove(ServerStaff, playerid);
		sendStaff(COLOR_SERVER, "SERVER: {ffffff}%s s-a deconnectat de pe server | Total Staff: %d [%d admins, %d helpers].", getName(playerid), Iter_Count(ServerStaff), Iter_Count(ServerAdmins), Iter_Count(ServerHelpers));
	}

	if(Iter_Contains(MutedPlayers, playerid))
		Iter_Remove(MutedPlayers, playerid);

	if(Iter_Contains(loggedPlayers, playerid))
		Iter_Remove(loggedPlayers, playerid);

	if(playerInfo[playerid][pClan]) {
		Iter_Remove(TotalClanMembers, playerid);
		sendClanMessage(playerInfo[playerid][pClan], clanInfo[playerInfo[playerid][pClan]][cClanColor], "SERVER: {ffffff}%s s-a deconnectat de pe server.", getName(playerid));
	}

	if(playerInfo[playerid][pContractID] > -1) {
		sendFactionMessage(10, COLOR_LIMEGREEN, "* Deoarece %s (%d) a iesit de pe server contractul plasat de %s (%d) pe %s (%d) in valoare de %s$ este valabil.", getName(playerid), playerid, getName(contractInfo[playerInfo[playerid][pContractID]][cBy]), contractInfo[playerInfo[playerid][pContractID]][cBy], getName(contractInfo[playerInfo[playerid][pContractID]][cFor]), contractInfo[playerInfo[playerid][pContractID]][cFor], formatNumber(contractInfo[playerInfo[playerid][pContractID]][cMoney]));
		contractInfo[playerInfo[playerid][pContractID]][cHitman] = -1; 	
    }

    if(playerInfo[playerid][pSpectate] > -1) {
		TogglePlayerSpectating(playerInfo[playerid][pSpectate], 0);
		stop spectator[playerInfo[playerid][pSpectate]];
		playerInfo[playerInfo[playerid][pSpectate]][pSpectate] = -1;
		PlayerTextDrawHide(playerid, specTD[playerInfo[playerid][pSpectate]]);
		SCMf(playerInfo[playerid][pSpectate], COLOR_SERVER, "* (Spectating): Deoarece %s (%d) s-a deconnectat, nu mai esti spectator pe el.", getName(playerid), playerid);
    }

	foreach(new x : Reports) {
		if(ReportInfo[x][reportID] == playerid) {
			sendAdmin(COLOR_SERVER, "Notice Report: {ffffff}Report-ul lui %s a fost anulat automat, deoarece s-a deconectat.", getName(playerid));
			ReportInfo[x][reportID] = INVALID_PLAYER_ID;
			ReportInfo[x][reportPlayer] = INVALID_PLAYER_ID;
			ReportInfo[x][reportType] = REPORT_TYPE_NONE;
			ReportInfo[x][reportText] = (EOS);
			Iter_Remove(Reports, x);
			break;
		}
	}

	if(playerInfo[playerid][pReportChat] != INVALID_PLAYER_ID) {
		SCMf(playerid, COLOR_YELLOW, "* Conversatia a fost inchisa deoarece %s s-a deconectat.", getName(playerid));
		playerInfo[playerInfo[playerid][pReportChat]][pReportChat] = INVALID_PLAYER_ID;
		playerInfo[playerid][pReportChat] = INVALID_PLAYER_ID;
	}
	switch(reason) {
		case 0: sendNearbyMessage(playerid, COLOR_SERVER, 20.0, "(*) {ffffff}%s a iesit de pe server (Crash).", getName(playerid));
    	case 1: sendNearbyMessage(playerid, COLOR_SERVER, 20.0, "(*) {ffffff}%s a iesit de pe server (Quit).", getName(playerid));
   	 	case 2: sendNearbyMessage(playerid, COLOR_SERVER, 20.0, "(*) {ffffff}%s a iesit de pe server (Kicked/Banned).", getName(playerid));
   	}
	update("UPDATE `server_users` SET `Seconds` = '%f', `Mute` = '%d', `ReportMute` = '%d', `Money` = '%d', `MStore` = '%d', `SpawnChange` = '%d', `Jailed` = '%d', `JailTime` = '%d', `WantedLevel` = '%d' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerid][pSeconds], playerInfo[playerid][pMute], (playerInfo[playerid][pReportMute] > gettime()) ? (playerInfo[playerid][pReportMute] - gettime()) : (0), MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSpawnChange], playerInfo[playerid][pJailed], playerInfo[playerid][pJailTime], playerInfo[playerid][pWantedLevel], playerInfo[playerid][pSQLID]);
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
		PreloadAnimLib(playerid, "SWORD");
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
	if(IsValidVehicle(playerInfo[playerid][pExamVeh])) examenFail(playerid);
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
			SetPlayerPos(playerid, -334.0408,1052.1276,19.7392);
			SetPlayerFacingAngle(playerid, 270.4797);
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

stock SendDeathMessageToPlayerEx(playerid, killerid1, killerid2, weapon) {
	SetPlayerName(killerid1, string_fast("%s+%s", getName(killerid1), getName(killerid2)));
	SendClientMessage(playerid, -1, string_fast("%s + %s", getName(killerid1), getName(killerid2)));
	SendDeathMessageToPlayer(playerid, killerid1, playerid, weapon);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason) 
{
	SendDeathMessageToPlayerEx(playerid, playerid, playerid, 32);
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
	if(strmatch(deelayInfo[playerid][Chat], text)) return 0;
	format(deelayInfo[playerid][Chat], 144, text);
	if(playerInfo[playerid][pMute] > gettime()) {
		SCMf(playerid, COLOR_LIGHTRED, eERROR"Ai mute pentru inca %s.", secinmin(playerInfo[playerid][pMute]-gettime()));
		return 0;
	}
	if(playerInfo[playerid][pTalkingLive] != -1) {
		oocNews(COLOR_LIGHTGREEN, "* %s %s: %s", playerInfo[playerid][pFaction] == 6 ? "Reporter" : "Jucator", getName(playerid), text);
		return 0;
	}
	if(playerInfo[playerid][pAdminDuty] != 0) {
		sendNearbyMessage(playerid, COLOR_YELLOW, 50.0, "** Administrator %s spune: %s **", getName(playerid), text); 
		return 0;
	}
	sendNearbyMessage(playerid, GetPlayerColor(playerid), 25.0, "%s {ffffff}spune: %s", getName(playerid), text); 
	SetPlayerChatBubble(playerid, text, COLOR_WHITE, 25.0, 5000);
	update("INSERT INTO `server_chat_logs` (PlayerName, PlayerID, ChatText) VALUES ('%s', '%d', '%s')", getName(playerid), playerInfo[playerid][pSQLID], string_fast("* (chat log): %s.", text));
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(!ispassenger) {
		if(playerInfo[playerid][pFlyLicense] == 0 && isPlane(vehicleid)) {
			SCM(playerid, COLOR_ERROR, eERROR"Nu ai licenta de pilot.");
			ClearAnimations(playerid);
			return true;
		}

		if(playerInfo[playerid][pBoatLicense] == 0 && isBoat(vehicleid)) {
			SCM(playerid, COLOR_ERROR, eERROR"Nu ai licenta de navigatie.");
			ClearAnimations(playerid);
			return true;
		}

		if(playerInfo[playerid][pDrivingLicense] == 0 && !isBike(vehicleid) && !isBoat(vehicleid) && !isPlane(vehicleid) && vehicleid != playerInfo[playerid][pExamVeh]) {
			SCM(playerid, COLOR_ERROR, eERROR"Nu ai licenta de condus.");
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
	if(vehPersonal[vehicleid] > -1) {
		new id = vehPersonal[vehicleid];
		ModVehicle(PersonalVeh[id][pvSpawnedID]);
		if(PersonalVeh[id][pvPaintJob] > -1) {
			ChangeVehiclePaintjob(PersonalVeh[id][pvSpawnedID], PersonalVeh[id][pvPaintJob]);
		}
		#pragma unused id
	}
	vehEngine[vehicleid] = false;
	vehLights[vehicleid] = false;
	vehBonnet[vehicleid] = false;
	vehBoot[vehicleid] = false;
	vehFuel[vehicleid] = 100.0;
	return true;
}

public OnVehicleMod(playerid, vehicleid, componentid) {
	if(vehPersonal[vehicleid] > -1 && Iter_Contains(PlayerVehicles[playerid], vehPersonal[vehicleid])) {
		SaveComponent(vehicleid, componentid);
	}
	return true;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid) {
	if(vehPersonal[vehicleid] > -1 && Iter_Contains(PlayerVehicles[playerid], vehPersonal[vehicleid])) {
		PersonalVeh[vehPersonal[vehicleid]][pvPaintJob] = paintjobid;
		update("UPDATE `server_personal_vehicles` SET `PaintJob`='%d' WHERE `ID`='%d' LIMIT 1", paintjobid, PersonalVeh[vehPersonal[vehicleid]][pvID]);
	}
	return true;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2) {
	if(vehPersonal[vehicleid] > -1 && Iter_Contains(PlayerVehicles[playerid], vehPersonal[vehicleid])) {
		PersonalVeh[vehPersonal[vehicleid]][pvHealth] = 1000;
		update("UPDATE `server_personal_vehicles` SET `Health`= '%f' WHERE `ID`='%d' LIMIT 1", PersonalVeh[vehPersonal[vehicleid]][pvHealth], PersonalVeh[vehPersonal[vehicleid]][pvID]);
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

	if(vehPersonal[vehicleid] > -1) {
		new id = vehPersonal[vehicleid];
		PersonalVeh[id][pvInsurancePoints] --;
		update("UPDATE `server_personal_vehicles` SET `InsurancePoints`='%d' WHERE `ID`='%d' LIMIT 1", PersonalVeh[id][pvInsurancePoints], PersonalVeh[id][pvID]);
		SCMf(getVehicleOwner(PersonalVeh[id][pvOwnerID]), -1, "Vehiculul tau %s a pierdut un punct de asigurare.", getVehicleName(PersonalVeh[id][pvModelID]));
	}

	vehEngine[vehicleid] = false;
	vehLights[vehicleid] = false;
	vehBonnet[vehicleid] = false;
	vehBoot[vehicleid] = false;
	vehFuel[vehicleid] = 100.0;
	return true;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	// if(deelayInfo[playerid][Keys] > GetTickCount()) return 1;
	// deelayInfo[playerid][Keys] = GetTickCount()+500;
	if(newkeys == KEY_SECONDARY_ATTACK) acInfo[playerid][acTimeCrash] = GetTickCount()+1000;
	if(PRESSED(KEY_LOOK_BEHIND)) {
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || !isBike(GetPlayerVehicleID(playerid)) || GetPVarInt(playerid, "engineDeelay") != gettime()) callcmd::engine(playerid, "\1");
	}
	if(PRESSED(KEY_SECONDARY_ATTACK)) {
		new b = GetPlayerVirtualWorld(playerid);
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
					if(playerInfo[playerid][pFishMoney] > 0) {
						SCMf(playerid, COLOR_SERVER, "* (Fisherman): {ffffff}Ai castigat %s$ deoarece ai vandut pestele.", formatNumber(playerInfo[playerid][pFishMoney]));
						GivePlayerCash(playerid, 1, playerInfo[playerid][pFishMoney]);
						playerInfo[playerid][pFishMoney] = 0;
						playerInfo[playerid][pFishTimes] ++;
						playerInfo[playerid][pFishCaught] = 0;
						if(playerInfo[playerid][pFishSkill] < 5) {
							if(playerInfo[playerid][pFishTimes] >= returnNeededPoints(playerid, JOB_FISHER)) {
								playerInfo[playerid][pFishSkill] ++;
								SCMf(playerid, COLOR_SERVER, "* (Fisherman): {ffffff}Ai avansat in skill. Acum ai %d skill si vei castiga mai multi bani.", playerInfo[playerid][pFishSkill]);
							}
						}
						for(new m; m < 2; m++) {
							if(playerInfo[playerid][pDailyMission][m] == 1) checkMission(playerid, m);
						}
						update("UPDATE `server_users` SET `Money`= '%d', `MStore` = '%d', `FishTimes` = '%d', `FishSkill` = '%d' WHERE `ID`='%d' LIMIT 1", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pFishTimes], playerInfo[playerid][pFishSkill], playerInfo[playerid][pSQLID]);
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
		if(playerInfo[playerid][areaHouse] != 0 && IsPlayerInRangeOfPoint(playerid, 3.5, houseInfo[playerInfo[playerid][areaHouse]][hExtX], houseInfo[playerInfo[playerid][areaHouse]][hExtY], houseInfo[playerInfo[playerid][areaHouse]][hExtZ])) {
			if(houseInfo[playerInfo[playerid][areaHouse]][hLocked] == 1) return SCM(playerid, COLOR_ERROR, eERROR"Acesta casa, este inchisa.");
			if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid, COLOR_ERROR, eERROR"Esti intr-un vehicul.");
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
			if(playerInfo[playerid][pFaction] != playerInfo[playerid][areaFaction] && factionInfo[playerInfo[playerid][areaFaction]][fLocked]) return SCMf(playerid, COLOR_ERROR, eERROR"Nu faci parte din factiunea %s.", factionName(playerInfo[playerid][areaFaction]));						
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
		if(!IsPlayerInAnyVehicle(playerid)) {
			new Float:x, Float:y, Float:z;
			foreach(new i : PlayerVehicles[playerid]) {
				if(PersonalVeh[i][pvSpawnedID] != INVALID_VEHICLE_ID) {
					GetVehiclePos(PersonalVeh[i][pvSpawnedID], x, y, z);
					if(IsPlayerInRangeOfPoint(playerid, 5.0, x, y, z)) {
						SetVehicleParamsForPlayer(PersonalVeh[i][pvSpawnedID], playerid, 0, 0);
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
			if(vehBoot[GetPlayerVehicleID(playerid)] == true) {
				vehBoot[GetPlayerVehicleID(playerid)] = false;
				SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_OFF, objective);
				return true;
			}
			vehBoot[GetPlayerVehicleID(playerid)] = true;
			SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_ON, objective);
		}
	}
	if(PRESSED(KEY_ANALOG_UP)) {
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER || !isBike(GetPlayerVehicleID(playerid)) ||  !isPlane(GetPlayerVehicleID(playerid)) ||  !isBoat(GetPlayerVehicleID(playerid))) {
			new engine, lights, alarm, doors, bonnet, boot, objective;
			GetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, bonnet, boot, objective);
			if(vehBonnet[GetPlayerVehicleID(playerid)] == true) {
				vehBonnet[GetPlayerVehicleID(playerid)] = false;
				SetVehicleParamsEx(GetPlayerVehicleID(playerid), engine, lights, alarm, doors, VEHICLE_PARAMS_OFF, boot, objective);
				return true;
			}
			vehBonnet[GetPlayerVehicleID(playerid)] = true;
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
	if(newstate == 2 && oldstate == 3) return 1;
	if(newstate == PLAYER_STATE_SPECTATING && playerInfo[playerid][pAdmin] == 0) return acKicked(playerid, "Invisibile Hack");
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER) {
		if(Iter_Contains(PlayerInVehicle, playerid)) Iter_Add(PlayerInVehicle, playerid);
		if(playerInfo[playerid][pSpectate] > -1) PlayerSpectateVehicle(playerInfo[playerid][pSpectate], GetPlayerVehicleID(playerid));
	}
	if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER) {
		if(Iter_Contains(PlayerInVehicle, playerid)) Iter_Remove(PlayerInVehicle, playerid);
		if(playerInfo[playerid][pSpectate] > -1) PlayerSpectatePlayer(playerInfo[playerid][pSpectate], playerid);
		new vehicleid = playerInfo[playerid][pinVehicle];
		if(vehPersonal[vehicleid] > -1) {
			new i = vehPersonal[vehicleid];
			PersonalVeh[i][pvDespawnTime] = (gettime() + 900);
			update("UPDATE `server_personal_vehicles` SET  `Health` = '%f', `Fuel` = '%f', `Odometer`='%f', `DamageDoors`='%d', `DamageLights`='%d', `DamageTires`='%d' WHERE `ID`='%d' LIMIT 1", PersonalVeh[i][pvHealth], PersonalVeh[i][pvFuel], PersonalVeh[i][pvOdometer], PersonalVeh[i][pvDamagePanels], PersonalVeh[i][pvDamageDoors], PersonalVeh[i][pvDamageLights], PersonalVeh[i][pvDamageTires],PersonalVeh[i][pvID]);
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
		if(IsValidVehicle(playerInfo[playerid][pExamVeh])) examenFail(playerid);
		for(new i; i < sizeof vehicleHud; i++) PlayerTextDrawHide(playerid, vehicleHud[i]);
	}
	if(newstate == PLAYER_STATE_DRIVER)
	{
		new vehicleid = playerInfo[playerid][pinVehicle] = GetPlayerVehicleID(playerid);
		if(playerInfo[playerid][pFlyLicense] == 0 && isPlane(vehicleid))
		{
			SCM(playerid, COLOR_ERROR, eERROR"Nu ai licenta de pilot.");
			ClearAnimations(playerid);
			return true;
		}

		if(playerInfo[playerid][pBoatLicense] == 0 && isBoat(vehicleid))
		{
			SCM(playerid, COLOR_ERROR, eERROR"Nu ai licenta de navigatie.");
			ClearAnimations(playerid);
			return true;
		}

		if(playerInfo[playerid][pDrivingLicense] == 0 && !isBike(vehicleid) && !isBoat(vehicleid) && !isPlane(vehicleid) && vehicleid != playerInfo[playerid][pExamVeh])
		{
			SCM(playerid, COLOR_ERROR, eERROR"Nu ai licenta de condus.");
			ClearAnimations(playerid);
			return true;
		}
		new engine, lights, alarm, doors, bonnet, boot, objective;
		GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
		SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_OFF, lights, alarm, doors, bonnet, boot, objective);
		if(vehEngine[vehicleid]) {
			SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
		}
		SetVehicleParamsEx(vehicleid, engine, VEHICLE_PARAMS_OFF, alarm, doors, bonnet, boot, objective);
		if(vehLights[vehicleid]) {
			SetVehicleParamsEx(vehicleid, engine, VEHICLE_PARAMS_ON, alarm, doors, bonnet, boot, objective);
		}
		SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_OFF, objective);
		if(vehBoot[vehicleid]) {
			SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, VEHICLE_PARAMS_ON, objective);
		}
		SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, VEHICLE_PARAMS_OFF, boot, objective);
		if(vehBonnet[vehicleid]) {
			SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, VEHICLE_PARAMS_ON, boot, objective);
		}
		if(isBike(vehicleid)) {
			SetVehicleParamsEx(vehicleid, VEHICLE_PARAMS_ON, lights, alarm, doors, bonnet, boot, objective);
			vehEngine[vehicleid] =  true;
		}
		if(vehPersonal[vehicleid] > -1) {
            new id = vehPersonal[vehicleid];
            SCMf(playerid, COLOR_WHITE, "Acest %s (ID: %d) este detinut de %s | Age: %d zile | Kilometraj: %.02f km | Culori: %d, %d", getVehicleName(PersonalVeh[id][pvModelID]), PersonalVeh[id][pvID], getName(getVehicleOwner(PersonalVeh[id][pvOwnerID])), PersonalVeh[id][pvAge], PersonalVeh[id][pvOdometer], PersonalVeh[id][pvColorOne], PersonalVeh[id][pvColorTwo]);
            PersonalVeh[id][pvDespawnTime] = 0;
            #pragma unused id
        }

		if(vehEngine[GetPlayerVehicleID(playerid)] == true) speedo[playerid] = repeat TimerSpeedo(playerid);
		for(new i; i < 18; i++) PlayerTextDrawShow(playerid, vehicleHud[i]);
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
		return SpawnPlayerEx(playerid);
	return false;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	Iter_Add(StreamPlayer[playerid], forplayerid);
    return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	Iter_Remove(StreamPlayer[playerid], forplayerid);
    return 1;
}

public OnPlayerEnterCheckpoint(playerid) 
{
	if(playerInfo[playerid][pExamenCP] > 0 && IsPlayerInVehicle(playerid, playerInfo[playerid][pExamVeh])) {
		DisablePlayerCheckpoint(playerid);
		playerInfo[playerid][pExamenCP] ++;
		if(!Iter_Contains(ExamCheckpointIter, playerInfo[playerid][pExamenCP])) {
			playerInfo[playerid][pDrivingLicense] = 100;
			update("UPDATE `server_users` SET `Licenses` = '%d|%d|%d|%d|%d|%d|%d|%d' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerid][pDrivingLicense], playerInfo[playerid][pDrivingLicenseSuspend], playerInfo[playerid][pWeaponLicense], playerInfo[playerid][pWeaponLicenseSuspend], playerInfo[playerid][pFlyLicense], playerInfo[playerid][pFlyLicenseSuspend], playerInfo[playerid][pBoatLicense], playerInfo[playerid][pBoatLicenseSuspend], playerInfo[playerid][pSQLID]);
			DestroyVehicle(playerInfo[playerid][pExamVeh]);
			PlayerTextDrawHide(playerid, playerExamenPTD[playerid]);
			playerInfo[playerid][pExamVeh] = INVALID_VEHICLE_ID;
			playerInfo[playerid][pExamenCP] = 0;
			SetPlayerPos(playerid, 1111.0055,-1795.5551,16.5938);
			SetPlayerVirtualWorld(playerid, 0);
			SCM(playerid, COLOR_AQUA, "DMV Exam: {ffffff} Ai trecut cu succes examenul auto, ai primit licenta de condus pentru 100 de payday-uri.");
			return true;
		}
		SetPlayerCheckpoint(playerid, ExamInformation[playerInfo[playerid][pExamenCP]][dmvX], ExamInformation[playerInfo[playerid][pExamenCP]][dmvY], ExamInformation[playerInfo[playerid][pExamenCP]][dmvZ], 3.0);
		va_PlayerTextDrawSetString(playerid, playerExamenPTD[playerid], "DMV Exam~n~Checkpoints:%d/%d~n~Stay Tuned !", (playerInfo[playerid][pExamenCP] - 1),  Iter_Count(ExamCheckpointIter));
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
	if(weaponid == 24 && playerInfo[playerid][pTazer] == 1) {
		TogglePlayerControllable(hitid, 0);
		defer tazerTimer(hitid);
		sendNearbyMessage(playerid, COLOR_GREY, 30.0, "*- %s l-a electrizat pe %s. -*", getName(playerid), getName(hitid));
	}
	return true;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags) {
	if(!isPlayerLogged(playerid)) defer kickEx(playerid);
	if(deelayInfo[playerid][Commands] > gettime()) {
		SCMf(playerid, COLOR_SERVER, "* (Deelay): {ffffff}Poti folosi o comanda peste %d secunde.", deelayInfo[playerid][Commands]-gettime());
		return 0;
	}
    return 1; 
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags) {
    if(result == -1) {
        SCMf(playerid, COLOR_SERVER, "* (/%s): {ffffff}Aceasta comanda nu exista pe server.", cmd);
        return 0; 
    }
    deelayInfo[playerid][Commands] = gettime()+1;
    return 1; 
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid) {
	if(playertextid == fishTD[playerid][9]) {  
		playerInfo[playerid][pFishSteps] ++;  
		PlayerTextDrawHide(playerid, fishTD[playerid][9]);
		SCMf(playerid, COLOR_SERVER, "* (Fisherman): {ffffff}Progress %d/5 for fishing rod.", playerInfo[playerid][pFishSteps]);
	}
	if(playertextid == fishTD[playerid][10]) {  
		if(playerInfo[playerid][pFishSteps] < 1) return SCM(playerid, COLOR_ERROR, eERROR"Trebuie sa pui obiectele in ordine.");
		playerInfo[playerid][pFishSteps] ++; 
		PlayerTextDrawHide(playerid, fishTD[playerid][10]);
		SCMf(playerid, COLOR_SERVER, "* (Fisherman): {ffffff}Progress %d/5 for fishing rod.", playerInfo[playerid][pFishSteps]);
	}
	if(playertextid == fishTD[playerid][11]) { 
		if(playerInfo[playerid][pFishSteps] < 2) return SCM(playerid, COLOR_ERROR, eERROR"Trebuie sa pui obiectele in ordine.");
		playerInfo[playerid][pFishSteps] ++;
		PlayerTextDrawHide(playerid, fishTD[playerid][11]);
		SCMf(playerid, COLOR_SERVER, "* (Fisherman): {ffffff}Progress %d/5 for fishing rod.", playerInfo[playerid][pFishSteps]);
	}
	if(playertextid == fishTD[playerid][12]) { 
		if(playerInfo[playerid][pFishSteps] < 3) return SCM(playerid, COLOR_ERROR, eERROR"Trebuie sa pui obiectele in ordine.");
		playerInfo[playerid][pFishSteps] ++; 
		PlayerTextDrawHide(playerid, fishTD[playerid][12]);
		SCMf(playerid, COLOR_SERVER, "* (Fisherman): {ffffff}Progress %d/5 for fishing rod.", playerInfo[playerid][pFishSteps]);
	}
	if(playertextid == fishTD[playerid][14]) { 
		if(playerInfo[playerid][pFishSteps] < 4) return SCM(playerid, COLOR_ERROR, eERROR"Trebuie sa pui obiectele in ordine.");
		playerInfo[playerid][pFishingRod] = 100;
		playerInfo[playerid][pFishSteps] = 0;
		SCMf(playerid, COLOR_SERVER, "* (Fisherman): {ffffff}Undita ta are acum 100 HP, va scade 1 HP la fiecare (/fish).");
		for(new i = 0; i < 15; i++) PlayerTextDrawHide(playerid, fishTD[playerid][i]);
		CancelSelectTextDraw(playerid);
	}	
	if(playertextid == examenTD[playerid][5]) {
		switch(playerInfo[playerid][pCertificateStep]) {
			case 1: {
				playerInfo[playerid][pCertificateStep] ++;
				SCM(playerid, COLOR_SERVER, "* (Certificate): {ffffff}Progress 1/3 step for certificate 'ADR'.");
				PlayerTextDrawSetString(playerid, examenTD[playerid][8], "Question #2~n~Care sunt obligatiile unui 'Community Transporter' inainte de plecarea cu marfa de tip 'ADR'?");
				PlayerTextDrawSetString(playerid, examenTD[playerid][10], "a) Nicio obligatie.");
				PlayerTextDrawSetString(playerid, examenTD[playerid][11], "b) Sa plece.");
				PlayerTextDrawSetString(playerid, examenTD[playerid][12], "c) Sa verifice remorca, inclusiv conexiunile.");		
				return true;
			}
			case 2: {
				playerInfo[playerid][pCertificateStep] = 1; playerInfo[playerid][pCertificateSeconds] = 300;
				SCM(playerid, COLOR_SERVER, "* (Certificate): {ffffff}Deoarece ai ales raspunsul corect, ti-a fost resetat testul.");
				PlayerTextDrawSetString(playerid, examenTD[playerid][8], "Question #1~n~Cu cate placi de culoare portocalie trebuie sa fie dotat un tir?");
				PlayerTextDrawSetString(playerid, examenTD[playerid][10], "a) 2 (1 fata, 1 spate)");
				PlayerTextDrawSetString(playerid, examenTD[playerid][11], "b) 1 doar pe spate");
				PlayerTextDrawSetString(playerid, examenTD[playerid][12], "c) niciuna");
				return true;
			}
			case 3: {
				playerInfo[playerid][pCertificateStep] = 1; playerInfo[playerid][pCertificateSeconds] = 300;
				SCM(playerid, COLOR_SERVER, "* (Certificate): {ffffff}Deoarece ai ales raspunsul corect, ti-a fost resetat testul.");
				PlayerTextDrawSetString(playerid, examenTD[playerid][8], "Question #1~n~Cu cate placi de culoare portocalie trebuie sa fie dotat un tir?");
				PlayerTextDrawSetString(playerid, examenTD[playerid][10], "a) 2 (1 fata, 1 spate)");
				PlayerTextDrawSetString(playerid, examenTD[playerid][11], "b) 1 doar pe spate");
				PlayerTextDrawSetString(playerid, examenTD[playerid][12], "c) niciuna");
				return true;
			}
		}
	}
	if(playertextid == examenTD[playerid][6]) {
		switch(playerInfo[playerid][pCertificateStep]) {
			case 1: {
				playerInfo[playerid][pCertificateStep] = 0; 
				SCM(playerid, COLOR_SERVER, "* (Certificate): {ffffff}Deoarece ai ales raspunsul corect si esti la primul stagiu, ti-a fost inchis testul.");
				for(new i = 0; i < 13; i++) PlayerTextDrawHide(playerid, examenTD[playerid][i]);
				stop examen[playerid];
				return true;
			}
			case 2: {
				playerInfo[playerid][pCertificateStep] = 1; playerInfo[playerid][pCertificateSeconds] = 300;
				SCM(playerid, COLOR_SERVER, "* (Certificate): {ffffff}Deoarece ai ales raspunsul corect, ti-a fost resetat testul.");
				PlayerTextDrawSetString(playerid, examenTD[playerid][8], "Question #1~n~Cu cate placi de culoare portocalie trebuie sa fie dotat un tir?");
				PlayerTextDrawSetString(playerid, examenTD[playerid][10], "a) 2 (1 fata, 1 spate)");
				PlayerTextDrawSetString(playerid, examenTD[playerid][11], "b) 1 doar pe spate");
				PlayerTextDrawSetString(playerid, examenTD[playerid][12], "c) niciuna");
				return true;
			}
			case 3: {
				playerInfo[playerid][pCertificateStep] = 0;
				playerInfo[playerid][pCertificate][0] = 30;
				SCM(playerid, COLOR_SERVER, "* (Certificate): {ffffff}Felicitari ! Ai absolvit certificatul de 'ADR' (Valabil: 30 zile) acum poti face curse de mare pericol.");
				for(new i = 0; i < 13; i++) PlayerTextDrawHide(playerid, examenTD[playerid][i]);
				stop examen[playerid];
				return true;
			}
		}	
	}
	if(playertextid == examenTD[playerid][7]) {
		switch(playerInfo[playerid][pCertificateStep]) {
			case 1: {
				playerInfo[playerid][pCertificateStep] = 0; 
				SCM(playerid, COLOR_SERVER, "* (Certificate): {ffffff}Deoarece ai ales raspunsul corect si esti la primul stagiu, ti-a fost inchis testul.");
				for(new i = 0; i < 13; i++) PlayerTextDrawHide(playerid, examenTD[playerid][i]);
				stop examen[playerid];
				return true;
			}
			case 2: {
				playerInfo[playerid][pCertificateStep] ++;
				SCM(playerid, COLOR_SERVER, "* (Certificate): {ffffff}Progress 2/3 step for certificate 'ADR'.");
				PlayerTextDrawSetString(playerid, examenTD[playerid][8], "Question #3~n~Care sunt riscurile ale unui transport de tip'ADR'?");
				PlayerTextDrawSetString(playerid, examenTD[playerid][10], "a) Niciun risc.");
				PlayerTextDrawSetString(playerid, examenTD[playerid][11], "b) Sa explodeze remorca, sa produca avarii.");
				PlayerTextDrawSetString(playerid, examenTD[playerid][12], "c) Sa se piarda lichidul din remorca.");		
				return true;
			}
			case 3: {
				playerInfo[playerid][pCertificateStep] = 1; playerInfo[playerid][pCertificateSeconds] = 300;
				SCM(playerid, COLOR_SERVER, "* (Certificate): {ffffff}Deoarece ai ales raspunsul corect, ti-a fost resetat testul.");
				PlayerTextDrawSetString(playerid, examenTD[playerid][8], "Question #1~n~Cu cate placi de culoare portocalie trebuie sa fie dotat un tir?");
				PlayerTextDrawSetString(playerid, examenTD[playerid][10], "a) 2 (1 fata, 1 spate)");
				PlayerTextDrawSetString(playerid, examenTD[playerid][11], "b) 1 doar pe spate");
				PlayerTextDrawSetString(playerid, examenTD[playerid][12], "c) niciuna");
				return true;
			}
		}	
	}
	return true;
}

function loadMaps() {
	CreateDynamicPickup(1210, 1,-322.8313,1025.3314,19.7422,-1, -1, -1, 50.0); 
	CreateDynamic3DTextLabel("Certificate System\nType /certificate for getting a certificate", -1, -322.8313,1025.3314,19.7422, 20.0, 0xFFFF, 0xFFFF, 0, 0, 0, -1, STREAMER_3D_TEXT_LABEL_SD);
	#include map/other
}
