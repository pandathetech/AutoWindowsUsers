# Auto User Creation Script for Windows
This PowerShell script automates the creation of local user accounts on a Windows machine by importing user data from a CSV file.

## Prerequisites
- You must have **Administrator privileges** on your Windows machine.
- Make sure that the following two files are downloaded and extracted from the ZIP archive :
  - `generate_windowsusers` (the PowerShell script)
  - `employee_list.csv` (the CSV file with user data)

Both files must be placed in the **same directory** before running the script.

## Instructions

### 1. Open PowerShell as Admin
Before running the script, open **Windows PowerShell** as an administrator.

### 2. Set Execution Policy
To allow PowerShell scripts to run, update the execution policy with the following command.

```powershell
set-executionpolicy unrestricted
```

> When prompted, type `Y` (for Yes) to confirm the change.

### 3. Navigate to the Script Directory
Use the `cd` command to navigate to the folder where you extracted the script and CSV file. For example:

```powershell
cd C:\Users\YourName\Downloads
```

Replace `YourName` with your actual username or folder name.

### 4. Run the Script
Run the script by executing the following command:

```powershell
.\generate_windowsusers.ps1 .\employee_list.csv
```

> If you see a security warning, enter `Y` to proceed and run the script.

### 5. Verify User Creation
To check that the users were created, follow these steps.

- Right-click the Windows icon in the bottom-left corner.
- Click `Computer Management`.
- In the left panel, navigate to `Local Users and Groups` -> `Users`.

You should see the new users listed in the right panel.

### 6. Re-running the Script (Optional)
This script is designed to be run once to create the user accounts. However, if you delete the users later, you can re-run the script to recreate them. Ensure the CSV file remains unchanged or is updated as needed.
