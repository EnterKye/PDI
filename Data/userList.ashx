<%@ WebHandler Language="C#" Class="userList" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using System.Collections;
public class userList : IHttpHandler {
    SQlHelper db = new SQlHelper();
    public void ProcessRequest (HttpContext context) {
        try
        {
            int i;
            int pageSize = int.Parse(context.Request.QueryString["limit"]);
            int pageNumber = int.Parse(context.Request.QueryString["page"]);
            string str = JsonConvert.SerializeObject(SqlJson(pageNumber, pageSize, out i));
            str = "{\"code\":0,\"msg\":\"\",\"count\":" + i + ",\"data\":" + str + "}";
            context.Response.Write(str);
        }
        catch
        {
            context.Response.StatusCode = 401;
        }
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="PageNumber"></param>
    /// <param name="PageSize"></param>
    /// <param name="i"></param>
    /// <returns></returns>
    public DataTable SqlJson(int PageNumber, int PageSize, out int i)
    {
        int pages = PageSize * (PageNumber - 1);
        string sql = "select id,apo,name,email,permission,createTime from (" + "select *,row_number() over(order by id) num " + "from UserInfo as tb_a) as tb_b" + " where num between " + ((PageNumber - 1) * PageSize + 1) + " and " + (PageNumber) * PageSize + " ";
        DataTable ds = db.ExcuteQuery("SqlServer", sql);
        string count = "select count(*) '数量' from UserInfo";
        DataTable dt = db.ExcuteQuery("SqlServer", count);
        i = Convert.ToInt32(dt.Rows[0]["数量"].ToString());
        return ds;
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}