<%@ WebHandler Language="C#" Class="uploadFile" %>

using System;
using System.Web;
using Newtonsoft.Json;
using System.IO;
using System.Data;
using System.Collections;
public class uploadFile : IHttpHandler {
    SQlHelper db = new SQlHelper();
    
    string filePath = string.Empty;
    public void ProcessRequest (HttpContext context) 
    {

        if (HttpContext.Current.Request.Files.Count > 0)
        {
            try
            {
                HttpPostedFile file = HttpContext.Current.Request.Files[0];
                string fileName = Path.GetFileName(file.FileName);//文件名

                switch (fileName)
                {
                    case "主机.xlsx":
                        filePath = HttpContext.Current.Server.MapPath("../Files/") + fileName;
                        file.SaveAs(filePath);
                        PC(context);
                        break;
                    case "打印机.xlsx":
                        filePath = HttpContext.Current.Server.MapPath("../Files/") + fileName;
                        file.SaveAs(filePath);
                        Print(context);
                        break;
                    case "扫描仪.xlsx":
                        filePath = HttpContext.Current.Server.MapPath("../Files/") + fileName;
                        file.SaveAs(filePath);
                        break;
                    default:
                        break;
                }

            }
            catch (Exception ex)
            {
                context.Response.Write(ex.Message);
            }
        }
        else 
        {
            context.Response.Write("-1");
        }
    }
    /// <summary>
    /// 主机上传
    /// </summary>
    /// <param name="context"></param> 
    private void PC(HttpContext context)
    {
        DataTable dt = NPOIHelper.ExcelToTable(filePath);
        ArrayList listSql = new ArrayList();
        ExcelPC parameter = new ExcelPC();
        foreach (DataRow dr in dt.Rows)
        {
            parameter.assetNum = dr["资产号"].ToString();
            parameter.sn = dr["序列号"].ToString();
            parameter.departmentNum = dr["部门管理编号"].ToString();
            parameter.cpu = dr["处理器"].ToString();
            parameter.memory = dr["内存"].ToString();
            parameter.hdd = dr["硬盘"].ToString();
            parameter.mac = dr["物理地址"].ToString();
            parameter.ip = dr["IP地址"].ToString();
            parameter.location = dr["位置/硬件拉"].ToString();
            parameter.works = dr["工位"].ToString();           
            listSql.Add("insert into PcList(assetNum,assetType,sn,departmentNum,cpu,memory,hdd,mac,ip,location,works) values('" + parameter.assetNum + "','主机','" + parameter.sn + "','" + parameter.departmentNum + "','" + parameter.cpu + "','" + parameter.memory + "','" + parameter.hdd + "','" + parameter.mac + "','" + parameter.ip + "','" + parameter.location + "','" + parameter.works + "')");
            parameter.count += 1;
        }
        Boolean result = db.ExcuteSqlTran("SqlServer", listSql);

        if (!result) //false
        {
            context.Response.Write(JsonConvert.SerializeObject("-1"));
        }
        else
        {
            context.Response.Write(JsonConvert.SerializeObject(parameter.count));
        }
    }

    /// <summary>
    /// 打印机
    /// </summary>
    /// <param name="context"></param>
    private void Print(HttpContext context)
    {
        DataTable dt = NPOIHelper.ExcelToTable(filePath);
        ArrayList listSql = new ArrayList();
        ExcelPrint print=new ExcelPrint();
        foreach (DataRow dr in dt.Rows)
        {
            print.assetNum = dr["资产号"].ToString();
            print.sn = dr["序列号"].ToString();
            print.ISDNum = dr["ISD编号"].ToString();
            print.Types = dr["机器型号"].ToString();
            print.Name = dr["名称"].ToString();
            print.Timer = Convert.ToDateTime(dr["购买日期"].ToString());
            print.location = dr["存放位置"].ToString();
            print.User = dr["管理担当"].ToString();
            print.states = dr["状态"].ToString();
            listSql.Add("insert into PcList(assetNum,assetType,sn,departmentNum,printTypes,printNames,buyTimer,works,location,states) values('" + print.assetNum + "','打印机','" + print.sn + "','" + print.ISDNum + "','" + print.Types + "','" + print.Name + "','" + print.Timer + "','" + print.location + "','" + print.User + "','" + print.states + "')");
            print.count += 1;
        }
        Boolean result = db.ExcuteSqlTran("SqlServer", listSql);

        if (!result) //false
        {
            context.Response.Write(JsonConvert.SerializeObject("-1"));
        }
        else
        {
            context.Response.Write(JsonConvert.SerializeObject(print.count));
        }
    }

    public bool IsReusable {
        get {
            return false;
        }
    }

}