return {
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000,
    opts = {
      setup = {
        ["@lsp.type.namespace.cpp"] = {
          guifg = "#e5c07b",
        },
        ["@lsp.typemod.function.defaultLibrary.cpp"] = {
          guifg = "#54B4C2",
        },
        ["@constant.builtin.cpp"] = {
          guifg = "#d19167",
        },
        ["@lsp.typemod.method.defaultLibrary.cpp"] = {
          guifg = "#61afef",
        },
        ["@type.builtin.cpp"] = {
          guifg = "#c678dd",
        },
        ["@type.qualifier.cpp"] = {
          guifg = "#c678dd",
        },
        ["@operator.cpp"] = {
          guifg = "none",
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
    },
  },
  {
    "echasnovski/mini.indentscope",
    opts = {
      mappings = {
        -- Textobjects
        object_scope = "hh",
        object_scope_with_border = "ah",

        -- Motions (jump to respective border line; if not present - body line)
        goto_top = "[h",
        goto_bottom = "]h",
      },
    },
  },
  {
    "folke/which-key.nvim",
    enabled = true,
    opts = {},
  },
  {
    "echasnovski/mini.comment",
    opts = {
      mappings = {
        comment = "gc",
        comment_line = "gl",
        textobject = "gc",
      },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

    -- stylua: ignore start
    map("n", "]h", gs.next_hunk, "Next Hunk")
    map("n", "[h", gs.prev_hunk, "Prev Hunk")
    map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
    map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
    map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
    map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
    map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
    map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
    map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
    map("n", "<leader>ghd", gs.diffthis, "Diff This")
    map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
    map({ "o", "x" }, "hh", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        -- "flake8",
      },
      ui = {
        keymaps = {
          install_package = "h",
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = { "K", false }
      keys[#keys + 1] = { "gh", vim.lsp.buf.hover }
    end,
    opts = {
      servers = {
        -- Ensure mason installs the server
        clangd = {
          keys = {
            { "<A-o>", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
          },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern(
              "Makefile",
              "configure.ac",
              "configure.in",
              "config.h.in",
              "meson.build",
              "meson_options.txt",
              "build.ninja"
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              fname
            ) or require("lspconfig.util").find_git_ancestor(fname)
          end,
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=never",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = true,
          },
        },
        pyright = {},
      },
      setup = {
        clangd = function(_, opts)
          local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
          require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
          return false
        end,
      },
      inlay_hints = {
        enabled = false,
      },
      diagnostics = {
        virtual_text = false,
        signs = false,
      },
    },
  },
  {
    "echasnovski/mini.surround",
    ops = {
      mappings = {
        add = "ys",
        delete = "ds",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "cs",
        update_n_lines = "gsn",
      },
    },
  },
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
  {
    "echasnovski/mini.comment",
    enabled = false,
  },
  {
    "numToStr/Comment.nvim",
    vscode = true,
    opts = {
      ---Add a space b/w comment and the line
      padding = true,
      ---Whether the cursor should stay at its position
      sticky = true,
      ---Lines to be ignored while (un)comment
      ignore = nil,
      ---LHS of toggle mappings in NORMAL mode
      toggler = {
        ---Line-comment toggle keymap
        line = "gl",
        ---Block-comment toggle keymap
        block = "gbc",
      },
      ---LHS of operator-pending mappings in NORMAL and VISUAL mode
      opleader = {
        ---Line-comment keymap
        line = "gl",
        ---Block-comment keymap
        block = "gb",
      },
      ---LHS of extra mappings
      extra = {
        ---Add comment on the line above
        above = "gcO",
        ---Add comment on the line below
        below = "gco",
        ---Add comment at the end of line
        eol = "gcA",
      },
      ---Enable keybindings
      ---NOTE: If given `false` then the plugin won't create any mappings
      mappings = {
        ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
        basic = true,
        ---Extra mapping; `gco`, `gcO`, `gcA`
        extra = true,
      },
      ---Function to call before (un)comment
      pre_hook = nil,
      ---Function to call after (un)comment
      post_hook = nil,
    },
    lazy = false,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["i"] = "none",
          ["h"] = "show_file_details",
        },
      },
    },
  },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      -- vim.cmd("highlight default link gitblame SpecialComment")
      vim.g.gitblame_enabled = 0
      vim.g.gitblame_message_template = "      <author>, <date> • <summary>"
      vim.g.gitblame_date_format = "%r"
      vim.g.gitblame_delay = 500
      vim.g.gitblame_use_blame_commit_file_urls = true
    end,
  },
  {
    "sustech-data/wildfire.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("wildfire").setup()
    end,
  },
  { "echasnovski/mini.nvim", version = false },
  {
    "folke/trouble.nvim",
    opts = {
      use_diagnostic_signs = true,
      action_keys = {
        previous = "i",
        next = "k",
      },
    },
  },
  {
    "joechrisellis/lsp-format-modifications.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      { "nvim-telescope/telescope-live-grep-args.nvim" },
    },
    config = function()
      require("telescope").load_extension("live_grep_args")
    end,
    opts = {
      defaults = {
        file_ignore_patterns = { ".git/", ".repo*", "toolchain*", "*.ascii" },
      },
    },
    keys = {
      {
        "<leader>/",
        function()
          -- https://github.com/nvim-telescope/telescope-live-grep-args.nvim
          -- Uses ripgrep args (rg) for live_grep
          -- Command examples:
          -- -i "Data"  # case insensitive
          -- -g "!*.md" # ignore md files
          -- -w # whole word
          -- -e # regex
          -- see 'man rg' for more
          require("telescope").extensions.live_grep_args.live_grep_args() -- see arguments given in extensions config
        end,
        desc = "Live Grep (Args)",
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    -- tag = "v4.5.2",
    opts = {
      options = {
        truncate_names = false, -- whether or not tab names should be truncated
      },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      sections = {
        lualine_c = { { "filename", path = 1 } },
      },
    },
  },
  {
    "folke/snacks.nvim",
    ---@type snacks.Config
    opts = {
      scope = {
        enabled = false,
      },
      picker = {
        sources = {
          explorer = {
            win = {
              list = {
                keys = {
                  ["j"] = "explorer_close", -- close directory
                  ["h"] = "focus_input",
                },
              },
            },
          },
        },
        win = {
          -- input window
          input = {
            keys = {
              -- to close the picker on ESC instead of going to normal mode,
              -- add the following keymap to your config
              -- ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["j"] = false,
              ["k"] = "list_down",
              ["i"] = "list_up",
            },
          },
          -- result list window
          list = {
            keys = {
              ["h"] = "focus_input",
              ["k"] = "list_down",
              ["i"] = "list_up",
              ["j"] = false,
            },
          },
          -- preview window
          preview = {
            keys = {
              ["h"] = "focus_input",
              ["i"] = false,
            },
          },
        },
      },
    },
  },
  {
    "echasnovski/mini.ai",
    opts = {
      mappings = {
        -- Main textobject prefixes
        around = "a",
        inside = "h",

        -- Next/last variants
        -- NOTE: These override built-in LSP selection mappings on Neovim>=0.12
        -- Map LSP selection manually to use it (see `:h MiniAi.config`)
        around_next = "an",
        inside_next = "hn",
        around_last = "al",
        inside_last = "hl",
      },
    },
  },
  {
    "sindrets/diffview.nvim",
  },
  {
    "mfussenegger/nvim-dap-python",
    -- stylua: ignore
    keys = {
      { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
      { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
    },
    config = function()
      -- if vim.fn.has("win32") == 1 then
      --   require("dap-python").setup(LazyVim.get_pkg_path("debugpy", "/venv/Scripts/pythonw.exe"))
      -- else
      --   require("dap-python").setup(LazyVim.get_pkg_path("debugpy", "/venv/bin/python"))
      -- end
      require("dap-python").setup("/usr/bin/python")
      local dap = require("dap")
      dap.configurations.python = dap.configurations.python or {}
    end,
  },
  {
    "LiadOz/nvim-dap-repl-highlights",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-dap-repl-highlights").setup() -- must be setup before nvim-treesitter
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
        indent = {
          enable = true,
          disable = {},
        },
        ensure_installed = {
          "bash",
          "luadoc",
          "json",
          "markdown",
          "regex",
          "vim",
          "vimdoc",
          "lua",
          "python",
          "typescript",
          "html",
          "javascript",
          "tsx",
          "scss",
          "rust",
          "c",
          "dap_repl",
          "yaml",
        },
      })
      vim.o.foldexpr = "nvim_treesitter#foldexpr()"
    end,
  },
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<A-d>",
        function()
          local mode = vim.fn.mode()
          local text
          if mode == "v" or mode == "V" then
            local lines = vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"))
            text = table.concat(lines, "\n")
          else
            text = vim.api.nvim_get_current_line()
          end
          require("dap").repl.execute(text)
        end,
        mode = { "n", "x" },
        desc = "Evaluate line/selection in Debug REPL",
      },
    },
  },
}

