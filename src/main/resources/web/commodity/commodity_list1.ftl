<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>商品信息</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <#include "../common/common.ftl" />
</head>

<body>
<header class="nav-down responsive-nav hidden-lg hidden-md">
    <button type="button" id="nav-toggle" class="navbar-toggle" data-toggle="collapse" data-target="#main-nav">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
    </button>

    <div id="main-nav" class="collapse navbar-collapse">
        <nav>
            <ul class="nav navbar-nav">
                <li><a href="#top">Home</a></li>
            </ul>
        </nav>
    </div>
</header>

<div class="sidebar-navigation hidde-sm hidden-xs">
    <div class="logo">
        <a href="#">Sen<em>tra</em></a>
    </div>
    <nav>
        <ul>
            <li>
                <a href="#featured">
                    <span class="rect"></span>
                    <span class="circle"></span>
                    商品管理
                </a>
            </li>
        </ul>
    </nav>
</div>

<div class="page-content">
    <section id="featured" class="content-section">
        <div class="section-heading">
            <h1>商品<br><em>列表</em></h1>
        </div>
        <div class="section-content">
            <div>
                <button id="add" type="button" class="btn btn-info" onclick="add()" style="position: relative;float: left;margin-bottom: 10px;">
                    添加
            </div>
        </div>
            <table class="table table-striped">
                <tr>
                    <td><input type="checkbox" id="all">全选</td>
                    <td>商品名称</td>
                    <td>商品规格</td>
                    <td>商品图片</td>
                    <td>温度</td>
                    <td>价格</td>
                    <td>商品描述</td>
                    <td colspan="2">操作</td>
                </tr>
                <#list commodity.list as item>
                    <tr>
                        <td><input type="checkbox" name="sub" value="${item.id}"></td>
                        <td>${(item.name)!}</td>
                        <td>${(item.standard)!}</td>
                        <td>
                            <#list item.images?split(",") as image>
                                <span><img src="${image!}" class="img-rounded" style="width: 140px;height: 140px;"></span>
                            </#list>
                        </td>
                        <td>${(item.temperature)!}</td>
                        <td>${(item.price)!}元</td>
                        <td>${(item.description)!}</td>
                        <td><button type="button" class="btn btn-warning" onclick="edit(${(item.id)})">
                                修改
                            </button>
                        </td>
                        <td><button type="button" class="btn btn-danger" onclick="deleteById('/commodity/deleteById?id=${(item.id)!}')">
                                删除
                            </button>
                        </td>
                    </tr>
                </#list>
                <tr>
                    <td>
                        <button type="button" class="btn btn-danger" onclick="del();" style="position: relative;float: left;margin-top: 18px;">
                            删除
                        </button>
                    </td>
                    <td colspan="7">

                    </td>
                </tr>
            </table>
        </div>
    </section>
    <section id="contact" class="content-section">
    </section>
</div>
<script>
    function deleteById(url) {
        $.confirm({
            title: '删除商品',
            content: '你确认要把该商品删除吗?',
            type: 'red',
            icon: 'glyphicon glyphicon-question-sign',
            buttons: {
                ok: {
                    text: '确认',
                    btnClass: 'btn-red',
                    action: function() {
                        location.href = url; //指向下载资源（此处为目标文件的输出数据流）
                    }
                },
                cancel: {
                    text: '取消'
                }
            }
        });
    }

    function edit(id){
        window.location.href="/commodity/editCommodity?id="+id;
    }

    // 跳转到添加界面
    function add() {
        window.location.href="/commodity/addCommodity";
    }


    function edit(id){

    }
    // 全选与全不选
    $("#all").on('click',function() {
        $("input[name='sub']").prop("checked", this.checked);
    });
    $("input[name='sub']").on('click',function() {
        var $subs = $("input[name='sub']");
        $("#all").prop("checked" , $subs.length == $subs.filter(":checked").length ? true :false);
    });
    // 获取选中的商品id
    function getIds() {
        var ids = "";
        var checkClass = $("input[name='sub']:checked");
        checkClass.each(function() {
            ids+=$(this).val();
            ids+=",";
        });
        ids = ids.substr(0, ids.lastIndexOf(","));
        return ids;
    }
    // 批删
    function del() {
        var ids = getIds();
        if(ids.length != 0){
            $.confirm({
                title: '删除操作!',
                content: '你确定要删除选中的所有商品吗？',
                type: 'red',
                typeAnimated: true,
                icon: 'glyphicon glyphicon-question-sign',
                buttons: {
                    tryAgain: {
                        text: '删除',
                        btnClass: 'btn-red',
                        action: function(){
                            $.ajax({
                                url : "/commodity/delCommoditys", // 数据发送方式
                                type : "post", // 接受数据格式           
                                dataType : "json", // 要传递的数据
                                data : {"ids" : ids},
                                success : function(data) {
                                    if (data.success) {
                                        layer.msg("删除成功!",
                                            {icon:6,time:1000},
                                            function(){
                                                parent.location.reload()
                                            })
                                    }else{
                                        $.alert("删除失败!");
                                    }
                                }
                            });
                        }
                    },
                    closebtn: {
                        text: '取消',
                        close: function () {
                            text:'取消'
                        }
                    }

                }
            });
        }else {
            $.confirm({
                title: '提示!',
                content: '请选择您要删除的商品!',
                type: 'red',
                typeAnimated: true,
                icon: 'glyphicon glyphicon-question-sign',
                buttons: {
                    tryAgain: {
                        text: '确定',
                        btnClass: 'btn-red',
                        action: function(){
                        }
                    }
                }
            });
        }


    }

</script>
</body>
</html>



















