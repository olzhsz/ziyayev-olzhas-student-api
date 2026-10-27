param([string]$BaseUrl = 'http://localhost:8080/api/ziyayev-olzhas')
$ErrorActionPreference = 'Stop'
$taskProject = Split-Path -Parent $PSScriptRoot
New-Item -ItemType Directory -Force (Join-Path $taskProject 'evidence') | Out-Null
Start-Transcript -Path (Join-Path $taskProject 'evidence/Ziyayev_Olzhas_api_powershell.txt') -Force
try {
    Write-Host "API verification: Ziyayev Olzhas | IT2-2302 | $BaseUrl"
    $taskReady = $false
    for ($taskAttempt = 0; $taskAttempt -lt 90; $taskAttempt++) {
        try {
            $taskInfo = Invoke-RestMethod -Uri $BaseUrl -TimeoutSec 3
            $taskReady = $true
            break
        } catch { Start-Sleep -Seconds 2 }
    }
    if (-not $taskReady) { throw 'Application did not become ready.' }
    $taskInfo | ConvertTo-Json

    function Invoke-ApiCheck {
        param([string]$Method, [string]$Path, [int]$Expected, [object]$Body = $null)
        $taskArgs = @{ Uri = "$BaseUrl$Path"; Method = $Method; UseBasicParsing = $true; TimeoutSec = 20 }
        if ($null -ne $Body) { $taskArgs.ContentType = 'application/json'; $taskArgs.Body = ($Body | ConvertTo-Json -Compress) }
        try {
            $taskResponse = Invoke-WebRequest @taskArgs
            $taskStatus = [int]$taskResponse.StatusCode
            $taskContent = $taskResponse.Content
        } catch {
            if ($null -eq $_.Exception.Response) { throw }
            $taskStatus = [int]$_.Exception.Response.StatusCode
            $taskContent = $_.ErrorDetails.Message
        }
        Write-Host "$Method $Path -> HTTP $taskStatus (expected $Expected)"
        Write-Host $taskContent
        if ($taskStatus -ne $Expected) { throw "Unexpected status: $taskStatus" }
        if ($taskContent -and $Expected -lt 400) { return $taskContent | ConvertFrom-Json }
    }

    $taskBody = @{fullName='Ziyayev Olzhas'; groupName='IT2-2302'; email='olzhas@example.com'}
    $taskStudent = Invoke-ApiCheck POST '/students' 201 $taskBody
    if (-not $taskStudent.id) { throw 'Missing student ID.' }
    Invoke-ApiCheck GET '/students' 200 | Out-Null
    Invoke-ApiCheck GET "/students/$($taskStudent.id)" 200 | Out-Null
    $taskBody.fullName = 'Ziyayev Olzhas Updated'
    $taskBody.email = 'updated@example.com'
    $taskUpdated = Invoke-ApiCheck PUT "/students/$($taskStudent.id)" 200 $taskBody
    if ($taskUpdated.fullName -ne 'Ziyayev Olzhas Updated') { throw 'Update response did not contain expected name.' }
    Invoke-ApiCheck POST '/students' 400 @{fullName=''; groupName=''; email='bad'} | Out-Null
    Invoke-ApiCheck DELETE "/students/$($taskStudent.id)" 204 | Out-Null
    Invoke-ApiCheck GET "/students/$($taskStudent.id)" 404 | Out-Null
    Invoke-ApiCheck PUT "/students/$($taskStudent.id)" 404 $taskBody | Out-Null
    Invoke-ApiCheck DELETE "/students/$($taskStudent.id)" 404 | Out-Null
    Write-Host 'All API checks passed.'
} finally {
    Stop-Transcript | Out-Null
}
