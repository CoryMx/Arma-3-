/*
	"Charkia Infiltration" v1.0 static mission for Altis.
	Created by [-SoL-]Cory using templates by eraser1
	19 years of CiC
	hardcore - reworked by [CiC]red_ned http://cic-gaming.co.uk
*/

// Create Buildings - this is so roadblocks only appear during mission
_baseObjs =	[
				"charkia_objects"
			] call DMS_fnc_ImportFromM3E_3DEN_Static;

// For logging purposes
_num = DMS_MissionCount;


// Set mission side (only "bandit" is supported for now)
_side = "bandit";

_pos = [20249.126953,11666.573242,0]; //insert the centre here

if ([_pos,DMS_StaticMinPlayerDistance] call DMS_fnc_IsPlayerNearby) exitWith {"delay"};


// Set general mission difficulty
_difficulty = "hardcore";

//vehicle pin code choice - doing early as its used in win message and vehicle spawn
_pinCode = (1000 +(round (random 8999)));

_vehicle = ["I_MBT_03_cannon_F",[[20232.6,11632.9,0] select 0, [20232.6,11632.9,0] select 1],_pinCode] call DMS_fnc_SpawnPersistentVehicle;

_cash = (150000 + round (random (50000)));					//this gives 1000 to 2500 cash

// Define spawn locations for AI Soldiers. These will be used for the initial spawning of AI as well as reinforcements.
// The center spawn location is added 3 times so at least 3 AI will spawn initially at the center location, and so that future reinforcements are more likely to spawn at the center.
_AISoldierSpawnLocations =
[
				[20238.224609,11645.745117,0],
				[20234.455078,11651.330078,0],
				[20359.566406,11781.728516,0],
				[20311.472656,11756.670898,0],
				[20302.398438,11762.371094,0],
				[20324.902344,11833.986328,0],
				[20321.40625,11826.44043,0],
				[20170.835938,11724.0810547,0],
				[20175.988281,11724.384766,0],
				[20175.292969,11730.602539,0],
				[20261.59375,11687.472656,0],
				[20260.886719,11694.353516,0],
				[20266.857422,11726.563477,0],
				[20255.607422,11727.0654297,0],
				[20373.154297,11692.980469,0],
				[20363.957031,11698.301758,0],
				[20361.460938,11706.692383,0],
				[20305.775391,11725.658203,0],
				[20288.318359,11602.430664,0],
				[20283.517578,11603.171875,0],
				[20286.902344,11610.133789,0],
				[20333.332031,11588.0351563,0],
				[20328.773438,11591.619141,0],
				[20329.884766,11589.0292969,0],
				[20319.509766,11661.34082,0],
				[20317.623047,11679.523438,0],
				[20297.166016,11670.260742,0],
				[20187.669922,11576.416016,0],
				[20176.722656,11590.219727,0],
				[20179.320313,11592.647461,0]
];

// Create AI
_AICount = 15 + (round (random 5));


_group =
[
	_AISoldierSpawnLocations+[_pos,_pos,_pos],			// Pass the regular spawn locations as well as the center pos 3x
	_AICount,
	_difficulty,
	"random",
	_side
] call DMS_fnc_SpawnAIGroup_MultiPos;


_staticGuns =
[
	[
						[20384.9,11637.2,0],
						[20386,11797.9,0],
						[20347.4,11843.3,0],
						[20166.4,11709.8,0],
						[20173.8,11575.3,0],
						[20313.5,11552.9,0],
						[20301,11548.4,0],
						[20228.3,11620.6,6.46176],
						[20243.8,11641.1,3.75764],
						[20064.1,11696,3.96349],
						[20064.1,11696,3.96349],
						[20275.8,11834.6,3.69609],
						[20179.5,11465.6,4.01455],
						[20295.8,11599.1,0.589539]
	],
	_group,
	"assault",
	_difficulty,
	"bandit",
	"random"
] call DMS_fnc_SpawnAIStaticMG;

_group3 =	[                                                       // Helicopter support group
				_pos,                 								//heli reinforcements
				2,
				"random",
				"random",
				_side
			] call DMS_fnc_SpawnAIGroup;
			[
			_group3,
			"random",
			"difficulty",
			_side,
			_pos,
			false,
			0,
			false,
			"I_Heli_light_03_dynamicLoadout_F"
			] call DMS_fnc_SpawnHeliReinforcement;
			
// add vehicle patrol 1
_ai_vehicle = "I_MBT_03_cannon_F"; // Class name of vehicle *Change This*
_veh =	[
			[
				[20249.2,11804.4,0]
			],
			_group,
			"assault",
			_difficulty,
			_side,
			_ai_vehicle
		] call DMS_fnc_SpawnAIVehicle;
		
// add vehicle patrol 2
_ai_vehicle = "CUP_B_HMMWV_Avenger_NATO_T"; // Class name of vehicle *Change This*
_veh =	[
			[
				[20162.1,11578.1,0]
			],
			_group,
			"assault",
			_difficulty,
			_side,
			_ai_vehicle
		] call DMS_fnc_SpawnAIVehicle;
		
// add Static AAPOD1 
_ai_vehicle = "CUP_B_Igla_AA_pod_CDF"; // Class name of vehicle *Change This*
_veh =	[
			[
				[20161.3,11650.2,3.69358]
			],
			_group,
			"assault",
			_difficulty,
			_side,
			_ai_vehicle
		] call DMS_fnc_SpawnAIVehicle;
		
