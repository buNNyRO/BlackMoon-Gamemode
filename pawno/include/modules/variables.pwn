//////////////////////////////////////////////////
//////    Variables                        //////
////////////////////////////////////////////////

new MySQL:SQL, gQuery[652], gString[4096], gFast[4096], Connection = 0, AntiCheatWarnings, PlayerNumber[20000], Weapons[MAX_PLAYERS][47], WeaponAmmo[MAX_PLAYERS][47], gates[4],
    StoreMoney[MAX_PLAYERS], MoneyMoney[MAX_PLAYERS], Selected[MAX_PLAYERS][50][180], selName[MAX_PLAYERS][180], Questions,
	bool: vehicle_engine[MAX_VEHICLES],
	bool: vehicle_lights[MAX_VEHICLES],
	bool: vehicle_bonnet[MAX_VEHICLES],
	bool: vehicle_boot[MAX_VEHICLES],
    Float: vehicle_fuel[MAX_VEHICLES],
    vehicle_personal[MAX_VEHICLES],

	Iterator:ServerAdmins<MAX_PLAYERS>,
    Iterator:ServerHelpers<MAX_PLAYERS>,
    Iterator:ServerStaff<MAX_PLAYERS>,
    Iterator:PlayerInVehicle<MAX_PLAYERS>,
	Iterator:MutedPlayers<MAX_PLAYERS>,
	Iterator:ExamenCheckpoints<MAX_EXAM_CHECKPOINTS>,
	Iterator:AdminVehicles<MAX_VEHICLES>,
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
	examenInfo[MAX_PLAYERS][examenInfoEnum],
	reportInfo[MAX_REPORTS][reportInfoEnum],
	/*pickupInfo[MAX_DYNAMIC_PICKUPS][pickupInfoEnum],
	labelInfo[MAX_DYNAMIC_LABELS][labelInfoEnum],*/

	Text:serverNameTD,
	Text:serverInfoTD,
	Text:serverDateTD,
    Text:serverDealerTD[9],
    
    PlayerText:jailTimeTD[MAX_PLAYERS],
	PlayerText:playerNamePTD[MAX_PLAYERS],
	PlayerText:playerLevelPTD[MAX_PLAYERS],
	PlayerText:playerExamenPTD[MAX_PLAYERS],
    PlayerText:vehicleHud[14],
    PlayerText:serverDealerPTD[MAX_PLAYERS][3],
    PlayerText:wantedTD[MAX_PLAYERS],
    PlayerText:fareTD[MAX_PLAYERS],
    PlayerText:warTD[MAX_PLAYERS],

	PlayerBar:playerBarPTD[MAX_PLAYERS],

    Timer:jailTime[MAX_PLAYERS],
    Timer:wantedTime[MAX_PLAYERS],
    Timer:collision[MAX_PLAYERS],
    Timer:wantedFind[MAX_PLAYERS],
    Timer:tutorial[MAX_PLAYERS],
    Timer:carFind[MAX_PLAYERS],
    Timer:muteTime[MAX_PLAYERS],
    Timer:speedo[MAX_PLAYERS],
    Timer:war[MAX_TURFS],
    Timer:taxi[MAX_PLAYERS],
    Timer:getHit[MAX_PLAYERS],


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
Float:SpawnPos[4][4] = {
{26.1781,1174.7161,19.3879,88.9873},
{25.9677,1167.8812,19.5199,89.4457},
{-0.7905,1171.9806,19.4969,259.9896},
{-0.7921,1185.6748,19.4027,263.1554}
};