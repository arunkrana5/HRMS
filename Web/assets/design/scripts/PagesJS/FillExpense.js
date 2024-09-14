$('.btnaddOtherExpense').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    AddNewRowOtherExpense();
});
$('.btnaddTransport').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    AddNewRowTransport();
});

$('.btnAddRowTravelFare').on('click', function (e) {
    e.preventDefault();
    e.stopPropagation();
    AddRowTravelFare();
});


function AddNewRowTransport() {
    var LastTRCount = parseInt($('#tblTransport').find("tbody tr").length) - 1;
    $('.applyselect').select2("destroy");
    var $tableBody = $('#tblTransport').find("tbody"),
        $trLast = $tableBody.find("tr:last"),
        $trNew = $trLast.clone();
    $trNew.find("td:last").html('<a onclick="DeleteTransport(this)" class="remove"><i class="fas fa-window-close red-clr" aria-hidden="true"></i></a>')


    $trNew.find("label").each(function () {
        $(this).attr({
            'id': function (_, id) { var arr = id.split('_'); return id.replace(arr[1], LastTRCount + 1); },
        });
        $(this).html(parseInt($('#tblTransport').find("tbody tr").length) + 1)
    });

    $trNew.find("select").each(function (i) {
        $(this).attr({
            'id': function (_, name) { return name.replace('_' + LastTRCount + '_', '_' + (parseInt(LastTRCount) + 1) + '_'); },
            'name': function (_, name) { return name.replace('[' + LastTRCount + ']', '[' + (parseInt(LastTRCount) + 1) + ']'); },
        });

    });
    $trNew.find("input").each(function (i) {
        $(this).attr({
            'id': function (_, name) { return name.replace('_' + LastTRCount + '_', '_' + (parseInt(LastTRCount) + 1) + '_'); },
            'name': function (_, name) { return name.replace('[' + LastTRCount + ']', '[' + (parseInt(LastTRCount) + 1) + ']'); },
        });
        $(this).val('')
    });
    $trNew.find("textarea").each(function (i) {
        $(this).attr({
            'id': function (_, name) { return name.replace('_' + LastTRCount + '_', '_' + (parseInt(LastTRCount) + 1) + '_'); },
            'name': function (_, name) { return name.replace('[' + LastTRCount + ']', '[' + (parseInt(LastTRCount) + 1) + ']'); },
        });
        $(this).val('')
    });

    $trNew.find("span").each(function (i) {
        if ($(this).attr("data-valmsg-for")) {
            $(this).attr({
                'data-valmsg-for': function (_, name) { return name.replace('[' + LastTRCount + ']', '[' + (parseInt(LastTRCount) + 1) + ']'); }
            });
        }
        if ($(this).attr("for")) {
            $(this).attr({
                'for': function (_, name) { return name.replace('_' + LastTRCount + '_', '_' + (parseInt(LastTRCount) + 1) + '_'); }
            });
        }
    });

    $trLast.after($trNew);
    var form = $("form");
    form.removeData('validator');
    form.removeData('unobtrusiveValidation');
    $.validator.unobtrusive.parse(form);
    $('[data-toggle="tooltip"]').tooltip();
    $(".applyselect").select2();

}


function DeleteTransport(obj) {
    var count = 0;
    var TotalRowCount = $('#tblTransport').find("tbody tr").length;
    ConfirmMsgBox("Are you sure want to delete", '', function () {

        $(obj).closest('tr').remove();
        $("#tblTransport TBODY TR").each(function (i) {
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



            $(this).closest("tr").find("textarea").each(function () {
                $(this).attr({
                    'id': function (_, id) { return id.replace('_' + (parseInt(i) + 1) + '_', '_' + i + '_'); },
                    'name': function (_, name) { return name.replace('[' + (parseInt(i) + 1) + ']', '[' + i + ']'); },
                });

            });


            $(this).closest("tr").find("span").each(function () {
                if ($(this).attr("data-valmsg-for")) {
                    $(this).attr({
                        'data-valmsg-for': function (_, name) { return name.replace('[' + (parseInt(i) + 1) + ']', '[' + i + ']'); },
                    });
                }
                if ($(this).attr("for")) {
                    $(this).attr({
                        'for': function (_, id) { return id.replace('_' + (parseInt(i) + 1) + '_', '_' + i + '_'); },
                    });
                }
            });
        });
        var form = $("form");
        form.removeData('validator');
        form.removeData('unobtrusiveValidation');
        $.validator.unobtrusive.parse(form);

    })
}


