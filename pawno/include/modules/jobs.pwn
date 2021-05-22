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
new jobInfo[MAX_JOBS + 1][jobInfoEnum], Iterator: ServerJobs<MAX_JOBS + 1>, Fishing[MAX_PLAYERS], FishWeight[MAX_PLAYERS], Timer: FishTimer[MAX_PLAYERS],
	FishNames[5][9] = {
		"Biban", "Stiuca", "Caras", "Crap", "Somon"
	}, Working[MAX_PLAYERS], JobVehicle[MAX_PLAYERS], Trailer[MAX_PLAYERS], JobMoney[MAX_PLAYERS], UsingDrugs[MAX_PLAYERS];
enum {
	JOB_NONE,
	JOB_FISHER,
	JOB_TRUCKER,
	JOB_DRUGSDEALER,
	JOB_ARMSDEALER,
	JOB_CARPENTER
};

hook OnGameModeInit() {
	Iter_Init(ServerJobs);
	return true;
}

hook OnPlayerConnect(playerid) {
	playerInfo[playerid][pJob] = JOB_NONE;
	playerInfo[playerid][pFishSkill] = 1;
	playerInfo[playerid][pFishTimes] = 0;
	playerInfo[playerid][pTruckSkill] = 1;
	playerInfo[playerid][pTruckTimes] = 0;
	playerInfo[playerid][pDrugsSkill] = 1;
	playerInfo[playerid][pDrugsTimes] = 0;
	playerInfo[playerid][pArmsSkill] = 1;
	playerInfo[playerid][pArmsTimes] = 0;
	playerInfo[playerid][pCarpenterSkill] = 1;
	playerInfo[playerid][pCarpenterTimes] = 0;
	FishWeight[playerid] = 0;
	Fishing[playerid] = false;
	Working[playerid] = 0;
	JobVehicle[playerid] = -1;
	Trailer[playerid] = -1;
	JobMoney[playerid] = 0;
	UsingDrugs[playerid] = 0;
	RemovePlayerAttachedObject(playerid, 9);
	ApplyAnimation(playerid, "SWORD", "Null", 0.0, 0, 0, 0,0,0);
	ApplyAnimation(playerid, "CRACK", "Null", 0.0, 0, 0, 0,0,0);
	return true;
}

hook OnPlayerDisconnect(playerid, reason) {
	if(FishTimer[playerid] != Timer:-1) {
		stop FishTimer[playerid];
		FishTimer[playerid] = Timer:-1;
	}
	return true;
}

stock returnNeededPoints(playerid, job) {
	if(!IsPlayerConnected(playerid)) return 0;
	if(!Iter_Contains(ServerJobs, job)) return 0;
	switch(job) {
		case JOB_FISHER: {
			switch(playerInfo[playerid][pFishSkill]) {
				case 1: return 50;
				case 2: return 100;
				case 3: return 150;
				case 4: return 250;
			}
		}
		case JOB_TRUCKER: {
			switch(playerInfo[playerid][pTruckSkill]) {
				case 1: return 15;
				case 2: return 25;
				case 3: return 35;
				case 4: return 50;
			}		
		}
		case JOB_DRUGSDEALER: {
			switch(playerInfo[playerid][pDrugsSkill]) {
				case 1: return 5;
				case 2: return 10;
				case 3: return 15;
				case 4: return 30;
			}		
		}
		case JOB_ARMSDEALER: {
			switch(playerInfo[playerid][pArmsSkill]) {
				case 1: return 3;
				case 2: return 12;
				case 3: return 19;
				case 4: return 35;
			}		
		}
		case JOB_CARPENTER: {
			switch(playerInfo[playerid][pCarpenterSkill]) {
				case 1: return 10;
				case 2: return 20;
				case 3: return 40;
				case 4: return 60;
			}		
		}

	}
	return -1;
}

Dialog:TRUCKER_SELECT(playerid, response, listitem) {
	if(!response) CancelJob(playerid, JOB_TRUCKER);
	switch(listitem) {
		case 0: {
			playerInfo[playerid][pCheckpointID] = JobVehicle[playerid];
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_TRUCKERSF;
			SetPlayerCheckpoint(playerid, -1560.3292,-447.7977,6.0000, 4.5);
	        new Float:pX,Float:pY,Float:pZ,Float:vA;
			GetPlayerPos(playerid,pX,pY,pZ);
			GetVehicleZAngle(JobVehicle[playerid],vA);
			Trailer[playerid] = CreateVehicle(435, pX+6, pY+6, pZ+6, vA, -1, -1, -1);
		}
		case 1: {
			playerInfo[playerid][pCheckpointID] = JobVehicle[playerid];
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_TRUCKERLV;
			SetPlayerCheckpoint(playerid, 1889.2887,1135.9785,10.8203, 4.5);
	        new Float:pX,Float:pY,Float:pZ,Float:vA;
			GetPlayerPos(playerid,pX,pY,pZ);
			GetVehicleZAngle(JobVehicle[playerid],vA);
			Trailer[playerid] = CreateVehicle(450, pX+6, pY+6, pZ+6, vA, -1, -1, -1);	
		}
	}
	return true;
}

