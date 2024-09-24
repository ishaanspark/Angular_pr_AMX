PROGRAM_NAME='IncSwitcher'
DEFINE_DEVICE

DEFINE_VARIABLE
integer nInputselection, nOutputselection
DEFINE_CONSTANT
Switcher_TELNET_PORT = 23 //Support UDP Protocol
Switcher_IP_ADDRESS ='192.168.1.102'

DEFINE_CALL 'Open_client_connection_for_Switcher'()
{
    //syntax: SLONG IP_CLIENT_OPEN(INTEGER LocalPort,CHAR ServerAddress[ ],LONG ServerPort,INTEGER Protocol)
    // Protocol : IP_TCP, IP_UDP and IP_UDP_2WAY
    IP_CLIENT_OPEN(dvSwitcher.port,Switcher_IP_ADDRESS,Switcher_TELNET_PORT,IP_TCP)
}

define_start
CALL 'Open_client_connection_for_Switcher'

DEFINE_EVENT
data_event[dvSwitcher]
{
    offline:
    {
	wait 300
	CALL 'Open_client_connection_for_Switcher'
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
		CALL 'Open_client_connection_for_Switcher'		
	    }
	}
    }
}

/*DEFINE_EVENT
DATA_EVENT[dvSwitcher]
{
    online:
    {
	send_command dvSwitcher,"'set baud 9600,N,8,1'"
    }
}*/

button_event[vdvUiRoom2_1,0]
{
    push:
    {
	switch(button.input.channel)
	{
	    case 11:
	    case 12:
	    case 13:
	    case 14:
	    case 15:
	    case 16:
	    case 17:
	    case 18:
	    {
		nInputselection =button.input.channel-10
	    }
	    case 21:
	    case 22:
	    case 23:
	    case 24:
	    case 25:
	    case 26:
	    case 27:
	    case 28:
	    {
		nOutputselection=button.input.channel-10
		send_string dvSwitcher,"'set switch CI',itoa(nInputselection),'O',itoa(nOutputselection),$0d"//1 input to all output
	    }
	    
	    case 501:
	    {
		send_string dvSwitcher,"'set switch CI1O1',$0d"//PRESET 1
		//send_string dvSwitcher,"'CI4O1 3T'"
	    }
	    case 502:
	    {
		send_string dvSwitcher,"'set switch CI1O2',$0d"//PRESET  2
		//send_string dvSwitcher,"'CI4O1 3T'"
	    }
	    case 503:
	    {
		send_string dvSwitcher,"'set switch CI1O3',$0d"//PRESET 3
		//send_string dvSwitcher,"'CI4O1 3T'"
	    }
	    case 504:
	    {
		send_string dvSwitcher,"'set switch CI1O4',$0d"//PRESET 4
		//send_string dvSwitcher,"'CI4O1 3T'"
	    }  	
	    case 505:
	    {
		send_string dvSwitcher,"'set switch CI2O1',$0d"//PRESET 4
		//send_string dvSwitcher,"'CI4O1 3T'"
	    }
	    case 506:
	    {
		send_string dvSwitcher,"'set switch CI2O2',$0d"//PRESET 4
		//send_string dvSwitcher,"'CI4O1 3T'"
	    }
	    case 507:
	    {
		send_string dvSwitcher,"'set switch CI2O3',$0d"//PRESET 4
		//send_string dvSwitcher,"'CI4O1 3T'"
	    }
	    case 508:
	    {
		send_string dvSwitcher,"'set switch CI2O4',$0d"//PRESET 4
		//send_string dvSwitcher,"'CI4O1 3T'"
	    }
	    case 509:
	    {
		send_string dvSwitcher,"'set switch CI3O1',$0d"//PRESET 4
		//send_string dvSwitcher,"'CI4O1 3T'"
	    }
	    case 510:
	    {
		send_string dvSwitcher,"'set switch CI3O2',$0d"//PRESET 4
		//send_string dvSwitcher,"'CI4O1 3T'"
	    }
	    case 511:
	    {
		send_string dvSwitcher,"'set switch CI3O3',$0d"//PRESET 4
		//send_string dvSwitcher,"'CI4O1 3T'"
	    }
	    case 512:
	    {
		send_string dvSwitcher,"'set switch CI3O4',$0d"//PRESET 4
		//send_string dvSwitcher,"'CI4O1 3T'"
	    }
	    case 513:
	    {
		send_string dvSwitcher,"'set switch CI4O1',$0d"//PRESET 4
		//send_string dvSwitcher,"'CI4O1 3T'"
	    }
	    case 514:
	    {
		send_string dvSwitcher,"'set switch CI4O2',$0d"//PRESET 4
		//send_string dvSwitcher,"'CI4O1 3T'"
	    }
	    case 515:
	    {
		send_string dvSwitcher,"'set switch CI4O3',$0d"//PRESET 4
		//send_string dvSwitcher,"'CI4O1 3T'"
	    }
	    case 516:
	    {
		send_string dvSwitcher,"'set switch CI4O4',$0d"//PRESET 4
		//send_string dvSwitcher,"'CI4O1 3T'"
	    }
	    
	}
    }
}//send_string dvSwitcher,"'set system reboot'"//reboot
