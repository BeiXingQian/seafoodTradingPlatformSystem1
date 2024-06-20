//购买窗口中下单数量标签的内容改变时执行
function cg() {
    $("#savemsg").attr("disabled", false);
}
//判断购买窗口中下单数量输入的值的合法性
function cn(){
    var number = $("#pnumber").val();
    var need = $("#pneed").val();
    if(isNaN(need)){
        alert("输入的数值不为数字,请重新输入")
        $("#savemsg").attr("disabled", true);
    }else{
        if(need>number){
            alert("购买数量不能大于库存数量")
            $("#savemsg").attr("disabled", true);
        }
        else if(need<0){
            alert("购买数量不能小于0")
            $("#savemsg").attr("disabled", true);
        }else{
            $("#savemsg").attr("disabled", false);
        }

    }

}
// 检查是否为正整数的辅助函数
function isPositiveInteger(value) {
    return /^\d+$/.test(value) && value > 0;
}
//点击购买商品时执行
function borrow() {
    cn();
    var url =getProjectPath()+ "/product/borrowProduct";
    var intValue = parseInt($("#pneed").val(), 10); // 购买数量，确保是数字类型
    if (!isPositiveInteger(intValue)){
        return; // 如果不是正整数，停止提交
    }
    var jsonData = {  //商品信息
        "id": $("#pid").val(),
        "number": ($("#pnumber").val()-$("#pneed").val()),
        "name": $("#pname").val(),
        "origin": $("#porigin").val(),
        "uploadTime": $("#puploadtime").val(),
        "price": parseFloat($("#pprice").val()),
        "status": ($("#pnumber").val() !== 0) ? 0 : 1
    }
    var requestData = {
        "product": jsonData,
        "need": intValue
    };
    // 使用 jQuery 的 $.ajax 方法发送 POST 请求
    $.ajax({
        type: "POST",
        contentType: "application/json",
        url: url,
        data: JSON.stringify(requestData),
        success: function(response) {
            alert(response.message);
            window.location.href = getProjectPath()+"/record/selectAllRecords";
        },
        error: function(error) {
            console.log(error);
        }
    });
    // $.post(url, JSON.stringify(dataTosend), function (response) {
    //     alert(response.message)
    //     if (response.success == true) {
    //         window.location.href = getProjectPath()+"/book/search";
    //     }
    // })
}

//重置添加和编辑窗口中输入框的内容
function resetFrom() {
    $("#aoe").attr("disabled",true)
    var $vals=$("#addOrEditProduct input");
    $vals.each(function(){
        $(this).attr("style","").val("")
    });
}
//重置添加和编辑窗口中输入框的样式
function resetStyle() {
    $("#aoe").attr("disabled",false)
    var $vals=$("#addOrEditProduct input");
    $vals.each(function(){
        $(this).attr("style","")
    });
}
//查询id对应的图书信息，并将图书信息回显到编辑或借阅的窗口中
function findProductById(id,doname) {
    resetStyle()
    var url = getProjectPath()+"/product/findById?id=" + id;
    $.get(url, function (response) {
        //如果是编辑商品，将获取的商品信息回显到编辑的窗口中
        if(doname=='edit'){
            $("#epid").val(response.data.id);
            $("#epname").val(response.data.name);
            $("#epprice").val(response.data.price);
            $("#eporigin").val(response.data.origin);
            $("#epnumber").val(response.data.number);
            $("#epstatus").val(response.data.status);
        }
        //如果是购买商品，将获取的商品信息回显到窗口中
        if(doname=='borrow'){
            $("#savemsg").attr("disabled",true)
            $("#pneed").val("");
            $("#pid").val(response.data.id);
            $("#pname").val(response.data.name);
            $("#pprice").val(response.data.price);
            $("#porigin").val(response.data.origin);
            $("#pnumber").val(response.data.number);
            $("#puploadtime").val(response.data.uploadTime);
        }
    })
}
//点击添加或编辑的窗口的确定按钮时，提交图书信息
function addOrEdit() {
    //获取表单中商品id的内容
    var epid = $("#epid").val();
    //如果表单中有商品id的内容，说明本次为编辑操作
    if (epid > 0) {
        var url = getProjectPath()+"/product/editProduct";
        $.post(url, $("#addOrEditProduct").serialize(), function (response) {
            alert(response.message)
            if (response.success == true) {
                window.location.href = getProjectPath()+"/product/search";
            }
        })
    }
    //如果表单中没有商品id，说明本次为添加操作
    else {
        var url = getProjectPath()+"/product/addProduct";
        $.post(url, $("#addOrEditProduct").serialize(), function (response) {
            alert(response.message)
            if (response.success == true) {
                window.location.href = getProjectPath()+"/product/search";
            }
        })
    }
}
//检查商品信息的窗口中，商品信息填写是否完整
function checkval(){
    var $inputs=$("#addOrEditTab input")
    var count=0;
    $inputs.each(function () {
        if($(this).val()==''||$(this).val()=="不能为空！"){
            count+=1;
        }
    })
    //如果全部输入框都填写完整，解除确认按钮的禁用状态
    if(count==0){
        $("#aoe").attr("disabled",false)
    }
}
//页面加载完成后，给商品模态窗口的输入框绑定失去焦点和获取焦点事件
$(function() {
    var $inputs=$("#addOrEditProduct input")
    var eisbn="";
    $inputs.each(function () {
        //给输入框绑定失去焦点事件
        $(this).blur(function () {
            if($(this).val()==''){
                $("#aoe").attr("disabled",true)
                $(this).attr("style","color:red").val("不能为空！")
            } else{
                checkval()
            }
        }).focus(function () {
            if($(this).val()=='不能为空！'){
                $(this).attr("style","").val("")
            }else{
                $(this).attr("style","")
            }
        })
    })
});
//获取当前项目的名称
function getProjectPath() {
    //获取主机地址之后的目录，如： cloudlibrary/admin/books.jsp
    var pathName = window.document.location.pathname;
    //获取带"/"的项目名，如：/cloudlibrary
    var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
    return  projectName;
}

