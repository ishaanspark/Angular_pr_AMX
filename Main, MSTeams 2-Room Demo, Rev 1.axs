PROGRAM_NAME='Main, MSTeams 2-Room Demo, Rev 1'

#include 'SNAPI';

(***********************************************************)
(*  FILE CREATED ON: 09/17/2020  AT: 09:15:14              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 05/16/2022  AT: 12:57:56        *)
(***********************************************************)
(*  FILE REVISION: Rev 1                                   *)
(*  REVISION DATE: 07/19/2022  AT: 10:53:56                *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*  Include SNAPI + G4API                                  *)
(*  Update to constant references                          *)
(*  Identify assignment update requored at WebUI           *)
(*                                                         *)
(***********************************************************)
(*  FILE REVISION: Rev 0                                   *)
(*  REVISION DATE: 05/16/2022  AT: 12:50:37                *)
(*                                                         *)
(*  COMMENTS:                                              *)
(*                                                         *)
(***********************************************************)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE

vdvWebServer    = 41999:1:0;

vdvUiRoom1_1	= 41100:1:0;
dvUiRoom1	= 0:2:0;

vdvUiRoom2_1    = 41101:1:0;
vdvUiRoom2_2    = 41101:2:0;
vdvUiRoom2_3    = 41101:3:0;
vdvUiRoom2_4    = 41101:4:0;
vdvUiRoom2_5    = 41101:5:0;
vdvUiRoom2_6    = 41101:6:0;
dvUiRoom2 	= 0:3:0;



