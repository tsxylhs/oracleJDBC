
--创建表空间
create tablespace lhsUserManager
datafile 'E:\oracle\lhsUserManager'
size 100M
--创建用户
create user lhsManager
identified by 123321
default tablespace lhsUserManager
--给用户赋予开发者权限
grant connect,resource to lhsManager
--给用户使用表空间的权利
alter user lhsManager quota unlimited on lhsUserManager
--创建用户
create table Users(
id number(10) primary key,
username varchar(20) not null,
userpassword varchar(11) not null,
userphone varchar(11) not null
)
--创建序列
create sequence seq_users
start with 10001
increment by 1;
--创建触发器
create or replace trigger t_users
before insert on Users
for each row 
  begin 
    select seq_users.nextval into :new.id from dual;
    end;
    --插入测试数据超级管理员
    insert into Users values(1,'admin','123','17863818241');
    --添加测试用户
    insert into Users values(1,'test','123','123123');
    select * from Users;
    
--创建角色表
create table  role(
id number(10) primary key,
rolename varchar(20) not null,
massage varchar(200) not null
)
--创建序列
create sequence seq_role
start with 10001
increment by 1;
--创建触发器
create or replace trigger t_role
before insert on role
for each row 
  begin 
    select  seq_role.nextval into :new.id  from dual;
    end;
   --插入测试数据  角色
    insert into role values(1,'超级管理员','系统boss');
    insert into role values(1,'测试员','小罗罗');
    --查询测试数据
    select * from role;
    --创建权限表
create table permission(
id number(10) primary key,
per_name varchar(20) not null,
per_url varchar(100) not null,
per_massger varchar(150) not null
)
--创建序列
create sequence seq_permission
start with 10001
increment by 1;
--创建触发器
create or replace trigger t_permission
before insert on permission
for each row 
  begin 
    select seq_permission.nextval into :new.id from dual;
    end;
--插入测试数据权限
    insert into permission values(1,'增加','/admin/add','增加用户权限');
    insert into permission values(1,'更改','/admin/update','修改用户信息');
    insert into permission values(1,'删除','/admin/delete','删除用户信息');
    insert into permission values(1,'查询','/admin/select','查询用户信息');
 --查询测试数据
 select  * from permission;  
 
 --创建用户角色表  
    create table user_role(
    id number(10) primary key,
    user_id number(10) not null references Users(id),
    role_id number(10) not null
    )
