*&---------------------------------------------------------------------*
*& Report  ZP_SF_HRDB2_REPLI
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zp_sf_hrdb2_repli.

TYPES: BEGIN OF s___metadata,
         uri  TYPE string,
         type TYPE string,
       END OF s___metadata.
TYPES: BEGIN OF s_picklistlabels_results,
         __metadata TYPE s___metadata,
         locale     TYPE string,
         label      TYPE string,
       END OF s_picklistlabels_results,
       t_picklistlabels_results TYPE STANDARD TABLE OF s_picklistlabels_results WITH EMPTY KEY.
TYPES: BEGIN OF s_picklistlabels,
         results TYPE t_picklistlabels_results,
       END OF s_picklistlabels.

TYPES: BEGIN OF s_customstring1nav,
         __metadata   TYPE s___metadata,
*         picklistlabels TYPE s_picklistlabels,
         externalcode TYPE string,
       END OF s_customstring1nav.
TYPES: BEGIN OF s_positionnav,
         __metadata         TYPE s___metadata,
         externalname_en_us TYPE string,
       END OF s_positionnav.
TYPES: BEGIN OF s_customstring2nav,
         __metadata     TYPE s___metadata,
         picklistlabels TYPE s_picklistlabels,
       END OF s_customstring2nav.
TYPES: s_customstring6nav TYPE s_customstring2nav.
*TYPES: BEGIN OF s_costcenternav,
*         __metadata TYPE s___metadata,
*         name_zh_cn TYPE string,
*       END OF s_costcenternav.
TYPES: BEGIN OF s_employeeclassnav,
         __metadata     TYPE s___metadata,
         externalcode   TYPE string,
         picklistlabels TYPE s_picklistlabels,
       END OF s_employeeclassnav.
TYPES: s_worklocationnav TYPE s_customstring2nav.
TYPES: BEGIN OF s_companynav,
         __metadata        TYPE s___metadata,
         name_defaultvalue TYPE string,
       END OF s_companynav.

TYPES: BEGIN OF s_personalinfonav_results,
         __metadata TYPE s___metadata,
         lastname   TYPE string,
         firstname  TYPE string,
       END OF s_personalinfonav_results,
       t_personalinfonav_results TYPE STANDARD TABLE OF s_personalinfonav_results WITH EMPTY KEY.
TYPES: BEGIN OF s_personalinfonav,
         results TYPE t_personalinfonav_results,
       END OF s_personalinfonav.
TYPES: BEGIN OF s_phonenav_results,
         __metadata  TYPE s___metadata,
         phonetype   TYPE string,
         extension   TYPE string,
         phonenumber TYPE string,
       END OF s_phonenav_results,
       t_phonenav_results TYPE STANDARD TABLE OF s_phonenav_results WITH EMPTY KEY.
TYPES: BEGIN OF s_phonenav,
         results TYPE t_phonenav_results,
       END OF s_phonenav.
TYPES: BEGIN OF s_emailnav_results,
         __metadata    TYPE s___metadata,
         emailtype     TYPE string,
         emailaddress  TYPE string,
         customstring1 TYPE string,
         customstring2 TYPE string,
       END OF s_emailnav_results,
       t_emailnav_results TYPE STANDARD TABLE OF s_emailnav_results WITH EMPTY KEY.
TYPES: BEGIN OF s_emailnav,
         results TYPE t_emailnav_results,
       END OF s_emailnav.
TYPES: BEGIN OF s_personnav,
         __metadata       TYPE s___metadata,
         personidexternal TYPE string,
         personalinfonav  TYPE s_personalinfonav,
         phonenav         TYPE s_phonenav,
         emailnav         TYPE s_emailnav,
       END OF s_personnav.
TYPES: BEGIN OF s_employmentnav,
         __metadata TYPE s___metadata,
         enddate    TYPE string,
         startdate  TYPE string,
         personnav  TYPE s_personnav,
       END OF s_employmentnav.

