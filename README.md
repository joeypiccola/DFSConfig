![Build status](https://ci.appveyor.com/api/projects/status/go5gb3hsm8asca5r?svg=true&branch=master)
# DFSConfig

A demo DSC configuration for managing DFS. It leverages the xDFS DSC resource. 

## The Demo

In the demo we'll create a branch of our DFSConfig repository named ChangeControl. Then we'll make an adjustment to our ChangeControl repository. We'll then wait for AppVeyor to run our health checks against changes. When our changes pass we'll manually merge them into our master branch. At that time we'll pull our master branch down to your pull server and publish the config.

## How it works

Build a configuraiton using the following xDFS resources. 

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

With our domain-based DFS root create a namespace folder with a target
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