Param(
	[parameter(Mandatory=$true, ValueFromPipelineByPropertyName)]
	[string]
	$thumprint,
	[parameter(Mandatory=$true, ValueFromPipelineByPropertyName)]
	[ValidateScript({[System.Guid]::TryParse($_,$([ref][guid]::Empty))})]
	[string]
	$appid
)

if (-not($thumprint)) { Throw "Missing thumprint. This can be obtained by running: certmgr.msc > [Store] > [Open Certificate] > Details Tab > Thumprint" }
if (-not($appid)) { Throw "Missing appid. This can be obtained by running: netsh http show sslcert" }

$cert = Get-ChildItem -Path "cert:\$($thumprint)" -Recurse | Select-Object -First 1
if (-not($cert)) { Throw "Certificate not found." }

$appid = "{$($appid.TrimStart("{"," ").TrimEnd("}"," "))}"

For ($i=44300; $i -le 44399; $i++) {
	netsh http delete sslcert ipport=0.0.0.0:$i 2>&1 | out-null
}

For ($i=44300; $i -le 44399; $i++) {
	netsh http add sslcert ipport=0.0.0.0:$i certhash=$thumprint appid=$appid
	if ($LASTEXITCODE -ne 0) { Throw "Could not assign the new SSL certificate $thumprint to the app $appid" }
}

$StoreScope = 'LocalMachine'
$StoreName = 'root'

$Store = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Store -ArgumentList $StoreName, $StoreScope
$Store.Open([System.Security.Cryptography.X509Certificates.OpenFlags]::ReadWrite)
$Store.Add($cert)
$Store.Close()
