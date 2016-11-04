![Build status](https://ci.appveyor.com/api/projects/status/go5gb3hsm8asca5r?svg=true&branch=master)
# DFSConfig

A demo DSC configuration for managing DFS with the XDFS resource. 

## Demo

1. clone "copy" down our DFS configuration from source control
2. create a new branch "another copy" of our DFS configuration
3. make our changes to our new branch
4. push our branch back up to source control 
5. lets our tests run against our new branch
6. if "passing" manually merge our new branch with our master branch
7. initiate a pull from our DSC pull server to source control to get our latest and "passing" configuration
8. initial an Update-DSCConfiguration on our DFS server
9. be patient

## xDFS resource

Create a domain-based DFS root
```powershell
xDFSNamespaceRoot DFSNamespaceRoot_Domain_Files_01
{
	DependsOn            = @('[xSMBShare]DFSRootShare','[WindowsFeature]DFSFileServices','[xDFSNamespaceServerConfiguration	DFSNamespaceConfig')
	Path                 = '\\ad.piccola.us\Files'
	TargetPath           = '\\dfs01.ad.piccola.us\Files'
	Ensure               = 'present'
	Type                 = 'DomainV2'
	PsDscRunAsCredential = $Credential
}
```

Create a namespace folder with a target
```powershell
xDFSNamespaceFolder DFSNamespaceFolder_docs
{
	Path                 = '\\ad.piccola.us\files\stuff\docs' 
	TargetPath           = '\\box.ad.piccola.us\docs'
	Ensure               = 'present'
	PsDscRunAsCredential = $Credential
	DependsOn            = @('[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Files_01','[xDFSNamespaceRoot]DFSNamespaceRoot_Domain_Files_02')
}
```

## Notes

This is a demo. This demo does not follow best practices and does not create a real CI pipeline. This is a demo.