param([string]$GameDir='C:/Program Files (x86)/Steam/steamapps/common/Sprocket',[switch]$SkipGame)
$ErrorActionPreference='Stop'
$root=$PSScriptRoot;$payload=Join-Path $root 'Payload'
$manifest=Get-Content -LiteralPath (Join-Path $root 'manifest.json') -Raw|ConvertFrom-Json
$prefix=[IO.Path]::GetFullPath($payload).TrimEnd('\','/')+[IO.Path]::DirectorySeparatorChar
$seen=@{}
foreach($entry in $manifest.files){
 $path=[IO.Path]::GetFullPath((Join-Path $payload $entry.path))
 if(!$path.StartsWith($prefix,[StringComparison]::OrdinalIgnoreCase)){throw 'Path outside payload'}
 $key=$entry.path.ToLowerInvariant();if($seen.ContainsKey($key)){throw 'Duplicate payload path'};$seen[$key]=$entry
 if(!(Test-Path -LiteralPath $path -PathType Leaf)){throw "Missing payload: $($entry.path)"}
 if((Get-FileHash -LiteralPath $path).Hash -ne $entry.sha256){throw "Hash mismatch: $($entry.path)"}
}
foreach($file in Get-ChildItem -LiteralPath $payload -Recurse -File){$relative=$file.FullName.Substring($prefix.Length).Replace('\','/');if(!$seen.ContainsKey($relative.ToLowerInvariant())){throw "Unexpected payload: $relative"}}
$guids=@{}
foreach($module in $manifest.modules){
 if($guids.ContainsKey($module.guid)){throw 'Duplicate module identity'};$guids[$module.guid]=$true
 if(!$seen.ContainsKey($module.file.ToLowerInvariant()) -or $seen[$module.file.ToLowerInvariant()].sha256 -ne $module.sha256){throw "Module manifest mismatch: $($module.name)"}
}
if(!$SkipGame){
 if(!(Test-Path -LiteralPath (Join-Path $GameDir 'Sprocket.exe'))){throw 'GameDir is not Sprocket'}
 if((Get-FileHash -LiteralPath (Join-Path $GameDir 'GameAssembly.dll')).Hash -ne $manifest.gameAssemblySha256){throw 'This package requires Sprocket 0.2.55.5 with the supported GameAssembly'}
}
"PASS: $($manifest.files.Count) payload files; $($manifest.modules.Count) modules."
