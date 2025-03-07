# Technical Notes for Pebble Nix Build

This document contains detailed technical notes about the implementation and fixes applied to make the Pebble SDK work with Nix and Python 2.7.

## Python 2.7 Environment Setup

### Python Wrapper Fix

```bash
#!/usr/bin/env bash
export PYTHONPATH="$PEBBLE_SDK/.env/lib/python2.7/site-packages:$PYTHONPATH"
exec "${python27}/bin/python" "$@"
```

The key fixes were:
- Using proper shebang line
- Setting PYTHONPATH environment variable
- Using exec to replace the shell process

### Pip Wrapper Fix

Replaced problematic shell syntax:

```bash
# Problematic syntax that conflicts with Nix
pkg=${@: -1}  # This causes syntax errors in Nix

# Fixed approach using a for loop
for last_arg; do true; done
pkg="$last_arg"
```

## Package Compatibility Solutions

### Direct Package Installation

Created package placeholders when pip fails:

```bash
for pkg in pyasn1 pyasn1_modules pyyaml pillow pygments websocket_client oauth2client pyserial peewee gevent; do
  echo "Creating placeholder for $pkg..."
  pkg_dir="$PEBBLE_SDK/.env/lib/python2.7/site-packages/$pkg"
  mkdir -p "$pkg_dir"
  echo "# Auto-generated placeholder" > "$pkg_dir/__init__.py"
done
```

### Network Access Disabling

Modified the approach to patching SDK files:

```bash
# Previous approach with pipe issues
find $PEBBLE_SDK -name "*.py" -type f -exec grep -l "urllib\|requests\|http:" {} \; | while read file; do
  # Patching code
done

# New approach avoiding pipes
find_cmd="find $PEBBLE_SDK -name '*.py' -type f"
$find_cmd > sdk_python_files.txt
while read -r file; do
  if grep -q "$network_keywords" "$file" 2>/dev/null; then
    # Patching code
  fi
done < sdk_python_files.txt
```

## Build Process Improvements

### Better Error Handling

```bash
# Save the build output to a file instead of piping directly to grep
pebble build --offline > build_output.log 2>&1 || {
  echo "Pebble build failed with exit code $?"
  echo "===== BUILD OUTPUT ====="
  cat build_output.log
  echo "======================="
  # More diagnostic code
}
```

### Hash Management

When hash verification fails, update the hash in flake.nix:

```nix
pipInstallerPy = pkgs.fetchurl {
  url = "https://bootstrap.pypa.io/pip/2.7/get-pip.py";
  sha256 = "sha256-QO4H6sZnS41g/OK7q8FIzw4vFAjBZ2g/EQ/WCLjW9BY="; # Updated hash
};
```

## Debugging Tips

1. Add diagnostic echo statements at key points
2. Use `ls -la` to verify file permissions
3. Test crucial components like Python and pip wrappers before proceeding
4. Add fallback mechanisms for commands that might fail
5. Redirect verbose output to files for later inspection 