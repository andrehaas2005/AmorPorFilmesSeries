#!/bin/sh
if test -d "/opt/homebrew/bin/"; then
    export PATH="/opt/homebrew/bin:${PATH}"
elif test -d "/usr/local/bin/"; then
    export PATH="/usr/local/bin:${PATH}"
fi

if which swiftlint >/dev/null; then
    swiftlint
else
    echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi

