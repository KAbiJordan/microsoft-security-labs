# New-BluepineUsers.ps1
# Lab 1.2 - Bulk-create Bluepine Outfitters users from a CSV file
# Part of the SC-300 Bluepine identity build (Showcase 01 - Identity Foundation)
#
# Requires:
#   - Microsoft.Graph.Users module (Install-Module Microsoft.Graph.Users)
#   - Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All"
#
# CSV columns (newusers.csv - never upload the CSV, it contains a starter password):
#   DisplayName, UserPrincipalName, MailNickname, Department, JobTitle, UsageLocation, Password
#
# What it does:
#   Reads each row of the CSV and creates the user with New-MgUser.
#   Department is set at creation, so the SG-All-Staff dynamic rule picks
#   each new user up automatically. UsageLocation is set at creation so
#   licence assignment cannot fail later. Every new user must change the
#   starter password at first sign-in.

$users = Import-Csv ./newusers.csv

foreach ($u in $users) {
    New-MgUser -DisplayName $u.DisplayName `
        -UserPrincipalName $u.UserPrincipalName `
        -MailNickname $u.MailNickname `
        -Department $u.Department `
        -JobTitle $u.JobTitle `
        -UsageLocation $u.UsageLocation `
        -AccountEnabled `
        -PasswordProfile @{
            Password = $u.Password
            ForceChangePasswordNextSignIn = $true
        }
}
