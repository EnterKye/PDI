using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using System.Collections;
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
        public string count { get; set; }
        public string MyProperty { get; set; }
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        string a = "p12";
        location li = new location();
        ArrayList locationArray = new ArrayList();
        locationArray = li.GetLocation();
        bool exists = ((IList)locationArray).Contains(a.ToUpper());

       
    }
}