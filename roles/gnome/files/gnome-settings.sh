#!/bin/bash

gsettings set org.gnome.desktop.input-sources   sources=[('xkb', 'pl')]
gsettings set org.gnome.desktop.input-sources xkb-options=['ctrl:swapcaps']

gsettings set org.gnome.desktop.interfaces gtk-im-module='gtk-im-context-simple'
gsettings set org.gnome.desktop.interfaces gtk-theme='Ayu-Dark'
gsettings set org.gnome.desktop.interfaces icon-theme='Arc'

gsettings set org.gnome.desktop.wm.preferences button-layout=':'
gsettings set org.gnome.desktop.wm.preferences theme='Ayu-Dark'

gsettings set org.gnome.desgsettings set ktop.screensaver color-shading-type='solid'
gsettings set org.gnome.desgsettings set ktop.screensaver picture-options='zoom'
gsettings set org.gnome.desgsettings set ktop.screensaver picture-uri='file:///home/l/Pictures/Wallpapers/islamic_mandala_breathe_death.png'
gsettings set org.gnome.desgsettings set ktop.screensaver primary-color='#000000000000'
gsettings set org.gnome.desgsettings set ktop.screensaver secondary-color='#000000000000'

gsettings set org.gnome.settings-daemon.plugins.media-keys area-screenshot-clip=['<Primary><Alt>s']

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom0
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom0 binding='<Primary><Alt>e'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom0 command='~/.emacs_anywhere/bin/run'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom0 name='Emacs anywhere'

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom1 binding=''
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom1 command='gnome-screenshot -a -c'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom1 name='Screenshot area'

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom2 binding='<Primary><Alt>c'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom2 command='copyq show'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.custom2 name='Copyq show'
