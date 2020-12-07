*&---------------------------------------------------------------------*
*& Report  ZP_SF_HRDB2_REPLI
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT zp_temployee_repli.

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
         firstname  TYPE string,
         lastname   TYPE string,
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
       END OF s_emailnav_results,
       t_emailnav_results TYPE STANDARD TABLE OF s_emailnav_results WITH EMPTY KEY.
TYPES: BEGIN OF s_emailnav,
         results TYPE t_emailnav_results,
       END OF s_emailnav.
TYPES: BEGIN OF s_usernav,
         __metadata TYPE s___metadata,
         city       TYPE string,
         status     TYPE string,
       END OF s_usernav.
TYPES: BEGIN OF s_personnav,
         __metadata       TYPE s___metadata,
         personidexternal TYPE string,
         personalinfonav  TYPE s_personalinfonav,
         phonenav         TYPE s_phonenav,
         emailnav         TYPE s_emailnav,
       END OF s_personnav.
TYPES: BEGIN OF s_employmentnav,
         __metadata     TYPE s___metadata,
         enddate        TYPE string,
         lastdateworked TYPE string,
         startdate      TYPE string,
         usernav        TYPE s_usernav,
         personnav      TYPE s_personnav,
       END OF s_employmentnav.

TYPES: BEGIN OF s_d_results,
         __metadata       TYPE s___metadata,
         userid           TYPE string,
         division         TYPE string,
         costcenter       TYPE string,
         company          TYPE string,
         location         TYPE string,
         department       TYPE string,
         customstring1nav TYPE s_customstring1nav,
         positionnav      TYPE s_positionnav,
         customstring2nav TYPE s_customstring2nav,
         customstring6nav TYPE s_customstring6nav,
         employmentnav    TYPE s_employmentnav,
         worklocationnav  TYPE s_worklocationnav,
       END OF s_d_results,
       t_d_results TYPE STANDARD TABLE OF s_d_results WITH EMPTY KEY.
TYPES: BEGIN OF s_d,
         results TYPE t_d_results,
         __next  TYPE string,
       END OF s_d.
TYPES: BEGIN OF s_json,
         d TYPE s_d,
       END OF s_json.

*TYPES: BEGIN OF ty_pkemployee_db,
*         Id                               TYPE char36,
*         EmployeeName_CN                  TYPE char100,
*         EmployeeName_EN                  TYPE char100,
*         Employee_Code                    TYPE char100,
*         LoginName                        TYPE char100,
*         mobilePhone                      TYPE char100,
*         Email                            TYPE char100,
*         IDNumber                         TYPE char50,
*         Gender                           TYPE char5,
*         Birthday                         TYPE char50,
*         EmployeeStatus_Start             TYPE char50,
*         Ext                              TYPE char100,
*         DisplayName                      TYPE char50,
*         GivenNameCHS                     TYPE char50,
*         HireDate                         TYPE char23,
*         HRLeaveDate                      TYPE char23,
*         ldapid                           TYPE char50,
*         MajorPosition                    TYPE char100,
*         LongDistance                     TYPE char100,
*         Secretary                        TYPE char100,
*         SecretaryMobilePhone             TYPE char100,
*         SecretaryTelephone               TYPE char100,
*         City                             TYPE char100,
*         Floors                           TYPE char100,
*         Buildings                        TYPE char100,
*         EmployeeStatus_* TYPE char100,
*         TeminalDate                      TYPE char23,
*         HiringLocation                   TYPE char100,
*         ExpenseLocation                  TYPE char100,
*         Department_Code                  TYPE char100,
*         Company_Code                     TYPE char100,
*         CostCenter                       TYPE char100,
*         Group_Code                       TYPE char100,
*         JobLevel_En                      TYPE char100,
*         WorkingLocation                  TYPE char100,
*         HireLocation                     TYPE char100,
*         Position                         TYPE char2000,
*         UpdateTime                       TYPE char23,
*         familyName                       TYPE char100,
*         GivenName                        TYPE char100,
*         dept_code                        TYPE char100,
*         status                           TYPE char112,
*         basevalue                        TYPE char10,
*       END OF ty_pkemployee_db,
TYPES: ty_temployee_db TYPE zstr_temployee,
       ty_t_temployee  TYPE STANDARD TABLE OF ty_temployee_db WITH EMPTY KEY.
TYPES: BEGIN OF ty_temployee_alv,
         userid TYPE string.
        INCLUDE TYPE ty_temployee_db.
TYPES: END OF ty_temployee_alv.

