# apps.bash

* installs all required packages and applications
* contains the package and application installation list
* does not remove the MATE desktop
* does not remove the display manager

# openbox.sh

* converts a Debian MATE installation to Openbox
* installs the required packages and applications
* removes the MATE desktop components that are no longer needed
* removes the display manager
* applies the derfd Openbox configuration

# openbox_:)LOG).sh

* whats happening during executing openbox.sh
* can be different on an actual computer
* not a script

# setup.sh

* repairs or reapplies the derfd configuration
* does not remove the MATE desktop
* does not remove the display manager
* restores configuration files and settings
* can be used after something was deleted, broken or changed

# verificator.sh

* verifies
    - packages apt
    - flatpak apps
    - configurations
* does not modify system

# verificator_:)LOG).sh

* what happens during executing verificator.sh
* can be different on actual computer
* not a script