
--������ռ�
create tablespace lhsUserManager
datafile 'E:\oracle\lhsUserManager'
size 100M
--�����û�
create user lhsManager
identified by 123321
default tablespace lhsUserManager
--���û����迪����Ȩ��
grant connect,resource to lhsManager
--���û�ʹ�ñ�ռ��Ȩ��
alter user lhsManager quota unlimited on lhsUserManager
--�����û�
create table Users(
id number(10) primary key,
username varchar(20) not null,
userpassword varchar(11) not null,
userphone varchar(11) not null
)
--��������
create sequence seq_users
start with 10001
increment by 1;
--����������
create or replace trigger t_users
before insert on Users
for each row 
  begin 
    select seq_users.nextval into :new.id from dual;
    end;
    --����������ݳ�������Ա
    insert into Users values(1,'admin','123','17863818241');
    --��Ӳ����û�
    insert into Users values(1,'test','123','123123');
    select * from Users;
    
--������ɫ��
create table  role(
id number(10) primary key,
rolename varchar(20) not null,
massage varchar(200) not null
)
--��������
create sequence seq_role
start with 10001
increment by 1;
--����������
create or replace trigger t_role
before insert on role
for each row 
  begin 
    select  seq_role.nextval into :new.id  from dual;
    end;
   --�����������  ��ɫ
    insert into role values(1,'��������Ա','ϵͳboss');
    insert into role values(1,'����Ա','С����');
    --��ѯ��������
    select * from role;
    --����Ȩ�ޱ�
create table permission(
id number(10) primary key,
per_name varchar(20) not null,
per_url varchar(100) not null,
per_massger varchar(150) not null
)
--��������
create sequence seq_permission
start with 10001
increment by 1;
--����������
create or replace trigger t_permission
before insert on permission
for each row 
  begin 
    select seq_permission.nextval into :new.id from dual;
    end;
--�����������Ȩ��
    insert into permission values(1,'����','/admin/add','�����û�Ȩ��');
    insert into permission values(1,'����','/admin/update','�޸��û���Ϣ');
    insert into permission values(1,'ɾ��','/admin/delete','ɾ���û���Ϣ');
    insert into permission values(1,'��ѯ','/admin/select','��ѯ�û���Ϣ');
 --��ѯ��������
 select  * from permission;  
 
 --�����û���ɫ��  
    create table user_role(
    id number(10) primary key,
    user_id number(10) not null references Users(id),
    role_id number(10) not null
    )
