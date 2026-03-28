---
apply: always
---

# Dosbox Staging Replacer GUI Project Context

This repository contains a lightweight Windows desktop GUI wrapper for the `DosboxStagingReplacerForGOGGalaxy` command-line tool. The app is implemented as a PowerShell script with a WPF/XAML interface and is intended to help users browse GOG Galaxy games and run DOSBox replacement actions without using the CLI directly.

## Tech Stack

- PowerShell 5.1+ / PowerShell 7+
- WPF via `PresentationFramework`
- XAML for the UI layout
- External dependency: `DosboxStagingReplacer.exe`

## Project Structure

```text
/
|-- main.ps1              # Main application logic, startup checks, event handlers, CLI invocation
|-- Interface.xaml        # WPF layout and named controls consumed by main.ps1
|-- dosbox-replacer.png   # Background image used by the UI
|-- README.md             # User-facing setup, usage, and troubleshooting guide
|-- LICENSE               # Project license
`-- docs/                 # Screenshots and documentation assets
```

## Runtime Behavior

- `main.ps1` loads `Interface.xaml`, binds named controls, and wires up WPF event handlers in script.
- The GUI expects `DosboxStagingReplacer.exe` to be present in the working directory.
- Game data is loaded by calling the companion executable with `-lg` and optionally `-do`, then parsing JSON output.
- DOSBox replacement actions are performed by invoking the companion executable with arguments derived from the selected game and UI options.

## Hard Constraints

- Preserve compatibility with Windows PowerShell and WPF on Windows 10/11.
- Keep `main.ps1` and `Interface.xaml` in sync when renaming or adding controls.
- Do not remove or silently bypass validation and error handling around the external executable.
- Do not assume the companion executable is available globally; it is expected beside the script unless intentionally redesigned.
- Prefer clear, defensive PowerShell over clever but fragile scripting.
- Never commit unless explicitly requested.
