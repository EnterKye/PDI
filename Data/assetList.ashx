<%@ WebHandler Language="C#" Class="assetList" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using System.Collections;

public class assetList : IHttpHandler {
    SQlHelper db = new SQlHelper();
    string id=string.Empty;
    public void ProcessRequest (HttpContext context) {
        try
        {
            int i;
            int pageSize = int.Parse(context.Request.QueryString["limit"]);
            int pageNumber = int.Parse(context.Request.QueryString["page"]);
            id = context.Request.QueryString["id"];
            string str = JsonConvert.SerializeObject(SqlJson(pageNumber, pageSize, out i));
            str = "{\"code\":0,\"msg\":\"\",\"count\":" + i + ",\"data\":" + str + "}";
            context.Response.Write(str);
        }
        catch
        {
            context.Response.StatusCode = 401;
        }
        
    }

    public DataTable SqlJson(int PageNumber, int PageSize, out int i)
    {
        int pages = PageSize * (PageNumber - 1);
        string sql = "select assetNum,assettype,sn,departmentNum,cpu,memory,hdd,mac,ip,works,managementUser from (" + "select *,row_number() over(order by id) num " + "from PcList as tb_a where location='"+id+"') as tb_b" + " where num between " + ((PageNumber - 1) * PageSize + 1) + " and " + (PageNumber) * PageSize + " ";
        DataTable ds = db.ExcuteQuery("SqlServer", sql);
        string count = "select count(*) '数量' from PcList where location='" + id + "'";
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