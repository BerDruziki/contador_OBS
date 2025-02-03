obs = obslua

-- Variáveis para o contador e a fonte de texto
counter = 0
text_source = ""
hotkey_id = obs.OBS_INVALID_HOTKEY_ID

-- Função para inicializar o script
function script_description()
    return "Este script cria um contador que aumenta de 1 a cada vez que um atalho é pressionado."
end

-- Função que é chamada quando o atalho é pressionado
function on_event(pressed)
    if pressed then
        counter = counter + 1
        update_text()
    end
end

-- Atualiza o texto da fonte
function update_text()
    if text_source ~= "" then
        local source = obs.obs_get_source_by_name(text_source)
        if source ~= nil then
            local settings = obs.obs_data_create()
            local text = tostring(counter)
            obs.obs_data_set_string(settings, "text", text)
            obs.obs_source_update(source, settings)
            obs.obs_data_release(settings)
            obs.obs_source_release(source)
        end
    end
end

-- Função chamada para configurar o script no OBS
function script_load(settings)
    text_source = obs.obs_data_get_string(settings, "text_source")
    hotkey_id = obs.obs_hotkey_register_frontend("increment_counter", "Incrementar Contador", on_event)

    local hotkeys = obs.obs_hotkey_get_actions(hotkey_id)
    if #hotkeys > 0 then
        obs.obs_hotkey_load(hotkey_id, hotkeys)
    end
end

-- Função para salvar as configurações ao fechar o script
function script_save(settings)
    obs.obs_data_set_string(settings, "text_source", text_source)
end

-- Função para configurar os parâmetros no OBS
function script_properties()
    local props = obs.obs_properties_create()
    obs.obs_properties_add_text(props, "text_source", "Fonte de Texto", obs.OBS_TEXT_DEFAULT)
    return props
end
