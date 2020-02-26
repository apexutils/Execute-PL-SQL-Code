function render
    ( p_dynamic_action in apex_plugin.t_dynamic_action
    , p_plugin         in apex_plugin.t_plugin
    )
return apex_plugin.t_dynamic_action_render_result
is
    l_result                apex_plugin.t_dynamic_action_render_result;
    
    --attribute_01 is the plsql code. not needed in the render function
    
    l_items_to_submit       varchar2(4000) := apex_plugin_util.item_names_to_jquery(p_dynamic_action.attribute_02, p_dynamic_action);
    l_items_to_return       varchar2(4000) := apex_plugin_util.item_names_to_jquery(p_dynamic_action.attribute_03, p_dynamic_action);
    
    --attribute_04 is the success message. not needed in the render function
    --attribute_05 is the error   message. not needed in the render function

    l_loader                varchar2(4000) := p_dynamic_action.attribute_06;
    l_loader_position       varchar2(4000) := p_dynamic_action.attribute_07;
    
    l_submit_clob           varchar2(4000) := p_dynamic_action.attribute_08;
    l_submit_clob_item      varchar2(4000) := p_dynamic_action.attribute_09;
    l_submit_clob_variable  varchar2(4000) := p_dynamic_action.attribute_10;
    
    l_return_clob           varchar2(4000) := p_dynamic_action.attribute_11;
    l_return_clob_item      varchar2(4000) := p_dynamic_action.attribute_12;
    l_return_clob_variable  varchar2(4000) := p_dynamic_action.attribute_13;

    --extra options
    l_suppress_change_event boolean := instr(p_dynamic_action.attribute_15, 'suppressChangeEvent') > 0;
    l_show_error_as_alert   boolean := instr(p_dynamic_action.attribute_15, 'showErrorAsAlert')    > 0;
    l_sync                  boolean := apex_application.g_compatibility_mode < 5.1;

begin

    l_result.javascript_function := 'apexutils.executePlSqlCode';
    l_result.ajax_identifier     := apex_plugin.get_ajax_identifier;
    
    if apex_application.g_debug then
        apex_plugin_util.debug_dynamic_action
            ( p_plugin         => p_plugin
            , p_dynamic_action => p_dynamic_action
            );
    end if;
    
    --attribute_01: regular items to submit/return
    l_result.attribute_01        := '{' || apex_javascript.add_attribute( 'itemsToSubmit', l_items_to_submit, false )
                                        || apex_javascript.add_attribute( 'itemsToReturn', l_items_to_return, false, false ) ||
                                    '}';

    --attribute_02: loader
    l_result.attribute_02        := '{' || apex_javascript.add_attribute( 'showLoader'    , l_loader is not null, false)
                                        || apex_javascript.add_attribute( 'loaderType'    , l_loader            , false)
                                        || apex_javascript.add_attribute( 'loaderPosition', l_loader_position   , false, false) ||
                                    '}';
                                    
    --attribute_03: clob to submit/return
    l_result.attribute_03        := '{' || apex_javascript.add_attribute( 'submitClob'        , l_submit_clob is not null, false)
                                        || apex_javascript.add_attribute( 'submitClobFrom'    , l_submit_clob)
                                        || apex_javascript.add_attribute( 'submitClobItem'    , l_submit_clob_item)
                                        || apex_javascript.add_attribute( 'submitClobVariable', l_submit_clob_variable)
                                        || apex_javascript.add_attribute( 'returnClob'        , l_return_clob is not null, false)
                                        || apex_javascript.add_attribute( 'returnClobInto'    , l_return_clob)
                                        || apex_javascript.add_attribute( 'returnClobItem'    , l_return_clob_item)
                                        || apex_javascript.add_attribute( 'returnClobVariable', l_return_clob_variable, false, false) ||
                                    '}';
    
    --attribute_05: extra options
    l_result.attribute_05        := '{' || apex_javascript.add_attribute('suppressChangeEvent', l_suppress_change_event, false)
                                        || apex_javascript.add_attribute('showErrorAsAlert'   , l_show_error_as_alert  , false)
                                        || apex_javascript.add_attribute('sync'               , l_sync                 , false, false) ||
                                    '}';

    return l_result;
end render;

function ajax
    ( p_dynamic_action in apex_plugin.t_dynamic_action
    , p_plugin         in apex_plugin.t_plugin
    )
return apex_plugin.t_dynamic_action_ajax_result
is
    l_statement        varchar2(32767) := p_dynamic_action.attribute_01;
    l_items_to_return  varchar2(4000)  := apex_plugin_util.cleanup_item_names(p_dynamic_action.attribute_03);
    
    l_return_clob      boolean         := p_dynamic_action.attribute_11 is not null;
    
    l_success_message  varchar2(4000)  := p_dynamic_action.attribute_04;
    l_error_message    varchar2(4000)  := p_dynamic_action.attribute_05;
    
    l_message          varchar2(4000);

    l_item_names       apex_application_global.vc_arr2;
    
    l_result           apex_plugin.t_dynamic_action_ajax_result;

begin
    
    apex_plugin_util.execute_plsql_code(l_statement);

    apex_json.initialize_output;
    apex_json.open_object;

    if l_items_to_return is not null then
        l_item_names := apex_util.string_to_table( p_string     => l_items_to_return
                                                 , p_separator  => ','
                                                 );
        apex_json.open_array('items');
        
        for i in 1 .. l_item_names.count loop
            apex_json.open_object;
            apex_json.write
                ( p_name  => 'id'
                , p_value => apex_plugin_util.item_names_to_dom
                    ( p_item_names     => l_item_names(i)
                    , p_dynamic_action => p_dynamic_action
                    )
                );
            apex_json.write('value', V( l_item_names(i)) );
            apex_json.close_object;
        end loop;

        apex_json.close_array;
    end if;
    
    if l_return_clob then
        apex_json.write('clob', apex_application.g_clob_01);
    end if;
    
    apex_json.write('status', 'success');
    
    l_message := case 
                    when apex_application.g_x01 is not null 
                    then apex_application.g_x01 
                    else l_success_message 
                 end;
    apex_json.write('message', l_message);
    
    apex_json.close_object;

    return l_result;

exception when others then
    rollback;
    
    apex_json.initialize_output;
    apex_json.open_object;
    apex_json.write('status', 'error');
    
    l_message := case 
                    when apex_application.g_x02 is not null 
                    then apex_application.g_x02 
                    else l_error_message 
                 end;
    
    l_message := replace(l_message, '#SQLCODE#'     , apex_escape.html(SQLCODE));
    l_message := replace(l_message, '#SQLERRM#'     , apex_escape.html(SQLERRM));
    l_message := replace(l_message, '#SQLERRM_TEXT#', apex_escape.html(substr(SQLERRM, instr(SQLERRM, ':')+1)));
    
    apex_json.write('message', l_message);
    
    apex_json.close_object;
    
    return l_result;
end ajax;