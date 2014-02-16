setTimeForScripts 90;

call compile preprocessFileLineNumbers "\dz\modulesDayZ\init.sqf";

DZ_MP_CONNECT = true;
DZ_MAX_ZOMBIES = 300;

dbSelectHost "http://localhost/DayZServlet/"; 
_createPlayer =
{
//check database
_savedChar = dbFindCharacter _uid;
_isAlive = _savedChar select 0;
_pos = [_savedChar select 1,_savedChar select 2,_savedChar select 3];
_idleTime = _savedChar select 4;

//process client
[_id,_isAlive,_pos,overcast,rain] spawnForClient {
titleText ["","BLACK FADED",10e10];
diag_log str(_this);
playerQueueVM = _this call player_queued;

0 setOvercast (_this select 4);
simulSetHumidity (_this select 4);
0 setRain (_this select 5);
};
    AMSID = player addAction [("<t color=""#FF3300"">" + ("Gegner spawnen") +"</t>"), "spawn.sqf", [], 1, true, true, "", "alive player"];
};

//DISCONNECTION PROCESSING
_disconnectPlayer =
{
if ((lifeState _agent == "ALIVE") and (not captive player)) then
{
_agent call dbSavePlayerPrep;
dbServerSaveCharacter _agent;
deleteVehicle _agent;

}
else
{
dbKillCharacter _uid;
//_id statusChat["Player %1 was killed by %2",name _agent, name _killer];


};

};

// Create player on connection
onPlayerConnecting _createPlayer;
onPlayerDisconnected _disconnectPlayer;

"clientReady" addPublicVariableEventHandler
{
_id = _this select 1;
_uid = getClientUID _id;
diag_log format["Player %1 ready to load previous character",_uid];
//_id statusChat["Player", _uid , "connected"];
_handler =
{
if (isNull _agent) then
{
//this should never happen!
diag_log format["Player %1 has no agent on load, kill character",_uid];
_id statusChat ["Your character was unable to be loaded and has been reset. A system administrator has been notified. Please reconnect to continue.","ColorImportant"];
dbKillCharacter _uid;
}
else
{
call init_newBody;
};
};
_id dbServerLoadCharacter _handler;
};

"respawn" addPublicVariableEventHandler
{

_agent = _this select 1;

diag_log format ["CLIENT request to respawn %1 (%2)",_this,lifeState _agent];

if (lifeState _agent != "ALIVE") then
{
//get details
_id = owner _agent;
_uid = getClientUID _id;
_agent setDamage 1;

//process client
[_id,false,[0,0,0]] spawnForClient {
titleText ["Respawning... Please wait...","BLACK FADED",10e10];
diag_log str(_this);
playerQueueVM = _this call player_queued;
};
};

};

"clientNew" addPublicVariableEventHandler
{
_array = _this select 1;
_id = _array select 2;
diag_log format ["CLIENT %1 request to spawn %2",_id,_this];
_id spawnForClient {statusChat ['testing 1 2 3','']};

_savedChar = dbFindCharacter (getClientUID _id); //ClientUID //steamUID
//if (_savedChar select 0) exitWith {
//diag_log format ["CLIENT %1 spawn request rejected as fake",_id];
//};

_charType = _array select 0;
_charInv = _array select 1;
_pos = findSpawnPoint [ DZ_posbubbles, DZ_spawnparams ];

//load data
_top = getArray(configFile >> "cfgCharacterCreation" >> "top");
_bottom = getArray(configFile >> "cfgCharacterCreation" >> "bottom");
_shoe = getArray(configFile >> "cfgCharacterCreation" >> "shoe");

_myTop = _top select (_charInv select 0);
_myBottom = _bottom select (_charInv select 1);
_myShoe = _shoe select (_charInv select 2);
_mySkin = DZ_SkinsArray select _charType;

_agent = createAgent [_mySkin, _pos, [], 0, "NONE"];
{null = _agent createInInventory _x} forEach [_myTop,_myBottom,_myShoe];
_v = _agent createInInventory "tool_flashlight";
_v = _agent createInInventory "consumable_battery9V";_v setVariable ["power",30000];
_agent call init_newPlayer;
call init_newBody;

};


//call dbLoadPlayer;
_humidity = 0.3;
//setDate getSystemTime;
simulSetHumidity _humidity;
0 setOvercast _humidity;

_position = [7500,7500,0];
//exportProxies [_position,200000];
call init_spawnZombies;
sleep 1;
importProxies;	
while{true} do {
spawnLoot [_position,15000,25000];
sleep 6400;
};
onPlayerDisconnected _disconnectPlayer;

setTimeForScripts 0.03;

[] execVM "car.sqf";

