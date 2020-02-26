prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- ORACLE Application Express (APEX) export file
--
-- You should run the script connected to SQL*Plus as the Oracle user
-- APEX_180200 or as the owner (parsing schema) of the application.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_api.import_begin (
 p_version_yyyy_mm_dd=>'2018.05.24'
,p_release=>'18.2.0.00.12'
,p_default_workspace_id=>1549777203957536
,p_default_application_id=>100
,p_default_owner=>'APEX_UTILS'
);
end;
/
prompt --application/shared_components/plugins/dynamic_action/com_apexutils_execute_plsql_code
begin
wwv_flow_api.create_plugin(
 p_id=>wwv_flow_api.id(1843861354211161477)
,p_plugin_type=>'DYNAMIC ACTION'
,p_name=>'COM.APEXUTILS.EXECUTE_PLSQL_CODE'
,p_display_name=>'APEX Utils - Execute PL/SQL Code'
,p_category=>'MISC'
,p_supported_ui_types=>'DESKTOP:JQM_SMARTPHONE'
,p_javascript_file_urls=>'#PLUGIN_FILES#js/script#MIN#.js'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'function render',
'    ( p_dynamic_action in apex_plugin.t_dynamic_action',
'    , p_plugin         in apex_plugin.t_plugin',
'    )',
'return apex_plugin.t_dynamic_action_render_result',
'is',
'    l_result                apex_plugin.t_dynamic_action_render_result;',
'    ',
'    --attribute_01 is the plsql code. not needed in the render function',
'    ',
'    l_items_to_submit       varchar2(4000) := apex_plugin_util.item_names_to_jquery(p_dynamic_action.attribute_02, p_dynamic_action);',
'    l_items_to_return       varchar2(4000) := apex_plugin_util.item_names_to_jquery(p_dynamic_action.attribute_03, p_dynamic_action);',
'    ',
'    --attribute_04 is the success message. not needed in the render function',
'    --attribute_05 is the error   message. not needed in the render function',
'',
'    l_loader                varchar2(4000) := p_dynamic_action.attribute_06;',
'    l_loader_position       varchar2(4000) := p_dynamic_action.attribute_07;',
'    ',
'    l_submit_clob           varchar2(4000) := p_dynamic_action.attribute_08;',
'    l_submit_clob_item      varchar2(4000) := p_dynamic_action.attribute_09;',
'    l_submit_clob_variable  varchar2(4000) := p_dynamic_action.attribute_10;',
'    ',
'    l_return_clob           varchar2(4000) := p_dynamic_action.attribute_11;',
'    l_return_clob_item      varchar2(4000) := p_dynamic_action.attribute_12;',
'    l_return_clob_variable  varchar2(4000) := p_dynamic_action.attribute_13;',
'',
'    --extra options',
'    l_suppress_change_event boolean := instr(p_dynamic_action.attribute_15, ''suppressChangeEvent'') > 0;',
'    l_show_error_as_alert   boolean := instr(p_dynamic_action.attribute_15, ''showErrorAsAlert'')    > 0;',
'    l_sync                  boolean := apex_application.g_compatibility_mode < 5.1;',
'',
'begin',
'',
'    l_result.javascript_function := ''apexutils.executePlSqlCode'';',
'    l_result.ajax_identifier     := apex_plugin.get_ajax_identifier;',
'    ',
'    if apex_application.g_debug then',
'        apex_plugin_util.debug_dynamic_action',
'            ( p_plugin         => p_plugin',
'            , p_dynamic_action => p_dynamic_action',
'            );',
'    end if;',
'    ',
'    --attribute_01: regular items to submit/return',
'    l_result.attribute_01        := ''{'' || apex_javascript.add_attribute( ''itemsToSubmit'', l_items_to_submit, false )',
'                                        || apex_javascript.add_attribute( ''itemsToReturn'', l_items_to_return, false, false ) ||',
'                                    ''}'';',
'',
'    --attribute_02: loader',
'    l_result.attribute_02        := ''{'' || apex_javascript.add_attribute( ''showLoader''    , l_loader is not null, false)',
'                                        || apex_javascript.add_attribute( ''loaderType''    , l_loader            , false)',
'                                        || apex_javascript.add_attribute( ''loaderPosition'', l_loader_position   , false, false) ||',
'                                    ''}'';',
'                                    ',
'    --attribute_03: clob to submit/return',
'    l_result.attribute_03        := ''{'' || apex_javascript.add_attribute( ''submitClob''        , l_submit_clob is not null, false)',
'                                        || apex_javascript.add_attribute( ''submitClobFrom''    , l_submit_clob)',
'                                        || apex_javascript.add_attribute( ''submitClobItem''    , l_submit_clob_item)',
'                                        || apex_javascript.add_attribute( ''submitClobVariable'', l_submit_clob_variable)',
'                                        || apex_javascript.add_attribute( ''returnClob''        , l_return_clob is not null, false)',
'                                        || apex_javascript.add_attribute( ''returnClobInto''    , l_return_clob)',
'                                        || apex_javascript.add_attribute( ''returnClobItem''    , l_return_clob_item)',
'                                        || apex_javascript.add_attribute( ''returnClobVariable'', l_return_clob_variable, false, false) ||',
'                                    ''}'';',
'    ',
'    --attribute_05: extra options',
'    l_result.attribute_05        := ''{'' || apex_javascript.add_attribute(''suppressChangeEvent'', l_suppress_change_event, false)',
'                                        || apex_javascript.add_attribute(''showErrorAsAlert''   , l_show_error_as_alert  , false)',
'                                        || apex_javascript.add_attribute(''sync''               , l_sync                 , false, false) ||',
'                                    ''}'';',
'',
'    return l_result;',
'end render;',
'',
'function ajax',
'    ( p_dynamic_action in apex_plugin.t_dynamic_action',
'    , p_plugin         in apex_plugin.t_plugin',
'    )',
'return apex_plugin.t_dynamic_action_ajax_result',
'is',
'    l_statement        varchar2(32767) := p_dynamic_action.attribute_01;',
'    l_items_to_return  varchar2(4000)  := apex_plugin_util.cleanup_item_names(p_dynamic_action.attribute_03);',
'    ',
'    l_return_clob      boolean         := p_dynamic_action.attribute_11 is not null;',
'    ',
'    l_success_message  varchar2(4000)  := p_dynamic_action.attribute_04;',
'    l_error_message    varchar2(4000)  := p_dynamic_action.attribute_05;',
'    ',
'    l_message          varchar2(4000);',
'',
'    l_item_names       apex_application_global.vc_arr2;',
'    ',
'    l_result           apex_plugin.t_dynamic_action_ajax_result;',
'',
'begin',
'    ',
'    apex_plugin_util.execute_plsql_code(l_statement);',
'',
'    apex_json.initialize_output;',
'    apex_json.open_object;',
'',
'    if l_items_to_return is not null then',
'        l_item_names := apex_util.string_to_table( p_string     => l_items_to_return',
'                                                 , p_separator  => '',''',
'                                                 );',
'        apex_json.open_array(''items'');',
'        ',
'        for i in 1 .. l_item_names.count loop',
'            apex_json.open_object;',
'            apex_json.write',
'                ( p_name  => ''id''',
'                , p_value => apex_plugin_util.item_names_to_dom',
'                    ( p_item_names     => l_item_names(i)',
'                    , p_dynamic_action => p_dynamic_action',
'                    )',
'                );',
'            apex_json.write(''value'', V( l_item_names(i)) );',
'            apex_json.close_object;',
'        end loop;',
'',
'        apex_json.close_array;',
'    end if;',
'    ',
'    if l_return_clob then',
'        apex_json.write(''clob'', apex_application.g_clob_01);',
'    end if;',
'    ',
'    apex_json.write(''status'', ''success'');',
'    ',
'    l_message := case ',
'                    when apex_application.g_x01 is not null ',
'                    then apex_application.g_x01 ',
'                    else l_success_message ',
'                 end;',
'    apex_json.write(''message'', l_message);',
'    ',
'    apex_json.close_object;',
'',
'    return l_result;',
'',
'exception when others then',
'    rollback;',
'    ',
'    apex_json.initialize_output;',
'    apex_json.open_object;',
'    apex_json.write(''status'', ''error'');',
'    ',
'    l_message := case ',
'                    when apex_application.g_x02 is not null ',
'                    then apex_application.g_x02 ',
'                    else l_error_message ',
'                 end;',
'    ',
'    l_message := replace(l_message, ''#SQLCODE#''     , apex_escape.html(SQLCODE));',
'    l_message := replace(l_message, ''#SQLERRM#''     , apex_escape.html(SQLERRM));',
'    l_message := replace(l_message, ''#SQLERRM_TEXT#'', apex_escape.html(substr(SQLERRM, instr(SQLERRM, '':'')+1)));',
'    ',
'    apex_json.write(''message'', l_message);',
'    ',
'    apex_json.close_object;',
'    ',
'    return l_result;',
'end ajax;'))
,p_api_version=>1
,p_render_function=>'render'
,p_ajax_function=>'ajax'
,p_standard_attributes=>'STOP_EXECUTION_ON_ERROR:WAIT_FOR_RESULT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'Executes PL/SQL code on the server.'
,p_version_identifier=>'1.0.2'
,p_about_url=>'https://www.apexutils.com'
,p_files_version=>9
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1843862265209183553)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_prompt=>'PL/SQL Code'
,p_attribute_type=>'PLSQL'
,p_is_required=>true
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'begin',
'    setCommission(:P1_SAL, :P1_JOB);',
'end;',
'</pre>',
'<p>In this example, you need to enter <code>P1_SAL,P1_JOB</code> in <strong>Page Items to Submit</strong>.</p>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Specify an execution only PL/SQL anonymous block, that is executed on the server.</p>',
'<p>You can reference other page or application items from within your application using bind syntax (for example <code>:P1_MY_ITEM</code>). Any items referenced also need to be included in <strong>Page Items to Submit</strong>.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(1843862867071193608)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_prompt=>'Items to Submit'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Enter the uppercase page items submitted to the server, and therefore, available for use within your <strong>PL/SQL Code</strong>.</p>',
'<p>You can type in the item name or pick from the list of available items.',
'If you pick from the list and there is already text entered then a comma is placed at the end of the existing text, followed by the item name returned from the list.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(920418153318418907)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_prompt=>'Items to Return'
,p_attribute_type=>'PAGE ITEMS'
,p_is_required=>false
,p_is_translatable=>false
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<pre>',
'    apex_util.set_session_state(''P1_MY_ITEM'', ''New Value'');',
'</pre>',
'</p>',
'<p>In this example, enter <code>P1_MY_ITEM</code> in this attribute in order for ''New Value'' to be displayed in that item on your page.</p>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Enter the uppercase page items set when the call to the server returns, based on their current value in session state. If your <strong>PL/SQL Code</strong> sets one or more page item values in session state you need to define those items in this a'
||'ttribute.</p>',
'<p>You can type in the item name or pick from the list of available items.',
'If you pick from the list and there is already text entered then a comma is placed at the end of the existing text, followed by the item name returned from the list.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(23016235130369602)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_prompt=>'Success Message'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Provide a success message which will be displayed as a green alert if the execution is completed successfully.</p>',
'<p>This message can be dynamically overridden in the PL/SQL Code block by assigning the new value to the apex_application.g_x01 global variable.</p>',
'<pre>apex_application.g_x01 := ''New Success Message'';</pre>',
'<p>If no success message is provided, none will be shown.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(23022176483371112)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_prompt=>'Error Message'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_default_value=>'#SQLERRM#'
,p_is_translatable=>true
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Provide an error message which will be displayed as a warning notification if the execution is completed unsuccessfully.</p>',
'<p>This message can be dynamically overridden in the PL/SQL Code block by assigning the new value to the <code>apex_application.g_x02</code> global variable.</p>',
'<pre>apex_application.g_x02 := ''New Error Message'';</pre>',
'<p>If no error message is provided, none will be shown.</p>',
'<p>You can also use the #SQLCODE#, #SQLERRM# and #SQLERRM_TEXT# substitution strings for more detailed error information.</p>',
'<p>By default the error message will be displayed in the top right corner as a notification. If you wish to display it as an alert, tick the Show "Error as Alert" checkbox.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(23078692591772342)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>6
,p_display_sequence=>60
,p_prompt=>'Loader'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_default_value=>'spinner'
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_null_text=>'None'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Provide the type of Loader to be displayed while waiting for the execution to complete.</p>',
'<p>This helps inform the user that something is going on in case of longer processes.</p>',
'<p><b>Spinner</b> is displayed as the default application spinner.</p>',
'<p><b>Spinner & Overlay</b> will add a translucent overlay behind the spinner to discourage the user from performing other actions while the AJAX call is in progress. Note that this will not stop actions performed via the keyboard.</p>',
'<p>To avoid flickering, the spinner will only be shown if the AJAX call takes longer than 200ms, and will always show for at least 800ms.</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(23090083113777277)
,p_plugin_attribute_id=>wwv_flow_api.id(23078692591772342)
,p_display_sequence=>10
,p_display_value=>'Spinner'
,p_return_value=>'spinner'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(23090413017779160)
,p_plugin_attribute_id=>wwv_flow_api.id(23078692591772342)
,p_display_sequence=>20
,p_display_value=>'Spinner & Overlay'
,p_return_value=>'spinnerandoverlay'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(23090864422813691)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>7
,p_display_sequence=>70
,p_prompt=>'Loader Position'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_default_value=>'body'
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(23078692591772342)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'NOT_NULL'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Provide the position of the spinner as a jQuery selector.</p>',
'<p><b>body</b> will be desired in most cases, but specific requirements can also be achieved. For example, you can give a region a static ID of <b>regionId</b>, and then reference it as <b>#regionId</b>.</p>',
'<p>Note that the spinner will be positioned at the center of said region, and scroll appropriately. The only exception is in the case of <b>body</b>, when the spinner will be positioned at the middle of the visible screen, and stay there despite any '
||'scrolling.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(23131913878970506)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>8
,p_display_sequence=>80
,p_prompt=>'Submit CLOB'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_null_text=>'No'
,p_help_text=>'<p>Values submitted to the server in APEX page items can have a maximum length of 4000 characters. If you need to submit values larger than that, specify here the source, and the value will be made available to you via the <code>apex_application.g_cl'
||'ob_01</code> global variable in your PL/SQL code block. From there, you can modify the value, store it in a table or collection, etc.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(23137818249981245)
,p_plugin_attribute_id=>wwv_flow_api.id(23131913878970506)
,p_display_sequence=>10
,p_display_value=>'From Page Item'
,p_return_value=>'pageitem'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(23138291806985669)
,p_plugin_attribute_id=>wwv_flow_api.id(23131913878970506)
,p_display_sequence=>20
,p_display_value=>'From JavaScript Variable'
,p_return_value=>'javascriptvariable'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(23144134510050421)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>9
,p_display_sequence=>90
,p_prompt=>'Submit From'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(23131913878970506)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'pageitem'
,p_help_text=>'<p>Specify the page item whose value will be loaded into the <code>apex_application.g_clob_01</code> global variable.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(23150044974055140)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>10
,p_display_sequence=>100
,p_prompt=>'Submit From'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(23131913878970506)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'javascriptvariable'
,p_examples=>'<pre>nameSpace.largeString</pre>'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Specify the name of the JavaScript variable to be loaded into the <code>apex_application.g_clob_01</code> global variable.</p>',
'<p>If the variable is a JSON, it will be stringified.</p>',
'<p>You do not have to prefix the variable with <code>window.</code></p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(23161722948061374)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>11
,p_display_sequence=>110
,p_prompt=>'Return CLOB'
,p_attribute_type=>'SELECT LIST'
,p_is_required=>false
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_null_text=>'No'
,p_help_text=>'<p>If you set this option to anything other that "No", any content found in <code>apex_application.g_clob_01</code> at the end of the PL/SQL execution will be loaded in the specified destination.</p>'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(23167688768064560)
,p_plugin_attribute_id=>wwv_flow_api.id(23161722948061374)
,p_display_sequence=>10
,p_display_value=>'Into Page Item'
,p_return_value=>'pageitem'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(23168054575070221)
,p_plugin_attribute_id=>wwv_flow_api.id(23161722948061374)
,p_display_sequence=>20
,p_display_value=>'Into JavaScript Variable'
,p_return_value=>'javascriptvariable'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(23168468696072123)
,p_plugin_attribute_id=>wwv_flow_api.id(23161722948061374)
,p_display_sequence=>30
,p_display_value=>'Into JavaScript Variable as JSON'
,p_return_value=>'javascriptvariablejson'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(23168859243079331)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>12
,p_display_sequence=>120
,p_prompt=>'Return Into'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(23161722948061374)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'EQUALS'
,p_depending_on_expression=>'pageitem'
,p_help_text=>'<p>Specify a page item into which the value of <code>apex_application.g_clob_01</code> will be loaded.</p>'
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(23174734104085173)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>13
,p_display_sequence=>130
,p_prompt=>'Return Into'
,p_attribute_type=>'TEXT'
,p_is_required=>true
,p_is_translatable=>false
,p_depending_on_attribute_id=>wwv_flow_api.id(23161722948061374)
,p_depending_on_has_to_exist=>true
,p_depending_on_condition_type=>'IN_LIST'
,p_depending_on_expression=>'javascriptvariable,javascriptvariablejson'
,p_examples=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><b>PL/SQL Code</b></p>',
'<pre>',
'apex_json.initialize_clob_output;',
'apex_json.open_array;',
'',
'for employee in (select * from emp)',
'loop',
'    apex_json.open_object;',
'    apex_json.write(''empno'', employee.empno);',
'    apex_json.write(''empname'', employee.empname);',
'    apex_json.close_object;',
'end loop;',
'',
'apex_json.close_array;',
'apex_application.g_clob_01 := apex_json.get_clob_output;',
'apex_json.free_output;',
'</pre>',
'<p><b>Return CLOB</b></p>',
'<pre>Into JavaScript Variable as JSON</pre>',
'<p><b>Return Into</b></p>',
'<pre>myApp.employees</pre>',
'',
'<p>You can then reference this object in any JavaScript context on the page, usually in subsequent Execute Javascript dynamic actions.</p>'))
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p>Specify the JavaScript variable into which the value of <code>apex_application.g_clob_01</code> will be loaded.</p>',
'<p>If you chose <b>Into JavaScript Variable</b> the value will simply be loaded as a string.</p>',
'<p>If you chose <b>Into JavaScript Variable as JSON</b> the value will be first parsed as JSON, then assigned to the variable.</p>',
'<p>Note that you can specify any variable, even a nested one. If it doesn''t exist, it will be created.</p>'))
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(22970414855488118)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>15
,p_display_sequence=>150
,p_prompt=>'Options'
,p_attribute_type=>'CHECKBOXES'
,p_is_required=>false
,p_is_translatable=>false
,p_lov_type=>'STATIC'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<p><b>Suppress Change Event</b></p>',
'<p>Specify whether the change event is suppressed on the items specified in Page Items to Return. This prevents subsequent Change based Dynamic Actions from firing, for these items.</p>',
'<p><b>Show Error as Alert</b></p>',
'<p>By default, errors will be shown via <code>apex.message.showErrors</code> as opposed to <code>apex.message.alert</code>. If you wish to use the classic alert, tick this checkbox.</p>'))
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22975951065490763)
,p_plugin_attribute_id=>wwv_flow_api.id(22970414855488118)
,p_display_sequence=>10
,p_display_value=>'Suppress Change Event'
,p_return_value=>'suppressChangeEvent'
);
wwv_flow_api.create_plugin_attr_value(
 p_id=>wwv_flow_api.id(22981477508505194)
,p_plugin_attribute_id=>wwv_flow_api.id(22970414855488118)
,p_display_sequence=>20
,p_display_value=>'Show Error as Alert'
,p_return_value=>'showErrorAsAlert'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2866756E6374696F6E28297B0A202020202F2F616464696E6720746865207374796C652064796E616D6963616C6C7920746F2074686520686561640A202020202F2F746F6F206C6974746C6520666F7220697473206F776E2066696C650A202020207661';
wwv_flow_api.g_varchar2_table(2) := '722074656D705374796C65203D20646F63756D656E742E637265617465456C656D656E7428277374796C6527293B0A2020202074656D705374796C652E747970653D22746578742F637373223B0A2020202074656D705374796C652E696E6E657248544D';
wwv_flow_api.g_varchar2_table(3) := '4C203D20272E61752D657865637574652D637573746F6D5370696E6E6572436C6173737B27202B0A2020202027706F736974696F6E3A206162736F6C7574652021696D706F7274616E743B27202B0A20202020276C6566743A20302021696D706F727461';
wwv_flow_api.g_varchar2_table(4) := '6E743B27202B0A202020202772696768743A20302021696D706F7274616E743B27202B0A20202020276D617267696E3A206175746F2021696D706F7274616E743B27202B0A2020202027746F703A20302021696D706F7274616E743B27202B0A20202020';
wwv_flow_api.g_varchar2_table(5) := '27626F74746F6D3A20302021696D706F7274616E743B27202B0A20202020277A2D696E6465783A203435303B7D273B0A20202020646F63756D656E742E686561642E617070656E644368696C642874656D705374796C65293B0A7D2928293B0A0A766172';
wwv_flow_api.g_varchar2_table(6) := '20617065787574696C73203D20746869732E617065787574696C73207C7C207B7D3B0A0A2866756E6374696F6E2864612C207365727665722C206974656D2C202429207B0A0A20202020617065787574696C732E73686F775370696E6E6572203D206675';
wwv_flow_api.g_varchar2_table(7) := '6E6374696F6E20287053656C6563746F722C20704F7665726C617929207B0A20202020202020200A2020202020202020766172206C5370696E6E65722C0A2020202020202020202020206C57616974506F707570243B0A20202020202020200A20202020';
wwv_flow_api.g_varchar2_table(8) := '20202020696628704F7665726C6179297B0A20202020202020202020202076617220626F64795374796C652020203D2027706F736974696F6E3A2066697865643B202020207A2D696E6465783A20313930303B207669736962696C6974793A2076697369';
wwv_flow_api.g_varchar2_table(9) := '626C653B2077696474683A20313030253B206865696768743A20313030253B206261636B67726F756E643A2072676261283235352C203235352C203235352C20302E35293B273B0A202020202020202020202020766172206E6F726D616C5374796C6520';
wwv_flow_api.g_varchar2_table(10) := '3D2027706F736974696F6E3A206162736F6C7574653B207A2D696E6465783A203434303B20207669736962696C6974793A2076697369626C653B2077696474683A20313030253B206865696768743A20313030253B206261636B67726F756E643A207267';
wwv_flow_api.g_varchar2_table(11) := '6261283235352C203235352C203235352C20302E35293B273B0A0A2020202020202020202020206C57616974506F70757024203D20242820273C646976207374796C653D2227202B20287053656C6563746F72203D3D2027626F647927203F20626F6479';
wwv_flow_api.g_varchar2_table(12) := '5374796C65203A206E6F726D616C5374796C6529202B2027223E3C2F6469763E2720292E70726570656E64546F282024287053656C6563746F722920293B0A20202020202020207D0A0A20202020202020206C5370696E6E6572203D20617065782E7574';
wwv_flow_api.g_varchar2_table(13) := '696C2E73686F775370696E6E6572287053656C6563746F722C20287053656C6563746F72203D3D2027626F647927203F207B66697865643A20747275657D203A207B7370696E6E6572436C6173733A202761752D657865637574652D637573746F6D5370';
wwv_flow_api.g_varchar2_table(14) := '696E6E6572436C617373277D29293B0A0A202020202020202072657475726E207B0A20202020202020202020202072656D6F76653A2066756E6374696F6E202829207B0A20202020202020202020202020202020696620286C57616974506F7075702420';
wwv_flow_api.g_varchar2_table(15) := '213D3D20756E646566696E656429207B0A20202020202020202020202020202020202020206C57616974506F707570242E72656D6F766528293B0A202020202020202020202020202020207D0A2020202020202020202020202020202069662028206C53';
wwv_flow_api.g_varchar2_table(16) := '70696E6E657220213D3D20756E646566696E65642029207B0A20202020202020202020202020202020202020206C5370696E6E65722E72656D6F766528293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020';
wwv_flow_api.g_varchar2_table(17) := '202020207D3B0A202020207D3B0A0A202020202F2F6275696C64732061206E6573746564206F626A65637420696620697420646F65736E277420657869737420616E642061737369676E7320697420612076616C75650A20202020617065787574696C73';
wwv_flow_api.g_varchar2_table(18) := '2E6372656174654E65737465644F626A656374416E6441737369676E203D2066756E6374696F6E286F626A2C206B6579506174682C2076616C756529207B0A20202020202020206B657950617468203D206B6579506174682E73706C697428272E27293B';
wwv_flow_api.g_varchar2_table(19) := '0A20202020202020206C6173744B6579496E646578203D206B6579506174682E6C656E6774682D313B0A2020202020202020666F7220287661722069203D20303B2069203C206C6173744B6579496E6465783B202B2B206929207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(20) := '202020206B6579203D206B6579506174685B695D3B0A2020202020202020202020206966202821286B657920696E206F626A29297B0A202020202020202020202020202020206F626A5B6B65795D203D207B7D3B0A2020202020202020202020207D0A20';
wwv_flow_api.g_varchar2_table(21) := '20202020202020202020206F626A203D206F626A5B6B65795D3B0A20202020202020207D0A20202020202020206F626A5B6B6579506174685B6C6173744B6579496E6465785D5D203D2076616C75653B0A202020207D3B0A202020200A20202020617065';
wwv_flow_api.g_varchar2_table(22) := '787574696C732E65786563757465506C53716C436F6465203D2066756E6374696F6E28297B0A20202020202020200A2020202020202020617065782E646562756728274578656375746520504C2F53514C20436F646520272C2074686973293B0A0A2020';
wwv_flow_api.g_varchar2_table(23) := '20202020202076617220616374696F6E20202020202020202020203D20746869732E616374696F6E2C0A202020202020202020202020726573756D6543616C6C6261636B2020203D20746869732E726573756D6543616C6C6261636B2C0A202020202020';
wwv_flow_api.g_varchar2_table(24) := '202020202020706167654974656D7320202020202020203D204A534F4E2E706172736528616374696F6E2E6174747269627574653031292C0A2020202020202020202020206C6F6164657253657474696E67732020203D204A534F4E2E70617273652861';
wwv_flow_api.g_varchar2_table(25) := '6374696F6E2E6174747269627574653032292C0A202020202020202020202020636C6F6253657474696E677320202020203D204A534F4E2E706172736528616374696F6E2E6174747269627574653033292C0A2020202020202020202020206F7074696F';
wwv_flow_api.g_varchar2_table(26) := '6E73202020202020202020203D204A534F4E2E706172736528616374696F6E2E6174747269627574653035292C0A2020202020202020202020206572726F724D65737361676573202020203D204A534F4E2E706172736528616374696F6E2E6174747269';
wwv_flow_api.g_varchar2_table(27) := '627574653036292C0A20202020202020202020202073796E63202020202020202020202020203D2028616374696F6E2E77616974466F72526573756C74202626206F7074696F6E732E73796E63293B0A0A202020202020202066756E6374696F6E205F68';
wwv_flow_api.g_varchar2_table(28) := '616E646C65526573706F6E7365282070446174612029207B0A20202020202020202020202069662870446174612E737461747573203D3D20277375636365737327297B0A20202020202020202020202020202020766172206974656D436F756E742C2069';
wwv_flow_api.g_varchar2_table(29) := '74656D41727261793B0A0A202020202020202020202020202020202F2F726567756C61722070616765206974656D730A202020202020202020202020202020206966282070446174612026262070446174612E6974656D732029207B0A20202020202020';
wwv_flow_api.g_varchar2_table(30) := '202020202020202020202020206974656D436F756E74203D2070446174612E6974656D732E6C656E6774683B0A20202020202020202020202020202020202020206974656D4172726179203D2070446174612E6974656D733B0A20202020202020202020';
wwv_flow_api.g_varchar2_table(31) := '20202020202020202020666F7228207661722069203D20303B2069203C206974656D436F756E743B20692B2B2029207B0A202020202020202020202020202020202020202020202020247328206974656D41727261795B695D2E69642C206974656D4172';
wwv_flow_api.g_varchar2_table(32) := '7261795B695D2E76616C75652C206E756C6C2C206F7074696F6E732E73757070726573734368616E67654576656E74293B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A0A202020202020202020';
wwv_flow_api.g_varchar2_table(33) := '202020202020202F2F636C6F622070616765206974656D2F207661726961626C652F207661726961626C65206173206A736F6E0A20202020202020202020202020202020696628636C6F6253657474696E67732E72657475726E436C6F62297B0A202020';
wwv_flow_api.g_varchar2_table(34) := '202020202020202020202020202020202073776974636828636C6F6253657474696E67732E72657475726E436C6F62496E746F297B0A202020202020202020202020202020202020202020202020636173652027706167656974656D273A0A2020202020';
wwv_flow_api.g_varchar2_table(35) := '2020202020202020202020202020202020202020202020247328636C6F6253657474696E67732E72657475726E436C6F624974656D2C2070446174612E636C6F622C206E756C6C2C206F7074696F6E732E73757070726573734368616E67654576656E74';
wwv_flow_api.g_varchar2_table(36) := '293B0A20202020202020202020202020202020202020202020202020202020627265616B3B0A2020202020202020202020202020202020202020202020206361736520276A6176617363726970747661726961626C65273A0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(37) := '2020202020202020202020202020202020617065787574696C732E6372656174654E65737465644F626A656374416E6441737369676E2877696E646F772C20636C6F6253657474696E67732E72657475726E436C6F625661726961626C652C2070446174';
wwv_flow_api.g_varchar2_table(38) := '612E636C6F62293B0A20202020202020202020202020202020202020202020202020202020627265616B3B0A2020202020202020202020202020202020202020202020206361736520276A6176617363726970747661726961626C656A736F6E273A0A20';
wwv_flow_api.g_varchar2_table(39) := '202020202020202020202020202020202020202020202020202020617065787574696C732E6372656174654E65737465644F626A656374416E6441737369676E2877696E646F772C20636C6F6253657474696E67732E72657475726E436C6F6256617269';
wwv_flow_api.g_varchar2_table(40) := '61626C652C204A534F4E2E70617273652870446174612E636C6F6229293B0A20202020202020202020202020202020202020202020202020202020627265616B3B0A20202020202020202020202020202020202020202020202064656661756C743A0A20';
wwv_flow_api.g_varchar2_table(41) := '202020202020202020202020202020202020202020202020202020627265616B3B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A202020202020202020202020202020200A202020202020202020';
wwv_flow_api.g_varchar2_table(42) := '2020202020202069662870446174612E6D657373616765297B0A2020202020202020202020202020202020202020617065782E6D6573736167652E73686F7750616765537563636573732870446174612E6D657373616765293B0A202020202020202020';
wwv_flow_api.g_varchar2_table(43) := '202020202020207D0A0A202020202020202020202020202020202F2A20526573756D6520657865637574696F6E206F6620616374696F6E73206865726520616E6420706173732066616C736520746F207468652063616C6C6261636B2C20746F20696E64';
wwv_flow_api.g_varchar2_table(44) := '6963617465206E6F0A202020202020202020202020202020206572726F7220686173206F6363757272656420776974682074686520416A61782063616C6C2E202A2F0A2020202020202020202020202020202064612E726573756D652820726573756D65';
wwv_flow_api.g_varchar2_table(45) := '43616C6C6261636B2C2066616C736520293B0A2020202020202020202020207D20656C7365206966202870446174612E737461747573203D3D20276572726F7227297B0A2020202020202020202020202020202069662870446174612E6D657373616765';
wwv_flow_api.g_varchar2_table(46) := '297B0A0A20202020202020202020202020202020202020206966286F7074696F6E732E73686F774572726F724173416C657274297B0A202020202020202020202020202020202020202020202020617065782E6D6573736167652E616C65727428704461';
wwv_flow_api.g_varchar2_table(47) := '74612E6D657373616765293B0A20202020202020202020202020202020202020207D20656C7365207B0A2020202020202020202020202020202020202020202020202F2F20466972737420636C65617220746865206572726F72730A2020202020202020';
wwv_flow_api.g_varchar2_table(48) := '20202020202020202020202020202020617065782E6D6573736167652E636C6561724572726F727328293B0A0A2020202020202020202020202020202020202020202020202F2F204E6F772073686F77206E6577206572726F72730A2020202020202020';
wwv_flow_api.g_varchar2_table(49) := '20202020202020202020202020202020617065782E6D6573736167652E73686F774572726F7273285B0A202020202020202020202020202020202020202020202020202020207B0A20202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(50) := '20202020747970653A20202020202020226572726F72222C0A20202020202020202020202020202020202020202020202020202020202020206C6F636174696F6E3A2020205B2270616765225D2C0A202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(51) := '20202020202020202020206D6573736167653A2020202070446174612E6D6573736167652C0A2020202020202020202020202020202020202020202020202020202020202020756E736166653A202020202066616C73650A202020202020202020202020';
wwv_flow_api.g_varchar2_table(52) := '202020202020202020202020202020207D0A2020202020202020202020202020202020202020202020205D293B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D0A2020202020202020202020207D0A';
wwv_flow_api.g_varchar2_table(53) := '20202020202020207D0A0A20202020202020202F2F204572726F722063616C6C6261636B2063616C6C6564207768656E2074686520416A61782063616C6C206661696C730A202020202020202066756E6374696F6E205F6572726F722820706A71584852';
wwv_flow_api.g_varchar2_table(54) := '2C2070546578745374617475732C20704572726F725468726F776E2029207B202020200A20202020202020202020202064612E68616E646C65416A61784572726F72732820706A715848522C2070546578745374617475732C20704572726F725468726F';
wwv_flow_api.g_varchar2_table(55) := '776E2C20726573756D6543616C6C6261636B20293B0A20202020202020207D0A20202020202020200A2020202020202020766172206C5370696E6E6572243B0A202020202020202076617220756E697175654964203D206E6577204461746528292E6765';
wwv_flow_api.g_varchar2_table(56) := '7454696D6528293B0A20202020202020200A20202020202020206966286C6F6164657253657474696E67732E73686F774C6F6164657229207B0A202020202020202020202020737769746368286C6F6164657253657474696E67732E6C6F616465725479';
wwv_flow_api.g_varchar2_table(57) := '7065297B0A202020202020202020202020202020206361736520277370696E6E6572273A0A2020202020202020202020202020202020202020617065782E7574696C2E64656C61794C696E6765722E737461727428756E6971756549642C2066756E6374';
wwv_flow_api.g_varchar2_table(58) := '696F6E2829207B0A2020202020202020202020202020202020202020202020206C5370696E6E657224203D20617065787574696C732E73686F775370696E6E6572286C6F6164657253657474696E67732E6C6F61646572506F736974696F6E2C2066616C';
wwv_flow_api.g_varchar2_table(59) := '7365293B0A20202020202020202020202020202020202020207D293B0A2020202020202020202020202020202020202020627265616B3B0A202020202020202020202020202020206361736520277370696E6E6572616E646F7665726C6179273A0A2020';
wwv_flow_api.g_varchar2_table(60) := '202020202020202020202020202020202020617065782E7574696C2E64656C61794C696E6765722E737461727428756E6971756549642C2066756E6374696F6E2829207B0A2020202020202020202020202020202020202020202020206C5370696E6E65';
wwv_flow_api.g_varchar2_table(61) := '7224203D20617065787574696C732E73686F775370696E6E6572286C6F6164657253657474696E67732E6C6F61646572506F736974696F6E2C2074727565293B0A20202020202020202020202020202020202020207D293B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(62) := '202020202020202020627265616B3B0A2020202020202020202020202020202064656661756C743A0A2020202020202020202020202020202020202020627265616B3B0A2020202020202020202020207D0A20202020202020207D0A2020202020202020';
wwv_flow_api.g_varchar2_table(63) := '0A20202020202020207661722068616E646C655F7370696E6E6572203D2066756E6374696F6E28297B0A2020202020202020202020206966286C6F6164657253657474696E67732E73686F774C6F61646572297B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(64) := '20617065782E7574696C2E64656C61794C696E6765722E66696E69736828756E6971756549642C2066756E6374696F6E28297B0A20202020202020202020202020202020202020206966286C5370696E6E657224297B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(65) := '20202020202020202020206C5370696E6E6572242E72656D6F766528293B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D293B20200A2020202020202020202020207D0A20202020202020207D3B0A';
wwv_flow_api.g_varchar2_table(66) := '0A202020202020202076617220636C6F62546F5375626D69743B0A0A2020202020202020696628636C6F6253657474696E67732E7375626D6974436C6F62297B0A20202020202020202020202073776974636828636C6F6253657474696E67732E737562';
wwv_flow_api.g_varchar2_table(67) := '6D6974436C6F6246726F6D297B0A20202020202020202020202020202020636173652027706167656974656D273A0A2020202020202020202020202020202020202020636C6F62546F5375626D6974203D206974656D28636C6F6253657474696E67732E';
wwv_flow_api.g_varchar2_table(68) := '7375626D6974436C6F624974656D292E67657456616C756528293B0A2020202020202020202020202020202020202020627265616B3B0A202020202020202020202020202020206361736520276A6176617363726970747661726961626C65273A0A2020';
wwv_flow_api.g_varchar2_table(69) := '20202020202020202020202020202020202076617220746F5375626D6974203D2077696E646F775B636C6F6253657474696E67732E7375626D6974436C6F625661726961626C655D3B0A0A2020202020202020202020202020202020202020696628746F';
wwv_flow_api.g_varchar2_table(70) := '5375626D697420696E7374616E63656F66204F626A656374297B0A202020202020202020202020202020202020202020202020636C6F62546F5375626D6974203D204A534F4E2E737472696E6769667928746F5375626D6974293B0A2020202020202020';
wwv_flow_api.g_varchar2_table(71) := '2020202020202020202020207D20656C7365207B0A202020202020202020202020202020202020202020202020636C6F62546F5375626D6974203D20746F5375626D69743B0A20202020202020202020202020202020202020207D0A2020202020202020';
wwv_flow_api.g_varchar2_table(72) := '202020202020202020202020627265616B3B0A2020202020202020202020202020202064656661756C743A0A2020202020202020202020202020202020202020627265616B3B0A2020202020202020202020207D0A20202020202020207D0A0A20202020';
wwv_flow_api.g_varchar2_table(73) := '202020207365727665722E706C7567696E28616374696F6E2E616A61784964656E7469666965722C0A2020202020202020202020207B0A20202020202020202020202020202020706167654974656D73202020202020203A20706167654974656D732E69';
wwv_flow_api.g_varchar2_table(74) := '74656D73546F5375626D69742C2020202F2F20416C726561647920696E206A51756572792073656C6563746F722073796E7461780A20202020202020202020202020202020705F636C6F625F3031202020202020203A20636C6F62546F5375626D69740A';
wwv_flow_api.g_varchar2_table(75) := '2020202020202020202020207D2C0A2020202020202020202020207B0A20202020202020202020202020202020646174615479706520202020202020203A20276A736F6E272C0A202020202020202020202020202020206C6F6164696E67496E64696361';
wwv_flow_api.g_varchar2_table(76) := '746F723A20706167654974656D732E6974656D73546F52657475726E2C2020202F2F20446973706C6179656420666F7220616C6C202250616765204974656D7320746F2052657475726E220A202020202020202020202020202020207375636365737320';
wwv_flow_api.g_varchar2_table(77) := '20202020202020203A2066756E6374696F6E287044617461297B0A202020202020202020202020202020202020202068616E646C655F7370696E6E657228293B0A20202020202020202020202020202020202020205F68616E646C65526573706F6E7365';
wwv_flow_api.g_varchar2_table(78) := '287044617461293B0A202020202020202020202020202020207D2C0A202020202020202020202020202020206572726F7220202020202020202020203A2066756E6374696F6E28706A715848522C2070546578745374617475732C20704572726F725468';
wwv_flow_api.g_varchar2_table(79) := '726F776E297B0A202020202020202020202020202020202020202068616E646C655F7370696E6E657228293B0A20202020202020202020202020202020202020205F6572726F722820706A715848522C2070546578745374617475732C20704572726F72';
wwv_flow_api.g_varchar2_table(80) := '5468726F776E20293B0A202020202020202020202020202020207D2C0A202020202020202020202020202020206173796E6320202020202020202020203A202173796E632C0A202020202020202020202020202020207461726765742020202020202020';
wwv_flow_api.g_varchar2_table(81) := '20203A20746869732E62726F777365724576656E742E7461726765740A2020202020202020202020207D0A2020202020202020293B0A202020207D3B0A7D2928617065782E64612C20617065782E7365727665722C20617065782E6974656D2C20617065';
wwv_flow_api.g_varchar2_table(82) := '782E6A5175657279293B0A2F2F2320736F757263654D617070696E6755524C3D7363726970742E6A732E6D61700A';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(23283577776894160)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_file_name=>'js/script.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '2166756E6374696F6E28297B76617220653D646F63756D656E742E637265617465456C656D656E7428227374796C6522293B652E747970653D22746578742F637373222C652E696E6E657248544D4C3D222E61752D657865637574652D637573746F6D53';
wwv_flow_api.g_varchar2_table(2) := '70696E6E6572436C6173737B706F736974696F6E3A206162736F6C7574652021696D706F7274616E743B6C6566743A20302021696D706F7274616E743B72696768743A20302021696D706F7274616E743B6D617267696E3A206175746F2021696D706F72';
wwv_flow_api.g_varchar2_table(3) := '74616E743B746F703A20302021696D706F7274616E743B626F74746F6D3A20302021696D706F7274616E743B7A2D696E6465783A203435303B7D222C646F63756D656E742E686561642E617070656E644368696C642865297D28293B7661722061706578';
wwv_flow_api.g_varchar2_table(4) := '7574696C733D746869732E617065787574696C737C7C7B7D3B2166756E6374696F6E28652C742C612C73297B617065787574696C732E73686F775370696E6E65723D66756E6374696F6E28652C74297B76617220612C693B69662874297B693D7328273C';
wwv_flow_api.g_varchar2_table(5) := '646976207374796C653D22272B2822626F6479223D3D653F22706F736974696F6E3A2066697865643B202020207A2D696E6465783A20313930303B207669736962696C6974793A2076697369626C653B2077696474683A20313030253B20686569676874';
wwv_flow_api.g_varchar2_table(6) := '3A20313030253B206261636B67726F756E643A2072676261283235352C203235352C203235352C20302E35293B223A22706F736974696F6E3A206162736F6C7574653B207A2D696E6465783A203434303B20207669736962696C6974793A207669736962';
wwv_flow_api.g_varchar2_table(7) := '6C653B2077696474683A20313030253B206865696768743A20313030253B206261636B67726F756E643A2072676261283235352C203235352C203235352C20302E35293B22292B27223E3C2F6469763E27292E70726570656E64546F2873286529297D72';
wwv_flow_api.g_varchar2_table(8) := '657475726E20613D617065782E7574696C2E73686F775370696E6E657228652C22626F6479223D3D653F7B66697865643A21307D3A7B7370696E6E6572436C6173733A2261752D657865637574652D637573746F6D5370696E6E6572436C617373227D29';
wwv_flow_api.g_varchar2_table(9) := '2C7B72656D6F76653A66756E6374696F6E28297B766F69642030213D3D692626692E72656D6F766528292C766F69642030213D3D612626612E72656D6F766528297D7D7D2C617065787574696C732E6372656174654E65737465644F626A656374416E64';
wwv_flow_api.g_varchar2_table(10) := '41737369676E3D66756E6374696F6E28652C742C61297B743D742E73706C697428222E22292C6C6173744B6579496E6465783D742E6C656E6774682D313B666F722876617220733D303B733C6C6173744B6579496E6465783B2B2B73296B65793D745B73';
wwv_flow_api.g_varchar2_table(11) := '5D2C6B657920696E20657C7C28655B6B65795D3D7B7D292C653D655B6B65795D3B655B745B6C6173744B6579496E6465785D5D3D617D2C617065787574696C732E65786563757465506C53716C436F64653D66756E6374696F6E28297B617065782E6465';
wwv_flow_api.g_varchar2_table(12) := '62756728224578656375746520504C2F53514C20436F646520222C74686973293B76617220732C693D746869732E616374696F6E2C723D746869732E726573756D6543616C6C6261636B2C6E3D4A534F4E2E706172736528692E61747472696275746530';
wwv_flow_api.g_varchar2_table(13) := '31292C6F3D4A534F4E2E706172736528692E6174747269627574653032292C6C3D4A534F4E2E706172736528692E6174747269627574653033292C753D4A534F4E2E706172736528692E6174747269627574653035292C703D284A534F4E2E7061727365';
wwv_flow_api.g_varchar2_table(14) := '28692E6174747269627574653036292C692E77616974466F72526573756C742626752E73796E63293B76617220633D286E65772044617465292E67657454696D6528293B6966286F2E73686F774C6F6164657229737769746368286F2E6C6F6164657254';
wwv_flow_api.g_varchar2_table(15) := '797065297B63617365227370696E6E6572223A617065782E7574696C2E64656C61794C696E6765722E737461727428632C66756E6374696F6E28297B733D617065787574696C732E73686F775370696E6E6572286F2E6C6F61646572506F736974696F6E';
wwv_flow_api.g_varchar2_table(16) := '2C2131297D293B627265616B3B63617365227370696E6E6572616E646F7665726C6179223A617065782E7574696C2E64656C61794C696E6765722E737461727428632C66756E6374696F6E28297B733D617065787574696C732E73686F775370696E6E65';
wwv_flow_api.g_varchar2_table(17) := '72286F2E6C6F61646572506F736974696F6E2C2130297D297D76617220622C643D66756E6374696F6E28297B6F2E73686F774C6F616465722626617065782E7574696C2E64656C61794C696E6765722E66696E69736828632C66756E6374696F6E28297B';
wwv_flow_api.g_varchar2_table(18) := '732626732E72656D6F766528297D297D3B6966286C2E7375626D6974436C6F6229737769746368286C2E7375626D6974436C6F6246726F6D297B6361736522706167656974656D223A623D61286C2E7375626D6974436C6F624974656D292E6765745661';
wwv_flow_api.g_varchar2_table(19) := '6C756528293B627265616B3B63617365226A6176617363726970747661726961626C65223A766172206D3D77696E646F775B6C2E7375626D6974436C6F625661726961626C655D3B623D6D20696E7374616E63656F66204F626A6563743F4A534F4E2E73';
wwv_flow_api.g_varchar2_table(20) := '7472696E67696679286D293A6D7D742E706C7567696E28692E616A61784964656E7469666965722C7B706167654974656D733A6E2E6974656D73546F5375626D69742C705F636C6F625F30313A627D2C7B64617461547970653A226A736F6E222C6C6F61';
wwv_flow_api.g_varchar2_table(21) := '64696E67496E64696361746F723A6E2E6974656D73546F52657475726E2C737563636573733A66756E6374696F6E2874297B6428292C66756E6374696F6E2874297B6966282273756363657373223D3D742E737461747573297B76617220612C733B6966';
wwv_flow_api.g_varchar2_table(22) := '28742626742E6974656D73297B613D742E6974656D732E6C656E6774682C733D742E6974656D733B666F722876617220693D303B693C613B692B2B29247328735B695D2E69642C735B695D2E76616C75652C6E756C6C2C752E7375707072657373436861';
wwv_flow_api.g_varchar2_table(23) := '6E67654576656E74297D6966286C2E72657475726E436C6F6229737769746368286C2E72657475726E436C6F62496E746F297B6361736522706167656974656D223A2473286C2E72657475726E436C6F624974656D2C742E636C6F622C6E756C6C2C752E';
wwv_flow_api.g_varchar2_table(24) := '73757070726573734368616E67654576656E74293B627265616B3B63617365226A6176617363726970747661726961626C65223A617065787574696C732E6372656174654E65737465644F626A656374416E6441737369676E2877696E646F772C6C2E72';
wwv_flow_api.g_varchar2_table(25) := '657475726E436C6F625661726961626C652C742E636C6F62293B627265616B3B63617365226A6176617363726970747661726961626C656A736F6E223A617065787574696C732E6372656174654E65737465644F626A656374416E6441737369676E2877';
wwv_flow_api.g_varchar2_table(26) := '696E646F772C6C2E72657475726E436C6F625661726961626C652C4A534F4E2E706172736528742E636C6F6229297D742E6D6573736167652626617065782E6D6573736167652E73686F77506167655375636365737328742E6D657373616765292C652E';
wwv_flow_api.g_varchar2_table(27) := '726573756D6528722C2131297D656C7365226572726F72223D3D742E7374617475732626742E6D657373616765262628752E73686F774572726F724173416C6572743F617065782E6D6573736167652E616C65727428742E6D657373616765293A286170';
wwv_flow_api.g_varchar2_table(28) := '65782E6D6573736167652E636C6561724572726F727328292C617065782E6D6573736167652E73686F774572726F7273285B7B747970653A226572726F72222C6C6F636174696F6E3A5B2270616765225D2C6D6573736167653A742E6D6573736167652C';
wwv_flow_api.g_varchar2_table(29) := '756E736166653A21317D5D2929297D2874297D2C6572726F723A66756E6374696F6E28742C612C73297B6428292C66756E6374696F6E28742C612C73297B652E68616E646C65416A61784572726F727328742C612C732C72297D28742C612C73297D2C61';
wwv_flow_api.g_varchar2_table(30) := '73796E633A21702C7461726765743A746869732E62726F777365724576656E742E7461726765747D297D7D28617065782E64612C617065782E7365727665722C617065782E6974656D2C617065782E6A5175657279293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(28716375280209793)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_file_name=>'js/script.min.js'
,p_mime_type=>'application/x-javascript'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7B2276657273696F6E223A332C226E616D6573223A5B5D2C226D617070696E6773223A22222C22736F7572636573223A5B227363726970742E6A73225D2C22736F7572636573436F6E74656E74223A5B222866756E6374696F6E28297B5C6E202020202F';
wwv_flow_api.g_varchar2_table(2) := '2F616464696E6720746865207374796C652064796E616D6963616C6C7920746F2074686520686561645C6E202020202F2F746F6F206C6974746C6520666F7220697473206F776E2066696C655C6E202020207661722074656D705374796C65203D20646F';
wwv_flow_api.g_varchar2_table(3) := '63756D656E742E637265617465456C656D656E7428277374796C6527293B5C6E2020202074656D705374796C652E747970653D5C22746578742F6373735C223B5C6E2020202074656D705374796C652E696E6E657248544D4C203D20272E61752D657865';
wwv_flow_api.g_varchar2_table(4) := '637574652D637573746F6D5370696E6E6572436C6173737B27202B5C6E2020202027706F736974696F6E3A206162736F6C7574652021696D706F7274616E743B27202B5C6E20202020276C6566743A20302021696D706F7274616E743B27202B5C6E2020';
wwv_flow_api.g_varchar2_table(5) := '20202772696768743A20302021696D706F7274616E743B27202B5C6E20202020276D617267696E3A206175746F2021696D706F7274616E743B27202B5C6E2020202027746F703A20302021696D706F7274616E743B27202B5C6E2020202027626F74746F';
wwv_flow_api.g_varchar2_table(6) := '6D3A20302021696D706F7274616E743B27202B5C6E20202020277A2D696E6465783A203435303B7D273B5C6E20202020646F63756D656E742E686561642E617070656E644368696C642874656D705374796C65293B5C6E7D2928293B5C6E5C6E76617220';
wwv_flow_api.g_varchar2_table(7) := '617065787574696C73203D20746869732E617065787574696C73207C7C207B7D3B5C6E5C6E2866756E6374696F6E2864612C207365727665722C206974656D2C202429207B5C6E5C6E20202020617065787574696C732E73686F775370696E6E6572203D';
wwv_flow_api.g_varchar2_table(8) := '2066756E6374696F6E20287053656C6563746F722C20704F7665726C617929207B5C6E20202020202020205C6E2020202020202020766172206C5370696E6E65722C5C6E2020202020202020202020206C57616974506F707570243B5C6E202020202020';
wwv_flow_api.g_varchar2_table(9) := '20205C6E2020202020202020696628704F7665726C6179297B5C6E20202020202020202020202076617220626F64795374796C652020203D2027706F736974696F6E3A2066697865643B202020207A2D696E6465783A20313930303B207669736962696C';
wwv_flow_api.g_varchar2_table(10) := '6974793A2076697369626C653B2077696474683A20313030253B206865696768743A20313030253B206261636B67726F756E643A2072676261283235352C203235352C203235352C20302E35293B273B5C6E202020202020202020202020766172206E6F';
wwv_flow_api.g_varchar2_table(11) := '726D616C5374796C65203D2027706F736974696F6E3A206162736F6C7574653B207A2D696E6465783A203434303B20207669736962696C6974793A2076697369626C653B2077696474683A20313030253B206865696768743A20313030253B206261636B';
wwv_flow_api.g_varchar2_table(12) := '67726F756E643A2072676261283235352C203235352C203235352C20302E35293B273B5C6E5C6E2020202020202020202020206C57616974506F70757024203D20242820273C646976207374796C653D5C2227202B20287053656C6563746F72203D3D20';
wwv_flow_api.g_varchar2_table(13) := '27626F647927203F20626F64795374796C65203A206E6F726D616C5374796C6529202B20275C223E3C2F6469763E2720292E70726570656E64546F282024287053656C6563746F722920293B5C6E20202020202020207D5C6E5C6E20202020202020206C';
wwv_flow_api.g_varchar2_table(14) := '5370696E6E6572203D20617065782E7574696C2E73686F775370696E6E6572287053656C6563746F722C20287053656C6563746F72203D3D2027626F647927203F207B66697865643A20747275657D203A207B7370696E6E6572436C6173733A20276175';
wwv_flow_api.g_varchar2_table(15) := '2D657865637574652D637573746F6D5370696E6E6572436C617373277D29293B5C6E5C6E202020202020202072657475726E207B5C6E20202020202020202020202072656D6F76653A2066756E6374696F6E202829207B5C6E2020202020202020202020';
wwv_flow_api.g_varchar2_table(16) := '2020202020696620286C57616974506F7075702420213D3D20756E646566696E656429207B5C6E20202020202020202020202020202020202020206C57616974506F707570242E72656D6F766528293B5C6E202020202020202020202020202020207D5C';
wwv_flow_api.g_varchar2_table(17) := '6E2020202020202020202020202020202069662028206C5370696E6E657220213D3D20756E646566696E65642029207B5C6E20202020202020202020202020202020202020206C5370696E6E65722E72656D6F766528293B5C6E20202020202020202020';
wwv_flow_api.g_varchar2_table(18) := '2020202020207D5C6E2020202020202020202020207D5C6E20202020202020207D3B5C6E202020207D3B5C6E5C6E202020202F2F6275696C64732061206E6573746564206F626A65637420696620697420646F65736E277420657869737420616E642061';
wwv_flow_api.g_varchar2_table(19) := '737369676E7320697420612076616C75655C6E20202020617065787574696C732E6372656174654E65737465644F626A656374416E6441737369676E203D2066756E6374696F6E286F626A2C206B6579506174682C2076616C756529207B5C6E20202020';
wwv_flow_api.g_varchar2_table(20) := '202020206B657950617468203D206B6579506174682E73706C697428272E27293B5C6E20202020202020206C6173744B6579496E646578203D206B6579506174682E6C656E6774682D313B5C6E2020202020202020666F7220287661722069203D20303B';
wwv_flow_api.g_varchar2_table(21) := '2069203C206C6173744B6579496E6465783B202B2B206929207B5C6E2020202020202020202020206B6579203D206B6579506174685B695D3B5C6E2020202020202020202020206966202821286B657920696E206F626A29297B5C6E2020202020202020';
wwv_flow_api.g_varchar2_table(22) := '20202020202020206F626A5B6B65795D203D207B7D3B5C6E2020202020202020202020207D5C6E2020202020202020202020206F626A203D206F626A5B6B65795D3B5C6E20202020202020207D5C6E20202020202020206F626A5B6B6579506174685B6C';
wwv_flow_api.g_varchar2_table(23) := '6173744B6579496E6465785D5D203D2076616C75653B5C6E202020207D3B5C6E202020205C6E20202020617065787574696C732E65786563757465506C53716C436F6465203D2066756E6374696F6E28297B5C6E20202020202020205C6E202020202020';
wwv_flow_api.g_varchar2_table(24) := '2020617065782E646562756728274578656375746520504C2F53514C20436F646520272C2074686973293B5C6E5C6E202020202020202076617220616374696F6E20202020202020202020203D20746869732E616374696F6E2C5C6E2020202020202020';
wwv_flow_api.g_varchar2_table(25) := '20202020726573756D6543616C6C6261636B2020203D20746869732E726573756D6543616C6C6261636B2C5C6E202020202020202020202020706167654974656D7320202020202020203D204A534F4E2E706172736528616374696F6E2E617474726962';
wwv_flow_api.g_varchar2_table(26) := '7574653031292C5C6E2020202020202020202020206C6F6164657253657474696E67732020203D204A534F4E2E706172736528616374696F6E2E6174747269627574653032292C5C6E202020202020202020202020636C6F6253657474696E6773202020';
wwv_flow_api.g_varchar2_table(27) := '20203D204A534F4E2E706172736528616374696F6E2E6174747269627574653033292C5C6E2020202020202020202020206F7074696F6E73202020202020202020203D204A534F4E2E706172736528616374696F6E2E6174747269627574653035292C5C';
wwv_flow_api.g_varchar2_table(28) := '6E2020202020202020202020206572726F724D65737361676573202020203D204A534F4E2E706172736528616374696F6E2E6174747269627574653036292C5C6E20202020202020202020202073796E63202020202020202020202020203D2028616374';
wwv_flow_api.g_varchar2_table(29) := '696F6E2E77616974466F72526573756C74202626206F7074696F6E732E73796E63293B5C6E5C6E202020202020202066756E6374696F6E205F68616E646C65526573706F6E7365282070446174612029207B5C6E20202020202020202020202069662870';
wwv_flow_api.g_varchar2_table(30) := '446174612E737461747573203D3D20277375636365737327297B5C6E20202020202020202020202020202020766172206974656D436F756E742C206974656D41727261793B5C6E5C6E202020202020202020202020202020202F2F726567756C61722070';
wwv_flow_api.g_varchar2_table(31) := '616765206974656D735C6E202020202020202020202020202020206966282070446174612026262070446174612E6974656D732029207B5C6E20202020202020202020202020202020202020206974656D436F756E74203D2070446174612E6974656D73';
wwv_flow_api.g_varchar2_table(32) := '2E6C656E6774683B5C6E20202020202020202020202020202020202020206974656D4172726179203D2070446174612E6974656D733B5C6E2020202020202020202020202020202020202020666F7228207661722069203D20303B2069203C206974656D';
wwv_flow_api.g_varchar2_table(33) := '436F756E743B20692B2B2029207B5C6E202020202020202020202020202020202020202020202020247328206974656D41727261795B695D2E69642C206974656D41727261795B695D2E76616C75652C206E756C6C2C206F7074696F6E732E7375707072';
wwv_flow_api.g_varchar2_table(34) := '6573734368616E67654576656E74293B5C6E20202020202020202020202020202020202020207D5C6E202020202020202020202020202020207D5C6E5C6E202020202020202020202020202020202F2F636C6F622070616765206974656D2F2076617269';
wwv_flow_api.g_varchar2_table(35) := '61626C652F207661726961626C65206173206A736F6E5C6E20202020202020202020202020202020696628636C6F6253657474696E67732E72657475726E436C6F62297B5C6E202020202020202020202020202020202020202073776974636828636C6F';
wwv_flow_api.g_varchar2_table(36) := '6253657474696E67732E72657475726E436C6F62496E746F297B5C6E202020202020202020202020202020202020202020202020636173652027706167656974656D273A5C6E202020202020202020202020202020202020202020202020202020202473';
wwv_flow_api.g_varchar2_table(37) := '28636C6F6253657474696E67732E72657475726E436C6F624974656D2C2070446174612E636C6F622C206E756C6C2C206F7074696F6E732E73757070726573734368616E67654576656E74293B5C6E202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(38) := '20202020202020627265616B3B5C6E2020202020202020202020202020202020202020202020206361736520276A6176617363726970747661726961626C65273A5C6E202020202020202020202020202020202020202020202020202020206170657875';
wwv_flow_api.g_varchar2_table(39) := '74696C732E6372656174654E65737465644F626A656374416E6441737369676E2877696E646F772C20636C6F6253657474696E67732E72657475726E436C6F625661726961626C652C2070446174612E636C6F62293B5C6E202020202020202020202020';
wwv_flow_api.g_varchar2_table(40) := '20202020202020202020202020202020627265616B3B5C6E2020202020202020202020202020202020202020202020206361736520276A6176617363726970747661726961626C656A736F6E273A5C6E2020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(41) := '2020202020202020617065787574696C732E6372656174654E65737465644F626A656374416E6441737369676E2877696E646F772C20636C6F6253657474696E67732E72657475726E436C6F625661726961626C652C204A534F4E2E7061727365287044';
wwv_flow_api.g_varchar2_table(42) := '6174612E636C6F6229293B5C6E20202020202020202020202020202020202020202020202020202020627265616B3B5C6E20202020202020202020202020202020202020202020202064656661756C743A5C6E2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(43) := '2020202020202020202020627265616B3B5C6E20202020202020202020202020202020202020207D5C6E202020202020202020202020202020207D5C6E202020202020202020202020202020205C6E202020202020202020202020202020206966287044';
wwv_flow_api.g_varchar2_table(44) := '6174612E6D657373616765297B5C6E2020202020202020202020202020202020202020617065782E6D6573736167652E73686F7750616765537563636573732870446174612E6D657373616765293B5C6E202020202020202020202020202020207D5C6E';
wwv_flow_api.g_varchar2_table(45) := '5C6E202020202020202020202020202020202F2A20526573756D6520657865637574696F6E206F6620616374696F6E73206865726520616E6420706173732066616C736520746F207468652063616C6C6261636B2C20746F20696E646963617465206E6F';
wwv_flow_api.g_varchar2_table(46) := '5C6E202020202020202020202020202020206572726F7220686173206F6363757272656420776974682074686520416A61782063616C6C2E202A2F5C6E2020202020202020202020202020202064612E726573756D652820726573756D6543616C6C6261';
wwv_flow_api.g_varchar2_table(47) := '636B2C2066616C736520293B5C6E2020202020202020202020207D20656C7365206966202870446174612E737461747573203D3D20276572726F7227297B5C6E2020202020202020202020202020202069662870446174612E6D657373616765297B5C6E';
wwv_flow_api.g_varchar2_table(48) := '5C6E20202020202020202020202020202020202020206966286F7074696F6E732E73686F774572726F724173416C657274297B5C6E202020202020202020202020202020202020202020202020617065782E6D6573736167652E616C6572742870446174';
wwv_flow_api.g_varchar2_table(49) := '612E6D657373616765293B5C6E20202020202020202020202020202020202020207D20656C7365207B5C6E2020202020202020202020202020202020202020202020202F2F20466972737420636C65617220746865206572726F72735C6E202020202020';
wwv_flow_api.g_varchar2_table(50) := '202020202020202020202020202020202020617065782E6D6573736167652E636C6561724572726F727328293B5C6E5C6E2020202020202020202020202020202020202020202020202F2F204E6F772073686F77206E6577206572726F72735C6E202020';
wwv_flow_api.g_varchar2_table(51) := '202020202020202020202020202020202020202020617065782E6D6573736167652E73686F774572726F7273285B5C6E202020202020202020202020202020202020202020202020202020207B5C6E202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(52) := '2020202020202020202020747970653A202020202020205C226572726F725C222C5C6E20202020202020202020202020202020202020202020202020202020202020206C6F636174696F6E3A2020205B5C22706167655C225D2C5C6E2020202020202020';
wwv_flow_api.g_varchar2_table(53) := '2020202020202020202020202020202020202020202020206D6573736167653A2020202070446174612E6D6573736167652C5C6E2020202020202020202020202020202020202020202020202020202020202020756E736166653A202020202066616C73';
wwv_flow_api.g_varchar2_table(54) := '655C6E202020202020202020202020202020202020202020202020202020207D5C6E2020202020202020202020202020202020202020202020205D293B5C6E20202020202020202020202020202020202020207D5C6E2020202020202020202020202020';
wwv_flow_api.g_varchar2_table(55) := '20207D5C6E2020202020202020202020207D5C6E20202020202020207D5C6E5C6E20202020202020202F2F204572726F722063616C6C6261636B2063616C6C6564207768656E2074686520416A61782063616C6C206661696C735C6E2020202020202020';
wwv_flow_api.g_varchar2_table(56) := '66756E6374696F6E205F6572726F722820706A715848522C2070546578745374617475732C20704572726F725468726F776E2029207B202020205C6E20202020202020202020202064612E68616E646C65416A61784572726F72732820706A715848522C';
wwv_flow_api.g_varchar2_table(57) := '2070546578745374617475732C20704572726F725468726F776E2C20726573756D6543616C6C6261636B20293B5C6E20202020202020207D5C6E20202020202020205C6E2020202020202020766172206C5370696E6E6572243B5C6E2020202020202020';
wwv_flow_api.g_varchar2_table(58) := '76617220756E697175654964203D206E6577204461746528292E67657454696D6528293B5C6E20202020202020205C6E20202020202020206966286C6F6164657253657474696E67732E73686F774C6F6164657229207B5C6E2020202020202020202020';
wwv_flow_api.g_varchar2_table(59) := '20737769746368286C6F6164657253657474696E67732E6C6F6164657254797065297B5C6E202020202020202020202020202020206361736520277370696E6E6572273A5C6E2020202020202020202020202020202020202020617065782E7574696C2E';
wwv_flow_api.g_varchar2_table(60) := '64656C61794C696E6765722E737461727428756E6971756549642C2066756E6374696F6E2829207B5C6E2020202020202020202020202020202020202020202020206C5370696E6E657224203D20617065787574696C732E73686F775370696E6E657228';
wwv_flow_api.g_varchar2_table(61) := '6C6F6164657253657474696E67732E6C6F61646572506F736974696F6E2C2066616C7365293B5C6E20202020202020202020202020202020202020207D293B5C6E2020202020202020202020202020202020202020627265616B3B5C6E20202020202020';
wwv_flow_api.g_varchar2_table(62) := '2020202020202020206361736520277370696E6E6572616E646F7665726C6179273A5C6E2020202020202020202020202020202020202020617065782E7574696C2E64656C61794C696E6765722E737461727428756E6971756549642C2066756E637469';
wwv_flow_api.g_varchar2_table(63) := '6F6E2829207B5C6E2020202020202020202020202020202020202020202020206C5370696E6E657224203D20617065787574696C732E73686F775370696E6E6572286C6F6164657253657474696E67732E6C6F61646572506F736974696F6E2C20747275';
wwv_flow_api.g_varchar2_table(64) := '65293B5C6E20202020202020202020202020202020202020207D293B5C6E2020202020202020202020202020202020202020627265616B3B5C6E2020202020202020202020202020202064656661756C743A5C6E20202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(65) := '20202020627265616B3B5C6E2020202020202020202020207D5C6E20202020202020207D5C6E20202020202020205C6E20202020202020207661722068616E646C655F7370696E6E6572203D2066756E6374696F6E28297B5C6E20202020202020202020';
wwv_flow_api.g_varchar2_table(66) := '20206966286C6F6164657253657474696E67732E73686F774C6F61646572297B5C6E20202020202020202020202020202020617065782E7574696C2E64656C61794C696E6765722E66696E69736828756E6971756549642C2066756E6374696F6E28297B';
wwv_flow_api.g_varchar2_table(67) := '5C6E20202020202020202020202020202020202020206966286C5370696E6E657224297B5C6E2020202020202020202020202020202020202020202020206C5370696E6E6572242E72656D6F766528293B5C6E2020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(68) := '2020207D5C6E202020202020202020202020202020207D293B20205C6E2020202020202020202020207D5C6E20202020202020207D3B5C6E5C6E202020202020202076617220636C6F62546F5375626D69743B5C6E5C6E2020202020202020696628636C';
wwv_flow_api.g_varchar2_table(69) := '6F6253657474696E67732E7375626D6974436C6F62297B5C6E20202020202020202020202073776974636828636C6F6253657474696E67732E7375626D6974436C6F6246726F6D297B5C6E20202020202020202020202020202020636173652027706167';
wwv_flow_api.g_varchar2_table(70) := '656974656D273A5C6E2020202020202020202020202020202020202020636C6F62546F5375626D6974203D206974656D28636C6F6253657474696E67732E7375626D6974436C6F624974656D292E67657456616C756528293B5C6E202020202020202020';
wwv_flow_api.g_varchar2_table(71) := '2020202020202020202020627265616B3B5C6E202020202020202020202020202020206361736520276A6176617363726970747661726961626C65273A5C6E202020202020202020202020202020202020202076617220746F5375626D6974203D207769';
wwv_flow_api.g_varchar2_table(72) := '6E646F775B636C6F6253657474696E67732E7375626D6974436C6F625661726961626C655D3B5C6E5C6E2020202020202020202020202020202020202020696628746F5375626D697420696E7374616E63656F66204F626A656374297B5C6E2020202020';
wwv_flow_api.g_varchar2_table(73) := '20202020202020202020202020202020202020636C6F62546F5375626D6974203D204A534F4E2E737472696E6769667928746F5375626D6974293B5C6E20202020202020202020202020202020202020207D20656C7365207B5C6E202020202020202020';
wwv_flow_api.g_varchar2_table(74) := '202020202020202020202020202020636C6F62546F5375626D6974203D20746F5375626D69743B5C6E20202020202020202020202020202020202020207D5C6E2020202020202020202020202020202020202020627265616B3B5C6E2020202020202020';
wwv_flow_api.g_varchar2_table(75) := '202020202020202064656661756C743A5C6E2020202020202020202020202020202020202020627265616B3B5C6E2020202020202020202020207D5C6E20202020202020207D5C6E5C6E20202020202020207365727665722E706C7567696E2861637469';
wwv_flow_api.g_varchar2_table(76) := '6F6E2E616A61784964656E7469666965722C5C6E2020202020202020202020207B5C6E20202020202020202020202020202020706167654974656D73202020202020203A20706167654974656D732E6974656D73546F5375626D69742C2020202F2F2041';
wwv_flow_api.g_varchar2_table(77) := '6C726561647920696E206A51756572792073656C6563746F722073796E7461785C6E20202020202020202020202020202020705F636C6F625F3031202020202020203A20636C6F62546F5375626D69745C6E2020202020202020202020207D2C5C6E2020';
wwv_flow_api.g_varchar2_table(78) := '202020202020202020207B5C6E20202020202020202020202020202020646174615479706520202020202020203A20276A736F6E272C5C6E202020202020202020202020202020206C6F6164696E67496E64696361746F723A20706167654974656D732E';
wwv_flow_api.g_varchar2_table(79) := '6974656D73546F52657475726E2C2020202F2F20446973706C6179656420666F7220616C6C205C2250616765204974656D7320746F2052657475726E5C225C6E20202020202020202020202020202020737563636573732020202020202020203A206675';
wwv_flow_api.g_varchar2_table(80) := '6E6374696F6E287044617461297B5C6E202020202020202020202020202020202020202068616E646C655F7370696E6E657228293B5C6E20202020202020202020202020202020202020205F68616E646C65526573706F6E7365287044617461293B5C6E';
wwv_flow_api.g_varchar2_table(81) := '202020202020202020202020202020207D2C5C6E202020202020202020202020202020206572726F7220202020202020202020203A2066756E6374696F6E28706A715848522C2070546578745374617475732C20704572726F725468726F776E297B5C6E';
wwv_flow_api.g_varchar2_table(82) := '202020202020202020202020202020202020202068616E646C655F7370696E6E657228293B5C6E20202020202020202020202020202020202020205F6572726F722820706A715848522C2070546578745374617475732C20704572726F725468726F776E';
wwv_flow_api.g_varchar2_table(83) := '20293B5C6E202020202020202020202020202020207D2C5C6E202020202020202020202020202020206173796E6320202020202020202020203A202173796E632C5C6E20202020202020202020202020202020746172676574202020202020202020203A';
wwv_flow_api.g_varchar2_table(84) := '20746869732E62726F777365724576656E742E7461726765745C6E2020202020202020202020207D5C6E2020202020202020293B5C6E202020207D3B5C6E7D2928617065782E64612C20617065782E7365727665722C20617065782E6974656D2C206170';
wwv_flow_api.g_varchar2_table(85) := '65782E6A5175657279293B225D2C2266696C65223A227363726970742E6A73227D';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(28716774266209775)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_file_name=>'js/script.js.map'
,p_mime_type=>'application/octet-stream'
,p_file_charset=>'utf-8'
,p_file_content=>wwv_flow_api.varchar2_to_blob(wwv_flow_api.g_varchar2_table)
);
end;
/
begin
wwv_flow_api.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false), p_is_component_import => true);
commit;
end;
/
set verify on feedback on define on
prompt  ...done
