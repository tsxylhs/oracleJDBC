package tsu.lhs.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class JdbcConnection { 
	 static {
 try {
	Class.forName("oracle.jdbc.OracleDriver");
} catch (ClassNotFoundException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}
	}
	 public static Connection getcon(){
		 String url="jdbc:oracle:thin:@127.0.0.1:1521/ORCL";
		 Connection conn = null;
		  try {
			conn=DriverManager.getConnection(url, "scott", "123321");
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 return conn;
		 
	 }
	
	
}