TYPES: BEGIN OF s_d_results,
         __metadata       TYPE s___metadata,
         userid           TYPE string,
         employeeclass    TYPE string,
         costcenter       TYPE string,
         division         TYPE string,
         location         TYPE string,
         department       TYPE string,
         customstring1nav TYPE s_customstring1nav,
         customstring2nav TYPE s_customstring2nav,
         employmentnav    TYPE s_employmentnav,
         worklocationnav  TYPE s_worklocationnav,
         positionnav      TYPE s_positionnav,
         customstring6nav TYPE s_customstring6nav,
         employeeclassnav TYPE s_employeeclassnav,
         companynav       TYPE s_companynav,
       END OF s_d_results,
       t_d_results TYPE STANDARD TABLE OF s_d_results WITH EMPTY KEY.
TYPES: BEGIN OF s_d,
         results TYPE t_d_results,
         __next  TYPE string,
       END OF s_d.
TYPES: BEGIN OF s_json,
         d TYPE s_d,
       END OF s_json.

TYPES: BEGIN OF ty_pkemployee,
         employeeid         TYPE char10,
         lastname           TYPE char40,
         firstname          TYPE char40,
         chinesename        TYPE char40,
         email              TYPE char40,
         department         TYPE char8,
         officelocation     TYPE char20,
         jobtitle           TYPE char8,
         intempodisplayname TYPE char20,
         hiredate           TYPE char23,
         leavedate          TYPE char23,
         updatedate         TYPE char23,
         updateby           TYPE char10,
         isready            TYPE i,
         isactivate         TYPE char6,
         joblevel           TYPE char10,
         costcenter         TYPE char20,
         displayname        TYPE char40,
         benefitid          TYPE char20,
         company_id         TYPE char30,
         nameinf            TYPE char20,
         mobileinf          TYPE char64,
         extensioninf       TYPE char64,
         extension          TYPE char64,
         mobiletele         TYPE char64,
         zx                 TYPE char100,
         fax                TYPE char100,
         deptermid          TYPE char8,
         updatetime         TYPE char23,
         bangongsec         TYPE char20,
         nature             TYPE char50,
         status             TYPE c LENGTH 112,
         alias              TYPE c LENGTH 80,
         jobname            TYPE char256,
         birthday           TYPE char23,
         esubtypecode       TYPE char10,
         basevalue          TYPE char10,
       END OF ty_pkemployee,
       ty_t_pkemployee TYPE STANDARD TABLE OF ty_pkemployee WITH EMPTY KEY.
TYPES: BEGIN OF ty_pkemployee_alv,
         userid TYPE string.
        INCLUDE TYPE ty_pkemployee.
TYPES: END OF ty_pkemployee_alv.

DATA: lo_con         TYPE REF TO cl_sql_connection,
      lv_sql         TYPE string,
      sql            TYPE REF TO cl_sql_statement,
      lv_url         TYPE string,
      lo_http_client TYPE REF TO if_http_client,
      lv_result      TYPE string,
      data_parsed    TYPE s_d,
      go_alv         TYPE REF TO cl_salv_table,
      gt_data_db     TYPE ty_t_pkemployee,
      gt_data_alv    TYPE TABLE OF ty_pkemployee_alv,
      gr_data        TYPE REF TO ty_t_pkemployee,
      lv_tstamp      TYPE timestamp,
      lv_epoch       TYPE string,
      lv_date        TYPE sydate,
      lv_time        TYPE syuzeit,
      lv_msec        TYPE num03,
      lv_str1        TYPE string,
      lv_str2        TYPE string,
      lv_num02       TYPE num02,
      lv_user        TYPE char10,
      lr_employeeid  TYPE REF TO char10,
      lr_ind_ref     TYPE REF TO int2.

SELECT-OPTIONS s_user FOR lv_user NO-DISPLAY.
PARAMETERS p_user TYPE char10.


START-OF-SELECTION.
*  MESSAGE '同步开始' TYPE 'I'.
  CREATE DATA lr_ind_ref.
  lr_ind_ref->* = -1.

  DO 30000 TIMES.
    WRITE: / '第' && sy-index && '批：'.
