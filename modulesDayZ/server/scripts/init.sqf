DZ_MAX_ZOMBIES = 100;
DZ_TotalZombies = 0;
playerBodies = [];

windChill = 0;
worldLightScale = 0;
windSpeed = 0;

debug = true;

//events
event_saySound =		compile preprocessFileLineNumbers "\dz\server\scripts\events\event_saySound.sqf";
event_weaponFired =		compile preprocessFileLineNumbers "\dz\server\scripts\events\event_weaponFired.sqf";
event_craftMessage = 	compile preprocessFileLineNumbers "\dz\server\scripts\events\event_craftMessage.sqf";
event_modifier = 		compile preprocessFileLineNumbers "\dz\server\scripts\events\event_modifier.sqf";
event_assessDamage = 	compile preprocessFileLineNumbers "\dz\server\scripts\events\event_assessDamage.sqf";
event_transferModifiers = 	compile preprocessFileLineNumbers "\dz\server\scripts\events\event_transferModifiers.sqf";
event_igniteObject = 	compile preprocessFileLineNumbers "\dz\server\scripts\events\event_igniteObject2.sqf";
event_clearModifiers = 	compile preprocessFileLineNumbers "\dz\server\scripts\events\event_clearModifiers.sqf";
event_playerKilled = 	compile preprocessFileLineNumbers "\dz\server\scripts\events\event_playerKilled.sqf";
event_hitZombie =		compile preprocessFileLineNumbers "\dz\server\scripts\events\event_hitZombie.sqf";
event_bloodTransfusion = compile preprocessFileLineNumbers "\dz\server\scripts\events\event_bloodTransfusion.sqf";
event_killedZombie = compile preprocessFileLineNumbers "\dz\server\scripts\events\event_killedZombie.sqf";
event_gasLight = compile preprocessFileLineNumbers "\dz\server\scripts\events\event_gasLight.sqf";

//players
//player_checkStealth = 	compile preprocessFileLineNumbers "\dz\server\scripts\players\player_checkStealth.sqf";
player_combineQuantity = 	compile preprocessFileLineNumbers "\dz\server\scripts\players\player_combineQuantity.sqf";
player_splitQuantity = 	compile preprocessFileLineNumbers "\dz\server\scripts\players\player_splitQuantity.sqf";
player_useItem =		compile preprocessFileLineNumbers "\dz\server\scripts\players\player_useItem.sqf";
player_useItemEnd =		compile preprocessFileLineNumbers "\dz\server\scripts\players\player_useItemEnd.sqf";
player_fillBottle =		compile preprocessFileLineNumbers "\dz\server\scripts\players\player_fillBottle.sqf";
player_stripMagazine = 	compile preprocessFileLineNumbers "\dz\server\scripts\players\player_stripMagazine.sqf";
player_loadMagazine = 	compile preprocessFileLineNumbers "\dz\server\scripts\players\player_loadMagazine.sqf";
player_addInventory = 	compile preprocessFileLineNumbers "\dz\server\scripts\players\player_addInventory.sqf";
player_actionOnTarget = compile preprocessFileLineNumbers "\dz\server\scripts\players\player_actionOnTarget.sqf";
player_actionOnSelf = 	compile preprocessFileLineNumbers "\dz\server\scripts\players\player_actionOnSelf.sqf";
player_actionOnItem = 	compile preprocessFileLineNumbers "\dz\server\scripts\players\player_actionOnItem.sqf";
player_combineMoney = 	compile preprocessFileLineNumbers "\dz\server\scripts\players\player_combineMoney.sqf";
player_applyBandage = 	compile preprocessFileLineNumbers "\dz\server\scripts\players\player_applyBandage.sqf";
player_chamberRound = 	compile preprocessFileLineNumbers "\dz\server\scripts\players\player_chamberRound.sqf";
player_loadWeapon = 	compile preprocessFileLineNumbers "\dz\server\scripts\players\player_loadWeapon.sqf";
player_applyDefibrillator = 	compile preprocessFileLineNumbers "\dz\server\scripts\players\player_applyDefibrillator.sqf";

//weapons
weapon_swapHandguard =compile preprocessFileLineNumbers "\dz\server\scripts\weapons\weapon_swapHandguard.sqf";

