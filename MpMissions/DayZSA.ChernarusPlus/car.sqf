dokeyDown={
     private ["_key"] ;
     _key = _this select 1; 
     switch (_key) do {
          case (0x40): {sleep 1;createDialog "RscDisplayDebug";};
          case (0x3F): {sleep 1;createDialog "RscDisplayDebugPublic";};
     };     
     _return
};

sleep 5;
(FindDisplay 46) DisplaySetEventHandler [
     "keydown",
     "_this call dokeyDown"
     ];