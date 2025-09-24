# Author : Bryan Yu

# The name of the CSV file containing the users is the first parameter when executing the script.
$user_file = $args[0]

# This will import the CSV file and replace the original columns with the ones below.
$users = Import-CSV $user_file -Delimiter ';' -Header "FirstName", "LastName", "EmployeeNumber", "Department", "ContractEndDate", "Group"

# Loop through each user in the user file.
foreach ($user in $users) {
    
    # Initialize user information variables.
    $FirstName = $user.FirstName
    $LastName = $user.LastName
    $EmployeeNumber = $user.EmployeeNumber
    $Department = $user.Department
    $ContractEndDate = $user.ContractEndDate
    $Group = $user.Group

    # The variables below are useful for generating the temporary password.
    $word_choices = "Banana", "Moon", "Zebra"
    $symbol_choices = "!", "$", "%"

    # The username will be created by concatenating the first name
    # and the last name, then converting to lowercase.
    $username = $FirstName[0].ToString().ToLower() + $LastName.ToLower()
    $i = 1
    
    # While the user ID already exists, it will be created using
    # the first letter of the first name and the last name. If this
    # user already exists, the script will use the first two letters
    # of the first name, and so on.
    while (Get-LocalUser -Name $username -ErrorAction SilentlyContinue) {
        $username = $FirstName.Substring(0, $i).ToLower() + $LastName.ToLower()
        $i++
    }

    # The cmdlet "Get-Random" will generate the temporary password.
    $word = Get-Random $word_choices
    $symbol = Get-Random $symbol_choices
    $number = $EmployeeNumber.Substring($EmployeeNumber.Length-3)

    # This variable combines the elements randomly for the password.
    $password = $word + $symbol + $number

    # This variable converts the temporary password into a secure string.
    $secure_password = ConvertTo-SecureString -String $password -AsPlainText -Force

    # Each user will be created with a description, full name, and secure password.
    # The "Out-Null" cmdlet will suppress the output.
    New-LocalUser -Name $username -Description "The user $username has been created" -FullName "$FirstName $LastName" -Password $secure_password | Out-Null

    # If the group for the user doesn't exist, it will be created.
    if (-not (Get-LocalGroup -Name $Group -ErrorAction SilentlyContinue)) {
        New-LocalGroup -Name $Group
    }

    # The user will be added to their associated group.
    Add-LocalGroupMember -Group $Group -Member $username

    # If an expiration date is specified, it will be set for the account.
    if ($ContractEndDate) {
        Set-LocalUser -Name $username -AccountExpires (Get-Date $ContractEndDate)
    }

    # The "net user" command will force the password to be changed at
    # the next login. The "Out-Null" cmdlet will suppress the output.
    net user $username /logonpasswordchg:yes | Out-Null
}