//server
building_spawnLoot =	compile preprocessFileLineNumbers "modulesDayZ\server\scripts\server\building_spawnLoot.sqf";
init_spawnLoot = 		compile preprocessFileLineNumbers "modulesDayZ\server\scripts\init\spawnLoot.sqf";
init_spawnZombies = 	compile preprocessFileLineNumbers "modulesDayZ\server\scripts\init\spawnZombies.sqf";
player_queued = 		compile preprocessFileLineNumbers "\dz\modulesDayZ\scripts\player_queued.sqf";

//functions
fnc_generateTooltip = compile preprocessFileLineNumbers "\dz\modulesDayZ\scripts\fn_generateTooltip.sqf";
fnc_inString = 		compile preprocessFileLineNumbers "\dz\server\scripts\functions\fn_inString.sqf";
fnc_inAngleSector =  	compile preprocessFileLineNumbers "\dz\server\scripts\functions\fn_inAngleSector.sqf";
fnc_isMaxQuantity = 		compile preprocessFileLineNumbers "\dz\server\scripts\functions\isMaxQuantity.sqf";
BIS_fnc_findSafePos =	compile preprocessFileLineNumbers "\dz\server\scripts\functions\fn_findSafePos.sqf";
fnc_generateQuantity =compile preprocessFileLineNumbers "\dz\server\scripts\functions\fn_generateQuantity.sqf";
dayz_losCheck =		compile preprocessFileLineNumbers "\dz\server\scripts\functions\dayz_losCheck.sqf";
dayz_losChance = 		compile preprocessFileLineNumbers "\dz\server\scripts\functions\dayz_losChance.sqf";
dayz_bulletHit = 		compile preprocessFileLineNumbers "\dz\modulesDayZ\scripts\dayz_bulletHit.sqf";
fnc_playerMessage =	compile preprocessFileLineNumbers "\dz\modulesDayZ\scripts\fn_playerMessage.sqf";
runZombieBrain =		compile preprocessFileLineNumbers "\dz\server\scripts\functions\runZombieBrain.sqf";
tick_modifiers =		compile preprocessFileLineNumbers "\dz\server\scripts\functions\tick_modifiers.sqf";
tick_states =		compile preprocessFileLineNumbers "\dz\server\scripts\functions\tick_states.sqf";
tick_environment = 	compile preprocessFileLineNumbers "\dz\server\scripts\functions\tick_environment.sqf";
randomValue =		compile preprocessFileLineNumbers "\dz\modulesDayZ\scripts\randomValue.sqf";
dbLoadPlayer = 		compile preprocessFileLineNumbers "\dz\server\scripts\functions\dbLoadPlayer.sqf";
world_surfaceNoise = 	compile preprocessFileLineNumbers "\dz\server\scripts\functions\fn_surfaceNoise.sqf";

//initialize
zombie_initialize = 	compile preprocessFileLineNumbers "\dz\server\scripts\init\zombie_initialize.sqf";
player_initialize = 	compile preprocessFileLineNumbers "\dz\server\scripts\init\player_initialize.sqf";
init_battery = 		compile preprocessFileLineNumbers "\dz\server\scripts\init\battery_initialize.sqf";
init_cooker = 		compile preprocessFileLineNumbers "\dz\server\scripts\init\cooker_initialize.sqf";
init_lamp =
{
	if (isServer) then
	{
		_this spawn {
			_this synchronizeVariable ["light",1,{_this call event_fnc_gasLight}];
		};
	};
};

init_newPlayer =
{
	//establish default variables
	_this setVariable ["health",DZ_HEALTH];
	_this setVariable ["blood",DZ_BLOOD];
	_this setVariable ["energy",DZ_ENERGY];
	_this setVariable ["water",DZ_WATER];
	_this setVariable ["stomach",DZ_STOMACH];
	_this setVariable ["diet",DZ_DIET];
	
	//get blood type
	_bloodTypes = getArray (configFile >> "cfgSolutions" >> "bloodTypes"); 
	_rand = random 1; 
	_newType = ""; 
	{ 
		_chance = getNumber (configFile >> "cfgSolutions" >> _x >> "probabilityScale"); 
		if (_rand < _chance) exitWith  
		{ 
			_newType = _x; 
		}; 
	} forEach _bloodTypes;	
	_this setVariable ["bloodtype",_newType];
};

