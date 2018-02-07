<#import "/spring.ftl" as s>
<!DOCTYPE html>
<html lang="zh_CN">
<head>
    <!-- Meta, title, CSS, favicons, etc. -->
    <meta charset="utf-8">
    <title>管理员设置</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
<#include '../include/baselink.ftl'>
    <link rel="stylesheet" type="text/css" href="<@s.url '/assets/css/jquery.pagination.css'/>">
</head>

<body class="dashboard-page">
<#include '../include/skin-toolbox.ftl'>
<!-- Start: Main -->
<div id="main">
<#include '../include/header.ftl'>
<#include '../include/sidebar.ftl'>
    <section id="content_wrapper">
        <header id="topbar" class="alt">
            <div class="topbar-left">
                <ol class="breadcrumb">
                    <li class="crumb-active">
                        <a href="<@s.url '/'/>">控制台</a>
                    </li>
                    <li class="crumb-icon">
                        <a href="<@s.url '/'/>">
                            <span class="glyphicon glyphicon-home"></span>
                        </a>
                    </li>
                    <li class="crumb-link">
                        <a href="<@s.url '/'/>">首页</a>
                    </li>
                    <li class="crumb-trail">管理员设置</li>
                </ol>
            </div>
        </header>
        <section id="content" class="table-layout animated fadeIn">
            <div class="tray tray-center">

            </div>
        </section>
        <!-- End: Content -->
    <#include '../include/footer.ftl' />
    </section>


    <div class="modal fade" id="myModalEdit" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h3 class="modal-title" id="myModalLabel">编辑版本详情</h3>
                </div>
                <div class="modal-body">
                    <div class="admin-form">
                        <div class="section">
                            <label class="field-label">版本名称</label>
                            <label class="field prepend-icon">
                                <div class="form-group">
                                    <input type="text" class="gui-input" v-model="updateVersion.versionName">
                                </div>
                            </label>
                        </div>
                        <template v-for="(product,index)  in updateVersion.products">
                            <div class="section-divider mv40">
                                <span class=".fa .fa-pencil"></span>
                            </div>
                            <div class="section">
                                <label class="field-label">产品名称</label>
                                <label class="field prepend-icon">
                                    <input type="text" class="gui-input" v-model="product.productName">
                                </label>
                                <div>
                                    <img style="height: 100px; width: auto" v-bind:src="product.realDetailProduct">
                                </div>
                                <label :for="'updateFile' + index" class="btn btn-default btn-sm">选择文件</label>
                                <input :id="'updateFile' + index" type="file" class="form-control-static" style="display:none" :data-index="index" v-validate="'image'" v-on:change="editUploadImages">
                            </div>
                        </template>
                        <button type="button" class="btn btn-primary btn-sm" @click="addEditProduct">添加新产品</button>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" @click="updateVersionInfo(true)">发布</button>
                        <button type="button" class="btn btn-primary" @click="updateVersionInfo(false)" data-dismiss="modal">存草稿</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="myModalAdd" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                    <h3 class="modal-title" id="myModalLabel">添加新版本</h3>
                </div>
                <div class="modal-body">
                    <div class="admin-form">
                        <div class="section">
                            <label class="field-label">版本名称</label>
                            <label class="field prepend-icon">
                                <div class="form-group">
                                    <input type="text" class="gui-input" v-model="addVersion.versionName">
                                </div>
                            </label>
                        </div>
                        <template v-for="(product,index) in addVersion.products">
                            <div class="section-divider mv40">
                                <span class=".fa .fa-pencil"></span>
                            </div>
                            <div class="section">
                                <label class="field-label">产品名称</label>
                                <label class="field prepend-icon">
                                    <div class="form-group">
                                        <input type="text" class="gui-input"
                                               v-model="product.productName">
                                    </div>
                                </label>
                                <div>
                                    <img style="height: 100px; width: auto" v-bind:src="product.realDetailProduct">
                                </div>
                                <label :for="'addFile' + index" class="btn btn-default btn-sm">选择文件</label>
                                <input :id="'addFile' + index" type="file" class="form-control-static" style="display:none" :data-index="index"
                                       v-validate="'image'" v-on:change="addUploadImages" >
                            </div>
                        </template>
                        <button type="button" class="btn btn-primary btn-sm" @click="addNewProduct">添加新产品</button>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" @click="saveNewVersion(true)">发布</button>
                        <button type="button" class="btn btn-primary" @click="saveNewVersion(false)" >存草稿</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
