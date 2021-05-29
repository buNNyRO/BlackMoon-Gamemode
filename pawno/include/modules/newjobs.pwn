#include <YSI\y_hooks>
#define MAX_JOBS (10)

enum jobInfoEnum {
	jobID,
	jobName[32 + 1],
	jobLevel,
	jobLegal,
	Float: jobX,
	Float: jobY,
	Float: jobZ,
	Float: jobXST,
	Float: jobYST,
	Float: jobZST,
	Text3D: jobText,
	Text3D: jobTextST,
	jobPickup,
	jobPickupST
};
new jobInfo[MAX_JOBS][jobInfoEnum], Iterator: ServerJobs<MAX_JOBS>, Timer:FishTimer[MAX_PLAYERS], fishNamesPluta[4][9] = {"Biban", "Stiuca", "Caras", "Crap"},  fishNamesFund[3][9] = {"Somon", "Somn", "Avat"};

enum {
	JOB_NONE,
	JOB_FISHER
};

hook OnGameModeInit() {
	Iter_Init(ServerJobs);
	return true;
}

stock returnNeededPoints(playerid, job) {
	if(!isPlayerLogged(playerid)) return 0;
	if(!Iter_Contains(ServerJobs, job)) return 0;
	switch(job) {
		case JOB_FISHER: {
			switch(playerInfo[playerid][pFishSkill]) {
				case 1: return 25;
				case 2: return 50;
				case 3: return 100;
				case 4: return 200;
			}
		}
	}
	return true;
}

function LoadJobs() {
	if(!cache_num_rows()) return print("Jobs: 0 [From Database]");
	for(new i = 1, j = cache_num_rows() + 1; i != j; i++)  {
	 	cache_get_value_name_int(i - 1, "ID", jobInfo[i][jobID]);
		cache_get_value_name_int(i - 1, "Level", jobInfo[i][jobLevel]);
		cache_get_value_name_int(i - 1, "Legal", jobInfo[i][jobLegal]);
		cache_get_value_name_float(i - 1, "PosX", jobInfo[i][jobX]);
		cache_get_value_name_float(i - 1, "PosY", jobInfo[i][jobY]);
		cache_get_value_name_float(i - 1, "PosZ", jobInfo[i][jobZ]);
		cache_get_value_name_float(i - 1, "XST", jobInfo[i][jobXST]);
		cache_get_value_name_float(i - 1, "YST", jobInfo[i][jobYST]);
		cache_get_value_name_float(i - 1, "ZST", jobInfo[i][jobZST]);
		cache_get_value_name(i - 1, "Name", jobInfo[i][jobName], 32);
		Iter_Add(ServerJobs, i);										 
		jobInfo[i][jobText] = CreateDynamic3DTextLabel(string_fast("Job '%s' (ID: %d)\nJob Level: %d\nLegal: %s\nType (/getjob) to get this job.", jobInfo[i][jobName], i, jobInfo[i][jobLevel], jobInfo[i][jobLegal] ? "{43bf37}Yes{ffffff}" : "{c95349}No{ffffff}"), -1, jobInfo[i][jobX], jobInfo[i][jobY], jobInfo[i][jobZ], 20.0, 0xFFFF, 0xFFFF, 0, 0, 0, -1, STREAMER_3D_TEXT_LABEL_SD);
		jobInfo[i][jobPickup] = CreateDynamicPickup(1239, 1, jobInfo[i][jobX], jobInfo[i][jobY], jobInfo[i][jobZ], 0, 0, -1, STREAMER_PICKUP_SD);
		PickInfo[jobInfo[i][jobPickup]][JOB] = i;
		if(jobInfo[i][jobXST] && jobInfo[i][jobYST] && jobInfo[i][jobZST]) {
			jobInfo[i][jobTextST] = CreateDynamic3DTextLabel(string_fast("Job '%s' (ID: %d)\nTo work at this job type (%s)", jobInfo[i][jobName], i, jobInfo[i][jobID] == 1 ? "/fish" : "/startwork"), -1, jobInfo[i][jobXST], jobInfo[i][jobYST], jobInfo[i][jobZST], 20.0, 0xFFFF, 0xFFFF, 0, 0, 0, -1, STREAMER_3D_TEXT_LABEL_SD);
			jobInfo[i][jobPickupST] = CreateDynamicPickup(1318, 1, jobInfo[i][jobXST], jobInfo[i][jobYST], jobInfo[i][jobZST], 0, 0, -1, STREAMER_PICKUP_SD);		
		}
	}
	return printf("Jobs: %d [From Database]", Iter_Count(ServerJobs));
}

