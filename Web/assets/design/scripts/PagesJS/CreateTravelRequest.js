$(function () {
    $("#ddProjectDropdown").change(function () {
        FillCostCenter();
    });

    $(".btnSaveProject").click(function (e) {
        FillProjectgrid();
    });

   
});

function FillCostCenter() {

    var ddCostCenter = $("#ddProjectDropdown :selected").val();
    if (ddCostCenter != "") {
        ShowLoadingDialog();
        $.ajax({
            url: "/CommonAjax/GetProjectDetail_DropdownJson",
            type: "Get",
            async: true,
            data: { ProjectID: ddCostCenter },
            success: function (data) {
                $("#ddProjectDetailDropdown").empty();
                $("#ddProjectDetailDropdown").append($("<option     />").val("").text("Select"));
                $(data).each(function () {
                    $("#ddProjectDetailDropdown").append($("<option />").val(this.ID).text(this.SubActivity));
                    $("#ddProjectDetailDropdown").select2();
                });
                CloseLoadingDialog();
            },
            error: function (er) {
                CloseLoadingDialog();
            }
        });
    } else {
        $("#ddProjectDetailDropdown").empty();
        $("#ddProjectDetailDropdown").append($("<option     />").val("").text("Select"));
    }

}


function DeleteProjectItemList(obj) {
    var count = 0;
    var TotalRowCount = $('#tblProjects').find("tbody tr").length;
    ConfirmMsgBox("Are you sure want to delete", '', function () {

        $(obj).closest('tr').remove();
        $("#tblProjects TBODY TR").each(function (i) {
            $(this).closest("tr").find("label").each(function () {
                $(this).attr({
                    'id': function (_, id) { var arr = id.split('_'); return id.replace(arr[1], i); },
                });
                $(this).html(i + 1)
            });

            $(this).closest("tr").find("input").each(function () {
                $(this).attr({
                    'id': function (_, id) { return id.replace('_' + (parseInt(i) + 1) + '_', '_' + i + '_'); },
                    'name': function (_, name) { return name.replace('[' + (parseInt(i) + 1) + ']', '[' + i + ']'); },
                });

            });
        });
        ShowHideNewAddProject();
    });
   
}



function FillProjectgrid() {
    $(".notifyjs-wrapper").click();
    var CombinationExist = false;
    var DPro = $("#ddProjectDropdown option:selected").val();
    var DProD = $("#ddProjectDetailDropdown option:selected").val();
    if (DPro == "") {
        $.notify($("#ddProjectDropdown"), "Project Can Not Be Blank", "error");
        $("#ddProjectDropdown").focus();
    }
    else if (DProD == "") {
        $.notify($("#ddProjectDetailDropdown"), "Line Items Can not be Blank", "error");
        $("#ddProjectDetailDropdown").focus();

    }
    else {
        var InnerHTML = "";
        var DProText = $("#ddProjectDropdown option:selected").text();
        var DProDText = $("#ddProjectDetailDropdown option:selected").text();
        $('[name=CostCenterandItem]').each(function (index) {
            if ($(this).val() == DPro + "#" + DProD) {
                CombinationExist = true;
            }
        });
        if (!CombinationExist) {
            var Count = parseInt($('#tblProjects').find("tbody tr").length);

            InnerHTML += "<tr>";
            InnerHTML += "<td><label id='span_" + Count + "'  Name='span_" + Count + "'>" + (Count + 1) + "</label><input type='hidden' id='CostCenterandItem_" + Count + "'  Name='CostCenterandItem' value='" + DPro + "#" + DProD + "' /></td>";
            InnerHTML += "<td><input type='hidden' id=\"ProjectList_Travel_" + Count + "__ProjectID\" name=\"ProjectList_Travel[" + Count + "].ProjectID\" value='" + DPro + "' /> <input type='hidden' id=\"ProjectList_Travel_" + Count + "__Proj_name\" name=\"ProjectList_Travel[" + Count + "].Proj_name\" value='" + DProText + "' />" + DProText + "</td>";
            InnerHTML += "<td><input type='hidden'  id=\"ProjectList_Travel_" + Count + "__costcenter_Name\" name=\"ProjectList_Travel[" + Count + "].costcenter_Name\" value='" + DProDText + "' /><input type='hidden'  id=\"ProjectList_Travel_" + Count + "__proReqDet_ID\" name=\"ProjectList_Travel[" + Count + "].proReqDet_ID\" value='" + DProD + "' />" + DProDText + "</td>";
            InnerHTML += "<td class='text-center'><a onclick='DeleteProjectItemList(this)' data-toggle='tooltip' data-original-title='Remove' > <i class='fas fa-window-close red-clr'></i></a></td>";
            InnerHTML += "</tr>";
            $('#tblProjects').append(InnerHTML);
            $('[data-toggle="tooltip"]').tooltip();
            $("#ModalProject").modal('hide');
            ShowHideNewAddProject();
        }
        else {
            swal('Combination is already Exists!', '');
        }
    }
}