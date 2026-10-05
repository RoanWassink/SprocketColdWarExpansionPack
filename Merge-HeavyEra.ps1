param([string]$GameDir='C:/Program Files (x86)/Steam/steamapps/common/Sprocket',[switch]$Apply)
$ErrorActionPreference='Stop'
if(Get-Process Sprocket -ErrorAction SilentlyContinue){throw 'Close Sprocket first.'}
$manifest=Get-Content (Join-Path $PSScriptRoot 'manifest.json') -Raw | ConvertFrom-Json
foreach($guid in @('nl.roan.sprocket.materialselector','nl.roan.sprocket.shellselector')){
 $module=$manifest.modules | Where-Object guid -eq $guid
 if((Get-FileHash -LiteralPath (Join-Path $GameDir $module.file)).Hash -ne $module.sha256){throw "Install exact paired DLLs first: $guid"}
}
$target=Join-Path $GameDir 'BepInEx/config/sprocket.armour.responses.json'
$raw=Get-Content -LiteralPath $target -Raw
$catalog=$raw | ConvertFrom-Json
$entry=Get-Content (Join-Path $PSScriptRoot 'ModuleHandoffs/HEAVY-ERA-ADDITIVE-ENTRY.json') -Raw | ConvertFrom-Json
$existing=@($catalog.responses | Where-Object responseId -eq $entry.responseId)
if($existing.Count){if($existing.Count -eq 1 -and ($existing[0] | ConvertTo-Json -Depth 60 -Compress) -eq ($entry | ConvertTo-Json -Depth 60 -Compress)){'Heavy ERA already matches; no changes.';return};throw 'Heavy ERA entry exists with custom/conflicting settings; review manually, do not overwrite.'}
$catalog.responses=@($catalog.responses)+$entry
if(!$Apply){'PLAN: append one heavy ERA entry; preserve enabled, caps, existing recipes and other root settings.';return}
$backup=Join-Path ([Environment]::GetFolderPath('MyDocuments')) ('Codex/SprocketColdWarBackups/heavy-era-config-'+(Get-Date -Format 'yyyyMMdd-HHmmss-fff'))
New-Item -ItemType Directory -Path $backup | Out-Null
Copy-Item -LiteralPath $target -Destination (Join-Path $backup 'sprocket.armour.responses.json')
if((Get-FileHash $target).Hash -ne (Get-FileHash (Join-Path $backup 'sprocket.armour.responses.json')).Hash){throw 'Backup mismatch'}
if(Get-Process Sprocket -ErrorAction SilentlyContinue){throw 'Game started; no config write'}
$catalog | ConvertTo-Json -Depth 60 | Set-Content -LiteralPath $target -Encoding utf8
"Appended heavy ERA only. Backup: $backup. Restart game to load both consumers."
