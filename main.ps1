$scriptVersion = "1.0.3"

Add-Type -AssemblyName PresentationFramework

# Load the XAML file as a string
$xamlString = Get-Content ".\Interface.xaml" -Raw

# Optionally remove code-behind reference if needed (if x:Class causes issues)
$xamlString = $xamlString -replace 'x:Class="[^"]+"', ''

# Parse the XAML
$reader = New-Object System.Xml.XmlTextReader([System.IO.StringReader]$xamlString)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Get the current powershell version
$psVersion = $PSVersionTable.PSVersion.ToString()

# Add a check here to ensure that the script is running on PowerShell 5.0 or later
if ($PSVersionTable.PSVersion.Major -lt 5) {
    [System.Windows.MessageBox]::Show("This script requires PowerShell 5.0 or later. You are running PowerShell $psVersion. The script may not work as expected.", "Warning", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Warning)
}

# Rename the root title of the window
$window.Title = "Dosbox Staging Replacer for GOG Galaxy v$scriptVersion - Running on PowerShell v$psVersion"

# Bind named elements to PowerShell variables
$names = Select-String -InputObject $xamlString -Pattern 'x:Name="([^"]+)"' -AllMatches |
ForEach-Object { $_.Matches.Groups[1].Value }

foreach ($name in $names) {
    Set-Variable -Name $name -Value $window.FindName($name)
}

# Get the full path to the image file (assuming it's in the same folder as the .ps1 script)
$imagePath = Join-Path -Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) -ChildPath "dosbox-replacer.png"

# Create the image source manually
$bitmap = New-Object System.Windows.Media.Imaging.BitmapImage
$bitmap.BeginInit()
$bitmap.UriSource = [Uri]$imagePath
$bitmap.CacheOption = [System.Windows.Media.Imaging.BitmapCacheOption]::OnLoad
$bitmap.EndInit()

# Assign the image to the Background Image control
$Background.Source = $bitmap

