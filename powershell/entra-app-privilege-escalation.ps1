# Fill in these variables
$ApplicationId = ""
$SecuredPassword = ""
$tenantID = ""

$SecuredPasswordPassword = ConvertTo-SecureString `
-String $SecuredPassword -AsPlainText -Force

$ClientSecretCredential = New-Object `
-TypeName System.Management.Automation.PSCredential `
-ArgumentList $ApplicationId, $SecuredPasswordPassword

Connect-MgGraph -TenantId $tenantID -ClientSecretCredential $ClientSecretCredential

# Define the Service Principal by display name
$servicePrincipalName = "Your-Service-Principal-Name"
$sp = Get-MgServicePrincipal -Filter "displayName eq '$servicePrincipalName'"

# List of Role IDs to assign (add your specific Role IDs here)
$roleIds = @(
    "b1d84b22-86f3-4cf0-9a9f-2291f14bc5d3",  # Example Role ID 1
    "e1fbf100-d49d-4c8f-b4e9-e9cdef1c3ab0",  # Example Role ID 2 (Global Administrator)
    "d063a1ed-5a5a-487a-80bb-bf5e61a0c2a2"   # Example Role ID 3
)

# Loop through each Role ID and assign it to the service principal
foreach ($roleId in $roleIds) {
    try {
        # Get the Directory Role for the current Role ID
        $role = Get-MgDirectoryRole -Filter "Id eq '$roleId'"
        
        # If the role is not found, try enabling it (only if it's not enabled yet)
        if (-not $role) {
            Write-Host "Role with ID $roleId is not enabled. Enabling it now..."
            $role = Enable-MgDirectoryRole -Id $roleId
        }

        # Add the service principal to the role
        New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $sp.Id -BodyParameter $params

        Write-Host "Successfully assigned role $($role.DisplayName) to service principal $($sp.DisplayName)"
    }
    catch {
        Write-Host "Error assigning role with ID $roleId to service principal: $_"
    }
}

Write-Host "Role assignment process completed."
# Assign permission
$params = @{
  "PrincipalId" =""
  "ResourceId" = ""
  "AppRoleId" = ""
}

New-MgServicePrincipalAppRoleAssignment -ServicePrincipalId $principalId -BodyParameter $params | 
  Format-List Id, AppRoleId, CreatedDateTime, PrincipalDisplayName, PrincipalId, PrincipalType, ResourceDisplayName