*** consume SF odata
    IF lv_url IS INITIAL.
      lv_url = |https://api15.sapsf.cn:443/odata/v2/EmpJob?$format=json| &&
               |&$select=userId,| &&
                        |employmentNav/personNav/personIdExternal,| &&
                        |employmentNav/personNav/personalInfoNav/lastName,| &&
                        |employmentNav/personNav/personalInfoNav/firstName,| &&
                        |employmentNav/personNav/emailNav/emailAddress,| &&
                        |employmentNav/personNav/emailNav/emailType,| &&
                        |division,| &&
                        |workLocationNav/picklistLabels/locale,| &&
                        |workLocationNav/picklistLabels/label,| &&
                        |customString2Nav/picklistLabels/locale,| &&
                        |customString2Nav/picklistLabels/label,| &&
                        |employmentNav/personNav/emailNav/customString1,| &&
                        |employmentNav/startDate,| &&
                        |employmentNav/endDate,| &&
                        |costCenter,| &&
                        |employmentNav/personNav/emailNav/customString2,| &&
                        |location,| &&
                        |companyNav/name_defaultValue,| &&
                        |employmentNav/personNav/phoneNav/phoneNumber,| &&
                        |employmentNav/personNav/phoneNav/extension,| &&
                        |employmentNav/personNav/phoneNav/phoneType,| &&
                        |department,| &&
                        |employeeClass,| &&
                        |employeeClassNav/picklistLabels/locale,| &&
                        |employeeClassNav/picklistLabels/label,| &&
                        |customString1Nav/externalCode,| &&
                        |positionNav/externalName_en_US,| &&
                        |employeeClassNav/externalCode,| &&
                        |customString6Nav/picklistLabels/locale,| &&
                        |customString6Nav/picklistLabels/label| &&
               |&$expand=employmentNav/personNav/personalInfoNav,| &&
                        |employmentNav/personNav/emailNav,| &&
                        |workLocationNav/picklistLabels,| &&
                        |customString2Nav/picklistLabels,| &&
                        |companyNav,| &&
                        |employmentNav/personNav/phoneNav,| &&
                        |employeeClassNav/picklistLabels,| &&
                        |customString1Nav,| &&
                        |positionNav,| &&
                        |customString6Nav/picklistLabels| &&
               |&$filter=not substringof('-',userId) and employeeClass ne '5161'&|.
      IF p_user IS INITIAL.
        lv_url = lv_url && |paging=snapshot&customPageSize=1000|.
      ELSE.
        CONDENSE p_user NO-GAPS.
        lv_url = lv_url && |$filter=userId eq { p_user }|.
      ENDIF.
    ENDIF.

    cl_http_client=>create_by_url(
         EXPORTING
           url                = lv_url
         IMPORTING
           client             = lo_http_client
         EXCEPTIONS
           argument_not_found = 1
           plugin_not_active  = 2
           internal_error     = 3
           OTHERS             = 4 ).

    lo_http_client->authenticate(
        EXPORTING
          username        = 'APIRCM@CICC'
          password        = 'CICC_1234567' ).

    lo_http_client->send(
         EXCEPTIONS
           http_communication_failure = 1
           http_invalid_state         = 2 ).

    lo_http_client->receive(
         EXCEPTIONS
           http_communication_failure = 1
           http_invalid_state         = 2
           http_processing_failed     = 3 ).

    CLEAR lv_result .
    lv_result = lo_http_client->response->get_cdata( ).

    lo_http_client->close( ).


*** parsing json
*  /ui2/cl_json=>deserialize(
*    EXPORTING
*      json = lv_result
*    CHANGING
*      data = data_parsed ).

