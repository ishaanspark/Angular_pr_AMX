PROGRAM_NAME='IncCamera_1'

DEFINE_CONSTANT
CAMERA1_TELNET_PORT = 1259 //Support UDP Protocol
CAMERA1_IP_ADDRESS ='192.168.1.104'

DEFINE_CALL 'Open_client_connection_for_Camera1'()
{
    //syntax: SLONG IP_CLIENT_OPEN(INTEGER LocalPort,CHAR ServerAddress[ ],LONG ServerPort,INTEGER Protocol)
    // Protocol : IP_TCP, IP_UDP and IP_UDP_2WAY
    IP_CLIENT_OPEN(dvCamera1.port,CAMERA1_IP_ADDRESS,CAMERA1_TELNET_PORT,IP_UDP_2WAY)
}

define_start
CALL 'Open_client_connection_for_Camera1'

DEFINE_EVENT
data_event[dvCamera1]
{
    offline:
    {
	wait 300
	CALL 'Open_client_connection_for_Camera1'
    }
    onerror:
    {
	send_string 0,"'data number',itoa(data.number)"
	switch(data.number)
	{
	    // No need to reopen socket in response to following two errors.
	    case 9:// Socket closed in response to IP_CLIENT_CLOSE.
	    case 17:// String was sent to a closed socket.
	    {}
	    default:
	    {
		wait 300
		CALL 'Open_client_connection_for_Camera1'		
	    }
	}
    }
}

/*					{}, //CAM_Power on 
					{}, //CAM_Power Off (Standby)
					{}, //Camera Zoom Stop
					{}, //Camera ZoomTele (Standard)
					{}, //Camera Zoom Wide (Standard)
					{}, //Pan-tiltDrive Up e.g 8x 01 06 01 VV WW 03 01 FF (VV: Pan speed 0x01 (low speed) to 0x18 (high speed),WW: Tilt Speed 0x01 (low speed) to 0x18 (high speed))
					{}, //Pan-tiltDrive Down
					{}, //Pan-tiltDrive Left
					{}, //Pan-tiltDrive Right
					{} //Pan-tiltDrive Stop */
