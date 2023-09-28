<#
.SYNOPSIS
    Execute a SQL query and export the results to an Excel file.
.DESCRIPTION
    This script connects to a SQL Server, executes a query, and exports the results to an Excel file.
.PARAMETER serverName
    The name or IP address of the SQL Server.
.PARAMETER databaseName
    The name of the database to connect to.
.PARAMETER authUsername
    The SQL Server authentication username.
.PARAMETER authPassword
    The SQL Server authentication password.
.PARAMETER query
    The SQL query to execute.
.PARAMETER outputFile
    The path where the Excel file will be saved.
.EXAMPLE
    .\RemoteQuerySQLtoExcel.ps1 -serverName "YourServerName" -databaseName "YourDatabaseName" -authUsername "YourUsername" -authPassword "YourPassword" -query "SELECT * FROM YourTable" -outputFile "C:\Path\To\OutputFile.xlsx"
    This example executes a SQL query and exports the results to an Excel file.
#>

param (
    [string]$serverName,
    [string]$databaseName,
    [string]$authUsername,
    [string]$authPassword,
    [string]$query,
    [string]$outputFile
)


[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12


if (-not (Get-Module -ListAvailable -Name SQLServer)) {
    Install-Module -Name SQLServer -Scope CurrentUser -Force
}

if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
    Install-Module -Name ImportExcel -Scope CurrentUser -Force
}


$sqlResult = Invoke-Sqlcmd -ServerInstance $serverName -Database $databaseName -Username $authUsername -Password $authPassword -Query $query -TrustServerCertificate
$sqlResult | Select-Object * -ExcludeProperty RowError, RowState, Table, ItemArray, HasErrors | Export-Excel -Path $outputFile -AutoSize

Write-Host "Data exported to $outputFile"