Dialog:TRUCKER_SELECTTWO(playerid, response, listitem) {
	if(!response) CancelJob(playerid, JOB_TRUCKER);
    switch(listitem) {
		case 0: {
			playerInfo[playerid][pCheckpointID] = JobVehicle[playerid];
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_TRUCKERLS;
			SetPlayerCheckpoint(playerid, 1435.5371,-2338.0239,13.5469, 4.5);
	        new Float:pX,Float:pY,Float:pZ,Float:vA;
			GetPlayerPos(playerid,pX,pY,pZ);
			GetVehicleZAngle(JobVehicle[playerid],vA);
			Trailer[playerid] = CreateVehicle(435, pX+6, pY+6, pZ+6, vA, -1, -1, -1);
		}
		case 1: {
			playerInfo[playerid][pCheckpointID] = JobVehicle[playerid];
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_TRUCKERLV;
			SetPlayerCheckpoint(playerid, 1889.2887,1135.9785,10.8203, 4.5);
	        new Float:pX,Float:pY,Float:pZ,Float:vA;
			GetPlayerPos(playerid,pX,pY,pZ);
			GetVehicleZAngle(JobVehicle[playerid],vA);
			Trailer[playerid] = CreateVehicle(450, pX+6, pY+6, pZ+6, vA, -1, -1, -1);		
		}
	}
	return true;
}

Dialog:TRUCKER_SELECTTHREE(playerid, response, listitem) {
	if(!response) CancelJob(playerid, JOB_TRUCKER);
    switch(listitem) {
		case 0: {
			playerInfo[playerid][pCheckpointID] = JobVehicle[playerid];
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_TRUCKERSF;
			SetPlayerCheckpoint(playerid, -1560.3292,-447.7977,6.0000, 4.5);
	        new Float:pX,Float:pY,Float:pZ,Float:vA;
			GetPlayerPos(playerid,pX,pY,pZ);
			GetVehicleZAngle(JobVehicle[playerid],vA);
			Trailer[playerid] = CreateVehicle(435, pX+6, pY+6, pZ+6, vA, -1, -1, -1);
		}
		case 1: {
			playerInfo[playerid][pCheckpointID] = JobVehicle[playerid];
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_TRUCKERLS;
			SetPlayerCheckpoint(playerid, 1435.5371,-2338.0239,13.5469, 4.5);
	        new Float:pX,Float:pY,Float:pZ,Float:vA;
			GetPlayerPos(playerid,pX,pY,pZ);
			GetVehicleZAngle(JobVehicle[playerid],vA);
			Trailer[playerid] = CreateVehicle(435, pX+6, pY+6, pZ+6, vA, -1, -1, -1);
		}
	}
	return true;
}
	
function AttachTrailer(playerid) {
	new Float:pX, Float:pY, Float:pZ,Float:vX, Float:vY, Float:vZ;
	GetPlayerPos(playerid,pX,pY,pZ);
	GetVehiclePos(Trailer[playerid],vX,vY,vZ);
	if((floatabs(pX-vX)<100.0)&&(floatabs(pY-vY)<100.0)&&(floatabs(pZ-vZ)<100.0)&&(Trailer[playerid]!=GetPlayerVehicleID(playerid)))  AttachTrailerToVehicle(Trailer[playerid],JobVehicle[playerid]);
	return 1;
}

function LoadJobs() {
	if(!cache_num_rows()) return print("Jobs: 0 [From Database]");
	new legal[24];
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
		if(jobInfo[i][jobLegal] == 1) legal = "{43bf37}Yes{ffffff}";
		else if(jobInfo[i][jobLegal] == 0) legal = "{c95349}No{ffffff}";

		jobInfo[i][jobText] = CreateDynamic3DTextLabel(string_fast("Job ID: %d\nJob Name: %s\nJob Level: %d\nLegal: %s\nType (/getjob) to get this job.", i, jobInfo[i][jobName], jobInfo[i][jobLevel], legal), -1, jobInfo[i][jobX], jobInfo[i][jobY], jobInfo[i][jobZ], 20.0, 0xFFFF, 0xFFFF, 0, 0, 0, -1, STREAMER_3D_TEXT_LABEL_SD);
		jobInfo[i][jobPickup] = CreateDynamicPickup(1239, 1, jobInfo[i][jobX], jobInfo[i][jobY], jobInfo[i][jobZ], 0, 0, -1, STREAMER_PICKUP_SD);
		PickInfo[jobInfo[i][jobPickup]][JOB] = i;
		if(jobInfo[i][jobXST] && jobInfo[i][jobYST] && jobInfo[i][jobZST]) {
			jobInfo[i][jobTextST] = CreateDynamic3DTextLabel(string_fast("%s (ID:%d)\nstart work type (/startwork).", jobInfo[i][jobName], i), -1, jobInfo[i][jobXST], jobInfo[i][jobYST], jobInfo[i][jobZST], 20.0, 0xFFFF, 0xFFFF, 0, 0, 0, -1, STREAMER_3D_TEXT_LABEL_SD);
			jobInfo[i][jobPickupST] = CreateDynamicPickup(1318, 1, jobInfo[i][jobXST], jobInfo[i][jobYST], jobInfo[i][jobZST], 0, 0, -1, STREAMER_PICKUP_SD);		
		}
	}

	return printf("Jobs: %d [From Database]", Iter_Count(ServerJobs));
}

