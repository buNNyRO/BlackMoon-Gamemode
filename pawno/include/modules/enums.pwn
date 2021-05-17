
enum
{
	FEMALE_GENDER,
	MALE_GENDER
};

enum {
	CHECKPOINT_NONE,
	CHECKPOINT_JOB,
    CHECKPOINT_FINDCAR,
    CHECKPOINT_TRUCKERSF,
    CHECKPOINT_TRUCKERLV,
    CHECKPOINT_TRUCKERLS,
    CHECKPOINT_DRUGSDEALER,
    CHECKPOINT_DRUGSDEALER2,
    CHECKPOINT_ARMSDEALER,
    CHECKPOINT_ARMSDEALER2,
    CHECKPOINT_CARPENTER,
    CHECKPOINT_CARPENTER2,
    CHECKPOINT_FACTION_DUTY,
    CHECKPOINT_GPS,
    CHECKPOINT_WANTEDFIND,
    CHECKPOINT_GETHIT
};


enum {
    REPORT_TYPE_NORMAL, 
    REPORT_TYPE_CHEATER,
    REPORT_TYPE_STUCK,
    REPORT_TYPE_NONE
};

enum examenInfoEnum {
	dmvID,
	Float:dmvX,
	Float:dmvY,
	Float:dmvZ
};

enum LIST_ANTIFLOOD {
    lastCheck, floodRate
}

enum playerInfoEnum
{
	pSQLID,
	pName[MAX_PLAYER_NAME],
	pPassword[65],
	pEMail[128],
	bool:pTutorial,
	pGender,
	pSkin,
	pAdmin,
	pHelper,
	pRespectPoints,
	pLevel,
	pMoney,
	pBank,
    pStoreBank,
	Float:pHours,
	Float:pSeconds,
	pDrivingLicense,
	pDrivingLicenseSuspend,
	pWeaponLicense,
	pWeaponLicenseSuspend,
	pFlyLicense,
	pFlyLicenseSuspend,
	pBoatLicense,
	pBoatLicenseSuspend,
	pMute,
	pWarn,
    pReportMute,
   	pJob,
   	pBusiness,
   	pBusinessID,
   	pHouse,
   	pHouseID,
   	pRent,
    pSpawnChange,
    pVehicleSlots,
    pFishTimes,
    pFishSkill,
    pTruckTimes,
    pTruckSkill,
    pArmsTimes,
    pArmsSkill,
    pDrugsTimes,
    pDrugsSkill,
    pCarpenterSkill,
    pCarpenterTimes,
    pIp[16],
    pLastIp[16],
    pDrugs,
    pPremium,
    pVIP,
    pBeta,
    pMats,
    pFaction,
    pFactionPunish,
    pFactionWarns,
    pFactionAge,
    pFactionRank,
    pPhone,
    pPhoneBook,
    pWantedLevel,
    pJailed,
    pJailTime,
    pArrested,
    pWantedDeaths,
    pCommands,
    pNeedProgress[2],
    pDailyMission[2],
    pProgress[2],
    pWTChannel,
    pWTalkie,
    pWToggle,
    pLiveToggle,
    pWantedTime,
    bool: pGuns[6],
    pClan,
    pClanTag,
    pClanRank,
    pClanAge,
    pClanWarns,
    pPremiumPoints,
    pFPSShow,
	pLoginTries,
	pAFKSeconds,
	bool:pLogged,
	bool:pLoginEnabled,
	Timer:pLoginTimer,
	Float:pLastPosX,
	Float:pLastPosY,
	Float:pLastPosZ,
	pExamenVehicle,
	pExamenCheckpoint,
	bool:pFlymode,
    bool:pFreeze,
    bool:pMark,
    Float:pMarkX,
    Float:pMarkY,
    Float:pMarkZ,
    Float:pHealth,
    Float:pArmour,
    pMarkInterior,
    pTutorialSeconds,
    pReportChat,
    pTutorialActive,
    pCheckpoint,
    pCheckpointID,
    pinBusiness,
    pinHouse,
    pinVehicle,
    pinDealer,
    pinFaction,
    pTintaApasata,
    pTransferMoney,
    pTransferPlayer,
    pspecFaction,
    pPhoneOnline,
    pReply,
    pDistanceCheckpoint,
    pFactionDuty,
    pCuffed,
    pTazer,
    pMDCon,
    pCollision,
    pUnFreezeTime,
    pFreezed,
    pAnimLibLoaded,
    pAnimLooping,
    pTaxiDuty,
    pTaxiFare,
    pTaxiDriver,
    pTaxiMoney,
    pLiveOffer,
    pTalkingLive,
    pQuestionText[180],
    pInLesson,
    pLesson,
    pLicense,
    pLicenseOffer,
    pShowTurfs,
    pSafeID,
    pSelectedItem,
    pOnTurf,
    areaBizz,
    areaHouse,
    areaFaction,
    areaJob,
    areaGascan,
    areaSafe,
    pEnableBoost,
    pAdminCover[MAX_PLAYER_NAME],
    pDrunkLevel,
    pFPS,
    pAdText[256],
    pAdminDuty,
    pSpectate,
    pSelectVehicle[MAX_PLAYER_PERSONAL_VEHICLES]
};
/*
enum pickupInfoEnum {
    pickupSQLID,
    pickupID,
    pickupModel,
    Float:pickupX,
    Float:pickupY,
    Float:pickupZ,
    pickupWorldID,
    pickupInterior
};

enum labelInfoEnum {
    labelSQLID,
    labelText[128],
    Float:labelX,
    Float:labelY,
    Float:labelZ,
    labelVirtualWorld,
    labelInterior,
    Text3D:labelID
};
*/
enum reportInfoEnum {
    reportID, 
    reportPlayer,
    reportText[128],
    reportType,
    Timer:reportTimer
};

enum serverVarsInfoEnum {
    srvVarID,
    srvVarName,
    srvVarValue,
    srvVarType
};

enum dealershipInfoEnum {   
    dID, 
    dModel, 
    dPrice, 
    dStock
};

enum deelayEnum {
    Chat[144],
    Commands,
    Keys,
}; new deelayInfo[MAX_PLAYERS][deelayEnum];