function AddNewRowOtherExpense() {
    var LastTRCount = parseInt($('#tblOtherExpense').find("tbody tr").length) - 1;
    $('.applyselect').select2("destroy");
    var $tableBody = $('#tblOtherExpense').find("tbody"),
        $trLast = $tableBody.find("tr:last"),
        $trNew = $trLast.clone();
    $trNew.find("td:last").html('<a onclick="DeleteOtherExpense(this)" class="remove"><i class="fas fa-window-close red-clr" aria-hidden="true"></i></a>')



    $trNew.find("label").each(function () {
        $(this).attr({
            'id': function (_, id) { var arr = id.split('_'); return id.replace(arr[1], LastTRCount + 1); },
        });
        $(this).html(parseInt($('#tblOtherExpense').find("tbody tr").length) + 1)
    });

    $trNew.find("input").each(function (i) {
        $(this).attr({
            'id': function (_, name) { return name.replace('_' + LastTRCount + '_', '_' + (parseInt(LastTRCount) + 1) + '_'); },
            'name': function (_, name) { return name.replace('[' + LastTRCount + ']', '[' + (parseInt(LastTRCount) + 1) + ']'); },
        });
        $(this).val('')
    });

    $trNew.find("select").each(function (i) {
        $(this).attr({
            'id': function (_, name) { return name.replace('_' + LastTRCount + '_', '_' + (parseInt(LastTRCount) + 1) + '_'); },
            'name': function (_, name) { return name.replace('[' + LastTRCount + ']', '[' + (parseInt(LastTRCount) + 1) + ']'); },
        });

    });

    $trNew.find("textarea").each(function (i) {
        $(this).attr({
            'id': function (_, name) { return name.replace('_' + LastTRCount + '_', '_' + (parseInt(LastTRCount) + 1) + '_'); },
            'name': function (_, name) { return name.replace('[' + LastTRCount + ']', '[' + (parseInt(LastTRCount) + 1) + ']'); },
        });
        $(this).val('')
    });

    $trNew.find("span").each(function (i) {
        if ($(this).attr("data-valmsg-for")) {
            $(this).attr({
                'data-valmsg-for': function (_, name) { return name.replace('[' + LastTRCount + ']', '[' + (parseInt(LastTRCount) + 1) + ']'); }
            });
        }
        if ($(this).attr("for")) {
            $(this).attr({
                'for': function (_, name) { return name.replace('_' + LastTRCount + '_', '_' + (parseInt(LastTRCount) + 1) + '_'); }
            });
        }
    });

    $trLast.after($trNew);
    var form = $("form");
    form.removeData('validator');
    form.removeData('unobtrusiveValidation');
    $.validator.unobtrusive.parse(form);
    $('[data-toggle="tooltip"]').tooltip();
    $(".applyselect").select2();
}


function DeleteOtherExpense(obj) {
    var count = 0;
    var TotalRowCount = $('#tblOtherExpense').find("tbody tr").length;
    ConfirmMsgBox("Are you sure want to delete", '', function () {

        $(obj).closest('tr').remove();
        $("#tblOtherExpense TBODY TR").each(function (i) {
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



            $(this).closest("tr").find("textarea").each(function () {
                $(this).attr({
                    'id': function (_, id) { return id.replace('_' + (parseInt(i) + 1) + '_', '_' + i + '_'); },
                    'name': function (_, name) { return name.replace('[' + (parseInt(i) + 1) + ']', '[' + i + ']'); },
                });

            });


            $(this).closest("tr").find("span").each(function () {
                if ($(this).attr("data-valmsg-for")) {
                    $(this).attr({
                        'data-valmsg-for': function (_, name) { return name.replace('[' + (parseInt(i) + 1) + ']', '[' + i + ']'); },
                    });
                }
                if ($(this).attr("for")) {
                    $(this).attr({
                        'for': function (_, id) { return id.replace('_' + (parseInt(i) + 1) + '_', '_' + i + '_'); },
                    });
                }
            });
        });
        var form = $("form");
        form.removeData('validator');
        form.removeData('unobtrusiveValidation');
        $.validator.unobtrusive.parse(form);

    })
}



