<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="utf-8">
    <title>商品菜单</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/AdminLTE.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pagination.css">
    <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
    <script src="${pageContext.request.contextPath}/js/pagination.js"></script>
    <script src="${pageContext.request.contextPath}/js/my.js"></script>
</head>

<body class="hold-transition skin-red sidebar-mini">
<!-- .box-body -->
<div class="box-header with-border">
    <h3 class="box-title">商品菜单</h3>
</div>
<div class="box-body">
    <%--新增按钮：如果当前登录用户是管理员，页面展示新增按钮--%>
    <c:if test="${USER_SESSION.role == 'ADMIN'}">
        <div class="pull-left">
            <div class="form-group form-inline">
                <div class="btn-group">
                    <button type="button" class="btn btn-default" title="新建" data-toggle="modal"
                            data-target="#addOrEditModal" onclick="resetFrom()"> 新增
                    </button>
                </div>
            </div>
        </div>
    </c:if>
    <%--新增按钮 /--%>
    <!--工具栏 数据搜索 -->
    <div class="box-tools pull-right">
        <div class="has-feedback">
            <form action="${pageContext.request.contextPath}/product/search" method="post">
                商品名称：<input name="name" value="${search.name}">&nbsp&nbsp&nbsp&nbsp
                商品产地：<input name="origin" value="${search.origin}">&nbsp&nbsp&nbsp&nbsp
                <input class="btn btn-default" type="submit" value="查询">
            </form>
        </div>
    </div>
    <!--工具栏 数据搜索 /-->
    <!-- 数据列表 -->
    <div class="table-box">
        <!-- 数据表格 -->
        <table id="dataList" class="table table-bordered table-striped table-hover dataTable text-center">
            <thead>
            <tr>
                <th class="sorting_asc">商品名称</th>
                <th class="sorting">商品产地</th>
                <th class="sorting">商品状态</th>
                <th class="sorting">商品数量</th>
                <th class="text-center">操作</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${pageResult.rows}" var="product">
                <tr>
                    <td>${product.name}</td>
                    <td>${product.origin}</td>
                    <td>
                        <c:if test="${product.status ==0}">出售中</c:if>
                        <c:if test="${product.status ==1}">已下架</c:if>
                    </td>
                    <td>${product.number}</td>
                    <td class="text-center">
                        <c:if test="${product.status ==0}">
                            <button type="button" class="btn bg-olive btn-xs" data-toggle="modal"
                                    data-target="#borrowModal" onclick="findProductById(${product.id},'borrow')"> 购买
                            </button>
                        </c:if>
                        <c:if test="${product.status ==1}">
                            <button type="button" class="btn bg-olive btn-xs" disabled="true">售空</button>
                        </c:if>
                        <c:if test="${USER_SESSION.role =='ADMIN'}">
                            <button type="button" class="btn bg-olive btn-xs" data-toggle="modal"
                                    data-target="#addOrEditModal" onclick="findProductById(${product.id},'edit')"> 编辑
                            </button>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <!--数据表格/-->
        <%--分页插件--%>
        <div id="pagination" class="pagination"></div>
    </div>
    <!--数据列表/-->
</div>
<!-- /.box-body -->
<%--引入存放模态窗口的页面--%>
<jsp:include page="/admin/product_modal.jsp"></jsp:include>

<!-- 添加和编辑图书的模态窗口 -->
<div class="modal fade" id="addOrEditModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
     aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="myModalLabel">商品信息</h3>
            </div>
            <div class="modal-body">
                <form id="addOrEditProduct">
                    <span><input type="hidden" id="epid" name="id"></span>
                    <table id="addOrEditTab" class="table table-bordered table-striped" width="800px">
                        <%--图书的id,不展示在页面--%>
                        <tr>
                            <td>商品名称</td>
                            <td><input class="form-control" placeholder="商品名称" name="name" id="epname"></td>
                            <td>商品产地</td>
                            <td><input class="form-control" placeholder="商品产地" name="origin" id="eporigin"></td>
                        </tr>
                        <tr>
                            <td>商品价格</td>
                            <td><input class="form-control" placeholder="商品价格" name="price" id="epprice"></td>
                            <td>商品数量</td>
                            <td><input class="form-control" placeholder="商品数量" name="number" id="epnumber"></td>
                        </tr>
                        <tr>
                            <td>上架状态</td>
                            <td>
                                <select class="form-control" id="epstatus" name="status"> <%-- 这里的name要与product对象的属性相同--%>
                                    <option value="0">上架</option>
                                    <option value="1">下架</option>
                                </select>
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-success" data-dismiss="modal" aria-hidden="true" id="aoe" disabled
                        onclick="addOrEdit()">保存
                </button>
                <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">关闭</button>
            </div>
        </div>
    </div>
</div>
</body>
<script>
    /*分页插件展示的总页数*/
    pageargs.total = Math.ceil(${pageResult.total}/pageargs.pagesize);
    /*分页插件当前的页码*/
    pageargs.cur = ${pageNum}
        /*分页插件页码变化时将跳转到的服务器端的路径*/
        pageargs.gourl = "${gourl}"
    /*保存搜索框中的搜索条件，页码变化时携带之前的搜索条件*/
    productVO.name = "${search.name}"
    productVO.origin = "${search.origin}"
    /*分页效果*/
    pagination(pageargs);
</script>
</html>