DATA: lo_con         TYPE REF TO cl_sql_connection,
      lv_sql         TYPE string,
      sql            TYPE REF TO cl_sql_statement,
      lv_url         TYPE string,
      lo_http_client TYPE REF TO if_http_client,
      lv_result      TYPE string,
      data_parsed    TYPE s_d,
      go_alv         TYPE REF TO cl_salv_table,
      gt_data_db     TYPE ty_t_temployee,
      gt_data_alv    TYPE TABLE OF ty_temployee_alv,
      gr_data        TYPE REF TO ty_t_temployee,
      lv_tstamp      TYPE timestamp,
      lv_epoch       TYPE string,
      lv_date        TYPE sydate,
      lv_time        TYPE syuzeit,
      lv_msec        TYPE num03,
      lv_user        TYPE char10,
      lr_user        TYPE REF TO char36,
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
                        |employmentNav/personNav/personalInfoNav/firstName,| &&
                        |employmentNav/personNav/personalInfoNav/lastName,| &&
                        |employmentNav/personNav/personIdExternal,| &&
                        |employmentNav/personNav/emailNav/customString1,| &&
                        |employmentNav/personNav/phoneNav/phoneNumber,| &&
                        |employmentNav/personNav/emailNav/emailType,| &&
                        |employmentNav/personNav/emailNav/emailAddress,| &&
                        |employmentNav/userNav/status,| &&
                        |employmentNav/personNav/phoneNav/extension,| &&
                        |employmentNav/personNav/phoneNav/phoneType,| &&
                        |employmentNav/startDate,| &&
                        |employmentNav/endDate,| &&
                        |employmentNav/userNav/city,| &&
                        |employmentNav/lastDateWorked,| &&
                        |division,| &&
                        |company,| &&
                        |costCenter,| &&
                        |department,| &&
                        |customString2Nav/picklistLabels/locale,| &&
                        |customString2Nav/picklistLabels/label,| &&
                        |workLocationNav/picklistLabels/locale,| &&
                        |workLocationNav/picklistLabels/label,| &&
                        |location,| &&
                        |positionNav/externalName_en_US,| &&
                        |customString1Nav/externalCode,| &&
                        |customString6Nav/picklistLabels/locale,| &&
                        |customString6Nav/picklistLabels/label| &&
               |&$expand=employmentNav/personNav/personalInfoNav,| &&
                        |employmentNav/personNav/emailNav,| &&
                        |employmentNav/personNav/phoneNav,| &&
                        |employmentNav/userNav,| &&
                        |customString2Nav/picklistLabels,| &&
                        |workLocationNav/picklistLabels,| &&
                        |positionNav,| &&
                        |customString1Nav,| &&
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
    REPLACE ALL OCCURRENCES OF '"userNav"' IN lv_result WITH '"USERNAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"status"' IN lv_result WITH '"STATUS"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"city"' IN lv_result WITH '"CITY"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"lastDateWorked"' IN lv_result WITH '"LASTDATEWORKED"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"customstring1"' IN lv_result WITH '"CUSTOMSTRING1"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"personidexternal"' IN lv_result WITH '"PERSONIDEXTERNAL"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"personalinfonav"' IN lv_result WITH '"PERSONALINFONAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"phonenav"' IN lv_result WITH '"PHONENAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"emailnav"' IN lv_result WITH '"EMAILNAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"endDate"' IN lv_result WITH '"ENDDATE"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"startDate"' IN lv_result WITH '"STARTDATE"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"personNav"' IN lv_result WITH '"PERSONNAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"userId"' IN lv_result WITH '"USERID"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"division"' IN lv_result WITH '"DIVISION"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"company"' IN lv_result WITH '"COMPANY"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"location"' IN lv_result WITH '"LOCATION"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"department"' IN lv_result WITH '"DEPARTMENT"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"customString1Nav"' IN lv_result WITH '"CUSTOMSTRING1NAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"positionNav"' IN lv_result WITH '"POSITIONNAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"customString2Nav"' IN lv_result WITH '"CUSTOMSTRING2NAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"customString6Nav"' IN lv_result WITH '"CUSTOMSTRING6NAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"costCenter"' IN lv_result WITH '"COSTCENTER"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"employmentNav"' IN lv_result WITH '"EMPLOYMENTNAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"workLocationNav"' IN lv_result WITH '"WORKLOCATIONNAV"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"__next"' IN lv_result WITH '"__NEXT"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"d"' IN lv_result WITH '"D"' IGNORING CASE.
    REPLACE ALL OCCURRENCES OF '"externalCode"' IN lv_result WITH '"EXTERNALCODE"' IGNORING CASE.

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
      lr_data->id = ls_d_results-userid.

      LOOP AT ls_d_results-employmentnav-personnav-personalinfonav-results INTO DATA(ls_personalinfonav_results).
