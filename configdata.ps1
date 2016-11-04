$configdata = @{
    AllNodes = @(
        @{
            Nodename        = 'localhost'
            CertificateFile = $configurationCertPath
            Thumbprint      = (Get-PfxCertificate -FilePath $configurationCertPath).Thumbprint
        }
    )
}