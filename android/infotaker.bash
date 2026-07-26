# <> needed termux
# <> needed shizuku (play store)
# <> needed canta debloater (play store)
# <> run shizuku and install rish in tmux which runs in termux (pkg install tmux; tmux)

# 1. basic system information

# 1.1 kernel version & build info (tested)
cat /proc/version

# 1.2 android properties (tested)
getprop | grep -E "ro.build|ro.product|ro.system|ro.vendor"

# 1.3 android api level sdk (tested)
getprop ro.build.version.sdk

# 1.4 security patch level (tested)
getprop ro.build.version.security_patch

# 1.5 codename & incremental build (tested)
getprop ro.build.version.codename
getprop ro.build.version.incremental

# 1.6 build fingerprint (tested)
getprop ro.build.fingerprint

# 1.7 build description (tested)
getprop ro.build.description

# 1.8 build date & time (tested)
getprop ro.build.date.utc
getprop ro.build.date

