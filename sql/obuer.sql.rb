# -*- coding: UTF-8 -*-

=begin

---------------------------------------------------
-- Export file for user OBUER                    --
-- Created by huangyuesong on 2011-7-28, 2:11:33 --
---------------------------------------------------

spool obuer.log

prompt
prompt Creating table OAUXRULES
prompt ========================
prompt
create table OAUXRULES
(
  aux_id     INTEGER not null,
  aux_name   VARCHAR2(16) not null,
  aux_mark   VARCHAR2(100),
  aux_status VARCHAR2(2) default 'Y' not null
)
;
comment on table OAUXRULES
  is '语间规则表';
comment on column OAUXRULES.aux_id
  is '语音规则ID_主键';
comment on column OAUXRULES.aux_name
  is '语音规则名称';
comment on column OAUXRULES.aux_mark
  is '语音规则备注';
comment on column OAUXRULES.aux_status
  is '语音规则状态_{Y:可用, N:停用}';
alter table OAUXRULES
  add constraint PK_OAUXRULES primary key (AUX_ID);

prompt
prompt Creating table OAUXDETAILS
prompt ==========================
prompt
create table OAUXDETAILS
(
  aux_id                 INTEGER not null,
  detail_id              INTEGER not null,
  detail_status          VARCHAR2(2) default 'Y' not null,
  detail_order           INTEGER not null,
  inbound_front          VARCHAR2(30),
  inbound_front_extname  VARCHAR2(5),
  inbound_back           VARCHAR2(30),
  inbound_back_extname   VARCHAR2(5),
  outbound_front         VARCHAR2(30),
  outbound_front_extname VARCHAR2(5),
  outbound_back          VARCHAR2(30),
  outbound_back_extname  VARCHAR2(5),
  bustop_suffix          VARCHAR2(4),
  detail_mark            VARCHAR2(200)
)
;
comment on column OAUXDETAILS.aux_id
  is '语音规则ID';
comment on column OAUXDETAILS.detail_id
  is '语音规则明细ID';
comment on column OAUXDETAILS.detail_status
  is '语音规则明细状态_{Y:可用, N:停用}';
comment on column OAUXDETAILS.detail_order
  is '语音明细处理顺序';
comment on column OAUXDETAILS.inbound_front
  is '入站前缀文件名';
comment on column OAUXDETAILS.inbound_front_extname
  is '入站前缀扩展名';
comment on column OAUXDETAILS.inbound_back
  is '入站后缀文件名';
comment on column OAUXDETAILS.inbound_back_extname
  is '入站后缀扩展名
';
comment on column OAUXDETAILS.outbound_front
  is '出站前缀文件名';
comment on column OAUXDETAILS.outbound_front_extname
  is '出站前缀扩展名';
comment on column OAUXDETAILS.outbound_back
  is '出站后缀文件名';
comment on column OAUXDETAILS.outbound_back_extname
  is '出站后缀扩展名';
comment on column OAUXDETAILS.bustop_suffix
  is '站点附加标识';
comment on column OAUXDETAILS.detail_mark
  is '明细备注';
alter table OAUXDETAILS
  add constraint PK_OAUXDETAILS primary key (AUX_ID, DETAIL_ID);
alter table OAUXDETAILS
  add constraint FK_OAUXDETAILS_OAUXRULES foreign key (AUX_ID)
  references OAUXRULES (AUX_ID);

prompt
prompt Creating table OTASKS
prompt =====================
prompt
create table OTASKS
(
  task_id           INTEGER not null,
  task_name         VARCHAR2(20) not null,
  task_status       VARCHAR2(2) default 'Y' not null,
  aux_id            INTEGER not null,
  task_create_time  DATE default SYSDATE,
  task_execute_time DATE,
  task_mark         VARCHAR2(200)
)
;
comment on column OTASKS.task_id
  is '任务ID_主键';
comment on column OTASKS.task_name
  is '任务名称';
comment on column OTASKS.task_status
  is '任务状态_{Y:可用, N:停用}';
comment on column OTASKS.aux_id
  is '语音规则ID_外键';
comment on column OTASKS.task_create_time
  is '任务建立时间';
comment on column OTASKS.task_execute_time
  is '任务最后运行时间';
comment on column OTASKS.task_mark
  is '任务备注';
alter table OTASKS
  add constraint PK_OTASKS primary key (TASK_ID);
alter table OTASKS
  add constraint FK_OTASKS_OAUXRULES foreign key (AUX_ID)
  references OAUXRULES (AUX_ID);

prompt
prompt Creating table OTASKROUTES
prompt ==========================
prompt
create table OTASKROUTES
(
  task_id       INTEGER not null,
  route_code    VARCHAR2(5) not null,
  route_extname VARCHAR2(5)
)
;
comment on column OTASKROUTES.task_id
  is '任务ID';
