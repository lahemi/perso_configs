
These are, probably already outdated, configs for awesome wm I use.

The keybindings are set in rckeys.lua, in order to make it easier
for others to reuse my configs by modularity.

In rc.lua, you need to change a so called "base dir" variable to
correspond with your system. Beware, that trying to use ~/ resulted
in featureful behaviour and a stream of error messages in my
system.
You also need to change the parametres for the network widget,
unless you're using systemd on your machine and happen to have
enp2s0 too...

Vicious is included as it plays central role, at least for now,
for my widgets. There is a directory 'teatime' which contains
my horrid un-Lua-tastic widget for OSS volume, and much more
importantly, a hexadecimal clock. It is quite simple but all
the same delightful and I urge you to take a look.

You are fully entitled and free to modify, redistribute and
in any way in general to elaborate on my configuration files.

See the respective licenses of Awesome WM and Vicious.

