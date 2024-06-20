<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <meta charset="utf-8">
    <title>新书推荐</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/AdminLTE.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/pagination.css">
    <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.js"></script>
    <script src="${pageContext.request.contextPath}/js/pagination.js"></script>
    <script src="${pageContext.request.contextPath}/js/my.js"></script>
</head>
<body class="hold-transition skin-red sidebar-mini">
<!--数据展示头部-->
<div class="box-header with-border">
    <h3 class="box-title">商品推荐</h3>
</div>
<!--数据展示头部-->
<!--数据展示内容区-->
<div class="box-body">
    <!-- 数据表格 -->
    <table id="dataList" class="table table-bordered table-striped table-hover dataTable text-center">
        <thead>
        <tr>
            <th class="sorting_asc">商品名称</th>
            <th class="sorting">产地</th>
            <th class="sorting">商品状态</th>
            <th class="sorting">价格</th>
            <th class="sorting">数量</th>
            <th class="text-center">操作</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${pageResult.rows}" var="product">
            <tr>
                <td> ${product.name}</td>
                <td>${product.origin}</td>
                <td>
                    <c:if test="${product.status ==0}">出售中</c:if>
                    <c:if test="${product.status ==1}">已售空</c:if>
                </td>
                <td>${product.price}</td>
                <td>${product.number}</td>
                <td class="text-center">
                    <c:if test="${product.status ==0&&product.number>0}">
                        <button type="button" class="btn bg-olive btn-xs" data-toggle="modal" data-target="#borrowModal"
                                onclick="findProductById(${product.id},'borrow')"> 购买
                        </button>
                    </c:if>
                    <c:if test="${product.status ==1||product.number<=0}">
                        <button type="button" class="btn bg-olive btn-xs" disabled="true">售空</button>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <!-- 数据表格 /-->
</div>
<!-- 数据展示内容区/ -->
<%--引入存放模态窗口的页面--%>
<jsp:include page="/admin/product_modal.jsp"></jsp:include>
</body>
</html>
