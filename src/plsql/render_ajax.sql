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

function get_display_value(
      p_item_name in apex_application_page_items.item_name%TYPE,
      p_value in varchar2
    )
return varchar2
is
    v_display_as_code apex_application_page_items.display_as_code%TYPE; 
    v_lov_named_lov  apex_application_page_items.lov_named_lov%TYPE; 
    v_lov_definition apex_application_page_items.lov_definition%TYPE;
    v_lov_display_null apex_application_page_items.lov_display_null%TYPE;
    v_lov_null_text apex_application_page_items.lov_null_text%TYPE;    
begin
  begin
    select display_as_code,
           lov_named_lov, 
           lov_definition,
           lov_display_null,
           lov_null_text
    into   v_display_as_code,
           v_lov_named_lov,
           v_lov_definition,
           v_lov_display_null,
           v_lov_null_text
    from apex_application_page_items
    where application_id = nv('APP_ID')
    and page_id = nv('APP_PAGE_ID')
    and item_name = p_item_name;
  exception
    when no_data_found then
      raise_application_error(-20001,'Item '||p_item_name||' not found!');
  end;   
  if v_display_as_code != 'NATIVE_POPUP_LOV' then
    return '';
  end if;  
  
  if v_lov_display_null = 'Yes' then
      null; 
  else 
      v_lov_null_text := '';
  end if;    
    
  if v_lov_named_lov is not null then 
      return apex_item.text_from_lov (
        p_value => p_value,
        p_lov => v_lov_named_lov,
        p_null_text => v_lov_null_text
      );
   else
      return apex_item.text_from_lov_query  (
        p_value => p_value,
        p_query => v_lov_definition,
        p_null_text => v_lov_null_text
      );
  end if;
    
end get_display_value;


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
    
    l_value            varchar2(32767);

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
            l_value := V( l_item_names(i));    
            apex_json.write('value', l_value);
            apex_json.write('display', get_display_value(
              p_item_name => l_item_names(i),
              p_value => l_value
            ));
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