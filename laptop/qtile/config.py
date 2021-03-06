#          __  _ __           __  ___________
#   ____ _/ /_(_) /__        / /_<  / __/ __ \
#  / __ `/ __/ / / _ \______/ //_/ / /_/ / / /
# / /_/ / /_/ / /  __/_____/ ,< / / __/ /_/ /
# \__, /\__/_/_/\___/     /_/|_/_/_/  \____/
#   /_/

import os
import subprocess
from libqtile import layout, widget, bar
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from themes import currentTheme

# initial config
mod = "mod4"
terminal = "kitty"
applauncher = "rofi"
filemanager = "thunar"
scriptPath = "/home/k1f0/.config/scripts/"
home = os.path.expanduser('~')
rofiPower = f"rofi -show power-menu -modi 'power-menu:{scriptPath}rofi-power.sh --no-symbols --choices=shutdown/reboot/logout'"

# key binds
keys = [
    # move windows
    Key([mod], "Right", lazy.next_screen(), desc="Toggle between screens"),
    Key([mod], "Left", lazy.prev_screen(), desc="Toggle between screens"),
    Key([mod], "Down", lazy.group.next_window(), desc="Move focus down"),
    Key([mod], "Up", lazy.group.prev_window(), desc="Move focus up"),
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "mod1"], "Down", lazy.layout.flip_down(), desc="Flip Layout downwards"),
    Key([mod, "mod1"], "Up", lazy.layout.flip_up(), desc="Flip Layout upwards"),
    Key([mod, "mod1"], "Left", lazy.layout.flip_left(), desc="Flip Layout leftside"),
    Key([mod, "mod1"], "Right", lazy.layout.flip_right(), desc="Flip Layout rightside"),
    Key([mod, "control"], "Left", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "Right", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "Down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "Up", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod, "shift"], "n", lazy.layout.normalize(), desc="Normalize Layout"),

    # modify windows / layout
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    Key([mod], "b", lazy.window.bring_to_front(), desc="Bring Window to front"),
    Key([mod], "s", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "Tab", lazy.next_screen(), desc="Toggle between screens"),
    Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.restart(), desc="Restart Qtile"),
    Key([mod, "shift"], "q", lazy.spawn(rofiPower), desc="Power Menu"),

    # custom keybinds
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "a", lazy.spawn(f"{applauncher} -show run"), desc="Launch rofi run"),
    Key([mod, "shift"], "a", lazy.spawn(f"{applauncher} -show calc"), desc="Launch rofi calc"),
    Key([mod, "shift"], "w", lazy.spawn(f"{applauncher} -show window"), desc="Launch rofi window"),
    Key([mod], "l", lazy.spawn(f"{scriptPath}i3lock.sh"), desc="Lock Screen"),
    Key([mod], "q", lazy.spawn(filemanager), desc="Lock Screen"),
    Key([mod, "shift"], "s", lazy.spawn(f"{scriptPath}takeScreen.sh"), desc="Take Screen"),

    # fn keybinds
    Key([], "XF86AudioLowerVolume", lazy.spawn(f"{scriptPath}volumeDown.sh")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn(f"{scriptPath}volumeUp.sh")),
    Key([], "XF86MonBrightnessDown", lazy.spawn(f"{scriptPath}brightDown.sh")),
    Key([], "XF86MonBrightnessUp", lazy.spawn(f"{scriptPath}brightUp.sh")),
    Key([], "XF86AudioMute", lazy.spawn(f"{scriptPath}volumeMute.sh")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"))
]

# mouse binds
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

# add groups
groups = [
    Group(name="1", label="1",),
    Group(name="2", label="2"),
    Group(name="3", label="3"),
    Group(name="4", label="4"),
    Group(name="5", label="5"),
    Group(name="6", label="6")
]

for i in groups:
    keys.extend([
        Key([mod], i.name, lazy.group[i.name].toscreen(),),
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=False)),
    ])

# layout
layout_border = dict(
    border_focus=currentTheme["accentActive"],
    border_normal=currentTheme["accentNormal"],
    border_width=currentTheme["bordersize"],
    border_on_single=True,
)
layouts = [
    layout.Bsp(**layout_border,
        margin=currentTheme["layoutmargin"],
        fair=True,
        grow_amount=5
    ),
    layout.Floating(**layout_border),
]

floating_layout = layout.Floating(**layout_border, float_rules=[
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),
    Match(wm_class='makebranch'),
    Match(wm_class='maketag'),
    Match(wm_class='ssh-askpass'),
    Match(title='branchdialog'),
    Match(title='pinentry'),
    Match(wm_class='confirm'),
    Match(wm_class='dialog'),
    Match(wm_class='download'),
    Match(wm_class='error'),
    Match(wm_class='file_progress'),
    Match(wm_class='notification'),
    Match(wm_class='splash'),
    Match(wm_class='pinentry'),
    Match(wm_class="telegram-desktop"),
    Match(wm_class="signal"),
    Match(wm_class="nomacs"),
    Match(wm_class="Zathura"),
])

#widget settings
widget_defaults = dict(
    font=currentTheme["font"],
    fontsize=currentTheme["fontsize"],
    background=currentTheme["accentBackground"],
    foreground=currentTheme["accentForeground"],
    active=currentTheme["accentActive"],
    inactive=currentTheme["accentForeground"],
    padding=6
)

sep_default = dict(
    size_percent=100
)

extension_defaults = widget_defaults.copy()

# screens
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Spacer(
                    length=currentTheme["layoutmargin"]
                ),
                widget.GroupBox(
                    other_screen_border=currentTheme["accentNormal"],
                    other_current_screen_border=currentTheme["accentNormal"],
                    this_screen_border=currentTheme["accentActive"],
                    this_current_screen_border=currentTheme["accentActive"],
                    urgent_border=currentTheme["accentUrgent"],
                    highlight_method="border",
                    borderwidth=currentTheme["bordersize"],
                    padding=2,
                    rounded=False,
                    disable_drag=True,
                    use_mouse_wheel=False,
                    font=currentTheme["monoFont"]
                ),
                widget.CurrentLayout(),
                widget.Spacer(),
                widget.CPU(
                    update_interval=3,
                    format='cpu {load_percent}%'
                ),
                widget.Spacer(
                    length=currentTheme["accentModSpace"]
                ),
                widget.Clock(
                    format='%a, %d.%m.%y - %H:%M:%S'
                ),
                widget.Spacer(
                    length=currentTheme["accentModSpace"]
                ),
                widget.Memory(
                    update_interval=3,
                    format='mem {MemPercent}%'
                ),
                widget.Spacer(),
                widget.Wlan(
                    interface="wlan0",
                    update_interval=5,
                    disconnected_message="dsc",
                    format="wifi {essid} lq {percent:2.0%}"
                ),
                widget.Spacer(
                    length=currentTheme["accentModSpace"]
                ),
                widget.Battery(
                    format='{char} {percent:2.0%}',
                    charge_char="chr",
                    discharge_char="dcr"
                ),
                widget.Spacer(
                    length=currentTheme["layoutmargin"]
                ),
            ],
            currentTheme["barHeight"],
        ),
    ),
]

# bools
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "urgent"
reconfigure_screens = True
auto_minimize = False
wmname = "qtile"

# start thingies
subprocess.call([home + '/.config/scripts/xrandrapply.sh'])
subprocess.call([home + '/.config/qtile/autostart.sh'])
