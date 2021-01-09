using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// ExcelScanner 的摘要说明
/// </summary>
public class ExcelScanner
{
    /// <summary>
    /// 资产号
    /// </summary>
    public string AssetNum { get; set; }
    /// <summary>
    /// 序列号
    /// </summary>
    public string Sn { get; set; }
    /// <summary>
    /// 型号
    /// </summary>
    public string Types { get; set; }
    /// <summary>
    /// ADM编号
    /// </summary>
    public string Adm { get; set; }
    /// <summary>
    /// 购入日期
    /// </summary>
    public DateTime? BuyTimer { get; set; }
    /// <summary>
    /// 存放位置
    /// </summary>
    public string Location { get; set; }
    /// <summary>
    /// 管理担当
    /// </summary>
    public string User { get; set; }
    /// <summary>
    /// 状态
    /// </summary>
    public string States { get; set; }
    /// <summary>
    /// 总数
    /// </summary>
    public int count { get; set; }
}