--�����⽨
alter table user_role add(constraint USER_ROLE_f foreign key(role_id) references role(id));
    -- ��������
    create sequence seq_user_role
    start with 10001
    increment by 1;
    create or replace trigger t_users_role
      before insert on user_role
      for each row 
        begin 
          select seq_user_role.nextval into :new.id from dual;
          end;
       --�����������
      -- ���û���ӽ�ɫ
       insert into user_role values(1,10001,10001);
       insert into user_role values(1,10002,10002);
        --��ѯ��������
         select * from user_role;
       
   --������ɫȨ�ޱ�
   create table role_permission(
   id number(10) primary key,
   role_id  number(10) not null,
   permission_id number(10) not null
   )
   --��������
   create sequence seq_role_permission
   start with 10001
   increment by 1;
  --����������
   create  or replace trigger t_role_permission
   before insert on role_permission
   for each row 
     begin
       select seq_role_permission.nextval into :new.id from dual;
       end;
      --������� 
 alter table role_permission add(constraint role_permission_f foreign key(role_id) references role(id));
 alter table role_permission add(constraint role_permision_f1 foreign key(permission_id) references permission(id));
    --�����������
    delete from role_permission where id=1;
    select * from role_permission;
   --����ɫ���Ȩ��
    insert into role_permission  values(1,10002,10001);
    insert into role_permission  values(1,10001,10002);
    insert into role_permission  values(1,10001,10003);
    insert into role_permission  values(1,10001,10004);
    /*
   ������ ������� �������ݲ���ɹ�
    */
    select u.name,p.url from
     users u inner join user_role ur on u.id=ur.userId
      inner join role_permission rp on ur.roleId=rp.roleId
       inner join permission p on rp.permissionId=p.id where u.id=2
    --�����û�ID ��ѯ��Ȩ��
    select u.username, p.id,p.per_name,p.per_url,p.per_massger from Users u inner join user_role ur on u.id=ur.user_id 
    inner join role_permission rp on ur.role_id=rp.role_id
    inner join permission p on rp.permission_id=p.id where u.id=10002;
    
      select r.id, p.id,p.per_name,p.per_url,p.per_massger from role r
    inner join role_permission rp on r.id=rp.role_id
    inner join permission p on rp.permission_id=p.id where r.rolename='����Ա';
    
        /*
        oracle ���ܲ���
        */
    create or replace package dbms_user_pm
    as
    --1���û��ͽ�ɫ����
    procedure pro_user_role(u_id number,r_id number,ur_o_id out number);
    --2�����û� ɾ��ĳ���û��Ĺ���
    procedure pro_user_role_delete(u_id number);
    --3�����û���Ϣ�������û���Ϣ
    procedure  user_add(
      u_name Users.Username%type,
      u_password Users.Userpassword%type,
      u_phone Users.Userphone%type,
      u_id out Users.Id%type
      );
   --4���ܽ�ɫ����Ȩ��ʵ�ֹ�����Ȩ�޵Ĳ���Ӧ�ÿ����Ƕ������p_id���в��
     procedure pro_role_permission(r_id number,
      p_id varchar,
      rp_o_id out number);
    
   
    --5�����û�ID��ѯ�û���ӵ�е�Ȩ��
    type cursor1 is ref cursor;
   procedure pro_user_permission(u_id number,o_u_p out cursor1);
   --6���ܽ�ɫ�� ��ѯ�ý�ɫ��ӵ�е�Ȩ��
   type cursor2 is ref cursor;
   procedure role_permission(r_name role.rolename%type,o_r_p out cursor2);
   --7����û��ĳ�ʼ��
   procedure Users_role_permission_init;
   --8��Ȩ�޽��з�ҳ�������ص�ǰҳ����
   type permission_data is ref cursor;
   function  permission_paging(page number) return permission_data;            
        
 end dbms_user_pm;
 --������
 create or replace package body dbms_user_pm
 as

       --1���û��ͽ�ɫ����
 procedure pro_user_role(
   u_id number,
   r_id number,
   ur_o_id out number
   )
   is
   begin
        insert into user_role values(1,u_id,r_id);
      select seq_user_role.currval into ur_o_id from dual;
      Exception
        when others then
          dbms_output.put_line('��������'||sqlerrm);
          rollback;
          
    end pro_user_role;
 
   --2�����û� ɾ��ĳ���û��Ĺ���
     procedure pro_user_role_delete(u_id number)
       is
       begin
       delete from user_role where user_role.user_id=u_id;
       Exception
        when others then
          dbms_output.put_line('��������'||sqlerrm);
          rollback;
       end pro_user_role_delete;
       
        --3�����û���Ϣ�������û���Ϣ
    procedure  user_add(
      u_name Users.Username%type,
      u_password Users.Userpassword%type,
      u_phone Users.Userphone%type,
      u_id out Users.Id%type
      )
      is
      begin
        insert into Users values(1,u_name,u_password,u_phone);
        select seq_users.currval into u_id from dual;
      Exception
        when others then
          dbms_output.put_line('��������'||sqlerrm);
          rollback;
        end user_add;
        
          --4���ܽ�ɫ����Ȩ��ʵ�ֹ�����Ȩ�޵Ĳ���Ӧ�ÿ����Ƕ������p_id���в��
  procedure pro_role_permission(r_id number,
      p_id varchar,
      rp_o_id out number)
      is
      begin
        insert into role_permission values(1,r_id,p_id);
         select seq_role_permission.currval into rp_o_id from dual;
      Exception
        when others then
          dbms_output.put_line('��������'||sqlerrm);
          rollback;
        end pro_role_permission;
       
      
       --5�����û�ID��ѯ�û���ӵ�е�Ȩ��
   --type cursor1 is ref cursor;
   procedure pro_user_permission(u_id number,o_u_p out cursor1)
     is
     begin
       open o_u_p for
       select u.username, p.id,p.per_name,p.per_url,p.per_massger from Users u inner join user_role ur on u.id=ur.user_id 
    inner join role_permission rp on ur.role_id=rp.role_id
    inner join permission p on rp.permission_id=p.id where u.id=u_id;
       end pro_user_permission;
       
       
       --6���ܽ�ɫ�� ��ѯ�ý�ɫ��ӵ�е�Ȩ��
   --type cursor2 is ref cursor;
   procedure role_permission(r_name role.rolename%type,o_r_p out cursor2)
     is
     begin
       open o_r_p for
         select r.id, p.id,p.per_name,p.per_url,p.per_massger from role r
         inner join role_permission rp on r.id=rp.role_id
         inner join permission p on rp.permission_id=p.id where r.rolename=r_name;
       end role_permission;
       
         --7����û��ĳ�ʼ��
   procedure Users_role_permission_init
     is
     begin
       --��ʼ���û�
         insert into Users values(1,'admin','123','17863818241');
         insert into Users values(1,'test','123','123123');
       --��ʼ����ɫ
        insert into role values(1,'��������Ա','ϵͳboss');
       insert into role values(1,'����Ա','С����');
       --��ʼ��Ȩ��
         insert into permission values(1,'����','/admin/add','�����û�Ȩ��');
         insert into permission values(1,'����','/admin/update','�޸��û���Ϣ');
         insert into permission values(1,'ɾ��','/admin/delete','ɾ���û���Ϣ');
         insert into permission values(1,'��ѯ','/admin/select','��ѯ�û���Ϣ');
       --���û���ӽ�ɫ
     insert into user_role values(1,10001,10001);
       insert into user_role values(1,10002,10002);
       --����ɫ���Ȩ��
       insert into role_permission  values(1,10002,10001);
        insert into role_permission  values(1,10001,10002);
         insert into role_permission  values(1,10001,10003);
        insert into role_permission  values(1,10001,10004);
       end Users_role_permission_init;
       
       
        --8��Ȩ�޽��з�ҳ�������ص�ǰҳ����
  -- type permission_data is ref cursor;
   function  permission_paging(page number) return permission_data 
     is
     
     rc permission_data;
     begin
       
     return rc;
       end permission_paging;
      
 end dbms_user_pm;

 Declare 
 u_id Users.id%type;
 begin
 dbms_user_pm.user_add('С��','123','1231231200',u_id);
 dbms_output.put_line('new insert'||u_id);
 end;
 declare
 type cursor1 is ref cursor;
 massage dbms_user_pm.cursor1;
 rec_next permission.per_name%type;
 begin
 dbms_user_pm.pro_user_permission(10003,massage);
    fetch massage into rec_next;
    dbms_output.put_line(rec_next);
 
 end;
 
 
 
 
 
 
 
 
 
 
 
 
    
  
