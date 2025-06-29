# Dosbox Staging Replacer GUI Wrapper

![GitHub](https://img.shields.io/github/license/Shin-Aska/DosboxStagingReplacerForGOGGalaxy-UI)
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/Shin-Aska/DosboxStagingReplacerForGOGGalaxy-UI)
![GitHub repo size](https://img.shields.io/github/repo-size/Shin-Aska/DosboxStagingReplacerForGOGGalaxy-UI)

![Dosbox Staging Replacer GUI](./docs/SampleUI.png)

A lightweight graphical user interface built with PowerShell and WPF for the [`DosboxStagingReplacerForGOGGalaxy`](https://github.com/Shin-Aska/DosboxStagingReplacerForGOGGalaxy) command-line tool. It allows for easy management of DOSBox installations for your GOG Galaxy games.

---

## 🧩 Features

-   Simple, intuitive GUI for browsing and selecting your GOG Galaxy games.
-   Filter games to show only DOS-based titles.
-   Easily configure and execute the replacer tool with just a few clicks.
-   A classic, retro-themed background to get you in the mood for some DOS gaming.

---

## 🔧 Requirements

-   **Operating System:** Windows 10 or Windows 11
-   **PowerShell:** Windows PowerShell 5.1 (included by default in Win10/11) or PowerShell 7+.

---

## ⚠️ A Note on Antivirus Software

PowerShell scripts, especially those that interact with other files, can sometimes be flagged as suspicious by antivirus software. This script is provided as plain text so you can inspect its contents and understand exactly what it does. The code is heavily commented for clarity.

If your antivirus flags `main.ps1`, please mark it as a false positive. It is recommended to review the code yourself to be confident in its safety.

---

## 🚀 Installation and Usage

There are two ways to get started. The easy way is recommended for most users.

### Option 1: The Easy Way (Recommended)

This method provides everything you need in a single download.

1.  **Download the Latest Release**
    Go to the [**Releases Page**](https://github.com/Shin-Aska/DosboxStagingReplacerForGOGGalaxy-UI/releases/latest) and download the `DosboxStagingReplacer-UI-vX.X.X.zip` file.

2.  **Extract the Archive**
    Right-click the downloaded `.zip` file and select "Extract All..." to a folder of your choice. This bundle already includes the required `DosboxStagingReplacer.exe`.

3.  **Run the Application**
    After extracting, you will likely need to address PowerShell's Execution Policy. **Please see the `Troubleshooting` section below for solutions.**

### Option 2: The Manual Way (from Source)

This method is for users who want to run the latest, unreleased code directly.

1.  **Prerequisites**
    You must have [**Git**](https://git-scm.com/) installed on your system.

2.  **Clone the Repository**
    Open a terminal and run the following command:
    ```powershell
    git clone [https://github.com/Shin-Aska/DosboxStagingReplacerForGOGGalaxy-UI.git](https://github.com/Shin-Aska/DosboxStagingReplacerForGOGGalaxy-UI.git)
    ```

3.  **Download the Companion Tool**
    Download the latest `DosboxStagingReplacer.exe` from its [**releases page**](https://github.com/Shin-Aska/DosboxStagingReplacerForGOGGalaxy/releases/latest). Place this `.exe` file in the `DosboxStagingReplacerForGOGGalaxy-UI` folder you just cloned, right next to `main.ps1`.

---

### How to Use the Application

1.  **Launch the Application**
    Open a PowerShell terminal, navigate into the application's folder, and run the main script:
    ```powershell
    cd C:\path\to\the\folder
    .\main.ps1
    ```
    > **Note:** If you receive an error, see the **Troubleshooting** section below.

2.  **Select Your Game**
    Use the dropdown menu to select the GOG game whose DOSBox runner you want to replace. You can check "DOS Games Only" to filter the list.

3.  **Configure Options**
    Choose whether you are using an "Installed" or "Portable" DOSBox version and select the appropriate version or path.

4.  **Apply Changes**
    Click the **Change DOSBox** button to perform the replacement. A success message will appear when finished.

---

## ⚠️ Troubleshooting: Execution Policy Errors

PowerShell's security features prevent running scripts downloaded from the internet by default. If you see an error mentioning `execution policy`, you have three options.

### Option A: Unblock the File (Recommended)

This is the safest method as it only affects this one script file.

1.  In File Explorer, right-click on `main.ps1`.
2.  Select **Properties**.
3.  On the **General** tab, at the bottom, check the **Unblock** box and click **OK**.

<img src="/docs/Unblock.png" alt="Unblock File" width="400">

### Option B: Bypass for a Single Run (Command-Line)

This command tells PowerShell to ignore the policy for a single execution. It does not permanently change any settings.

1.  Open a PowerShell terminal.
2.  Run the script using the following command, replacing the path with the actual path to your script:
    ```powershell
    PowerShell.exe -ExecutionPolicy Bypass -File "C:\path\to\your\main.ps1"
    ```

### Option C: Change the Policy (Advanced)

This permanently changes the execution policy for your user account. This is convenient but has security implications if you are not careful about the scripts you run.

1.  Open a PowerShell console.
2.  Run the following command. It only needs to be run once.
    ```powershell
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
    ```
3.  It will ask for confirmation; press `Y` and Enter. This allows local scripts and unblocked/signed remote scripts to run.

---

## 📁 Project Files

| File                  | Description                                            |
| --------------------- | ------------------------------------------------------ |
| `main.ps1`            | The main PowerShell script that runs the application.  |
| `Interface.xaml`      | The WPF file that defines the UI layout and controls.  |
| `dosbox-replacer.png` | The retro-themed background image for the UI.          |
| `/docs`               | Contains screenshots and documentation assets.         |
| `README.md`           | The file you are currently reading.                    |

## 📦 Related Project

This GUI is a front-end for the powerful command-line tool:
🔗 **[`DosboxStagingReplacerForGOGGalaxy`](https://github.com/Shin-Aska/DosboxStagingReplacerForGOGGalaxy)**

---

## 📝 License

This project is licensed under the **MIT License**. For the full license text, please refer to the license file in the upstream tool's repository.