return {
    "rmagatti/auto-session",
    config = function()
        local auto_session = require("auto-session")

        auto_session.setup({
			auto_session_enabled        = true,
			auto_save_enabled           = true,
			auto_restore_enabled        = true,
			bypass_session_save_file_types = { "alpha", "dashboard" },
			pre_save_cmds = { "Neotree close" },
			post_restore_cmds = { "Neotree show" },
        })

    end,
}
