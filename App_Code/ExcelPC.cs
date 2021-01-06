using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Excel 的摘要说明
/// </summary>
public class ExcelPC
{
    public string id { get; set; }
    /// <summary>
    /// 资产号
    /// </summary>
    public string assetNum { get; set; }
    /// <summary>
    /// 序列号
    /// </summary>
    public string sn { get; set; }
    //部门管理编号
    public string departmentNum { get; set; }
    /// <summary>
    /// 处理器
    /// </summary>
    public string cpu { get; set; }
    /// <summary>
    /// 内存
    /// </summary>
    public string memory { get; set; }
    /// <summary>
    /// 硬盘
    /// </summary>
    public string hdd { get; set; }
    /// <summary>
    /// 物理地址
    /// </summary>
    public string mac { get; set; }
    /// <summary>
    /// ip
    /// </summary>
    public string ip { get; set; }
    /// <summary>
    /// 位置
    /// </summary>
    public string location { get; set; }
    /// <summary>
    /// 工位
    /// </summary>
    public string works { get; set; }
    /// <summary>
    /// 导入数据
    /// </summary>
    public int count { get; set; }
}