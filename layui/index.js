
window.onload = function () {
    if (sessionStorage.getItem("user") != null) {
        window.parent.document.getElementById("uid").innerHTML = sessionStorage.getItem("user");
        window.parent.document.getElementById("loginTo").innerHTML = "注销";
    }
    if (sessionStorage.getItem("user") == null) {
        $(location).attr('href', 'login.html');
    }
}