init_newBody =
{
	//manage player body
	playerBodies set [count playerBodies,_agent];
	_agent setVariable ["UID",_uid];
	diag_log format["Recording player %1 with %2",name _agent,_uid];
	
	//move player into body
	_id selectPlayer _agent;
	_agent call player_initialize;	
	[_id] spawnForClient compile "player execFSM '\dz\modulesDayZ\fsm\brain_player_client.fsm'";
	_agent addEventHandler ["HandleDamage",{_this call event_assessDamage} ];
};

dbSavePlayerPrep = 
{
	_agent = _this;
	switch (lifeState _agent) do
	{
		case "UNCONSCIOUS": {
			_agent setVariable ["unconscious",true];
		};
		case "ALIVE": {
			_agent setVariable ["unconscious",false];
		};
		default {
			_agent setVariable ["unconscious",false];
		};
	};
};

player_warningMessage = {
	private["_messages","_color","_client","_output"];
	_messages = _this select 0;
	_color = _this select 1;
	_client = _this select 2;
	_output = (_messages select floor(random(count _messages)));
	if (isDedicated) then {
		_client statusChat [_output,_color];
	} else {
		statusChat [_output,_color];
	};
};

fnc_generateRscQuantity = {
	private["_object","_resource","_qty ","_max","_str"];
	_object = _this select 0;
	_resource = _this select 1;
	_qty = _object getVariable [_resource,1];
	_max = getNumber (configFile >> "CfgVehicles" >> typeOf _object >> "Resources" >> _resource);
	_qty = round ((_qty / _max) * 100);
	_str = format ["%1%%",_qty];
	_str
};

doZombieHit = {
	private["_agent","_fsm"];
	_agent = _this;
	_fsm = _agent getVariable["fsm",-1];
	if (_fsm < 0) exitWith{};
	_fsm setFSMVariable["_attacking",false];
};

building_getProxyName = {
	//Take string and return truncated proxy name
	_array = toArray(_this);
	_newArray = [];
	for "_i" from 17 to ((count _array) - 1) do 
	{
		_newArray set[(_i - 17),(_array select _i)];
	};
	_string = toString _newArray;
	_string
};

fnc_randomPlacement = {
	private["_pos","_max","_val"];
	_pos = _this select 0;
	_max = _this select 1;
	_val = 0;
	
	for "_i" from 0 to 1 do 
	{	
		_val = _max - (random (_max * 2));
		_pos set [_i,((_pos select _i) + _val)];
	};
	_pos
};

/*
ENVIRONMENT FUNCTIONS
*/
fnc_processItemWetness = {

	/*
		Processes wetness change for an item
		_this refers to whether item is parented to player or not
	*/
	
	if (!isNull _item) then
	{
		if (_this) then {_filledSlots = _filledSlots + 1};
		
		//is the player getting wet?
		_wetness = _item getVariable ["wet",0];
		if (_isDrying and (_wetness == 0)) exitWith {};
		
		//is the item actually absorbent?
		_absorbancy = getNumber(configFile >> "cfgVehicles" >> typeOf _item >> "absorbency");
		if (_absorbancy == 0) exitWith {};

		//is the item already wet enough?
		private["_change"];
		_change = (_delta * _scale);
		if ((_wetness >= _scale) and !_isDrying) exitWith {};

		//calculate wetness
		_wetness = (((_wetness + (_delta * _scale)) min 1) max 0) * _absorbancy;
		if (_this) then
		{
			//check if should make player wet or dry
			if ((_wetness == 1) or (_wetness == 0)) then
			{
				_playerWet = (((_playerWet + _change) min 1) max 0);
			};			
		};
		_item setVariable ["wet",_wetness];
	}
	else
	{
		_playerWet = (((_playerWet + (_delta * _scale)) min 1) max 0);
	};
};