<#include '../include/footer_js.ftl'/>
    <script src="<@s.url '/assets/js/jquery.pagination.min.js'/>"></script>
    <script src="<@s.url '/assets/plugins/ueditor/ueditor.config.js'/>"></script>
    <script src="<@s.url '/assets/plugins/ueditor/ueditor.all.min.js'/>"></script>

    <script>
        var aa = new Vue({
            el: "#main",
            data: {
                versions: [],
                sender: '',
                versionStatus: '',
                senders:[],
                addVersion: {products: [{}]},
                updateVersion: {products: [{}]},
                showVersionInfo: {products: [{}]},
            },
            created: function () {
                this.queryAll();
                this.findAllUser();
            },
            methods: {
                queryAll: function () {
                    this.$http.get(contentPath+"/api/youjia/version/findAllByUserOrStatus").then(function (response) {
                        this.versions = response.data.data;
                    },function (response) {
                        sweetAlert(response.data.message,"错误码"+response.data.code , "error");
                    })
                },
                findAllUser: function () {
                    this.$http.get(contentPath+"/api/youjia/version/findAllUsers").then(function (response) {
                        this.senders = response.data.data;
                    },function (response) {
                        sweetAlert(response.data.message,"错误码"+response.data.code , "error");
                    })
                },
                queryByUserOrStatus: function () {
                    this.$http.get(contentPath+"/api/youjia/version/findAllByUserOrStatus?user="+this.sender+"&status="+this.versionStatus).then(function (response) {
                        this.versions = response.data.data;
                    },function (response) {
                        sweetAlert(response.data.message,"错误码"+response.data.code , "error");
                    })
                },
                saveNewVersion: function (deploy) {
                    this.$http.post(contentPath+"/api/youjia/version/saveNewVersion?deploy="+ deploy,this.addVersion).then(function (response) {
                        sweetAlert("保存成功", "保存成功" , "info");
                        location.reload();
                    },function (response) {
                        sweetAlert(response.data.message,"错误码"+response.data.code , "error");
                    })
                },
                updateVersionInfo: function (deploy) {
                    this.$http.post(contentPath+"/api/youjia/version/updateVersion?deploy="+ deploy,this.updateVersion).then(function (response) {
                        sweetAlert("保存成功", "保存成功" , "info");
                        location.reload();
                    },function (response) {
                        sweetAlert(response.data.message,"错误码"+response.data.code , "error");
                    })
                },
                addNewProduct: function () {
                    this.addVersion.products.push({});
                },
                editVersion: function (version) {
                    if (version.products == undefined){
                        this.updateVersion.products = [{}]
                    }else{
                        this.updateVersion = version;
                    }
                },
                addEditProduct: function () {
                    this.updateVersion.products.push({});
                },
                showVersion: function(version){
                    if (version.products == undefined){
                        this.showVersionInfo.products = [{}]
                    }else{
                        this.showVersionInfo = version;
                    }
                },
                updateToUnDeploy: function (version) {
                    this.$http.get(contentPath + "/api/youjia/version/updateToUnDeploy?versionId=" + version.id)
                            .then(function (response) {
                        sweetAlert("撤回成功", "撤回成功", "info");
                        location.reload();
                    }, function (response) {
                        sweetAlert(response.data.message, "错误码" + response.data.code, "error");
                    })
                } ,
                updateToDeploy: function (version) {
                    this.$http.get(contentPath+"/api/youjia/version/updateToDeploy?versionId="+version.id).then(function (response) {
                        sweetAlert("发布成功", "发布成功" , "info");
                        location.reload();
                    },function (response) {
                        sweetAlert(response.data.message,"错误码"+response.data.code , "error");
                    })
                },
                addUploadImages:function (e) {
                    var index = e.target.dataset.index;
                    var thisVue = this;
                    var logoFile = e.target.files[0];
                    if (logoFile == undefined){
                        return;
                    }
                    var form = new FormData();
                    form.append("file",logoFile);
                    form.append("category","youjiajinfu");
                    $.ajax({
                        url:contentPath+"/images/upload",
                        type:"post",
                        data: form,
                        contentType:false,
                        processData:false,
                        success:function(data){
                            thisVue.$set(thisVue.addVersion.products[index],'detailProduct',data.data.key);
                            thisVue.addFindImageUrl(index);
                        },
                        error:function(e){
                            sweetAlert(e.toString());
                        }
                    });
                },
                addFindImageUrl:function (index) {
                    this.$http.get(contentPath+"/images/views?path="+this.addVersion.products[index].detailProduct)
                            .then(function (response) {
                                this.$set(this.addVersion.products[index],'realDetailProduct',response.data);
                            }, function (error) {
                                sweetAlert(error.body.msg);
                            });
                },
                editUploadImages:function (e) {
                    var index = e.target.dataset.index;
                    var thisVue = this;
                    var logoFile = e.target.files[0];
                    if (logoFile == undefined){
                        return;
                    }
                    var form = new FormData();
                    form.append("file",logoFile);
                    form.append("category","youjiajinfu");
                    $.ajax({
                        url:contentPath+"/images/upload",
                        type:"post",
                        data: form,
                        contentType:false,
                        processData:false,
                        success:function(data){
                            thisVue.$set(thisVue.updateVersion.products[index],'detailProduct',data.data.key);
                            thisVue.editFindImageUrl(index);
                        },
                        error:function(e){
                            sweetAlert(e.toString());
                        }
                    });
                },
                editFindImageUrl:function (index) {
                    this.$http.get(contentPath+"/images/views?path="+this.updateVersion.products[index].detailProduct)
                            .then(function (response) {
                                this.$set(this.updateVersion.products[index],'realDetailProduct',response.data);
                            }, function (error) {
                                sweetAlert(error.body.msg);
                            });
                }
            }
        })
    </script>
</body>

</html>