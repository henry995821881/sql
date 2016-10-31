

TO_TIMESTAMP('''||P_TERMINAL||''',''RR-MM-DD HH24:MI:SSXFF''),


 VAR_YEARMONTH  := TO_DATE(P_YEARMONTH, 'YYYYMMDD');


 AND TO_CHAR(DT.FSTOUTPUT_DATE, ''YYYY/MM/DD'') <= '''||P_OUPUT_END_DATE||'''';

-------------------------------------------------------------------------

select nvl(tb.nm,nvl(a.val,''))
from
(
select seq,val,xml_cd from (
 select t.seq,m1.xml_cd ,kn2.val ,rank()over(partition by m1.xml_group_cd order by m1.jun_no) row_
 from m_xml m1
 inner join (
  select c.seq,m.xml_group_cd
  from ctm_code_tbl c
   inner join m_xml m
     on m.xml_cd = c.cd
     and  m.xml_group_cd is not null    
   where c.kbn =/*data.kbn*/ )t
   on m1.xml_group_cd = t.xml_group_cd
   left join kensa k1
     on k1.jlac10_cd = m1.xml_cd
   left join knsn2 kn2
      on kn2.koumoku_cd = k1.cd
      and kn2.seq_no =/*data.knsnSeq*/
      and kn2.val is not null) t1
      where t1.row_ = 1
 
UNION all
 
select c.seq,kn2.val,m.xml_cd
from ctm_code_tbl c
  inner join m_xml m
    on m.xml_cd = c.cd
    and m.xml_group_cd is null
  left join kensa k1
     on k1.jlac10_cd = m.xml_cd
  left join knsn2 kn2
     on kn2.koumoku_cd = k1.cd
     and kn2.seq_no =/*data.knsnSeq*/
where c.kbn=/*data.kbn*/
)a
left join m_xml xm
  on xm.xml_cd =  a.xml_cd
left join oidkekka_tbl tb
  on xm.kekka_oid = tb.kekka_oid
  and tb.a_cd =a.val  
 order by a.seq 
  
------------------------------------------------------------------

select nvl(a.val,''),a.seq
  from(
  select kn2.val,t.seq ,kn2.seq_no, rank()over(partition by m1.xml_group_cd order by m1.jun_no) row_
  from m_xml m1
  inner join
  (
  select m.xml_group_cd ,c.seq
  from ctm_code_tbl c
  left join m_xml m
   on m.xml_cd = c.cd
   and m.xml_group_cd is not null
   where c.kbn='D17' 
   and to_char(c.seq) in('1','2','3')--='1'
  )t
  on m1.xml_group_cd = t.xml_group_cd
  left join kensa k1
     on k1.jlac10_cd = m1.xml_cd
  left join knsn2 kn2
     on kn2.koumoku_cd = k1.cd
    and kn2.val is not null
    and to_char(kn2.seq_no) = '861'
    )a
    where a.row_ =1
order by a.seq 
  
--------------------------------------------------------------------------------  

 @SqlFile
 List<JigyousyoData> getJigyousyoByKigou(String[] kigous);

select j.kigou,
j.jigyousyo_nm 
from jigyousyo j
where j.kigou in /*kigous*/('selectGroup')
order by j.kigou

-----------------------------------------------------------------------
	function trim(str) {
		return str.replace(/(^\s*)|(\s*$)/g, "");
	}



