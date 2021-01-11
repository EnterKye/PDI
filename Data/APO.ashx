<%@ WebHandler Language="C#" Class="APO" %>

using System;
using System.Web;
using System.Web.SessionState;
public class APO : IHttpHandler,IRequiresSessionState {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "text/plain";
        string domain = HttpContext.Current.User.Identity.Name;
        string[] info = domain.Split('\\');
        string apo = string.Empty;
        string defautUser = "测试用户";
        if (info.Length > 1) 
        {
            apo = info[1];
            defautUser = apo;    
        }
        context.Response.Write(defautUser);
        context.Session["apo"] = defautUser;
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}