timer FishingTimer[10 * 1000](playerid, Float:x, Float:y, Float:z) {
	if(!IsPlayerConnected(playerid)) return 0;
	if(!Fishing[playerid]) return 0;
	Fishing[playerid] = false;
	ClearAnimations(playerid);
	RemovePlayerAttachedObject(playerid, 9);
	TogglePlayerControllable(playerid, true);
	if(!IsPlayerInRangeOfPoint(playerid, 1.0, x, y, z)) {
		SCM(playerid, COLOR_GREY, "* Ai speriat pestele iar acesta a fugit de tine.");
	}
	else {
		new rand = random(sizeof FishNames);
		FishWeight[playerid] = (playerInfo[playerid][pFishSkill] * 15) + (50 + random(25));
		SCM(playerid, COLOR_GREY, string_fast("* Fish Notice: Ai prins un %s ce cantareste %d kg.\nPentru a vinde pestele, trebuie sa te duci la un 24/7", FishNames[rand], FishWeight[playerid]));
		sendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "* Pescar %s a prins un %d kg.", getName(playerid), FishWeight[playerid]);
	}
	return true;
}	

Dialog:DIALOG_JOBS(playerid, response, listitem, inputtext[]) {
	if(!response) return true;
	if(playerInfo[playerid][pCheckpoint] != CHECKPOINT_NONE) return SCM(playerid, COLOR_ERROR, eERROR"Ai un checkpoint activ pe harta.");
	SetPlayerCheckpoint(playerid, jobInfo[listitem + 1][jobX], jobInfo[listitem + 1][jobY], jobInfo[listitem + 1][jobZ], 2.0);
	SCM(playerid, COLOR_GREY, string_fast("* Ti-am plasat un checkpoint catre job-ul %s.", jobInfo[listitem + 1][jobName]));
	playerInfo[playerid][pCheckpoint] = CHECKPOINT_JOB;
	playerInfo[playerid][pCheckpointID] = listitem  + 1;
	return true;
}

CMD:jobs(playerid, params[]) {
	if(!Iter_Count(ServerJobs)) return SCM(playerid, COLOR_ERROR, eERROR"Nu sunt job-uri disponibile pe server.");
	if(Dialog_Opened(playerid)) return SCM(playerid, COLOR_ERROR, eERROR"Nu poti folosi aceasta comanda cat timp ai un dialog afisat.");
	new string[256] = "Job Name\tJob Level\tJob Legal\n", legal[24];
	foreach(new i : ServerJobs) {
		if(jobInfo[i][jobLegal] == 1) legal = "{43bf37}Yes{ffffff}";
		else if(jobInfo[i][jobLegal] == 0) legal = "{c95349}No{ffffff}";
		format(string, sizeof(string), "%s{ffffff}%s\t%d\t%s\n", string, jobInfo[i][jobName], jobInfo[i][jobLevel], legal);	
	}
	Dialog_Show(playerid, DIALOG_JOBS, DIALOG_STYLE_TABLIST_HEADERS, "SERVER: Jobs", string, "Select", "Cancel");
	return true;
}

CMD:getjob(playerid, params[]) {
	if(!Iter_Count(ServerJobs)) return SCM(playerid, COLOR_ERROR, eERROR"Nu sunt job-uri disponibile pe server.");
	if(playerInfo[playerid][pJob] != 0) return SCM(playerid, COLOR_ERROR, eERROR"Ai deja un job, foloseste (/quitjob).");
	if(playerInfo[playerid][areaJob] != 0 && IsPlayerInRangeOfPoint(playerid, 3.5, jobInfo[playerInfo[playerid][areaJob]][jobX], jobInfo[playerInfo[playerid][areaJob]][jobY], jobInfo[playerInfo[playerid][areaJob]][jobZ])) {
		if(playerInfo[playerid][pLevel] < jobInfo[playerInfo[playerid][areaJob]][jobLevel]) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai level-ul necesar pentru acest job.");
		playerInfo[playerid][pJob] = playerInfo[playerid][areaJob];
		update("UPDATE `server_users` SET `Job` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pJob], playerInfo[playerid][pSQLID]);
		SCM(playerid, COLOR_GREY, string_fast("* Job Notice: Acum ai jobul '%s'.", jobInfo[playerInfo[playerid][areaJob]][jobName]));
	}
	return true;
}

CMD:quitjob(playerid, params[]) {
	if(playerInfo[playerid][pJob] == 0) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai un job, foloseste (/getjob).");
	if(Working[playerid]) CancelJob(playerid, Working[playerid]);
	playerInfo[playerid][pJob] = 0;
	gQuery[0] = EOS;
	mysql_format(SQL, gQuery, sizeof(gQuery), "UPDATE `server_users` SET `Job` = '0' WHERE `ID` = '%d'", playerInfo[playerid][pSQLID]);
	mysql_tquery(SQL, gQuery);	
	SCM(playerid, COLOR_GREY, "* Ai demisionat de la locul tau de munca.");
	return true;
}

CMD:fish(playerid, params[]) {
	if(playerInfo[playerid][pJob] != 1) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai jobul 'Fisher'.");
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid, COLOR_ERROR, eERROR"Nu poti pescui din vehicul.");
	if(!IsPlayerInArea(playerid, 348, -2089, 411, -2074)) return SCM(playerid, COLOR_ERROR, eERROR"Nu esti in zona in care poti pescui.");
	if(Fishing[playerid]) return SCM(playerid, COLOR_ERROR, eERROR"Deja pescuiesti.");
	if(FishWeight[playerid]) return SCM(playerid, COLOR_ERROR, eERROR"Ai deja un peste prins.");
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	Fishing[playerid] = true;
	FishTimer[playerid] = defer FishingTimer(playerid, x, y, z);
	TogglePlayerControllable(playerid, false);
	ClearAnimations(playerid);
	ApplyAnimation(playerid, "SWORD", "SWORD_IDLE", 4.1, true, false, false,false, 0, false);
	SetPlayerAttachedObject(playerid, 9, 18632,6,0.079376,0.037070,0.007706,181.482910,0.000000,0.000000,1.000000,1.000000,1.000000);
	return true;
}

