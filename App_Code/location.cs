using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Collections;
using System.Data;
/// <summary>
/// location 的摘要说明
/// </summary>
public class location
{
    SQlHelper db=new SQlHelper();
    public ArrayList GetLocation() 
    {
        string location = "select distinct location from location";
        ArrayList locationArray = new ArrayList();//存储地址
        IDataReader drLocation = db.ExecuteReader("SqlServer", location);
        while (drLocation.Read())
        {
            locationArray.Add(drLocation["location"].ToString());
        }
        return locationArray;
    }
}