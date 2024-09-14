
$(document).ready(function () {
    DatatableScriptsWithColumnSearch("datatable-buttons");

});
$(document).ready(function () {
    DatatableScriptsWithColumnSearch("datatable-buttonss");

});
$(document).ready(function () {
    DatatableScriptsWithColumnSearch("datatable-buttonsss");

});

function DatatableScriptsWithColumnSearch(TableID) {
    $('#' + TableID + ' thead tr:eq(1) th').each(function () {
        var title = $('#' + TableID + ' thead tr:eq(0) th').eq($(this).index()).text();
        $(this).html('<input type="text" placeholder="Search" class="form-control"/>');
    });

    var table = $('#' + TableID + '').DataTable({
        orderCellsTop: true,
        dom: "lBfrtip",
        responsive: false,
        stateSave: true,
        lengthMenu: [
            [10, 25, 50, -1],
            ['10 rows', '25 rows', '50 rows', 'Show all']
        ],
        buttons: [
            'colvis',
            {
                extend: "copy",
                className: "btn-sm"
            }, {
                extend: "csv",
                className: "btn-sm"
            }, {
                extend: "pdf",
                className: "btn-sm"
            }, {
                extend: "print",
                className: "btn-sm"
            },
            {
                extend: "pageLength",
                className: "btn-sm"
            }

        ],
        responsive: true
    });

    // Apply the search
    table.columns().every(function (index) {
        $('#' + TableID + ' thead tr:eq(1) th:eq(' + index + ') input').on('keyup change', function () {
            table.column($(this).parent().index() + ':visible')
                .search(this.value)
                .draw();
        });
    });
}

function DatatableScripts() {

    var table = $('#datatable').DataTable({
        orderCellsTop: true,
        dom: "lBfrtip",
        responsive: false,
        stateSave: true,
        lengthMenu: [
            [10, 25, 50, -1],
            ['10 rows', '25 rows', '50 rows', 'Show all']
        ],
        buttons: [
            'colvis',
            {
                extend: "copy",
                className: "btn-sm"
            }, {
                extend: "csv",
                className: "btn-sm"
            }, {
                extend: "excel",
                className: "btn-sm"
            }, {
                extend: "pdf",
                className: "btn-sm"
            }, {
                extend: "print",
                className: "btn-sm"
            },
            {
                extend: "pageLength",
                className: "btn-sm"
            }],
        responsive: true
    });
}


function DatatableScriptsWithPrintButton() {

    var table = $('#datatable').DataTable({
        orderCellsTop: true,
        dom: "lBfrtip",
        responsive: false,
        stateSave: true,

        lengthMenu: [
            [-1],
            ['Show all']
        ],
        buttons: [
            'colvis',
            {
                extend: "copy",
                className: "btn-sm"
            }, {
                extend: "csv",
                className: "btn-sm"
            }, {
                extend: "pdf",
                className: "btn-sm"
            }, {
                extend: "print",
                className: "btn-sm"
            },
            {
                extend: "pageLength",
                className: "btn-sm"
            }],
        responsive: true
    });
}


function DatatableWithoutPaging(TableID) {
    $('#' + TableID + ' thead tr:eq(1) th').each(function () {
        var title = $('#' + TableID + ' thead tr:eq(0) th').eq($(this).index()).text();
        $(this).html('<input type="text" placeholder="Search" class="form-control"/>');
    });

    var table = $('#' + TableID + '').DataTable({
        "paging": false,
        "ordering": false,
        "info": false
    });

    // Apply the search
    table.columns().every(function (index) {
        $('#' + TableID + ' thead tr:eq(1) th:eq(' + index + ') input').on('keyup change', function () {
            table.column($(this).parent().index() + ':visible')
                .search(this.value)
                .draw();
        });
    });
}


//function UpdateIsActiveJSON(Type, ID, IsActive) {
//    var hdn = $("#hdn_" + ID).val();
//    var Msg = '';
//    var trchange = false;
//    if (IsActive == 1) {
//        var Msg = 'Are you sure want to Activate ' + hdn;
//    }
//    if (IsActive == 0) {
//        var Msg = 'Are you sure want to Deactivate ' + hdn;
//    }

//    ConfirmMsgBox(Msg, '', function () {
//        $('#datatable-buttons tr').each(function () {
//            $(this).find("a").each(function (i) {


//                if ($(this).attr('id') == $("#AIsActive_" + ID).attr('id')) {
//                    trchange = true;
//                }
//            });
//            if (trchange) {
//                if (IsActive == 1) {
//                    $(this).removeClass("trrowred");
//                } else if (IsActive == 0) {
//                    $(this).addClass("trrowred");
//                }
//                trchange = false;
//            }
//        });

//        $.ajax({
//            url: "/CommonAjax/ActiveDeactiveJson",
//            type: "Get",
//            async: true,
//            data: { Type: Type, ID: ID, IsActive: IsActive },
//            success: function (args) {
//                var arr = args.split('::');
//                if (arr[0] != '-1') {
//                    if (parseInt(arr[1]) == 0) {
//                        $("#AIsActive_" + arr[0]).attr("onclick", "UpdateIsActiveJSON(\"" + Type + "\"," + arr[0] + ",1);");
//                        $("#AIsActive_" + arr[0] + " i").attr("class", "fa fa-times-circle crossred");
//                        $("#AIsActive_" + arr[0] + " i").attr("title", "Click to  Activate");
//                    } else {
//                        $("#AIsActive_" + arr[0]).attr("onclick", "UpdateIsActiveJSON(\"" + Type + "\"," + arr[0] + ",0);");
//                        $("#AIsActive_" + arr[0] + " i").attr("class", "fa fa-check-circle checkgreen");
//                        $("#AIsActive_" + arr[0] + " i").attr("title", "Click to  DeActivate");
//                    }

//                }
//            },
//            error: function (er) {
//                alert(er);
//            }
//        });

//    })


//}



