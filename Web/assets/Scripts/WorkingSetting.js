$(document).ready(function () {
    $(".applyselect").select2();
});




$("#btn_generateURL").bind("click", function () {
    GenerateURL(this);
});


$(".AIsActive").on('click', function (e) {
    UpdateIsActive(this);
});


function GenerateURL(obj) {
    $(".anchorShowURL").text('');
    $(".hdnURL").val('');
    var ObjURL = $(obj).closest("div").find("#txtURL");
    if ($(ObjURL).val() != "") {
        var dataObject = JSON.stringify({
            'ID': $(ObjURL).attr("tag-id"),
            'URL': $(ObjURL).val(),
            'Doctype': $(ObjURL).attr("tag-value")
        });
        $.ajax({
            url: "/CommonAjax/GenerateURLJSon",
            type: "Post",
            contentType: 'application/json',
            data: dataObject,
            success: function (data) {
                if (!data.Status) {
                    FailToaster(data.SuccessMessage);
                    $(".anchorShowURL").text('');
                    $(".hdnURL").val('');
                    $(ObjURL).val('');
                }
                else {
                    $(".anchorShowURL").text(data.AdditionalMessage);
                    $(".hdnURL").val(data.AdditionalMessage);
                    $(ObjURL).val(data.AdditionalMessage);
                }
            },
            error: function (er) {
                alert(er);
            }
        });
    }
    else {
        $.notify($(ObjURL), "Page URL can't not blank");
    }

}




function UpdateIsActive(obj) {
    var _this = $(obj);
    var ID = $(_this).closest("tr").find("input:hidden[name=I]").val();
    var Name = $(_this).closest("tr").find("input:hidden[name=N]").val();
    var Value = $(_this).attr('OP');
    var list = $(_this).attr('list');

    var dataObject = JSON.stringify({
        'ID': ID,
        'Value': Value,
        'Doctype': list
    });
    var Msg = '';
    if (Value == 1) {
        Msg = 'Are you sure want to Activate ' + Name;
    }
    else {
        Msg = 'Are you sure want to Deactivate ' + Name;
    }
    ConfirmMsgBox(Msg, '', function () {
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
                }
                else {

                    FailToaster(args.SuccessMessage);
                }
            },
            error: function (er) {
                console.log(er);
            }
        });
    })
}



$('.listpriority').blur(function () {
    UpdatePriority(this);
});
$('.listpriority').focus(function () {
    if ($(this).val() == '0') { $(this).val('') }
});


function UpdatePriority(obj) {
    var _this = $(obj);
    if ($(_this).val() == '') { $(_this).val('0') }
    var ID = $(_this).closest("tr").find("input:hidden[name=I]").val();
    var list = $(_this).attr('list');
    var Val = Number($(_this).val());

    var dataObject = JSON.stringify({
        'ID': ID,
        'Value': Val,
        'Doctype': list
    });

    $.ajax({
        url: "/CommonAjax/UpdateColumn_CommonJson",
        type: "Post",
        contentType: 'application/json',
        async: true,
        data: dataObject,
        success: function (data) {
            if (data.Status) {
                $(_this).css('border', '2px solid Green');
                SuccessToaster(data.SuccessMessage);
            }
            else {

                $(_this).css('border', '2px solid red');
                FailToaster(data.SuccessMessage);
            }

        },
        error: function (er) {
            console.log(er);
        }
    });
}