(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

// Same controls multiple devices (1/port) in same room
dev vdvUiRoom2Systems[] = {vdvUiRoom2_1, vdvUiRoom2_2, vdvUiRoom2_3, vdvUiRoom2_4, vdvUiRoom2_5, vdvUiRoom2_6}; 


(***********************************************************)
(*                MODULE DEFINITIONS GO BELOW              *)
(***********************************************************)

DEFINE_MODULE 
    'AMX_WebUI_Gateway_dr1_0_0' AMX_WebUI_Gateway_dr1_0_0_1 (vdvUiRoom1_1, dvUiRoom1);
    'AMX_WebUI_Gateway_dr1_0_0' AMX_WebUI_Gateway_dr1_0_0_2 (vdvUiRoom2_1, dvUiRoom2);

    
/*
*       Room Control URL Pattern:
*
*	<protocol>://<masterIP/hostName>:<port>/web/ui/<vdvDevice.NUMBER>/home
*
*/


(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
    
     char PREAUTH_CLIENTS[][255] = {'192.168.2.37',
				    '192.168.2.89'};

    integer MAX_ROOM = 2;
    integer MAX_LIGHTS = 3
   
    integer BTN_ROOM_PRESET[] = {501, 502, 503, 504, 505, 506, 507, 508, 509, 510};
    integer BTN_SHADE_PRESET[] = {521, 522, 523, 524, 525, 526, 527, 528, 529, 530};
    integer BTN_LIGHT_PRESET[] = {541, 542, 543, 544, 545, 546, 547, 548, 549, 550};
    integer BTN_CONTENT_SHARE_PRESET[] = {571, 572, 573, 574, 575, 576, 577, 578, 579, 580};
    integer BTN_DISPLAY_PRESET[] = {591, 592, 593, 594, 595, 596, 597, 598, 599, 600};
    
    integer BTN_LIGHT_TOGGLE[MAX_LIGHTS] = {561, 562, 563};
    integer LVL_LIGHT[MAX_LIGHTS] = {9, 10, 11};
    
    #include 'G4API'; // Include here to overwrite G4API BTN_LIGHT_PRESET[]

    
(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)

DEFINE_VARIABLE

volatile integer roomSource[MAX_ROOM];
volatile integer roomVolume[MAX_ROOM];
volatile integer cameraPreset[MAX_ROOM];
volatile integer shadePreset[MAX_ROOM];
volatile integer lightPreset[MAX_ROOM];
volatile integer roomPreset[MAX_ROOM];

volatile char bToggleLight[MAX_LIGHTS];

(***********************************************************)
(*                  FUNCTIONS                              *)
(***********************************************************)

define_function addPreAuthClients(char clients[][]) 
{
    if(length_array(clients)) {
	stack_var integer i;
	for(i = 1; i <= length_array(clients); i++) 
	{
	    send_command vdvWebServer ,"'CLIENTS.PREAUTH-ADD,',clients[i]";
	}
    }
}


(***********************************************************)
(*                 STARTUP CODE GOES BELOW                 *)
(***********************************************************)

(***********************************************************)
(*                  THE EVENTS GO BELOW                    *)
(***********************************************************)
DEFINE_EVENT

data_event[vdvUiRoom1_1] 
{
    online:
    {
  	send_command data.device,"'SERVER.PROPERTY-Duet-Device,',itoa(vdvWebServer.NUMBER),':',itoa(vdvWebServer.PORT),':',itoa(vdvWebServer.SYSTEM)";
	send_command data.device,"'PROPERTY-webui-configuration-file,vaughn-MTR.json'";
	
	send_command data.device, 'REINIT'; 

    }
}

data_event[vdvWebServer] 
{
    online:
    {
	send_command data.device,'PROPERTY-Has-PreAuthClients,true';
    }
}

channel_event[vdvWebServer, DATA_INITIALIZED] 
{
    on:
    {
	#warn 'Enable Pre-Authorized Clients list at CSV or Command API'
	addPreAuthClients(PREAUTH_CLIENTS);
    }
}

button_event[vdvUiRoom1_1,0]
{
    push:
    {
	switch(button.input.channel) 
	{
	    case BTN_VOL_UP: { // G4API Channel 24
		roomVolume[1] = roomVolume[1] + 5;
		if (roomVolume[1] > 255){
		    roomVolume[1] = 255
		}
		send_level button.input.device,VOL_LVL,roomVolume[1]; // SNAPI Level 1
		
		break;
	    }	    
	    case BTN_VOL_DN: { // G4API Channel 25
		if (roomVolume[1] > 0){
		    roomVolume[1] = roomVolume[1] - 5;
		}
		send_level button.input.device,VOL_LVL,roomVolume[1];// SNAPI Level 1
		
		break;
	    }
	    case BTN_VOL_MUTE: { // G4API Channel 26	
		[button.input.device, VOL_MUTE_ON] = ![button.input.device, VOL_MUTE_FB] // SNAPI Channel 199
		
		break;
	    }
	    case PWR_ON: { // G4API Channel 27
		on[button.input.device, POWER_ON]  // SNAPI Channel 255
		
		break;
	    }
	    case PWR_OFF: { // G4API Channel 28
		off[button.input.device, POWER_ON]  // SNAPI Channel 255
		
		break;
	    }
	    case BTN_POWER: { // G4API Channel 9
		[button.input.device,POWER_ON] = ![button.input.device,POWER_FB]; // SNAPI Channel 255
		
		break;
	    }
	    //Cam Control:
	    case BTN_TILT_UP: 	// G4API Channel 132
	    case BTN_TILT_DN: 	// G4API Channel 133
	    case BTN_PAN_LT:  	// G4API Channel 134
	    case BTN_PAN_RT: 	// G4API Channel 135
	    case BTN_ZOOM_IN:	// G4API Channel 159
	    case BTN_ZOOM_OUT: 	// G4API Channel 158
	    {
		min_to[button.input];
		
		break;
	    }
	}
    }
}

button_event[vdvUiRoom1_1,BTN_INPUT_SOURCE] // G4API Channel 281..300
{
    push:
    {
	off[button.input.device, BTN_INPUT_SOURCE];  // All FB off
	roomSource[1] = get_last(BTN_INPUT_SOURCE);
	on[button.input.device,BTN_INPUT_SOURCE[roomSource[1]]];
    }
}

button_event[vdvUiRoom1_1,BTN_CAM_PRESET] // G4API Channel 261..280
{
    push:
    {
      off[button.input.device,BTN_CAM_PRESET];  // All FB off
      cameraPreset[1] = get_last(BTN_CAM_PRESET);
      on[button.input.device,BTN_CAM_PRESET[cameraPreset[1]]];    
    }
}

level_event[vdvUiRoom1_1,LVL_VOL]  // SNAPI Level 1
{
    amx_log(AMX_ERROR,"'ROOM 1 VOLUME: ',itoa(level.value)");
}

/********* TEMPLATE #2 LEFT COL LAYOUT *************/

data_event[vdvUiRoom2_1] 
{
    online:
    {
  	send_command data.device,"'SERVER.PROPERTY-Duet-Device,',itoa(vdvWebServer.NUMBER),':',itoa(vdvWebServer.PORT),':',itoa(vdvWebServer.SYSTEM)";
	send_command data.device,"'PROPERTY-webui-configuration-file,einstein-MTR.json'";
	
	send_command data.device, 'REINIT'; 

    }
}

button_event[vdvUiRoom2_1,0]
{
    push:
    {
	switch(button.input.channel) {
	    case BTN_VOL_UP: { // G4API Channel 24
		roomVolume[2] = roomVolume[2] + 5;
		if (roomVolume[2] > 255){
		    roomVolume[2] = 255
		}
		send_level button.input.device,VOL_LVL,roomVolume[2]; // SNAPI Level 1
	    
		break;
	    }	    
	    case BTN_VOL_DN: { // G4API Channel 25
		if (roomVolume[2] > 0){
		    roomVolume[2] = roomVolume[2] - 5;
		}
		send_level button.input.device,VOL_LVL,roomVolume[2]; // SNAPI Level 1
		
		break;
	    }
	    
	    case BTN_VOL_MUTE: { // G4API Channel 26
		[button.input.device, VOL_MUTE_ON] = ![button.input.device, VOL_MUTE_FB] // SNAPI Channel 199
		
		break;
	    }
	    
	     //camera control:
	    case BTN_TILT_UP:	// G4API Channel 132
	    case BTN_TILT_DN:	// G4API Channel 133
	    case BTN_PAN_LT:	// G4API Channel 134
	    case BTN_PAN_RT: 	// G4API Channel 135
	    case BTN_ZOOM_IN:	// G4API Channel 159
	    case BTN_ZOOM_OUT: 	// G4API Channel 158
	    {
		min_to[button.input];
		
		break;
	    }
	}
    }
}

button_event[vdvUiRoom2_1,BTN_INPUT_SOURCE] // G4API Channel 281..300
{
    push:
    {
	off[button.input.device, BTN_INPUT_SOURCE];  // All FB off
	roomSource[2] = get_last(BTN_INPUT_SOURCE);
	on[button.input.device,BTN_INPUT_SOURCE[roomSource[2]]];
    }
}

button_event[vdvUiRoom2_1,BTN_CAM_PRESET] // G4API Channel 261..280
{
    push:
    {
	off[button.input.device,BTN_CAM_PRESET];  // All FB off
	cameraPreset[2] = get_last(BTN_CAM_PRESET);    
	on[button.input.device,BTN_CAM_PRESET[cameraPreset[2]]];
    }
}

button_event[vdvUiRoom2_1,BTN_ROOM_PRESET] // Custom API Channel 501..510
{
    push:
    {
	off[button.input.device,BTN_ROOM_PRESET];  // All FB off
	roomPreset[2] = get_last(BTN_ROOM_PRESET);
	on [button.input.device,BTN_ROOM_PRESET[roomPreset[2]]];
    }
}

button_event[vdvUiRoom2_1,BTN_CONTENT_SHARE_PRESET] // Custom API Channel 571..580
{
    push:
    {
	off[button.input.device,BTN_CONTENT_SHARE_PRESET]; // All FB off
	on[button.input];
    }
}

button_event[vdvUiRoom2_1,BTN_DISPLAY_PRESET] // Custom API Channel 591..600
{
    push:
    {
	off[button.input.device,BTN_DISPLAY_PRESET]; // All FB off
	on[button.input];
	
	switch(get_last(BTN_DISPLAY_PRESET))
	{
	    case 1: // All Displays Off
	    {
		off[vdvUiRoom2Systems,POWER_ON];  // SNAPI Channel 255

		break;
	    }
	    case 2: // All Displays On
	    {
		on[vdvUiRoom2Systems,POWER_ON];  // SNAPI Channel 255
	    
		break;
	    }
	}
    }
}
	    
button_event[vdvUiRoom2_1,BTN_SHADE_PRESET] // Custom API Channel 521..530
{
    push:
    {
	off[ button.input.device,BTN_SHADE_PRESET]; // All off
	shadePreset[2] = get_last(BTN_SHADE_PRESET);
	on[ button.input.device,BTN_SHADE_PRESET[shadePreset[2]]];
    }
}

button_event[vdvUiRoom2_1,BTN_LIGHT_PRESET] // Custom API Channel 541.. 550
{
    push:
    {

	off[ button.input.device,BTN_LIGHT_PRESET];
	lightPreset[2] = get_last(BTN_LIGHT_PRESET);
	on[ button.input.device,BTN_LIGHT_PRESET[lightPreset[2]]];
	
	// Individual light channel and level addressing custom set at config json file
	switch(lightPreset[2]){
	    case 1: {// Call
		send_level button.input.device,LVL_LIGHT[1],50; // Overhead  Custom Level 9
		send_level button.input.device,LVL_LIGHT[2],50; // Track     Custom Level 10
		bToggleLight[3] = false;			// Bar       Custom Channel 563
		[button.input.device, BTN_LIGHT_TOGGLE[3]] = bToggleLight[3]; 
		
		break;
	    }
	    case 2: { // Standard
		send_level button.input.device,LVL_LIGHT[1],85; // Overhead  Custom Level 9
		send_level button.input.device,LVL_LIGHT[2],85; // Track     Custom Level 10
		bToggleLight[3] = true; 			// Bar       Custom Channel 563
		[button.input.device, BTN_LIGHT_TOGGLE[3]] = bToggleLight[3];
		
		break;
	    
	    }
	    case 3:{ // Cleaning
		send_level button.input.device,LVL_LIGHT[1],100; // Overhead  Custom Level 9
		send_level button.input.device,LVL_LIGHT[2],100; // Track     Custom Level 10
		bToggleLight[3] = true;				 // Bar       Custom Channel 563
		[button.input.device, BTN_LIGHT_TOGGLE[3]] = bToggleLight[3]; 
		
		break;
	    }
	}

	
    }
}


button_event[vdvUiRoom2_1,BTN_LIGHT_TOGGLE] // Custom API Channel 561.. 563
{
    release:
    {
	stack_var integer iLight;
	
	iLight = get_last(BTN_LIGHT_TOGGLE);
	bToggleLight[iLight] = !bToggleLight[iLight];
	amx_log(AMX_ERROR,"'Toggle Light ',itoa(iLight),'->',itoa(bToggleLight[iLight])");
	[button.input.device, BTN_LIGHT_TOGGLE[iLight]] = bToggleLight[iLight];
    }
}

// Same controls multiple devices (1/port) in same room
button_event[vdvUiRoom2Systems, 0]
{
    push:
    {
	stack_var integer iDevice;
	
	iDevice = get_last(vdvUiRoom2Systems);
	
	switch(button.input.channel)
	{	
	    //shades control:
	    case BTN_MOTOR_STOP:    // G4API Channel 2
	    case BTN_MOTOR_OPEN:    // G4API Channel 4
	    case BTN_MOTOR_CLOSE: { // G4API Channel 5
		off[vdvUiRoom2Systems[iDevice],MOTOR_STOP];  // SNAPI Channel 2
		off[vdvUiRoom2Systems[iDevice],MOTOR_OPEN];  // SNAPI Channel 2
		off[vdvUiRoom2Systems[iDevice],MOTOR_CLOSE]; // SNAPI Channel 2

		min_to[vdvUiRoom2Systems[iDevice],button.input.channel];
		
		break;
	    }
	    
	    // Displays control:
	    case PWR_ON: { // G4API Channel 27
		on[vdvUiRoom2Systems[iDevice], POWER_ON];  // SNAPI Channel 255
		
		break;
	    }
	    case PWR_OFF: { // G4API Channel 28
		off[vdvUiRoom2Systems[iDevice], POWER_ON];  // SNAPI Channel 255
		
		break;
	    }
	    case BTN_POWER: { // G4API Channel 9
		[vdvUiRoom2Systems[iDevice],POWER_ON] = ![vdvUiRoom2Systems[iDevice],POWER_FB]; // SNAPI Channel 255
		
		break;
	    } 
	}
    }
    release:
    {
	stack_var integer iDevice;
	
	iDevice = get_last(vdvUiRoom2Systems);
	
	switch(button.input.channel){
	    //shade control:
	    case BTN_MOTOR_OPEN:    // G4API Channel 4
	    case BTN_MOTOR_CLOSE: { // G4API Channel 5
		on[vdvUiRoom2Systems[iDevice],MOTOR_STOP]; // G4API Channel 2
	    }
	}
    }
}


level_event[vdvUiRoom2_1,VOL_LVL] // SNAPI Level 1
{	
    amx_log(AMX_ERROR,"'ROOM 2 VOLUME: ',itoa(level.value)");
}

level_event[vdvUiRoom2_1,LVL_LIGHT[1]] // Custom Level 9
{
    amx_log(AMX_ERROR,"'ROOM 2 Overhead Light level: ',itoa(level.value)");
}
level_event[vdvUiRoom2_1,LVL_LIGHT[2]] // Custom Level 10
{
    amx_log(AMX_ERROR,"'ROOM 2 Track Light level: ',itoa(level.value)");
}

