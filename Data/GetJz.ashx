<%@ WebHandler Language="C#" Class="GetJz" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using System.Web.SessionState;
using System.Collections;
public class GetJz : IHttpHandler,IRequiresSessionState {
    SQlHelper db = new SQlHelper();
    public void ProcessRequest (HttpContext context) {
        try
        {
            //if (context.Session["apo"].ToString() == null)
            //{
            //    context.Response.StatusCode = 401;
            //}
            //else
            //{
                string sql = "select distinct location,count(location)'num' from pclist group by location";
                string depart = "select distinct a.location ,b.department from PcList a inner join Location b on a.location=b.location"; 
                DataTable dt = db.ExcuteQuery("SqlServer", sql);
                DataTable dts = db.ExcuteQuery("SqlServer", depart);
                Hashtable ht = new Hashtable();
                ArrayList al = new ArrayList();
                ArrayList department = new ArrayList();
                if (dt.Rows.Count != 0)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        foreach (DataRow drs in dts.Rows)
                        { 
                            //区分部门
                            if (dr["location"].ToString() == drs["location"].ToString())
                            {
                                //DataRow对比
                                al.Add(new title { Jz = dr["location"].ToString().ToUpper(), department = drs["department"].ToString().ToUpper(), Num = dr["Num"].ToString() });
                            }
                            
                        }
                    }
                    context.Response.Write(JsonConvert.SerializeObject(al));
                }
                else
                {
                    ht.Add("error", "none");
                    context.Response.Write(JsonConvert.SerializeObject(ht));
                }
                
            //}
        }
        catch
        {
            context.Response.StatusCode = 401;
        }
    }
    private class title
    { 
        /// <summary>
        /// 机种
        /// </summary>
        public string Jz { get; set; }
        /// <summary>
        /// 数量
        /// </summary>
        public string Num { get; set; }
        /// <summary>
        /// 部门
        /// </summary>
        public string department { get; set; }
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}