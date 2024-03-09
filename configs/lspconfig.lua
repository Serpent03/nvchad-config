local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local lspconfig = require "lspconfig"

local function get_python_path(workspace)
  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end

  -- Find and use virtualenv via poetry in workspace directory.
  local match = vim.fn.glob(path.join(workspace, "poetry.lock"))
  if match ~= "" then
    local venv = vim.fn.trim(vim.fn.system("poetry env info -p"))
    return path.join(venv, "bin", "python")
  end

  -- Fallback to system Python.
  return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

-- if you just want default config for the servers then put them in a table
local servers = { "html", "cssls", "tsserver", "clangd", "asm_lsp", "jdtls" }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

lspconfig.rust_analyzer.setup({
    on_attach=on_attach,
    settings = {
        ["rust-analyzer"] = {
            cargo = {
              allfeatures = true
            },
        }
    }
})

lspconfig.pylsp.setup({
    on_init = function(client)
        local pythonPath = get_python_path(client.config.root_dir)
        client.config.settings.python.pythonPath = pythonPath
    end,
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "python" },
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = { enabled = false },
                flake8 = { enabled = false, maxLineLength = 120, ignore                 = { "E501,F401" } },
                pyflakes = { enabled = false, maxLineLength = 120 },
                ruff = { enabled = false },
                mccabe = { enabled = true },
                pylint = { enabled = false },
                jedi_signature_help = { enabled = true },
                jedi_completion = {
                    include_params = true,
                    fuzzy = true,
                },
                jedi = {
                    extra_paths = {
                        "<home_dir>/.local/lib/python3.10/",
                        "/usr/lib/python3.11/site-packages/",
                    },
                },
            },
        },
    },
})

lspconfig.asm_lsp.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  command = "asm-lsp",
  filetypes = { "asm", "fas", "s", "S" }
})
-- lspconfig.pyright.setup { blabla}