/*
DAMAGE CAlC
*/
damage_fnc_generateSlots =
{
	_slots = getArray (_config >> "inventorySlots");
	{
		private["_item"];
		//find out what is on the player
		_item = _agent itemInSlot _x;
		if (!isNull _item) then
		{
			_items set [count _items,_item];
		};
	} forEach _slots;
};
damage_fnc_applyStateChange =
{
	private["_v","_i"];
	_v = getNumber(_ammoConfig >> format["hit%1",_this]);
	//statusChat[format["Result: %1",_v],""];
	_i = _agent getVariable [_this,0];
	_agent setVariable [_this,(_i + _v)];
};
damage_unconscious = 
{
	private["_agent","_case"];
	_agent = _this select 0;
	_case = _this select 1;
	if _case then {
		_agent playAction "KnockDownStayB";
		_agent setUnconscious true;
	}
	else
	{
		//null = _agent spawn {sleep 1;_this playAction "KnockUp"};
		_agent setUnconscious false;
	};
};
damage_publishBleeding =
{
	_chance = getNumber(_ammoConfig >> "bleedChance");
	if (_isMelee) then
	{
		{
			_i = _agent itemInSlot _x;
			_chance = _chance * (1 - (getNumber(configFile >> "cfgVehicles" >> typeOf _i >> "DamageArmor" >> "bleed") * (1 - damage _i)));
		} forEach _slots;
	};
	
	_doBleed = (random 1) < _chance;
	if (_doBleed) then 
	{
		_bleeding = call compile (_agent getVariable ["bleedingsources","[]"]);
		_bleeding set [count _bleeding,_this select 5];
		_agent setVariable ["bleedingsources",str(_bleeding)];
	};
	//statusChat [format["chance: %1 // result: %2 // bone: %3 // damage: %4",_chance,_doBleed,_bone,_damage],""];
};
medical_playerBandage =
{
	_agent = _this select 1;
	if (_this select 0) then
	{
		_infectionChance = random 1;
		_wounds = _agent getVariable ['bleedingLevel',0];
		if (_wounds > 0) then {
			_item = _agent getVariable ['inUseItem',objNull];
			_condition = damage _item;
			if ((_condition >= 0.5) and (_infectionChance < 0.3)) then 
			{
				[0,_agent,'WoundInfection'] call event_modifier;
			};
		};
		_agent setVariable ['bleedingsources','[]'];
		_agent setVariable ['bleedingLevel',0];
		_agent setDamage 0;
	}
	else
	{
		_agent setVariable ['bleedingsources','[]'];
		_agent setVariable ['bleedingLevel',0];
		_agent setDamage 0;
	};
};
/*
EVENT MANAGEMENT
*/
fnc_speedVector = {
	private["_speed"];
	_speed = [0,0,0] distance (velocity _this);
	_speed
};

weapon_toggleOptics = {
//[(_this select 0),0] call 
	_optic = _this select 0;
	_powerOn = _this select 1;
	
	switch (_powerOn) do
	{
		case 0:
		{
			_optic setObjectTexture [0,""];
		};
		case 1:
		{
			//set scope texture if required
			_opticTexture = getText (configFile >> "CfgVehicles" >> typeOf _optic >> "OpticsInfo" >> "opticSightTexture");
			if (_opticTexture != "") then
			{
				_optic setObjectTexture [0,_opticTexture];
			};
		};
	};
};

player_fnc_useItemStart =
{
	_person setVariable ["inUseItem",_item];
	if (_quantity > 0) then
	{
		//Use part of stack
		_quantity = (_quantity - _use) max 0;		
		_item setVariable ["quantity",_quantity];
	};
};

player_fnc_useItemEnd =
{
	_oldItem = _person getVariable ["previousItem",objNull];
	_item = _person getVariable ["inUseItem",objNull];
	if (!_keepEmpty) then
	{		
		if (quantity _item <= 0) exitWith
		{
			deleteVehicle _item;
		};
	};
	if (_oldItem != _item) then 
	{
		_person moveToHands _oldItem;
	};
	_person setVariable ["inUseItem",objNull];
	_person setVariable ["previousItem",objNull];
};

event_fnc_sendActvMessage = {
	//send an activation message
	private["_messages","_style","_output","_statement"];
	//_stages = _cfgModifier >> "Stages";
	//_cfgStage = _stages select _stage;

	_messages = getArray (_cfgStage >> "messages");
	if (count _messages > 0) then
	{
		_style = getText (_cfgStage >> "messageStyle");
		_output = (_messages select (floor random(count _messages)));
		[_person,_output,_style] call fnc_playerMessage;
	};
	
	//execute entry statement
	_statement = getText(_cfgStage >> "statementEnter");
	call compile _statement;
};