function AddRowTravelFare() {
    var LastTRCount = parseInt($('#tblTravelFare').find("tbody tr").length) - 1;
    $('.applyselect').select2("destroy");
    var $tableBody = $('#tblTravelFare').find("tbody"),
        $trLast = $tableBody.find("tr:last"),
        $trNew = $trLast.clone();
    $trNew.find("td:last").html('<a onclick="DeletTravelFare(this)" data-toggle="tooltip" data-original-title="Delete Row" class="close"><i class="fas fa-window-close red-clr" aria-hidden="true"></i></a>');


    $trNew.find("label").each(function () {
        $(this).attr({
            'id': function (_, id) { var arr = id.split('_'); return id.replace(arr[1], LastTRCount + 1); },
        });
        $(this).html(parseInt($('#tblTravelFare').find("tbody tr").length) + 1);
    });

    $trNew.find("select").each(function (i) {
        $(this).attr({

            'name': function (_, name) { return name.replace('[' + LastTRCount + ']', '[' + (parseInt(LastTRCount) + 1) + ']'); },
        });
        

    });
    $trNew.find("input").each(function (i) {
        $(this).attr({

            'name': function (_, name) { return name.replace('[' + LastTRCount + ']', '[' + (parseInt(LastTRCount) + 1) + ']'); },
        });
        if ($(this).attr('type') != 'hidden') {
            $(this).val('');
            $(this).removeAttr('readonly');
        }
       
       

    });

    $trNew.find("span").each(function (i) {
        if ($(this).attr("data-valmsg-for")) {
            $(this).attr({
                'data-valmsg-for': function (_, name) { return name.replace('[' + LastTRCount + ']', '[' + (parseInt(LastTRCount) + 1) + ']'); }
            });
        }
        if ($(this).attr("for")) {
            $(this).attr({
                'for': function (_, name) { return name.replace('_' + LastTRCount + '_', '_' + (parseInt(LastTRCount) + 1) + '_'); }
            });
        }
    });

    $trLast.after($trNew);
    var form = $("form");
    form.removeData('validator');
    form.removeData('unobtrusiveValidation');
    $.validator.unobtrusive.parse(form);
    $('[data-toggle="tooltip"]').tooltip();
    $(".applyselect").select2();

    $('.ATravelSource').bind("change", function () {
        DiableEnableATravelfareAmount(this);
    });
    PageLoadATravelfareAmount();

}


function DeletTravelFare(obj) {
    var count = 0;
    var TotalRowCount = $('#tblTravelFare').find("tbody tr").length;
    ConfirmMsgBox("Are you sure want to delete", '', function () {

        $(obj).closest('tr').remove();
        $("#tblTravelFare TBODY TR").each(function (i) {
            $(this).closest("tr").find("label").each(function () {
                $(this).attr({
                    'id': function (_, id) { var arr = id.split('_'); return id.replace(arr[1], i); },
                });
                $(this).html(i + 1);
            });
            $(this).closest("tr").find("select").each(function () {
                $(this).attr({
                    'id': function (_, id) { return id.replace('_' + (parseInt(i) + 1) + '_', '_' + i + '_'); },
                    'name': function (_, name) { return name.replace('[' + (parseInt(i) + 1) + ']', '[' + i + ']'); },
                });

            });

            $(this).closest("tr").find("input").each(function () {
                $(this).attr({
                    'id': function (_, id) { return id.replace('_' + (parseInt(i) + 1) + '_', '_' + i + '_'); },
                    'name': function (_, name) { return name.replace('[' + (parseInt(i) + 1) + ']', '[' + i + ']'); },
                });

            });


            $(this).closest("tr").find("span").each(function () {
                if ($(this).attr("data-valmsg-for")) {
                    $(this).attr({
                        'data-valmsg-for': function (_, name) { return name.replace('[' + (parseInt(i) + 1) + ']', '[' + i + ']'); },
                    });
                }
                if ($(this).attr("for")) {
                    $(this).attr({
                        'for': function (_, id) { return id.replace('_' + (parseInt(i) + 1) + '_', '_' + i + '_'); },
                    });
                }
            });
        });
        var form = $("form");
        form.removeData('validator');
        form.removeData('unobtrusiveValidation');
        $.validator.unobtrusive.parse(form);

    });
}



$('.ATravelSource').bind("change", function () {
    DiableEnableATravelfareAmount(this);
});

function DiableEnableATravelfareAmount(obj) {
    var a = $(obj).closest('tr').find("select.ATravelSource option:selected").val();
    if (a == "By Travel Desk") {
        $(obj).closest('tr').find(".AAmount").removeAttr('readonly');

    }
    else {
        $(obj).closest('tr').find(".AAmount").attr('readonly', 'readonly');
    }
}