*  DATA: lo_writer TYPE REF TO cl_sxml_string_writer,
*        lv_jsonx  TYPE xstring.
*
*  lo_writer = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
*  CALL TRANSFORMATION id SOURCE XML lv_result RESULT XML lo_writer.
*  lv_jsonx = lo_writer->get_output( ).


    REPLACE ALL OCCURRENCES OF '"uri"' IN lv_result WITH '"URI"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"type"' IN lv_result WITH '"TYPE"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"__metadata"' IN lv_result WITH '"__METADATA"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"locale"' IN lv_result WITH '"LOCALE"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"label"' IN lv_result WITH '"LABEL"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"results"' IN lv_result WITH '"RESULTS"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"picklistLabels"' IN lv_result WITH '"PICKLISTLABELS"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"externalName_en_us"' IN lv_result WITH '"EXTERNALNAME_EN_US"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"lastname"' IN lv_result WITH '"LASTNAME"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"firstname"' IN lv_result WITH '"FIRSTNAME"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"phonetype"' IN lv_result WITH '"PHONETYPE"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"extension"' IN lv_result WITH '"EXTENSION"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"phonenumber"' IN lv_result WITH '"PHONENUMBER"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"emailtype"' IN lv_result WITH '"EMAILTYPE"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"emailaddress"' IN lv_result WITH '"EMAILADDRESS"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"customstring1"' IN lv_result WITH '"CUSTOMSTRING1"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"customstring2"' IN lv_result WITH '"CUSTOMSTRING2"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"personidexternal"' IN lv_result WITH '"PERSONIDEXTERNAL"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"personalinfonav"' IN lv_result WITH '"PERSONALINFONAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"phonenav"' IN lv_result WITH '"PHONENAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"emailnav"' IN lv_result WITH '"EMAILNAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"endDate"' IN lv_result WITH '"ENDDATE"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"startDate"' IN lv_result WITH '"STARTDATE"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"personNav"' IN lv_result WITH '"PERSONNAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"userId"' IN lv_result WITH '"USERID"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"division"' IN lv_result WITH '"DIVISION"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"employeeClass"' IN lv_result WITH '"EMPLOYEECLASS"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"location"' IN lv_result WITH '"LOCATION"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"department"' IN lv_result WITH '"DEPARTMENT"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"customString1Nav"' IN lv_result WITH '"CUSTOMSTRING1NAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"positionNav"' IN lv_result WITH '"POSITIONNAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"customString2Nav"' IN lv_result WITH '"CUSTOMSTRING2NAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"customString6Nav"' IN lv_result WITH '"CUSTOMSTRING6NAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"costCenter"' IN lv_result WITH '"COSTCENTER"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"employeeClassNav"' IN lv_result WITH '"EMPLOYEECLASSNAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"employmentNav"' IN lv_result WITH '"EMPLOYMENTNAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"workLocationNav"' IN lv_result WITH '"WORKLOCATIONNAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"__next"' IN lv_result WITH '"__NEXT"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"d"' IN lv_result WITH '"D"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"externalCode"' IN lv_result WITH '"EXTERNALCODE"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"companyNav"' IN lv_result WITH '"COMPANYNAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"name_defaultValue"' IN lv_result WITH '"NAME_DEFAULTVALUE"' IGNORING CASE.

    REPLACE ALL OCCURRENCES OF ': NULL,' IN lv_result WITH ': "",' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF ': FALSE,' IN lv_result WITH ': "FALSE",' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF ': TRUE,' IN lv_result WITH ': "TRUE",' IGNORING CASE.

    CLEAR data_parsed.
    CALL TRANSFORMATION id SOURCE XML lv_result RESULT d = data_parsed.


    IF data_parsed-results IS INITIAL.
      WRITE: /10 'Odata解析失败'.
      EXIT.
    ELSE.
      WRITE: /10 'Odata解析成功'.
    ENDIF.

    CLEAR gt_data_db.
    LOOP AT data_parsed-results INTO DATA(ls_d_results).
      CHECK ls_d_results-employmentnav-personnav-personidexternal <> 'ADMIN'.

      APPEND INITIAL LINE TO gt_data_alv REFERENCE INTO DATA(lr_data_alv).
      lr_data_alv->userid = ls_d_results-userid.

      APPEND INITIAL LINE TO gt_data_db REFERENCE INTO DATA(lr_data).
      lr_data->department = ls_d_results-division.
      SPLIT ls_d_results-location AT '-' INTO lv_str1 lv_str2.
      lv_num02 = lv_str1.
      lr_data->benefitid = lv_num02.
      lr_data->deptermid = ls_d_results-department.

      lr_data->status = ls_d_results-customstring1nav-externalcode.

      lr_data->jobname = ls_d_results-positionnav-externalname_en_us.

      LOOP AT ls_d_results-customstring2nav-picklistlabels-results INTO DATA(ls_label_results) WHERE locale = 'en_US'.
*    IF lr_data->jobtitle IS NOT INITIAL.
*      ASSERT 1 = 2.
*    ENDIF.
        lr_data->jobtitle = ls_label_results-label.
      ENDLOOP.

      LOOP AT ls_d_results-customstring6nav-picklistlabels-results INTO ls_label_results WHERE locale = 'en_US'.
*    IF lr_data->basevalue IS NOT INITIAL.
*      ASSERT 1 = 2.
*    ENDIF.
        lr_data->basevalue = ls_label_results-label.
      ENDLOOP.

      lr_data->costcenter = ls_d_results-costcenter.

      LOOP AT ls_d_results-employeeclassnav-picklistlabels-results INTO ls_label_results WHERE locale = 'en_US'.