*    IF lr_data->lastname IS NOT INITIAL.
*      ASSERT 1 = 2.
*    ENDIF.
        lr_data->employeename_cn = ls_personalinfonav_results-firstname.
        lr_data->employeename_en = ls_personalinfonav_results-lastname.
      ENDLOOP.

      lr_data->employee_code = ls_d_results-employmentnav-personnav-personidexternal.

      LOOP AT ls_d_results-employmentnav-personnav-emailnav-results INTO DATA(ls_emailnav_results) WHERE emailtype = '3886'.
*    IF lr_data->email IS NOT INITIAL.
*      ASSERT 1 = 2.
*    ENDIF.
        lr_data->loginname = ls_emailnav_results-customstring1.
        lr_data->email = ls_emailnav_results-emailaddress.
      ENDLOOP.

      LOOP AT ls_d_results-employmentnav-personnav-phonenav-results INTO DATA(ls_phonenav_results).
        IF ls_phonenav_results-phonetype = '3859'.
          lr_data->ext = ls_phonenav_results-extension.
        ENDIF.
        IF ls_phonenav_results-phonetype = '3860'.
          lr_data->mobilephone = ls_phonenav_results-phonenumber.
        ENDIF.
      ENDLOOP.

      lr_data->employeestatus_start = ls_d_results-employmentnav-usernav-status.
      lr_data->displayname = lr_data->employeename_en && lr_data->employeename_cn.

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
        lr_data->hrleavedate = |{ lv_tstamp TIMESTAMP = ISO }|.
      ENDIF.

      lv_epoch = match( val = ls_d_results-employmentnav-lastdateworked regex = '\d+' ).
      IF lv_epoch IS NOT INITIAL.
        cl_pco_utility=>convert_java_timestamp_to_abap(
          EXPORTING
            iv_timestamp = lv_epoch
          IMPORTING
            ev_date = lv_date
            ev_time = lv_time
            ev_msec = lv_msec ).
        CONVERT DATE lv_date TIME lv_time INTO TIME STAMP lv_tstamp TIME ZONE ''.
        lr_data->teminaldate = |{ lv_tstamp TIMESTAMP = ISO }|.
      ENDIF.

      lr_data->city = ls_d_results-employmentnav-usernav-city.
      lr_data->employeestatus_teminaloronthej = ls_d_results-employmentnav-usernav-status.
      lr_data->department_code = ls_d_results-division.
      lr_data->company_code = ls_d_results-company.
      lr_data->costcenter = ls_d_results-costcenter.
      lr_data->group_code = ls_d_results-department.

      LOOP AT ls_d_results-customstring2nav-picklistlabels-results INTO DATA(ls_label_results) WHERE locale = 'en_US'.
*    IF lr_data->jobtitle IS NOT INITIAL.
*      ASSERT 1 = 2.
*    ENDIF.
        lr_data->joblevel_en = ls_label_results-label.
      ENDLOOP.

      LOOP AT ls_d_results-worklocationnav-picklistlabels-results INTO ls_label_results WHERE locale = 'zh_CN'.
*    IF lr_data->officelocation IS NOT INITIAL.
*      ASSERT 1 = 2.
*    ENDIF.
        lr_data->workinglocation = ls_label_results-label.
      ENDLOOP.

      lr_data->hirelocation = ls_d_results-location.
      lr_data->position = ls_d_results-positionnav-externalname_en_us.
      SPLIT ls_personalinfonav_results-lastname AT space INTO lr_data->familyname lr_data->givenname.
      lr_data->dept_code = lr_data->department_code && '-' && lr_data->group_code.
      lr_data->status = ls_d_results-customstring1nav-externalcode.

      LOOP AT ls_d_results-customstring6nav-picklistlabels-results INTO ls_label_results WHERE locale = 'en_US'.
*    IF lr_data->basevalue IS NOT INITIAL.
*      ASSERT 1 = 2.
*    ENDIF.
        lr_data->basevalue = ls_label_results-label.
      ENDLOOP.

      MOVE-CORRESPONDING lr_data->* TO lr_data_alv->*.
    ENDLOOP.