/**
 * 数据展示页面分页插件的参数
 * cur 当前页
 * total 总页数
 * len   显示多少页数
 * pagesize 1页显示多少条数据
 * gourl 页码变化时 跳转的路径
 * targetId 分页插件作用的id
 */
var pageargs = {
    cur: 1,
    total: 0,
    len: 5,
    pagesize:10,
    gourl:"",
    targetId: 'pagination',
    callback: function (total) {
        var oPages = document.getElementsByClassName('page-index');
        for (var i = 0; i < oPages.length; i++) {
            oPages[i].onclick = function () {
                changePage(this.getAttribute('data-index'), pageargs.pagesize);
            }
        }
        var goPage = document.getElementById('go-search');
        goPage.onclick = function () {
            var index = document.getElementById('yeshu').value;
            if (!index || (+index > total) || (+index < 1)) {
                return;
            }
            changePage(index, pageargs.pagesize);
        }
    }
}
/**
 *商品查询栏的查询参数
 * name:'',
 * origin: ''
 */
var productVO={
    name:'',
    origin: ''
}
/**
 *消费记录查询栏的查询参数
 * userName:'',
 * productName:''
 */
var recordVO={
    userName:'',
    productName:''
}
//数据展示页面分页插件的页码发送变化时执行
function changePage(pageNo,pageSize) {
    pageargs.cur=pageNo;
    pageargs.pagesize=pageSize;
    document.write("<form action="+pageargs.gourl +" method=post name=form1 style='display:none'>");
    document.write("<input type=hidden name='pageNum' value="+pageargs.cur+" >");
    document.write("<input type=hidden name='pageSize' value="+pageargs.pagesize+" >");
    //如果跳转的是商品信息查询的相关链接，提交商品查询栏中的参数
    if(pageargs.gourl.indexOf("product")>=0){
        document.write("<input type=hidden name='name' value="+productVO.name+" >");
        document.write("<input type=hidden name='origin' value="+productVO.origin+" >");
    }
    //如果跳转的是交易记录查询的相关链接，提交交易记录查询栏中的参数
    if(pageargs.gourl.indexOf("record")>=0){
        document.write("<input type=hidden name='bookname' value="+recordVO.userName+" >");
        document.write("<input type=hidden name='borrower' value="+recordVO.productName+" >");
    }
    document.write("</form>");
    document.form1.submit();
    pagination(pageargs);
}

