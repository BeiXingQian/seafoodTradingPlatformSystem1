<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- 图书借阅信息的模态窗口，默认是隐藏的 -->
<div class="modal fade" id="borrowModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="myModalLabel">商品信息</h3>
            </div>
            <div class="modal-body">
                <form id="borrowBook">
                    <table class="table table-bordered table-striped" width="800px">
                        <%--商品的id，不展示在页面--%>
                        <span><input type="hidden" id="pid" name="id"></span>
                        <tr>
                            <td>商品名称</td>
                            <td><input class="form-control" readonly name="name" id="pname"></td>
                            <td>上架时间</td>
                            <td><input class="form-control" readonly name="uploadTime" id="puploadtime"></td>
                        </tr>
                        <tr>
                            <td>库存</td>
                            <td><input class="form-control" readonly name="number" id="pnumber"></td>
                            <td>产地</td>
                            <td><input class="form-control" readonly name="origin" id="porigin"></td>
                        </tr>
                        <tr>
                            <td>价格</td>
                            <td><input class="form-control" readonly name="price" id="pprice"></td>
                            <td>下单数量<br/><span style="color: red">*</span></td>
                            <%--输入购买商品的数量时，调用js中的cn方法如果输入的数量大于库存，则提示库存不足--%>
                            <td><input class="form-control" type="text" name="need" id="pneed" onclick="cg()">
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
            <div class="modal-footer">
                <%--点击保存按钮时，隐藏模态窗口并调用js文件中的borrow()方法--%>
                <button class="btn btn-success" data-dismiss="modal" aria-hidden="true" onclick="borrow()"
                        disabled="true" id="savemsg">保存
                </button>
                <button class="btn btn-default" data-dismiss="modal" aria-hidden="true">关闭</button>
            </div>
        </div>
    </div>
</div>