*    IF p_user IS NOT INITIAL.
*** write into DB
    TRY.
        lo_con = cl_sql_connection=>get_connection( 'HRDB2' ).

        CREATE OBJECT sql
          EXPORTING
            con_ref = lo_con.

        IF sy-index = 1.
          IF p_user IS INITIAL.
            lv_sql = |TRUNCATE TABLE HRDB2.dbo.T_Employee|.
            sql->execute_ddl( lv_sql ).
            WRITE: /10 'TRUNCATE成功'.
          ELSE.
            IF lr_data_alv->userid <> p_user.
              EXIT.
            ENDIF.
            GET REFERENCE OF lr_data_alv->id INTO lr_user.
            lv_sql = |DELETE FROM HRDB2.dbo.T_Employee | &&
                     |WHERE Id = ?|.
            sql->set_param( lr_user ).
            sql->execute_update( lv_sql ).
            WRITE: /10 '单条记录' && p_user && '已删除'.
          ENDIF.
        ENDIF.
      CATCH cx_sql_exception INTO DATA(lo_exc).
        WRITE: /10 'DB删除异常' && lo_exc->sql_message.
    ENDTRY.

    LOOP AT gt_data_db INTO DATA(ls_data_db).
      lv_sql = |INSERT INTO HRDB2.dbo.T_Employee | &&
               |VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)|.
      TRY.
