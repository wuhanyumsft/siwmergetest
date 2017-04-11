Param(
  [string]$DhsConnectionConfigs,
  [string]$DepotToMerge,
  [string]$TargetDepot,
  [string]$Domain,
  [string]$BaseUrl,
  [string]$BaseFolder
)

Add-type -AssemblyName "System.IO.Compression.FileSystem"
$mergeDepotToolContainerUrl = "https://siwtest.blob.core.windows.net/mergedepot"

if(!(Test-Path ".optemp"))
{
    New-Item ".optemp" -ItemType Directory
}

$currentFolder = Get-Location
$MergeDepotToolSource = "$mergeDepotToolContainerUrl/MergeDepotTool_v2.zip"
$MergeDepotToolDestination = "$currentFolder\.optemp\MergeDepotTool.zip"

echo 'Start Download!'
Invoke-WebRequest -Uri $MergeDepotToolSource -OutFile $MergeDepotToolDestination
echo 'Download Success!'

$MergeDepotToolUnzipFolder = "$currentFolder\.optemp\MergeDepotTool"
if((Test-Path "$MergeDepotToolUnzipFolder"))
{
    Remove-Item $MergeDepotToolUnzipFolder -Force -Recurse
}

[System.IO.Compression.ZipFile]::ExtractToDirectory($MergeDepotToolDestination, $MergeDepotToolUnzipFolder)
echo 'Extract Success!' 
$MergeDepotTool = "$MergeDepotToolUnzipFolder\MergeDepot.exe"

echo "Start to call merge depot tool"
&"$MergeDepotTool" "$currentFolder\mergedepot" "-c" "$DhsConnectionConfigs" "-m" "$DepotToMerge" "-u" "$BaseUrl" "-f" "$BaseFolder" "-d" "$Domain" "-t" "$TargetDepot"
echo "Finish calling merge depot tool"