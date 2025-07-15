return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({
      -- Disable netrw at the very start of your init.lua
      disable_netrw = true,
      hijack_netrw = true,
      
      -- Configure the tree view
      view = {
        width = 30,
        side = "left",
      },
      
      -- Renderer configuration
      renderer = {
        add_trailing = false,
        group_empty = false,
        highlight_git = false,
        full_name = false,
        highlight_opened_files = "none",
        root_folder_modifier = ":~",
        indent_width = 2,
        indent_markers = {
          enable = false,
          inline_arrows = true,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
          },
        },
        icons = {
          webdev_colors = true,
          git_placement = "before",
          padding = " ",
          symlink_arrow = " ➛ ",
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
          glyphs = {
            default = "",
            symlink = "",
            bookmark = "",
            folder = {
              arrow_closed = "",
              arrow_open = "",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
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
        cmd = "",
        args = {},
      },
      
      -- Diagnostics
      diagnostics = {
        enable = false,
        show_on_dirs = false,
        debounce_delay = 50,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
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
            relative = "cursor",
            border = "shadow",
            style = "minimal",
          },
        },
        open_file = {
          quit_on_open = false,
          resize_window = true,
          window_picker = {
            enable = true,
            picker = "default",
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
        remove_file = {
          close_window = true,
        },
      },
      
      -- Trash configuration
      trash = {
        cmd = "gio trash",
        require_confirm = true,
      },
      
      -- Live filter
      live_filter = {
        prefix = "[FILTER]: ",
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
    })

    -- Key mappings for nvim-tree
    vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file [E]xplorer' })
    vim.keymap.set('n', '<leader>ef', ':NvimTreeFindFileToggle<CR>', { desc = 'Toggle file explorer and [F]ind current file' })
  end,
}