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

# 1.4 security patch level
getprop ro.build.version.security_patch