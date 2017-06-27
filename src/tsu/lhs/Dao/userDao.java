package tsu.lhs.Dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


import tsu.lhs.util.JdbcConnection;

public class userDao {
    //查询
	public void selectuser(){
		String sql="select * from emp";
		Connection conn=JdbcConnection.getcon();
		Statement stm;
		try {
			stm = conn.createStatement();
			ResultSet rest=null;
			rest=stm.executeQuery(sql);
			while(rest.next()!=false){
			    System.out.println(rest.getString(1));
			    System.out.println("haha");
			}
			JdbcConnection.close(conn,stm);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
	
	
	
	
	//程序包插入
	public void insertuser() throws SQLException{
		Connection conn=JdbcConnection.getcon();
		CallableStatement cstmts=conn.prepareCall("call  pkg_user.sp_insertuser(?,?,?,?,?,?,?)");
		cstmts.setString(1, "sp95279527");
		cstmts.setString(2,"紫萝");
		cstmts.setInt(3, 0);
		cstmts.setNull(4,oracle.jdbc.OracleTypes.DATE);
		cstmts.setInt(5, 1);
		cstmts.setInt(6, 1);
		cstmts.registerOutParameter(7,oracle.jdbc.OracleTypes.INTEGER);
		cstmts.execute();
		System.out.println(cstmts.getInt(7));
	   
	
		 
	}
	//插入
	
	
	public void installuser() throws SQLException{
		String sql="insert into emp(empno,ename,deptno) values(?,?,?)";
	   Connection conn=JdbcConnection.getcon();
	   PreparedStatement pstmt=conn.prepareStatement(sql);
	   pstmt.setInt(1, 7233);
	   pstmt.setString(2, "haha");
	   pstmt.setInt(3, 10);
	   if(pstmt.executeUpdate()==1){
		   System.out.println(" 插入成功");
	   }
	   
	   
	   
		
	}
	//修改
	public void updatauser() throws SQLException{
	String sql="update emp set sal=1200 where empno=7233";
	Connection conn=JdbcConnection.getcon();
	Statement stmt=conn.createStatement();
	if(stmt.executeUpdate(sql)==1){
	System.out.println("修改成成功");
		
	}
	
	}
	//游标获取
	public void cursorselect() throws SQLException{
		String sql="{call pag_find.t_user_find(?,?,?)}";
		Connection  conn=JdbcConnection.getcon();
		 CallableStatement cste=conn.prepareCall(sql);
		 cste.setInt(1,10004);
		cste.setString(2, "青菜");
		 cste.registerOutParameter(3,  oracle.jdbc.OracleTypes.CURSOR);
	     cste.execute();
	     ResultSet rs=(ResultSet) cste.getObject(3);
	     while(rs.next()){
	    	 System.out.println(rs.getInt(1)+""+rs.getString(2));
	     }
	}
	
	

}
