function Initialize-Cluster
{
    [CmdletBinding()]
    Param
    (
        [ValidateSet('westeurope')]
        [string] $Location
    )

    $webTemplateFile = Join-Path $PSScriptRoot -ChildPath ".Template\cluster.json"
    $rgName = "my-cluster"

    if($null -eq (Get-AzResourceGroup $rgName -ErrorAction SilentlyContinue)) {
        New-AzResourceGroup $rgName -Location $Location
    }

    if($TestOnly.IsPresent) {
        $TestResult = Test-AzResourceGroupDeployment -Mode Incremental `
                                                     -ResourceGroupName $rgName `
                                                     -TemplateFile $webTemplateFile `
                                                     -ErrorAction Stop `
                                                     -Verbose

        if ($TestResult) {
            $TestResult
            throw "The deployment for the cluster did not pass validation."
        }
    }
    else {
        New-AzResourceGroupDeployment -Mode Incremental `
                                      -ResourceGroupName $rgName `
                                      -TemplateFile $webTemplateFile `
                                      -Verbose
    }    
}