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
                        Scanner(context);
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
       
        //DataTable dt = NPOIOprateExcel.ExcelUtility.ExcelToDataTable(filePath, true);
             
        ArrayList listSql = new ArrayList();
        ArrayList repeatNum = new ArrayList();
        Hashtable ht = new Hashtable();
        ExcelPC parameter = new ExcelPC();
        //如果位置不在Location表中,那么取消导入
        string location = "select distinct location from location";
        ArrayList locationArray = new ArrayList();//存储地址
        IDataReader drLocation = db.ExecuteReader("SqlServer", location);
        while (drLocation.Read())
        {
            locationArray.Add(drLocation["location"].ToString());
        }
  
        
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
            parameter.states = dr["状态"].ToString();
            parameter.manageUser = dr["管理担当"].ToString();
            //如果资产号重复,则更新
            string isAssetNum = "select assetNum from PcList where assetNum ='" + dr["资产号"].ToString() + "'";
            IDataReader drd = db.ExecuteReader("SqlServer", isAssetNum);
            if (drd.Read()) 
            {
                //资产重复,保存信息回显给用户
                repeatNum.Add(dr["资产号"].ToString());        
            }
            else
            {
                bool exists = ((IList)locationArray).Contains(parameter.location);
                if (!exists)
                {
                    ht.Add("Non-compliant", parameter.assetNum);
                }
                else
                {
                    listSql.Add("insert into PcList(assetNum,assetType,sn,departmentNum,cpu,memory,hdd,mac,ip,location,works,states,ManagementUser) values('" + parameter.assetNum + "','主机','" + parameter.sn + "','" + parameter.departmentNum + "','" + parameter.cpu + "','" + parameter.memory + "','" + parameter.hdd + "','" + parameter.mac + "','" + parameter.ip + "','" + parameter.location + "','" + parameter.works + "','" + parameter.states + "','" + parameter.manageUser + "')");
                    parameter.count += 1;
                }
            }
           
            
           
           
            
        }
        Boolean result = db.ExcuteSqlTran("SqlServer", listSql);

        if (!result) //false
        {
            context.Response.Write(JsonConvert.SerializeObject("-1"));
        }
        else
        {
            //实际上传数量+重复数据
            ht.Add("repeat",repeatNum);
            ht.Add("reality", parameter.count);
            
            context.Response.Write(JsonConvert.SerializeObject(ht));
            
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
        ArrayList repeatNum = new ArrayList();
        Hashtable ht = new Hashtable();
        ExcelPrint print=new ExcelPrint();
        foreach (DataRow dr in dt.Rows)
        {
            print.assetNum = dr["资产号"].ToString();
            print.sn = dr["序列号"].ToString();
            print.ISDNum = dr["ISD编号"].ToString();
            print.Types = dr["机器型号"].ToString();
            print.Name = dr["名称"].ToString();
            print.Timer = dr["购买日期"].ToString() == "" ? new Nullable<DateTime>() : DateTime.ParseExact(dr["购买日期"].ToString(), "yyyyMMdd", System.Globalization.CultureInfo.CurrentUICulture);
            print.location = dr["存放位置"].ToString();
            print.User = dr["管理担当"].ToString();
            print.states = dr["状态"].ToString();

            string isAssetNum = "select assetNum from PcList where assetNum ='" + dr["资产号"].ToString() + "'";
            IDataReader drd = db.ExecuteReader("SqlServer", isAssetNum);
            if (drd.Read())
            {
                //资产重复,保存信息回显给用户
                repeatNum.Add(dr["资产号"].ToString());
            }
            else
            {

                //bool exists = ((IList)locationArray).Contains(parameter.location);
                //if (!exists)
                //{
                //    ht.Add("Non-compliant", parameter.assetNum);
                //}
                listSql.Add("insert into PcList(assetNum,assetType,sn,departmentNum,printTypes,printNames,buyTimer,works,ManagementUser,states) values('" + print.assetNum + "','打印机','" + print.sn + "','" + print.ISDNum + "','" + print.Types + "','" + print.Name + "','" + print.Timer + "','" + print.location + "','" + print.User + "','" + print.states + "')");
                print.count += 1;
            }
            
        }
        Boolean result = db.ExcuteSqlTran("SqlServer", listSql);

        if (!result) //false
        {
            context.Response.Write(JsonConvert.SerializeObject("-1"));
        }
        else
        {
            ht.Add("repeat", repeatNum);
            ht.Add("reality", print.count);
            context.Response.Write(JsonConvert.SerializeObject(ht));
        }
    }

    /// <summary>
    /// 扫描仪
    /// </summary>
    /// <param name="context"></param>
    private void Scanner(HttpContext context)
    {
        DataTable dt = NPOIHelper.ExcelToTable(filePath);
        ArrayList listSql = new ArrayList();
        ArrayList repeatNum = new ArrayList();
        Hashtable ht = new Hashtable();
        ExcelScanner scanner = new ExcelScanner();
        foreach (DataRow dr in dt.Rows)
        {
            scanner.AssetNum = dr["资产号"].ToString();
            scanner.Sn = dr["序列号"].ToString();
            scanner.Types = dr["型号"].ToString();
            scanner.Adm= dr["ADM编号"].ToString();
            scanner.BuyTimer = dr["购入日期"].ToString() == "" ? new Nullable<DateTime>() : DateTime.ParseExact(dr["购入日期"].ToString(), "yyyyMMdd", System.Globalization.CultureInfo.CurrentUICulture);
            scanner.Location = dr["存放位置"].ToString();
            scanner.User = dr["管理担当"].ToString();
            scanner.States = dr["状态"].ToString();

            string isAssetNum = "select assetNum from PcList where assetNum ='" + dr["资产号"].ToString() + "'";
            IDataReader drd = db.ExecuteReader("SqlServer", isAssetNum);
            if (drd.Read())
            {
                //资产重复,保存信息回显给用户
                repeatNum.Add(dr["资产号"].ToString());
            }
            else
            {
                listSql.Add("insert into PcList(assetNum,assetType,sn,printTypes,departmentNum,buyTimer,works,location,states) values('" + scanner.AssetNum + "','扫描仪','" + scanner.Sn + "','" + scanner.Types + "','" + scanner.Adm + "','" + scanner.BuyTimer + "','" + scanner.Location + "','" + scanner.User + "','" + scanner.States + "')");
                scanner.count += 1;
            }

        }
        Boolean result = db.ExcuteSqlTran("SqlServer", listSql);

        if (!result) //false
        {
            context.Response.Write(JsonConvert.SerializeObject("-1"));
        }
        else
        {
            ht.Add("repeat", repeatNum);
            ht.Add("reality", scanner.count);
            context.Response.Write(JsonConvert.SerializeObject(ht));
        }
    }
    public bool IsReusable {
        get {
            return false;
        }
    }

}