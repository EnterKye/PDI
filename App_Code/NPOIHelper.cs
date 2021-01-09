using NPOI.HSSF.UserModel;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
/// <summary>
/// NPOIHelper 的摘要说明
/// </summary>
public class NPOIHelper
{
	public NPOIHelper()
	{		
      
	}
    /// <summary>
    /// Excel导入成Datable
    /// </summary>
    /// <param name="file">导入路径(包含文件名与扩展名)</param>
    /// <returns></returns>
    public static DataTable ExcelToTable(string file)
    {
        try
        {
            DataTable dt = new DataTable();
            IWorkbook workbook;
            string fileExt = Path.GetExtension(file).ToLower();
            using (FileStream fs = new FileStream(file, FileMode.Open, FileAccess.Read))
            {
                //XSSFWorkbook 适用XLSX格式，HSSFWorkbook 适用XLS格式
                if (fileExt == ".xlsx") { workbook = new XSSFWorkbook(fs); } else if (fileExt == ".xls") { workbook = new HSSFWorkbook(fs); } else { workbook = null; }
                if (workbook == null) { return null; }
                ISheet sheet = workbook.GetSheetAt(0);

                //表头  
                IRow header = sheet.GetRow(sheet.FirstRowNum);
                List<int> columns = new List<int>();
                for (int i = 0; i < header.LastCellNum; i++)
                {
                    object obj = GetValueType(header.GetCell(i));
                    if (obj == null || obj.ToString() == string.Empty)
                    {
                        dt.Columns.Add(new DataColumn("Columns" + i.ToString()));
                    }
                    else
                        dt.Columns.Add(new DataColumn(obj.ToString()));
                    columns.Add(i);
                }
                //数据  
                for (int i = sheet.FirstRowNum + 1; i <= sheet.LastRowNum; i++)
                {
                    DataRow dr = dt.NewRow();
                    bool hasValue = false;
                    foreach (int j in columns)
                    {
                        //NPOI.XSSF.UserModel.XSSFCell
                        ICell cell = sheet.GetRow(i).GetCell(j);
                        if (cell == null)
                        {
                            dr[j] = GetValueType(sheet.GetRow(i).GetCell(j));
                        }
                        else 
                        {
                            if (cell.CellType == CellType.Numeric && DateUtil.IsCellDateFormatted(cell))
                            {
                                dr[j] = cell.DateCellValue.ToString();
                            }
                            else
                            {
                                dr[j] = GetValueType(sheet.GetRow(i).GetCell(j));
                            }
                        }
                        

                        //dr[j] = GetValueType(sheet.GetRow(i).GetCell(j));
                        if (dr[j] != null && dr[j].ToString() != string.Empty)
                        {
                            hasValue = true;
                        }
                    }
                    if (hasValue)
                    {
                        dt.Rows.Add(dr);
                    }
                }
            }
            return dt;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    /// <summary>
    /// Datable导出成Excel
    /// </summary>
    /// <param name="dt"></param>
    /// <param name="file">导出路径(包括文件名与扩展名)</param>
    public static MemoryStream TableToExcel(DataTable dt, string file)
    {
        try
        {
            IWorkbook workbook;
            string fileExt = Path.GetExtension(file).ToLower();
            if (fileExt == ".xlsx") { workbook = new XSSFWorkbook(); } else if (fileExt == ".xls") { workbook = new HSSFWorkbook(); } else { workbook = null; }
            if (workbook == null) { return null; }
            ISheet sheet = string.IsNullOrEmpty(dt.TableName) ? workbook.CreateSheet("Sheet1") : workbook.CreateSheet(dt.TableName);

            //表头  
            IRow row = sheet.CreateRow(0);
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                ICell cell = row.CreateCell(i);
                cell.SetCellValue(dt.Columns[i].ColumnName);
            }
            ////表头  
            //IRow row = sheet.CreateRow(0);
            //string[] ColumnName = { "列名1", "列名2", "列名3", "列名4" };
            //for (int i = 0; i < dt.Columns.Count; i++)
            //{
            //    ICell cell = row.CreateCell(i);
            //    foreach (var item in ColumnName)
            //    {
            //        cell.SetCellValue(item);
            //    } 
            //}
            //数据  
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                IRow row1 = sheet.CreateRow(i + 1);
                for (int j = 0; j < dt.Columns.Count; j++)
                {
                    ICell cell = row1.CreateCell(j);
                    cell.SetCellValue(dt.Rows[i][j].ToString());
                }
            }

            //转为字节数组  
            using (MemoryStream stream = new MemoryStream())
            {
                workbook.Write(stream);
                stream.Flush();

                return stream;
            }
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    //获取单元格值
    private static object GetValueType(ICell cell)
    {
        if (cell == null)
            return null;
        switch (cell.CellType)
        {
            case CellType.Blank: //BLANK:  
                return null;
            case CellType.Boolean: //BOOLEAN:  
                return cell.BooleanCellValue;
            case CellType.Numeric: //NUMERIC:  
                return cell.NumericCellValue;
            case CellType.String: //STRING:  
                return cell.StringCellValue;
            case CellType.Error: //ERROR:  
                return cell.ErrorCellValue;
            case CellType.Formula: //FORMULA:  
            default:
                return "=" + cell.CellFormula;
        }
    }



}

