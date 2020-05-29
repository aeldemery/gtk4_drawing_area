### Gtk4 Drawing Area Example
This is a translated Vala version from the example at main (Gtk4 Documentation) [https://gnome.pages.gitlab.gnome.org/gtk/gtk/ch01s04.html]

the only problem I couldn't find solusion for is that closing the window don't exit the process.
And I can't connect to `destroy` signal. I don't know if it's a bug with Gtk4 or my fault.

### Note
You have to compile and install Gtk4 on your machin. On `ArchLinx` you can build the Gtk4 AUR package.

### Compile
run `meson build`, `cd build`, `ninja`.
