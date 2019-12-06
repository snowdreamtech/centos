#!/bin/bash
# https://github.com/estesp/manifest-tool

file="/usr/local/bin/manifest-tool"
arch=`uname -m`
version="1.0.0"
url="https://github.com/estesp/manifest-tool/releases/download/v${version}/manifest-tool-linux-amd64"


# manifest-tool
if [ ! -f "$file" ]; then
    echo 'check manifest-tool: no exists, it will be installed automatically.'
    
    if command -v wget >/dev/null 2>&1; then
        echo 'check wget: installed.'
    else
        echo 'check wget: no exists, please install it.'
    fi
    
    case $arch in
        x86_64 )
        url="https://github.com/estesp/manifest-tool/releases/download/v${version}/manifest-tool-linux-amd64" ;;
        i386 )
        url="https://github.com/estesp/manifest-tool/releases/download/v${version}/manifest-tool-linux-386" ;;
        armv7l )
        url="https://github.com/estesp/manifest-tool/releases/download/v${version}/manifest-tool-linux-armv7" ;;
        aarch64 )
        url="https://github.com/estesp/manifest-tool/releases/download/v${version}/manifest-tool-linux-arm64" ;;
    esac
    
    wget -c $url -O $file
    chmod +x $file
    echo 'check manifest-tool: installed.'
else
    echo 'check manifest-tool: installed.'
fi

# centos
manifest-tool push from-spec centos.yaml
