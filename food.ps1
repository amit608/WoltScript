$prefix = 'https://restaurant-api.wolt.com/v3/venues/slug/'
$resturantsAliasLookUp = @{
    vitrina =  @{name = 'vitrina'; url = 'vitrina'};
    nam = @{name = 'nam'; url = 'nam-king-george'};
    tal =  @{name = 'tal'; url = 'tal-bagels'};
    cafe = @{name = 'cafe'; url = 'cafe-noir'};
}

$inpt = Read-Host "you hungry beast, please enter the resturants to check (url suffix or alias e.g vitrina,tal,nam,cafe)"
$inpt = $inpt.Split(",")

$count = 0
$flag = $true
$wc = New-Object System.Net.WebClient
$sleepSeconds = 60

function Check($url)
{
    $wc.DownloadString($url) | Select-String -Pattern ',"online":false' -Quiet
}

While ($flag) {
    $count++
    Write-Host "try "$count
    foreach($i in $inpt) {
        $resturant = $i.ToString().trim()
        if ($null -eq $resturantsAliasLookUp.Item($resturant)) 
        {
            $thisName = $resturant
            $thisUrl = $resturant
        }
        else
        {
            $thisName = $resturantsAliasLookUp.Item($resturant).name
            $thisUrl = $resturantsAliasLookUp.Item($resturant).url
        }
        Write-Host "checking "($thisName)
        $result = Check("$($prefix)$($thisUrl)")
        if ($result -ne 'True') 
        {
            $flag = $false
            Write-Host ($thisName)" is open!!"
        }
        else 
        {
            Write-Host ($thisName)" is closed :("
        }
    }

    if($flag)
    {
        Start-sleep $sleepSeconds
    }
}
Write-Host "FOOD TIME!!!"
While ('True') {
    Start-sleep 2
    [system.media.systemsounds]::Asterisk.play()
}