---------------------------------------------------------------
select
dhp.kanyu_no,
dhp.fuyou_no,
ko.kigou,
ko.bangou,
z.nm as zokugara_nm,
koj.nm kojin_nm,
m.org as sex,
FN_NENREI(koj.tanjoubi,sysdate) as age,
ctm.org,
c.note 
from dai_dhp_taisyosya dhp
 inner join kojinrireki ko
    on dhp.kanyu_no = ko.kanyu_no
    and dhp.fuyou_no = ko.fuyou_no
 inner join kojin koj
   on ko.kanyu_no= koj.kanyu_no
   and ko.fuyou_no = koj.fuyou_no
   and ko.syutoku_no = (select max(ko1.syutoku_no)  from kojinrireki ko1 where ko.kanyu_no = ko1.kanyu_no and ko.fuyou_no = ko1.fuyou_no)
 left join zokugara z
   on ko.zokugara_cd = z.cd
 left join m_code_tbl m
   on m.kbn ='119'
   and m.cd = koj.seibetu  
 left join ctm_code_tbl ctm
  on dhp.hantei_moto = ctm.cd
  and ctm.kbn ='D18' 
 left join ctm_code_tbl c
   on dhp.genkou_dhp_kbn = c.cd
   and c.kbn ='D12'    
 /*BEGIN*/
 where
      /*IF data.dhpArrayCd != null*/
       dhp.genkou_dhp_kbn in /*data.dhpArrayCd*/('selectGroup')
     /*END*/
   
      /*IF data.sosituFlag ==true */
        and (
            ((SELECT DISTINCT FIRST_VALUE(SOUSITUBI) OVER(PARTITION BY KANYU_NO,FUYOU_NO ORDER BY SYUTOKU_NO DESC)
               FROM KOJINRIREKI
              WHERE KANYU_NO = dhp.KANYU_NO
                AND FUYOU_NO = dhp.FUYOU_NO) IS NULL
            )
            OR
            ((SELECT DISTINCT FIRST_VALUE(SOUSITUBI) OVER(PARTITION BY KANYU_NO,FUYOU_NO ORDER BY SYUTOKU_NO DESC)
               FROM KOJINRIREKI
              WHERE KANYU_NO = dhp.KANYU_NO
                AND FUYOU_NO = dhp.FUYOU_NO) > SYSDATE
             AND
             (SELECT DISTINCT FIRST_VALUE(SYUTOKUBI) OVER(PARTITION BY KANYU_NO,FUYOU_NO ORDER BY SYUTOKU_NO DESC)
               FROM KOJINRIREKI
              WHERE KANYU_NO = dhp.KANYU_NO
                AND FUYOU_NO = dhp.FUYOU_NO) <= SYSDATE
            )       
         ) 
    /*END*/
  
    /*IF data.zokugaraKbn == "1" */
    and ko.fuyou_no ='0'
    /*END*/
    
    /*IF data.zokugaraKbn == "2" */
    and ko.fuyou_no <>'0'
    /*END*/
    
    /*IF data.ageFrom !=null and data.ageFrom !="" */
      and FN_NENREI(koj.tanjoubi,sysdate) >=  /*data.ageFrom*/
    /*END*/
  
    /*IF data.ageTo !=null and data.ageTo !="" */
    and FN_NENREI(koj.tanjoubi,sysdate) <= /*data.ageTo*/ 
    /*END*/   
     
   /*IF data.sex !=null and data.sex != "" */
     and koj.seibetu =/*data.sex*/
    /*END*/
   
    /*IF data.reseCheckBox == true*/
    
        /*IF data.hanni == "1" */
        
             /*IF data.kigouArray != null*/
             and ko.kigou in  /*data.kigouArray*/('selectGroup')
            /*END*/
            
         /*END*/
     
    /*IF data.hanni == "2" */
       /*IF data.personFlg == "1" */
         and ko.kanyu_no = /*data.kanyuNo*/
         and ko.fuyou_no = /*data.fuyouNo*/
       /*END*/
        /*IF data.personFlg == "0" */  
        and ko.kigou = /*data.kigou*/
        and ko.bangou =/*data.bangou*/
        /*END*/
   /*END*/ 
 /*END*/  
/*END*/
    order by ko.kigou,ko.bangou,z.cd
