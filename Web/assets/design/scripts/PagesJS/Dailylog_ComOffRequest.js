



function ShowRequestForComOFf() {
    var Month = $("#Month").val();
    $.ajax({
        url: "/Activity/_RequestForCompensatoryOff",
        type: "Post",
        data: { src: EncryptQueryStringJSON(MenuID+"*" + "/Activity/_RequestForCompensatoryOff" + "*" + Month)
},
success: function (data) {
    $("#DivComOFF").html(data);
    $("#RequestCompOffModal").modal('show');
    ApplyScriptsRequestForCompOff();

}
			});
        }

function ApplyScriptsRequestForCompOff() {

    BindAllCheckBox();
    var form = $("form")
        .removeData("validator")
        .removeData("unobtrusiveValidation");
    $.validator.unobtrusive.parse(form);

    $(".btnCompensatory").click(function () {
        return Myvalidate();
    });

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



function Myvalidate() {

    var checked_checkboxes = $("#tableApprove input[type=checkbox]:checked");
    if (checked_checkboxes.length === 0) {
        swal('please Select atleast one checkbox', '');
        return false;

    }

    return true;
}

function OnSuccessRequest(objsss) {
    if (objsss.Status) {
        $("#RequestCompOffModal").modal('hide');
		SuccessToaster(objsss.SuccessMessage);
		if ($('#IsHaveComOff') != undefined) {
			$('#IsHaveComOff').val('0');
		}
    }
    else {
        FailToaster(objsss.SuccessMessage);
    }

}
