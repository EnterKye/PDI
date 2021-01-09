<%@ WebHandler Language="C#" Class="addInServer" %>

using System;
using System.Web;
using System.Data;
using System.Collections;
using Newtonsoft.Json;
using Newtonsoft;
public class addInServer : IHttpHandler {
    SQlHelper db = new SQlHelper();
    
    public void ProcessRequest (HttpContext context) {
        string action = context.Request["action"].ToString();
        switch (action) 
        {
            case "PC":
                Pc(context);
                break;
            case "Print":
                Print(context);
                break;
            case "Scanner":
                Scanner(context);
                break;
            default:
                context.Response.StatusCode = 401;
                break;
                
        }
        
    }
    public void Pc(HttpContext context)
    {
        try
        {
            ArrayList info = new ArrayList();
            dynamic JSONOutPut = JsonConvert.DeserializeObject(context.Request["Data"]);
            info.Add(JSONOutPut["PcAssetNum"]);
            info.Add(JSONOutPut["PcSno"]);
            info.Add(JSONOutPut["Pcdepartment"]);
            info.Add(JSONOutPut["PcCpu"]);
            info.Add(JSONOutPut["PcMemory"]);
            info.Add(JSONOutPut["PcHdd"]);
            info.Add(JSONOutPut["PcMac"]);
            info.Add(JSONOutPut["PcIp"]);
            info.Add(JSONOutPut["PcLine"]);
            info.Add(JSONOutPut["PcWorks"]);
            info.Add(JSONOutPut["PcStates"]);
            //查询资产号是否存在
            string isAssetNum = "select assetNum from PcList where assetNum ='" + info[0] + "'";
            IDataReader dr = db.ExecuteReader("SqlServer", isAssetNum);
            if (dr.Read())
            {
                //数据存在,返回通知用户
                context.Response.Write("exist");
            }
            else
            {
                string sql = "insert into PcList(assetNum,assetType,sn,departmentNum,cpu,memory,hdd,mac,ip,location,works,states) values('" + info[0] + "','主机','" + info[1] + "','" + info[2] + "','" + info[3] + "','" + info[4] + "','" + info[5] + "','" + info[6] + "','" + info[7] + "','" + info[8] + "','" + info[9] + "','" + info[10] + "')";
                db.ExcuteSqlScalar("SqlServer", sql);
                context.Response.Write("0");
            }
            
        }
        catch
        {
            context.Response.Write("-1");
        }
    }

    public void Print(HttpContext context)
    {
        try
        {
            ArrayList info = new ArrayList();
            dynamic JSONOutPut = JsonConvert.DeserializeObject(context.Request["Data"]);
            info.Add(JSONOutPut["PrintAssetNum"]);//资产号
            info.Add(JSONOutPut["PrintSn"]);//序列号
            info.Add(JSONOutPut["PrintISDNum"]);//ISD编号
            info.Add(JSONOutPut["PrintTypes"]);//机器型号
            info.Add(JSONOutPut["PrintName"]);//名称
            info.Add(JSONOutPut["PrintBuyTimer"]);//购买日期
            info.Add(JSONOutPut["PrintLocation"]);//存放位置
            info.Add(JSONOutPut["PrintUser"]);//管理担当
            info.Add(JSONOutPut["PrintStates"]);//状态
            //查询资产号是否存在
            string isAssetNum = "select assetNum from PcList where assetNum ='" + info[0] + "'";
            IDataReader dr = db.ExecuteReader("SqlServer", isAssetNum);
            if (dr.Read())
            {
                //数据存在,返回通知用户
                context.Response.Write("exist");
            }
            else
            {
                string sql = "insert into PcList(assetNum,assetType,sn,departmentNum,printTypes,printNames,buyTimer,works,location,states) values('" + info[0] + "','打印机','" + info[1] + "','" + info[2] + "','" + info[3] + "','" + info[4] + "','" + info[5] + "','" + info[6] + "','" + info[7] + "','" + info[8] + "')";
                db.ExcuteSqlScalar("SqlServer", sql);
                context.Response.Write("0");
            }

        }
        catch
        {
            context.Response.Write("-1");
        }
    }

    public void Scanner(HttpContext context)
    {
        try
        {
            ArrayList info = new ArrayList();
            dynamic JSONOutPut = JsonConvert.DeserializeObject(context.Request["Data"]);
            info.Add(JSONOutPut["ScannerAssetNum"]);//资产号
            info.Add(JSONOutPut["ScannerSn"]);//序列号
            info.Add(JSONOutPut["ScannerName"]);//型号
            info.Add(JSONOutPut["ScannerADMNum"]);//ADM编号
            info.Add(JSONOutPut["ScannerBuyTimer"]);//购入日期
            info.Add(JSONOutPut["ScannerLocation"]);//存放位置
            info.Add(JSONOutPut["ScannerUser"]);//管理担当
            info.Add(JSONOutPut["ScannerStates"]);//状态
            //查询资产号是否存在
            string isAssetNum = "select assetNum from PcList where assetNum ='" + info[0] + "'";
            IDataReader dr = db.ExecuteReader("SqlServer", isAssetNum);
            if (dr.Read())
            {
                //数据存在,返回通知用户
                context.Response.Write("exist");
            }
            else
            {
                string sql = "insert into PcList(assetNum,assetType,sn,printTypes,departmentNum,buyTimer,works,location,states) values('" + info[0] + "','扫描仪','" + info[1] + "','" + info[2] + "','" + info[3] + "','" + info[4] + "','" + info[5] + "','" + info[6] + "','" + info[7] + "')";
                db.ExcuteSqlScalar("SqlServer", sql);
                context.Response.Write("0");
            }

        }
        catch
        {
            context.Response.Write("-1");
        }
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}