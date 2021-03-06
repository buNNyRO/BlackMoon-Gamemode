//////////////////////////////////////////////////
//////    Variables                        //////
////////////////////////////////////////////////

new MySQL:SQL, gQuery[652], gString[4096], gFast[4096], PlayerNumber[20000], Weapons[MAX_PLAYERS][47], WeaponAmmo[MAX_PLAYERS][47], gates[4],
    StoreMoney[MAX_PLAYERS], MoneyMoney[MAX_PLAYERS], Selected[MAX_PLAYERS][50][180], selName[MAX_PLAYERS][180], Questions, PayDayTime, CountTime,
	bool: vehEngine[MAX_VEHICLES],
	bool: vehLights[MAX_VEHICLES],
	bool: vehBonnet[MAX_VEHICLES],
	bool: vehBoot[MAX_VEHICLES],
    Float: vehFuel[MAX_VEHICLES],
    vehPersonal[MAX_VEHICLES],

	Iterator:ServerAdmins<MAX_PLAYERS>,
    Iterator:ServerHelpers<MAX_PLAYERS>,
    Iterator:ServerStaff<MAX_PLAYERS>,
    Iterator:PlayerInVehicle<MAX_PLAYERS>,
	Iterator:MutedPlayers<MAX_PLAYERS>,
	Iterator:ExamCheckpointIter<MAX_EXAM_CHECKPOINTS>,
    Iterator:AdminVehicles<MAX_VEHICLES>,
    // Iterator:AccountBlocked<MAX_PLAYERS>,
	Iterator:StreamPlayer[MAX_PLAYERS]<MAX_PLAYERS>,
	/*Iterator:Pickups<MAX_DYNAMIC_PICKUPS>,
	Iterator:Labels<MAX_DYNAMIC_LABELS>,*/
	Iterator:Reports<MAX_REPORTS>,
    Iterator:PremiumPlayers<MAX_PLAYERS>,
    Iterator:VipPlayers<MAX_PLAYERS>,
    Iterator:BetaPlayers<MAX_PLAYERS>,
    Iterator:JailedPlayers<MAX_PLAYERS>,
    Iterator:Freqs[10]<MAX_PLAYERS>,
    Iterator:loggedPlayers<MAX_PLAYERS>,

	playerInfo[MAX_PLAYERS][playerInfoEnum],
	ExamInformation[MAX_PLAYERS][ExamInformationEnum],
	ReportInfo[MAX_REPORTS][ReportInfoEnum],
	/*pickupInfo[MAX_DYNAMIC_PICKUPS][pickupInfoEnum],
	labelInfo[MAX_DYNAMIC_LABELS][labelInfoEnum],*/

    Text:ClockTD[3],
    Text:serverDealerTD[9],
    
    Text:Inventory_BG[30],
    PlayerText:Inventory_BTN[20],
    
    PlayerText:jailTimeTD[MAX_PLAYERS],
	PlayerText:serverHud[2],
    PlayerText:levelBar[4],
	PlayerText:playerLevelPTD[MAX_PLAYERS],
	PlayerText:playerExamenPTD[MAX_PLAYERS],
    PlayerText:vehicleHud[20],
    PlayerText:serverDealerPTD[MAX_PLAYERS][3],
    PlayerText:wantedTD[MAX_PLAYERS],
    PlayerText:fareTD[MAX_PLAYERS],
    PlayerText:warTD[MAX_PLAYERS],
    PlayerText:notificationTD[MAX_PLAYERS],
    PlayerText:specTD[MAX_PLAYERS],
    PlayerText:fishTD[MAX_PLAYERS][15],
    PlayerText:examenTD[MAX_PLAYERS][13],

    Timer:jailTime[MAX_PLAYERS],
    Timer:wantedTime[MAX_PLAYERS],
    Timer:wantedFind[MAX_PLAYERS],
    Timer:tutorial[MAX_PLAYERS],
    Timer:carFind[MAX_PLAYERS],
    Timer:speedo[MAX_PLAYERS],
    Timer:war[MAX_TURFS],
    Timer:taxi[MAX_PLAYERS],
    Timer:getHit[MAX_PLAYERS],
    Timer:spectator[MAX_PLAYERS],
    Timer:examen[MAX_PLAYERS],


