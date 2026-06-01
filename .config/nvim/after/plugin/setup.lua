local has_onedark, onedark = pcall(require, "onedark")
if has_onedark then
  onedark.setup({
    style = "deep",
    code_style = {
      comments = "italic",
      strings = "italic",
    },
  })
  onedark.load()
end

local has_gitsigns, gitsigns = pcall(require, "gitsigns")
if has_gitsigns then
  gitsigns.setup({
    current_line_blame = true,
    current_line_blame_opts = { delay = 200 },
  })
end

local has_diffview, diffview = pcall(require, "diffview")
if has_diffview then
  diffview.setup({
    use_icons = false,
    enhanced_diff_hl = true,
    file_panel = {
      win_config = { position = "bottom", height = 10 },
    },
  })
end
