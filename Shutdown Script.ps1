# PURPOSE OF SCRIPT IS TO ITERATE THROUGH AN EXCEL FILE AND SHUTDOWN COMPUTERS WITH THE CREDENTIALS AND DNS IN THE EXCEL

 

$ShutdownComputers = "$PSScriptRoot\Computers\PhysicalDevices.xlsx"

 

$Computerlist = Import-Excel -Path "$ShutdownComputers" -WorksheetName "Sheet1"

 

$OutPutFile = "$PSSCriptRoot\Output\ShutdownCompletition.xlsx"

 

$OutputReport=[System.Collections.ArrayList]@()

 

foreach($row1 in $Computerlist)

{

 

$ComputerDNS = $row1.DNS

$ComputerName = $row1.DeviceName

$Password = $row1.Password

$Username = $row1.Username

$Domain = $row1.Domain

    if ($ComputerDNS -eq $null )

    {

        break

    }

    else

    {

           try

            {

                Write-Output "Shutting Down $ComputerDNS"

                #Figure out Command To shutdown Computer

                Stop-Computer -ComputerName $ComputerDNS -Force -Credential (New-Object PSCredential -ArgumentList $Username, (ConvertTo-SecureString -String $Password -AsPlainText -Force)) #-ErrorAction SilentlyContinue

                Start-Sleep -Seconds 45

                Write-Output "Testing Connection For $ComputerDNS"

                #Test-Connection -ComputerName $ComputerDNS

            }

 

           catch [System.Net.NetworkInformation.PingException]

           {

           Write-Output "Could not Ping $ComputerDNS , system was shutdown"

           }

 

           catch [System.Runtime.InteropServices.COMException]

           {

           Write-Output "The Device $ComputerDNS is already Offline"

           }

 

#Figure out Command to Ping Computer

#See if Computer Pings or not

#Get Booolean Operator and if Ping Works then try again, if ping doesnt work, make shutdown variable true

#Handle log in error

#Handle Error of Computer Already being shutdown

#Shutdown

    }

}

