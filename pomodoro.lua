local obs = obslua
local timer_active = false
local pomodoro_interval = 25 * 60 -- 25 minutes in seconds
local break_interval = 5 * 60 -- 5 minutes in seconds
local timer_start_time = 0
local is_break_time = false

function pomodoro_timer()
    local current_time = os.time()
    local remaining_time = timer_start_time + pomodoro_interval - current_time

    if timer_active then
        if remaining_time <= 0 then
            if is_break_time then
                obs.timer_remove(pomodoro_timer)
                timer_active = false
                is_break_time = false
            else
                is_break_time = true
                timer_start_time = current_time
                obs.timer_remove(pomodoro_timer)
                obs.timer_add(pomodoro_timer, break_interval * 1000)
            end
        end

        local minutes = math.floor(remaining_time / 60)
        local seconds = remaining_time % 60

        local timer_text = string.format("%02d:%02d", minutes, seconds)
        obs.script_log(obs.LOG_INFO, "Timer: " .. timer_text)

        -- Replace "Timer Text" with the name of your Text Source in OBS
        local source = obs.obs_get_source_by_name("Timer Text")
        if source ~= nil then
            local settings = obs.obs_data_create()
            obs.obs_data_set_string(settings, "text", timer_text)
            obs.obs_source_update(source, settings)
            obs.obs_data_release(settings)
            obs.obs_source_release(source)
        end
    end
end

function start_pomodoro_timer()
    timer_active = true
    timer_start_time = os.time()
    obs.timer_add(pomodoro_timer, 1000) -- 1 second interval
end

function stop_pomodoro_timer()
    obs.timer_remove(pomodoro_timer)
    timer_active = false
end

function script_description()
    return "A Pomodoro Timer script for OBS"
end

function script_properties()
    local props = obs.obs_properties_create()
    obs.obs_properties_add_button(props, "start_button", "Start Pomodoro", start_pomodoro_timer)
    obs.obs_properties_add_button(props, "stop_button", "Stop Pomodoro", stop_pomodoro_timer)
    return props
end