---------------------------------------------------------------
select 
KO.Kigou as kigou,
ko.bangou as bangou,
ju.yubin_no as yubinNo ,
ju.address as address,
'' as address2,
'' as address3,
k.nm as kojinNm,
k.kana as kana,
to_char(k.tanjoubi,'YYYYMMDD') as tanjoubi,
k.seibetu as seibetu ,
z.nm as zokugaraNm ,
kn1.nenrei as nenrei,
ki.nm as kikanNm,
'KM'||substr(x.nendo,length(x.nendo)-1,2)||ctm.nm||
lpad(to_char(case when cnt.count >99 then 99 else cnt.count end),2,'0') as km1,
x.knsn_seqno as knsnSeq,
to_char(kn1.kensinbi,'YYYYMMDD') as kensinbi1,
to_char(x.kanyu_no) as kanyuNo,
to_char(x.fuyou_no) as fuyouNo
from dai_x_new_kaisouka x
   left join KOJINRIREKI KO
        ON x.kanyu_no = KO.KANYU_NO
        AND x.fuyou_no = KO.FUYOU_NO
        AND x.syutoku_no = KO.SYUTOKU_NO
   left join juusyo ju
      on ju.fuyou_no = x.fuyou_no
       and ju.kanyu_no = x.kanyu_no
   left join kojin k
       on k.fuyou_no = x.fuyou_no
       and k.kanyu_no = x.kanyu_no
   left join zokugara  z
       on z.cd = ko.zokugara_cd
   left join knsn1 kn1
      on kn1.seq_no = x.knsn_seqno
   left join kikan  ki 
      on ki.cd = kn1.kikan_cd
   left join DAI_TS_SIDOUTAI ts
       on ts.nendo = x.nendo 
       and ts.fuyou_no = x.fuyou_no
       and ts.kanyu_no = x.kanyu_no   
   left join ctm_code_tbl ctm
    on ctm.cd = ts.dhp_kbn
    and ctm.kbn='D12'
    left join DAI_HK_OUTPUT_CNT cnt
    on cnt.nendo =x.nendo
where x.TERMN_IDENT = TO_TIMESTAMP(/*data.termnIdent*/,'RR-MM-DD HH24:MI:SSXFF')
order by KO.Kigou ,ko.bangou,z.cd 


--------------------------------------------------------
nvl2()

---------------------------------------------------------------
select
lpad(ko.kigou,4,'0') as kigou,
ko.bangou,
koj.nm as kojin_nm,
to_char(koj.tanjoubi,'YYYY/MM/DD')as tanjoubi,--
m.org as sex,
z.nm as zokugara_nm,
FN_NENREI(koj.tanjoubi,sysdate) as age,
dhp.genkou_dhp_kbn as dhp_kbn,
c.note,
ctm.org,
dhp.nendo,--
dhp.knsn_no
from dai_dhp_taisyosya dhp
 inner join kojinrireki ko
    on dhp.kanyu_no = ko.kanyu_no
    and dhp.fuyou_no = ko.fuyou_no
 inner join kojin koj
   on ko.kanyu_no= koj.kanyu_no
   and ko.fuyou_no = koj.fuyou_no
   and ko.syutoku_no = (select max(ko1.syutoku_no)  from kojinrireki ko1 where ko.kanyu_no = ko1.kanyu_no and ko.fuyou_no = ko1.fuyou_no)
 left join zokugara z
   on ko.zokugara_cd = z.cd
 left join m_code_tbl m
   on m.kbn ='119'
   and m.cd = koj.seibetu  
 left join ctm_code_tbl ctm
  on dhp.hantei_moto = ctm.cd
  and ctm.kbn ='D18' 
 left join ctm_code_tbl c
   on dhp.genkou_dhp_kbn = c.cd
   and c.kbn ='D12'    
 /*BEGIN*/
 where
    /*IF data.dhpArrayCd != null*/
     dhp.genkou_dhp_kbn in /*data.dhpArrayCd*/('selectGroup')
   /*END*/
      /*IF data.sosituFlag ==true */
        and (
            ((SELECT DISTINCT FIRST_VALUE(SOUSITUBI) OVER(PARTITION BY KANYU_NO,FUYOU_NO ORDER BY SYUTOKU_NO DESC)
               FROM KOJINRIREKI
              WHERE KANYU_NO = dhp.KANYU_NO
                AND FUYOU_NO = dhp.FUYOU_NO) IS NULL
            )
            OR
            ((SELECT DISTINCT FIRST_VALUE(SOUSITUBI) OVER(PARTITION BY KANYU_NO,FUYOU_NO ORDER BY SYUTOKU_NO DESC)
               FROM KOJINRIREKI
              WHERE KANYU_NO = dhp.KANYU_NO
                AND FUYOU_NO = dhp.FUYOU_NO) > SYSDATE
             AND
             (SELECT DISTINCT FIRST_VALUE(SYUTOKUBI) OVER(PARTITION BY KANYU_NO,FUYOU_NO ORDER BY SYUTOKU_NO DESC)
               FROM KOJINRIREKI
              WHERE KANYU_NO = dhp.KANYU_NO
                AND FUYOU_NO = dhp.FUYOU_NO) <= SYSDATE
            )
        
         ) 
    /*END*/
  
    /*IF data.zokugaraKbn == "1" */
    and ko.fuyou_no ='0'
    /*END*/
    /*IF data.zokugaraKbn == "2" */
    and ko.fuyou_no <>'0'
    /*END*/
  /*IF data.ageFrom !=null and data.ageFrom !="" */
  and (to_char(sysdate,'YYYY') - to_char(koj.tanjoubi,'YYYY')+1) >=  /*data.ageFrom*/
  /*END*/
  /*IF data.ageTo !=null and data.ageTo !="" */
  and (to_char(sysdate,'YYYY') - to_char(koj.tanjoubi,'YYYY')+1) <= /*data.ageTo*/ 
  /*END*/      
  /*IF data.sex !=null and data.sex != "" */
    and koj.seibetu =/*data.sex*/
    /*END*/
   
    /*IF data.reseCheckBox == true*/
    /*IF data.hanni == "1" */
     /*IF data.kigouArray != null*/
     and ko.kigou in  /*data.kigouArray*/('selectGroup')
    /*END*/
    /*END*/
     
    /*IF data.hanni == "2" */
   /*IF data.personFlg == "1" */
    and ko.kanyu_no = /*data.kanyuNo*/
    and ko.fuyou_no = /*data.fuyouNo*/
   /*END*/
    /*IF data.personFlg == "0" */  
    and ko.kigou = /*data.kigou*/
    and ko.bangou =/*data.bangou*/
    /*END*/
  /*END*/ 
 /*END*/   