CMD:skills(playerid, params[]) {
	SCM(playerid, COLOR_GREY, "* --- Jobs Skills --- *");
	if(playerInfo[playerid][pFishSkill] >= 5) SCM(playerid, COLOR_WHITE, string_fast("* Fisherman: 5 (%d times)", playerInfo[playerid][pFishTimes]));
	else SCM(playerid, COLOR_WHITE, string_fast("* (Fisherman): %d (%d times, %d needed)", playerInfo[playerid][pFishSkill], playerInfo[playerid][pFishTimes], returnNeededPoints(playerid, JOB_FISHER)));
	if(playerInfo[playerid][pTruckSkill] >= 5) SCM(playerid, COLOR_WHITE, string_fast("* Truck: 5 (%d times)", playerInfo[playerid][pTruckTimes]));
	else SCM(playerid, COLOR_WHITE, string_fast("* (Truck): %d (%d times, %d needed)", playerInfo[playerid][pTruckSkill], playerInfo[playerid][pTruckTimes], returnNeededPoints(playerid, JOB_TRUCKER)));
	if(playerInfo[playerid][pDrugsSkill] >= 5) SCM(playerid, COLOR_WHITE, string_fast("* Drugs Dealer: 5 (%d times)", playerInfo[playerid][pDrugsTimes]));
	else SCM(playerid, COLOR_WHITE, string_fast("* (Drugs Dealer): %d (%d times, %d needed)", playerInfo[playerid][pDrugsSkill], playerInfo[playerid][pDrugsTimes], returnNeededPoints(playerid, JOB_DRUGSDEALER)));	
	if(playerInfo[playerid][pArmsSkill] >= 5) SCM(playerid, COLOR_WHITE, string_fast("* Arms Dealer: 5 (%d times)", playerInfo[playerid][pArmsTimes]));
	else SCM(playerid, COLOR_WHITE, string_fast("* (Arms Dealer): %d (%d times, %d needed)", playerInfo[playerid][pArmsSkill], playerInfo[playerid][pArmsTimes], returnNeededPoints(playerid, JOB_ARMSDEALER)));	
	if(playerInfo[playerid][pCarpenterSkill] >= 5) SCM(playerid, COLOR_WHITE, string_fast("* Carpenter: 5 (%d times)", playerInfo[playerid][pCarpenterTimes]));
	else SCM(playerid, COLOR_WHITE, string_fast("* (Carpenter): %d (%d times, %d needed)", playerInfo[playerid][pCarpenterSkill], playerInfo[playerid][pCarpenterTimes], returnNeededPoints(playerid, JOB_CARPENTER)));		
	return true;
}