timer timerFishJob[10000](playerid, type) {
	new rand_fish_money = 100000 + random(2500*playerInfo[playerid][pFishingRod]+10000*type*playerInfo[playerid][pFishSkill]), rand_fish = type > 1 ? random(sizeof fishNamesFund) : random(sizeof fishNamesPluta);
	if(type == 1) playerInfo[playerid][pFishCaughtNormal] ++, playerInfo[playerid][pFishBaitNormal] --;
	else if(type == 2) playerInfo[playerid][pFishCaughtSpecial] ++, playerInfo[playerid][pFishBaitSpecial] --;
	playerInfo[playerid][pFishingRod] --;		
	playerInfo[playerid][pFishMoney] += rand_fish_money;		
	playerInfo[playerid][pFishCaught] ++;																				
	SCMf(playerid, COLOR_SERVER, "* (Fisherman): {ffffff}Ai prins un '%s' (%s) iar acesta va valora %s$ (Total Fishes Money: %s$).", type > 1 ? fishNamesFund[rand_fish] : fishNamesPluta[rand_fish], type > 1 ? "Fund" : "Pluta", formatNumber(rand_fish_money), formatNumber(playerInfo[playerid][pFishMoney]));
	SCMf(playerid, COLOR_SERVER, "* (Fisherman): {ffffff}Deoarece ai prins un peste ti-a fost scazut 1 HP (HP-ul actual: %d) de la undita si 1 momeala de %s.", playerInfo[playerid][pFishingRod], type > 1 ? "fund" : "pluta");
	ClearAnimations(playerid);
	RemovePlayerAttachedObject(playerid, 9);
	TogglePlayerControllable(playerid, 1);
	return true;
}

Dialog:DIALOG_JOBS(playerid, response, listitem) {
	if(!response) return true;
	if(playerInfo[playerid][pCheckpoint] != CHECKPOINT_NONE) return SCM(playerid, COLOR_ERROR, eERROR"Ai un checkpoint activ pe minimap, foloseste comanda (/killcp).");
	SetPlayerCheckpoint(playerid, jobInfo[listitem + 1][jobX], jobInfo[listitem + 1][jobY], jobInfo[listitem + 1][jobZ], 3);
	playerInfo[playerid][pCheckpoint] = CHECKPOINT_GPS;
	playerInfo[playerid][pCheckpointID] = listitem + 1;
	SCMf(playerid, COLOR_SERVER, "* (GPS): {ffffff}Ti-a fost setat un checkpoint catre job-ul '%s' (ID: %d).", jobInfo[listitem + 1][jobName], jobInfo[listitem + 1][jobID]); 
	return true;
}

CMD:jobs(playerid, params[]) {
	if(!Iter_Count(ServerJobs)) return SCM(playerid, COLOR_ERROR, eERROR"Nu sunt job-uri disponibile pe server.");
	if(Dialog_Opened(playerid)) return SCM(playerid, COLOR_ERROR, eERROR"Nu poti folosi aceasta comanda cat timp ai un dialog afisat.");
	gString[0] = (EOS);
	foreach(new i : ServerJobs) format(gString, sizeof(gString), "Job ID\tJob Name\tJob Level\tJob Legal\n#%d\t%s\t%d\t%s\n", i, jobInfo[i][jobName], jobInfo[i][jobLevel], jobInfo[i][jobLegal] ? "{43bf37}Yes{ffffff}" : "{c95349}No{ffffff}");
	Dialog_Show(playerid, DIALOG_JOBS, DIALOG_STYLE_TABLIST_HEADERS, "Server: Jobs", gString, "Select", "Cancel");
	return true;
}