event_fnc_endModifier = {	
	private["_statement"];
	//end the modifier
	_modifiers set [_i,0];
	_modstates set [_i,0];
	_cleanup = true;
	_skipSave = true;
	
	//send a state exit message
	private["_messages","_style","_output"];
	_messages = getArray (_cfgModifier >> "messagesExit");
	if (count _messages > 0) then
	{
		_style = getText (_cfgModifier >> "messageExitStyle");
		_output = (_messages select (floor random(count _messages)));
		[_person,_output,_style] call fnc_playerMessage;
	};
	
	//run ending statement
	_statement = getText (_cfgStage >> "statementExit");	//_person
	call compile _statement;
};

event_fnc_addModifier = {
	/*
		important! this must not have its variables set to private!
		
		This script is used within others, parenting off their variables, to
		allow the addition of a modifier to the mod array
	*/
	//check if allowed to add
	private["_stages","_cfgStage"];
	_stages = _cfgModifier >> "Stages";
	_cfgStage = _stages select _stage;
	_condition = getText (_cfgStage >> "condition");
	
	_runEvent = _person call compile _condition;
	if (!_runEvent) exitWith {};
	
	//load additional variables			
	_remaining = getArray (_cfgStage >> "duration") call randomValue;
	_reminder = getArray (_cfgStage>> "cooldown") call randomValue;
	
	//send an activation message
	call event_fnc_sendActvMessage;
	
	//save results
	_modifiers set [count _modifiers,_modifier];
	if (_person isKindOf "SurvivorBase") then
	{
		_stageArray = [_stage];
		_modstates set [count _modstates,[_stageArray,_remaining,_reminder]];
	};
	//call event_fnc_saveModifiers;
};

event_fnc_saveModifiers = {
	/*
	important! don't declare these values as private, as it uses its
	parents variables
	
	This function processes an array save for modifiers where needed
	*/
	if (_cleanup) then 
	{
		_modifiers = _modifiers - [0];
		_modstates = _modstates - [0];
	};
	_modifiers = _person setVariable["modifiers",_modifiers];
	if (_person isKindOf "SurvivorBase") then
	{
		_modstates = _person setVariable["modstates",_modstates];
	};
};

event_fnc_advanceModifier = {
	private["_newStage"];
	_newStage = _checkStages select _cStage;
	/*
	important! don't declare these values as private, as it uses its
	parents variables
	*/
	//is condition met?
	_condition = getText (_newStage >> "condition");
	_runEvent = _person call compile _condition;
	if (_runEvent) then
	{
		//load new stage
		_cfgStage = _newStage;
		_cfgStages = _checkStages;
		//statusChat[format["Advancing too...%1 in ; %2",configName _cfgStage,_cfgStages],"colorFriendly"];
		diag_log format["Stage change to: %1; duration: %2",(_cfgStage),getArray (_cfgStage >> "duration")];
		_remaining = getArray (_cfgStage >> "duration") call randomValue;
		_reminder = getArray (_cfgStage >> "cooldown") call randomValue;
		_stage = _cStage;
		_stageArray set [_cSerial,_stage];
		_modstates set [_i,[_stageArray,_remaining,_reminder]];
		
		//send an activation message
		call event_fnc_sendActvMessage;
		
		//save
		//call event_fnc_saveModifiers;
	};
	_runEvent
};

/*
	PLAYER FUNCTIONS
*/

player_fnc_roundsDistribute = {
	/*
	Used when distributing rounds amongst piles
	uses the _quantity , _person , _ammo, _parent parent variables
	*/
	private["_pile","_receiverQty","_exchanged","_max"];
	_max = 	getNumber (configFile >> "CfgVehicles" >> _ammo >> "stackedMax");
	if (_quantity <= 0) exitWith {};
	_pile = objNull;
	{
		if (_x isKindOf _ammo) then
		{
			//has a pile
			if (!(_x call fnc_isMaxQuantity)) then
			{
				_pile = _x;
				_receiverQty = quantity _pile;
				//process changes
				_exchanged = ((_receiverQty + _quantity) min _max) - _receiverQty;
				_receiverQty = _receiverQty + _exchanged;
				_quantity = _quantity - _exchanged;
				_pile setVariable ["quantity",_receiverQty];				
			};
		};
	} forEach itemsInCargo _parent;
	if (_quantity > 0) then 
	{
		_pile = [_ammo,_parent,_person] call player_addInventory;
		_pile setVariable ["quantity",_quantity];	
	};
	[_person,"craft_rounds"] call event_saySound;
};

