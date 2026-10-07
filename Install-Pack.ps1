param([string]$GameDir='C:/Program Files (x86)/Steam/steamapps/common/Sprocket',
 [string]$BackupRoot=(Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Codex/SprocketColdWarBackups'),[switch]$Apply)
$ErrorActionPreference='Stop'
& (Join-Path $PSScriptRoot 'Verify-Pack.ps1') -GameDir $GameDir
if(Get-Process -Name Sprocket -ErrorAction SilentlyContinue){throw 'Close Sprocket first; it will not be terminated.'}
$game=(Resolve-Path -LiteralPath $GameDir).Path
$prefix=$game.TrimEnd('\','/')+[IO.Path]::DirectorySeparatorChar
$manifest=Get-Content -LiteralPath (Join-Path $PSScriptRoot 'manifest.json') -Raw|ConvertFrom-Json
foreach($required in @('winhttp.dll','doorstop_config.ini','BepInEx/core/BepInEx.Core.dll','BepInEx/core/BepInEx.Unity.IL2CPP.dll','BepInEx/interop/Sprocket.EngineDesigner.dll','dotnet/coreclr.dll')){if(!(Test-Path -LiteralPath (Join-Path $game $required))){throw "Install/start the working Sprocket Mod Loader first. Missing: $required"}}
function Resolve-Target([string]$relative){$target=[IO.Path]::GetFullPath((Join-Path $game $relative));if(!$target.StartsWith($prefix,[StringComparison]::OrdinalIgnoreCase)){throw 'Unsafe target'};return $target}
$knownModules=@{};foreach($module in $manifest.modules){$knownModules[[IO.Path]::GetFileName($module.file).ToLowerInvariant()]=$module.file.ToLowerInvariant()}
foreach($dll in Get-ChildItem -LiteralPath (Join-Path $game 'BepInEx/plugins') -Recurse -Filter '*.dll' -File -ErrorAction SilentlyContinue){
 $name=$dll.Name.ToLowerInvariant();$relative=$dll.FullName.Substring($prefix.Length).Replace('\','/').ToLowerInvariant()
 if($knownModules.ContainsKey($name) -and $knownModules[$name] -ne $relative){throw "Duplicate addon DLL: $relative. Back up/remove that duplicate before updating."}
}
$aliases=@{'BepInEx/config/sprocket.shellselector.cfg'='BepInEx/config/nl.roan.sprocket.shellselector.cfg'}
$plans=@()
foreach($entry in $manifest.files){
 $target=Resolve-Target $entry.path;$exists=Test-Path -LiteralPath $target
 $settings=$entry.path.StartsWith('BepInEx/config/') -or $entry.path -eq 'BepInEx/plugins/SprocketThermalSight/thermal-models.json'
 $native=$entry.path.StartsWith('Sprocket_Data/StreamingAssets/Technology/') -or $entry.path.StartsWith('Sprocket_Data/StreamingAssets/Eras/')
 $action='Install'
 if($exists){
  $hash=(Get-FileHash -LiteralPath $target).Hash
  if($settings){$action='Preserve settings'}
  elseif($hash -eq $entry.sha256){$action='Already current'}
  elseif($native -and $hash -notin @($entry.previousDefaultHashes)){$action='Preserve custom native data'}
  else{$action='Replace'}
 }elseif($aliases.ContainsKey($entry.path) -and (Test-Path -LiteralPath (Resolve-Target $aliases[$entry.path]))){$action='Preserve legacy settings'}
 $plans+=@([pscustomobject]@{Path=$entry.path;Action=$action;Existed=$exists;BeforeHash=$(if($exists){(Get-FileHash -LiteralPath $target).Hash}else{$null})})
}
foreach($retired in $manifest.retiredFiles){
 $target=Resolve-Target $retired.path
 if(Test-Path -LiteralPath $target){
  $hash=(Get-FileHash -LiteralPath $target).Hash
  if($hash -notin @($retired.knownHashes)){throw "Customized obsolete part: $($retired.path). Back it up, copy the replacement part and remove the obsolete duplicate manually."}
  $plans+=@([pscustomobject]@{Path=$retired.path;Action='Retire duplicate part';Existed=$true;BeforeHash=$hash})
 }
}
$plans|Format-Table Action,Path -AutoSize
if(!$Apply){'Plan only. Add -Apply to install with verified backups.';return}
$backup=Join-Path ([IO.Path]::GetFullPath($BackupRoot)) ('pack-update-'+(Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
if($backup.StartsWith($prefix,[StringComparison]::OrdinalIgnoreCase) -or (Test-Path -LiteralPath $backup)){throw 'Unsafe or existing backup directory'}
New-Item -ItemType Directory -Path $backup|Out-Null
$changes=@($plans|Where-Object Action -in @('Install','Replace','Retire duplicate part'))
foreach($plan in $changes){
 $target=Resolve-Target $plan.Path
 if($plan.Existed){
  if((Get-FileHash -LiteralPath $target).Hash -ne $plan.BeforeHash){throw 'A target changed during preparation; no installation performed'}
  $saved=Join-Path $backup $plan.Path;New-Item -ItemType Directory -Force ([IO.Path]::GetDirectoryName($saved))|Out-Null
  Copy-Item -LiteralPath $target -Destination $saved
  if((Get-FileHash -LiteralPath $saved).Hash -ne $plan.BeforeHash){throw 'Backup hash mismatch'}
 }
}
$journal=[pscustomobject]@{version=$manifest.version;game=$game;files=$changes;preserved=@($plans|Where-Object Action -like 'Preserve*')}
$journal|ConvertTo-Json -Depth 8|Set-Content -LiteralPath (Join-Path $backup 'restore-records.json') -Encoding utf8
foreach($plan in $changes|Where-Object Action -ne 'Retire duplicate part'){
 if(Get-Process -Name Sprocket -ErrorAction SilentlyContinue){throw "Sprocket started; stopped. Backup: $backup"}
 $target=Resolve-Target $plan.Path
 if(!$plan.Existed -and (Test-Path -LiteralPath $target)){throw 'New target appeared; stopped to preserve it'}
 if($plan.Existed -and (Get-FileHash -LiteralPath $target).Hash -ne $plan.BeforeHash){throw 'Target changed after backup; stopped to preserve it'}
 $source=Join-Path $PSScriptRoot ('Payload/'+$plan.Path)
 New-Item -ItemType Directory -Force ([IO.Path]::GetDirectoryName($target))|Out-Null
 Copy-Item -LiteralPath $source -Destination $target -Force
 if((Get-FileHash -LiteralPath $source).Hash -ne (Get-FileHash -LiteralPath $target).Hash){throw 'Installed hash mismatch'}
}
foreach($plan in $changes|Where-Object Action -eq 'Retire duplicate part'){
 if(Get-Process -Name Sprocket -ErrorAction SilentlyContinue){throw 'Sprocket started; stopped before retirement'}
 $target=Resolve-Target $plan.Path
 if((Get-FileHash -LiteralPath $target).Hash -ne $plan.BeforeHash){throw 'Obsolete part changed; stopped'}
 Remove-Item -LiteralPath $target
}
foreach($plan in $plans|Where-Object {$_.Action -like 'Preserve*' -and $_.Existed}){if((Get-FileHash -LiteralPath (Resolve-Target $plan.Path)).Hash -ne $plan.BeforeHash){throw 'Preserved file changed'}}
"Installed $($manifest.version). Backups: $backup"