/*END*/
    order by ko.kigou,ko.bangou,zokugara_nm
------------------------------------------------------------------------------
SELECT CT.CD,T.VAL 
FROM CTM_CODE_TBL CT
  LEFT JOIN M_XML MXM
  ON CT.CD = MXM.XML_CD
 
 
  LEFT JOIN (
   SELECT TMP.XML_GROUP_CD,TMP.VAL 
    FROM(
     SELECT XM.XML_GROUP_CD,K2.VAL,rank() over(partition by XM.XML_GROUP_CD order by XM.JUN_NO) AS ROW_ 
     FROM M_XML XM
     LEFT JOIN KENSA KE
     ON XM.XML_CD = KE.JLAC10_CD
     LEFT JOIN KNSN2 K2
     ON K2.KOUMOKU_CD = KE.CD
     AND K2.SEQ_NO = 30009
     WHERE XML_GROUP_CD IN (
              SELECT MX.XML_GROUP_CD
              FROM CTM_CODE_TBL CT
              LEFT JOIN M_XML MX
              ON CT.CD = MX.XML_CD
              WHERE CT.KBN = 'D17')
              AND K2.VAL IS NOT NULL 
     ) TMP   
WHERE TMP.ROW_ = 1) t
on mxm.xml_group_cd = t.xml_group_cd


where ct.kbn = 'D17'
ORDER BY CT.SEQ

