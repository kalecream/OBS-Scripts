local obs = obslua

function start_pomodoro()
    obs.script_run("Pomodoro Timer", "start_pomodoro_timer")
end

function stop_pomodoro()
    obs.script_run("Pomodoro Timer", "stop_pomodoro_timer")
end

function script_description()
    return "Pomodoro Timer Hotkeys Script"
end

function script_properties()
    local props = obs.obs_properties_create()
    obs.obs_properties_add_button(props, "start_button", "Start Pomodoro", start_pomodoro)
    obs.obs_properties_add_button(props, "stop_button", "Stop Pomodoro", stop_pomodoro)
    return props
end
