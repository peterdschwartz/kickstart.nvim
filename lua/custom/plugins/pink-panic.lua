return {
  {
    "rktjmp/lush.nvim",
  },
  {
    "Scysta/pink-panic.nvim",
    lazy = false, -- load during startup
    priority = 1000, -- load before other start plugins
    config = function()
      vim.cmd.colorscheme("pink-panic")
    end,
  },
}
