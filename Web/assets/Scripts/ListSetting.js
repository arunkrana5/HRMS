
$(document).ready(function () {
    
    DatatableScripts();
    
});


function DatatableScripts_ByID(ID) {
    
    var table = $('#' + ID+'').DataTable({
        orderCellsTop: true,
        dom: "lBfrtip",
        responsive: false,

        lengthMenu: [
            [10, 25, 50, -1],
            ['10 rows', '25 rows', '50 rows', 'Show all']
        ],
        buttons: [
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
        responsive: false
    });
}



function ExportTableDatatableScripts() {

    var table = $('#ExportTable').DataTable({
        orderCellsTop: true,
        dom: "lBfrtip",
        responsive: false,

        lengthMenu: [
            [-1],
            ['Show all']
        ],
        buttons: [
            {
                extend: "csv",
                className: "btn-sm"
            }, {
                extend: "excel",
                className: "btn-sm"
            }
        ],
        responsive: false
    });
}


function DatatableScriptsWithColumnSearch(TableID) {
    $('#' + TableID + ' thead tr:eq(1) th').each(function () {
        var title = $('#' + TableID + ' thead tr:eq(0) th').eq($(this).index()).text();
        $(this).html('<input type="text" placeholder="Search" class="form-control"/>');
    });

    var table = $('#' + TableID + '').DataTable({
        orderCellsTop: true,
        dom: "lBfrtip",
        responsive: false,

        lengthMenu: [
            [10, 25, 50, -1],
            ['10 rows', '25 rows', '50 rows', 'Show all']
        ],
        buttons: [
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
        //$('#' + TableID + ' thead tr:eq(1) th:eq(' + index + ') input').mouseleave(function () {
        //    $(this).blur();
        //}); 
    });
}

function DatatableScripts() {

    var table = $('#example').DataTable({
        orderCellsTop: true,
        dom: "lBfrtip",
        responsive: false,

        lengthMenu: [
            [10, 25, 50, -1],
            ['10 rows', '25 rows', '50 rows', 'Show all']
        ],
        buttons: [
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
        responsive: false
    });
}


function DatatableScriptsWithPrintButton() {

    var table = $('#datatable').DataTable({
        orderCellsTop: true,
        dom: "lBfrtip",
        responsive: false,
      
        lengthMenu: [
            [ -1],
            ['Show all']
        ],
        buttons: [
            {
                extend: "copy",
                className: "btn-sm"
            }, {
                extend: "csv",
                className: "btn-sm"
            },  {
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

function UpdatePriority(Obj, ID, Type) {

    $.ajax({
        url: "/CommonAjax/UpdatePriorityJSon",
        type: "Get",
        async: true,
        data: { ID: ID, Value: Obj.value, Type: Type },
        success: function (data) {
            if (data == 0) {
                $('#txtPriority_' + ID).css('border', '2px solid red');
            }
            else {
                $('#txtPriority_' + ID).css('border', '2px solid Green');
            }
        },
        error: function (er) {
            alert(er);
        }
    });
}

function UpdateIsActiveJSON(Type, ID, IsActive) {
    var hdn = $("#hdn_" + ID).val();
    var Msg = '';
    var trchange = false;
    if (IsActive == 1) {
        var Msg = 'Are you sure want to Activate ' + hdn;
    }
    if (IsActive == 0) {
        var Msg = 'Are you sure want to Deactivate ' + hdn;
    }

    ConfirmMsgBox(Msg, '', function () {
        $('#datatable-buttons tr').each(function () {
            $(this).find("a").each(function (i) {


                if ($(this).attr('id') == $("#AIsActive_" + ID).attr('id')) {
                    trchange = true;
                }
            });
            if (trchange) {
                if (IsActive == 1) {
                    $(this).removeClass("trrowred");
                } else if (IsActive == 0) {
                    $(this).addClass("trrowred");
                }
                trchange = false;
            }
        });

        $.ajax({
            url: "/CommonAjax/ActiveDeactiveJson",
            type: "Get",
            async: true,
            data: { Type: Type, ID: ID, IsActive: IsActive },
            success: function (args) {
                var arr = args.split('::');
                if (arr[0] != '-1') {
                    if (parseInt(arr[1]) == 0) {
                        $("#AIsActive_" + arr[0]).attr("onclick", "UpdateIsActiveJSON(\"" + Type + "\"," + arr[0] + ",1);");
                        $("#AIsActive_" + arr[0] + " i").attr("class", "fa fa-times-circle crossred");
                        $("#AIsActive_" + arr[0] + " i").attr("title", "Click to  Activate");
                    } else {
                        $("#AIsActive_" + arr[0]).attr("onclick", "UpdateIsActiveJSON(\"" + Type + "\"," + arr[0] + ",0);");
                        $("#AIsActive_" + arr[0] + " i").attr("class", "fa fa-check-circle checkgreen");
                        $("#AIsActive_" + arr[0] + " i").attr("title", "Click to  DeActivate");
                    }

                }
				
				 $('[data-toggle="tooltip"]').tooltip();   
            },
            error: function (er) {
                alert(er);
            }
        });

    })


}




function UpdateOtherFieldJSON(Type, ID, IsActive,obj) {
    var hdn = $("#hdn_" + ID).val();
    var Msg = '';
    var trchange = false;
    if (IsActive == 1) {
        var Msg = 'Are you sure want to Activate Applying District' + hdn;
    }
    if (IsActive == 0) {
        var Msg = 'Are you sure want to Deactivate Applying District' + hdn;
    }

    ConfirmMsgBox(Msg, '', function () {
        $.ajax({
            url: "/CommonAjax/ActiveDeactiveJson",
            type: "Get",
            data: { Type: Type, ID: ID, IsActive: IsActive },
            success: function (args) {
                var arr = args.split('::');
                if (arr[0] != '-1') {
                    if (parseInt(arr[1]) == 0) {
                        $(obj).addClass('colorred').removeClass("colorgreen");
                        $(obj).attr("OP", "1");
                        $(obj).attr("title", "Click to  Activate");
                    } else {
                        $(obj).addClass('colorgreen').removeClass("colorred");
                        $(obj).attr("OP", "0");
                        $(obj).attr("title", "Click to  DeActivate");
                    }

                }

                $('[data-toggle="tooltip"]').tooltip();
            },
            error: function (er) {
                alert(er);
            }
        });

    })


}
