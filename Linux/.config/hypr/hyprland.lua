pcall(require, "extra")

hl.env("GTK_IM_MODULE", "fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")

hl.on("hyprland.start", function()
  hl.exec_cmd "xrdb ~/.Xresources"
end)

hl.animation {
  leaf = "global",
  enabled = false,
}

local mod = "SUPER"

-- Volume keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd "pactl set-sink-volume @DEFAULT_SINK@ +2%")
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd "pactl set-sink-volume @DEFAULT_SINK@ -2%")
hl.bind("XF86AudioMute", hl.dsp.exec_cmd "pactl set-sink-mute @DEFAULT_SINK@ toggle")

-- Launchers
hl.bind(mod .. " + Return", hl.dsp.exec_cmd "kitty")
hl.bind(mod .. " + Space", hl.dsp.exec_cmd "rofi -show drun")

-- Session / window control
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd "hyprshutdown")
hl.bind(mod .. " + ALT + Q", hl.dsp.exec_cmd "hyprlock")

-- Focus movement
hl.bind(mod .. " + H", hl.dsp.focus { direction = "l" })
hl.bind(mod .. " + J", hl.dsp.focus { direction = "d" })
hl.bind(mod .. " + K", hl.dsp.focus { direction = "u" })
hl.bind(mod .. " + L", hl.dsp.focus { direction = "r" })

-- Window movement
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move { direction = "l", group_aware = true })
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move { direction = "d", group_aware = true })
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move { direction = "u", group_aware = true })
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move { direction = "r", group_aware = true })

-- Workspaces 1..9
for i = 1, 9 do
  hl.bind(mod .. " + " .. i, hl.dsp.focus { workspace = i })
  hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move { workspace = i })
end

-- Workspace 10
hl.bind(mod .. " + 0", hl.dsp.focus { workspace = 10 })

-- Named workspaces
local named_workspaces = {
  M = "name:mail",
  D = "name:discord",
  S = "name:slack",
}

for key, workspace in pairs(named_workspaces) do
  hl.bind(mod .. " + " .. key, hl.dsp.focus { workspace = workspace })
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move { workspace = workspace })
end

-- Screenshots
hl.bind(mod .. " + SHIFT + F3", hl.dsp.exec_cmd "grim - | wl-copy")
hl.bind(mod .. " + SHIFT + F4", hl.dsp.exec_cmd [[grim -g "$(slurp)" - | wl-copy]])

-- Center active window
hl.bind(mod .. " + C", hl.dsp.window.center())

-- Input
hl.config {
  input = {
    kb_options = "korean:ralt_hangul, korean:rctrl_hanja",
  },
}

-- Window rules
hl.window_rule {
  name = "thunderbird-to-mail",
  match = {
    class = [[^org\.mozilla\.Thunderbird$]],
  },
  workspace = "name:mail",
}

hl.window_rule {
  name = "discord-to-discord",
  match = {
    class = [[^webcord$]],
  },
  workspace = "name:discord",
}

hl.window_rule {
  name = "slack-to-slack",
  match = {
    class = [[^Slack$]],
  },
  workspace = "name:slack",
}

-- Mouse binds
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Groups
hl.bind(mod .. " + G", hl.dsp.group.toggle())
hl.bind(mod .. " + Tab", hl.dsp.group.next())
hl.bind(mod .. " + SHIFT + Tab", hl.dsp.group.prev())

hl.config {
  group = {
    auto_group = true,
    insert_after_current = true,
    drag_into_group = 1,

    groupbar = {
      enabled = true,
      render_titles = true,
      font_family = "JetBrains Mono",
      font_size = 12,
      height = 18,
      gradients = true,
    },
  },
}

-- Cursor
hl.config {
  cursor = {
    no_warps = true,
  },
}
