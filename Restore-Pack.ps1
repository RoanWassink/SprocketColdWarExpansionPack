param([Parameter(Mandatory)][string]$BackupDir,[string]$GameDir='C:/Program Files (x86)/Steam/steamapps/common/Sprocket',[switch]$Apply)
$ErrorActionPreference='Stop'
if(Get-Process -Name Sprocket -ErrorAction SilentlyContinue){throw 'Close Sprocket before restoring'}
$game=(Resolve-Path -LiteralPath $GameDir).Path;$backup=(Resolve-Path -LiteralPath $BackupDir).Path
$prefix=$game.TrimEnd('\','/')+[IO.Path]::DirectorySeparatorChar;$backupPrefix=$backup.TrimEnd('\','/')+[IO.Path]::DirectorySeparatorChar
$journal=Get-Content -LiteralPath (Join-Path $backup 'restore-records.json') -Raw|ConvertFrom-Json
if($journal.game -ne $game){throw 'Backup belongs to another game folder'}
foreach($entry in $journal.files){
 $target=[IO.Path]::GetFullPath((Join-Path $game $entry.Path));$saved=[IO.Path]::GetFullPath((Join-Path $backup $entry.Path))
 if(!$target.StartsWith($prefix,[StringComparison]::OrdinalIgnoreCase) -or !$saved.StartsWith($backupPrefix,[StringComparison]::OrdinalIgnoreCase)){throw 'Unsafe restore path'}
 if($entry.Existed -and (Get-FileHash -LiteralPath $saved).Hash -ne $entry.BeforeHash){throw 'Backup hash mismatch'}
}
$journal.files|Select-Object Path,Existed|Format-Table -AutoSize
if(!$Apply){'Plan only. Add -Apply to restore these mod files.';return}
# Preserve current mod versions as a second recovery copy before rollback.
$rollback=Join-Path $backup ('before-restore-'+(Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
foreach($entry in $journal.files){
 if(Get-Process -Name Sprocket -ErrorAction SilentlyContinue){throw 'Sprocket started; restore stopped'}
 $target=Join-Path $game $entry.Path
 if(Test-Path -LiteralPath $target){$copy=Join-Path $rollback $entry.Path;New-Item -ItemType Directory -Force ([IO.Path]::GetDirectoryName($copy))|Out-Null;Copy-Item -LiteralPath $target -Destination $copy}
 if($entry.Existed){New-Item -ItemType Directory -Force ([IO.Path]::GetDirectoryName($target))|Out-Null;Copy-Item -LiteralPath (Join-Path $backup $entry.Path) -Destination $target -Force;if((Get-FileHash -LiteralPath $target).Hash -ne $entry.BeforeHash){throw 'Restored hash mismatch'}}
 elseif(Test-Path -LiteralPath $target){Remove-Item -LiteralPath $target}
}
"Restored backed-up addon files. Current versions saved at $rollback. Restore vehicle backups separately."
