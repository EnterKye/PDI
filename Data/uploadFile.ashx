<%@ WebHandler Language="C#" Class="uploadFile" %>

using System;
using System.Web;
using Newtonsoft.Json;
using System.IO;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using System.Web.SessionState;
public class uploadFile : IHttpHandler, IRequiresSessionState
{
    SQlHelper db = new SQlHelper();

    string filePath = string.Empty;
    location li = new location();
    ArrayList locationArray = new ArrayList();
    public void ProcessRequest(HttpContext context)
    {
        try
        {
            if (context.Session["apo"].ToString() == null)
            {
                context.Response.StatusCode = 401;
            }
            else
            {
                locationArray = li.GetLocation();
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
        }
        catch
        {

        }
    }
    /// <summary>
    /// 返回值
    /// </summary>
    public class ContextResPC
    {
        /// <summary>
        /// 类型
        /// </summary>
        public string types { get; set; }
        /// <summary>
        /// 导入数
        /// </summary>
        public string count { get; set; }
        /// <summary>
        /// 重复项
        /// </summary>
        public string repeat { get; set; }
        /// <summary>
        /// 地址项
        /// </summary>
        public string address { get; set; }
    }


    /// <summary>
    /// 主机上传
    /// </summary>
    /// <param name="context"></param> 
    private void PC(HttpContext context)
    {
        DataTable dt = NPOIHelper.ExcelToTable(filePath);  
        ArrayList listSql = new ArrayList();
        ArrayList repeatNum = new ArrayList();
        ExcelPC parameter = new ExcelPC();
        List<ContextResPC> list = new List<ContextResPC>();
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
            string isAssetNum = "select assetNum from PcList where assetNum ='" + dr["资产号"].ToString() + "'";
            IDataReader drd = db.ExecuteReader("SqlServer", isAssetNum);
            if (drd.Read()) 
            {
                //资产重复,保存信息回显给用户
                repeatNum.Add(dr["资产号"].ToString());      
            }
            else
            {
                bool exists = ((IList)locationArray).Contains(parameter.location.ToUpper());
                if (!exists)
                {
                    list.Add(new ContextResPC { types = "address", address = parameter.assetNum });
                }
                else
                {
                    listSql.Add("insert into FourMList values('" + parameter.assetNum + "','" + context.Session["apo"].ToString() + "','" + parameter.location + "','" + parameter.works + "',GetDate(),'')");
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
            string str= string.Join(",", (string[])repeatNum.ToArray(typeof( string)));
            list.Add(new ContextResPC { types = "导入数", count = parameter.count.ToString() });
            list.Add(new ContextResPC { types = "重复项", repeat = str });           
            context.Response.Write(JsonConvert.SerializeObject(list));            
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
        ExcelPrint print = new ExcelPrint();
        List<ContextResPC> list = new List<ContextResPC>();
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

                bool exists = ((IList)locationArray).Contains(print.location.ToUpper());
                if (!exists)
                {
                    list.Add(new ContextResPC { types = "address", address = print.assetNum });
                }
                else
                {
                    listSql.Add("insert into FourMList(assetNum,moveUser,moveLocation,moveTimes) values('" + print.assetNum + "','" + context.Session["apo"].ToString() + "','" + print.location + "',GetDate())");
                    listSql.Add("insert into PcList(assetNum,assetType,sn,departmentNum,printTypes,printNames,buyTimer,location,ManagementUser,states) values('" + print.assetNum + "','打印机','" + print.sn + "','" + print.ISDNum + "','" + print.Types + "','" + print.Name + "','" + print.Timer + "','" + print.location + "','" + print.User + "','" + print.states + "')");
                    print.count += 1;
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
            string str = string.Join(",", (string[])repeatNum.ToArray(typeof(string)));
            list.Add(new ContextResPC { types = "导入数", count = print.count.ToString() });
            list.Add(new ContextResPC { types = "重复项", repeat = str });
            context.Response.Write(JsonConvert.SerializeObject(list));
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
        List<ContextResPC> list = new List<ContextResPC>();
        ExcelScanner scanner = new ExcelScanner();
        foreach (DataRow dr in dt.Rows)
        {
            scanner.AssetNum = dr["资产号"].ToString();
            scanner.Sn = dr["序列号"].ToString();
            scanner.Types = dr["型号"].ToString();
            scanner.Adm = dr["ADM编号"].ToString();
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
                bool exists = ((IList)locationArray).Contains(scanner.Location.ToUpper());
                if (!exists)
                {
                    list.Add(new ContextResPC { types = "address", address = scanner.AssetNum });
                }
                else
                {
                    listSql.Add("insert into FourMList(assetNum,moveUser,moveLocation,moveTimes) values('" + scanner.AssetNum + "','" + context.Session["apo"].ToString() + "','" + scanner.Location + "',GetDate())");
                    listSql.Add("insert into PcList(assetNum,assetType,sn,printTypes,departmentNum,buyTimer,location,ManagementUser,states) values('" + scanner.AssetNum + "','扫描仪','" + scanner.Sn + "','" + scanner.Types + "','" + scanner.Adm + "','" + scanner.BuyTimer + "','" + scanner.Location + "','" + scanner.User + "','" + scanner.States + "')");
                    scanner.count += 1;
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
            string str = string.Join(",", (string[])repeatNum.ToArray(typeof(string)));
            list.Add(new ContextResPC { types = "导入数", count = scanner.count.ToString() });
            list.Add(new ContextResPC { types = "重复项", repeat = str });
            context.Response.Write(JsonConvert.SerializeObject(list));
        }
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}