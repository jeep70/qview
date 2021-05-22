#! /usr/bin/pwsh

param
(
    $Prefix = "/usr"
)

if ($IsWindows) {
    & "$env:BUILD_REPOSITORY_LOCALPATH/ci/pwsh/vcvars.ps1"
}

qmake $args[0] PREFIX=$Prefix

if ($IsWindows) {
    nmake
} else {
    make
}