// Define the classnames and locations where the crates can spawn (at least 2, since we're spawning 2 crates)
_crateClasses_and_Positions =
[
	[[20232.9,11619.1,0.16098],"I_CargoNet_01_ammo_F"],
	[[20236.8,11617.8,0.154953],"I_CargoNet_01_ammo_F"]
];

{
	deleteVehicle (nearestObject _x);		// Make sure to remove any previous crates.
} forEach _crateClasses_and_Positions;

// Shuffle the list
_crateClasses_and_Positions = _crateClasses_and_Positions call ExileClient_util_array_shuffle;


// Create Crates
_crate0 = [_crateClasses_and_Positions select 0 select 1, _crateClasses_and_Positions select 0 select 0] call DMS_fnc_SpawnCrate;
_crate1 = [_crateClasses_and_Positions select 1 select 1, _crateClasses_and_Positions select 1 select 0] call DMS_fnc_SpawnCrate;

// Disable or enable smoke on the crates so that the players have to search for them >:D
{
	_x setVariable ["DMS_AllowSmoke", true];
} forEach [_crate0,_crate1];


// Define mission-spawned AI Units
_missionAIUnits =
[
	_group, 		// We only spawned the single group for this mission
	_group3
];

// Define the group reinforcements
_groupReinforcementsInfo =
[
	[
		_group,			// pass the group
		[
			[
				3,		// Only 5 "waves" (5 vehicles can spawn as reinforcement)
				0
			],
			[
				-1,		// No need to limit the number of units since we're limiting "waves"
				0
			]
		],
		[
			300,		// At least a 5 minute delay between reinforcements.
			diag_tickTime
		],
		_pos,	
		"random",
		_difficulty,
		_side,
		"heli_troopers",
            [
                20,                // SCALAR: If the AI Group has fewer than "_AICount" living units, then the group will receive reinforcements.
                false,               // BOOLEAN: Whether or not to eject Fire-From-Vehicle (FFV) gunners.
                8,                    // SCALAR: Maximum number of AI to eject from the aircraft. Set to a really high # to ignore (like 999).
                false               // BOOLEAN: Whether or not to keep the heli flying around as a gunship.
                ]
		],
	    [
		_group,			// pass the group
		[
			[
				-1,		// Let's limit number of units instead...
				0
			],
			[
				20,	// Maximum 100 units can be given as reinforcements.
				0
			]
		],
		[
			120,		// About a 4 minute delay between reinforcements.
			diag_tickTime
		],
		_AISoldierSpawnLocations,
		"random",
		_difficulty,
		_side,
		"reinforce",
		[
			20,			// Reinforcements will only trigger if there's fewer than 10 members left in the group
			10			// 7 reinforcement units per wave.
		]
	]
];

_vehicle setVariable ["ExileMoney", _cash,true];

// Define mission-spawned objects and loot values
_missionObjs =
[
	_staticGuns+_baseObjs+[_veh],							// static gun(s). Road blocks. Patrol vehicles
	[_vehicle],												//this is prize vehicle
	[[_crate0,[50,100,2]],[_crate1,[3,150,15]]]
];

// Define Mission Start message
_msgStart = ['#FFFF00', "ISIS Has invaded Charkia, better stop them before they get any farther into Altis!"];

// Define Mission Win message
_msgWIN = ['#0080ff',format ["Convicts have successfully cleared Charkia, Vehicle entry code %1...",_pinCode]];

// Define Mission Lose message
_msgLOSE = ['#FF0000',"Charkia mission failed."];

// Define mission name (for map marker and logging)
_missionName = "Charkia Infiltration (AA)";

// Create Markers
_markers =
[
	_pos,
	_missionName,
	_difficulty
] call DMS_fnc_CreateMarker;

_circle = _markers select 1;
_circle setMarkerDir 20;
_circle setMarkerSize [150,150];


_time = diag_tickTime;

// Parse and add mission info to missions monitor
_added =
[
	_pos,
	[
		[
			"kill",
			[_group,_group3]
		],
		[
			"playerNear",
			[_pos,100]
		]
	],
	_groupReinforcementsInfo,
	[
		_time,
		DMS_StaticMissionTimeOut call DMS_fnc_SelectRandomVal
	],
	_missionAIUnits,
	_missionObjs,
	[_missionName,_msgWIN,_msgLOSE],
	_markers,
	_side,
	_difficulty,
	[]
] call DMS_fnc_AddMissionToMonitor_Static;

// Check to see if it was added correctly, otherwise delete the stuff
if !(_added) exitWith
{
	diag_log format ["DMS ERROR :: Attempt to set up mission %1 with invalid parameters for DMS_fnc_AddMissionToMonitor_Static! Deleting mission objects and resetting DMS_MissionCount.",_missionName];

	_cleanup = [];
	{
		_cleanup pushBack _x;
	} forEach _missionAIUnits;

	_cleanup pushBack ((_missionObjs select 0)+(_missionObjs select 1));

	{
		_cleanup pushBack (_x select 0);
	} foreach (_missionObjs select 2);

	_cleanup call DMS_fnc_CleanUp;


	// Delete the markers directly
	{deleteMarker _x;} forEach _markers;


	// Reset the mission count
	DMS_MissionCount = DMS_MissionCount - 1;
};


// Notify players
[_missionName,_msgStart] call DMS_fnc_BroadcastMissionStatus;



if (DMS_DEBUG) then
{
	(format ["MISSION: (%1) :: Mission #%2 started at %3 with %4 AI units and %5 difficulty at time %6",_missionName,_num,_pos,_AICount,_difficulty,_time]) call DMS_fnc_DebugLog;
};
