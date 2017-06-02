package tsu.lhs.test;

import java.sql.SQLException;

import tsu.lhs.Dao.userDao;

public class Test {

	public static void main(String[] args) throws SQLException {
     userDao user=new userDao();
     user.selectuser();
 //  user.installuser();
     user.updatauser();
	}

}
