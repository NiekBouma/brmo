# See: http://www.appveyor.com/docs/services-databases#sql2012
# Set the $instanceName value below to the name of the instance you
# want to configure a static port for. This could conceivably be
# passed into the script as a parameter.
$instanceName = 'SQL2012SP1'
$computerName = $env:COMPUTERNAME
$smo = 'Microsoft.SqlServer.Management.Smo.'
$wmi = New-Object ($smo + 'Wmi.ManagedComputer')

# For the named instance, on the current computer, for the TCP protocol,
# loop through all the IPs and configure them to use the standard port of 1433.
$uri = "ManagedComputer[@Name='$computerName']/ ServerInstance[@Name='$instanceName']/ServerProtocol[@Name='Tcp']"
$Tcp = $wmi.GetSmoObject($uri)
foreach ($ipAddress in $Tcp.IPAddresses)
{
    $ipAddress.IPAddressProperties["TcpDynamicPorts"].Value = ""
    $ipAddress.IPAddressProperties["TcpPort"].Value = "1433"
}
$Tcp.Alter()

# Restart the named instance of SQL Server to enable the changes.
# The restart is performed in the calling batch file.