CMD:startwork(playerid, params[]) {
	if(playerInfo[playerid][pJob] == 0) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai un job, foloseste (/getjob).");
	if(IsPlayerInAnyVehicle(playerid)) return SCM(playerid, COLOR_ERROR, eERROR"Nu poti lucra din vehicul.");
	if(Working[playerid] != 0) return SCM(playerid, COLOR_ERROR, eERROR"Deja lucrezi.");
	if(playerInfo[playerid][pCheckpointID] != -1) return SCM(playerid, COLOR_ERROR, eERROR"Ai deja un checkpoint, pe mini map.");
	if(playerInfo[playerid][pDrivingLicense] <= 0) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai licenta de condus.");
	if(playerInfo[playerid][pDrivingLicenseSuspend] > 0) return SCMf(playerid, COLOR_ERROR, eERROR"Ai licenta suspendata pentru %d ore.", playerInfo[playerid][pDrivingLicenseSuspend]);
	new jobid = playerInfo[playerid][pJob];
	switch(jobid) {
		case 1: callcmd::fish(playerid, "\1");
		case 2: {
			if(!IsPlayerInRangeOfPoint(playerid, 5.5, jobInfo[jobid][jobXST], jobInfo[jobid][jobYST], jobInfo[jobid][jobZST])) return SCM(playerid, COLOR_ERROR, eERROR"Nu esti la punctul de start work pentru jobul 'Trucker'.");
			jobWork(playerid, JOB_TRUCKER);
		}
		case 3: {
			if(!IsPlayerInRangeOfPoint(playerid, 5.5, jobInfo[jobid][jobXST], jobInfo[jobid][jobYST], jobInfo[jobid][jobZST])) return SCM(playerid, COLOR_ERROR, eERROR"Nu esti la punctul de start work pentru jobul 'Drugs Dealer'.");
			jobWork(playerid, JOB_DRUGSDEALER);
		}
		case 4: {
			if(!IsPlayerInRangeOfPoint(playerid, 5.5, jobInfo[jobid][jobXST], jobInfo[jobid][jobYST], jobInfo[jobid][jobZST])) return SCM(playerid, COLOR_ERROR, eERROR"Nu esti la punctul de start work pentru jobul 'Arms Dealer'.");
			jobWork(playerid, JOB_ARMSDEALER);
		}
		case 5: {
			if(!IsPlayerInRangeOfPoint(playerid, 5.5, jobInfo[jobid][jobXST], jobInfo[jobid][jobYST], jobInfo[jobid][jobZST])) return SCM(playerid, COLOR_ERROR, eERROR"Nu esti la punctul de start work pentru jobul 'Carpenter'.");
			jobWork(playerid, JOB_CARPENTER);			
		}
	}
	return true;
}

CMD:usedrugs(playerid, params[]) {
	if(playerInfo[playerid][pDrugs] == 0) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai droguri.");
	if(UsingDrugs[playerid] == 1) return SCM(playerid, COLOR_ERROR, eERROR"Deja te droghezi.");
	playerInfo[playerid][pDrugs] --;
	UsingDrugs[playerid] = 1;
	update("UPDATE `server_users` SET `Drugs` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pDrugs], playerInfo[playerid][pSQLID]);
	ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, true, false, false,false, 10000, false);
	SetPlayerWeather(playerid, 165);
	sendNearbyMessage(playerid, COLOR_PURPLE, 25.0, "%s se drogheaza.", getName(playerid));
	defer usedrugsTimer(playerid);
	return true;
}

timer usedrugsTimer[10000](playerid) {
	ClearAnimations(playerid);
	SetPlayerWeather(playerid, 1);
	SetPlayerHealthEx(playerid, 100);
	UsingDrugs[playerid] = 0;
	SCM(playerid, COLOR_GREY, "{ccaa2d}* (Drugs){ffffff}: Efectul s-a terminat.");
	return true;
}