vehNames[212][] =
{
    {"Landstalker"},
    {"Bravura"},
    {"Buffalo"},
    {"Linerunner"},
    {"Perrenial"},
    {"Sentinel"},
    {"Dumper"},
    {"Firetruck"},
    {"Trashmaster"},
    {"Stretch"},
    {"Manana"},
    {"Infernus"},
    {"Voodoo"},
    {"Pony"},
    {"Mule"},
    {"Cheetah"},
    {"Ambulance"},
    {"Leviathan"},
    {"Moonbeam"},
    {"Esperanto"},
    {"Taxi"},
    {"Washington"},
    {"Bobcat"},
    {"MrWhoopee"},
    {"BFInjection"},
    {"Hunter"},
    {"Premier"},
    {"Enforcer"},
    {"Securicar"},
    {"Banshee"},
    {"Predator"},
    {"Bus"},
    {"Rhino"},
    {"Barracks"},
    {"Hotknife"},
    {"Trailer1"},
    {"Previon"},
    {"Coach"},
    {"Cabbie"},
    {"Stallion"},
    {"Rumpo"},
    {"RCBandit"},
    {"Romero"},
    {"Packer"},
    {"Monster"},
    {"Admiral"},
    {"Squalo"},
    {"Seasparrow"},
    {"Pizzaboy"},
    {"Tram"},
    {"Trailer2"},
    {"Turismo"},
    {"Speeder"},
    {"Reefer"},
    {"Tropic"},
    {"Flatbed"},
    {"Yankee"},
    {"Caddy"},
    {"Solair"},
    {"BerkleyRCVan"},
    {"Skimmer"},
    {"PCJ-600"},
    {"Faggio"},
    {"Freeway"},
    {"RCBaron"},
    {"RCRaider"},
    {"Glendale"},
    {"Oceanic"},
    {"Sanchez"},
    {"Sparrow"},
    {"Patriot"},
    {"Quad"},
    {"Coastguard"},
    {"Dinghy"},
    {"Hermes"},
    {"Sabre"},
    {"Rustler"},
    {"ZR-350"},
    {"Walton"},
    {"Regina"},
    {"Comet"},
    {"BMX"},
    {"Burrito"},
    {"Camper"},
    {"Marquis"},
    {"Baggage"},
    {"Dozer"},
    {"Maverick"},
    {"NewsChopper"},
    {"Rancher"},
    {"FBIRancher"},
    {"Virgo"},
    {"Greenwood"},
    {"Jetmax"},
    {"Hotring"},
    {"Sandking"},
    {"Blista Compact"},
    {"Police Maverick"},
    {"Boxville"},
    {"Benson"},
    {"Mesa"},
    {"RCGoblin"},
    {"HotringRacer A"},
    {"HotringRacer B"},
    {"BloodringBanger"},
    {"Rancher"},
    {"SuperGT"},
    {"Elegant"},
    {"Journey"},
    {"Bike"},
    {"MountainBike"},
    {"Beagle"},
    {"Cropdust"},
    {"Stunt"},
    {"Tanker"},
    {"Roadtrain"},
    {"Nebula"},
    {"Majestic"},
    {"Buccaneer"},
    {"Shamal"},
    {"Hydra"},
    {"FCR-900"},
    {"NRG-500"},
    {"HPV1000"},
    {"CementTruck"},
    {"TowTruck"},
    {"Fortune"},
    {"Cadrona"},
    {"FBITruck"},
    {"Willard"},
    {"Forklift"},
    {"Tractor"},
    {"Combine"},
    {"Feltzer"},
    {"Remington"},
    {"Slamvan"},
    {"Blade"},
    {"Freight"},
    {"Streak"},
    {"Vortex"},
    {"Vincent"},
    {"Bullet"},
    {"Clover"},
    {"Sadler"},
    {"FiretruckLA"},
    {"Hustler"},
    {"Intruder"},
    {"Primo"},
    {"Cargobob"},
    {"Tampa"},
    {"Sunrise"},
    {"Merit"},
    {"Utility"},
    {"Nevada"},
    {"Yosemite"},
    {"Windsor"},
    {"MonsterA"},
    {"MonsterB"},
    {"Uranus"},
    {"Jester"},
    {"Sultan"},
    {"Stratum"},
    {"Elegy"},
    {"Raindance"},
    {"RC Tiger"},
    {"Flash"},
    {"Tahoma"},
    {"Savanna"},
    {"Bandito"},
    {"FreightFlat"},
    {"StreakCarriage"},
    {"Kart"},
    {"Mower"},
    {"Duneride"},
    {"Sweeper"},
    {"Broadway"},
    {"Tornado"},
    {"AT-400"},
    {"DFT-30"},
    {"Huntley"},
    {"Stafford"},
    {"BF-400"},
    {"Newsvan"},
    {"Tug"},
    {"Trailer 3"},
    {"Emperor"},
    {"Wayfarer"},
    {"Euros"},
    {"Hotdog"},
    {"Club"},
    {"FreightCarriage"},
    {"Trailer3"},
    {"Andromada"},
    {"Dodo"},
    {"RCCam"},
    {"Launch"},
    {"PoliceCar(LSPD)"},
    {"PoliceCar(SFPD)"},
    {"PoliceCar(LVPD)"},
    {"PoliceRanger"},
    {"Picador"},
    {"S.W.A.T.Van"},
    {"Alpha"},
    {"Phoenix"},
    {"Glendale"},
    {"Sadler"},
    {"LuggageTrailerA"},
    {"LuggageTrailerB"},
    {"StairTrailer"},
    {"Boxville"},
    {"FarmPlow"},
    {"UtilityTrailer"}
},
MaxSeats[212] = {
4,2,2,2,4,4,1,2,2,4,2,2,2,4,2,2,4,2,4,2,4,4,2,2,2,1,4,4,4,2,1,9,1,2,2,1,2,9,4,2,
4,1,2,2,2,4,1,2,1,6,1,2,1,1,1,2,2,2,4,4,2,2,2,2,2,2,4,4,2,2,4,2,1,1,2,2,1,2,2,4,
2,1,4,3,1,1,1,4,2,2,4,2,4,1,2,2,2,4,4,2,2,2,2,2,2,2,2,4,2,1,1,2,1,1,2,2,4,2,2,1,
1,2,2,2,2,2,2,2,2,4,1,1,1,2,2,2,2,0,0,1,4,2,2,2,2,2,4,4,2,2,4,4,2,1,2,2,2,2,2,2,
4,4,2,2,1,2,4,4,1,0,0,1,1,2,1,2,2,2,2,4,4,2,4,1,1,4,2,2,2,2,6,1,2,2,2,1,4,4,4,2,
2,2,2,2,4,2,1,1,1,4,1,1
},
SpeedVehicle[212] = {
149,139,176,104,125,155,104,140,94,149,122,209,159,104,100,181,145,127,109,141,137,145,132,93,128,
191,164,156,148,190,100,123,89,104,158,0,141,149,135,159,128,71,131,119,104,155,140,126,106,169,0,
182,141,58,115,119,100,90,138,128,0,151,105,136,0,0,139,132,136,0,148,104,0,0,141,163,0,176,111,132,
174,68,148,116,0,94,60,0,0,132,148,141,132,0,203,166,153,0,115,116,132,0,203,203,163,132,169,156,
102,74,95,0,0,0,113,126,148,148,155,0,0,150,166,142,123,151,149,141,166,141,57,66,104,157,159,149,
163,0,0,94,141,191,155,142,140,139,141,135,0,145,137,148,114,0,136,149,104,104,147,168,159,145,168,
0,83,155,151,163,138,0,0,88,58,104,57,149,140,0,123,149,144,101,115,66,0,144,132,155,102,153,0,0,0,
0,57,0,166,166,166,149,142,104,160,162,139,142,0,0,0,102,0
};