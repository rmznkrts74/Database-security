package databaseapp;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DatabaseConnector {
   private Connection conn;
   private final String url = "jdbc:mysql://127.0.0.1:3306/links?useSSL=false&useUnicode=true&characterEncoding=UTF-8&serverTimezone=Europe/Istanbul";
   private final String driver = "com.mysql.cj.jdbc.Driver";
   private final String userName = "root";
   private final String password = "root";
   
    public List<Link> listLink(String links){
        List<Link> linkList=new ArrayList<>();
      try {
         Class.forName(driver).newInstance();
         conn = DriverManager.getConnection(url,userName,password);
         System.out.println("Connected to the database");
      } catch (ClassNotFoundException | IllegalAccessException | InstantiationException | SQLException e) {
         e.printStackTrace();
      }
       return linkList;
   }

   public boolean checkLink(String link) {
      try {
         Class.forName(driver).newInstance();
         conn = DriverManager.getConnection(url,userName,password);
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery("SELECT * FROM linkler WHERE link='" + link + "'");
         if (rs.next()) {
            String url = rs.getString("link");
            if (url.startsWith("http://")) {
               System.out.println("This link is can be safe but it doesn't have security Certificate.");
               return false;
            } else {
               System.out.println("This link is dangerous!");
               return true;
            }
         } else {
            System.out.println("This link probably safe but be careful ;)");
         }
         conn.close();
      } catch (ClassNotFoundException | IllegalAccessException | InstantiationException | SQLException e) {
         e.printStackTrace();
      }
      return false;
   }

   public void addLink(String link) {
       System.out.println(link);
      try {
         Class.forName(driver).newInstance();
         conn = DriverManager.getConnection(url,userName,password);
         Statement stmt = conn.createStatement();
         
         int rs = stmt.executeUpdate("INSERT INTO linkler (link) VALUES ('" + link + "')");
         System.out.println(link);
         System.out.println("Link added to the database");
         conn.close();
      } catch (ClassNotFoundException | IllegalAccessException | InstantiationException | SQLException e) {
         e.printStackTrace();
      }
   }
}
