local config = vim.fn.expand("$HOME/.config/nvim")
local lazypath = config .. "/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--depth=1",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    }
end

vim.opt.rtp:prepend(lazypath)

require("options")
require("keymaps")

require("lazy").setup(require("plugins"), {
    root = vim.fn.expand("$HOME/.config/nvim/lazy_plugs"),
    lockfile = vim.fn.expand("$HOME/.config/nvim/lazy-lock.json"),
    git = {
        depth = 1,
    },
})

local Job = require('plenary.job')
local function run_build_script()
    local temp_file = "/tmp/build_output.txt"

    Job:new({
        command = "./build.sh",
        cwd = vim.fn.getcwd(),
        on_exit = function(job, return_val)
            local output = job:result()
            local err_output = job:stderr_result()

            local file = io.open(temp_file, "w")

            for _, line in ipairs(output) do
                file:write(line .. "\n")
            end

            for _, line in ipairs(err_output) do
                file:write(line .. "\n")
            end

            file:close()

            vim.schedule(function()
                vim.cmd("cfile " .. temp_file)

                if return_val == 0 then
                    print("Build successful!")
                else
                    print("Build failed with exit code: " .. return_val)
                end
            end)
        end,
    }):start()
end

vim.api.nvim_create_user_command(
    'RunBuild',
    run_build_script,
    { desc = 'Run the build script and populate quickfix list' }
)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.textwidth = 80
        --vim.opt_local.formatoptions:append("a")
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.colorcolumn = "82"
    end,
})

require('render-markdown').setup({
    heading = { sign = false },
})