button_event[vdvUiRoom2_1,0]
{
    push:
    {
	switch(button.input.channel)
	{
	    case 261:
	    {
		send_string dvCamera1,"$01,$00,$00,$07,$00,$00,$00,$01,$81,$01,$04,$3F,$02,$01,$FF"  // preset 1
	    
	    }
	    case 262:
	    {
		send_string dvCamera1,"$01,$00,$00,$07,$00,$00,$00,$01,$81,$01,$04,$3F,$02,$02,$FF"  // preset 2
	    
	    }
	    case 263:
	    {
		send_string dvCamera1,"$01,$00,$00,$07,$00,$00,$00,$01,$81,$01,$04,$3F,$02,$03,$FF"  // preset 3
	    
	    
	    }
	    case 264:
	    {
		send_string dvCamera1,"$01,$00,$00,$07,$00,$00,$00,$01,$81,$01,$04,$3F,$02,$04,$FF"  // preset 4
	    
	    }
	    case 265:
	    {
		send_string dvCamera1,"$01,$00,$00,$07,$00,$00,$00,$01,$81,$01,$04,$3F,$02,$05,$FF"  // preset 5
	    
	    }
	    case 266:
	    {
		send_string dvCamera1,"$01,$00,$00,$07,$00,$00,$00,$01,$81,$01,$04,$3F,$02,$06,$FF"  // preset 6
	    
	    }
	    /*case 7:
	    {
		send_string dvCamera1,"$01,$00,$00,$07,$00,$00,$00,$01,$81,$01,$04,$3F,$02,$07,$FF"  // preset 7
	    
	    }
	    case 8:
	    {
		send_string dvCamera1,"$01,$00,$00,$07,$00,$00,$00,$01,$81,$01,$04,$3F,$02,$08,$FF"  // preset 8
	    
	    
	    }
	    case 9:
	    {
		send_string dvCamera1,"$01,$00,$00,$07,$00,$00,$00,$01,$81,$01,$04,$3F,$02,$09,$FF"  // preset 9
	    
	    }case 10:
	    {
		send_string dvCamera1,"$01,$00,$00,$07,$00,$00,$00,$01,$81,$01,$04,$3F,$02,$0A,$FF"  // preset 10
	    
	    }
	    case 21:
	    {
		send_string dvCamera1,"$01,$00,$00,$06,$00,$00,$00,$01,$81,$01,$04,$00,$02,$FF"  //CAM_Power on
	    
	    }
	    case 22:*/
	   // {
		//send_string dvCamera1,"$01,$00,$00,$06,$00,$00,$00,$01,$81,$01,$04,$00,$03,$FF"  //CAM_Power Off (Standby)
	   // }
	    //case 23:
	    {
		//send_string dvCamera1,"$01,$00,$00,$06,$00,$00,$00,$01,$81,$01,$04,$07,$00,$FF"  {}, //Camera Zoom Stop
	    }
	    case 159:
	    {
		send_string dvCamera1,"$01,$00,$00,$06,$00,$00,$00,$01,$81,$01,$04,$07,$02,$FF"  //Camera ZoomTele (Standard)
	    }
	    case 158:
	    {
		send_string dvCamera1,"$01,$00,$00,$06,$00,$00,$00,$01,$81,$01,$04,$07,$03,$FF"  //Camera Zoom Wide (Standard)
	    }
	    case 132:
	    {
		send_string dvCamera1,"$01,$00,$00,$09,$00,$00,$00,$02,$81,$01,$06,$01,$09,$09,$03,$01,$FF"  //Pan-tiltDrive Up
		send_string 0,"'test',$01,$00,$00,$09,$00,$00,$00,$02,$81,$01,$06,$01,$09,$09,$03,$01,$FF"  //Pan-tiltDrive Up
	    }
	    case 133:
	    {
		send_string dvCamera1,"$01,$00,$00,$09,$00,$00,$00,$02,$81,$01,$06,$01,$09,$09,$03,$02,$FF"  //Pan-tiltDrive Down
	    send_string 0,"$01,$00,$00,$09,$00,$00,$00,$02,$81,$01,$06,$01,$09,$09,$03,$02,$FF"  //Pan-tiltDrive Down
	    }
	    case 134:
	    {
		send_string dvCamera1,"$01,$00,$00,$09,$00,$00,$00,$01,$81,$01,$06,$01,$09,$09,$01,$03,$FF"  //Pan-tiltDrive Left
	    }
	    case 135:
	    {
		send_string dvCamera1,"$01,$00,$00,$09,$00,$00,$00,$01,$81,$01,$06,$01,$09,$09,$02,$03,$FF"  //Pan-tiltDrive Right
	    }	
	
	}
    
    }
    release:
    {
	switch(button.input.channel)
	{
	    case 159:
	    {
		send_string dvCamera1,"$01,$00,$00,$06,$00,$00,$00,$01,$81,$01,$04,$07,$00,$FF"  //zoom stop
	    }
	    case 158:
	    {
		send_string dvCamera1,"$01,$00,$00,$06,$00,$00,$00,$01,$81,$01,$04,$07,$00,$FF"  //Zoom Stop
	    }
	    case 132:
	    {
		send_string dvCamera1,"$01,$00,$00,$09,$00,$00,$00,$01,$81,$01,$06,$01,$09,$09,$03,$03,$FF"  //Pan tilt stop
	    }
	    case 133:
	    {
		send_string dvCamera1,"$01,$00,$00,$09,$00,$00,$00,$01,$81,$01,$06,$01,$09,$09,$03,$03,$FF"  //Pan tilt stop
	    }
	    case 134:
	    {
		send_string dvCamera1,"$01,$00,$00,$09,$00,$00,$00,$01,$81,$01,$06,$01,$09,$09,$03,$03,$FF"  //Pan tilt stop
	    }
	    case 135:
	    {
		send_string dvCamera1,"$01,$00,$00,$09,$00,$00,$00,$01,$81,$01,$06,$01,$09,$09,$03,$03,$FF"  //Pan tilt stop
	    }	
	}       
    }
}
button_event[vdvUiRoom2_1,101]//for test
{
    push:
    {
	IP_CLIENT_OPEN(dvCamera1.port,CAMERA1_IP_ADDRESS,CAMERA1_TELNET_PORT,IP_UDP)
    }
}

button_event[vdvUiRoom2_1,102]//for test
{
    push:
    {
	IP_CLIENT_OPEN(dvCamera1.port,CAMERA1_IP_ADDRESS,CAMERA1_TELNET_PORT,IP_UDP)
    }
}

button_event[vdvUiRoom2_1,103]//for test
{
    push:
    {
	IP_CLIENT_close(dvCamera1.port)
    }
}