---------------------------------------------------------------------------

 CURSOR  CUR_KAISOUKA IS
      SELECT
          KNSN_SEQNO,
          TO_CHAR(YEARMONTH, 'yyyy/MM/dd'),
          NENDO,
          KANYU_NO,
          FUYOU_NO,
          SYUTOKU_NO,
          A_SIDOU_KBN
      FROM DAI_X_NEW_KAISOUKA
      WHERE TERMN_IDENT = TO_TIMESTAMP(P_TERMINAL,'RR-MM-DD HH24:MI:SSXFF')
        AND KAISOUKA_FLG = 1
        AND NENDO = P_NENDO;



  OPEN CUR_KAISOUKA;
    v_process := 'STEP2';
    LOOP
      FETCH CUR_KAISOUKA
      INTO  VAR_SEQ_NO,
            VAR_YEARMONTH,
            VAR_NENDO,
            VAR_KANYU_NO,
            VAR_FUYOU_NO,
            VAR_SYOTOKU_NO,
            VAR_SIDOU_KBN;
       EXIT WHEN CUR_KAISOUKA%NOTFOUND;
       IF P_KAISOU_STEP = '1' THEN
        PS_DO_KAISOUKA_ONE
        (
          VAR_SEQ_NO,
          VAR_YEARMONTH,
          VAR_NENDO,
          VAR_KANYU_NO,
          VAR_FUYOU_NO,
          VAR_SYOTOKU_NO,
          VAR_SIDOU_KBN,
          P_USER_ID,
          P_KAISOU_STEP,
          P_STATUS
        );
        END IF;
        
        --新階層化処理(STEP2)
        IF P_KAISOU_STEP = '2' THEN
          cnt_temp := FN_KAISOUKA_HANTEI(VAR_NENDO, VAR_KANYU_NO, VAR_FUYOU_NO, VAR_SEQ_NO, VAR_SYOTOKU_NO,VAR_YEARMONTH,P_USER_ID,P_KAISOU_STEP);
        END IF;
      END LOOP;
    v_process := 'STEP3';
    CLOSE CUR_KAISOUKA;


---------------------------------------------------------------------------
UPDATE DAI_TS_SIDOUTAI2
SET  FSTOUTPUT_DATE = NVL(FSTOUTPUT_DATE,SYSDATE)
	,LSTOUTPUT_DATE = SYSDATE
	,KOUSIN_ID = /*data.userId*/
	,KOUSIN_DATETIME = SYSTIMESTAMP
	,REVISION_NO = NVL(REVISION_NO,0) + 1
WHERE EXISTS (
        	  SELECT ID FROM DAI_X_NEW_KAISOUKA
        	  WHERE TERMN_IDENT = TO_TIMESTAMP(/*data.termnIdent*/,'RR-MM-DD HH24:MI:SSXFF')
          	  AND NENDO = DAI_TS_SIDOUTAI2.NENDO
          	  AND KANYU_NO = DAI_TS_SIDOUTAI2.KANYU_NO
          	  AND FUYOU_NO = DAI_TS_SIDOUTAI2.FUYOU_NO
          	 )


------------------------------------------------------------------

@Sql("UPDATE DAI_X_NEW_KAISOUKA SET YEARMONTH = ?")
	public void updateYearMonth(String syoriDate);
}

-----------------------------------------------------------------------
SELECT CT.CD,T.VAL 
FROM CTM_CODE_TBL CT
  LEFT JOIN M_XML MXM
  ON CT.CD = MXM.XML_CD
  LEFT JOIN 

(
select a.xml_group_cd,kn2.val
from 
(
 SELECT xm.xml_group_cd, min(xm.jun_no) as jun_no
     FROM M_XML XM
     LEFT JOIN KENSA KE
     ON XM.XML_CD = KE.JLAC10_CD
     LEFT JOIN KNSN2 K2
     ON K2.KOUMOKU_CD = KE.CD
     AND K2.SEQ_NO = 861
     WHERE XML_GROUP_CD IN (
              SELECT MX.XML_GROUP_CD
              FROM CTM_CODE_TBL CT
              LEFT JOIN M_XML MX
              ON CT.CD = MX.XML_CD
              WHERE CT.KBN = 'D17')
              AND K2.VAL IS NOT NULL 
    group by xm.xml_group_cd
)a
left join m_xml m
  on m.xml_group_cd = a.xml_group_cd
  and m.jun_no = a.jun_no
left join kensa k
  on k.jlac10_cd =m.xml_cd
  left join knsn2 kn2
  on kn2.seq_no =861
  and kn2.koumoku_cd = k.cd 
  )t
on mxm.xml_group_cd = t.xml_group_cd
where ct.kbn = 'D17'
ORDER BY CT.SEQ

--------------------------------------------------------------

		
-----------------------------------------------------------------------------
例1: 建立一个触发器, 当职工表 emp 表被删除一条记录时，把被删除记录写到职工表删除日志表中去。

 

CREATE TABLE emp_his AS SELECT * FROM EMP WHERE 1=2; 
CREATE OR REPLACE TRIGGER tr_del_emp 
   BEFORE DELETE --指定触发时机为删除操作前触发
   ON scott.emp 
   FOR EACH ROW   --说明创建的是行级触发器 
