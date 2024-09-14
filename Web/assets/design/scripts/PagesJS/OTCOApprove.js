$(document).ready(function () {
    $("#btnSearch").click();
});
$('.AnchorApproval').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    var att = $(this).attr("tabvalue");
    $(".AnchorApproval.active").removeClass("active");
    $(this).addClass("active");
    $("#Approve").val(att);
    ShowLoadingDialog();
    $("#btnSearch").click();
});

$('#Date').bind("change", function () {
    ShowLoadingDialog();
    $("#btnSearch").click();

});

$('#EMPID').bind("change", function () {
    ShowLoadingDialog();
    $("#btnSearch").click();

});

function BindTarget(args) {
    CloseLoadingDialog();
    $("#TargetDiv").empty();
    $("#TargetDiv").html(args);
    $('[data-toggle="tooltip"]').tooltip();
    DatatableScriptsWithColumnSearch("tableApprove");

    BindAllCheckBox();
    var form = $("form")
        .removeData("validator")
        .removeData("unobtrusiveValidation");
    $.validator.unobtrusive.parse(form);

    $(".btnCompensatory").click(function () {
        return Myvalidate();
    });
    $('.myResubmit').on('click', function (e) {
        e.preventDefault();
        e.stopPropagation();
        ResubmitOption();
    });
}


function Myvalidate() {

    var checked_checkboxes = $("#tableApprove input[type=checkbox]:checked");
    if (checked_checkboxes.length === 0) {
        swal('please Select atleast one checkbox', '');
        return false;

    }

    return true;
}


function OnSuccessAction(objsss) {
    if (objsss.Status) {
        $("#btnSearch").click();
    }
    else {
        FailToaster(objsss.SuccessMessage);
    }

}



function BindAllCheckBox() {
    chkAll();
    SinglecheckBind();
}
function SinglecheckBind() {

    $(".aaprovedhours").hide();
    $("#tableApprove input[type=checkbox]").change(function () {
        if ($(this).is(":checked")) {
            $(this).parents("tr:eq(0)").find(".aaprovedhours").show();
            $(this).parents("tr:eq(0)").find(".aaprovedhours").val($(this).parents("tr:eq(0)").find(".appliedhours").val());
        }
        else {
            $(this).parents("tr:eq(0)").find(".aaprovedhours").hide()
        }
    });
}

function chkAll() {
    $("#checkAll").change(function () {
        if ($(this).is(":checked")) {
            $(".chksingle").each(function () {
                $(this).prop('checked', true);
                $(this).parents("tr:eq(0)").find(".aaprovedhours").show();
                $(this).parents("tr:eq(0)").find(".aaprovedhours").val($(this).parents("tr:eq(0)").find(".appliedhours").val());
            });
        }
        else {
            $(".chksingle").each(function () {
                $(this).prop('checked', false);
                $(this).parents("tr:eq(0)").find(".aaprovedhours").hide()
            });
        }
    });
}



function ResubmitOption() {
    var checked_checkboxes = $("#tableApprove input[type=checkbox]:checked");
    if (checked_checkboxes.length === 0) {
        swal('please Select atleast one checkbox', '');
    }
    else {
            swal("Write Remarks", {
                text: "Enter Reason For Resubmit",
                content: "input",
            }).then(function (result) {
                if (result != "") {
                    $("#tableApprove input[type=checkbox]:checked").closest("tr").find("td .txtReason").val(result);
                    $("#btnResubmit").click();
                }
                else {
                    swal("", "Can't be Blank");
                }
            });
        }
    }

