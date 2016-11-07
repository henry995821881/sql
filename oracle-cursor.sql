
一  概念
游标是SQL的一个内存工作区，由系统或用户以变量的形式定义。游标的作用就是用于临时存储从数据库中提取的数据块。在某些情况下，需要把数据从存放在磁盘的表中调到计算机内存中进行处理，最后将处理结果显示出来或最终写回数据库。这样数据处理的速度才会提高，否则频繁的磁盘数据交换会降低效率。
二  类型
  Cursor类型包含三种: 隐式Cursor，显式Cursor和Ref Cursor（动态Cursor）。
1． 隐式Cursor:
1).对于Select …INTO…语句，一次只能从数据库中获取到一条数据，对于这种类型的DML Sql语句，就是隐式Cursor。例如：Select /Update / Insert/Delete操作。
2)作用：可以通过隐式Cusor的属性来了解操作的状态和结果，从而达到流程的控制。Cursor的属性包含：
SQL%ROWCOUNT 整型 代表DML语句成功执行的数据行数
SQL%FOUND  布尔型  值为TRUE代表插入、删除、更新或单行查询操作成功
SQL%NOTFOUND 布尔型 与SQL%FOUND属性返回值相反
SQL%ISOPEN 布尔型 DML执行过程中为真，结束后为假
3) 隐式Cursor是系统自动打开和关闭Cursor.
下面是一个Sample：
Sql代码 ： 

    Set Serveroutput on;   
      
    begin  
        update t_contract_master set liability_state = 1 where policy_code = '123456789';   
           
        if SQL%Found then  
           dbms_output.put_line('the Policy is updated successfully.');   
           commit;   
        else  
          dbms_output.put_line('the policy is updated failed.');   
        end if;   
      
    end;   
      
    /  

在PL/SQL中run:
Sql代码  

    SQL>    
        
    the policy is updated failed.   
        
    PL/SQL procedure successfully completed  

2． 显式Cursor：
（1） 对于从数据库中提取多行数据，就需要使用显式Cursor。显式Cursor的属性包含：
游标的属性   返回值类型   意    义 
%ROWCOUNT   整型  获得FETCH语句返回的数据行数 
%FOUND  布尔型 最近的FETCH语句返回一行数据则为真，否则为假 
%NOTFOUND   布尔型 与%FOUND属性返回值相反 
%ISOPEN 布尔型 游标已经打开时值为真，否则为假 

（2） 对于显式游标的运用分为四个步骤：
 定义游标---Cursor  [Cursor Name]  IS;
 打开游标---Open  [Cursor Name];
 操作数据---Fetch  [Cursor name]
 关闭游标---Close [Cursor Name],这个Step绝对不可以遗漏。
（3）以下是三种常见显式Cursor用法。
1）
Sql代码  

    Set serveroutput on;   
      
    declare    
        ---define Cursor   
        Cursor cur_policy is  
         select cm.policy_code, cm.applicant_id, cm.period_prem,cm.bank_code,cm.bank_account   
         from t_contract_master cm   
         where cm.liability_state = 2   
         and cm.policy_type = 1   
         and cm.policy_cate in ('2','3','4')   
         and rownum < 5   
         order by cm.policy_code desc;   
        curPolicyInfo cur_policy%rowtype;---定义游标变量   
    Begin  
       open cur_policy; ---open cursor   
       Loop    
         --deal with extraction data from DB   
         Fetch cur_policy into curPolicyInfo;   
         Exit when cur_policy%notfound;   
                
         Dbms_Output.put_line(curPolicyInfo.policy_code);   
       end loop;   
       Exception    
         when others then  
             close cur_policy;   
             Dbms_Output.put_line(Sqlerrm);   
                
       if cur_policy%isopen then     
        --close cursor    
          close cur_policy;   
       end if;   
    end;   
      
    /  

2）
Sql代码  

    Set serveroutput on;   
      
    declare    
        Cursor cur_policy is  
         select cm.policy_code, cm.applicant_id, cm.period_prem,cm.bank_code,cm.bank_account   
         from t_contract_master cm   
         where cm.liability_state = 2   
         and cm.policy_type = 1   
         and cm.policy_cate in ('2','3','4')   
         and rownum < 5   
         order by cm.policy_code desc;   
         v_policyCode t_contract_master.policy_code%type;   
         v_applicantId t_contract_master.applicant_id%type;   
         v_periodPrem t_contract_master.period_prem%type;   
         v_bankCode t_contract_master.bank_code%type;   
         v_bankAccount t_contract_master.bank_account%type;   
    Begin  
       open cur_policy;   
       Loop    
         Fetch cur_policy into v_policyCode,   
                               v_applicantId,   
                               v_periodPrem,   
                               v_bankCode,   
                               v_bankAccount;   
         Exit when cur_policy%notfound;   
                
         Dbms_Output.put_line(v_policyCode);   
       end loop;   
       Exception    
         when others then  
             close cur_policy;   
             Dbms_Output.put_line(Sqlerrm);   
                
       if cur_policy%isopen then      
          close cur_policy;   
       end if;   
    end;   
    /  

