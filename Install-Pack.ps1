param(
 [string]$GameDir='C:\Program Files (x86)\Steam\steamapps\common\Sprocket',
 [string]$BackupRoot=(Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Codex/SprocketColdWarBackups'),
 [switch]$Apply,
 [switch]$UsePackDefaults
)
$ErrorActionPreference='Stop'
& (Join-Path $PSScriptRoot 'Verify-Pack.ps1') -GameDir $GameDir
if(Get-Process -Name Sprocket -ErrorAction SilentlyContinue){throw 'Close Sprocket first; it will not be terminated automatically.'}
$game=(Resolve-Path -LiteralPath $GameDir).Path
foreach($required in @('winhttp.dll','doorstop_config.ini','BepInEx/core/BepInEx.Core.dll','BepInEx/core/BepInEx.Unity.IL2CPP.dll','BepInEx/interop/Sprocket.EngineDesigner.dll','dotnet/coreclr.dll')){
 if(!(Test-Path -LiteralPath (Join-Path $game $required))){throw "Install or restore the working BepInEx loader first, then start/close it once. Missing: $required"}
}
$manifest=Get-Content (Join-Path $PSScriptRoot 'manifest.json') -Raw | ConvertFrom-Json
$payload=Join-Path $PSScriptRoot 'Payload'
$gamePrefix=$game.TrimEnd('\','/')+[IO.Path]::DirectorySeparatorChar
$targetList=@{}
foreach($entry in $manifest.files){
 $target=[IO.Path]::GetFullPath((Join-Path $game $entry.path))
 if(!$target.StartsWith($gamePrefix,[StringComparison]::OrdinalIgnoreCase)){throw "Unsafe target: $target"}
 $targetList[$entry.path.ToLowerInvariant()]=$true
}
# Never leave duplicate copies of the same plugin or silently retain unreviewed mods.
$knownDlls=@($manifest.modules | ForEach-Object {[IO.Path]::GetFileName($_.file).ToLowerInvariant()})
foreach($file in Get-ChildItem (Join-Path $game 'BepInEx/plugins') -Recurse -Filter '*.dll' -ErrorAction SilentlyContinue){
 $relative=$file.FullName.Substring($gamePrefix.Length).Replace('\','/').ToLowerInvariant()
 if($relative.StartsWith('bepinex/plugins/bepinex.melonloader.loader/')){continue}
 if(!$targetList.ContainsKey($relative)){throw "Unreviewed plugin or duplicate at $relative. Complete the vanilla/loader-only step first."}
}
$plans=@();foreach($entry in $manifest.files){
 $target=Join-Path $game $entry.path
 $skip=($entry.path.StartsWith('BepInEx/config/') -or $entry.path -eq 'BepInEx/plugins/SprocketThermalSight/thermal-models.json') -and (Test-Path -LiteralPath $target) -and !$UsePackDefaults
 $plans+=[pscustomobject]@{Action=$(if($skip){'Preserve existing config'}elseif(Test-Path -LiteralPath $target){'Backup and replace'}else{'Install'});Path=$entry.path}
}
$plans | Format-Table -AutoSize
if(!$Apply){'PLAN ONLY: no files were changed. After review, use -Apply. -UsePackDefaults backs up and replaces existing addon configs.';return}
$backup=Join-Path ([IO.Path]::GetFullPath($BackupRoot)) ('pack-install-'+(Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
if($backup.StartsWith($gamePrefix,[StringComparison]::OrdinalIgnoreCase)){throw 'BackupRoot must be outside the game directory.'}
if(Test-Path -LiteralPath $backup){throw 'Backup directory already exists.'}
New-Item -ItemType Directory -Path $backup | Out-Null
$records=@();foreach($plan in $plans){
 if($plan.Action -eq 'Preserve existing config'){continue}
 $target=Join-Path $game $plan.Path;$exists=Test-Path -LiteralPath $target
 if($exists){$saved=Join-Path $backup $plan.Path;New-Item -ItemType Directory -Force ([IO.Path]::GetDirectoryName($saved)) | Out-Null;Copy-Item -LiteralPath $target -Destination $saved; if((Get-FileHash -LiteralPath $target).Hash -ne (Get-FileHash -LiteralPath $saved).Hash){throw "Backup failed: $target"}}
 $records+=[pscustomobject]@{Path=$plan.Path;Existed=$exists}
}
$records | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $backup 'restore-records.json') -Encoding utf8
foreach($plan in $plans){
 if($plan.Action -eq 'Preserve existing config'){continue}
 if(Get-Process -Name Sprocket -ErrorAction SilentlyContinue){throw "Sprocket started; stopped installation. Backups: $backup"}
 $source=Join-Path $payload $plan.Path;$target=Join-Path $game $plan.Path
 New-Item -ItemType Directory -Force ([IO.Path]::GetDirectoryName($target)) | Out-Null
 Copy-Item -LiteralPath $source -Destination $target -Force
 if((Get-FileHash -LiteralPath $source).Hash -ne (Get-FileHash -LiteralPath $target).Hash){throw "Installed hash mismatch: $target; backup: $backup"}
}
"Installed review candidate. Backups: $backup. Start the game only when ready for the test protocol."

