return {
    {
      "olimorris/codecompanion.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "codecompanion" } },
      },
        config = function()
            require("codecompanion").setup({
              adapters = {
                openai_compatible = function()
                  return require("codecompanion.adapters").extend("openai_compatible", {
                    env = {
                      api_key = "OPENROUTER_API_KEY",
                      url = "https://openrouter.ai/api",
                      chat_url = "v1/chat/completions",
                    },
                    schema = {
                      model = {
                        default = "meta-llama/llama-3.3-70b-instruct",
                      }
                    },
                  })
                end,
             },
            strategies = {
                chat = {
                adapter = "openai_compatible",
                show_header_separator = false,
                },
                inline = {
                adapter = "openai_compatible",
                },
            },
            })
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "nvim-telescope/telescope-file-browser.nvim",
        },
        config = function()
            local telescope = require("telescope")
            telescope.setup {
                pickers = {
                    find_files = {
                        layout_strategy = "horizontal",
                        previewer = true,
                    },
                    live_grep = {
                        layout_strategy = "horizontal",
                        previewer = true,
                    },
                },
                extensions = {
                    fzf = {
                        layout_strategy = "horizontal",
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                    file_browser = {
                        hijack_netrw = true,
                        layout_strategy = "horizontal",
                        layout_config = {
                        height = 0.9,
                        width = 0.9,
                    },
                    },
                },
            }
            telescope.load_extension("fzf")
            telescope.load_extension("file_browser")
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup({
                options = {
                    theme = 'ayu_mirage',
                    component_separators = '|',
                    section_separators = { left = '', right = '' },
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff' },
                    lualine_c = { 'filename' },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
            })
        end
    },
    {
        'Shatur/neovim-ayu',
        config = function()
            require('ayu').setup({
                mirage = true,
                overrides = {},
            })
            vim.cmd([[colorscheme ayu-mirage]])
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        version = false,
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "TSUpdateSync" },
        opts = {
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                "lua",
                "python",
                "go",
                "c",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<CR>",
                    node_incremental = "<CR>",
                    node_decremental = "<BS>",
                    scope_incremental = "<TAB>",
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "ray-x/cmp-treesitter",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping.select_next_item(),
                    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                }),
                sources = cmp.config.sources({
                    { name = "treesitter" }, -- from treesitter
                    { name = "buffer" },     -- from current buffer
                    { name = "path" },       -- file paths
                    { name = 'render-markdown' },
                }),
            })
        end
    },
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = function()
            require("toggleterm").setup({
                size = 15,
                open_mapping = [[<c-\>]], -- ctrl+\ to open terminal
                hide_numbers = true,
                shade_filetypes = {},
                shade_terminals = true,
                start_in_insert = true,
                insert_mappings = true,
                persist_size = true,
                direction = "horizontal",
                close_on_exit = true,
                shell = vim.o.shell,
            })
            -- Lazygit terminal
            local Terminal = require('toggleterm.terminal').Terminal
            local lazygit = Terminal:new({
                cmd = "lazygit",
                dir = "git_dir",
                direction = "float",
                on_open = function(term)
                    vim.cmd("startinsert!")
                    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
                end,
            })
            -- Make the toggle function global
            _G._lazygit_toggle = function()
                lazygit:toggle()
            end
        end
    },
    {
        'folke/which-key.nvim',
        event = 'VimEnter',
        opts = {
          spec = {
            { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
            { '<leader>d', group = '[D]ocument' },
            { '<leader>r', group = '[R]ename' },
            { '<leader>s', group = '[S]earch' },
            { '<leader>w', group = '[W]orkspace' },
            { '<leader>t', group = '[T]oggle' },
            { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
          },
    },
    },
}