function PageLoadATravelfareAmount() {
    var a = $("select.ATravelSource option:selected").val();
    if (a == "By Travel Desk") {

        $("select.ATravelSource option:selected").closest('tr').find(".AAmount").removeAttr('readonly');

    }
    else {
        $("select.ATravelSource option:selected").closest('tr').find(".AAmount").attr('readonly', 'readonly');
    }
}

$('.ErdbOther_status').bind("change", function () {
    ShowE();
});

function ShowE() {
    var checkAll = $(".ErdbOther_status:checked").val();
    if (checkAll === "Yes") {
        $(".EDiv").show();
    }
    else {
        $(".EDiv").hide();
    }
   
}

$('.BFreemealDD').bind("change", function () {
    var PercantageAmount = 0, FinalAmount=0;
    var percentage = $(this).closest('tr').find("select.BFreemealDD option:selected").attr("percentage");
    var perdiemrate = $(this).closest('tr').find(".spnperdiemrate").html(); 
    var hdnFirstLast = $(this).closest('tr').find(".hdnFirstLast").val();
    if (parseFloat(hdnFirstLast)>0) {
        FirstAmount = parseFloat(perdiemrate * parseFloat(hdnFirstLast));
    }
    else {
        FirstAmount = parseFloat(perdiemrate);
    }

    PercantageAmount = parseFloat((FirstAmount * percentage) / 100);
    FinalAmount = parseFloat(FirstAmount - PercantageAmount).toFixed(0);
    $(this).closest('tr').find(".bAmount").val(FinalAmount);
    
});

function BCalFreeMealAmount() {
    $("#tblBPerDiem TBODY TR").each(function (i) {
        var PercantageAmount = 0, FinalAmount = 0;
        var percentage = $(this).find("select.BFreemealDD option:selected").attr("percentage");
        var perdiemrate = $(this).find(".spnperdiemrate").html();
        var hdnFirstLast = $(this).find(".hdnFirstLast").val();
        if (parseFloat(hdnFirstLast) > 0) {
            FirstAmount = parseFloat(perdiemrate * parseFloat(hdnFirstLast));
        }
        else {
            FirstAmount = parseFloat(perdiemrate);
        }

        PercantageAmount = parseFloat((FirstAmount * percentage) / 100);
        FinalAmount = parseFloat(FirstAmount - PercantageAmount).toFixed(0);
        $(this).find(".bAmount").val(FinalAmount);

    });
}

$('.AAmount').blur(function () {
    CalculateAll();
});


$('.bAmount').blur(function () {
    CalculateAll();
});

$('.CAmount').blur(function () {
    CalculateAll();
});

$('.DAmount').blur(function () {
    CalculateAll();
});

$('#TravelExpense_amount').blur(function () {
    $("#TravelExpense_anyOther_Credit").val($(this).val());
    CalculateAll();
});

function CalculateAll() {
    ACalculatetotal();
    BCalculatetotal();
    CCalculatetotal();
    DCalculatetotal();
    CalCulateTotal();
    CalcualteNetpayable();
}
function ACalculatetotal() {
    var tempCtotal = 0;
    $(".AAmount").each(function (index) {
        tempCtotal += parseFloat(Number($(this).val()));
    });
    $(".totalA").val(tempCtotal);
}

function BCalculatetotal() {
    var tempCtotal = 0;
    $(".bAmount").each(function (index) {
        tempCtotal += parseFloat(Number($(this).val()));
    });
    $(".totalB").val(tempCtotal);
}

function CCalculatetotal() {
    var tempCtotal = 0;
    $(".CAmount").each(function (index) {
        tempCtotal += parseFloat(Number($(this).val()));
    });
    $(".totalC").val(tempCtotal);
}

function DCalculatetotal() {
    var tempCtotal = 0;
    $(".DAmount").each(function (index) {
        tempCtotal += parseFloat(Number($(this).val()));
    });
    $(".totalD").val(tempCtotal);
}

function CalCulateTotal() {
    var A = Number($(".totalA").val());
    var B = Number($(".totalB").val());
    var C = Number($(".totalC").val());
    var D = Number($(".totalD").val());
    $(".totalFinal").val(A+B+C+D);
}

function CalcualteNetpayable() {
    var A = Number($(".totalFinal").val());
    var B = Number($("#TravelExpense_advance_received").val());
    var C = Number($("#TravelExpense_anyOther_Credit").val());
    $(".Netpayable").val(A + (B - C ));
}