*    IF lr_data->nature IS NOT INITIAL.
*      ASSERT 1 = 2.
*    ENDIF.
        lr_data->nature = ls_label_results-label.
      ENDLOOP.
      lr_data->esubtypecode = ls_d_results-employeeclassnav-externalcode.

      lv_epoch = match( val = ls_d_results-employmentnav-startdate regex = '\d+' ).
      IF lv_epoch IS NOT INITIAL.
        cl_pco_utility=>convert_java_timestamp_to_abap(
          EXPORTING
            iv_timestamp = lv_epoch
          IMPORTING
            ev_date = lv_date
            ev_time = lv_time
            ev_msec = lv_msec ).
        CONVERT DATE lv_date TIME lv_time INTO TIME STAMP lv_tstamp TIME ZONE ''.
        lr_data->hiredate = |{ lv_tstamp TIMESTAMP = ISO }|.
      ENDIF.

      lv_epoch = match( val = ls_d_results-employmentnav-enddate regex = '\d+' ).
      IF lv_epoch IS NOT INITIAL.
        cl_pco_utility=>convert_java_timestamp_to_abap(
          EXPORTING
            iv_timestamp = lv_epoch
          IMPORTING
            ev_date = lv_date
            ev_time = lv_time
            ev_msec = lv_msec ).
        CONVERT DATE lv_date TIME lv_time INTO TIME STAMP lv_tstamp TIME ZONE ''.
        lr_data->leavedate = |{ lv_tstamp TIMESTAMP = ISO }|.
      ENDIF.

      lr_data->employeeid = ls_d_results-employmentnav-personnav-personidexternal.

      LOOP AT ls_d_results-employmentnav-personnav-personalinfonav-results INTO DATA(ls_personalinfonav_results).
*    IF lr_data->lastname IS NOT INITIAL.
*      ASSERT 1 = 2.
*    ENDIF.
        SPLIT ls_personalinfonav_results-lastname AT space INTO lr_data->lastname lr_data->firstname.
        lr_data->chinesename = ls_personalinfonav_results-firstname.
      ENDLOOP.

      LOOP AT ls_d_results-employmentnav-personnav-phonenav-results INTO DATA(ls_phonenav_results).
        IF ls_phonenav_results-phonetype = '3859'.
          lr_data->extension = ls_phonenav_results-extension.
        ENDIF.
        IF ls_phonenav_results-phonetype = '3860'.
          lr_data->mobiletele = ls_phonenav_results-phonenumber.
        ENDIF.
      ENDLOOP.

      LOOP AT ls_d_results-employmentnav-personnav-emailnav-results INTO DATA(ls_emailnav_results) WHERE emailtype = '3886'.
*    IF lr_data->email IS NOT INITIAL.
*      ASSERT 1 = 2.
*    ENDIF.
        lr_data->email = ls_emailnav_results-emailaddress.
        lr_data->intempodisplayname = ls_emailnav_results-customstring1.
        lr_data->displayname = ls_emailnav_results-customstring2.
      ENDLOOP.

      LOOP AT ls_d_results-worklocationnav-picklistlabels-results INTO ls_label_results WHERE locale = 'en_US'.
*    IF lr_data->officelocation IS NOT INITIAL.
*      ASSERT 1 = 2.
*    ENDIF.
        lr_data->officelocation = ls_label_results-label.
      ENDLOOP.

      lr_data->company_id = ls_d_results-companynav-name_defaultvalue.


      MOVE-CORRESPONDING lr_data->* TO lr_data_alv->*.
    ENDLOOP.



*** write into DB
    TRY.
        lo_con = cl_sql_connection=>get_connection( 'HRDB2' ).

        CREATE OBJECT sql
          EXPORTING
            con_ref = lo_con.

        IF sy-index = 1.
          IF p_user IS INITIAL.
            lv_sql = |TRUNCATE TABLE HRDB2.dbo.PKemployee|.
            sql->execute_ddl( lv_sql ).
            WRITE: /10 'TRUNCATE成功'.
          ELSE.
            IF lr_data_alv->userid <> p_user.
              EXIT.
            ENDIF.
            GET REFERENCE OF lr_data_alv->employeeid INTO lr_employeeid.
            lv_sql = |DELETE FROM HRDB2.dbo.PKemployee | &&
                     |WHERE EmployeeId = ?|.
            sql->set_param( lr_employeeid ).
            sql->execute_update( lv_sql ).
            WRITE: /10 '单条记录' && p_user && '已删除'.
          ENDIF.
        ENDIF.
      CATCH cx_sql_exception INTO DATA(lo_exc).
        WRITE: /10 'DB删除异常'.
    ENDTRY.

    LOOP AT gt_data_db INTO DATA(ls_data_db).
      lv_sql = |INSERT INTO HRDB2.dbo.PKemployee | &&
               |VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)|.
      TRY.
