<%@ WebHandler Language="C#" Class="FourMList" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using System.Collections;
using System.Web.SessionState;
public class FourMList : IHttpHandler,IRequiresSessionState {
    SQlHelper db = new SQlHelper();
    FourM fm = new FourM();
    int i;
    public void ProcessRequest (HttpContext context) {
        try
        {
            if (context.Session["apo"].ToString() == null)
            {
                context.Response.StatusCode = 401;
            }
            else
            { 
                string action = context.Request["action"].ToString();
                if (action == "FourM")
                {
                    fm.PageSize = int.Parse(context.Request.QueryString["limit"]);
                    fm.PageNumber = int.Parse(context.Request.QueryString["page"]);
                    fm.assetNumKey = context.Request.QueryString["key[assetNum]"];
                    fm.dateKey = context.Request.QueryString["key[writeTime]"];
                }

                switch (action)
                {
                    case "FourM":
                        FourM(context);
                        break;
                    case "saveFM":
                        SaveFM(context);
                        break;
                    default:
                        context.Response.StatusCode = 401;
                        break;
                }
            }
        }
        catch 
        {
            context.Response.StatusCode = 401;
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
                fm.str = "{\"code\":0,\"msg\":\"\",\"count\":" + i + ",\"data\":" + fm.str + "}";
                context.Response.Write(fm.str);
            }
            else
            {
                fm.str = JsonConvert.SerializeObject(SqlJsonII(fm.PageNumber, fm.PageSize, out i, fm.assetNumKey, fm.dateKey));
                fm.str = "{\"code\":0,\"msg\":\"\",\"count\":" + i + ",\"data\":" + fm.str + "}";
                context.Response.Write(fm.str);
            }
        }
        catch
        { 
            
        }
    }
    /// <summary>
    /// 保存4M变动记录
    /// </summary>
    /// <param name="context"></param>
    private void SaveFM(HttpContext context)
    {
        try
        {
            ArrayList info = new ArrayList();
            dynamic JSONInfo = JsonConvert.DeserializeObject(context.Request["Data"]);
            foreach (string item in JSONInfo)
            {
                info.Add(item.ToString());
            }
            string isAssetNum = "select assetNum from PcList where assetNum ='" + info[0] + "'";
            IDataReader dr = db.ExecuteReader("SqlServer", isAssetNum);
            Hashtable ht = new Hashtable();    
            if (dr.Read())
            {
                         
                //string isSql = string.Empty;
                //for (int i = 0; i <= info.Count; i++)
                //{
                //    isSql += info[i] + ",";
                //}
                string Inssql = "insert into FourMList values('" + info[0] + "','" + context.Session["apo"].ToString() + "','" + info[1] + "','" + info[2] + "',GetDate(),'" + info[4] + "')";
                string Upsql = "update PcList set location='" + info[1] + "',works='" + info[2] + "',states='" + info[3] + "' where assetNum='" + info[0] + "'";
                db.ExcuteSqlScalar("SqlServer", Inssql);
                db.ExcuteSqlScalar("SqlServer", Upsql);
                ht.Add("Result", 0);
                context.Response.Write(JsonConvert.SerializeObject(ht));
            }
            else
            {
                ht.Add("Result", "NoExist");
                //通知用户主表无信息
                context.Response.Write(JsonConvert.SerializeObject(ht));
            }
        }
        catch
        { 
            
        }
   
    }
    /// <summary>
    /// 表格数据加载
    /// </summary>
    /// <param name="PageNumber"></param>
    /// <param name="PageSize"></param>
    /// <param name="i"></param>
    /// <returns></returns>
    public DataTable SqlJson(int PageNumber, int PageSize, out int i)
    {
        int pages;
        pages = PageSize * (PageNumber - 1);
        string sql = "select tb_b.assetNum,assettype,moveUser,movelocation,moveWorks,moveTimes,tb_b.states from(" + "select *,row_number() over(order by id desc)num" + " from PcList as tb_a) as tb_b" + " inner join FourMList b on tb_b.assetNum=b.assetNum where num between " + ((PageNumber - 1) * PageSize + 1) + " and " + (PageNumber) * PageSize + " order by moveTimes desc";
        DataTable ds = db.ExcuteQuery("SqlServer", sql);
        string count = "select count(*) '数量' from FourMList";
        DataTable dt = db.ExcuteQuery("SqlServer", count);
        i = Convert.ToInt32(dt.Rows[0]["数量"].ToString());
        return ds;
    }

    /// <summary>
    /// 参数化查询重载表格
    /// </summary>
    /// <param name="PageNumber"></param>
    /// <param name="PageSize"></param>
    /// <param name="i"></param>
    /// <param name="selectAssetNum"></param>
    /// <param name="WriteTime"></param>
    /// <returns></returns>
    public DataTable SqlJsonII(int PageNumber, int PageSize, out int i, string selectAssetNum, string WriteTime) 
    {
        string SqlWhere = "";
        if (selectAssetNum != "") 
        {
            SqlWhere = " b.assetNum ='" + selectAssetNum + "'";
        }
        if (WriteTime != "") 
        {
            if (SqlWhere == "")
            {
                SqlWhere = " Convert(varchar(10),moveTimes,120)='" + WriteTime + "'";
            }
            else
            {
                SqlWhere += " and Convert(varchar(10),moveTimes,120)='" + WriteTime + "'";
            }
        }
        int pages;
        pages = PageSize * (PageNumber - 1);
        string sql = string.Empty;
        if (SqlWhere == "")
        {
            sql = "select tb_b.assetNum,assettype,moveUser,movelocation,moveWorks,moveTimes,tb_b.states from(" + "select *,row_number() over(order by id desc)num" + " from PcList as tb_a) as tb_b" + " inner join FourMList b on tb_b.assetNum=b.assetNum where " + SqlWhere + " num between " + ((PageNumber - 1) * PageSize + 1) + " and " + (PageNumber) * PageSize + " order by moveTimes desc";
        }
        else
        {
            sql = "select tb_b.assetNum,assettype,moveUser,movelocation,moveWorks,moveTimes,tb_b.states from(" + "select *,row_number() over(order by id desc)num" + " from PcList as tb_a) as tb_b" + " inner join FourMList b on tb_b.assetNum=b.assetNum where " + SqlWhere + " order by moveTimes desc";
        }
        DataTable ds = db.ExcuteQuery("SqlServer", sql);
        string count = string.Empty;
        if (SqlWhere == "")
        {
            count = "select count(*) '数量' from FourMList";
        }
        else
        {
            count = "select count(*) '数量' from FourMList b where " + SqlWhere + "";
        }
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