hook OnPlayerEnterCheckpoint(playerid) {
	gString[0] = (EOS);
	switch(playerInfo[playerid][pCheckpoint]) {
		case CHECKPOINT_JOB: {
			DisablePlayerCheckpoint(playerid);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			SCM(playerid, COLOR_GREY, "* Ai ajuns la destinatie, pentru a lua un job, foloseste comanda (/getjob).");		
		}
		case CHECKPOINT_DRUGSDEALER: {
			DisablePlayerCheckpoint(playerid);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_DRUGSDEALER2;
			SetPlayerCheckpoint(playerid, 1285.8954,173.8965,20.1386, 4.5); 
			SCM(playerid, COLOR_WHITE, string_fast("{ccaa2d}* (Drugs Dealer){ffffff}: Acum trebuie sa aduci masina inapoi, pentru a primi {78e352}drogurile{ffffff}."));
		}
		case CHECKPOINT_DRUGSDEALER2: {
			new drugs = 2 + random(3);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			playerInfo[playerid][pDrugs] += drugs;
			playerInfo[playerid][pDrugsTimes] ++;
			Working[playerid] = 0;	
			DisablePlayerCheckpoint(playerid);
			DestroyVehicle(JobVehicle[playerid]);
			SCM(playerid, COLOR_WHITE, string_fast("{ccaa2d}* (Drugs Dealer){ffffff}: Jobul a fost terminat, ai primit {78e352}%d droguri{ffffff}.", drugs));
			if(playerInfo[playerid][pDrugsSkill] < 5) {
				if(playerInfo[playerid][pDrugsTimes] >= returnNeededPoints(playerid, JOB_DRUGSDEALER)) {
					playerInfo[playerid][pDrugsSkill] ++;
					SCM(playerid, COLOR_GREY, string_fast("{ccaa2d}* (Drugs Dealer){ffffff}: Ai avansat in skill %d. {78e352}Castigul{ffffff} tau va fi mai mare.", playerInfo[playerid][pDrugsSkill]));
				}
			}
			update("UPDATE `server_users` SET `DrugsSkill` = '%d', `DrugsTimes` = '%d', `Drugs` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pDrugsSkill], playerInfo[playerid][pDrugsTimes], playerInfo[playerid][pDrugs], playerInfo[playerid][pSQLID]);
		}
		case CHECKPOINT_ARMSDEALER: {
			DisablePlayerCheckpoint(playerid);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_ARMSDEALER2;
			SetPlayerCheckpoint(playerid, 985.1091, -1754.2627, 13.5816, 4.5);
			va_format(gString, sizeof(gString), "{2db560}* (Arms Dealer){ffffff}: Intr-o cutie se afla cateva {78e352}materiale{ffffff}, drept recompensa pentru tine. Tu trebuie sa aduci masina intr-un garaj pentru a le primi.(Distance: %.2fm)", GetDistanceBetweenPoints(-351.4561, -1032.3164, 59.4044, 985.1091, -1754.2627, 13.5816));
			sendSplitMessage(playerid, COLOR_WHITE, gString);
		}
		case CHECKPOINT_ARMSDEALER2: {
			new mats = 2500*playerInfo[playerid][pArmsSkill] + random(150);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			playerInfo[playerid][pMats] += mats;
			playerInfo[playerid][pArmsTimes] ++;
			Working[playerid] = 0;	
			DisablePlayerCheckpoint(playerid);
			DestroyVehicle(JobVehicle[playerid]);
			SCM(playerid, COLOR_WHITE, string_fast("{2db560}* (Arms Dealer){ffffff}: Jobul a fost terminat, ai primit {78e352}%s materiale{ffffff}.", formatNumber(mats)));
			if(playerInfo[playerid][pArmsSkill] < 5) {
				if(playerInfo[playerid][pArmsTimes] >= returnNeededPoints(playerid, JOB_ARMSDEALER)) {
					playerInfo[playerid][pArmsSkill] ++;
					SCM(playerid, COLOR_GREY, string_fast("{2db560}* (Arms Dealer){ffffff}: Ai avansat in skill %d. {78e352}Castigul{ffffff} tau va fi mai mare.", playerInfo[playerid][pArmsSkill]));
				}
			}
			update("UPDATE `server_users` SET `ArmsSkill` = '%d', `ArmsTimes` = '%d', `Mats` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pArmsSkill], playerInfo[playerid][pArmsTimes], playerInfo[playerid][pMats], playerInfo[playerid][pSQLID]);
		}
		case CHECKPOINT_TRUCKERSF: {
			if(!IsTrailerAttachedToVehicle(JobVehicle[playerid])) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai atasata remorca de tir.");
			JobMoney[playerid] = (playerInfo[playerid][pTruckSkill] * 35000) + random(15000);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			playerInfo[playerid][pTruckTimes] ++;
			DisablePlayerCheckpoint(playerid);				
			GivePlayerCash(playerid, 1, JobMoney[playerid]);
			SCM(playerid, COLOR_GREY, string_fast("* Trucker Notice: Ai finalizat cursa ai ai primit $%s.", formatNumber(JobMoney[playerid])));
			DestroyVehicle(GetVehicleTrailer(JobVehicle[playerid]));
			if(playerInfo[playerid][pTruckSkill] < 5) {
				if(playerInfo[playerid][pTruckTimes] >= returnNeededPoints(playerid, JOB_TRUCKER)) {
					playerInfo[playerid][pTruckSkill] ++;
					SCM(playerid, COLOR_GREY, string_fast("* Trucker Notice: Ai avansat in %d skill. Vei castiga probabil mai multi bani", playerInfo[playerid][pTruckSkill]));
				}
			}
			update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d', `TruckSkill` = '%d', `TruckTimes` = '%d' WHERE `ID` = '%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pTruckSkill], playerInfo[playerid][pTruckTimes], playerInfo[playerid][pSQLID]);
			DestroyVehicle(Trailer[playerid]);
			Dialog_Show(playerid, TRUCKER_SELECTTWO, DIALOG_STYLE_LIST, "JOB: Trucker", "Los Santos Airport\nLas Venturas", "Select", "Cancel");
		}
		case CHECKPOINT_TRUCKERLV: {
			if(!IsTrailerAttachedToVehicle(JobVehicle[playerid])) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai atasata remorca de tir.");
			JobMoney[playerid] = (playerInfo[playerid][pTruckSkill] * 35000) + random(15000);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			playerInfo[playerid][pTruckTimes] ++;
			DisablePlayerCheckpoint(playerid);				
			GivePlayerCash(playerid, 1, JobMoney[playerid]);
			SCM(playerid, COLOR_GREY, string_fast("* Trucker Notice: Ai finalizat cursa ai ai primit $%s.", formatNumber(JobMoney[playerid])));
			DestroyVehicle(GetVehicleTrailer(JobVehicle[playerid]));
			if(playerInfo[playerid][pTruckSkill] < 5) {
				if(playerInfo[playerid][pTruckTimes] >= returnNeededPoints(playerid, JOB_TRUCKER)) {
					playerInfo[playerid][pTruckSkill] ++;
					SCM(playerid, COLOR_GREY, string_fast("* Trucker Notice: Ai avansat in %d skill. Vei castiga probabil mai multi bani", playerInfo[playerid][pTruckSkill]));
				}
			}
			update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d', `TruckSkill` = '%d', `TruckTimes` = '%d' WHERE `ID` = '%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pTruckSkill], playerInfo[playerid][pTruckTimes], playerInfo[playerid][pSQLID]);
			DestroyVehicle(Trailer[playerid]);
			Dialog_Show(playerid, TRUCKER_SELECTTHREE, DIALOG_STYLE_LIST, "JOB: Trucker", "San Fierro Airport\nLos Santos", "Select", "Cancel");
		}
		case CHECKPOINT_TRUCKERLS: {
			if(!IsTrailerAttachedToVehicle(JobVehicle[playerid])) return SCM(playerid, COLOR_ERROR, eERROR"Nu ai atasata remorca de tir.");
			JobMoney[playerid] = (playerInfo[playerid][pTruckSkill] * 35000) + random(15000);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			playerInfo[playerid][pTruckTimes] ++;
			DisablePlayerCheckpoint(playerid);				
			GivePlayerCash(playerid, 1, JobMoney[playerid]);
			SCM(playerid, COLOR_GREY, string_fast("* Trucker Notice: Ai finalizat cursa ai ai primit $%s.", formatNumber(JobMoney[playerid])));
			DestroyVehicle(GetVehicleTrailer(JobVehicle[playerid]));
			if(playerInfo[playerid][pTruckSkill] < 5) {
				if(playerInfo[playerid][pTruckTimes] >= returnNeededPoints(playerid, JOB_TRUCKER)) {
					playerInfo[playerid][pTruckSkill] ++;
					SCM(playerid, COLOR_GREY, string_fast("* Trucker Notice: Ai avansat in %d skill. Vei castiga probabil mai multi bani", playerInfo[playerid][pTruckSkill]));
				}
			}
			update("UPDATE `server_users` SET `Money` = '%d', `MStore` = '%d', `TruckSkill` = '%d', `TruckTimes` = '%d' WHERE `ID` = '%d'", MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pTruckSkill], playerInfo[playerid][pTruckTimes], playerInfo[playerid][pSQLID]);
			DestroyVehicle(Trailer[playerid]);
			Dialog_Show(playerid, TRUCKER_SELECT, DIALOG_STYLE_LIST, "JOB: Trucker", "San Fierro Airport\nLas Venturas", "Select", "Cancel");
		}
		case CHECKPOINT_CARPENTER: {
			DisablePlayerCheckpoint(playerid);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_CARPENTER2;
			SetPlayerCheckpoint(playerid,997.6502,-1434.9153,13.5469, 4.5); 
			SCM(playerid, COLOR_WHITE, string_fast("{7cc433}* (Carpenter){ffffff}: Acum trebuie sa aduci masina inapoi, pentru a primi {78e352}bani{ffffff} pentru aceasta cursa."));			
		}
		case CHECKPOINT_CARPENTER2: {
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			playerInfo[playerid][pCarpenterTimes] ++;
			Working[playerid] = 0;	
			JobMoney[playerid] = (playerInfo[playerid][pCarpenterSkill] * 45000) + random(20000);
			DisablePlayerCheckpoint(playerid);
			GivePlayerCash(playerid, 1, JobMoney[playerid]);
			DestroyVehicle(JobVehicle[playerid]);
			SCM(playerid, COLOR_WHITE, string_fast("{7cc433}* (Carpenter){ffffff}: Jobul a fost terminat, ai primit {78e352}$%s bani{ffffff}.", formatNumber(JobMoney[playerid])));
			if(playerInfo[playerid][pCarpenterSkill] < 5) {
				if(playerInfo[playerid][pCarpenterTimes] >= returnNeededPoints(playerid, JOB_CARPENTER)) {
					playerInfo[playerid][pCarpenterSkill] ++;
					SCM(playerid, COLOR_GREY, string_fast("{7cc433}* (Carpenter){ffffff}: Ai avansat in skill %d. {78e352}Castigul{ffffff} tau va fi mai mare.", playerInfo[playerid][pCarpenterSkill]));
				}
			}
			update("UPDATE `server_users` SET `CarpenterSkill` = '%d', `CarpenterTimes` = '%d', `Money` = '%d', `MStore` = '%d' WHERE `ID` = '%d'", playerInfo[playerid][pCarpenterSkill], playerInfo[playerid][pCarpenterTimes], MoneyMoney[playerid], StoreMoney[playerid], playerInfo[playerid][pSQLID]);
		}
	}
	return true;
}

