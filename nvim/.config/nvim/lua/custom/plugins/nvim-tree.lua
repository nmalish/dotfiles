return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    -- Custom on_attach function to define keymaps
    local function on_attach(bufnr)
      local api = require('nvim-tree.api')
      local wk = require('which-key')
      
      -- Helper function for options
      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end
      
      -- Default mappings
      api.config.mappings.default_on_attach(bufnr)
      
      -- Register NvimTree keymaps with which-key for buffer
      wk.register({
        n = {
          name = "NvimTree Actions",
          a = { api.fs.create, "Create file/directory" },
          d = { api.fs.remove, "Delete" },
          D = { api.fs.trash, "Trash" },
          r = { api.fs.rename, "Rename" },
          R = { api.tree.reload, "Refresh tree" },
          x = { api.fs.cut, "Cut" },
          c = { api.fs.copy.node, "Copy" },
          p = { api.fs.paste, "Paste" },
          y = { api.fs.copy.filename, "Copy name" },
          Y = { api.fs.copy.relative_path, "Copy relative path" },
          A = { api.fs.copy.absolute_path, "Copy absolute path" },
          f = { api.live_filter.start, "Filter" },
          F = { api.live_filter.clear, "Clear filter" },
          q = { api.tree.close, "Close tree" },
          W = { api.tree.collapse_all, "Collapse all" },
          E = { api.tree.expand_all, "Expand all" },
          S = { api.tree.search_node, "Search" },
          ["?"] = { api.tree.toggle_help, "Toggle help" },
          ["."] = { api.tree.toggle_hidden_filter, "Toggle hidden files" },
          ["U"] = { api.tree.toggle_custom_filter, "Toggle custom filter" },
          i = { api.tree.toggle_gitignore_filter, "Toggle git ignore" },
        },
      }, { buffer = bufnr, prefix = "<leader>" })
      
      -- Also register some direct keymaps (without leader)
      wk.register({
        ["g?"] = { api.tree.toggle_help, "Toggle help" },
        ["<CR>"] = { api.node.open.edit, "Open" },
        ["o"] = { api.node.open.edit, "Open" },
        ["<2-LeftMouse>"] = { api.node.open.edit, "Open" },
        ["v"] = { api.node.open.vertical, "Open vertical split" },
        ["s"] = { api.node.open.horizontal, "Open horizontal split" },
        ["t"] = { api.node.open.tab, "Open in tab" },
        ["<"] = { api.node.navigate.sibling.prev, "Previous sibling" },
        [">"] = { api.node.navigate.sibling.next, "Next sibling" },
        ["P"] = { api.node.navigate.parent, "Parent directory" },
        ["K"] = { api.node.show_info_popup, "Info" },
        ["[c"] = { api.node.navigate.git.prev, "Prev git" },
        ["]c"] = { api.node.navigate.git.next, "Next git" },
        ["-"] = { api.tree.change_root_to_parent, "Up" },
        ["<C-]>"] = { api.tree.change_root_to_node, "CD" },
      }, { buffer = bufnr })
    end
    
    require('nvim-tree').setup {
      on_attach = on_attach,
      -- Disable netrw at the very start of your init.lua
      disable_netrw = true,
      hijack_netrw = true,

      -- Configure the tree view
      view = {
        width = 30,
        side = 'left',
      },

      -- Renderer configuration
      renderer = {
        add_trailing = false,
        group_empty = false,
        highlight_git = false,
        full_name = false,
        highlight_opened_files = 'none',
        root_folder_modifier = ':~',
        indent_width = 2,
        indent_markers = {
          enable = false,
          inline_arrows = true,
          icons = {
            corner = '└',
            edge = '│',
            item = '│',
            bottom = '─',
            none = ' ',
          },
        },
        icons = {
          webdev_colors = true,
          git_placement = 'before',
          padding = ' ',
          symlink_arrow = ' ➛ ',
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            default = '',
            symlink = '',
            bookmark = '',
            folder = {
              arrow_closed = '',
              arrow_open = '',
              default = '',
              open = '',
              empty = '',
              empty_open = '',
              symlink = '',
              symlink_open = '',
            },
            git = {
              unstaged = '✗',
              staged = '✓',
              unmerged = '',
              renamed = '➜',
              untracked = '★',
              deleted = '',
              ignored = '◌',
            },
          },
        },
        special_files = { 'Cargo.toml', 'Makefile', 'README.md', 'readme.md' },
        symlink_destination = true,
      },

      -- Update focused file
      update_focused_file = {
        enable = false,
        update_cwd = false,
        ignore_list = {},
      },

      -- System open
      system_open = {
        cmd = '',
        args = {},
      },

      -- Diagnostics
      diagnostics = {
        enable = false,
        show_on_dirs = false,
        debounce_delay = 50,
        icons = {
          hint = '',
          info = '',
          warning = '',
          error = '',
        },
      },

      -- Filtering
      filters = {
        dotfiles = false,
        custom = {},
        exclude = {},
      },

      -- Filesystem watchers
      filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
        ignore_dirs = {},
      },

      -- Git integration
      git = {
        enable = true,
        ignore = true,
        show_on_dirs = true,
        timeout = 400,
      },

      -- Actions
      actions = {
        use_system_clipboard = true,
        change_dir = {
          enable = true,
          global = false,
          restrict_above_cwd = false,
        },
        expand_all = {
          max_folder_discovery = 300,
          exclude = {},
        },
        file_popup = {
          open_win_config = {
            col = 1,
            row = 1,
            relative = 'cursor',
            border = 'shadow',
            style = 'minimal',
          },
        },
        open_file = {
          quit_on_open = false,
          resize_window = true,
          window_picker = {
            enable = true,
            picker = 'default',
            chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890',
            exclude = {
              filetype = { 'notify', 'packer', 'qf', 'diff', 'fugitive', 'fugitiveblame' },
              buftype = { 'nofile', 'terminal', 'help' },
            },
          },
        },
        remove_file = {
          close_window = true,
        },
      },

      -- Trash configuration
      trash = {
        cmd = 'gio trash',
        require_confirm = true,
      },

      -- Live filter
      live_filter = {
        prefix = '[FILTER]: ',
        always_show_folders = true,
      },

      -- Tab configuration
      tab = {
        sync = {
          open = false,
          close = false,
          ignore = {},
        },
      },

      -- Notification configuration
      notify = {
        threshold = vim.log.levels.INFO,
      },

      -- Log configuration
      log = {
        enable = false,
        truncate = false,
        types = {
          all = false,
          config = false,
          copy_paste = false,
          dev = false,
          diagnostics = false,
          git = false,
          profile = false,
          watcher = false,
        },
      },
    }
  end,
}

