-- ALE Configuration
vim.g.ale_linters = {
	python = {
		"mypy",
		"flake8",
		"pycln",
		-- "pydocstyle"
	},
	lua = {
		"selene",
		-- 'luacheck'
		-- 'lua_language_server'
	},
}

vim.g.ale_fixers = {
	python = {
		"add_blank_lines_for_python_control_statements", -- Add blank lines before control statements.
		"autoflake", -- Fix flake issues with autoflake.
		-- "autoimport", -- Fix import issues with autoimport.
		"autopep8", -- Fix PEP8 issues with autopep8.
		-- 'black', -- Fix PEP8 issues with black.
		"isort", -- Sort Python imports with isort.
		"pycln", -- remove unused python import statements
		-- 'pyflyby', -- Tidy Python imports with pyflyby.
		"remove_trailing_lines", -- Remove all blank lines at the end of a file.
		-- 'reorder-python-imports', -- Sort Python imports with reorder-python-imports.
		-- 'ruff', -- A python linter/fixer for Python written in Rust
		"trim_whitespace", -- Remove all trailing whitespace characters at the end of every line.
		-- 'yapf', -- Fix Python files with yapf.
	},
	lua = {
		"stylua",
		"remove_trailing_lines", -- Remove all blank lines at the end of a file.
		"trim_whitespace", -- Remove all trailing whitespace characters at the end of every line.
	},
}

-- Ale config

vim.g.ale_python_flake8_options = "--max-line-length 100"
vim.g.ale_python_isort_options = ""
-- vim.g.ale_python_isort_options = "-l 100 --top false --use-parenthesis"
vim.g.ale_sign_error = "E"
vim.g.ale_sign_warning = "W"
vim.g.ale_echo_msg_error_str = "E"
vim.g.ale_echo_msg_warning_str = "W"
vim.g.ale_echo_msg_format = "[%linter%] %s [%severity%]"
vim.g.ale_fix_on_save = 1
vim.g.ale_disable_lsp = 1
--