stock jobWork(playerid, job) {
	gString[0] = (EOS);
	switch(job) {
		case JOB_TRUCKER: {
			JobVehicle[playerid] = CreateVehicle(515, 873.6147,-1773.7589,13.3828,84.5656, 1, 1,-1);
			PutPlayerInVehicleEx(playerid, JobVehicle[playerid], 0);
			Dialog_Show(playerid, TRUCKER_SELECT, DIALOG_STYLE_LIST, "JOB: Trucker", "San Fierro Airport\nLas Venturas", "Select", "Cancel");
			SCM(playerid, COLOR_WHITE, string_fast("{f26050}* (Trucker){ffffff}: Pentru a atasa trailer-ul iar, poti apasa tasta F."));
		}
		case JOB_DRUGSDEALER: {
			JobVehicle[playerid] = CreateVehicle(478, 1285.8954,173.8965,20.1386, 62.8171, 1, 1, -1);
			PutPlayerInVehicleEx(playerid, JobVehicle[playerid], 0);
			playerInfo[playerid][pCheckpointID] = JobVehicle[playerid];
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_DRUGSDEALER;	
			SetPlayerCheckpoint(playerid, 643.1931, 1241.5510, 11.5892, 4.5);
			va_format(gString, sizeof(gString), "{ccaa2d}* (Drugs Dealer){ffffff}: Ti-a fost dat o masina de tip {78e352}Walton (478){ffffff}. Aceasta detine droguri ascunse, in bara de fata respectiv bara spate. Tu trebuie sa le transporti cu grija, la checkpoint-ul de pe minimap.");
			sendSplitMessage(playerid, COLOR_WHITE, gString);
		}
		case JOB_ARMSDEALER: {
			JobVehicle[playerid] = CreateVehicle(455, 1700.6183,-1485.4926,13.8227,179.7867, 1, 1, -1);
			PutPlayerInVehicleEx(playerid, JobVehicle[playerid], 0);
			playerInfo[playerid][pCheckpointID] = JobVehicle[playerid];
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_ARMSDEALER;	
			SetPlayerCheckpoint(playerid, -351.4561, -1032.3164, 59.4044, 4.5);
			va_format(gString, sizeof(gString), "{2db560}* (Arms Dealer){ffffff}: Ti-a fost dat o masina de tip {78e352}Flatbed (455){ffffff}. Aceasta detine arme in cutiile, din spatele masinii. Tu trebuie sa le transporti cu grija, la checkpoint-ul de pe minimap.(Distance: %.2fm)", GetDistanceBetweenPoints(1769.5156, -1509.4844, 12.4453, -351.4561, -1032.3164, 59.4044));
			sendSplitMessage(playerid, COLOR_WHITE, gString);
		}
		case JOB_CARPENTER: {
			JobVehicle[playerid] = CreateVehicle(456, 1027.2261, -1451.8898, 13.3994, 90.2400, 1, 1, -1);
			PutPlayerInVehicleEx(playerid, JobVehicle[playerid], 0);
			playerInfo[playerid][pCheckpointID] = JobVehicle[playerid];
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_CARPENTER;	
			SetPlayerCheckpoint(playerid, -64.9157,-1120.2693,1.0781, 4.5);
			va_format(gString, sizeof(gString), "{7cc433}* (Carpenter){ffffff}: Ti-a fost dat o masina de tip {78e352}Yankee (456){ffffff}. Aceasta detine mobila in spatele masinii. Tu trebuie sa le transporti cu grija, la checkpoint-ul de pe minimap.(Distance: %.2fm)", GetDistanceBetweenPoints(1027.2261, -1451.8898, 13.3994, -64.9157,-1120.2693,1.0781));
			sendSplitMessage(playerid, COLOR_WHITE, gString);			
		}
	}	
	vehicle_fuel[JobVehicle[playerid]] = 100.0;
	vehicle_personal[JobVehicle[playerid]] = -1;
	vehicle_engine[JobVehicle[playerid]] = true;
	Working[playerid] = job;
	return true;
}
		
