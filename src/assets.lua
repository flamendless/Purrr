local Assets = {}
local states = {}

function states.splash()
	return {
		images = {
			{ id = "flamendless", path = "assets/anim/flamendless.png" },
		},
		sources = {
			{ id = "sfx_transition", path = "assets/sounds/cat/deep_meow.ogg", kind = "stream" },
			{ id = "sfx_alert", path = "assets/sounds/sfx/alert.ogg", kind = "static" },
			{ id = "sfx_back", path = "assets/sounds/sfx/back.ogg", kind = "static" },
			{ id = "sfx_forward", path = "assets/sounds/sfx/forward.ogg", kind = "static" },
			{ id = "sfx_hover1", path = "assets/sounds/sfx/hover1.ogg", kind = "static" },
			{ id = "sfx_click1", path = "assets/sounds/sfx/click1.ogg", kind = "static" },
			{ id = "sfx_click2", path = "assets/sounds/sfx/click2.ogg", kind = "static" },
			{ id = "sfx_click3", path = "assets/sounds/sfx/click3.ogg", kind = "static" },
			{ id = "sfx_click4", path = "assets/sounds/sfx/click4.ogg", kind = "static" },
			{ id = "sfx_click5", path = "assets/sounds/sfx/click5.ogg", kind = "static" },
			{ id = "sfx_wrong", path = "assets/sounds/sfx/wrong.ogg", kind = "static" },
			{ id = "sfx_page_turn", path = "assets/sounds/sfx/page_turn.ogg", kind = "static" },
			{ id = "sfx_buy", path = "assets/sounds/sfx/buy.ogg", kind = "static" },
			{ id = "sfx_coins1", path = "assets/sounds/sfx/coins1.ogg", kind = "static" },
			{ id = "sfx_coins2", path = "assets/sounds/sfx/coins2.ogg", kind = "static" },
			{ id = "sfx_coins3", path = "assets/sounds/sfx/coins3.ogg", kind = "static" },
			{ id = "cat_purrr", path = "assets/sounds/cat/cat_purrr.ogg", kind = "static" },
			{ id = "cat_snore", path = "assets/sounds/cat/cat_snore.ogg", kind = "static" },
		},
		fonts = {
			{ id = "vera", path = "assets/fonts/vera.ttf", sizes = { 18, 24, 32 } },
			{ id = "bmdelico", path = "assets/fonts/bmdelico.ttf", sizes = { 18, 24, 32, 42 } },
			{ id = "trashhand", path = "assets/fonts/trashhand.ttf", sizes = {18, 28, 32, 36, 42, 48} },
		}
	}
end

function states.menu()
	return {
		images = {
			{ id = "title", path = "assets/images/title.png" },
			{ id = "btn_play", path = "assets/gui/play.png" },
			{ id = "btn_play_hovered", path = "assets/gui/play_hovered.png" },
			{ id = "btn_leave", path = "assets/gui/leave.png" },
			{ id = "btn_leave_hovered", path = "assets/gui/leave_hovered.png" },
			{ id = "window_red", path = "assets/gui/window_red.png" },
			{ id = "window_green", path = "assets/gui/window_green.png" },
			{ id = "window_blue", path = "assets/gui/window_blue.png" },
			{ id = "button_accept", path = "assets/gui/button_accept.png" },
			{ id = "button_accept_hovered", path = "assets/gui/button_accept_hovered.png" },
			{ id = "button_back", path = "assets/gui/button_back.png" },
			{ id = "button_back_hovered", path = "assets/gui/button_back_hovered.png" },
			{ id = "button_cancel", path = "assets/gui/button_cancel.png" },
			{ id = "button_cancel_hovered", path = "assets/gui/button_cancel_hovered.png" },
			{ id = "items_base", path = "assets/gui/items_base.png" },
			{ id = "items_base_hovered", path = "assets/gui/items_base_hovered.png" },
			{ id = "window_settings1", path = "assets/gui/window_settings1.png" },
			{ id = "window_settings2", path = "assets/gui/window_settings2.png" },
			{ id = "window_settings3", path = "assets/gui/window_settings3.png" },
			{ id = "window_settings4", path = "assets/gui/window_settings4.png" },
			{ id = "bg", path = "assets/images/bg.png" },
		},
		sources = {
			{ id = "bgm_main_menu", path = "assets/sounds/bgm/main_menu.ogg", kind = "stream" },
		},
		fonts = {
			{ id = "upheaval", path = "assets/fonts/upheavalpro.ttf", sizes = {18, 28, 32, 36, 42} },
		},
	}
end

		-- { id = "bgm_customization", path = "assets/sounds/bgm/customization.ogg", kind = "stream" },
		-- { id = "bgm_map1", path = "assets/sounds/bgm/map1.ogg", kind = "stream" },
		-- { id = "bgm_map2", path = "assets/sounds/bgm/map2.ogg", kind = "stream" },

function states.intro()
	return {
		images = {
			{ id = "spritesheet", path = "assets/anim/space.png" }
		},
		sources = {
			{ id = "bgm_intro", path = "assets/sounds/bgm/intro.ogg", kind = "stream" },
		},
	}
end

function states.lobby()
	return {
		images = {
			{ id = "energy_full", path = "assets/gui/energy_full.png" },
			{ id = "energy_half", path = "assets/gui/energy_half.png" },
			{ id = "energy_empty", path = "assets/gui/energy_empty.png" },
			{ id = "window", path = "assets/gui/window.png" },
			{ id = "display_lobby", path = "assets/images/display_lobby.png" },
			{ id = "name", path = "assets/gui/name.png" },
		},
		sources = {
			{ id = "bgm_lobby1", path = "assets/sounds/bgm/lobby1.ogg", kind = "stream" },
			{ id = "bgm_lobby2", path = "assets/sounds/bgm/lobby2.ogg", kind = "stream" },
		}
	}
end

function Assets:load(state)
	return states[string.lower(state)]()
end

return Assets
