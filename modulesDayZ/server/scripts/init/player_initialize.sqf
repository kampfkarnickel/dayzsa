private["_state","_healthCheck","_fsm"];
/*
	Run on initialization of a player

	Author: Rocket
*/
_agent = _this;

//if (!isPlayer _player) exitWith {};

if (isServer) then
{
	//check if server task manager is running
	if (isNil "DZ_ServerBrain") then
	{
		DZ_ServerBrain = [] execFSM "\dz\server\scripts\fsm\server_taskmanager.fsm";
	};
		
	_agent synchronizeVariable ["bleedingsources",0.5,{_this call event_playerBleed}];
	_agent synchronizeVariable ["vomit",1,{null = _this spawn effect_playerVomit}];
	_agent synchronizeVariable ["blood",0.5];
	_agent synchronizeVariable ["health",0.5];
	_agent synchronizeVariable ["shock",0.5];
	
	if (_agent getVariable ["unconscious",false]) then
	{
		[_agent,true] call damage_unconscious;
	};
	
	//count bleeding
	_coords = call compile (_agent getVariable ["bleedingsources","[]"]);
	_agent setVariable ["bleedingLevel",(count _coords)];
	
	//run player brain
	//_fsm = _agent execFSM "\dz\server\scripts\fsm\brain_player_server.fsm";
	
	_agent setTargetCategory "player";
	
	null = _agent spawn 
	{
		_agent = _this;
		
		while {alive _this} do 
		{
			if (debug) then
			{
				//if (_agent != player) exitWith {};
				_str = format["MODIFIERS:\n\n%1\n\n",_agent];
				_modStates = _agent getVariable ["modstates",[]];
				_i = 0;
				{
					_v = _modStates select 0;
					_stage = _v select 0;
					_dur = _v select 1;
					_cool = _v select 2;
					_str = _str + format["%1: %2, %3, %4",_x,_stage,_dur,_cool];
					_i = _i + 1;
				} forEach (_agent getVariable ["modifiers",[]]);
				hintSilent _str;
			};
		
			//Ticks
			_agent call tick_modifiers;	//records changes in any modifiers
			_agent call tick_states;		//records changes in any states
			_agent call tick_environment; //records changes due to environment
			
			//exit
			if (isNull _agent) exitWith {};
			
			//wait
			sleep DZ_TICK;
		};
	};
	
	//event handlers
	_firedEH = _agent addEventHandler ["fired", {_this spawn event_weaponFired}];
	_killedEH = _agent addEventHandler ["killed", {_this spawn event_playerKilled}];
};