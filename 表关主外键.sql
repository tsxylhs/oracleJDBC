create table t_user(
Userid number(38),   --�û���ţ���������
Pwd Nvarchar2(100) not null,
Nickname Nvarchar2(10) not null,
Sex Number(1) check(sex=0 or sex=1),
Birthday Date ,
Currstate Number(1), --Ĭ��ֵ0�������ǰ״̬
Friendshippolicy  number(1)--������Ѳ���
)
create or replace trigger t_user
before insert on t_user
for each row 
  begin 
   select seq_user.nextval into :new.Userid from dual;
   end;
alter table t_user add(constraint t_user_p primary key(Userid));
alter table t_user add(constraint t_user_t_onlinestate_f foreign key(Currstate) references t_onlinestate(Stateid));
alter table t_user add(constraint t_user_t_friendshippolicy foreign key(Friendshippolicy) references t_friendshippolicy(polid) );--������Լ��
create sequence seq_user
start with 10001
increment by 1;
insert into t_user values(1,'sp9527','���',1,TO_Date('1994-12-12','YYYY-MM-DD'),1,1);
select * from t_user;
create table t_onlinestate --�û�״̬��
(
Stateid number(1) not null,--״̬���
Statedesc Nvarchar2(10) not null --״̬���� Ψһ
)
alter table t_onlinestate add(constraint t_onlinestate_p primary key(Stateid));
insert into t_onlinestate values(1,'����');
insert into t_onlinestate values(2,'����');
insert into t_onlinestate values(3,'����');
insert into t_onlinestate values(4,'æµ');
select * from t_onlinestate;
create table t_friendshippolicy--���Ѳ��Ա�
(
polid Number(1) not null,--��� ����
policy   Nvarchar2(20) not null --���Ѳ��� Ψһ
)
alter table t_friendshippolicy add(constraint t_friendshippolicy_p primary key(polid));
insert into t_friendshippolicy values(1,'�����κ��˼�Ϊ����');
insert into t_friendshippolicy values(2,'�������κ��˼�Ϊ����');
insert into t_friendshippolicy values(3,'��֤���Ϊ����');
select * from t_friendshippolicy;
drop table t_friend
create  table t_friend (
Ufid Number(38) not null ,--�������� ���
Userid Number(38) not null --��� ��� �û����
)

alter table t_friend add(constraint friendid_p primary key(Ufid));
alter table t_friend add(constraint t_friend_t_user_f foreign key(Userid) references t_user(Userid));
insert into t_friend values(1,10002);
--insert into t_friend values(2,1003);
--alter table t_friend add(constraint t_friend_t_)
--�������� 
create or replace trigger tri_t_messsage
before insert on t_message
for each row 
  begin 
    select seq_mesage.nextval into :new.messageId from dual;
    end;
create sequence seq_friend 
start with 1
increment by 1;
drop table t_message;
create  table t_message
(
messageId Number(38) not null, --������
FormuserId Number(38) not null, --���
TouserId Number(38) not null,--���
ContentText Nvarchar2(50),
Messagetype Number(1) check(messagetype=1 or messagetype=0),--���Լ����Ϣ����
 State Number(1) check(State=1 or State=0), --Ĭ��ֵ ���Լ��
Sendtime Date --Ĭ��ֵ
)
alter table t_message add(constraint message_p primary key(messageId));
alter table t_message add(constraint t_user_t_message_f foreign key(FormuserId) references t_user(Userid));
alter table t_message add(constraint t_user_t_mesage_f2 foreign key (TouserId) references t_user(Userid));
insert into t_message values(seq_mesage.nextval,10002,10004,'adjfladsjf', 1,1,sysdate);
--remove * from t_message where messageId=10002;
--ɾ��������
TRUNCATE TABLE t_message;
select *from t_message;
--��Ϣ����
create sequence seq_mesage
start with 1
increment by 1;

create table t_admin(
AdminId number(10) not null,--��������
Adminname Nvarchar2(20) unique,--Ψһ
Adminpwd Nvarchar2(10) not null 
)
insert into t_admin values(seq_admin.nextval,'admin','sp9527')
select * from t_user;
--����Ա����
create sequence seq_admin
start with 888888
increment by 1;


select * from t_user;
create or replace package pkg_user
as 
procedure sp_insertuser(pwd varchar2,
  nickname varchar2,
  sex number,
  brithday date,
  currsate number,
 firendshippolicy number,
 o_userid out number
 
  );
  end pkg_user;
  
  create or replace package body pkg_user
  as
  procedure sp_insertuser(pwd varchar2,
  nickname varchar2,
  sex number,
  brithday date,
  currsate number,
 firendshippolicy number,
 o_userid out number
 
  )
  as
  begin
    insert into t_user values(1,pwd,nickname,sex,brithday,
currsate,firendshippolicy);
--�����������ֵ
select seq_user.currval into o_userid from dual;
Exception
  when others then
    dbms_output.put_line('��������'||sqlerrm);
    rollback;
    end sp_insertuser;
    end pkg_user;
    
    
    
    
    
       Declare
    L_userID t_user.userid%type;
    begin
      pkg_user.sp_insertuser('sp9527','���9527',0,to_date('1990-10-12','YYYY-MM-DD'),1,1,L_userID);
      DBMS_OUTPUT.put_line('�²����id��'||L_userID);
      end;
      select * from t_user;
      
      
     create or replace package pag_find
     as
     type cursor1 is ref cursor;
     procedure t_user_find(
       o_id number,
       o_niceng varchar2,
      o_userid out cursor1
       );
       end;
      
      create or replace package body pag_find
      as 
      
      procedure t_user_find(
         o_id number,
       o_niceng varchar2,
       o_userid out cursor1
       )
       is
       begin
          
         if   o_id  is not null then
            open o_userid for
         select * from t_user where userid=o_id;
         end if;
         if o_niceng is not null then
            open o_userid for
          select * from t_user where  Nickname=o_niceng;
            end if;
          if    o_niceng is not null then
            if o_id  is not null then
             open o_userid for
             select * from t_user where  Nickname=o_niceng and userid=o_id;
             end if;
             end if;
      end t_user_find;
    end pag_find;
    
