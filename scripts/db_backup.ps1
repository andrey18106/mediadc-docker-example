# run backup as task scheduler daily
# get database container id, may update when watchtower upgrades container to new version
# this program runs a backup of the postgres database, nextcloud config file
# also deletes any backups older than 15 days
$nextCloudPostgresContainerName = "nextcloud_postgres15"
$nextCloudPostgresContainerId = docker ps --no-trunc -aqf "name=$nextCloudPostgresContainerName"
$nextCloudDockerDataRootFolder = "\\wsl.localhost\docker-desktop-data\data\docker\volumes\xxxx\_data"
$backupFolderPath = "D:\nextcloud_backup"
$pgDumpFolder = "\pg_dumpall"
$logFolder = "\log"
$configFolder = "\configArchive"

$logFolderPath = $backupFolderPath + $logFolder
New-Item -ItemType Directory -Force -Path $logFolderPath

$filenameFormat = 'nextcloudBackupLog_' + (Get-Date -Format 'yyyy-MM') + '.txt'
$backupLog = "$logFolderPath/$filenameFormat"

# echo $backupLog

$currDate = Get-Date
$Daysback = "-15"
$DatetoDelete = $currDate.AddDays($Daysback)

":::$currDate:::Running nextcloud backup:::" | Tee-Object -Append -file $backupLog

# delete logs older than 7 days
"Get-ChildItem $logFolderPath -Recurse  | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item"  | Tee-Object -Append -file $backupLog
Get-ChildItem $logFolderPath -Recurse  | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item

$configFolderPath = $backupFolderPath + $configFolder
New-Item -ItemType Directory -Force -Path $configFolderPath

$filenameFormat = 'config_' + (Get-Date -Format 'yyyy-MM-dd-hh-mm') + '.php'
"Copy-Item $nextCloudDockerDataRootFolder\config\config.php -Destination $configFolderPath\$filenameFormat"  | Tee-Object -Append -file $backupLog
Copy-Item $nextCloudDockerDataRootFolder\config\config.php -Destination $configFolderPath\$filenameFormat

"Get-ChildItem $configFolderPath -Recurse  | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item"  | Tee-Object -Append -file $backupLog
Get-ChildItem $configFolderPath -Recurse  | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item

$pgDumpFolderPath = $backupFolderPath + $pgDumpFolder

New-Item -ItemType Directory -Force -Path $pgDumpFolderPath
$filenameFormat = 'dump_' + (Get-Date -Format 'yyyy-MM-dd-hh-mm') + '.sql'

"docker exec -t $nextCloudPostgresContainerId pg_dumpall -c -U postgres | Out-File -FilePath $pgDumpFolderPath\$filenameFormat"  | Tee-Object -Append -file $backupLog
docker exec -t $nextCloudPostgresContainerId pg_dumpall -c -U postgres | Out-File -FilePath $pgDumpFolderPath\$filenameFormat

"Get-ChildItem $pgDumpFolderPath -Recurse  | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item"  | Tee-Object -Append -file $backupLog
Get-ChildItem $pgDumpFolderPath -Recurse  | Where-Object { $_.LastWriteTime -lt $DatetoDelete } | Remove-Item

":::$currDate:::Finished nextcloud backup:::" | Tee-Object -Append -file $backupLog
