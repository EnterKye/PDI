<%@ WebHandler Language="C#" Class="GetLocation" %>

using System;
using System.Web;
using Newtonsoft.Json;
using System.Data;
using System.Collections;
public class GetLocation : IHttpHandler {
    SQlHelper db = new SQlHelper();
    public void ProcessRequest (HttpContext context) {
        IDataReader dr = db.ExecuteReader("SqlServer", "select distinct location from Location");
        ArrayList location = new ArrayList();
        
        while (dr.Read())
        {
            location.Add(dr["location"].ToString());
        }
        context.Response.Write(JsonConvert.SerializeObject(location));
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}