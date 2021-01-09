using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// FourM 的摘要说明
/// </summary>
public class FourM
{
    /// <summary>
    /// 页面查询资产号
    /// </summary>
    public string assetNumKey { get; set; }
    /// <summary>
    /// 页面查询日期
    /// </summary>
    public string dateKey { get; set; }
    /// <summary>
    /// 列表总数
    /// </summary>
    public int i { get; set; }
    /// <summary>
    /// 返回Json
    /// </summary>
    public string str { get; set; }
    /// <summary>
    /// limit数
    /// </summary>
    public int PageSize { get; set; }
    /// <summary>
    /// page页
    /// </summary>
    public int PageNumber { get; set; }
}