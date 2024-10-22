
<#ZACHARY STRICKLER

 

FUNCTION IS TO CHECK KBs FROM INTENDED SERVER LIST IN \COMPUTERS FOLDER OF THIS ZIP

 

COMPUTERS NEED TO HAVE CORRECT DNS, USERNAME, and PASSWORD IN EXCEL FILE TO WORK

 

PROGRAM WILL ASK YOU TO SELECT A POSTSCAN (SEE EXACT NEEDED POSTSCAN TEMPLATE IN ZIP FILE (JAN PRESCAN IS EXAMPLE))

 

PROGRAM WILL CREATE AN OUTPUT EXCEL WITH THE DNS, KB, AND INSTALLATION STATUS

 

PROGRAM WILL HANDLE CONNECTION ERRORS (COM ERRORS WILL TRY AGAIN UNTIL IT WORKS, CONNECTIVITY OR AUTHENTICATION ERRORS WILL

RESULT IN A "Could Not Connect" OUTPUT IN EXCEL FILE, UNKNOWN DEVICES WILL RESULT IN A "Device not found" IN OUTPUT FILE

 

DEVICES THAT SUCCESSFULLY CONNECT WILL RESULT IN EITHER AN "Installed" or "Not Installed" FOR THAT KB IN THE OUTPUT FILE

 

NEEDS INPUTEXCEL MODULE TO WORK #>

 

#Installs Excel Module

#Install-Module -Name ImportExcel #Needs Powershell to be ran as an Admin

 

#Installs Dialogue Box Framework For Select File

Add-Type -AssemblyName System.Windows.Forms

 

# Create our Path for our Input File (Lab Computers)

$LabComputers = "$PSSCriptRoot\Computers\LabComputers.xlsx"

 

#Set up Function For Selecting File (Post Scan File)

$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{

    InitialDirectory = [Environment]::GetFolderPath('Desktop')

    Filter = 'SpreadSheet (*.xlsx)|*.xlsx'

                                         }

$null = $FileBrowser.ShowDialog()

 

#Makes a Variable of the File Path for the Selected File

$PostScan = $FileBrowser.FileName

 

# IMPORT BOTH EXCEL FILES FROM THE PATH VARIABLES

try

{

$PostScanReport = Import-Excel -Path "$PostScan" -WorksheetName "patchreport"

$Computerlist = Import-Excel -Path "$LabComputers" -WorksheetName "Sheet1"

}

catch

{

    Write-Output "Please run again and select a file"

    break

}

 

#Create OutPutFile Path For The Final Scan"

$OutPutFile = "$PSSCriptRoot\Output\FinalScan.xlsx"

 

# Creates an array for all of the ouput in the end

$OutputReport=[System.Collections.ArrayList]@()

foreach($row1 in $PostScanReport) {

    $failed = $false

    $ScanKB = $row1.KB

    $columnToMatch = 'Device'

 

    $DeviceName = $row1.$columnToMatch

    Write-Output "Checking $DeviceName for $ScanKB"

    $matchingrow = $Computerlist | Where-Object { $_.$columnToMatch -eq $DeviceName }

    if ($matchingrow) {

        #Specify what Column in Excel File and Put The Information from the Same Row in a Variable

        $DNSRow = 'DNS'

        $DNS = $matchingrow.$DNSRow

        $UsernameRow = 'Username'

        $Username = $matchingrow.$UsernameRow

        $PasswordRow = 'Password'

        $Password = $matchingrow.$PasswordRow

        # Tries to remote into system with given DNS, Username and Password

 

        #start while loop here to retry for the error catch maybe

        do{

            try{

            $remotehotfixes = get-hotfix -ComputerName $DNS -Credential (New-Object PSCredential -ArgumentList $Username, (ConvertTo-SecureString -String $Password -AsPlainText -Force)) -ErrorAction SilentlyContinue

               

                if($remotehotfixes){

                    $kbPresent = $remoteHotfixes | Where-Object { $_.HotFixId -eq $ScanKB }

                        if ($kbPresent) {

                            $InstalledStatus = "Installed" #Displays Installed in Output File if KB is found

                            $failed = $false

                            Write-Output "$ScanKB Is Installed on $DeviceName"

                            }

                        else {

                            $InstalledStatus = "Not Installed"

                            $failed = $false

                            Write-Output "$ScanKB Is Not Installed on $DeviceName"

 

                             }

                                  }

                }

            catch [System.Runtime.InteropServices.COMException]{

                $failed = $true

                Write-Output "Trying again for $DeviceName"

                                              }

            catch [System.UnauthorizedAccessException]{

                $failed = $false

                $InstalledStatus = "Unauthorized Access"

                Write-Output "Could not connect to $DeviceName due to Unauthorized Access"

            }

                      }

           

              while($Failed)

 

        }

    else {

        $InstalledStatus = "Device Not Found"

        #Only Displays if the Computer being checked is not found in the LabComputers file

        #UPDATE TO MULTIPLE CATCHES FOR EACH ERROR | FOR CONNECTIVITY UPDATE INSTALLED STATUS TO CANT CONNECT System.UnauthorizedAccessException

        #OTHER ERROR SHOULD CATCH AND SEND LOOP BACK TO TRY AGAIN System.Runtime.InteropServices.COMException

    }

#Creates a New Row and Inserts The Header Followed by The Respective Properties

    $NewRow=New-Object -TypeName psobject

    Add-Member -InputObject $NewRow -MemberType NoteProperty -Name "DEVICE" -Value $DeviceName

    Add-Member -InputObject $NewRow -MemberType NoteProperty -Name "KB" -Value $ScanKB

    Add-Member -InputObject $NewRow -MemberType NoteProperty -Name "INSTALLATION" -Value $InstalledStatus

    [void]$OutputReport.add($NewRow)

}

#Styles the Excel File To Be More Easily Readable

$style = New-ExcelStyle -FontSize 11

$OutputReport| Export-Excel -Path($OutPutFile) -Show -Style $style -BoldTopRow -AutoSize