# Check if DosboxStagingReplacer.exe exists in the current directory and if it doesn't, show an error message
$exePath = Join-Path -Path (Get-Location) -ChildPath "DosboxStagingReplacer.exe"
if (-Not (Test-Path $exePath)) {
    [System.Windows.MessageBox]::Show("DosboxStagingReplacer.exe not found in the current directory. Please download that first and place it at the same directory as this script is executed. The script will now open a link where you can download the executable.", "Error", [System.Windows.MessageBoxButton]::OK, [System.Windows.MessageBoxImage]::Error)
    # Open the URL in the default web browser
    Start-Process -FilePath "https://github.com/Shin-Aska/DosboxStagingReplacerForGOGGalaxy/releases/latest"
}
else {

    # Fill in the ComboBox named $dosboxMode with the modes (Installed or Portable)
    $modes = @("Installed", "Portable")
    $dosboxMode = $window.FindName("DosboxMode")
    $dosboxMode.ItemsSource = $modes
    $dosboxMode.SelectedIndex = 0

    # Let us define DosboxVersion combobox and it's sources
    $dosboxVersion = $window.FindName("DosboxVersion")
    $sources = @("dosbox-staging", "dosbox-x", "dosbox-ece")
    $dosboxVersion.ItemsSource = $sources
    $dosboxVersion.IsEditable = $false
    $dosboxVersion.SelectedIndex = 0

    # Let us define DosboxVersionText TextBox
    $dosboxVersionText = $window.FindName("DosboxVersionText")
    # Fill in $dosboxVersionText with the path of the current directory
    $dosboxVersionText.Text = (Get-Location).Path

    # Let us define DosboxModeButton button
    $dosboxModeButton = $window.FindName("DosboxModeButton")

    # Add an event handler if $dosboxMode is changed where it it is, if the value is 
    # Installed, the sources for $dosboxVersion will be dosbox-staging, dosbox-x and dosbox-ece
    # On the other hand, if it is Portable, the sources will blank and combobox will become editable instead
    $dosboxMode.add_SelectionChanged({
            if ($dosboxMode.SelectedItem -eq "Installed") {
                $dosboxVersion.Visibility = "Visible"
                $dosboxVersionText.Visibility = "Collapsed"
                $dosboxModeButton.Visibility = "Collapsed"
            }
            else {
                $dosboxVersion.Visibility = "Collapsed"
                $dosboxVersionText.Visibility = "Visible"
                $dosboxModeButton.Visibility = "Visible"
            }
        })

    # Add an event handler if $dosboxVersionText is clicked, where it will open a file dialog 
    # to select the path of the dosbox version
    $dosboxModeButton.Add_PreviewMouseLeftButtonDown({
            $dialog = New-Object System.Windows.Forms.OpenFileDialog
            $dialog.Filter = "Executable files (*.exe)|*.exe|All files (*.*)|*.*"
            $dialog.Title = "Select the Dosbox version executable"
            if ($dialog.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
                $dosboxVersionText.Text = $dialog.FileName
            }
        })

    # We define DosOnly checkbox
    $dosOnly = $window.FindName("DosOnly")
    # We set the default value to true
    $dosOnly.IsChecked = $true

    # Then we also define GameSelection combobox
    $gameSelection = $window.FindName("GameSelection")

    # We create a function that calls DosboxStagingReplacer.exe -lg and fills in the combobox with the games
    # that are found in the current directory, the output is JSON and we parse it to fill in the combobox
    # Add also a boolean that if it is true, we add an additional -do flag to the command
    function FillGameSelection {
        param (
            [bool]$FilterDosOnly = $false  # Optional external override
        )
    
        # Prepare argument list
        $mainArgs = @()
        if ($FilterDosOnly -or ($dosOnly.IsChecked -eq $true)) {
            $mainArgs += "-do"
        }
        $mainArgs += "-lg"
    
        # Check if executable exists
        if (-not (Test-Path $exePath)) {
            Write-Host "DosboxStagingReplacer.exe not found at $exePath" -ForegroundColor Red
            return
        }
    
        try {
            
            # Configure the process start information
            $startInfo = New-Object System.Diagnostics.ProcessStartInfo
            $startInfo.FileName = $exePath
            $startInfo.Arguments = $mainArgs -join ' '
            $startInfo.RedirectStandardOutput = $true
            $startInfo.UseShellExecute = $false
            $startInfo.CreateNoWindow = $true
            $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8

            # Create and start the process
            $process = New-Object System.Diagnostics.Process
            $process.StartInfo = $startInfo
            $process.Start() | Out-Null

            # Read the entire output stream to its end. 
            # The .NET StreamReader will use the UTF-8 encoding we specified above.
            $rawOutput = $process.StandardOutput.ReadToEnd()

            # Wait for the process to finish
            $process.WaitForExit()

            # Now convert the corrected string to JSON
            $json = $rawOutput | ConvertFrom-Json
    
            # Validate it's an array of games
            if (-not ($json -is [System.Collections.IEnumerable])) {
                throw "Unexpected JSON structure"
            }
    
            # Build list of games (Title + ReleaseKey)
            $games = @($json | ForEach-Object {
                    [PSCustomObject]@{
                        Title            = $_.title
                        ReleaseKey       = $_.releaseKey
                        InstallationPath = $_.installationPath
                        InstallationDate = $_.installationDate
                    }
                })
    
            # Assign to ComboBox with display and value bindings
            $gameSelection.DisplayMemberPath = "Title"
            $gameSelection.SelectedValuePath = "ReleaseKey"
            $gameSelection.ItemsSource = $games

            # debug the output of games variable here
            Write-Host "Games loaded: $($games.Count)"
    
            # Optionally select the first game
            if ($games.Count -gt 0) {
                $gameSelection.SelectedIndex = 0
            }
    
        }
        catch {
            # Print the error to the console for debugging
            Write-Host "Error loading games: $_" -ForegroundColor Red
            # Show a message box to the user
            [System.Windows.MessageBox]::Show("Failed to load games: $_", "Error", "OK", "Error")
            exit
        }
    }
    
    

    # Call the function to fill in the combobox
    FillGameSelection -FilterDosOnly ($dosOnly.IsChecked -eq $true)

    $dosOnly.Add_Checked({
            FillGameSelection -FilterDosOnly $true
        })
    
    $dosOnly.Add_Unchecked({
            FillGameSelection -FilterDosOnly $false
        })

    # Let us define the RichTextBox named GameDescription
    $gameDescription = $window.FindName("GameDescription")
    $selectedGame = $gameSelection.SelectedItem
    # Check if a game is selected
    if ($null -ne $selectedGame) {
        # Clear the current content of the RichTextBox
        $gameDescription.Document.Blocks.Clear()

        # Create a new paragraph and add it to the RichTextBox
        $paragraph = New-Object System.Windows.Documents.Paragraph
        $paragraph.Inlines.Add("Title: " + $selectedGame.Title)
        $paragraph.Inlines.Add("`nReleaseKey: " + $selectedGame.ReleaseKey)
        $paragraph.Inlines.Add("`nInstallationPath: " + $selectedGame.InstallationPath)
        $paragraph.Inlines.Add("`nInstallationDate: " + $selectedGame.InstallationDate)

        # Add the paragraph to the RichTextBox
        $gameDescription.Document.Blocks.Add($paragraph)
    }

    # Add an event handler for when the game selection changes
    $gameSelection.add_SelectionChanged({
            # Get the selected game
            $selectedGame = $gameSelection.SelectedItem

            # Check if a game is selected
            if ($null -ne $selectedGame) {
                # Clear the current content of the RichTextBox
                $gameDescription.Document.Blocks.Clear()

                # Create a new paragraph and add it to the RichTextBox
                $paragraph = New-Object System.Windows.Documents.Paragraph
                $paragraph.Inlines.Add("Title: " + $selectedGame.Title)
                $paragraph.Inlines.Add("`nReleaseKey: " + $selectedGame.ReleaseKey)
                $paragraph.Inlines.Add("`nInstallationPath: " + $selectedGame.InstallationPath)
                $paragraph.Inlines.Add("`nInstallationDate: " + $selectedGame.InstallationDate)

                # Add the paragraph to the RichTextBox
                $gameDescription.Document.Blocks.Add($paragraph)
            }
        })

    # Let us define the button named ChangeDosbox
    $changeDosboxButton = $window.FindName("ChangeDosbox")

    # Now for the real beef, add the functionality for ChangeDosbox button
    $changeDosboxButton.Add_PreviewMouseLeftButtonDown({
            # Get the selected game from the combobox
            $selectedGame = $gameSelection.SelectedItem

            # Check if a game is selected
            if ($null -eq $selectedGame) {
                [System.Windows.MessageBox]::Show("Please select a game.", "Error", "OK", "Error")
                return
            }

            # We call the following from DosboxStagingReplacer.exe in the following order:
            # 1. -b (For backup)
            # 2. -rd -rk (releaseKey) -dv (dosboxVersion) [Assuming that the mode is Installed]
            # 3. -rd -rk (releaseKey) -dvm (dosboxVersionText) [Assuming that the mode is Portable]

            # Call 1.
            & $exePath -b
            # Call 2.
            if ($dosboxMode.SelectedItem -eq "Installed") {
                & $exePath -rd -rk $selectedGame.ReleaseKey -dv $dosboxVersion.SelectedItem
            }
            # Call 3.
            else {
                & $exePath -rd -rk $selectedGame.ReleaseKey -dvm $dosboxVersionText.Text
            }
            # Show a message box to indicate success
            [System.Windows.MessageBox]::Show("Dosbox version changed successfully.", "Success", "OK", "Information")
        })


    # Show the window
    $window.ShowDialog() | Out-Null
}

