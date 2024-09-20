local wezterm = require("wezterm")

local function italic(data)
	data = data or {}
	local conf = {
		family = "Cascadia Code PL",
		style = "Italic",
		harfbuzz_features = { "+ss01" },
	}
	for k, v in pairs(data) do
		conf[k] = v
	end
	return wezterm.font(conf)
end

local function basename(s)
	s = s or ""
	local ret = string.gsub(s, "(.*[/\\])(.*)", "%2")
	return ret or ""
end

local function is_local_domain(pane)
	return pane:get_domain_name() == "local"
end

local function process_name(pane)
	if is_local_domain(pane) then
		local name = pane:get_foreground_process_name()
		return basename(name)
	end

	local title = pane:get_title()

	local first = title:sub(1, 1)
	if first == "/" or first == "~" then
		return ""
	end

	local nvim_title = " - NVIM"
	if title:sub(-#nvim_title) == nvim_title then
		return "nvim"
	end

	return title:match("([^ ]*)")
end

local function is_vim(pane)
	return process_name(pane):find("n?vim") ~= nil
end

local function active_pane_info(win)
	local mux_tab = win:active_tab()

	if mux_tab == nil then
		wezterm.log_warn("smart_split: couldn't find tab")
		return
	end

	for _, item in ipairs(mux_tab:panes_with_info()) do
		if item.is_active then
			return item
		end
	end
end

local function move_around(win, pane, direction_wez, direction_nvim)
	if pane:tab():get_pane_direction(direction_wez) == nil then
		win:perform_action(wezterm.action.SendKey({ mods = "CTRL", key = direction_nvim }), pane)
		return
	end

	local name = process_name(pane)

	if is_vim(pane) or name == "ssh" or name == "gcloud" or name == "et" then
		win:perform_action(wezterm.action.SendKey({ mods = "CTRL", key = direction_nvim }), pane)
		return
	end

	win:perform_action(wezterm.action.ActivatePaneDirection(direction_wez), pane)
end

local function resize(win, pane, direction_wez, direction_nvim)
	local name = process_name(pane)

	if is_vim(pane) or name == "ssh" or name == "gcloud" or name == "et" then
		win:perform_action(wezterm.action.SendString("\x01" .. direction_nvim), pane)
		return
	end

	-- TODO(jawa) AdjustPaneSize shouldn't require a table, but plain args don't work
	win:perform_action(wezterm.action.AdjustPaneSize({ direction_wez, 1 }), pane)
end

local function smart_split(win, pane, domain)
	local info = active_pane_info(win)

	if info == nil then
		wezterm.log_warn("smart_split: couldn't find pane")
		return
	end

	if info.pixel_width > info.pixel_height then
		win:perform_action(wezterm.action.SplitHorizontal({ domain = domain }), pane)
	else
		win:perform_action(wezterm.action.SplitVertical({ domain = domain }), pane)
	end
end

wezterm.on("update-right-status", function(win, pane)
	local date = wezterm.strftime("%a %d %b %l:%M:%S %P ")
	win:set_right_status(wezterm.format({ { Text = wezterm.nerdfonts.mdi_clock .. " " .. date } }))
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = (tab.tab_index + 1) .. ": "
	if tab.active_pane and tab.active_pane.domain_name and tab.active_pane.domain_name ~= "local" then
		title = title .. "(" .. tab.active_pane.domain_name .. ") "
	end
	title = title .. tab.active_pane.title
	return { { Text = title } }
end)

wezterm.on("user-var-changed", function(window, pane, name, value)
	local overrides = window:get_config_overrides() or {}
	if name == "ZEN_MODE" then
		local incremental = value:find("+")
		local number_value = tonumber(value)
		if incremental ~= nil then
			while number_value > 0 do
				window:perform_action(wezterm.action.IncreaseFontSize, pane)
				number_value = number_value - 1
			end
			overrides.enable_tab_bar = false
		elseif number_value < 0 then
			window:perform_action(wezterm.action.ResetFontSize, pane)
			overrides.font_size = nil
			overrides.enable_tab_bar = true
		else
			overrides.font_size = number_value
			overrides.enable_tab_bar = false
		end
	end
	window:set_config_overrides(overrides)
end)

return {
	font = wezterm.font("JetBrainsMono Nerd Font"),
	font_rules = {
		{
			italic = true,
			font = italic(),
		},
		{
			intensity = "Normal",
			italic = true,
			font = italic(),
		},
		{
			intensity = "Bold",
			italic = true,
			font = italic({
				weight = "Bold",
			}),
		},
	},
	window_frame = {
		font = wezterm.font({
			family = "Helvetica Neue",
			weight = "Bold",
		}),
	},
	disable_default_key_bindings = true,
	keys = {
		{ mods = "CMD", key = "o", action = "ShowLauncher" },

		-- copy/paste
		{ mods = "SUPER", key = "c", action = wezterm.action.CopyTo("Clipboard") },
		{ mods = "SUPER", key = "v", action = wezterm.action.PasteFrom("Clipboard") },
		{ mods = "CTRL|SHIFT", key = "C", action = wezterm.action.CopyTo("Clipboard") },
		{ mods = "CTRL|SHIFT", key = "V", action = wezterm.action.PasteFrom("Clipboard") },
		{ key = "Copy", action = wezterm.action.CopyTo("Clipboard") },
		{ key = "Paste", action = wezterm.action.PasteFrom("Clipboard") },
		{ mods = "CTRL", key = "Insert", action = wezterm.action.CopyTo("PrimarySelection") },
		{ mods = "SHIFT", key = "Insert", action = wezterm.action.PasteFrom("PrimarySelection") },
		{
			mods = "CTRL",
			key = "c",
			action = wezterm.action_callback(function(win, pane)
				if win:get_selection_text_for_pane(pane) ~= "" then
					win:perform_action(wezterm.action.CopyTo("ClipboardAndPrimarySelection"), pane)
					win:perform_action(wezterm.action.ClearSelection, pane)
				else
					win:perform_action(wezterm.action.SendKey({ mods = "CTRL", key = "c" }), pane)
				end
			end),
		},

		-- window management
		{ mods = "SUPER", key = "m", action = "Hide" },
		{ mods = "SUPER", key = "n", action = "SpawnWindow" },
		{ mods = "CTRL|SHIFT", key = "N", action = "SpawnWindow" },
		{ mods = "ALT", key = "Enter", action = "ToggleFullScreen" },
		{ mods = "SUPER|SHIFT", key = "F", action = "ToggleFullScreen" },

		-- font size
		{ mods = "SUPER", key = "-", action = "DecreaseFontSize" },
		{ mods = "CTRL", key = "-", action = "DecreaseFontSize" },
		{ mods = "SUPER", key = "=", action = "IncreaseFontSize" },
		{ mods = "CTRL", key = "=", action = "IncreaseFontSize" },
		{ mods = "SUPER", key = "0", action = "ResetFontSize" },
		{ mods = "CTRL", key = "0", action = "ResetFontSize" },

		-- new tab
		{ mods = "SUPER", key = "t", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
		{ mods = "CTRL|SHIFT", key = "T", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
		{ mods = "SUPER|SHIFT", key = "T", action = wezterm.action.SpawnTab("DefaultDomain") },

		-- select specific tab
		{ mods = "SUPER", key = "w", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
		{ mods = "SUPER", key = "1", action = wezterm.action.ActivateTab(0) },
		{ mods = "SUPER", key = "2", action = wezterm.action.ActivateTab(1) },
		{ mods = "SUPER", key = "3", action = wezterm.action.ActivateTab(2) },
		{ mods = "SUPER", key = "4", action = wezterm.action.ActivateTab(3) },
		{ mods = "SUPER", key = "5", action = wezterm.action.ActivateTab(4) },
		{ mods = "SUPER", key = "6", action = wezterm.action.ActivateTab(5) },
		{ mods = "SUPER", key = "7", action = wezterm.action.ActivateTab(6) },
		{ mods = "SUPER", key = "8", action = wezterm.action.ActivateTab(7) },
		{ mods = "SUPER", key = "9", action = wezterm.action.ActivateTab(-1) },

		-- select specific tab
		{ mods = "CTRL|SHIFT", key = "W", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
		{ mods = "CTRL|SHIFT", key = "!", action = wezterm.action.ActivateTab(0) },
		{ mods = "CTRL|SHIFT", key = "@", action = wezterm.action.ActivateTab(1) },
		{ mods = "CTRL|SHIFT", key = "#", action = wezterm.action.ActivateTab(2) },
		{ mods = "CTRL|SHIFT", key = "$", action = wezterm.action.ActivateTab(3) },
		{ mods = "CTRL|SHIFT", key = "%", action = wezterm.action.ActivateTab(4) },
		{ mods = "CTRL|SHIFT", key = "^", action = wezterm.action.ActivateTab(5) },
		{ mods = "CTRL|SHIFT", key = "&", action = wezterm.action.ActivateTab(6) },
		{ mods = "CTRL|SHIFT", key = "*", action = wezterm.action.ActivateTab(7) },
		{ mods = "CTRL|SHIFT", key = "(", action = wezterm.action.ActivateTab(-1) },

		-- select relative tab
		{ mods = "CTRL|SHIFT", key = "Tab", action = wezterm.action.ActivateTabRelative(-1) },
		{ mods = "CTRL", key = "PageUp", action = wezterm.action.ActivateTabRelative(-1) },
		{ mods = "CTRL", key = "Tab", action = wezterm.action.ActivateTabRelative(1) },
		{ mods = "CTRL", key = "PageDown", action = wezterm.action.ActivateTabRelative(1) },

		-- move tab
		{ mods = "CTRL|SHIFT", key = "PageUp", action = wezterm.action.MoveTabRelative(-1) },
		{ mods = "CTRL|SHIFT", key = "PageDown", action = wezterm.action.MoveTabRelative(1) },
		{ mods = "SUPER|SHIFT", key = "{", action = wezterm.action.MoveTabRelative(-1) },
		{ mods = "SUPER|SHIFT", key = "}", action = wezterm.action.MoveTabRelative(1) },

		-- scrolling
		{ mods = "SHIFT", key = "PageUp", action = wezterm.action.ScrollByPage(-1) },
		{ mods = "SHIFT", key = "PageDown", action = wezterm.action.ScrollByPage(1) },
		{ mods = "SUPER", key = "u", action = wezterm.action.ScrollByPage(-1) },
		{ mods = "SUPER", key = "d", action = wezterm.action.ScrollByPage(1) },

		{ mods = "SUPER", key = "y", action = wezterm.action.ScrollByLine(-1) },
		{ mods = "SUPER", key = "e", action = wezterm.action.ScrollByLine(1) },

		{ mods = "SHIFT", key = "UpArrow", action = wezterm.action.ScrollToPrompt(-1) },
		{ mods = "SHIFT", key = "DownArrow", action = wezterm.action.ScrollToPrompt(1) },

		{ mods = "SHIFT", key = "UpArrow", action = wezterm.action.ScrollToPrompt(-1) },
		{ mods = "SHIFT", key = "DownArrow", action = wezterm.action.ScrollToPrompt(1) },

		{ mods = "SUPER", key = "[", action = wezterm.action.ScrollToPrompt(-1) },
		{ mods = "SUPER", key = "]", action = wezterm.action.ScrollToPrompt(1) },

		-- reload config
		{ mods = "SUPER", key = "r", action = "ReloadConfiguration" },
		{ mods = "CTRL|SHIFT", key = "R", action = "ReloadConfiguration" },

		{ mods = "CTRL|SHIFT", key = "D", action = "ShowDebugOverlay" },

		-- search
		{ mods = "SUPER", key = "f", action = wezterm.action.Search({ CaseSensitiveString = "" }) },
		{ mods = "CTRL|SHIFT", key = "F", action = wezterm.action.Search({ CaseSensitiveString = "" }) },

		{ mods = "CTRL|SHIFT", key = "X", action = "ActivateCopyMode" },
		{ mods = "CTRL|SHIFT", key = "Space", action = "QuickSelect" },

		-- splits
		{
			mods = "SUPER",
			key = "Enter",
			action = wezterm.action_callback(function(win, pane)
				smart_split(win, pane, "CurrentPaneDomain")
			end),
		},
		{
			mods = "SUPER|SHIFT",
			key = "Enter",
			action = wezterm.action_callback(function(win, pane)
				smart_split(win, pane, "DefaultDomain")
			end),
		},
		-- {
		-- 	mods = "SUPER",
		-- 	key = "\\",
		-- 	action = wezterm.action_callback(function(win, pane)
		-- 		win:perform_action(wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }), pane)
		-- 	end),
		-- },
		-- {
		-- 	mods = "SUPER|SHIFT",
		-- 	key = "|",
		-- 	action = wezterm.action_callback(function(win, pane)
		-- 		win:perform_action(wezterm.action.SplitHorizontal({ domain = "DefaultDomain" }), pane)
		-- 	end),
		-- },

		{ mods = "SUPER", key = ",", action = wezterm.action.RotatePanes("CounterClockwise") },
		{ mods = "SUPER", key = ".", action = wezterm.action.RotatePanes("Clockwise") },

		-- resize panes
		{ mods = "CTRL|SHIFT|ALT", key = "LeftArrow", action = wezterm.action.AdjustPaneSize({ "Left", 1 }) },
		{ mods = "CTRL|SHIFT|ALT", key = "RightArrow", action = wezterm.action.AdjustPaneSize({ "Right", 1 }) },
		{ mods = "CTRL|SHIFT|ALT", key = "UpArrow", action = wezterm.action.AdjustPaneSize({ "Up", 1 }) },
		{ mods = "CTRL|SHIFT|ALT", key = "DownArrow", action = wezterm.action.AdjustPaneSize({ "Down", 1 }) },

		{
			mods = "CTRL|SHIFT",
			key = "H",
			action = wezterm.action_callback(function(win, pane)
				resize(win, pane, "Left", "H")
			end),
		},
		{
			mods = "CTRL|SHIFT",
			key = "J",
			action = wezterm.action_callback(function(win, pane)
				resize(win, pane, "Down", "J")
			end),
		},
		{
			mods = "CTRL|SHIFT",
			key = "K",
			action = wezterm.action_callback(function(win, pane)
				resize(win, pane, "Up", "K")
			end),
		},
		{
			mods = "CTRL|SHIFT",
			key = "L",
			action = wezterm.action_callback(function(win, pane)
				resize(win, pane, "Right", "L")
			end),
		},

		-- select pane
		{ mods = "CTRL|SHIFT", key = "LeftArrow", action = wezterm.action.ActivatePaneDirection("Left") },
		{ mods = "CTRL|SHIFT", key = "RightArrow", action = wezterm.action.ActivatePaneDirection("Right") },
		{ mods = "CTRL|SHIFT", key = "UpArrow", action = wezterm.action.ActivatePaneDirection("Up") },
		{ mods = "CTRL|SHIFT", key = "DownArrow", action = wezterm.action.ActivatePaneDirection("Down") },

		{ mods = "SUPER", key = "[", action = wezterm.action.ActivatePaneDirection("Left") },
		{ mods = "SUPER", key = "h", action = wezterm.action.ActivatePaneDirection("Left") },
		{ mods = "SUPER", key = "j", action = wezterm.action.ActivatePaneDirection("Down") },
		{ mods = "SUPER", key = "k", action = wezterm.action.ActivatePaneDirection("Up") },
		{ mods = "SUPER", key = "l", action = wezterm.action.ActivatePaneDirection("Right") },
		{ mods = "SUPER", key = "]", action = wezterm.action.ActivatePaneDirection("Right") },

		{
			mods = "CTRL",
			key = "h",
			action = wezterm.action_callback(function(win, pane)
				move_around(win, pane, "Left", "h")
			end),
		},
		{
			mods = "CTRL",
			key = "j",
			action = wezterm.action_callback(function(win, pane)
				move_around(win, pane, "Down", "j")
			end),
		},
		{
			mods = "CTRL",
			key = "k",
			action = wezterm.action_callback(function(win, pane)
				move_around(win, pane, "Up", "k")
			end),
		},
		{
			mods = "CTRL",
			key = "l",
			action = wezterm.action_callback(function(win, pane)
				move_around(win, pane, "Right", "l")
			end),
		},

		{ mods = "CMD", key = "z", action = "TogglePaneZoomState" },
		{ mods = "SUPER", key = "x", action = wezterm.action.DetachDomain("CurrentPaneDomain") },
	},
	key_tables = {
		search_mode = {
			{ key = "Escape", action = wezterm.action.CopyMode("Close") },
			{ key = "UpArrow", action = wezterm.action.CopyMode("PriorMatch") },
			{ key = "Enter", action = wezterm.action.CopyMode("PriorMatch") },
			{ mods = "CTRL", key = "p", action = wezterm.action.CopyMode("PriorMatch") },
			{ key = "PageUp", action = wezterm.action.CopyMode("PriorMatchPage") },
			{ key = "PageDown", action = wezterm.action.CopyMode("NextMatchPage") },
			{ mods = "CTRL", key = "n", action = wezterm.action.CopyMode("NextMatchPage") },
			{ key = "DownArrow", action = wezterm.action.CopyMode("NextMatch") },
			{ mods = "CTRL", key = "r", action = wezterm.action.CopyMode("CycleMatchType") },
			{ mods = "CTRL", key = "u", action = wezterm.action.CopyMode("ClearPattern") },
		},
	},
	audible_bell = "SystemBeep",
	visual_bell = {
		fade_in_function = "Constant",
		fade_in_duration_ms = 0,
		fade_out_function = "EaseOut",
		fade_out_duration_ms = 500,
		target = "CursorColor",
	},
	color_schemes = {
		["Gruvbox Dark Hard"] = {
			foreground = "#d5c4a1",
			background = "#1d2021",
			cursor_bg = "#d5c4a1",
			cursor_border = "#d5c4a1",
			cursor_fg = "#1d2021",
			selection_bg = "#d5c4a1",
			selection_fg = "#3c3836",
			visual_bell = "#cc241d",

			ansi = {
				"#1d2021",
				"#cc241d",
				"#98971a",
				"#d79921",
				"#458588",
				"#b16286",
				"#689d6a",
				"#a89984",
			},
			brights = {
				"#928374",
				"#fb4934",
				"#b8bb26",
				"#fabd2f",
				"#83a598",
				"#d3869b",
				"#8ec07c",
				"#d5c4a1",
			},
		},
	},
	inactive_pane_hsb = {
		saturation = 0.4,
		brightness = 0.4,
	},
	color_scheme = "Gruvbox Dark Hard",
	use_fancy_tab_bar = true,
	bold_brightens_ansi_colors = true,
	default_cursor_style = "SteadyBlock",
	hide_tab_bar_if_only_one_tab = false,
	enable_wayland = true,
	automatically_reload_config = true,
	exit_behavior = "CloseOnCleanExit",
	front_end = "OpenGL",
	initial_cols = 80,
	initial_rows = 24,
	term = "wezterm",
	check_for_updates = true,
	check_for_updates_interval_seconds = 86400,
	enable_scroll_bar = true,
	native_macos_fullscreen_mode = false,
	pane_focus_follows_mouse = true,
	quote_dropped_files = "SpacesOnly",
	scroll_to_bottom_on_input = true,
	scrollback_lines = 3500,
	selection_word_boundary = " \t\n{}[]()\"'`",
	show_tab_index_in_tab_bar = true,
	skip_close_confirmation_for_processes_named = {
		"bash",
		"fish",
		"sh",
		"tmux",
		"zsh",
	},
	status_update_interval = 25,
	treat_east_asian_ambiguous_width_as_wide = false,
	unicode_version = 9,
	use_ime = true,
	unzoom_on_switch_pane = true,
	use_resize_increments = false,
	warn_about_missing_glyphs = true,
	window_decorations = "TITLE | RESIZE",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	ssh_backend = "LibSsh",
	ssh_domains = {
		{
			name = "balerion",
			remote_address = "balerion",
			username = "jrubin",
			assume_shell = "Posix",
		},
	},
}
