if vim.g.vscode then
    -- VSCode extension
else
    -- ordinary Neovim
    require('config.options')
    require('config.keybinds')
    require('config.autocmds')
    require('utils.diagnostics')
    require('config.lazy')
end
