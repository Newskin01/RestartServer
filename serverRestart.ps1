$CurrentTime = Get-Date -UFormat "%R"
$Times = @("12:00", "18:00", "00:00", "06:00")
$servers = @("public", "private")
$aff = @(196, 56)  
$global:loop = 1
$global:ScriptStart = 0

function checkServers 
{
    while($loop -eq 1) 
	{
	$CurrentTime = updateTime
    if ($CurrentTime -eq $Times[0] -or $CurrentTime -eq $Times[1] -or $CurrentTime -eq $Times[2] -or $CurrentTime -eq $Times[3]) 
	{
		stopServers; startServers; Start-Sleep -s 60; checkServers;
	} else {
		Start-Sleep -s 55; checkServers;
	}
	}
}

function stopServers 
{
		Stop-Process $global:pids
		foreach ($s in $servers) { 
			Write-Output "$s has been stopped"  
		}
}

function startServers {
	$i = 0
	$global:pids = @( )
	
	foreach($s in $servers)
	{
		$a = $aff[$i]
		$Starter = Start-Process -FilePath $s -WindowStyle Minimized -PassThru  
		$Process = Get-Process -Id $Starter.ID
		$global:pids += $Process.ID
		$Process.ProcessorAffinity = $a
		$CurrentTime = updateTime
		Write-Output "Starting $s at $CurrentTime"
		$i = $i + 1
		Start-Sleep -s 10
	}
	return
}

function updateTime
{
	$time = Get-Date -UFormat "%R"
	if ( $CurrentTime -ne $time) {
		$CurrentTime = $time
		return $CurrentTime
	} else {
		$CurrentTime = $CurrentTime
		return $CurrentTime
	}
return
}

Write-Output "Starting RestartServer Script at $CurrentTime"
if ( $global:ScriptStart -eq 0) { 
startServers 
$global:ScriptStart = 1
}
checkServers
