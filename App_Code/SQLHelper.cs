using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Configuration;
using System.Collections;
using System.Data.OleDb;

/// <summary>
/// SQlHelper 的摘要说明
/// </summary>
public class SQlHelper
{
    #region 数据库连接字段
    public string ConnectString { get; set; }
    public string ConnectStringSql { get; set; }
    public string ConnectStringOrl { get; set; }
	public  SQlHelper()
	{
        ConnectString = ConfigurationManager.AppSettings["ConnectionString"];
        ConnectStringSql = ConfigurationManager.AppSettings["strCon"];

    }
    #endregion

    #region 创建Connection
    private IDbConnection GetConnection(string DbType)
    {
        switch (DbType)
        {
            case "SqlServer":
                return new SqlConnection(ConnectStringSql);
            case "Access":
                return new OleDbConnection(ConnectString);
            default:
                return new SqlConnection(ConnectStringSql);
        }
    }
    #endregion

    #region 创建Command
    private IDbCommand GetCommand(string DbType, string sql, IDbConnection iConn)
    {
        switch (DbType)
        {
            case "SqlServer":
                return new SqlCommand(sql, (SqlConnection)iConn);
            case "Access":
                return new OleDbCommand(sql, (OleDbConnection)iConn);
            default:
                return new SqlCommand(sql, (SqlConnection)iConn);
        }
    }

    private IDbCommand GetCommand(string DbType)
    {
        switch (DbType)
        {
            case "SqlServer":
                return new SqlCommand();
            case "Access":
                return new OleDbCommand();
            default:
                return new SqlCommand();
        }
    }
    #endregion

    #region 创建Adapter
    private IDataAdapter GetAdapter(string DbType, string sql, IDbConnection iConn)
    {
        switch (DbType)
        {
            case "SqlServer":
                return new SqlDataAdapter(sql, (SqlConnection)iConn);
            case "Access":
                return new OleDbDataAdapter(sql, (OleDbConnection)iConn);
            default:
                return new SqlDataAdapter(sql, (SqlConnection)iConn);
        }
    }

    private IDataAdapter GetAdapter(string DbType, IDbCommand iCmd)
    {
        switch (DbType)
        {
            case "SqlServer":
                return new SqlDataAdapter((SqlCommand)iCmd);
            case "Access":
                return new OleDbDataAdapter((OleDbCommand)iCmd);
            default:
                return new SqlDataAdapter((SqlCommand)iCmd);
        }
    }
    #endregion

    #region 执行数据库表操作
    public IDataReader ExecuteReader(string DbType, string SqlString)
    {
        IDbConnection iConn = GetConnection(DbType);
        {
            iConn.Open();
            IDbCommand iCmd = GetCommand(DbType);
            {
                try
                {
                    PrepareCommand(DbType, out iCmd, iConn, null, SqlString, null);
                    IDataReader iReader = iCmd.ExecuteReader();
                    return iReader;
                }
                catch (Exception ex)
                {
                    throw new Exception(ex.Message);
                }
                finally
                {
                    iCmd.Dispose();

                }
            }
        }


    }

    private void PrepareCommand(string DbType, out IDbCommand iCmd, IDbConnection iConn, IDbTransaction iTrans, string cmdText, IDataParameter[] iParms)
    {
        if (iConn.State != ConnectionState.Open)
        {
            iConn.Open();
        }
        iCmd = GetCommand(DbType);
        iCmd.Connection = iConn;
        iCmd.CommandText = cmdText;
        if (iTrans != null)
        {
            iCmd.Transaction = iTrans;
        }
        iCmd.CommandType = CommandType.Text; //cmdType
        if (iParms != null)
        {
            foreach (IDataParameter parm in iParms)
            {
                iCmd.Parameters.Add(parm);
            }
        }

    }

