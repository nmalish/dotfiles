return {
  'mbbill/undotree',
  cmd = 'UndotreeToggle',
  keys = {
    { '<leader>u', '<cmd>UndotreeToggle<cr>', desc = 'Toggle [U]ndo tree' },
  },
  config = function()
    -- Configure undotree window layout
    vim.g.undotree_WindowLayout = 2
    vim.g.undotree_SplitWidth = 40
    vim.g.undotree_SetFocusWhenToggle = 1
    
    -- Enable persistent undo (already set in init.lua but ensuring it's available)
    vim.opt.undofile = true
  end,
}