player_fnc_knockdown = {
	/*
		Used within the damage functionality to knock a player down
		can be easily commented out to be disabled
	*/
	private["_agent","_source","_pos1","_pos2"];
	_agent = _this select 0;
	_source = _this select 1;
	_pos1 = getPos _agent;
	_pos2 = getPos _source;
	_dir = ((_pos2 select 0) - (_pos1 select 0)) atan2 ((_pos2 select 1) - (_pos1 select 1));
	//_dir = _dir % 360;
	_dir = _dir - (getdir _agent); //subtract direction of unit
	
	if (_dir < 0) then {_dir = _dir + 360};
	if (_dir > 360) then {_dir = _dir - 360};
	
	_dir = _dir + 45;

	switch true do 
	{
		case (_dir < 90):
		{
			_agent playAction "KnockDownF";
		};
		case (_dir < 180):
		{
			_agent playAction "KnockDownR";
		};
		case (_dir < 270):
		{
			_agent playAction "KnockDownB";
		};
		case (_dir < 360):
		{
			_agent playAction "KnockDownL";
		};
	};
};
 
player_fnc_tickBlood = {
	private["_regen","_hungerOk","_thirstOk","_result"];
	/*
		Calculates how much blood the player should regen
	*/
	_regen = _this;
	_hungerOk = _person getVariable ["hunger",0] < 0;
	_thirstOk = _person getVariable ["thirst",0] < 0;
	_result = 0;
	
	if (_hungerOk and _thirstOk) then
	{
		_result = (_person getVariable ["blood",5000]) + _regen;
		_result = _result min (_person getVariable ["health",5000]);
		_result = _result - (_person getVariable ["blood",5000]);
	};
	_result
};

player_fnc_tickHealth = {
	private["_regen","_hungerOk","_thirstOk","_result","_bloodOk"];
	/*
		Calculates how much health the player should regen
	*/
	_regen = _this;
	_hungerOk = _person getVariable ["hunger",0] < 0;
	_thirstOk = _person getVariable ["thirst",0] < 0;
	_health = _person getVariable ["health",5000];
	_bloodOk = _person getVariable ["blood",5000] >= _health;
	_result = 0;
	
	if (_hungerOk and _thirstOk and _bloodOk) then
	{
		_result = _regen;
	};
	_result
};

player_fnc_tickExposure = {
	private["_wci","_result","_items","_situations","_situation"];
	/*
		Calculates how much exposure should change
	*/	
	_result = 0;
	
	_items = itemsInInventory _agent;
	_damper = 0;
	_situations = ["heatReduction","coldReduction"];
	_situation = switch true do
	{
		case (windChill <= DZ_COOLING_POINT):	{1};		//cooling
		case (windChill):	{0};		//warming
	};
	
	//tally up damper based on clothing
	{
		private["_isClothing","_wetness","_change"];
		_isClothing = _x isKindOf "ClothingBase";
		if (_isClothing) then
		{
			_wetness = _x getVariable ["wet",0];
			
			_change = getNumber(configFile >> "cfgVehicles" >> typeOf _x >> (_situations select _situation));
			_damper = _damper + _change;
		};
	} forEach _items;
	
	_damper = 1 - ((_damper min 1) max 0);
	_wci = (windChill * _damper);
	
	//diag_log format["WCI: %1",(_wci)];
	//hintSilent str(_wci);
	_result
};

