Configuration DFSConfig
{
    param
    (
        [Parameter(Mandatory)]
        [System.Management.Automation.PSCredential]
        [System.Management.Automation.CredentialAttribute()]
        $Credential
    )
        
    Import-DscResource -ModuleName xPSDesiredStateConfiguration,PSDesiredStateConfiguration,xsmbshare,xDFS

    Node localhost
    {
        WindowsFeature DFSFileServices
        {
            Name   = 'FS-DFS-Namespace'
            Ensure = 'Present'
        } 

        WindowsFeature RSATDFSMgmtConInstall
        {
            Ensure = 'Present'
            Name   = 'RSAT-DFS-Mgmt-Con'
        }

        File DFSRootDirectory 
        {
            Ensure          = 'Present'
            DestinationPath = 'c:\dfsroots\Files'
            Type            = 'Directory'
        }

        File DFSRootDirectoryOffices
        {
            Ensure          = 'Present'
            DestinationPath = 'c:\dfsroots\Offices'
            Type            = 'Directory'
        }

        xSMBShare DFSRootShare
        {
            DependsOn  = '[File]DFSRootDirectory'
            Name       = 'Files'
            FullAccess = 'ad\domain admins'
            ReadAccess = 'Everyone'
            Path       = 'C:\DFSRoots\Files'
            Ensure     = 'Present'
        }

        xSMBShare DFSRootShareOffices
        {
            DependsOn  = '[File]DFSRootDirectoryOffices'
            Name       = 'Offices'
            FullAccess = 'ad\domain admins'
            ReadAccess = 'Everyone'
            Path       = 'C:\DFSRoots\Offices'
            Ensure     = 'Present'
        }        

        File stuff
        {
            DestinationPath = 'c:\dfsroots\files\stuff'
            Ensure          = 'Present'
            Type            = 'Directory'
            DependsOn       = '[File]DFSRootDirectory'
        }

        xDFSNamespaceServerConfiguration DFSNamespaceConfig
        {
            IsSingleInstance     = 'Yes'
            UseFQDN              = $true
            PsDscRunAsCredential = $Credential
            DependsOn            = '[WindowsFeature]DFSFileServices'
        }

        xDFSNamespaceRoot DFSNamespaceRoot_Domain_Files_01
        {
            DependsOn            = @('[xSMBShare]DFSRootShare','[WindowsFeature]DFSFileServices','[xDFSNamespaceServerConfiguration]DFSNamespaceConfig')
            Path                 = '\\ad.piccola.us\Files'
            TargetPath           = '\\dfs01.ad.piccola.us\Files'
            Ensure               = 'present'
            Type                 = 'DomainV2'
            PsDscRunAsCredential = $Credential
        }

        xDFSNamespaceRoot DFSNamespaceRoot_Domain_Files_02
        {
            DependsOn            = @('[xSMBShare]DFSRootShare','[WindowsFeature]DFSFileServices','[xDFSNamespaceServerConfiguration]DFSNamespaceConfig')
            Path                 = '\\ad.piccola.us\Files'
            TargetPath           = '\\dfs02.ad.piccola.us\Files'
            Ensure               = 'present'
            Type                 = 'DomainV2'
            PsDscRunAsCredential = $Credential
        }

        xDFSNamespaceRoot DFSNamespaceRoot_Domain_Offices_01
        {
            DependsOn            = @('[xSMBShare]DFSRootShare','[WindowsFeature]DFSFileServices','[xDFSNamespaceServerConfiguration]DFSNamespaceConfig')
            Path                 = '\\ad.piccola.us\Offices'
            TargetPath           = '\\dfs01.ad.piccola.us\Offices'
            Ensure               = 'present'
            Type                 = 'DomainV2'
            PsDscRunAsCredential = $Credential
        }

        xDFSNamespaceRoot DFSNamespaceRoot_Domain_Offices_02
        {
            DependsOn            = @('[xSMBShare]DFSRootShare','[WindowsFeature]DFSFileServices','[xDFSNamespaceServerConfiguration]DFSNamespaceConfig')
            Path                 = '\\ad.piccola.us\Offices'
            TargetPath           = '\\dfs02.ad.piccola.us\Offices'
            Ensure               = 'present'
            Type                 = 'DomainV2'
            PsDscRunAsCredential = $Credential
        }
        xDFSNamespaceFolder DFSNamespaceFolder_docs
        {
            Path                 = '\\ad.piccola.us\files\stuff\docs' 
            TargetPath           = '\\box.ad.piccola.us\docs'
            Ensure               = 'present'
            PsDscRunAsCredential = $Credential
            DependsOn            = @('[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Files_01','[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Files_02')
        }
        
        xDFSNamespaceFolder DFSNamespaceFolder_dscmodules
        {
            Path                 = '\\ad.piccola.us\files\stuff\dscmodules' 
            TargetPath           = '\\box.ad.piccola.us\dscmodules'
            Ensure               = 'present'
            PsDscRunAsCredential = $Credential
            DependsOn            = @('[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Files_01','[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Files_02')
        }

        xDFSNamespaceFolder DFSNamespaceFolder_dogs
        {
            Path                 = '\\ad.piccola.us\files\stuff\dogs' 
            TargetPath           = '\\box.ad.piccola.us\dscmodules\xDFS'
            Ensure               = 'present'
            PsDscRunAsCredential = $Credential
            DependsOn            = @('[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Files_01','[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Files_02')
        }

        xDFSNamespaceFolder DFSNamespaceFolder_cats
        {
            Path                 = '\\ad.piccola.us\files\stuff\cats' 
            TargetPath           = '\\box.ad.piccola.us\dscmodules\xDFS'
            Ensure               = 'present'
            PsDscRunAsCredential = $Credential
            DependsOn            = @('[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Files_01','[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Files_02')
        }

        xDFSNamespaceFolder DFSNamespaceFolder_DAL
        {
            Path                 = '\\ad.piccola.us\offices\Dallas' 
            TargetPath           = '\\box.ad.piccola.us\docs'
            Ensure               = 'present'
            PsDscRunAsCredential = $Credential
            DependsOn            = @('[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Offices_01','[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Offices_02')
        }    
        
        xDFSNamespaceFolder DFSNamespaceFolder_DEN
        {
            Path                 = '\\ad.piccola.us\offices\Denver' 
            TargetPath           = '\\box.ad.piccola.us\docs'
            Ensure               = 'present'
            PsDscRunAsCredential = $Credential
            DependsOn            = @('[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Offices_01','[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Offices_02')
        } 
        
        xDFSNamespaceFolder DFSNamespaceFolder_BOS
        {
            Path                 = '\\ad.piccola.us\offices\Boston' 
            TargetPath           = '\\box.ad.piccola.us\docs'
            Ensure               = 'present'
            PsDscRunAsCredential = $Credential
            DependsOn            = @('[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Offices_01','[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Offices_02')
        }

        xDFSNamespaceFolder DFSNamespaceFolder_SEA
        {
            Path                 = '\\ad.piccola.us\offices\Seattle' 
            TargetPath           = '\\box.ad.piccola.us\docs'
            Ensure               = 'present'
            PsDscRunAsCredential = $Credential
            DependsOn            = @('[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Offices_01','[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Offices_02')
        } 
    }
}