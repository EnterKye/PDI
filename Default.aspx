﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <input id="Text1" type="text" runat="server" />
        <asp:Button ID="Button1" runat="server" Text="Button" OnClick="Button1_Click" />
        <input type="button" name="name" value=" 123123" runat="server" />

        <asp:GridView ID="GridView1" runat="server"></asp:GridView>
      

    </div>
    </form>
   <script src="js/GetUrlID.js"></script>
    <script>
        QueryString("")
    </script>
</body>
</html>
