param([Parameter(Mandatory)][string]$GameDir)
$ErrorActionPreference='Stop'
# Read-only preflight. The pack installer backs up, writes and restores these plans.
$plans=@()
foreach($name in @('sprocket.armour.responses.json','sprocket.era.bindings.json')){
 $relative='BepInEx/config/'+$name
 $target=Join-Path $GameDir $relative
 $defaults=Get-Content -LiteralPath (Join-Path $PSScriptRoot ('Payload/'+$relative)) -Raw|ConvertFrom-Json
 if(!(Test-Path -LiteralPath $target)){continue}
 $before=(Get-FileHash -LiteralPath $target).Hash
 $existing=Get-Content -LiteralPath $target -Raw|ConvertFrom-Json
 if($existing.schemaVersion -ne 1){throw "Unsupported schema in $name; existing files preserved."}
 $changed=$false
 if($name -eq 'sprocket.armour.responses.json'){
  if($existing.responses -isnot [Array]){throw 'Response catalogue must contain an array.'}
  $seen=@{}
  foreach($r in $existing.responses){if(!$r.responseId -or $seen.ContainsKey([string]$r.responseId)){throw 'Invalid or duplicate response ID.'};$seen[[string]$r.responseId]=$true}
  foreach($r in $defaults.responses){if(!$seen.ContainsKey([string]$r.responseId)){$existing.responses=@($existing.responses)+@($r);$seen[[string]$r.responseId]=$true;$changed=$true}}
 }else{
  if($existing.matchMode -ne 'componentId' -or $existing.bindings -isnot [Array]){throw 'Unsupported ERA binding format.'}
  $roles=@{}
  foreach($b in $existing.bindings){foreach($role in @($b.cassetteComponentId,$b.mountComponentId)){if(!$role -or $roles.ContainsKey([string]$role)){throw 'Invalid or duplicate ERA role.'};$roles[[string]$role]=$b}}
  foreach($b in $defaults.bindings){
   $found=@(@($b.cassetteComponentId,$b.mountComponentId)|Where-Object {$roles.ContainsKey([string]$_)})
   if($found.Count){
    if($found.Count -ne 2){throw 'Partial ERA binding conflict; existing files preserved.'}
    foreach($role in $found){$old=$roles[[string]$role];foreach($field in @('cassetteComponentId','mountComponentId','materialId','responseId','kind')){if($old.$field -cne $b.$field){throw "Conflicting ERA binding $role; existing files preserved."}}}
   }else{$existing.bindings=@($existing.bindings)+@($b);$roles[[string]$b.cassetteComponentId]=$b;$roles[[string]$b.mountComponentId]=$b;$changed=$true}
  }
 }
 if($changed){$plans+=@([pscustomobject]@{Path=$relative;Action='Merge missing catalogue entries';Existed=$true;BeforeHash=$before;Updated=($existing|ConvertTo-Json -Depth 100)})}
}
return $plans
