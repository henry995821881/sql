####��ʿ�α�E
declare
  flag char :='u';
   begin
   update dvds
   set dname ='888'
   where id=100;
    if SQL%NOTFOUND then
   flag:='z';
   insert into dvds(dname,dcount)values('uuuu',8);
   end if;
   if flag ='u' then
   dbms_output.put_line('1');
   else
   dbms_output.put_line('0');
   end if;
  end;


###��ʾ�α�E�������
declare
cursor mycur is select * from dvds order by id;
myreco dvds%rowtype;
begin
open mycur;
fetch mycur into myreco;
while mycur%found loop
dbms_output.put_line(myreco.dname || ' ' || myreco.dcount);

end loop;
close mycur;
end;

###��ʾ�α�E�����
declare
cursor mycur(myjob varchar2) is
select * from emp where job = myjob;
begin
	for i in mycur('salesman') loop
		dbms_output.put_line(i.ename);
	end loop;
end;
/

### ��ʾ�α�E���������������
declare
 dept_no emp.deptno%type;
 emp_no  emp.empno%type;
 emp_name emp.ename%type;
cursor emp_cur(deptparam number) is
 select empno,ename from emp where deptno =deptparam;
begin
	dept_no:=&���ű��;
     open emp_cur(edpt_no);
    loop 
	fetch emp_cur into emp_no,emp_name;
	exit when emp_cur%notfound;
	dbms_output.put_line(emp_no || ' ' || emp_name);
    end loop;
 close emp_cur;
end;
/

