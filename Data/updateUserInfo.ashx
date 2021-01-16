<%@ WebHandler Language="C#" Class="updateUserInfo" %>

using System;
using System.Web;
using System.Data;
public class updateUserInfo : IHttpHandler {
    SQlHelper db = new SQlHelper();
    public void ProcessRequest (HttpContext context) {
        string name = context.Request["names"];
        string email = context.Request["emails"];
        string permission = context.Request["permissions"];
        string id=context.Request["id"];
        string sql = "update userInfo set name='" + name + "',email='" + email + "',permission='" + permission + "' where id='" + id + "'";
        db.ExcuteSqlScalar("SqlServer", sql);
        context.Response.Write("0");
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}