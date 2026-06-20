hl.monitor {
  output = "DVI-D-1",
  mode = "1920x1080",
  position = "0x0",
  scale = 1,
  transform = 3,
}

hl.monitor {
  output = "HDMI-A-1",
  mode = "1920x1080",
  position = "1080x570",
  scale = 1,
}

hl.env("LIBVA_DRIVER_NAME", "nvidia")

hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
