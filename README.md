# iTerm2 to Gnome Terminal Theme Converter

A script to convert iTerm2 themes to gnome-terminal themes that uses
[plist](https://github.com/bleything/plist) to read the colorschemes.

[More info.](http://www.sharms.org/blog/2012/08/24/using-iterm2-themes-with-gnome-terminal/)

##Usage

    ./convert.rb /path/to/iterm_scheme.itermcolors

##Example:

    $ ./convert.rb ./idleToes.itermcolors 
    # ./idleToes.itermcolors
    gconftool-2 --set /apps/gnome-terminal/profiles/Default/foreground_color --type string "#FFFFFF"
    gconftool-2 --set /apps/gnome-terminal/profiles/Default/background_color --type string "#323232"
    gconftool-2 --set /apps/gnome-terminal/profiles/Default/bold_color --type string "#FFFFA9"
    gconftool-2 --set /apps/gnome-terminal/profiles/Default/palette --type string "#323232:#D25252:#7FE173:#FFC66D:#4098FF:#F57FFF:#BED6FF:#EEEEEC:#535353:#F07070:#9DFF90:#FFE48B:#5EB7F7:#FF9DFF:#DCF4FF:#FFFFFF"


Then, you can just paste those commands into a gnome terminal, and it will set
your color scheme.

##Dependencies
Requires the [plist gem](https://github.com/bleything/plist).
