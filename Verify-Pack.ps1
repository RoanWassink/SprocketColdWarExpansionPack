param([string]$GameDir='C:\Program Files (x86)\Steam\steamapps\common\Sprocket',[switch]$SkipGame)
$ErrorActionPreference='Stop'
$root=(Resolve-Path -LiteralPath $PSScriptRoot).Path
$payload=Join-Path $root 'Payload'
$manifest=Get-Content -LiteralPath (Join-Path $root 'manifest.json') -Raw | ConvertFrom-Json
$prefix=[IO.Path]::GetFullPath($payload).TrimEnd('\','/')+[IO.Path]::DirectorySeparatorChar
$seen=@{}
foreach($entry in $manifest.files){
 $path=[IO.Path]::GetFullPath((Join-Path $payload $entry.path))
 if(!$path.StartsWith($prefix,[StringComparison]::OrdinalIgnoreCase)){throw "Path outside payload: $($entry.path)"}
 if($seen.ContainsKey($entry.path.ToLowerInvariant())){throw "Duplicate file: $($entry.path)"};$seen[$entry.path.ToLowerInvariant()]=$true
 if(!(Test-Path -LiteralPath $path -PathType Leaf)){throw "Missing payload file: $($entry.path)"}
 if((Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash -ne $entry.sha256){throw "Payload hash mismatch: $($entry.path)"}
}
foreach($file in Get-ChildItem -LiteralPath $payload -Recurse -File){$relative=$file.FullName.Substring($prefix.Length).Replace('\','/');if(!$seen.ContainsKey($relative.ToLowerInvariant())){throw "Unexpected payload file: $relative"}}
if(!$SkipGame){
 if(!(Test-Path -LiteralPath (Join-Path $GameDir 'Sprocket.exe'))){throw 'GameDir is not a Sprocket installation.'}
 if((Get-FileHash -LiteralPath (Join-Path $GameDir 'GameAssembly.dll') -Algorithm SHA256).Hash -ne $manifest.gameAssemblySha256){throw 'Unsupported GameAssembly: this pack targets the inspected Sprocket build. Do not bypass this check.'}
}
"PASS: $($manifest.files.Count) payload hashes; $($manifest.modules.Count) module records. Native gameplay has not been tested."