comment on column OTASKROUTES.route_code
  is '线路代码';
comment on column OTASKROUTES.route_extname
  is '线线语音扩展名';
alter table OTASKROUTES
  add constraint PK_OTASKROUTES primary key (TASK_ID, ROUTE_CODE);
alter table OTASKROUTES
  add constraint FK_OTASKROUTES_OAUXRULES foreign key (TASK_ID)
  references OTASKS (TASK_ID);

prompt
prompt Creating table TT_TIMETABLE
prompt ===========================
prompt
create table TT_TIMETABLE
(
  routecode VARCHAR2(5),
  rowno     INTEGER,
  c01       VARCHAR2(1000),
  c02       VARCHAR2(100),
  c03       VARCHAR2(100),
  c04       VARCHAR2(100),
  c05       VARCHAR2(100),
  c06       VARCHAR2(100),
  c07       VARCHAR2(100),
  c08       VARCHAR2(100),
  c09       VARCHAR2(100),
  c10       VARCHAR2(100),
  c11       VARCHAR2(100),
  c12       VARCHAR2(100),
  c13       VARCHAR2(100),
  c14       VARCHAR2(100),
  c15       VARCHAR2(100),
  c16       VARCHAR2(100),
  c17       VARCHAR2(100),
  c18       VARCHAR2(100),
  c19       VARCHAR2(100),
  c20       VARCHAR2(100),
  c21       VARCHAR2(100),
  c22       VARCHAR2(100),
  c23       VARCHAR2(100),
  c24       VARCHAR2(300),
  c25       VARCHAR2(300),
  c26       VARCHAR2(100),
  c27       VARCHAR2(100)
)
;

prompt
prompt Creating sequence SEQ_TASK_ID
prompt =============================
prompt
create sequence SEQ_TASK_ID
minvalue 1
maxvalue 99999
start with 15
increment by 1
nocache;

prompt
prompt Creating view MV_OROUTEDETAIL
prompt =============================
prompt
CREATE OR REPLACE VIEW MV_OROUTEDETAIL AS
select s.routecode,
       busstopname,
       case
           when routecode != next_routecode or tripnumber != next_tripnumber then
            ''
           else
            next_busstopname
       end next_busstopname,
       s.tripnumber,
       s.orderonroute,
       s.busstop_auto_audio
  from (SELECT t.routecode routecode,
               t.tripnumber,
               t.busstopname,
               t.busstop_auto_audio,
               lead(t.busstopname, 1) over(ORDER BY t.routecode, t.tripnumber, t.orderonroute) next_busstopname,
               lead(t.tripnumber, 1) over(ORDER BY t.routecode, t.tripnumber, t.orderonroute) next_tripnumber,
               lead(t.routecode, 1) over(ORDER BY t.routecode, t.tripnumber, t.orderonroute) next_routecode,
               t.orderonroute
          FROM (SELECT *
                  FROM (SELECT t.routecode,
                               t.c12 tripnumber,
                               t.c09 busstopname,
                               to_number(t.c07) orderonroute,
                               substr(t.c22, instr(t.c22, '=') + 1) busstop_auto_audio -- 进站语音
                          FROM tt_timetable t
                         WHERE t.c27 = upper('SERVICES'))) t) s;

prompt
prompt Creating view MV_OTASKDETAIL
prompt ============================
prompt
CREATE OR REPLACE VIEW MV_OTASKDETAIL AS
SELECT s.task_id,
       s.task_name,
       t.route_code,
       t.route_extname,
       u.aux_id,
       v.bustop_suffix,
       v.detail_order,
       u.aux_mark,
       CASE
           WHEN v.inbound_front IS NOT NULL THEN
            v.inbound_front || v.inbound_front_extname
           ELSE
            ''
       END inbound_front_fullname,
       CASE
           WHEN v.inbound_back IS NOT NULL THEN
            v.inbound_back || v.inbound_back_extname
           ELSE
            ''
       END inbound_back_fullname,
       CASE
           WHEN v.outbound_front IS NOT NULL THEN
            v.outbound_front || v.outbound_front_extname
           ELSE
            ''
       END outbound_front_fullname,
       CASE
           WHEN v.outbound_back IS NOT NULL THEN
            v.outbound_back || v.outbound_back_extname
           ELSE
            ''
       END outbound_back_fullname

  FROM otasks s, otaskroutes t, oauxrules u, oauxdetails v
 WHERE s.task_id = t.task_id
   AND s.aux_id = u.aux_id
   and u.aux_id = v.aux_id
   and s.task_status = 'Y'
   and u.aux_status = 'Y'
   and v.detail_status = 'Y'
 ORDER BY s.task_id, t.route_code, v.detail_order;

