return {
  'AlexvZyl/nordic.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('nordic').setup {
      on_highlight = function(highlights, palette)
        highlights.Comment = {
          fg = palette.gray5,
          italic = true,
        }
      end,
      -- Cursorline options.
      cursorline = {
        -- Bold font in cursorline.
        bold = false,
        -- Bold cursorline number.
        bold_number = true,
        -- Available styles: 'dark', 'light'.
        theme = 'light',
        -- Blending the cursorline bg with the buffer bg.
        blend = 0.5,
      },
      -- Visual selection options.
      visual = {
        -- Bold font in visual selection.
        bold = false,
        -- Bold visual selection number.
        bold_number = true,
        -- Available styles: 'dark', 'light'.
        theme = 'light',
        -- Blending the visual selection bg with the buffer bg.
        blend = 0.85,
      },
    }
    require('nordic').load()
  end,
}