*        GET REFERENCE OF gt_data_db INTO gr_data.
*        sql->set_param_table( gr_data ).
          sql->set_param_struct( REF #( ls_data_db ) ).
          sql->execute_update( lv_sql ).
*        WRITE: / 20 ls_data_db-employeeid && ' 插入成功'.

          IF ls_data_db-hrleavedate IS INITIAL.
            lv_sql = |UPDATE HRDB2.dbo.T_Employee | &&
                     |SET HRLeaveDate = ? WHERE Id = ?|.
            sql->set_param( data_ref = REF #( ls_data_db-hrleavedate )
                            ind_ref = lr_ind_ref ).
            sql->set_param( data_ref = REF #( ls_data_db-id ) ).
            sql->execute_update( lv_sql ).
          ENDIF.
          IF ls_data_db-updatetime IS INITIAL.
            lv_sql = |UPDATE HRDB2.dbo.T_Employee | &&
                     |SET UpdateTime = ? WHERE Id = ?|.
            sql->set_param( data_ref = REF #( ls_data_db-updatetime )
                            ind_ref = lr_ind_ref ).
            sql->set_param( data_ref = REF #( ls_data_db-id ) ).
            sql->execute_update( lv_sql ).
          ENDIF.
          IF ls_data_db-teminaldate IS INITIAL.
            lv_sql = |UPDATE HRDB2.dbo.T_Employee | &&
                     |SET TeminalDate = ? WHERE Id = ?|.
            sql->set_param( data_ref = REF #( ls_data_db-teminaldate )
                            ind_ref = lr_ind_ref ).
            sql->set_param( data_ref = REF #( ls_data_db-id ) ).
            sql->execute_update( lv_sql ).
          ENDIF.
          IF ls_data_db-birthday IS INITIAL.
            lv_sql = |UPDATE HRDB2.dbo.T_Employee | &&
                     |SET Birthday = ? WHERE Id = ?|.
            sql->set_param( data_ref = REF #( ls_data_db-birthday )
                            ind_ref = lr_ind_ref ).
            sql->set_param( data_ref = REF #( ls_data_db-id ) ).
            sql->execute_update( lv_sql ).
          ENDIF.
          IF ls_data_db-city IS INITIAL.
            lv_sql = |UPDATE HRDB2.dbo.T_Employee | &&
                     |SET City = ? WHERE Id = ?|.
            sql->set_param( data_ref = REF #( ls_data_db-city )
                            ind_ref = lr_ind_ref ).
            sql->set_param( data_ref = REF #( ls_data_db-id ) ).
            sql->execute_update( lv_sql ).
          ENDIF.
          IF ls_data_db-workinglocation IS INITIAL.
            lv_sql = |UPDATE HRDB2.dbo.T_Employee | &&
                     |SET WorkingLocation = ? WHERE Id = ?|.
            sql->set_param( data_ref = REF #( ls_data_db-workinglocation )
                            ind_ref = lr_ind_ref ).
            sql->set_param( data_ref = REF #( ls_data_db-id ) ).
            sql->execute_update( lv_sql ).
          ENDIF.

        CATCH cx_sql_exception INTO lo_exc.
          WRITE: /20 ls_data_db-id && 'DB更新异常' && lo_exc->sql_message.
      ENDTRY.
    ENDLOOP.

    TRY.
        lo_con->commit( ).
        lo_con->close( ).

      CATCH cx_sql_exception INTO lo_exc.
        WRITE: /10 'DB提交异常' && lo_exc->sql_message.
    ENDTRY.
*    ENDIF.


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

  lo_column = lo_columns->get_column( 'ID' ).
  lo_column->set_long_text( 'Id' ).
  lo_column = lo_columns->get_column( 'EMPLOYEENAME_CN' ).
  lo_column->set_long_text( 'EmployeeName_CN' ).
  lo_column = lo_columns->get_column( 'EMPLOYEENAME_EN' ).
  lo_column->set_long_text( 'EmployeeName_EN' ).
  lo_column = lo_columns->get_column( 'EMPLOYEE_CODE' ).
  lo_column->set_long_text( 'Employee_Code' ).
  lo_column = lo_columns->get_column( 'LOGINNAME' ).
  lo_column->set_long_text( 'LoginName' ).
  lo_column = lo_columns->get_column( 'MOBILEPHONE' ).
  lo_column->set_long_text( 'mobilePhone' ).
  lo_column = lo_columns->get_column( 'EMAIL' ).
  lo_column->set_long_text( 'Email' ).
  lo_column = lo_columns->get_column( 'EMPLOYEESTATUS_START' ).
  lo_column->set_long_text( 'EmployeeStatus_Start' ).
  lo_column = lo_columns->get_column( 'EXT' ).
  lo_column->set_long_text( 'Ext' ).
  lo_column = lo_columns->get_column( 'DISPLAYNAME' ).
  lo_column->set_long_text( 'DisplayName' ).
  lo_column = lo_columns->get_column( 'HIREDATE' ).
  lo_column->set_long_text( 'HireDate' ).
  lo_column = lo_columns->get_column( 'HRLEAVEDATE' ).
  lo_column->set_long_text( 'HRLeaveDate' ).
  lo_column = lo_columns->get_column( 'CITY' ).
  lo_column->set_long_text( 'City' ).
*  lo_column = lo_columns->get_column( 'EMPLOYEESTATUS_TEMINALORONTHEJOB' ).
*  lo_column->set_long_text( 'EmployeeStatus_TeminalOrOnthejob' ).
  lo_column = lo_columns->get_column( 'TEMINALDATE' ).
  lo_column->set_long_text( 'TeminalDate' ).
  lo_column = lo_columns->get_column( 'DEPARTMENT_CODE' ).
  lo_column->set_long_text( 'Department_Code' ).
  lo_column = lo_columns->get_column( 'COMPANY_CODE' ).
  lo_column->set_long_text( 'Company_Code' ).
  lo_column = lo_columns->get_column( 'COSTCENTER' ).
  lo_column->set_long_text( 'CostCenter' ).
  lo_column = lo_columns->get_column( 'GROUP_CODE' ).
  lo_column->set_long_text( 'Group_Code' ).
  lo_column = lo_columns->get_column( 'JOBLEVEL_EN' ).
  lo_column->set_long_text( 'JobLevel_En' ).
  lo_column = lo_columns->get_column( 'WORKINGLOCATION' ).
  lo_column->set_long_text( 'WorkingLocation' ).
  lo_column = lo_columns->get_column( 'HIRELOCATION' ).
  lo_column->set_long_text( 'HireLocation' ).
  lo_column = lo_columns->get_column( 'POSITION' ).
  lo_column->set_long_text( 'Position' ).
  lo_column = lo_columns->get_column( 'FAMILYNAME' ).
  lo_column->set_long_text( 'familyName' ).
  lo_column = lo_columns->get_column( 'GIVENNAME' ).
  lo_column->set_long_text( 'GivenName' ).
  lo_column = lo_columns->get_column( 'DEPT_CODE' ).
  lo_column->set_long_text( 'dept_code' ).
  lo_column = lo_columns->get_column( 'STATUS' ).
  lo_column->set_long_text( 'status' ).
  lo_column = lo_columns->get_column( 'BASEVALUE' ).
  lo_column->set_long_text( 'basevalue' ).

  lo_column = lo_columns->get_column( 'UPDATETIME' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'IDNUMBER' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'GENDER' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'BIRTHDAY' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'GIVENNAMECHS' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'LDAPID' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'MAJORPOSITION' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'LONGDISTANCE' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'SECRETARY' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'SECRETARYMOBILEPHONE' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'SECRETARYTELEPHONE' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'FLOORS' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'BUILDINGS' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'HIRINGLOCATION' ).
  lo_column->set_technical( 'X' ).
  lo_column = lo_columns->get_column( 'EXPENSELOCATION' ).
  lo_column->set_technical( 'X' ).

  go_alv->display( ).

  EXIT.
