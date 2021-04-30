//////////////////////////////////////////////////
//////    Defines                          //////
////////////////////////////////////////////////

#define function%0(%1)					forward %0(%1); public %0(%1)
#define PRESSED(%0) 					(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))
#define SCM 							SendClientMessage
#define SCMf 							va_SendClientMessage
#define ResetMoneyBar    				ResetPlayerMoney
#define UpdateMoneyBar   				GivePlayerMoney
#define SPECIAL_ACTION_PISSING   		68	

#define MAX_EXAM_CHECKPOINTS 			20
#define MAX_REPORTS                     50
//#define MAX_DYNAMIC_PICKUPS             100
#define MAX_ADMIN_VEHICLES 				50
//#define MAX_DYNAMIC_LABELS              100
#define MAX_SERVER_VARS					10
#define MAX_DSMODELS					90
#define MAX_FREQS						10
#define MAX_TURFS 						44

#define RATE_INC (500)
#define RATE_MAX (2500)
#define THRESOLD_ACTION 				1

#define getName(%0)						playerInfo[%0][pName]
#define getIp(%0) 						playerInfo[%0][pIp]
#define getVehicleName(%0) 				vehNames[%0 - 400]
#define getVehicleMaxSeats(%0) 			MaxSeats[%0 - 400]

#define MAX_PLAYER_PERSONAL_VEHICLES 20
#define MAX_PLAYERS_PERSONAL_VEHICLES (MAX_PLAYER_PERSONAL_VEHICLES * MAX_PLAYERS)

#define COLOR_GREY 						0xAFAFAFAA
#define COLOR_ERROR						0xba2727FF
#define COLOR_SYNTAX					0xba2727FF
#define COLOR_SERVER					0xba2727FF
#define COLOR_PURPLE 					0xC2A2DAAA
#define COLOR_GREEN 					0x33AA33AA
#define COLOR_RED 						0xAA3333AA
#define COLOR_YELLOW 					0xFFFF00AA
#define COLOR_WHITE 					0xFFFFFFAA
#define COLOR_BLUE 						0x0000BBAA
#define COLOR_LIGHTBLUE 				0x33CCFFAA
#define COLOR_DARKBLUE					0x445fe3FF
#define COLOR_ORANGE 					0xdbb82cFF
#define COLOR_RED 						0xAA3333AA
#define COLOR_LIME 						0x81e622FF
#define COLOR_MAGENTA 					0xFF00FFFF
#define COLOR_NAVY 						0x000080AA
#define COLOR_AQUA 						0xF0F8FFAA
#define COLOR_CRIMSON 					0xDC143CAA
#define COLOR_FLBLUE 					0x6495EDAA
#define COLOR_BISQUE 					0xFFE4C4AA
#define COLOR_BLACK 					0x000000AA
#define COLOR_CHARTREUSE 				0x7FFF00AA
#define COLOR_BROWN 					0x8c2b2bFF
#define COLOR_CORAL 					0xFF7F50AA
#define COLOR_GOLD 						0xB8860BAA
#define COLOR_GREENYELLOW 				0xADFF2FAA
#define COLOR_INDIGO 					0x4B00B0AA
#define COLOR_IVORY 					0xFFFF82AA
#define COLOR_LAWNGREEN 				0x7CFC00AA
#define COLOR_LIMEGREEN 				0x32CD32AA 
#define COLOR_MIDNIGHTBLUE 				0X191970AA
#define COLOR_ADMINCHAT					0xffa31aFF
#define COLOR_HELPERCHAT				0xb35900FF
#define COLOR_MAROON 					0x800000AA
#define COLOR_OLIVE 					0x808000AA
#define COLOR_ORANGERED 				0xFF4500AA
#define COLOR_PINK 						0xFFC0CBAA 
#define COLOR_SEAGREEN 					0x2E8B57AA
#define COLOR_SPRINGGREEN 				0x00FF7FAA
#define COLOR_TOMATO 					0xFF6347AA 
#define COLOR_YELLOWGREEN 				0x9ACD32AA 
#define COLOR_MEDIUMAQUA 				0x83BFBFAA
#define COLOR_MEDIUMMAGENTA 			0x8B008BAA 
#define COLOR_LIGHTRED 					0xFF6347FF
#define COLOR_FREQ						0xC8E0DFFF
#define COLOR_NEWS 						0xFFA500AA
#define COLOR_LIGHTGREEN 				0x9ACD32AA
#define COLOR_PURPLE2					0xab1560FF
