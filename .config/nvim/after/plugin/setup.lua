require("onedark").setup({
  style = "cool",
  code_style = {
    comments = "italic",
    strings = "italic",
  },
})
require("onedark").load()

require("gitsigns").setup({
  current_line_blame = true,
  current_line_blame_opts = { delay = 200 },
})

require("diffview").setup({
  use_icons = false,
  enhanced_diff_hl = true,
  file_panel = {
    win_config = { position = "bottom", height = 10 },
  },
})