BEGIN
   --将修改前数据插入到日志记录表 del_emp ,以供监督使用。
   INSERT INTO emp_his(deptno , empno, ename , job ,mgr , sal , comm , hiredate )
       VALUES( :old.deptno, :old.empno, :old.ename , :old.job,:old.mgr, :old.sal, :old.comm, :old.hiredate );
END;
DELETE emp WHERE empno=7788;


-----------------------------------------------------------------------
  create table employee(
       Id int ,
       DeptNo number,
       EmpNo number,
       Ename varchar2(16),
       Job varchar2(32),
       Sal float,
       HireDate date,
       constraint pk_employee primary key(EmpNo)
        );
 
     第二，创建员工表自动增长序列
     create sequence employ_autoinc
     minvalue 1
     maxvalue 9999999999999999999999999999
     start with 1
     increment by 1
     nocache;
 
     第三，创建触发器将序列中的值赋给插入employee表的行
     create or replace tirgger insert_employee_autoinc
     before insert  on employee
     for each row
          begin
               select employ_autoinc.nextval into :new.Id from dual;
          end insert_employee_autoinc
 
     最后测试一下我们的成果
     insert into employee(DeptNo,EmpNo,Ename,job,sal,hiredate)                                 values(520,5201002,'James zhou','PD',6000,to_date('2012-10-22','yyyy-mm-dd'));


----------------------------------------------------------------
例3：限定只对部门号为80的记录进行行触发器操作。

 

CREATE OR REPLACE TRIGGER tr_emp_sal_comm
BEFORE UPDATE OF salary, commission_pct
       OR DELETE
ON HR.employees
FOR EACH ROW
WHEN (old.department_id = 80)
BEGIN
 CASE
     WHEN UPDATING ('salary') THEN
        IF :NEW.salary < :old.salary THEN

           RAISE_APPLICATION_ERROR(-20001, '部门80的人员的工资不能降');
        END IF;
     WHEN UPDATING ('commission_pct') THEN

        IF :NEW.commission_pct < :old.commission_pct THEN
           RAISE_APPLICATION_ERROR(-20002, '部门80的人员的奖金不能降');
        END IF;
     WHEN DELETING THEN
          RAISE_APPLICATION_ERROR(-20003, '不能删除部门80的人员记录');
     END CASE;
END; 

/*
实例：
UPDATE employees SET salary = 8000 WHERE employee_id = 177;
DELETE FROM employees WHERE employee_id in (177,170);
*/

--------------------------------------------------------------------
 

例4：利用行触发器实现级联更新。在修改了主表regions中的region_id之后（AFTER），级联的、自动的更新子表countries表中原来在该地区的国家的region_id。

 

 

CREATE OR REPLACE TRIGGER tr_reg_cou
AFTER update OF region_id
ON regions
FOR EACH ROW
BEGIN
 DBMS_OUTPUT.PUT_LINE('旧的region_id值是'||:old.region_id
                  ||'、新的region_id值是'||:new.region_id);
 UPDATE countries SET region_id = :new.region_id
 WHERE region_id = :old.region_id;
END;

------------------------------------------------------
例5：在触发器中调用过程。

 

CREATE OR REPLACE PROCEDURE add_job_history
 ( p_emp_id          job_history.employee_id%type
   , p_start_date      job_history.start_date%type
  , p_end_date        job_history.end_date%type
   , p_job_id          job_history.job_id%type
   , p_department_id   job_history.department_id%type
   )
IS
BEGIN
 INSERT INTO job_history (employee_id, start_date, end_date,
                           job_id, department_id)
  VALUES(p_emp_id, p_start_date, p_end_date, p_job_id, p_department_id);
END add_job_history;

--创建触发器调用存储过程...
CREATE OR REPLACE TRIGGER update_job_history
 AFTER UPDATE OF job_id, department_id ON employees
 FOR EACH ROW
BEGIN
 add_job_history(:old.employee_id, :old.hire_date, sysdate,
                  :old.job_id, :old.department_id);
END;

------------------------------------------------------------------------------------------