CMD:getjob(playerid, params[]) {
	if(!Iter_Count(ServerJobs)) return SCM(playerid, COLOR_ERROR, eERROR"Nu sunt job-uri disponibile pe server.");
	if(playerInfo[playerid][pJob] != 0) return SCM(playerid, COLOR_ERROR, eERROR"Ai deja un job, foloseste comanda (/quitjob).");
	if(playerInfo[playerid][areaJob] != 0 && IsPlayerInRangeOfPoint(playerid, 3.5, jobInfo[playerInfo[playerid][areaJob]][jobX], jobInfo[playerInfo[playerid][areaJob]][jobY], jobInfo[playerInfo[playerid][areaJob]][jobZ])) {
		if(playerInfo[playerid][pLevel] < jobInfo[playerInfo[playerid][areaJob]][jobLevel]) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai level-ul necesar pentru acest job.");
		playerInfo[playerid][pJob] = playerInfo[playerid][areaJob];
		update("UPDATE `server_users` SET `Job` = '%d' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerid][pJob], playerInfo[playerid][pSQLID]);
		SCMf(playerid, COLOR_SERVER, "* (Jobs): {ffffff}Acum jobul tau este '%s' (ID: %d).", jobInfo[playerInfo[playerid][areaJob]][jobName], playerInfo[playerid][areaJob]);
	}
	return true;
}

CMD:quitjob(playerid, params[]) {
	if(playerInfo[playerid][pJob] == 0) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai un job, foloseste comanda (/getjob) la un job.");
	playerInfo[playerid][pJob] = 0;
	update("UPDATE `server_users` SET `Job` = '0' WHERE `ID` = '%d' LIMIT 1", playerInfo[playerid][pSQLID]);
	SCM(playerid, COLOR_SERVER, "* (Jobs): {ffffff}Ai demisionat de la locul tau de munca.");
	return true;
}

CMD:skills(playerid, params[]) {
	if(playerInfo[playerid][pJob] == 0) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai un job, foloseste comanda (/getjob) la un job.");
	SCM(playerid, COLOR_SERVER, "* --- Job{ffffff} Skills{cc66ff} --- *");
	SCMf(playerid, COLOR_SERVER, "* (Fisherman): {ffffff}%d (%s)", playerInfo[playerid][pFishSkill], playerInfo[playerid][pFishSkill] >= 5 ? ("%d times", playerInfo[playerid][pFishTimes]) : ("%d times, %d needed", playerInfo[playerid][pFishTimes], returnNeededPoints(playerid, JOB_FISHER)));
	return true;
}

CMD:startwork(playerid, params[]) {
	if(playerInfo[playerid][pJob] == 0) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai un job, foloseste (/getjob).");
	if(playerInfo[playerid][pWorking] != 0) return SCM(playerid, COLOR_ERROR, eERROR"Lucrezi deja la un job.");
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid, COLOR_ERROR, eERROR"Nu poti lucra din vehicul.");
	if(playerInfo[playerid][pCheckpoint] != CHECKPOINT_NONE) return SCM(playerid, COLOR_ERROR, eERROR"Ai deja un checkpoint, pe mini map.");
	if(playerInfo[playerid][pDrivingLicense] <= 0) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai licenta de condus.");
	if(playerInfo[playerid][pDrivingLicenseSuspend] > 0) return SCMf(playerid, COLOR_ERROR, eERROR"Ai licenta suspendata pentru %d ore.", playerInfo[playerid][pDrivingLicenseSuspend]);
	if(!IsPlayerInRangeOfPoint(playerid, 3.5, jobInfo[playerInfo[playerid][pJob]][jobXST], jobInfo[playerInfo[playerid][pJob]][jobYST], jobInfo[playerInfo[playerid][pJob]][jobZST])) return SCM(playerid, COLOR_ERROR, eERROR"Nu esti la punctul de start work al jobului tau.");
	switch(playerInfo[playerid][pJob]) {
		case 1: return SCM(playerid, COLOR_SERVER, eERROR"Pentru a lucra la acest job foloseste comanda (/fish).");
	}
	return true;
}

