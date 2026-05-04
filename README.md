# C3 Development Template (Nix + VS Code)

A professional, reproducible development environment for the C3 programming language. This template uses Nix and direnv to provide a "zero-config" experience with working autocompletion, go-to-definition for the standard library, and integrated macOS debugging.

## 🚀 Features

- **Reproducible Toolchain**: Guarantees the same version of c3c and c3-lsp for everyone.
- **Automated IDE Config**: The Nix shellHook automatically injects absolute paths for the compiler, standard library, and system debugger into `.vscode/settings.json`.
- **Native Debugging**: Pre-configured to use the macOS system LLDB for full entitlement support (F5 to debug).
- **Clean Workspace**: Built-in tasks to nuke artifacts and keep the sidebar minimalist.

## 🛠 Prerequisites

- **Nix**: Install Nix (Deterministic Package Manager).
- **direnv**: Install direnv (Automatic environment switching).
- **VS Code Extensions**:
  - C3 Language Support
  - CodeLLDB
  - direnv
  - **Custom LSP Client**: This project requires a custom VS Code extension to bridge the communication with the c3-lsp server. 🔒 Privacy Note: The provided .vsix in the extensions/ folder is pre-packaged for convenience. If you prefer to build it yourself from source, you can find the repository here: [github.com/pherrymason/c3-lsp/client/vscode](https://github.com/pherrymason/c3-lsp/tree/main/client/vscode).

## 📥 Getting Started

Fork the template on GitHub by clicking the "Fork" button at https://github.com/jacomemateo/c3-template.

Clone your fork:

```bash
git clone https://github.com/YOUR_USERNAME/c3-template
cd c3-template
```

Allow the environment:

```bash
direnv allow
```

This will trigger Nix to download the compiler and generate your local configuration files.

Launch VS Code:

```bash
code .
```

Accept the "Recommended Extensions" prompt if it appears.

Install the Custom LSP Client:

```bash
code --install-extension extensions/c3-lsp-client-0.1.0.vsix
```

## 🔧 Customization

After cloning your fork, customize the project to make it your own:

1. **Rename the project directory** (optional): Rename the `c3-template` directory to your desired project name.

2. **Update `project.json`**:
   - Change the `"authors"` field to your name and email.
   - Update the `"version"` if desired (starts at "0.1.0").
   - Optionally, rename the output directory in `"output"` if you prefer a different name.

3. **Update README.md**: Replace references to the template with your project details.

## ⌨️ Development Workflow

### Building & Running

- **Build Debug**: Cmd + Shift + B (Default task).
- **Build Release**: Run the C3: Build Release task from the Command Palette.

### Debugging

Set a breakpoint in `src/main.c3`.

Press F5.

The environment automatically discovers your system's debugserver path and attaches correctly.

### Standard Library Exploration

You can Cmd + Click on modules (e.g., `std::io`) to jump directly to the Nix-store source code.

This is enabled by a stable symlink at `./.c3_lib` managed by the Flake.

## 🧹 Maintenance

To reset your workspace and remove all temporary links and binaries:

1. Open the Command Palette (Cmd + Shift + P).
2. Run Tasks: Run Task.
3. Select C3: Clean Workspace.

## 📂 Project Structure

```
.
├── .vscode/            # Integrated IDE configurations
├── src/                # Your C3 source code
├── .c3_lib             # Symlink to the C3 Stdlib (Auto-generated)
├── c3lsp.json          # LSP configuration (Auto-generated)
├── flake.nix           # Environment definition
└── project.json        # C3 build configuration
```