prompt
prompt Creating view MV_OBUSSTOP_AUXDETAIL
prompt ===================================
prompt
CREATE OR REPLACE VIEW MV_OBUSSTOP_AUXDETAIL AS
select task_id,
       aux_id,
       detail_order auxdetail_order,
       busstop_inbound_title,
       busstop_outbound_title,
       inbound,
       case
           when next_busstopname is null then
            ''
           else
            outbound
       end outbound, -- 根据实际操作需要，总站出站不报站，始终为空。
       busstopname,
       next_busstopname,
       routecode,
       tripnumber,
       orderonroute,
       busstop_auto_audio,
       row_number() over(PARTITION BY task_id, routecode, tripnumber, orderonroute ORDER BY detail_order) rn,
       COUNT(*) over(PARTITION BY task_id, routecode, tripnumber, orderonroute) cnt
  from (

        SELECT t.task_id,
                t.aux_id,
                t.detail_order,
                t.route_code || u.tripnumber || u.busstopname || '进站=' busstop_inbound_title,
                t.route_code || u.tripnumber || u.busstopname || '出站=' busstop_outbound_title,
                t.inbound_front_fullname || '+' || u.busstopname || t.bustop_suffix || t.route_extname || '+' ||
                t.inbound_back_fullname inbound,
                t.outbound_front_fullname || '+' || u.next_busstopname || t.bustop_suffix || t.route_extname || '+' ||
                t.outbound_back_fullname outbound,
                u.busstopname,
                u.next_busstopname,
                u.routecode,
                u.tripnumber,
                u.orderonroute,
                u.busstop_auto_audio
          FROM mv_otaskdetail t, mv_oroutedetail u
         WHERE t.route_code = u.routecode);

prompt
prompt Creating type BUSSTOP_MERGEAUDIO_LINE
prompt =====================================
prompt
CREATE OR REPLACE TYPE busstop_mergeaudio_line  AS OBJECT
(
    routecode    varchar2(10),
    tripnumber   varchar2(10),
    orderonroute number,
    inbound      varchar2(1000),
    outbound     varchar2(1000)
)
/

prompt
prompt Creating type BUSSTOP_MERGEAUDIO_ARRAY
prompt ======================================
prompt
CREATE OR REPLACE TYPE busstop_mergeaudio_array AS table of busstop_mergeaudio_line
/

prompt
prompt Creating type BUSSTOP_MULTIAUDIO_LINE
prompt =====================================
prompt
CREATE OR REPLACE TYPE busstop_multiaudio_line AS OBJECT
(
    task_id                integer,
    aux_id                 integer,
    auxdetail_order        integer,
    busstop_inbound_title  varchar2(500),
    busstop_outbound_title varchar2(500),
    inbound                varchar2(2000),
    outbound               varchar2(2000),
    routecode              varchar2(10),
    tripnumber             varchar2(10),
    orderonroute           number,
    busstop_auto_audio     varchar2(50),
    rn                     integer,
    cnt                    integer
)
/

prompt
prompt Creating type BUSSTOP_MULTIAUDIO_ARRAY
prompt ======================================
prompt
CREATE OR REPLACE TYPE busstop_multiaudio_array AS table of busstop_multiaudio_line
/

prompt
prompt Creating type MERGELINE
prompt =======================
prompt
CREATE OR REPLACE TYPE mergeline AS OBJECT
(
    merge_content          clob
)
/

prompt
prompt Creating type MERGEINFO
prompt =======================
prompt
CREATE OR REPLACE TYPE Mergeinfo AS table of mergeline
/

prompt
prompt Creating package OBU_MAINT
prompt ==========================
prompt
CREATE OR REPLACE PACKAGE obu_maint IS
    -- 站点多种语音组合明细列表
    FUNCTION mk_busstop_multiaudio_detail(i_taskid otasks.task_id%TYPE) RETURN busstop_multiaudio_array;
    -- 站点多种语音明细组合
    FUNCTION merge_busstop_audio(i_taskid otasks.task_id%TYPE) RETURN busstop_mergeaudio_array;
    -- 任务包含站点语音合并为CLOB字段，方便外部调用。
    FUNCTION merge_task_audio(i_taskid otasks.task_id%TYPE) RETURN mergeinfo;
END;
/

