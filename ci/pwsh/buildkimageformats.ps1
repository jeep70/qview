#! /usr/bin/pwsh

# Clone
git clone https://invent.kde.org/frameworks/kimageformats.git
cd kimageformats
git checkout $(git describe --abbrev=0).substring(0, 7)


# Get dependencies
if ($IsWindows) {
    choco install ninja nasm
} elseif ($IsMacOS) {
    brew untap kde-mac/kde 2> /dev/null
    brew tap kde-mac/kde https://invent.kde.org/packaging/homebrew-kde.git --force-auto-update
    "$(brew --repo kde-mac/kde)/tools/do-caveats.sh"

    brew install kde-mac/kde/kf5-kparts


    brew install ninja nasm extra-cmake-modules openexr libheif
} else {
    brew untap kde-mac/kde 2> /dev/null
    brew tap kde-mac/kde https://invent.kde.org/packaging/homebrew-kde.git --force-auto-update
    "$(brew --repo kde-mac/kde)/tools/do-caveats.sh"

    brew install kde-mac/kde/kf5-kparts


    sudo apt-get install ninja-build
    brew install nasm extra-cmake-modules openexr libheif
}

# Build

# vcvars on windows
if ($IsWindows) {
    & "$env:BUILD_REPOSITORY_LOCALPATH/ci/pwsh/vcvars.ps1"
}

# Build libavif dependency

& "$env:BUILD_REPOSITORY_LOCALPATH/ci/pwsh/buildlibavif.ps1"

$env:libavif_DIR = "libavif/build/installed/usr/local/lib/cmake/libavif/"


cmake -DKIMAGEFORMATS_HEIF=ON .

if ($IsWindows) {
    nmake
} else {
    make
    sudo make install
}