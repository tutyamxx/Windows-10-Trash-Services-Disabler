@echo off
setlocal enabledelayedexpansion
if DEFINED SESSIONNAME (
    echo.
    echo ##############################################################################
    echo #                                                                            #
    echo #  CAN'T EXECUTE THE SCRIPT - YOU NEED TO RUN IT WITH ELEVATED PERMISSIONS!  #
    echo #  You must right click the file and "Run as administrator"                  #
    echo #                                                                            #
    echo ##############################################################################
    echo.
    pause
    goto :EOF
)

echo [+] Preparing to disable trash services...
timeout 3 >Nul /nobreak
echo.

set /a count = 0
set list=AJRouter ALG BDESVC BTAGService bthserv PeerDistSvc CertPropSvc DiagTrack MapsBroker EFS Fax lfsvc HvHost vmickvpexchange vmicguestinterface vmicshutdown vmicheartbeat vmicvmsession vmicrdv vmictimesync vmicvss SharedAccess diagnosticshub.standardcollector.service AppVClient MSiSCSI SmsRouter NaturalAuthentication Netlogon NcdAutoSetup CscService ssh-agent WpcMonSvc SEMgrSvc PhoneSvc PcaSvc RasAuto RasMan SessionEnv TermService UmRdpService RemoteRegistry RetailDemo RemoteAccess seclogon SensorDataService SensrSvc SensorService shpamsvc SCardSvr ScDeviceEnum SCPolicySvc SNMPTRAP SysMain TapiSrv TabletInputService UevAgentService WbioSrvc wcncsvc WerSvc FontCache wisvc WMPNetworkSvc icssvc WinRM WSearch workfolderssvc WwanSvc RpcLocator BthAvctpSvc NetTcpPortSharing TrkWks FontCache3.0.0.0 WebClient SSDPSRV PerfHost BITS COMSysApp upnphost KtmRm WdiSystemHost fdPHost p2psvc FrameServer p2pimsvc swprv PNRPsvc PNRPAutoReg

(for %%a in (%list%) do (
    set /a count += 1
    SC queryex %%a | Find "STATE" | Find /v "RUNNING" > Nul && (
        echo Starting task #!count!:
        echo [x] The %%a service is not running, no need to stop
        echo [+] Service has been successfully disabled
        echo.

        sc config %%a start= disabled
        echo.
    )||(
        echo Starting task #!count!:
        echo [+] The %%a service is running, stopping it now
        net stop %%a /y

        echo [+] Service has been successfully disabled
        echo.
        sc config %%a start= disabled
        echo.
    )
))

echo #############################################################################
echo #                                                                           #
echo #  Everything went fine, trash services are now disabled                    #
echo #  IT IS RECOMMENDED TO RESTART YOUR COMPUTER AFTER RUNNING THIS SCRIPT     #
echo #                                                                           #
echo #############################################################################
echo.
pause