    //执行查询语句，返回DataSet，重点用于Oracle数据库
    public DataSet Query(string DbType, string SqlString)
    {
        using (IDbConnection iConn = GetConnection(DbType))
        {
            DataSet Ds = new DataSet();
            iConn.Open();
            try
            {
                IDataAdapter iAdapter = GetAdapter(DbType, SqlString, iConn);
                iAdapter.Fill(Ds);
                return Ds;
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
            finally
            {
                if (iConn.State != ConnectionState.Closed)
                {
                    iConn.Close();
                }
            }
        }
    }

    //执行查询语句，返回DataTable，重点用于Oracle数据库
    public DataTable ExcuteQuery(string DbType, string SqlString)
    {
        using (IDbConnection iConn = GetConnection(DbType))
        {
            DataSet Ds = new DataSet();
            iConn.Open();
            try
            {
                IDataAdapter iAdapter = GetAdapter(DbType, SqlString, iConn);
                iAdapter.Fill(Ds);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
            finally
            {
                if (iConn.State != ConnectionState.Closed)
                {
                    iConn.Close();
                }
            }
            return Ds.Tables[0];
        }
    }

    //执行数据库表操作，重点用于SqlServer数据库
    public void ExcuteSqlScalar(string DbType, string SqlString)
    {
        using (IDbConnection iConn = GetConnection(DbType))
        {
            using (IDbCommand iCmd = GetCommand(DbType, SqlString, iConn))
            {
                iConn.Open();
                iCmd.ExecuteNonQuery();
            }
        }
    }

    public int ExcuteSqlNum(string DbType, string SqlString)
    {
        using (IDbConnection iConn = GetConnection(DbType))
        {
            using (IDbCommand iCmd = GetCommand(DbType, SqlString, iConn))
            {
                iConn.Open();
                int i = (int)iCmd.ExecuteScalar();
                return i;
            }
        }
    }

    public bool ExcuteSql(string DbType, string SqlString)
    {
        using (IDbConnection iConn = GetConnection(DbType))
        {
            using (IDbCommand iCmd = GetCommand(DbType, SqlString, iConn))
            {
                iConn.Open();
                try
                {
                    int Rows = (int)iCmd.ExecuteScalar();
                    return false;
                }
                catch (Exception ex)
                {
                    return true;
                }
                finally
                {
                    if (iConn.State != ConnectionState.Closed)
                    {
                        iConn.Close();
                    }
                }
            }

        }
    }

    //删除数据
    public void DeleGet(string DbType, string SqlString)
    {
        using (IDbConnection iConn = GetConnection(DbType))
        {
            using (IDbCommand iCmd = GetCommand(DbType, SqlString, iConn))
            {
                iConn.Open();
                iCmd.ExecuteNonQuery();
            }
        }
    }
    #endregion

    #region 执行多条SQL语句，实现数据库事物
    /// <summary>
    /// 
    /// </summary>
    /// <param name="DbType"></param>
    /// <param name="SqlStringList">多条SQL语句</param>
    /// <returns></returns>
    public bool ExcuteSqlTran(string DbType, ArrayList SqlStringList)
    {
        using (IDbConnection iConn = GetConnection(DbType))
        {
            iConn.Open();
            using (IDbCommand iCmd = GetCommand(DbType))
            {
                iCmd.Connection = iConn;
                using (IDbTransaction iDbTran = iConn.BeginTransaction())
                {
                    iCmd.Transaction = iDbTran;
                    try
                    {
                        for (int n = 0; n < SqlStringList.Count; n++)
                        {
                            string StrSql = SqlStringList[n].ToString();
                            if (StrSql.Trim().Length > 1)
                            {
                                iCmd.CommandText = StrSql;
                                iCmd.ExecuteNonQuery();
                            }
                        }
                        iDbTran.Commit();
                    }
                    catch (Exception ex)
                    {
                        Debug.WriteLine("ExcuteSqlTran" + ex.Message);
                        iDbTran.Rollback();
                        return false;
                    }
                    finally
                    {
                        if (iConn.State != ConnectionState.Closed)
                        {
                            iConn.Close();
                        }
                    }
                }
            }
            return true;
        }
    }


    #endregion

    #region SQL数据库解析格式
    private IDbDataParameter DbPara(string DbType, string ParaName, string DataType)
    {
        switch (DbType)
        {
            case "SqlServer":
                return GetSqlPara(ParaName, DataType);
            case "Access":
                return GetOledbPara(ParaName, DbType);
            default:
                return GetSqlPara(ParaName, DbType);
        }
    }

    private IDbDataParameter GetSqlPara(string ParaName, string DataType)
    {
        switch (DataType)
        {
            case "Decimal":
                return new SqlParameter(ParaName, SqlDbType.Decimal);
            case "VarChar":
                return new SqlParameter(ParaName, SqlDbType.VarChar);
            case "DateTime":
                return new SqlParameter(ParaName, SqlDbType.DateTime);
            case "Image":
                return new SqlParameter(ParaName, SqlDbType.Image);
            case "Int":
                return new SqlParameter(ParaName, SqlDbType.Int);
            case "Text":
                return new SqlParameter(ParaName, SqlDbType.Text);
            default:
                return new SqlParameter(ParaName, SqlDbType.VarChar);
        }
    }

    //Access(OLEDB)数据库数据解析格式
    private IDbDataParameter GetOledbPara(string ParaName, string DbType)
    {
        switch (DbType)
        {
            case "Decimal":
                return new OleDbParameter(ParaName, SqlDbType.Decimal);
            case "VarChar":
                return new OleDbParameter(ParaName, SqlDbType.VarChar);
            case "DateTime":
                return new OleDbParameter(ParaName, SqlDbType.DateTime);
            case "Image":
                return new OleDbParameter(ParaName, SqlDbType.Image);
            case "Int":
                return new OleDbParameter(ParaName, SqlDbType.Int);
            case "Text":
                return new OleDbParameter(ParaName, SqlDbType.Text);
            default:
                return new OleDbParameter(ParaName, SqlDbType.VarChar);
        }
    }

    #endregion


    #region  执行存储过程
    public DataSet RunProcedure(string DbType, string StoreProcName, IDataParameter[] Parameters, DataSet dataSet, string TableName)
    {
        using (IDbConnection iConn = GetConnection(DbType))
        {
            iConn.Open();
            IDataAdapter iDa = GetAdapter1(DbType, BuildQueryCommand(DbType, iConn, StoreProcName, Parameters));
            ((SqlDataAdapter)iDa).Fill(dataSet, TableName);
            if (iConn.State != ConnectionState.Closed)
            {
                iConn.Close();
            }
            return dataSet;
        }
    }


    private IDbCommand BuildQueryCommand(string dbType, IDbConnection iConn, string storeProcName, IDataParameter[] parameters)
    {
        IDbCommand iCmd = GetCommand(dbType, storeProcName, iConn);
        iCmd.CommandType = CommandType.StoredProcedure;
        if (parameters == null)
        {
            return iCmd;
        }
        foreach (IDataParameter parameter in parameters)
        {
            iCmd.Parameters.Add(parameter);
        }
        return iCmd;
    }

    private IDataAdapter GetAdapter1(string DbType, IDbCommand iCmd)
    {
        switch (DbType)
        {
            case "SqlServer":
                return new SqlDataAdapter((SqlCommand)iCmd);
            case "Oledb":
                return new OleDbDataAdapter((OleDbCommand)iCmd);
            default:
                return new SqlDataAdapter((SqlCommand)iCmd);
        }
    }

    /// <summary>
    /// 执行存储过程
    /// </summary>
    /// <param name="DbType"></param>
    /// <param name="storeProcName"></param>
    /// <param name="parameters"></param>
    /// <param name="TableName"></param>
    /// <returns></returns>
    public DataSet RunProcedure(string DbType, string storeProcName, IDbDataParameter[] parameters, string TableName)
    {
        using (IDbConnection iConn = GetConnection(DbType))
        {
            DataSet Ds = new DataSet();
            iConn.Open();
            IDataAdapter iDa = GetAdapter(DbType, BuildQueryCommand(DbType, iConn, storeProcName, parameters));
            ((SqlDataAdapter)iDa).Fill(Ds, TableName);
            if (iConn.State != ConnectionState.Closed)
            {
                iConn.Close();
            }
            return Ds;
        }
    }

    public DataSet RunProcedure(string DbType, string storeProcName, IDbDataParameter[] parameters)
    {
        using (IDbConnection iConn = GetConnection(DbType))
        {
            DataSet Ds = new DataSet();
            IDataAdapter iDa = GetAdapter(DbType, BuildQueryCommand(DbType, iConn, storeProcName, parameters));
            ((SqlDataAdapter)iDa).Fill(Ds);
            if (iConn.State != ConnectionState.Closed)
            {
                iConn.Close();
            }
            return Ds;
        }
    }
    #endregion
}