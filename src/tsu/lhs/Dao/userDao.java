package tsu.lhs.Dao;

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
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

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
	

}
