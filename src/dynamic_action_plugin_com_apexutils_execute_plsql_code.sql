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
'    ',
'    l_action_identifier     varchar2(4000) := p_dynamic_action.attribute_14;',
'',
'    --extra options',
'    l_suppress_change_event boolean := instr(p_dynamic_action.attribute_15, ''suppressChangeEvent'') > 0;',
'    l_show_error_as_alert   boolean := instr(p_dynamic_action.attribute_15, ''showErrorAsAlert'')    > 0;',
'    l_sync                  boolean := apex_application.g_compatibility_mode < 5.1;',
'    ',
'    ',
'    --other',
'    l_js_file               varchar2(4000);',
'',
'begin',
'',
'    l_result.javascript_function := ''apexutils.executePlSqlCode'';',
'    l_result.ajax_identifier     := apex_plugin.get_ajax_identifier;',
'    ',
'    if apex_application.g_debug then',
'        apex_plugin_util.debug_dynamic_action( p_plugin         => p_plugin',
'                                             , p_dynamic_action => p_dynamic_action',
'                                             );',
'    end if;',
'    ',
'    apex_javascript.add_library( p_name           => ''script''',
'                               , p_directory      => p_plugin.file_prefix||''/js/''',
'                               , p_version        => NULL',
'                               , p_skip_extension => FALSE',
'                               );',
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
'    --attribute_04: action identifier',
'    l_result.attribute_04        := l_action_identifier;',
'    ',
'    --attribute_05: extra options',
'    l_result.attribute_05        := ''{'' || apex_javascript.add_attribute(''suppressChangeEvent'', l_suppress_change_event, false)',
'                                        || apex_javascript.add_attribute(''showErrorAsAlert''   , l_show_error_as_alert  , false)',
'                                        || apex_javascript.add_attribute(''sync''               , l_sync                 , false, false) ||',
'                                    ''}'';',
'',
'    --attribute_06: helps identify possible error messages',
'    l_result.attribute_06        := ''{'' || apex_javascript.add_attribute( ''sessionExpiredError''',
'                                                                        , wwv_flow_lang.custom_runtime_message(''APEX.SESSION.EXPIRED'')',
'                                                                        , false',
'                                                                        , false) || ',
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
'    ',
'begin',
'    ',
'    apex_plugin_util.execute_plsql_code( p_plsql_code => l_statement );',
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
'            apex_json.write(''id'', apex_plugin_util.item_names_to_dom( p_item_names     => l_item_names(i)',
'                                                                    , p_dynamic_action => p_dynamic_action',
'                                                                    )',
'                           );',
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
'    l_message := replace(l_message, ''#SQLCODE#'', SQLCODE);',
'    l_message := replace(l_message, ''#SQLERRM#'', SQLERRM);',
'    ',
'    apex_json.write(''message'', l_message);',
'    ',
'    apex_json.close_object;',
'    ',
'    return l_result;',
'end ajax;',
'',
' '))
,p_api_version=>1
,p_render_function=>'render'
,p_ajax_function=>'ajax'
,p_standard_attributes=>'STOP_EXECUTION_ON_ERROR:WAIT_FOR_RESULT'
,p_substitute_attributes=>true
,p_subscribe_plugin_settings=>true
,p_help_text=>'Executes PL/SQL code on the server.'
,p_version_identifier=>'1.0'
,p_about_url=>'https://www.apexutils.com'
,p_files_version=>2
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
);
wwv_flow_api.create_plugin_attribute(
 p_id=>wwv_flow_api.id(23120194899935851)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>14
,p_display_sequence=>140
,p_prompt=>'Action Identifier'
,p_attribute_type=>'TEXT'
,p_is_required=>false
,p_is_translatable=>false
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
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(22913968621837052)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_name=>'au-execute-plsql-error'
,p_display_name=>'APEX Utils - Execute PL/SQL Code - On Error'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(22913537842837052)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_name=>'au-execute-plsql-finish'
,p_display_name=>'APEX Utils - Execute PL/SQL Code - Finished'
);
wwv_flow_api.create_plugin_event(
 p_id=>wwv_flow_api.id(22913220317837051)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_name=>'au-execute-plsql-start'
,p_display_name=>'APEX Utils - Execute PL/SQL Code - Started'
);
end;
/
begin
wwv_flow_api.g_varchar2_table := wwv_flow_api.empty_varchar2_table;
wwv_flow_api.g_varchar2_table(1) := '7661722074656D705374796C65203D20646F63756D656E742E637265617465456C656D656E7428277374796C6527293B0A74656D705374796C652E747970653D22746578742F637373223B0A74656D705374796C652E696E6E657248544D4C203D20272E';
wwv_flow_api.g_varchar2_table(2) := '61752D657865637574652D637573746F6D5370696E6E6572436C6173737B27202B0A2020202027706F736974696F6E3A206162736F6C7574652021696D706F7274616E743B27202B0A20202020276C6566743A20302021696D706F7274616E743B27202B';
wwv_flow_api.g_varchar2_table(3) := '0A202020202772696768743A20302021696D706F7274616E743B27202B0A20202020276D617267696E3A206175746F2021696D706F7274616E743B27202B0A2020202027746F703A20302021696D706F7274616E743B27202B0A2020202027626F74746F';
wwv_flow_api.g_varchar2_table(4) := '6D3A20302021696D706F7274616E743B27202B0A20202020277A2D696E6465783A203435303B7D273B0A646F63756D656E742E686561642E617070656E644368696C642874656D705374796C65293B0A0A76617220617065787574696C73203D20746869';
wwv_flow_api.g_varchar2_table(5) := '732E617065787574696C73207C7C207B7D3B0A0A2866756E6374696F6E2864612C207365727665722C206974656D2C202429207B0A0A20202020617065787574696C732E73686F775370696E6E6572203D2066756E6374696F6E20287053656C6563746F';
wwv_flow_api.g_varchar2_table(6) := '722C20704F7665726C617929207B0A20202020202020200A2020202020202020766172206C5370696E6E65722C0A2020202020202020202020206C57616974506F707570243B0A20202020202020200A2020202020202020696628704F7665726C617929';
wwv_flow_api.g_varchar2_table(7) := '7B0A20202020202020202020202076617220626F64795374796C652020203D2027706F736974696F6E3A2066697865643B202020207A2D696E6465783A20313930303B207669736962696C6974793A2076697369626C653B2077696474683A2031303025';
wwv_flow_api.g_varchar2_table(8) := '3B206865696768743A20313030253B206261636B67726F756E643A2072676261283235352C203235352C203235352C20302E35293B273B0A202020202020202020202020766172206E6F726D616C5374796C65203D2027706F736974696F6E3A20616273';
wwv_flow_api.g_varchar2_table(9) := '6F6C7574653B207A2D696E6465783A203434303B20207669736962696C6974793A2076697369626C653B2077696474683A20313030253B206865696768743A20313030253B206261636B67726F756E643A2072676261283235352C203235352C20323535';
wwv_flow_api.g_varchar2_table(10) := '2C20302E35293B273B0A0A2020202020202020202020206C57616974506F70757024203D20242820273C646976207374796C653D2227202B20287053656C6563746F72203D3D2027626F647927203F20626F64795374796C65203A206E6F726D616C5374';
wwv_flow_api.g_varchar2_table(11) := '796C6529202B2027223E3C2F6469763E2720292E70726570656E64546F282024287053656C6563746F722920293B0A20202020202020207D0A0A20202020202020206C5370696E6E6572203D20617065782E7574696C2E73686F775370696E6E65722870';
wwv_flow_api.g_varchar2_table(12) := '53656C6563746F722C20287053656C6563746F72203D3D2027626F647927203F207B66697865643A20747275657D203A207B7370696E6E6572436C6173733A202761752D657865637574652D637573746F6D5370696E6E6572436C617373277D29293B0A';
wwv_flow_api.g_varchar2_table(13) := '0A202020202020202072657475726E207B0A20202020202020202020202072656D6F76653A2066756E6374696F6E202829207B0A20202020202020202020202020202020696620286C57616974506F7075702420213D3D20756E646566696E656429207B';
wwv_flow_api.g_varchar2_table(14) := '0A20202020202020202020202020202020202020206C57616974506F707570242E72656D6F766528293B0A202020202020202020202020202020207D0A2020202020202020202020202020202069662028206C5370696E6E657220213D3D20756E646566';
wwv_flow_api.g_varchar2_table(15) := '696E65642029207B0A20202020202020202020202020202020202020206C5370696E6E65722E72656D6F766528293B0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020207D3B0A202020207D3B0A0A20';
wwv_flow_api.g_varchar2_table(16) := '2020202F2F6275696C64732061206E6573746564206F626A65637420696620697420646F65736E277420657869737420616E642061737369676E7320697420612076616C75650A20202020617065787574696C732E6372656174654E65737465644F626A';
wwv_flow_api.g_varchar2_table(17) := '656374416E6441737369676E203D2066756E6374696F6E286F626A2C206B6579506174682C2076616C756529207B0A20202020202020206B657950617468203D206B6579506174682E73706C697428272E27293B0A20202020202020206C6173744B6579';
wwv_flow_api.g_varchar2_table(18) := '496E646578203D206B6579506174682E6C656E6774682D313B0A2020202020202020666F7220287661722069203D20303B2069203C206C6173744B6579496E6465783B202B2B206929207B0A2020202020202020202020206B6579203D206B6579506174';
wwv_flow_api.g_varchar2_table(19) := '685B695D3B0A2020202020202020202020206966202821286B657920696E206F626A29297B0A202020202020202020202020202020206F626A5B6B65795D203D207B7D3B0A2020202020202020202020207D0A2020202020202020202020206F626A203D';
wwv_flow_api.g_varchar2_table(20) := '206F626A5B6B65795D3B0A20202020202020207D0A20202020202020206F626A5B6B6579506174685B6C6173744B6579496E6465785D5D203D2076616C75653B0A202020207D3B0A202020200A20202020617065787574696C732E65786563757465506C';
wwv_flow_api.g_varchar2_table(21) := '53716C436F6465203D2066756E6374696F6E28297B0A20202020202020200A2020202020202020617065782E646562756728274578656375746520504C2F53514C20436F646520272C2074686973293B0A0A202020202020202076617220616374696F6E';
wwv_flow_api.g_varchar2_table(22) := '20202020202020202020203D20746869732E616374696F6E2C0A202020202020202020202020726573756D6543616C6C6261636B2020203D20746869732E726573756D6543616C6C6261636B2C0A202020202020202020202020706167654974656D7320';
wwv_flow_api.g_varchar2_table(23) := '202020202020203D204A534F4E2E706172736528616374696F6E2E6174747269627574653031292C0A2020202020202020202020206C6F6164657253657474696E67732020203D204A534F4E2E706172736528616374696F6E2E61747472696275746530';
wwv_flow_api.g_varchar2_table(24) := '32292C0A202020202020202020202020636C6F6253657474696E677320202020203D204A534F4E2E706172736528616374696F6E2E6174747269627574653033292C0A202020202020202020202020616374696F6E4964656E746966696572203D206163';
wwv_flow_api.g_varchar2_table(25) := '74696F6E2E61747472696275746530342C0A2020202020202020202020206F7074696F6E73202020202020202020203D204A534F4E2E706172736528616374696F6E2E6174747269627574653035292C0A2020202020202020202020206572726F724D65';
wwv_flow_api.g_varchar2_table(26) := '737361676573202020203D204A534F4E2E706172736528616374696F6E2E6174747269627574653036292C0A20202020202020202020202073796E63202020202020202020202020203D2028616374696F6E2E77616974466F72526573756C7420262620';
wwv_flow_api.g_varchar2_table(27) := '6F7074696F6E732E73796E63293B0A0A20202020202020200A20202020202020202F2A204576656E74202261752D657865637574652D706C73716C2D737461727422202A2F0A2020202020202020766172206576656E7444617461203D207B0A20202020';
wwv_flow_api.g_varchar2_table(28) := '202020202020202070726576656E7444656661756C743A2066616C73652C0A2020202020202020202020206576656E7449643A20616374696F6E4964656E7469666965720A20202020202020207D3B0A20202020202020200A2020202020202020242864';
wwv_flow_api.g_varchar2_table(29) := '6F63756D656E74292E74726967676572282761752D657865637574652D706C73716C2D7374617274272C206576656E7444617461293B0A0A20202020202020206966286576656E74446174612E70726576656E7444656661756C74297B0A202020202020';
wwv_flow_api.g_varchar2_table(30) := '202020202020617065782E646562756728274578656375746520504C2F53514C20436F646520657865637574696F6E2077697468204576656E74204964656E746966696572202227202B20616374696F6E4964656E746966696572202B20272220776173';
wwv_flow_api.g_varchar2_table(31) := '2070726576656E7465642E27293B0A20202020202020202020202072657475726E3B0A20202020202020207D0A20202020202020202F2A202D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D202A2F0A0A20202020202020202F';
wwv_flow_api.g_varchar2_table(32) := '2F2043616C6C65642062792074686520414A415820636C6561722063616C6C6261636B20746F20636C656172207468652076616C75657320696E20746865202250616765204974656D7320746F2052657475726E220A202020202020202066756E637469';
wwv_flow_api.g_varchar2_table(33) := '6F6E205F636C6561722829207B0A0A2020202020202020202020202F2F204F6E6C7920636C6561722069662063616C6C206973206173796E632E20436C656172696E6720686173206E6F2065666665637420666F722073796E6368726F6E6F7573206361';
wwv_flow_api.g_varchar2_table(34) := '6C6C7320616E6420697320616C736F206B6E6F776E20746F2063617573650A2020202020202020202020202F2F20697373756573207769746820636F6D706F6E656E7473207468617420757365206173796E63207365742076616C7565206D656368616E';
wwv_flow_api.g_varchar2_table(35) := '69736D73202862756720233230373730393335292E0A20202020202020202020202069662028202173796E632029207B0A20202020202020202020202020202020242820706167654974656D732E6974656D73546F52657475726E2C20617065782E6750';
wwv_flow_api.g_varchar2_table(36) := '616765436F6E746578742420292E656163682866756E6374696F6E202829207B0A2020202020202020202020202020202020202020247328746869732C2022222C206E756C6C2C2074727565293B0A202020202020202020202020202020207D293B0A20';
wwv_flow_api.g_varchar2_table(37) := '20202020202020202020207D0A20202020202020207D0A0A202020202020202066756E6374696F6E205F68616E646C65526573706F6E7365282070446174612029207B0A20202020202020202020202069662870446174612E737461747573203D3D2027';
wwv_flow_api.g_varchar2_table(38) := '7375636365737327297B0A20202020202020202020202020202020766172206974656D436F756E742C206974656D41727261793B0A0A202020202020202020202020202020202F2F726567756C61722070616765206974656D730A202020202020202020';
wwv_flow_api.g_varchar2_table(39) := '202020202020206966282070446174612026262070446174612E6974656D732029207B0A20202020202020202020202020202020202020206974656D436F756E74203D2070446174612E6974656D732E6C656E6774683B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(40) := '20202020202020206974656D4172726179203D2070446174612E6974656D733B0A2020202020202020202020202020202020202020666F7228207661722069203D20303B2069203C206974656D436F756E743B20692B2B2029207B0A2020202020202020';
wwv_flow_api.g_varchar2_table(41) := '20202020202020202020202020202020247328206974656D41727261795B695D2E69642C206974656D41727261795B695D2E76616C75652C206E756C6C2C206F7074696F6E732E73757070726573734368616E67654576656E74293B0A20202020202020';
wwv_flow_api.g_varchar2_table(42) := '202020202020202020202020207D0A202020202020202020202020202020207D0A0A202020202020202020202020202020202F2F636C6F622070616765206974656D2F207661726961626C652F207661726961626C65206173206A736F6E0A2020202020';
wwv_flow_api.g_varchar2_table(43) := '2020202020202020202020696628636C6F6253657474696E67732E72657475726E436C6F62297B0A202020202020202020202020202020202020202073776974636828636C6F6253657474696E67732E72657475726E436C6F62496E746F297B0A202020';
wwv_flow_api.g_varchar2_table(44) := '202020202020202020202020202020202020202020636173652027706167656974656D273A0A20202020202020202020202020202020202020202020202020202020247328636C6F6253657474696E67732E72657475726E436C6F624974656D2C207044';
wwv_flow_api.g_varchar2_table(45) := '6174612E636C6F622C206E756C6C2C206F7074696F6E732E73757070726573734368616E67654576656E74293B0A20202020202020202020202020202020202020202020202020202020627265616B3B0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(46) := '20202020206361736520276A6176617363726970747661726961626C65273A0A20202020202020202020202020202020202020202020202020202020617065787574696C732E6372656174654E65737465644F626A656374416E6441737369676E287769';
wwv_flow_api.g_varchar2_table(47) := '6E646F772C20636C6F6253657474696E67732E72657475726E436C6F625661726961626C652C2070446174612E636C6F62293B0A20202020202020202020202020202020202020202020202020202020627265616B3B0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(48) := '20202020202020202020206361736520276A6176617363726970747661726961626C656A736F6E273A0A20202020202020202020202020202020202020202020202020202020617065787574696C732E6372656174654E65737465644F626A656374416E';
wwv_flow_api.g_varchar2_table(49) := '6441737369676E2877696E646F772C20636C6F6253657474696E67732E72657475726E436C6F625661726961626C652C204A534F4E2E70617273652870446174612E636C6F6229293B0A2020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(50) := '2020627265616B3B0A20202020202020202020202020202020202020202020202064656661756C743A0A20202020202020202020202020202020202020202020202020202020627265616B3B0A20202020202020202020202020202020202020207D0A20';
wwv_flow_api.g_varchar2_table(51) := '2020202020202020202020202020207D0A202020202020202020202020202020200A2020202020202020202020202020202069662870446174612E6D657373616765297B0A2020202020202020202020202020202020202020617065782E6D6573736167';
wwv_flow_api.g_varchar2_table(52) := '652E73686F7750616765537563636573732870446174612E6D657373616765293B0A202020202020202020202020202020207D0A0A202020202020202020202020202020202F2A20526573756D6520657865637574696F6E206F6620616374696F6E7320';
wwv_flow_api.g_varchar2_table(53) := '6865726520616E6420706173732066616C736520746F207468652063616C6C6261636B2C20746F20696E646963617465206E6F0A202020202020202020202020202020206572726F7220686173206F6363757272656420776974682074686520416A6178';
wwv_flow_api.g_varchar2_table(54) := '2063616C6C2E202A2F0A2020202020202020202020202020202064612E726573756D652820726573756D6543616C6C6261636B2C2066616C736520293B0A2020202020202020202020207D20656C7365206966202870446174612E737461747573203D3D';
wwv_flow_api.g_varchar2_table(55) := '20276572726F7227297B0A2020202020202020202020202020202069662870446174612E6D657373616765297B0A0A20202020202020202020202020202020202020206966286F7074696F6E732E73686F774572726F724173416C657274297B0A202020';
wwv_flow_api.g_varchar2_table(56) := '202020202020202020202020202020202020202020617065782E6D6573736167652E616C6572742870446174612E6D657373616765293B0A20202020202020202020202020202020202020207D20656C7365207B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(57) := '2020202020202020202F2F20466972737420636C65617220746865206572726F72730A202020202020202020202020202020202020202020202020617065782E6D6573736167652E636C6561724572726F727328293B0A0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(58) := '2020202020202020202020202F2F204E6F772073686F77206E6577206572726F72730A202020202020202020202020202020202020202020202020617065782E6D6573736167652E73686F774572726F7273285B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(59) := '202020202020202020202020207B0A2020202020202020202020202020202020202020202020202020202020202020747970653A20202020202020226572726F72222C0A2020202020202020202020202020202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(60) := '6C6F636174696F6E3A2020205B2270616765225D2C0A20202020202020202020202020202020202020202020202020202020202020206D6573736167653A2020202070446174612E6D6573736167652C0A20202020202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(61) := '20202020202020202020202020756E736166653A202020202066616C73650A202020202020202020202020202020202020202020202020202020207D0A2020202020202020202020202020202020202020202020205D293B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(62) := '2020202020202020207D0A202020202020202020202020202020207D0A2020202020202020202020207D0A20202020202020207D0A0A20202020202020202F2F204572726F722063616C6C6261636B2063616C6C6564207768656E2074686520416A6178';
wwv_flow_api.g_varchar2_table(63) := '2063616C6C206661696C730A202020202020202066756E6374696F6E205F6572726F722820706A715848522C2070546578745374617475732C20704572726F725468726F776E2029207B0A2020202020202020202020200A202020202020202020202020';
wwv_flow_api.g_varchar2_table(64) := '7661722064617461203D207B0A20202020202020202020202020202020706A715848523A20706A715848522C0A2020202020202020202020202020202070546578745374617475733A2070546578745374617475732C0A20202020202020202020202020';
wwv_flow_api.g_varchar2_table(65) := '202020704572726F725468726F776E3A20704572726F725468726F776E2C0A2020202020202020202020202020202073657373696F6E457870697265643A20704572726F725468726F776E203D3D3D206572726F724D657373616765732E73657373696F';
wwv_flow_api.g_varchar2_table(66) := '6E457870697265644572726F722C0A202020202020202020202020202020206576656E7449643A20616374696F6E4964656E7469666965722C0A2020202020202020202020202020202070726576656E7444656661756C743A2066616C73650A20202020';
wwv_flow_api.g_varchar2_table(67) := '20202020202020207D3B0A20202020202020202020200A2020202020202020202020202428646F63756D656E74292E74726967676572282761752D65786563757465706C73716C2D6572726F72272C2064617461293B0A2020202020202020202020200A';
wwv_flow_api.g_varchar2_table(68) := '20202020202020202020202069662821646174612E70726576656E7444656661756C74297B0A2020202020202020202020202020202064612E68616E646C65416A61784572726F72732820706A715848522C2070546578745374617475732C2070457272';
wwv_flow_api.g_varchar2_table(69) := '6F725468726F776E2C20726573756D6543616C6C6261636B20293B0A2020202020202020202020207D0A20202020202020207D0A20202020202020200A2020202020202020766172206C5370696E6E6572243B0A202020202020202076617220756E6971';
wwv_flow_api.g_varchar2_table(70) := '75654964203D206E6577204461746528292E67657454696D6528293B0A20202020202020200A20202020202020206966286C6F6164657253657474696E67732E73686F774C6F6164657229207B0A202020202020202020202020737769746368286C6F61';
wwv_flow_api.g_varchar2_table(71) := '64657253657474696E67732E6C6F6164657254797065297B0A202020202020202020202020202020206361736520277370696E6E6572273A0A2020202020202020202020202020202020202020617065782E7574696C2E64656C61794C696E6765722E73';
wwv_flow_api.g_varchar2_table(72) := '7461727428756E6971756549642C2066756E6374696F6E2829207B0A2020202020202020202020202020202020202020202020206C5370696E6E657224203D20617065787574696C732E73686F775370696E6E6572286C6F6164657253657474696E6773';
wwv_flow_api.g_varchar2_table(73) := '2E6C6F61646572506F736974696F6E2C2066616C7365293B0A20202020202020202020202020202020202020207D293B0A2020202020202020202020202020202020202020627265616B3B0A202020202020202020202020202020206361736520277370';
wwv_flow_api.g_varchar2_table(74) := '696E6E6572616E646F7665726C6179273A0A2020202020202020202020202020202020202020617065782E7574696C2E64656C61794C696E6765722E737461727428756E6971756549642C2066756E6374696F6E2829207B0A2020202020202020202020';
wwv_flow_api.g_varchar2_table(75) := '202020202020202020202020206C5370696E6E657224203D20617065787574696C732E73686F775370696E6E6572286C6F6164657253657474696E67732E6C6F61646572506F736974696F6E2C2074727565293B0A202020202020202020202020202020';
wwv_flow_api.g_varchar2_table(76) := '20202020207D293B0A2020202020202020202020202020202020202020627265616B3B0A2020202020202020202020202020202064656661756C743A0A2020202020202020202020202020202020202020627265616B3B0A202020202020202020202020';
wwv_flow_api.g_varchar2_table(77) := '7D0A20202020202020207D0A20202020202020200A20202020202020207661722068616E646C655F7370696E6E6572203D2066756E6374696F6E28297B0A2020202020202020202020206966286C6F6164657253657474696E67732E73686F774C6F6164';
wwv_flow_api.g_varchar2_table(78) := '6572297B0A20202020202020202020202020202020617065782E7574696C2E64656C61794C696E6765722E66696E69736828756E6971756549642C2066756E6374696F6E28297B0A20202020202020202020202020202020202020206966286C5370696E';
wwv_flow_api.g_varchar2_table(79) := '6E657224297B0A2020202020202020202020202020202020202020202020206C5370696E6E6572242E72656D6F766528293B0A20202020202020202020202020202020202020207D0A202020202020202020202020202020207D293B20200A2020202020';
wwv_flow_api.g_varchar2_table(80) := '202020202020207D0A20202020202020207D3B0A0A202020202020202076617220636C6F62546F5375626D69743B0A0A2020202020202020696628636C6F6253657474696E67732E7375626D6974436C6F62297B0A202020202020202020202020737769';
wwv_flow_api.g_varchar2_table(81) := '74636828636C6F6253657474696E67732E7375626D6974436C6F6246726F6D297B0A20202020202020202020202020202020636173652027706167656974656D273A0A2020202020202020202020202020202020202020636C6F62546F5375626D697420';
wwv_flow_api.g_varchar2_table(82) := '3D206974656D28636C6F6253657474696E67732E7375626D6974436C6F624974656D292E67657456616C756528293B0A2020202020202020202020202020202020202020627265616B3B0A202020202020202020202020202020206361736520276A6176';
wwv_flow_api.g_varchar2_table(83) := '617363726970747661726961626C65273A0A2020202020202020202020202020202020202020636C6F62546F5375626D6974203D2077696E646F775B636C6F6253657474696E67732E7375626D6974436C6F625661726961626C655D3B0A202020202020';
wwv_flow_api.g_varchar2_table(84) := '2020202020202020202020202020627265616B3B0A2020202020202020202020202020202064656661756C743A0A2020202020202020202020202020202020202020627265616B3B0A2020202020202020202020207D0A20202020202020207D0A0A2020';
wwv_flow_api.g_varchar2_table(85) := '2020202020207365727665722E706C7567696E202820616374696F6E2E616A61784964656E7469666965722C207B0A20202020202020202020202020202020706167654974656D73202020202020203A20706167654974656D732E6974656D73546F5375';
wwv_flow_api.g_varchar2_table(86) := '626D69742C2020202F2F20416C726561647920696E206A51756572792073656C6563746F722073796E7461780A20202020202020202020202020202020705F636C6F625F3031202020202020203A20636C6F62546F5375626D69740A2020202020202020';
wwv_flow_api.g_varchar2_table(87) := '202020207D2C207B0A20202020202020202020202020202020646174615479706520202020202020203A20276A736F6E272C0A202020202020202020202020202020206C6F6164696E67496E64696361746F723A20706167654974656D732E6974656D73';
wwv_flow_api.g_varchar2_table(88) := '546F52657475726E2C2020202F2F20446973706C6179656420666F7220616C6C202250616765204974656D7320746F2052657475726E220A20202020202020202020202020202020636C65617220202020202020202020203A205F636C6561722C202020';
wwv_flow_api.g_varchar2_table(89) := '20202020202020202020202020202020202F2F20436C6561727320616C6C202250616765204974656D7320746F2052657475726E22206265666F7265207468652063616C6C0A202020202020202020202020202020207375636365737320202020202020';
wwv_flow_api.g_varchar2_table(90) := '20203A2066756E6374696F6E287044617461297B0A202020202020202020202020202020202020202068616E646C655F7370696E6E657228293B0A20202020202020202020202020202020202020205F68616E646C65526573706F6E7365287044617461';
wwv_flow_api.g_varchar2_table(91) := '293B0A202020202020202020202020202020207D2C0A202020202020202020202020202020206572726F7220202020202020202020203A2066756E6374696F6E28706A715848522C2070546578745374617475732C20704572726F725468726F776E297B';
wwv_flow_api.g_varchar2_table(92) := '0A202020202020202020202020202020202020202068616E646C655F7370696E6E657228293B0A20202020202020202020202020202020202020205F6572726F722820706A715848522C2070546578745374617475732C20704572726F725468726F776E';
wwv_flow_api.g_varchar2_table(93) := '20293B0A202020202020202020202020202020207D2C0A202020202020202020202020202020206173796E6320202020202020202020203A202173796E632C0A20202020202020202020202020202020746172676574202020202020202020203A207468';
wwv_flow_api.g_varchar2_table(94) := '69732E62726F777365724576656E742E7461726765740A2020202020202020202020207D0A2020202020202020293B0A202020207D3B0A7D2928617065782E64612C20617065782E7365727665722C20617065782E6974656D2C20617065782E6A517565';
wwv_flow_api.g_varchar2_table(95) := '7279293B';
null;
end;
/
begin
wwv_flow_api.create_plugin_file(
 p_id=>wwv_flow_api.id(23283577776894160)
,p_plugin_id=>wwv_flow_api.id(1843861354211161477)
,p_file_name=>'js/script.js'
,p_mime_type=>'application/javascript'
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
