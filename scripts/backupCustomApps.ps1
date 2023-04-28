# TODO: update paths
# run this weekly not daily, custom apps can be 1 gib
# this script zips up custom apps folder, note node_modules will need to be reinstalled after a restore
# e.g. cd ./custom_apps/recognize, npm install
$nextCloudDockerDataRootFolder = "\\wsl.localhost\docker-desktop-data\data\docker\volumes\xxx\_data"
$backupFolderPath = "D:\nextcloud_backup"
$logFolder = "\log"
$zipFolder = "\archive"

$currDate = Get-Date
$Daysback = "-15"
$DatetoDelete = $currDate.AddDays($Daysback)

$logFolderPath = $backupFolderPath + $logFolder
$filenameFormat = 'nextcloudBackupLog_' + (Get-Date -Format 'yyyy-MM') + '.txt'
$backupLog = "$logFolderPath/$filenameFormat"

":::$currDate:::Running nextcloud custom_apps backup:::" | Tee-Object -Append -file $backupLog

If (!(test-path -PathType container "7zip")) {
    "7zip exe missing downloading" | Tee-Object -Append -file $backupLog

    curl -o 7za920.zip https://www.7-zip.org/a/7za920.zip

    powershell.exe -NoP -NonI -Command "Expand-Archive '.\7za920.zip' '.\7zip\'"
}

# output 7zip version
$command = ".\7zip\7za.exe"

$customAppFolderSource = $nextCloudDockerDataRootFolder + "\custom_apps\*"

$zipFolderPath = $backupFolderPath + $zipFolder
New-Item -ItemType Directory -Force -Path $zipFolderPath
$filenameFormat = 'custom_apps_' + (Get-Date -Format 'yyyy-MM-dd-hh-mm') + '.zip'

$zipDestination = "$zipFolderPath\$filenameFormat"

"zipping custom app folder: $customAppFolderSource to $zipDestination"  | Tee-Object -Append -file $backupLog

# 7z.exe a -t7z archive.7z FolderToArchive\ -mx0 -xr!bin -xr!obj
& $command a -mx0 -tzip $zipDestination $customAppFolderSource -mx0 -xr!node_modules


"Get-ChildItem $zipFolderPath -Recurse  | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item"  | Tee-Object -Append -file $backupLog
Get-ChildItem $zipFolderPath -Recurse  | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item

":::$currDate:::Finished nextcloud custom_apps backup:::" | Tee-Object -Append -file $backupLog