CMD:fish(playerid, params[]) {
	if(playerInfo[playerid][pJob] != 1) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai job-ul 'Fisherman'.");
	if(playerInfo[playerid][pWorking]) return SCM(playerid, COLOR_ERROR, eERROR"Nu poti face acest lucru, deoarece deja muncesti.");
	if(playerInfo[playerid][pFishCaught] == 5) return SCM(playerid, COLOR_ERROR, eERROR"Nu poti prinde mai mult de 5 pesti.");
	if(!IsPlayerInRangeOfPoint(playerid, 3.5, -418.0396,1163.5547,2.3219)) return SCM(playerid, COLOR_ERROR, eERROR"Nu esti in zona de pescuit.");
	if(playerInfo[playerid][pFishingRod] == 0) {
		SCM(playerid, COLOR_SERVER, "* (Fisherman): {ffffff}Deoarece undita ta nu este aranjata / nu mai are durabilitate de viata aceasta trebuie aranjata.");
		SelectTextDraw(playerid, COLOR_GREY);
		va_PlayerTextDrawSetString(playerid, fishTD[playerid][7], "%d", playerInfo[playerid][pFishCaughtNormal]);
		va_PlayerTextDrawSetString(playerid, fishTD[playerid][8], "%d", playerInfo[playerid][pFishCaughtSpecial]);
		for(new i = 0; i < 15; i++) PlayerTextDrawShow(playerid, fishTD[playerid][i]);
		return true;
	}
	extract params -> new type; else {
		SCM(playerid, COLOR_GREY, "* Optiuni Type: (1) Pluta / (2) Fund");
		return sendPlayerSyntax(playerid, "/fish <type>");
	}
	if(!(1 <= type <= 2)) return SCM(playerid, COLOR_ERROR, eERROR"Invalid type (1 - 2).");
	if(type == 1 && playerInfo[playerid][pFishBaitNormal] < 1) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai momeala pentru pluta.");
	else if(type == 2 && playerInfo[playerid][pFishBaitSpecial] < 1) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai momeala pentru fund.");
	TogglePlayerControllable(playerid, 0);
	ApplyAnimation(playerid, "SWORD", "SWORD_IDLE", 4.1, true, false, false,false, 0, false);
	SetPlayerAttachedObject(playerid, 9, 18632,6,0.079376,0.037070,0.007706,181.482910,0.000000,0.000000,1.000000,1.000000,1.000000);
	FishTimer[playerid] = defer timerFishJob(playerid, type);
	playerInfo[playerid][pWorking] = 1;
	return true;
}

stock jobWork(playerid, job) {
	switch(job) {
		/*case JOB_CARPENTER: {
			JobVehicle[playerid] = CreateVehicle(456, 1027.2261, -1451.8898, 13.3994, 90.2400, 1, 1, -1);
			PutPlayerInVehicleEx(playerid, JobVehicle[playerid], 0);
			playerInfo[playerid][pCheckpointID] = JobVehicle[playerid];
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_CARPENTER;	
			SetPlayerCheckpoint(playerid, -64.9157,-1120.2693,1.0781, 4.5);	
		}*/
	}	
	vehicle_fuel[JobVehicle[playerid]] = 100.0;
	vehicle_personal[JobVehicle[playerid]] = -1;
	vehicle_engine[JobVehicle[playerid]] = true;
	Working[playerid] = job;
	return true;
}
		
// CancelJob(playerid, job) {
// 	switch(job) {
// 		case JOB_FISHER: {
// 			// coming soon
// 		}
// 	}
// 	return true;
// }
