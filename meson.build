project ('github.aeldemery.gtk4demo', 'vala', 'c')

sources = []

sources += files(
    'src/main.vala',
)

dependencies = [
    dependency ('glib-2.0'),
    dependency ('gobject-2.0'),
    dependency ('gtk4'),
]

executable (
    meson.project_name(),
    sources: sources,
    dependencies: dependencies,
    install: true,
)

