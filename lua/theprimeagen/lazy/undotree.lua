return {
    "mbbill/undotree",
    config = function()
        vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle,
            {desc='toggle [u]ndotree'}
        )
    end
}
