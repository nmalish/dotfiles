## Installation Notes

### dotnet
https://learn.microsoft.com/en-us/dotnet/core/install/macos#install-net

#### dotnet scripts:
https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script

# .NET Installation Scripts Guide

This README provides a comprehensive guide for using the official .NET installation script for Linux and macOS.

## Quick Reference

| Script | Platform | Download URL |
|--------|----------|--------------|
| `dotnet-install.sh` | Linux/macOS | https://dot.net/v1/dotnet-install.sh |

## Understanding .NET Releases

### Release Types
- **LTS (Long-Term Support)**: Even-numbered releases (6, 8, 10, etc.)
  - 3 years of support
  - Recommended for production environments
  - More stable, fewer breaking changes

- **STS (Standard-Term Support)**: Odd-numbered releases (7, 9, 11, etc.)
  - 18 months of support
  - Latest features and improvements
  - Good for development and testing

### Current Versions (as of 2024)
- **Latest LTS**: .NET 8 (supported until November 2026)
- **Latest STS**: .NET 9 (supported until ~May 2026)
- **Latest Overall**: .NET 9

## Installation Examples

### Download the Script First

```bash
wget https://dot.net/v1/dotnet-install.sh
chmod +x dotnet-install.sh
```

### Basic Installation Commands

#### Install Latest LTS Version (.NET 8)
```bash
./dotnet-install.sh --channel LTS
```

#### Install Latest STS Version (.NET 9)
```bash
./dotnet-install.sh --channel STS
```

#### Install Specific Version
```bash
./dotnet-install.sh --version 9.0.100
./dotnet-install.sh --channel 9.0
```

#### Install Latest Available (Current)
```bash
./dotnet-install.sh --channel Current
```

### Runtime vs SDK

#### Install SDK (Recommended for Development)
```bash
# Default behavior - installs SDK
./dotnet-install.sh --channel 9.0
```

#### Install Runtime Only
```bash
./dotnet-install.sh --channel 9.0 --runtime dotnet
```

#### Install ASP.NET Core Runtime
```bash
./dotnet-install.sh --channel 9.0 --runtime aspnetcore
```

### Custom Installation Location

```bash
./dotnet-install.sh --channel 9.0 --install-dir ~/dotnet
```

## Common Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `--channel` | Release channel (LTS, STS, Current, or version) | `--channel 9.0` |
| `--version` | Specific version to install | `--version 9.0.100` |
| `--runtime` | Install runtime only (`dotnet`, `aspnetcore`) | `--runtime aspnetcore` |
| `--install-dir` | Installation directory | `--install-dir ~/dotnet` |
| `--architecture` | Target architecture (x64, arm64, etc.) | `--architecture arm64` |
| `--dry-run` | Show what would be installed without installing | `--dry-run` |
| `--help` | Show help information | `--help` |

## Verification

After installation, verify the installation:

```bash
# Check installed versions
dotnet --list-sdks
dotnet --list-runtimes

# Check .NET info
dotnet --info

# Test with a simple command
dotnet --version
```

## Environment Setup

Add to your `~/.zshrc`:
```bash
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$DOTNET_ROOT:$PATH"
```

Then reload your shell:
```bash
source ~/.zshrc
```

## Production Recommendations

1. **Use LTS for Production**: Always use LTS releases for production environments
2. **Pin Specific Versions**: Use exact version numbers rather than channels for reproducible builds
3. **Test Before Upgrading**: Test applications thoroughly before upgrading .NET versions
4. **Security Updates**: Keep up with patch releases for security fixes

## Troubleshooting

### Common Issues

**Script fails to download:**
- Check internet connectivity
- Verify the download URL is accessible
- Try downloading manually

**Permission denied:**
- Make the script executable: `chmod +x dotnet-install.sh`
- Run with appropriate permissions

**Version not found:**
- Check if the specified version exists
- Use `--dry-run` to see what would be installed
- Verify the channel/version syntax

**Multiple versions installed:**
- Use `dotnet --list-sdks` to see all installed versions
- Set `DOTNET_ROOT` to point to the desired version
- Use global.json to pin project to specific version

### Useful Commands

```bash
# See what would be installed without actually installing
./dotnet-install.sh --channel 9.0 --dry-run

# Get help
./dotnet-install.sh --help

# Install multiple versions
./dotnet-install.sh --channel 8.0
./dotnet-install.sh --channel 9.0
```

## Additional Resources

- [Official .NET Downloads](https://dotnet.microsoft.com/download)
- [.NET Support Policy](https://dotnet.microsoft.com/platform/support/policy/dotnet-core)
- [.NET Release Notes](https://github.com/dotnet/core/tree/main/release-notes)
- [Installation Documentation](https://docs.microsoft.com/en-us/dotnet/core/install/)

## Notes

- The script behavior may change over time as Microsoft updates the installation process
- Always verify the script source and use official Microsoft URLs
- For enterprise environments, consider using package managers or official installers
- Keep track of support lifecycles when choosing between LTS and STS releases