player_fnc_processStomach = {
	private["_person","_itemCfg","_itemClass","_energy","_water","_stomach","_scale"];
	/*
		Calculates how much total volume in the stomach should change based on energy/water used by player for actions or food/drink consumed by player
	*/
	_person = _this select 0;
	_itemClass = _this select 1;
	_itemCfg = configFile >> "CfgVehicles" >> _itemClass;
	if (count _this > 2) then
	{
		_scale = _this select 2;
	}
	else
	{
		_scale = 1;
	};
	
	if (!isClass _itemCfg) exitWith {};
	
	//if (isNil "_scale") then {_scale = 1;hint "bing!";};
	
	_energy = _person getVariable ["energy",DZ_ENERGY]; // actual energy from all food and drink consumed
	_water = _person getVariable ["water",DZ_WATER]; // actual water from all food and drink consumed
	_stomach = _person getVariable ["stomach",DZ_STOMACH]; // actual volume in stomach
	_diet = _person getVariable ["diet",DZ_DIET]; // actual diet 
	
	_isFood = _itemClass isKindOf "FoodItemBase";
	_isDrink = _itemClass isKindOf "DrinksItemBase";
	_isMedicine = _itemClass isKindOf "MedicalItemBase";
	
	switch true do
	{
		case (_isFood or _isDrink):
		{
			// pull food and drink nutritions parameters from Nutrition class
			_nutritionConfig = _itemCfg >> "Nutrition";
			_totalVolume = getNumber (_nutritionConfig >> "totalVolume");
			_consumableWater = getNumber (_nutritionConfig >> "water");
			_consumableEnergy = getNumber (_nutritionConfig >> "energy");
			_consumableNutriIndex = getNumber (_nutritionConfig >> "nutritionalIndex");
			
			//statusChat [format ["D> energy:%1, water:%2, stomach:%3, scale:%4 (%5)",_energy,_water,_stomach,_scale,isNil "_scale"],""]; // debug: actual values of states
			
			// volume of portion actually eaten/drunk/used
			_portionVolume = _totalVolume * _scale; // ??Am I sure to get proper scale from actionOnSelf??
			
			// change energy
			_energyGathered = _consumableEnergy * _scale; // energy actually gathered from serving		
			_energy = _energy + _energyGathered;
			_person setVariable ["energy",_energy];
			
			// change water
			_waterGathered = _consumableWater * _scale; // water actually gathered from serving
			_water = _water + _waterGathered;
			_person setVariable ["water",_water];
			
			// change diet
			_dietGathered = _consumableNutriIndex * _scale * 0.01; // nutrients actually gathered from serving	
			_diet = (((9 * _diet) + _dietGathered) / 10) min 1; // diet formula (will be probably changed)
			_person setVariable ["diet",_diet];
			
			// change stomach volume
			_stomach = _stomach + _portionVolume;
			_person setVariable ["stomach",_stomach];
		};
		case _isMedicine:
		{
			_medicineConfig = _itemCfg >> "Medicine";
			_consumablePrevention = getNumber (_medicineConfig >> "prevention");
			
			// change diet
			_dietGathered = _consumablePrevention; // nutrients actually gathered from medicine
			_diet = (((4 * _diet) + _dietGathered) / 5) min 1; // diet formula (will be probably changed)
			_person setVariable ["diet",_diet];
		};
	};
};

player_vomit = {
	_agent = _this;
	if (_agent getVariable["vomiting",false]) exitWith {};
	_agent playAction ["PlayerCrouch",{_agent setVariable["vomiting",true]}];
	waitUntil {_agent getVariable["vomiting",true]};
	_agent playAction ["PlayerVomit",{_agent setVariable["vomiting",false]}];
	_energy = _agent getVariable ["energy",DZ_ENERGY]; // actual energy from all food and drink consumed
	_water = _agent getVariable ["water",DZ_WATER]; // actual water from all food and drink consumed
	_stomach = _agent getVariable ["stomach",DZ_STOMACH]; // actual volume in stomach
	
	if (_stomach > 100) then
	{
		_agent setVariable ["vomit",diag_tickTime];	//broadcasts vomit
		
		//remove contents
		_stomach = (_stomach - 500) max 0;
		_agent setVariable ["stomach",_stomach];
			
		_energy = (_energy - 600) max 100;
		_agent setVariable ["energy",_energy];		
			
		_water = (_water - 1000);
		_agent setVariable ["water",_water];
	}
	else
	{
		//dry wretch
		
		//remove contents
		_agent setVariable ["stomach",0];
	};
};