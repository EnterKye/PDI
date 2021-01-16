<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default2.aspx.cs" Inherits="Default2" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        账号：<asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
        密码：<asp:TextBox ID="TextBox2"  runat="server"></asp:TextBox>
        <asp:Button ID="Button1" runat="server" Text="登录"  OnClick="Button1_Click"/>
        <asp:Label ID="Label1" runat="server" Text=""></asp:Label>
    </div>
    </form>
</body>
</html>
