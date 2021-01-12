using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        List<tb_c> list = new List<tb_c>();
        list.Add(new tb_c() { jz = "456", sl = "123" });

       
    }
    public class tb_c
    {
        public string jz { get; set; }
        public string sl { get; set; }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {

        string timer = Text1.Value;
        //DateTime times = Convert.ToDateTime(timer);
        DateTime? dt;
        DateTime? date12 = timer == "" ? new Nullable<DateTime>() : DateTime.ParseExact(timer, "yyyyMMdd", System.Globalization.CultureInfo.CurrentCulture);       

       
       
    }
}