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
                DataTable dt = db.ExcuteQuery("SqlServer", sql);
                Hashtable ht = new Hashtable();
                ArrayList al = new ArrayList();
                
                if (dt.Rows.Count != 0)
                {
                    foreach (DataRow dr in dt.Rows)
                    {
                        //al.Add(dr["location"].ToString());
                        //ht.Add(dr["location"].ToString(), dr["num"].ToString());
                        al.Add(new title { Jz = dr["location"].ToString(), Num = dr["Num"].ToString() });
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
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}