prompt
prompt Creating package body OBU_MAINT
prompt ===============================
prompt
create or replace package body obu_maint is
    c_linesep            varchar(1); -- 行结束符
    c_startingplace_flag integer; -- 起始站点标识

    /*
    || 包初始化
    */
    procedure initialize is
    begin
        c_linesep            := chr(10);
        c_startingplace_flag := 1;
    end initialize;

    /*
    || 单一站点单一语音形成一行的明细列表
    */
    function mk_busstop_multiaudio_detail(i_taskid otasks.task_id%type) return busstop_multiaudio_array is
        -- 单一站点单一语音形成的一行
        l_line busstop_multiaudio_line := busstop_multiaudio_line(null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  null);
        -- 单一站点单一语音形成的表
        l_ret_ot busstop_multiaudio_array := busstop_multiaudio_array();
    begin
        for r in (select task_id,
                         aux_id,
                         auxdetail_order,
                         busstop_inbound_title,
                         busstop_outbound_title,
                         inbound,
                         outbound,
                         routecode,
                         tripnumber,
                         orderonroute,
                         busstop_auto_audio,
                         rn,
                         cnt
                    from mv_obusstop_auxdetail
                   where task_id = i_taskid) loop
            l_ret_ot.extend;

            l_line.task_id                := i_taskid;
            l_line.aux_id                 := r.aux_id;
            l_line.auxdetail_order        := r.auxdetail_order;
            l_line.busstop_inbound_title  := r.busstop_inbound_title;
            l_line.busstop_outbound_title := r.busstop_outbound_title;
            l_line.inbound                := r.inbound;
            l_line.outbound               := r.outbound;
            l_line.routecode              := r.routecode;
            l_line.tripnumber             := r.tripnumber;
            l_line.orderonroute           := r.orderonroute;
            l_line.busstop_auto_audio     := r.busstop_auto_audio;
            l_line.rn                     := r.rn;
            l_line.cnt                    := r.cnt;

            l_ret_ot(l_ret_ot.count) := l_line;
        end loop;
        return l_ret_ot;
    end;

    /*
    || 单一站点多种语音合并形成一行
    */
    function merge_busstop_audio(i_taskid otasks.task_id%type) return busstop_mergeaudio_array is
        -- 单一站点多种语音合并形成一行
        l_line   busstop_mergeaudio_line := busstop_mergeaudio_line(null, null, null, null, null);
        l_ret_ot busstop_mergeaudio_array := busstop_mergeaudio_array();

        cursor multiaudio_cur is
            select routecode,
                   tripnumber,
                   orderonroute, -- 为入出站特殊处理在游标中保留此列
                   busstop_auto_audio, -- 为入出站特殊处理在游标中保留此列
                   busstop_inbound_title, -- 为入出站特殊处理在游标中保留此列
                   busstop_outbound_title, -- 为入出站特殊处理在游标中保留此列
                   busstop_inbound_title ||
                   rtrim(ltrim(replace(sys_connect_by_path(rtrim(ltrim(inbound, '+'), '+'), '->'), '->', '+'), '+'),
                         '+') inbound,
                   busstop_outbound_title ||
                   rtrim(ltrim(replace(sys_connect_by_path(rtrim(ltrim(outbound, '+'), '+'), '->'), '->', '+'), '+'),
                         '+') outbound
              from table(mk_busstop_multiaudio_detail(i_taskid))
             where level = cnt
             start with rn = 1
            connect by prior routecode = routecode
                   and prior tripnumber = tripnumber
                   and prior orderonroute = orderonroute
                   and prior rn = rn - 1
             order by routecode, tripnumber, orderonroute, rn;
    begin
        for r in multiaudio_cur loop
            l_ret_ot.extend;

            l_line.routecode    := r.routecode;
            l_line.tripnumber   := r.tripnumber;
            l_line.orderonroute := r.orderonroute;

            if r.orderonroute = c_startingplace_flag then
                -- 入总站直接转变为自动生成的语音文件
                l_line.inbound := r.busstop_inbound_title || r.busstop_auto_audio;
            else
                l_line.inbound := r.inbound;
            end if;
            l_line.outbound := r.outbound;
            l_ret_ot(l_ret_ot.count) := l_line;
        end loop;
        return l_ret_ot;
    end;

    /*
    || 任务包含站点语音合并为clob字段，方便外部调用。
    */
    function merge_task_audio(i_taskid otasks.task_id%type) return mergeinfo is
        l_content   mergeline := mergeline(null);
        l_mergeinfo mergeinfo := mergeinfo();

    begin
        for r in (select inbound content
                    from table(merge_busstop_audio(i_taskid))
                  union all
                  select outbound content from table(merge_busstop_audio(i_taskid))) loop
            l_content.merge_content := l_content.merge_content || r.content || c_linesep;
        end loop;
        l_mergeinfo.extend;
        l_mergeinfo(l_mergeinfo.count) := l_content;

        return l_mergeinfo;
    end;

begin
    initialize;
end;
/


spool off


=end