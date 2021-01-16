using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
public partial class Default2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        SQlHelper db = new SQlHelper();
        string sql = "select apo,name from userInfo";
        DataTable dt = db.ExcuteQuery("SqlServer", sql); ;
        for (int i = 0; i < dt.Rows.Count-1; i++)
		{

            string a = dt.Rows[i][0].ToString();
            string b = dt.Rows[i][1].ToString();
			if (TextBox1.Text == a && TextBox2.Text == b)
            {
                Label1.Text = "登录成功";
                Server.Transfer("default.aspx");
            }
            else
            {
                Label1.Text = "登录失败";
            }
		}
       
    }
}