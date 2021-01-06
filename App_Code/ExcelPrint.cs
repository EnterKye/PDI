using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// ExcelPrint 的摘要说明
/// </summary>
public class ExcelPrint
{
    /// <summary>
    /// 资产号
    /// </summary>
    public string assetNum { get; set; }
    /// <summary>
    /// 序列号
    /// </summary>
    public string sn { get; set; }
    /// <summary>
    /// ISD编号
    /// </summary>
    public string ISDNum { get; set; }
    /// <summary>
    /// 机器型号
    /// </summary>
    public string Types { get; set; }
    /// <summary>
    /// 机器名称
    /// </summary>
    public string Name { get; set; }
    /// <summary>
    /// 购买时间
    /// </summary>
    public DateTime Timer { get; set; }
    /// <summary>
    /// 存放位置
    /// </summary>
    public string location { get; set; }
    /// <summary>
    /// 管理担当
    /// </summary>
    public string User { get; set; }
    /// <summary>
    /// 状态
    /// </summary>
    public string states { get; set; }
    /// <summary>
    /// 计数
    /// </summary>
    public int count { get; set; }
}