CancelJob(playerid, job) {
	switch(job) {
		case JOB_FISHER: {
			TogglePlayerControllable(playerid, true);
			ClearAnimations(playerid);
			RemovePlayerAttachedObject(playerid, 9);	
			if(FishTimer[playerid] != Timer:-1) {
				stop FishTimer[playerid];
			}
			Fishing[playerid] = false;
			FishWeight[playerid] = 0;
			FishTimer[playerid] = Timer:-1;		
		}
		case JOB_TRUCKER: {
			DestroyVehicle(Trailer[playerid]);
			DestroyVehicle(JobVehicle[playerid]);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			Working[playerid] = 0;
			DisablePlayerCheckpoint(playerid);	
		}
		case JOB_DRUGSDEALER: {
			DestroyVehicle(JobVehicle[playerid]);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			Working[playerid] = 0;	
			DisablePlayerCheckpoint(playerid);	
		}
		case JOB_ARMSDEALER: {
			DestroyVehicle(JobVehicle[playerid]);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			Working[playerid] = 0;	
			DisablePlayerCheckpoint(playerid);	
		}
		case JOB_CARPENTER: {
			DestroyVehicle(JobVehicle[playerid]);
			playerInfo[playerid][pCheckpoint] = CHECKPOINT_NONE;
			playerInfo[playerid][pCheckpointID] = -1;
			Working[playerid] = 0;	
			DisablePlayerCheckpoint(playerid);			
		}
	}
	return true;
}
