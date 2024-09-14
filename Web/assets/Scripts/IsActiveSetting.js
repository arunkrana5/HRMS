
var IsActiveElements;

$(".IsActive_Confirm").on('click', function (e) {
    IsActiveElements = $(this);
    var Name = $(IsActiveElements).closest("tr").find("input:hidden[name=N]").val();
    var Value = $(IsActiveElements).attr('OP');
    var Msg = '';
    if (Value == 1) {
        Msg = 'Are you sure want to Activate ' + Name;
    }
    else {
        Msg = 'Are you sure want to Deactivate ' + Name;
    }
    $("#spanIsActive").html(Msg);

    $('#IsActiveModal').modal({
        backdrop: 'static',
        keyboard: false
    })
});

$("#IsActiveBtn_No").on("click", function () {
    $("#txtIsActiveReason").val('');
    $("#IsActiveModal").modal('hide');
});

$("#IsActiveBtn_Yes").on("click", function () {
    UpdateIsActive_Confirm();
});


function UpdateIsActive_Confirm() {
    var _this = $(IsActiveElements);
    var ID = $(_this).closest("tr").find("input:hidden[name=I]").val();
    var Name = $(_this).closest("tr").find("input:hidden[name=N]").val();
    var Value = $(_this).attr('OP');
    var list = $(_this).attr('list');
    var Reason = $("#txtIsActiveReason").val();
    $.trim(Reason.replace(/\s+/g, ' '));
    if (Reason=="") {
        FailToaster("Reason can't be Blank");
    } else {
        var dataObject = JSON.stringify({
            'ID': ID,
            'Value': Value,
            'Doctype': list,
            'Reason': Reason
        });
        $.ajax({
            url: "/CommonAjax/UpdateColumn_CommonJson",
            type: "Post",
            contentType: 'application/json',
            async: true,
            data: dataObject,
            success: function (args) {
                if (args.Status) {
                    if (parseInt(Value) == 0) {
                        $(_this).find('i').attr("class", "fa fa-times-circle crossred");
                        $(_this).attr("OP", "1");
                        $(_this).attr("data-original-title", "Click to Activate");

                        if (list.split('_')[1].toLowerCase() == "isactive") {
                            $(_this).closest("tr").addClass("trrowred");
                        } else {
                            $(_this).addClass("colorred").removeClass("colorgreen");

                        }
                    }
                    else {
                        $(_this).find('i').attr("class", "fa fa-check-circle checkgreen");
                        $(_this).attr("OP", "0");
                        $(_this).attr("data-original-title", "Click to DeActivate");

                        if (list.split('_')[1].toLowerCase() == "isactive") {
                            $(_this).closest("tr").removeClass("trrowred");
                        } else {
                            $(_this).addClass("colorgreen").removeClass("colorred");

                        }
                    }

                    CloseIsActiveModal();
                }
                else {

                    FailToaster(args.SuccessMessage);
                }
            },
            error: function (er) {
                console.log(er);
            }
        });

    }
}

function CloseIsActiveModal() {
    $("#txtIsActiveReason").val('');
    $("#IsActiveModal").modal('hide');
}