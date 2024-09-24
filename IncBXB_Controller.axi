PROGRAM_NAME='IncBXB_Controller'

DEFINE_VARIABLE

integer nChairman_1_Mic_Status, nChairman_2_Mic_Status, nChairman_3_Mic_Status, nChairman_4_Mic_Status, nChairman_5_Mic_Status, nChairman_6_Mic_Status, nChairman_7_Mic_Status

DEFINE_EVENT
data_event[dv_delegate_controller]
{
    online:
    {
	send_command dv_delegate_controller,"'set baud 9600,N,8,1'"
    }
    string:
    {
	if(find_string(data.text,"$05,$03,$E8,$EE",1)) // Mic  1 ON
	{
	    nChairman_1_Mic_Status =1
	    do_Push(vdvUiRoom2_1,261)
	}
	if(find_string(data.text,"$05,$03,$E9,$EF",1)) // Mic  2 ON
	{
	    nChairman_1_Mic_Status =1
	    do_Push(vdvUiRoom2_1,262)
	}
	else if(find_string(data.text,"$05,$03,$EA,$EC",1))// Mic 3 ON
	{//
	 nChairman_2_Mic_Status =1
	      do_Push(vdvUiRoom2_1,263)
	}
	else if(find_string(data.text,"$05,$03,$EB,$ED",1))// Mic 4 ON
	{

	 nChairman_3_Mic_Status =1
	      do_Push(vdvUiRoom2_1,264)
	}
	else if(find_string(data.text,"$05,$03,$EC,$EA",1))// Mic 5 ON
	{
	 nChairman_4_Mic_Status =1
	      do_Push(vdvUiRoom2_1,265)
	}
    	else if(find_string(data.text,"$05,$03,$EA,$EC",1))// Mic 6 ON
	{
	 nChairman_5_Mic_Status =1
	      do_Push(vdvUiRoom2_1,266)
	}
    	else if(find_string(data.text,"$05,$03,$ED,$EB",1))// Mic 7 ON
	{
	 nChairman_6_Mic_Status =1
	      do_Push(vdvUiRoom2_1,267)
	}
	/*else if(find_string(data.text,"$05,$00,$05,$00",1))// Mic 8 ON
	{
	 nChairman_7_Mic_Status =1
	      do_Push(dvTP_Camera1,7)
	}
	else if(find_string(data.text,"$05,$00,$06,$03",1))// M ON
	{
	 nChairman_7_Mic_Status =1
	      do_Push(dvTP_Camera1,8)
	}
	else if(find_string(data.text,"$05,$03,$EB,$ED",1))// Chairman 7 ON
	{
	 nChairman_7_Mic_Status =1
	      do_Push(dvTP_Camera1,9)
	}
	else if(find_string(data.text,"$05,$03,$EC,$EA",1))// Chairman 7 ON
	{
	 nChairman_7_Mic_Status =1
	      do_Push(dvTP_Camera1,9)
	}*/
	else if(find_string(data.text,"$06,$03,$E8,$ED,$06,$03,$E8,$ED",1))// Chairman 1 OFF
	{	
	    nChairman_1_Mic_Status =0
	}
	else if(find_string(data.text,"$06,$03,$E8,$ED,$0A,'3',$00,'9',$06,$03,$E8,$ED",1))// Chairman 1 OFF
	{
	    nChairman_1_Mic_Status =0

	}
	else if(find_string(data.text,"$06,$03,$E9,$EC,$06,$03,$E9,$EC",1))// Chairman 2 OFF
	{
	    nChairman_2_Mic_Status =0
	}
	else if(find_string(data.text,"$06,$03,$E9,$EC,$0A,'3',$00,'9',$06,$03,$E9,$EC",1))// Chairman 2 OFF
	{
	    nChairman_2_Mic_Status =0
	}
	else if(find_string(data.text,"$06,$03,$EA,$EF,$06,$03,$EA,$EF",1))// Chairman 3 OFF
	{
	    nChairman_3_Mic_Status =0
	}
	else if(find_string(data.text,"$06,$03,$EA,$EF,$0A,'3',$00,'9',$06,$03,$EA,$EF",1))// Chairman 3 OFF
	{
	    nChairman_3_Mic_Status =0
	}
	else if(find_string(data.text,"$06,$03,$EB,$EE,$06,$03,$EB,$EE",1))// Chairman 4 OFF
	{
	    nChairman_4_Mic_Status =0
	}
	else if(find_string(data.text,"$06,$03,$EB,$EE,$0A,'3',$00,'9',$06,$03,$EB,$EE",1))// Chairman 4 OFF
	{
	    nChairman_4_Mic_Status =0
	}
	else if(find_string(data.text,"$06,$03,$EC,$E9,$06,$03,$EC,$E9",1))// Chairman 5 OFF
	{
	    nChairman_5_Mic_Status =0
	}
	else if(find_string(data.text,"$06,$03,$EC,$E9,$0A,'3',$00,'9',$06,$03,$EC,$E9",1))// Chairman 5 OFF
	{
	    nChairman_5_Mic_Status =0
	}
	else if(find_string(data.text,"$06,$03,$ED,$E8,$06,$03,$ED,$E8",1))// Chairman 6 OFF
	{
	    nChairman_6_Mic_Status =0
	}	
	else if(find_string(data.text,"$06,$03,$ED,$E8,$0A,'3',$00,'9',$06,$03,$ED,$E8",1))// Chairman 6 OFF
	{
	    nChairman_6_Mic_Status =0
	}
	
	else if(find_string(data.text,"$06,$03,$EE,$EB,$0A,'3',$00,'9',$06,$03,$EE,$EB",1))// Chairman 7 OFF
	{
	    nChairman_7_Mic_Status =0
	     // do_Push(dvTP_Camera1,7)
	}
	
    }
}	



DEFINE_PROGRAM

if ((nChairman_1_Mic_Status==0) && (nChairman_2_Mic_Status==0) && (nChairman_3_Mic_Status==0) && (nChairman_4_Mic_Status==0)&& (nChairman_5_Mic_Status==0) && (nChairman_6_Mic_Status==0) && (nChairman_7_Mic_Status==0 ))
{
 do_Push(vdvUiRoom2_1,270)
}


