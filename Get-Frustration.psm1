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

     License:
        Copyright (c) 2013, Christopher Terry ( tuba.terry@gmail.com )
        All rights reserved.

        Redistribution and use in source and binary forms, with or without
        modification, are permitted provided that the following conditions are met: 

        1. Redistributions of source code must retain the above copyright notice, this
           list of conditions and the following disclaimer. 
        2. Redistributions in binary form must reproduce the above copyright notice,
           this list of conditions and the following disclaimer in the documentation
           and/or other materials provided with the distribution. 

        THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
        ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
        WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
        DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
        ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
        (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
        LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
        ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
        (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
        SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

        The views and conclusions contained in the software and documentation are those
        of the authors and should not be interpreted as representing official policies, 
        either expressed or implied, of the FreeBSD Project.
    .INPUTS
     Rage, Anger, Frustration, any other emotions implied by invocation of this function.
    .OUTPUTS
     Catharsis, sometimes giggling.
    .LINK
     https://foaas.herokuapp.com/
     http://pastebin.com/kSy7WmjN
     https://github.com/tubaterry/Miscellaneous/blob/master/Get-Frustration.psm1
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