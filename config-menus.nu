# Mostly experimental, to learn inline command line menu configuration and behavior
# The nav_subdir_menu and fuzzy_dir_menu menus are lacking in that they do not replace the marker
# fuzzy_dir_menu is based on nu_scripts/custom-menus/fuzzy/directory.nu
# docs: https://www.nushell.sh/book/line_editor.html#user-defined-menus

$env.config.menus = ($env.config.menus | append [
        {
            name: nav_subdir_menu
            only_buffer_difference: true
            marker: "cd "
            type: {
                layout: list
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
            source: { |buffer, position|
                get-subdirs $env.PWD | each {|x| {value: $x} }
            }
        }
        {
            name: fuzzy_dir_menu
            only_buffer_difference: true
            marker: "# "
            type: {
                layout: list
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
            source: { |buffer, position|
                ls **/* | where type == dir | get name
                    | each {|x| {value: $x} }
            }
        }
    ])

$env.config.keybindings = ($env.config.keybindings | append [
        {
            name: nav_subdir_menu
            modifier: control
            keycode: char_d
            mode: [emacs, vi_insert, vi_normal]
            event: { send: menu name: nav_subdir_menu }
        }
        {
            name: fuzzy_dir_menu
            modifier: control
            keycode: char_d
            mode: [emacs, vi_insert, vi_normal]
            event: { send: menu name: fuzzy_dir_menu }
        }
    ])
