#!/bin/bash

gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'pl')]"
gsettings set org.gnome.desktop.input-sources xkb-options "['ctrl:swapcaps']"

gsettings set org.gnome.desktop.interface gtk-im-module 'gtk-im-context-simple'
gsettings set org.gnome.desktop.interface gtk-theme 'Ayu-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Arc'

gsettings set org.gnome.desktop.wm.preferences button-layout ':'
gsettings set org.gnome.desktop.wm.preferences theme 'Ayu-Dark'

gsettings set org.gnome.desktop.screensaver picture-options 'zoom'
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///home/l/Dropbox/Wallpapers/islamic_mandala.png'
gsettings set org.gnome.desktop.screensaver primary-color '#000000000000'
gsettings set org.gnome.desktop.screensaver secondary-color '#000000000000'

gsettings set org.gnome.desktop.background color-shading-type 'solid'
gsettings set org.gnome.desktop.background picture-options 'zoom'
gsettings set org.gnome.desktop.background picture-uri 'file:///home/l/Dropbox/Wallpapers/socrates.jpg'
gsettings set org.gnome.desktop.background primary-color '#000000'
gsettings set org.gnome.desktop.background secondary-color '#000000'
gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot-clip "['<Primary><Alt>s']"

gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot-clip "['<Primary><Alt>s']"

# gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom0 binding '<Primary><Alt>e'
# gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom0 command '~/.emacs_anywhere/bin/run'
# gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom0 name 'Emacs anywhere'

# gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom binding ''
# gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom command 'gnome-screenshot -a -c'
# gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom name 'Screenshot area'

# gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom binding '<Primary><Alt>c'
# gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom command 'copyq show'
# gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom name 'Copyq show'
