PROGRAM_NAME='Main'
(***********************************************************)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON:   AT:         *)
(***********************************************************)
(* System Type : NetLinx                                   *)
(***********************************************************)
(* REV HISTORY:                                            *)
(***********************************************************)
(*
    NX-2200 IP Address:192.168.1.108 subnet:255:255:255:0 Gateway:192.168.1.1
    Ipad IP Address:192.168.1.109 subnet:255:255:255:0 Gateway:192.168.1.1
    Wifi SSID :
    WIfi Password:
*)
(***********************************************************)
(*          DEVICE NUMBER DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_DEVICE


dvSwitcher 		= 5001:4:0 //Solvision-  SV04041UA 4x4 HDMI Matrix
//dvSwitcher1		= 0:4:0 // Cypress HDMI Switcher CPLUS-V4H4HPA
//dv_main_display	= 5001:1:0 // Samsung QM86T 
dv_delegate_controller 	= 5001:3:0 //BXB Delegate Controller
//dvMonitor_Lift		= 5001:4:0 // Monitot Lift BO
dvCamera1 		= 0:5:0 //Solvision CYT-FX4

dvTP_Switcher		= 10001:2:0
dvTP_Camera1		= 10001:11:0
//dvTP_Doc_Camera	= 10001:1:0
//dvTP_Main_display	= 10001:3:0
//dvTP_Monitor_Lift	= 10001:4:0
//dvTP_Macro		= 10001:31:0


(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT

(***********************************************************)
(*              DATA TYPE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_TYPE

(***********************************************************)
(*               VARIABLE DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_VARIABLE

(***********************************************************)
(*               LATCHING DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_LATCHING

(***********************************************************)
(*       MUTUALLY EXCLUSIVE DEFINITIONS GO BELOW           *)
(***********************************************************)
DEFINE_MUTUALLY_EXCLUSIVE

(***********************************************************)
(*        SUBROUTINE/FUNCTION DEFINITIONS GO BELOW         *)
(***********************************************************)
(* EXAMPLE: DEFINE_FUNCTION <RETURN_TYPE> <NAME> (<PARAMETERS>) *)
(* EXAMPLE: DEFINE_CALL '<NAME>' (<PARAMETERS>) *)

(***********************************************************)
(*                STARTUP CODE GOES BELOW                  *)
(***********************************************************)
DEFINE_START
//#include'IncMonitorLift.axi'
//#include'IncMain_Display.axi'
#include'IncSwitcher.axi'
#include'IncCamera_1.axi'
#include'IncBXB_Controller.axi'
//#include'IncDoc_Camera.axi'

(***********************************************************)
(*                THE EVENTS GO BELOW                      *)
(***********************************************************)
DEFINE_EVENT

(*****************************************************************)
(*                                                               *)
(*                      !!!! WARNING !!!!                        *)
(*                                                               *)
(* Due to differences in the underlying architecture of the      *)
(* X-Series masters, changing variables in the DEFINE_PROGRAM    *)
(* section of code can negatively impact program performance.    *)
(*                                                               *)
(* See “Differences in DEFINE_PROGRAM Program Execution” section *)
(* of the NX-Series Controllers WebConsole & Programming Guide   *)
(* for additional and alternate coding methodologies.            *)
(*****************************************************************)
DEFINE_PROGRAM

(*****************************************************************)
(*                       END OF PROGRAM                          *)
(*                                                               *)
(*         !!!  DO NOT PUT ANY CODE BELOW THIS COMMENT  !!!      *)
(*                                                               *)
(*****************************************************************)



