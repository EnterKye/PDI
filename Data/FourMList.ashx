<%@ WebHandler Language="C#" Class="FourMList" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
public class FourMList : IHttpHandler {
    SQlHelper db = new SQlHelper();
    FourM fm = new FourM();
    int i;
    public void ProcessRequest (HttpContext context) {
        string action = context.Request["action"].ToString();
        fm.PageSize = int.Parse(context.Request.QueryString["limit"]);
        fm.PageNumber= int.Parse(context.Request.QueryString["page"]);
        fm.assetNumKey = context.Request.QueryString["key[selectAssetNum]"];
        fm.dateKey = context.Request.QueryString["key[selectDate]"];
        switch (action)
        { 
            case "FourM":
                FourM(context);
                break;
            default:
                context.Response.StatusCode = 401;
                break;
        }
    }
    /// <summary>
    /// 4M表格记录
    /// </summary>
    /// <param name="context"></param>
    public void FourM(HttpContext context)
    {      
        try
        {
            if ((fm.assetNumKey == null || fm.assetNumKey.Trim() == "") && (fm.dateKey == null || fm.dateKey.Trim() == ""))
            {
                fm.str = JsonConvert.SerializeObject(SqlJson(fm.PageNumber, fm.PageSize, out i));
                fm.str = "{\"code\":0,\"msg\":\"\",\"count\":" + fm.i + ",\"data\":" + fm.str + "}";
                context.Response.Write(fm.str);
            }
            else
            { 
                
            }
        }
        catch
        { 
            
        }
    }

    public DataTable SqlJson(int PageNumber, int PageSize, out int i)
    {
        int pages;
        pages = PageSize * (PageNumber - 1);
        string sql = "select tb_b.assetNum,assettype,moveUser,movelocation,moveWorks,moveTimes,tb_b.states from(" + "select *,row_number() over(order by id desc)num" + " from PcList as tb_a) as tb_b" + " inner join FourMList b on tb_b.assetNum=b.assetNum where num between " + ((PageNumber - 1) * PageSize + 1) + " and " + (PageNumber) * PageSize + " ";
        DataTable ds = db.ExcuteQuery("SqlServer", sql);
        string count = "select count(*) '数量' from PcList";
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