*        GET REFERENCE OF gt_data_db INTO gr_data.
*        sql->set_param_table( gr_data ).
          sql->set_param_struct( REF #( ls_data_db ) ).
          sql->execute_update( lv_sql ).
*        WRITE: / 20 ls_data_db-employeeid && ' 插入成功'.

          IF ls_data_db-leavedate IS INITIAL.
            lv_sql = |UPDATE HRDB2.dbo.PKemployee | &&
                     |SET LeaveDate = ? WHERE EmployeeId = ?|.
            sql->set_param( data_ref = REF #( ls_data_db-leavedate )
                            ind_ref = lr_ind_ref ).
            sql->set_param( data_ref = REF #( ls_data_db-employeeid ) ).
            sql->execute_update( lv_sql ).
          ENDIF.
          IF ls_data_db-updatedate IS INITIAL.
            lv_sql = |UPDATE HRDB2.dbo.PKemployee | &&
                     |SET updatedate = ? WHERE EmployeeId = ?|.
            sql->set_param( data_ref = REF #( ls_data_db-updatedate )
                            ind_ref = lr_ind_ref ).
            sql->set_param( data_ref = REF #( ls_data_db-employeeid ) ).
            sql->execute_update( lv_sql ).
          ENDIF.
          IF ls_data_db-updatetime IS INITIAL.
            lv_sql = |UPDATE HRDB2.dbo.PKemployee | &&
                     |SET updatetime = ? WHERE EmployeeId = ?|.
            sql->set_param( data_ref = REF #( ls_data_db-updatetime )
                            ind_ref = lr_ind_ref ).
            sql->set_param( data_ref = REF #( ls_data_db-employeeid ) ).
            sql->execute_update( lv_sql ).
          ENDIF.
          IF ls_data_db-birthday IS INITIAL.
            lv_sql = |UPDATE HRDB2.dbo.PKemployee | &&
                     |SET birthday = ? WHERE EmployeeId = ?|.
            sql->set_param( data_ref = REF #( ls_data_db-birthday )
                            ind_ref = lr_ind_ref ).
            sql->set_param( data_ref = REF #( ls_data_db-employeeid ) ).
            sql->execute_update( lv_sql ).
          ENDIF.

* Set officelocation is null when no officelocaion is maintained in SF
          IF ls_data_db-officelocation IS INITIAL.
            lv_sql = |UPDATE HRDB2.dbo.PKemployee | &&
                     |SET officelocation = ? WHERE EmployeeId = ?|.
            sql->set_param( data_ref = REF #( ls_data_db-officelocation )
                            ind_ref = lr_ind_ref ).
            sql->set_param( data_ref = REF #( ls_data_db-employeeid ) ).
            sql->execute_update( lv_sql ).
          ENDIF.

        CATCH cx_sql_exception INTO lo_exc.
          WRITE: /20 ls_data_db-employeeid && 'DB更新异常'.
      ENDTRY.
    ENDLOOP.

    TRY.
        lo_con->commit( ).
        lo_con->close( ).

      CATCH cx_sql_exception INTO lo_exc.
        WRITE: /10 'DB提交异常'.
    ENDTRY.


*** end check
    IF data_parsed-__next IS INITIAL.
      WRITE: /.
      WRITE: / '最后一批结束'.
      EXIT.
    ELSE.
      lv_url = data_parsed-__next.
    ENDIF.

  ENDDO.



*** alv
  CHECK sy-batch IS INITIAL.
  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = go_alv
        CHANGING
          t_table      = gt_data_alv ).
    CATCH cx_salv_msg.                                  "#EC NO_HANDLER
  ENDTRY.

  DATA(lo_functions) = go_alv->get_functions( ).
  lo_functions->set_all( 'X' ).

  DATA(lo_columns) = go_alv->get_columns( ).
  lo_columns->set_optimize( 'X' ).

  DATA(lo_column) = lo_columns->get_column( 'USERID' ).
  lo_column->set_long_text( 'userid' ).

  lo_column = lo_columns->get_column( 'EMPLOYEEID' ).
  lo_column->set_long_text( 'EmployeeId' ).
  lo_column = lo_columns->get_column( 'LASTNAME' ).
  lo_column->set_long_text( 'LastName' ).
  lo_column = lo_columns->get_column( 'FIRSTNAME' ).
  lo_column->set_long_text( 'FirstName' ).
  lo_column = lo_columns->get_column( 'CHINESENAME' ).
  lo_column->set_long_text( 'ChineseName' ).
  lo_column = lo_columns->get_column( 'EMAIL' ).
  lo_column->set_long_text( 'email' ).
  lo_column = lo_columns->get_column( 'DEPARTMENT' ).
  lo_column->set_long_text( 'Department' ).
  lo_column = lo_columns->get_column( 'OFFICELOCATION' ).
  lo_column->set_long_text( 'OfficeLocation' ).
  lo_column = lo_columns->get_column( 'JOBTITLE' ).
  lo_column->set_long_text( 'JobTitle' ).
  lo_column = lo_columns->get_column( 'INTEMPODISPLAYNAME' ).
  lo_column->set_long_text( 'InTempoDisplayName' ).
  lo_column = lo_columns->get_column( 'HIREDATE' ).
  lo_column->set_long_text( 'HireDate' ).
  lo_column = lo_columns->get_column( 'LEAVEDATE' ).
  lo_column->set_long_text( 'LeaveDate' ).

  lo_column = lo_columns->get_column( 'UPDATEDATE' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'UPDATEBY' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'ISREADY' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'ISACTIVATE' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'JOBLEVEL' ).
  lo_column->set_technical( 'X' ).

  lo_column = lo_columns->get_column( 'COSTCENTER' ).
  lo_column->set_long_text( 'costcenter' ).
  lo_column = lo_columns->get_column( 'DISPLAYNAME' ).
  lo_column->set_long_text( 'displayname' ).
  lo_column = lo_columns->get_column( 'BENEFITID' ).
  lo_column->set_long_text( 'benefitid' ).
  lo_column = lo_columns->get_column( 'COMPANY_ID' ).
  lo_column->set_long_text( 'company_id' ).

  lo_column = lo_columns->get_column( 'NAMEINF' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'MOBILEINF' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'EXTENSIONINF' ).
  lo_column->set_technical( 'X' ).

  lo_column = lo_columns->get_column( 'EXTENSION' ).
  lo_column->set_long_text( 'Extension' ).
  lo_column = lo_columns->get_column( 'MOBILETELE' ).
  lo_column->set_long_text( 'MobileTele' ).

  lo_column = lo_columns->get_column( 'ZX' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'FAX' ).
  lo_column->set_technical( 'X' ).

  lo_column = lo_columns->get_column( 'DEPTERMID' ).
  lo_column->set_long_text( 'deptermid' ).

  lo_column = lo_columns->get_column( 'UPDATETIME' ).
  lo_column->set_technical( 'X' ).

  lo_column = lo_columns->get_column( 'BANGONGSEC' ).
  lo_column->set_long_text( 'bangongSec' ).
  lo_column = lo_columns->get_column( 'NATURE' ).
  lo_column->set_long_text( 'Nature' ).
  lo_column = lo_columns->get_column( 'STATUS' ).
  lo_column->set_long_text( 'status' ).

  lo_column = lo_columns->get_column( 'ALIAS' ).
  lo_column->set_technical( 'X' ).

  lo_column = lo_columns->get_column( 'JOBNAME' ).
  lo_column->set_long_text( 'jobname' ).

  lo_column = lo_columns->get_column( 'BIRTHDAY' ).
  lo_column->set_technical( 'X' ).

  lo_column = lo_columns->get_column( 'ESUBTYPECODE' ).
  lo_column->set_long_text( 'esubTypeCode' ).
  lo_column = lo_columns->get_column( 'BASEVALUE' ).
  lo_column->set_long_text( 'basevalue' ).


  go_alv->display( ).

  EXIT.