--增加外建
alter table user_role add(constraint USER_ROLE_f foreign key(role_id) references role(id));
    -- 创建序列
    create sequence seq_user_role
    start with 10001
    increment by 1;
    create or replace trigger t_users_role
      before insert on user_role
      for each row 
        begin 
          select seq_user_role.nextval into :new.id from dual;
          end;
       --插入测试数据
      -- 给用户添加角色
       insert into user_role values(1,10001,10001);
       insert into user_role values(1,10002,10002);
        --查询测试数据
         select * from user_role;
       
   --创建角色权限表
   create table role_permission(
   id number(10) primary key,
   role_id  number(10) not null,
   permission_id number(10) not null
   )
   --创建序列
   create sequence seq_role_permission
   start with 10001
   increment by 1;
  --创建触发器
   create  or replace trigger t_role_permission
   before insert on role_permission
   for each row 
     begin
       select seq_role_permission.nextval into :new.id from dual;
       end;
      --插入外键 
 alter table role_permission add(constraint role_permission_f foreign key(role_id) references role(id));
 alter table role_permission add(constraint role_permision_f1 foreign key(permission_id) references permission(id));
    --插入测试数据
    delete from role_permission where id=1;
    select * from role_permission;
   --给角色添加权限
    insert into role_permission  values(1,10002,10001);
    insert into role_permission  values(1,10001,10002);
    insert into role_permission  values(1,10001,10003);
    insert into role_permission  values(1,10001,10004);
    /*
   基本表 创建完毕 测试数据插入成功
    */
    select u.name,p.url from
     users u inner join user_role ur on u.id=ur.userId
      inner join role_permission rp on ur.roleId=rp.roleId
       inner join permission p on rp.permissionId=p.id where u.id=2
    --根据用户ID 查询其权限
    select u.username, p.id,p.per_name,p.per_url,p.per_massger from Users u inner join user_role ur on u.id=ur.user_id 
    inner join role_permission rp on ur.role_id=rp.role_id
    inner join permission p on rp.permission_id=p.id where u.id=10002;
    
      select r.id, p.id,p.per_name,p.per_url,p.per_massger from role r
    inner join role_permission rp on r.id=rp.role_id
    inner join permission p on rp.permission_id=p.id where r.rolename='测试员';
    
        /*
        oracle 功能部分
        */
    create or replace package dbms_user_pm
    as
    --1将用户和角色关联
    procedure pro_user_role(u_id number,r_id number,ur_o_id out number);
    --2接受用户 删除某个用户的功能
    procedure pro_user_role_delete(u_id number);
    --3接受用户信息，增加用户信息
    procedure  user_add(
      u_name Users.Username%type,
      u_password Users.Userpassword%type,
      u_phone Users.Userphone%type,
      u_id out Users.Id%type
      );
   --4接受角色，和权限实现关联，权限的参数应该可以是都多个将p_id进行拆分
     procedure pro_role_permission(r_id number,
      p_id varchar,
      rp_o_id out number);
    
   
    --5接受用户ID查询用户所拥有的权限
    type cursor1 is ref cursor;
   procedure pro_user_permission(u_id number,o_u_p out cursor1);
   --6接受角色名 查询该角色所拥有的权限
   type cursor2 is ref cursor;
   procedure role_permission(r_name role.rolename%type,o_r_p out cursor2);
   --7完成用户的初始化
   procedure Users_role_permission_init;
   --8对权限进行分页处理，返回当前页数据
   type permission_data is ref cursor;
   function  permission_paging(page number) return permission_data;            
        
 end dbms_user_pm;
 --包主体
 create or replace package body dbms_user_pm
 as

       --1将用户和角色关联
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
          dbms_output.put_line('发生错误'||sqlerrm);
          rollback;
          
    end pro_user_role;
 
   --2接受用户 删除某个用户的功能
     procedure pro_user_role_delete(u_id number)
       is
       begin
       delete from user_role where user_role.user_id=u_id;
       Exception
        when others then
          dbms_output.put_line('发生错误'||sqlerrm);
          rollback;
       end pro_user_role_delete;
       
        --3接受用户信息，增加用户信息
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
          dbms_output.put_line('发生错误'||sqlerrm);
          rollback;
        end user_add;
        
          --4接受角色，和权限实现关联，权限的参数应该可以是都多个将p_id进行拆分
  procedure pro_role_permission(r_id number,
      p_id varchar,
      rp_o_id out number)
      is
      begin
        insert into role_permission values(1,r_id,p_id);
         select seq_role_permission.currval into rp_o_id from dual;
      Exception
        when others then
          dbms_output.put_line('发生错误'||sqlerrm);
          rollback;
        end pro_role_permission;
       
      
       --5接受用户ID查询用户所拥有的权限
   --type cursor1 is ref cursor;
   procedure pro_user_permission(u_id number,o_u_p out cursor1)
     is
     begin
       open o_u_p for
       select u.username, p.id,p.per_name,p.per_url,p.per_massger from Users u inner join user_role ur on u.id=ur.user_id 
    inner join role_permission rp on ur.role_id=rp.role_id
    inner join permission p on rp.permission_id=p.id where u.id=u_id;
       end pro_user_permission;
       
       
       --6接受角色名 查询该角色所拥有的权限
   --type cursor2 is ref cursor;
   procedure role_permission(r_name role.rolename%type,o_r_p out cursor2)
     is
     begin
       open o_r_p for
         select r.id, p.id,p.per_name,p.per_url,p.per_massger from role r
         inner join role_permission rp on r.id=rp.role_id
         inner join permission p on rp.permission_id=p.id where r.rolename=r_name;
       end role_permission;
       
         --7完成用户的初始化
   procedure Users_role_permission_init
     is
     begin
       --初始化用户
         insert into Users values(1,'admin','123','17863818241');
         insert into Users values(1,'test','123','123123');
       --初始化角色
        insert into role values(1,'超级管理员','系统boss');
       insert into role values(1,'测试员','小罗罗');
       --初始化权限
         insert into permission values(1,'增加','/admin/add','增加用户权限');
         insert into permission values(1,'更改','/admin/update','修改用户信息');
         insert into permission values(1,'删除','/admin/delete','删除用户信息');
         insert into permission values(1,'查询','/admin/select','查询用户信息');
       --给用户添加角色
     insert into user_role values(1,10001,10001);
       insert into user_role values(1,10002,10002);
       --给角色添加权限
       insert into role_permission  values(1,10002,10001);
        insert into role_permission  values(1,10001,10002);
         insert into role_permission  values(1,10001,10003);
        insert into role_permission  values(1,10001,10004);
       end Users_role_permission_init;
       
       
        --8对权限进行分页处理，返回当前页数据
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
 dbms_user_pm.user_add('小明','123','1231231200',u_id);
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
 
 
 
 
 
 
 
 
 
 
 
 
    
  
