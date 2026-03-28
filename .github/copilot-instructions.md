# Copilot Instructions

This repository is a Windows desktop GUI wrapper for `DosboxStagingReplacerForGOGGalaxy`.

## Project Type

- This is a PowerShell + WPF/XAML project.
- This is not a C++ project.
- Do not suggest CMake, MSYS2, Ninja, Visual Studio C++ workflows, or native compilation steps unless the repository is intentionally redesigned.

## Primary Files

- `main.ps1`: main application logic, startup checks, event handlers, and external process execution
- `Interface.xaml`: WPF user interface definition
- `dosbox-replacer.png`: UI background image
- `README.md`: user-facing documentation
- `.github/workflows/release.yml`: GitHub Actions release packaging workflow

## Development Guidance

- Keep `main.ps1` and `Interface.xaml` aligned when controls are renamed or added.
- Prefer clear, defensive PowerShell over clever or compact scripting.
- Preserve compatibility with Windows PowerShell 5.1 and PowerShell 7+ when practical.
- Treat `DosboxStagingReplacer.exe` as an external dependency, not source code in this repository.
- Keep user-facing error handling intact when the external executable is missing or returns an error.

## Release Expectations

- The release artifact should be a `bundle.zip`.
- `bundle.zip` should contain the repository files for the tagged revision.
- `bundle.zip` should also include the latest `DosboxStagingReplacer.exe` downloaded from:
  `https://github.com/Shin-Aska/DosboxStagingReplacerForGOGGalaxy/releases/latest`
- Do not describe the release workflow as compiling a C++ binary from this repository.
- If release automation is updated, prefer packaging/copying/downloading steps over build steps that assume a native toolchain.

## Copilot Prompt Pack

This repository also contains reusable prompt files for Copilot:

- Skill:
  - `.github/prompts/deploy-to-publish.md`
- Workflows:
  - `.github/prompts/execute-plan.md`
  - `.github/prompts/multi-agent-plan.md`
  - `.github/prompts/multi-agent-plan-budget-mode.md`
  - `.github/prompts/multi-agent-plan-ultra-budget-mode.md`
- Router:
  - `.github/prompts/prompt-router.md`