3）
Sql代码  

    Set serveroutput on;   
      
    declare    
        Cursor cur_policy is  
         select cm.policy_code, cm.applicant_id, cm.period_prem,cm.bank_code,cm.bank_account   
         from t_contract_master cm   
         where cm.liability_state = 2   
         and cm.policy_type = 1   
         and cm.policy_cate in ('2','3','4')   
         and rownum < 5   
         order by cm.policy_code desc;   
    Begin  
       For rec_Policy in cur_policy loop   
           Dbms_Output.put_line(rec_policy.policy_code);   
       end loop;   
       Exception    
         when others then  
             Dbms_Output.put_line(Sqlerrm);   
                
    end;   
      
    /  

run pl/sql,执行结果如下：
Sql代码  

    SQL>    
        
    8780203932   
    8780203227   
    8780203218   
    8771289268   
        
    PL/SQL procedure successfully completed  

3． Ref Cursor（动态游标）：
1） 与隐式Cursor,显式Cursor的区别：Ref Cursor是可以通过在运行期间传递参数来获取数据结果集。而另外两种Cursor，是静态的，在编译期间就决定数据结果集。
2） Ref cursor的使用:
 Type [Cursor type name] is ref cursor
 Define 动态的Sql语句
 Open cursor
 操作数据---Fetch  [Cursor name]
 Close Cursor
下面是一个Sample：
Sql代码  

    Set serveroutput on;   
      
    Declare  
        ---define cursor type name   
        type cur_type is ref cursor;   
        cur_policy cur_type;   
        sqlStr varchar2(500);   
        rec_policy t_contract_master%rowtype;   
    begin  
       ---define 动态Sql   
       sqlStr := 'select cm.policy_code, cm.applicant_id, cm.period_prem,cm.bank_code,cm.bank_account from t_contract_master cm   
         where cm.liability_state = 2    
         and cm.policy_type = 1    
         and cm.policy_cate in (2,3,4)    
         and rownum < 5    
         order by cm.policy_code desc ';   
    ---Open Cursor   
      open cur_policy for sqlStr;   
      loop   
           fetch cur_policy into rec_policy.policy_code, rec_policy.applicant_id, rec_policy.period_prem,rec_policy.bank_code,rec_policy.bank_account;   
           exit when cur_policy%notfound;   
              
           Dbms_Output.put_line('Policy_code:'||rec_policy.policy_code);   
         
      end loop;   
    close cur_policy;       
      
    end;   
    /  


4.常见Exception
Sql代码  

    1.  错 误 名 称 错误代码    错 误 含 义      
    2.  CURSOR_ALREADY_OPEN ORA_06511   试图打开已经打开的游标      
    3.  INVALID_CURSOR  ORA_01001   试图使用没有打开的游标      
    4.  DUP_VAL_ON_INDEX    ORA_00001   保存重复值到惟一索引约束的列中      
    5.  ZERO_DIVIDE ORA_01476   发生除数为零的除法错误      
    6.  INVALID_NUMBER  ORA_01722   试图对无效字符进行数值转换      
    7.  ROWTYPE_MISMATCH    ORA_06504   主变量和游标的类型不兼容      
    8.  VALUE_ERROR ORA_06502   转换、截断或算术运算发生错误      
    9.  TOO_MANY_ROWS   ORA_01422   SELECT…INTO…语句返回多于一行的数据      
    10. NO_DATA_FOUND   ORA_01403   SELECT…INTO…语句没有数据返回      
    11. TIMEOUT_ON_RESOURCE ORA_00051   等待资源时发生超时错误      
    12. TRANSACTION_BACKED_OUT  ORA_00060   由于死锁，提交失败      
    13. STORAGE_ERROR   ORA_06500   发生内存错误      
    14. PROGRAM_ERROR   ORA_06501   发生PL/SQL内部错误      
    15. NOT_LOGGED_ON   ORA_01012   试图操作未连接的数据库      
    16. LOGIN_DENIED    ORA_01017   在连接时提供了无效用户名或口令   