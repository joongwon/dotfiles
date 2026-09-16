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

-- Volume keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd "pactl set-sink-volume @DEFAULT_SINK@ +2%")
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd "pactl set-sink-volume @DEFAULT_SINK@ -2%")
hl.bind("XF86AudioMute", hl.dsp.exec_cmd "pactl set-sink-mute @DEFAULT_SINK@ toggle")

-- Launchers
hl.bind("SUPER + Return", hl.dsp.exec_cmd "ghostty")
hl.bind("SUPER + Space", hl.dsp.exec_cmd "rofi -show drun")

-- Session / window control
hl.bind("SUPER + Q", hl.dsp.window.close())

-- Focus movement
hl.bind("SUPER + H", hl.dsp.focus { direction = "l" })
hl.bind("SUPER + J", hl.dsp.focus { direction = "d" })
hl.bind("SUPER + K", hl.dsp.focus { direction = "u" })
hl.bind("SUPER + L", hl.dsp.focus { direction = "r" })

-- Window movement
hl.bind("SUPER + SHIFT + H", hl.dsp.window.move { direction = "l", group_aware = true })
hl.bind("SUPER + SHIFT + J", hl.dsp.window.move { direction = "d", group_aware = true })
hl.bind("SUPER + SHIFT + K", hl.dsp.window.move { direction = "u", group_aware = true })
hl.bind("SUPER + SHIFT + L", hl.dsp.window.move { direction = "r", group_aware = true })

-- Float toggle
hl.bind("SUPER + F", hl.dsp.window.float { action = "toggle" })

-- Workspace focus helper
-- Since Hyprland's focus command does not work for visible but empty workspaces,
-- we need to check if the workspace is visible and focus the monitor instead.
local function focus_workspace(id)
  return function()
    local workspace = hl.get_workspace(id)
    if workspace == nil then
      hl.dispatch(hl.dsp.focus { workspace = id })
    elseif workspace.visible then
      hl.dispatch(hl.dsp.focus { monitor = workspace.monitor })
    else
      hl.dispatch(hl.dsp.focus { workspace = id })
    end
  end
end

-- Workspaces 1..9
for i = 1, 9 do
  hl.bind("SUPER + " .. i, focus_workspace(i))
  hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move { workspace = i })
end

-- Workspace 10
hl.bind("SUPER + 0", focus_workspace(10))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move { workspace = 10 })

-- Named workspaces
local named_workspaces = {
  M = "name:mail",
  D = "name:discord",
  S = "name:slack",
}

for key, workspace in pairs(named_workspaces) do
  hl.bind("SUPER + " .. key, focus_workspace(workspace))
  hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move { workspace = workspace })
end

-- Screenshots
hl.bind("SUPER + SHIFT + F3", hl.dsp.exec_cmd "grim - | wl-copy")
hl.bind("SUPER + SHIFT + F4", hl.dsp.exec_cmd [[grim -g "$(slurp)" - | wl-copy]])

-- Center active window
hl.bind("SUPER + C", hl.dsp.window.center())

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
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Groups
hl.bind("SUPER + G", hl.dsp.group.toggle())
hl.bind("SUPER + Tab", hl.dsp.group.next())
hl.bind("SUPER + SHIFT + Tab", hl.dsp.group.prev())

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
