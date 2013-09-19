function Get-Frustration([string]$Giver,[string]$Target){
    <#
    .SYNOPSIS 
      Vents frustration at errors, the computer you're working on, or a specified object
    .DESCRIPTION
     Get-Frustration is a cheesy way to vent anger, using the FOASS API.  ( https://foaas.herokuapp.com/ )
     See 'get-help Get-Frustration -full' for error handling information.
    .PARAMETER Giver
     Giver of zero or more fucks.  (Number of fucks given not specified.)
     If used, must be used in conjunction with a Target.
    .PARAMETER Target
     The Target of Giver's ire.
     If used, must be used in conjunction with a Giver.
    .EXAMPLE
     Get-Frustration 
     If there are any errors in the $Error array, the system this command was invoked on will curse at the latest error.
     Otherwise, current user will curse at the current host.
    .EXAMPLE
     Get-Frustration -Target $env:COMPUTERNAME -Giver $MyInvocation
     This will have the current powershell script curse at your computer.
    .NOTES
     Error handling is simply cursing at the current user.  They can figure it out.
    .INPUTS
     Rage, Anger, Frustration, any other emotions implied by invocation of this function.
    .OUTPUTS
     Catharsis, sometimes giggling.
    .LINK
     https://foaas.herokuapp.com/
     http://pastebin.com/kSy7WmjN
    #>
    $TypeChoices="shakespeare,king,linus,donut,chainsaw,you,off"  #Methods taking 2 parameters
    $Type=($TypeChoices.Split(",") | Get-Random)

    If((!$Target -and $Giver) -or ($Target -and !$Giver))
    {
        $Target=$env:USERNAME
        $Giver="Powershell, in response to a bad invocation of Get-Frustration"
    }
    ElseIf(!$Target -or !$Giver){
        If($Error.Count -gt 0){ 
            $Target=$Error[-1].FullyQualifiedErrorId 
            $Giver=$env:COMPUTERNAME
        }
        Else{ 
            $Target=$env:COMPUTERNAME
            $Giver=$env:USERNAME
        }
    }
    
    Write-Output (Invoke-WebRequest https://foaas.herokuapp.com/$Type/$Target/$Giver).Content
}