###��ʾ�α�E��E��л�ɾ��
declare
 cursor mycur(dept_no integer) is
 select * from dept
 where deptno >dept_no   for update �������� (of ������;//��ЁEӣ� for update��
	begin
		for  index in mycur(50) loop
			delete from dept
			where current of mycur; //�α�E�ǰ��
		end loop;
	end;
	/
####ѭ��Ƕ���α�E
declare 
 cursor c_dept is
select deptno,dname,from dept order by deptno;
 cursor c_emp(p_dept varchar2) is
select ename ,sal from emp where deptno =p_dept ;
v_salary emp.sal%type;
begin
	for r_dept in c_dept loop
		dbms_output.put_line('department' || r_dept.deptno ||' '||r_dept.dname);
		v_salary:=0;
		for r_emp in c_emp(r_dept.deptno) loop
			dbms_output.put_line('name:' || r_emp.ename || 'salary:'|| r_emp.sal);
			v_salary:=v_salary+ emp.sal;
		end loop;
		dbms_output.put_line('total:'|| v_salary);
	end loop;
end;
/


########## REF �α�E��̬�α�E
 type mycur is ref cursor
 [return stud_dep%rowtype;]
s_cursor mycur;


declare
 type cursor_type is ref cursor;

 stu_cur cursor_type;
 v_stu user%rowtype;

begin
	open stu_cur for 
	  select * form user where sex ='male';
	loop 
		fetch stu_cur into v_stu;
		exit when stu_cur%notfound;
		dbms_output.put_line(v_stu.num || ''|| v_stu.name || v_stu.sex || v_stu.age);
	end loop;
	close stu_cur;
end;
/


#### ref �α�E
declare
 type empcurtyp is ref cursor;
 type idlist is table of emp.empno%type //����
 type namelist is table of emp.ename%type;
 type sallist is table of emp.sal%type;
 emp_cv empcurtyp;
 ids  idlist;
 names namelist;
 sals salist
 row_cn number;
begin
	open emp_cv for select empno,ename,sal from emp;
	fetch emp_cv bluk collect into ids,names,sals;
	close emp_cv;
	for i in ids.first .. ids.last loop
		dbms_output.put_line(ids(i) ' '||names(i) ||' '|| sals(i));

	end loop;
end;
/

####�м�ˁE

select * from emp where empno =7654 for update[of colmns,colmns,colmns];// for update ��ˁE


#####��ضˁE
lock table table_name in mode MODE;

//�����E
lock table emp in share mode;//�����û����ԵĲ�ѯemp��������,�����޸�ɾ����ȁE



######function

create or replace function fun_hello
 return varchar2
is
begin  
	return 'hello firend'||to_char(sysdate,'DAY');
end;
/

create or replace function fun_is_first_day
return number
is
v_result number:=0;
v_day varchar2(2);
begin
 select to_char(sysdate,'dd')into v_day from dual;
 if v_day ='01' them
	v_result:=1;
else
	v_result :=0;
end if;
return (v_reuslt��;
end;
/
//���ֽڳ��Ⱥ���
create or replace function getstringlen(str in varchar2)
return integer
is
 result integer;
  i number;
 begin
    result :=0;
 if length(str)=0 then
	return (reuslt);
 end if;
 for i in 1..length(str) loop
	if ascii(substr(str,i,1) <256 then//���Ǻ���
		result :=result +1;
	else
		result : result +2;
	end if;
end loop;
return(result);
end;
/

create or replace function find_deptname
(emp_no number)
return varchar2
as
 dept_no number(2);
 result dept.dname%type;
begin
	select deptno into dept_no from emp
	where empno = emp_no;
	select dname into result from dept
	where deptno =dept_no;
	return result;
	exception
	when others then
		return null;
end;
/

create or replace function sal_fun
(salary number)
return varchar2
as
max_sal number;
min_sal number;
begin
	select max(sal),min(sal) into max_sal,min_sal from emp;
	if salary >= max_sal and salary <=min_sal then
		return '��ȁEĹ��������������͹���֮��E;
	else 
		return '������Χ';
	end if;
end;
/

////���ú���
declare
sal number:= 1500;
msg varchar2(200);
begin
	msg:=sal_fun(sal);
	dbms_output.put_line(msg);
end;
/
####
select sal_fun(1500) from dual;
####
create or replace function work_day
(emp_num varchar2)
return number
as
v_days number;
v_sal number;
begin
	select workdays,salary into v_days,v_sal from salary
	where emp_num =empno;
	v_days:=22-v_days;
	if v_days >0 then
		v_sal:=v_sal - v_days*50;
	end if;
	if v_sal <0 then
		v_sal :=0;
	end if;
	return v_sal;
end;
/

create or replace function cursor_getdata
(n integer:=0)
return integer
is
n_result integer:0;
emp_no emp.empno%type;
emp_name emp.ename%type;
emp_sal emp.sal%type;
cursor cur_emp is select empno,ename,sal from emp;
begin
	case 
	when (n=0) then
		open cur_emp;
		loop
			fetch cur_emp into emp_no ,emp_name,emp_sal;
			exit when cur_emp%notfound;
			n_reuslt:= n_reuslt+1;
		end loop;
	else
		goto exit0;
	end case;
	<<exit0>>
	if cur_emp%isopen then
		close cur_emp;
	end if;
	return n_result;
end;
/

#############��E
create or replace package sales_report
as
cursor salsecur return emp;
end;
/
create or replace package body sales_report
as
cursor salescur return emp
is
select * from emp;
end;
/

//���ð�E
declare ename emp%rowtype;
begin
	open sales_report.salsecur
       loop
       	fetch sales_report.salsecur into ename;
	exit when sales_report.salescur%notfound;
	if ename.sal>3000 then
		dbms_output.put_line(ename.ename ||':��Ĺ��ʻ�����');
	elseif ename.sal <=3000 then
		dbms_output.put_line(enname.ename || '��Ĺ����е��');
	end if;
    end loop
close sales_report.salsecur;
end;
/

##package
create or replace package emp_data
as
type emprecetyp is record(emp_id number(5),
	emp_name varchar2(10),
	job_title varchar2(9),
	dept_name varchar2(14),
	dept_loc varchar2(13);
type empcurtyp is ref cursor return emprectyp;

procedure get_staff( dept_no number,
	             emp_cv in out empcurtyp);
end;
/
create or replace package body emp_data
as
procedure get_staff
(dept_no in number,emp_cv in out empcurtyp)
is 
begin
	open emp_cv for select empno,ename,job,dname,loc from emp,dept
	where emp.deptno =dept_no and emp.deptno =dept.deptno
end;
end;
/
///���ð�E
var cv ref cursor
exec emp_data.get_staff(20,:cv);


��?�Ȋœ���?FOR�z???�k�D�I?������?�I??�C
��?�s�ݎ��vopen�Afetch�aclose?��C�s�ݎ��v�p%FOUND����??���ۓ��ō@���??�C
?���Oracle?���I?��?�������B
�@��?�z?�����ҍX�V��Select For Update���p�I??�C?�Ȏg�pWhere Current Of?��B
declare

cursor emp_cur is
select * from emp for update;

begin
for emp_row in emp_cur
loop
if emp_row.job='manager'then
update emp set sal=sal+5000 where current of emp_cur;

else 
update emp set sal =sal+1000 where curren of emp_cur;
end if;
end loop;
end;



	










