
function GetCalenderEventsJson(Doctype) {
    var dataObject = JSON.stringify({
        'Doctype': Doctype
    });
    var data = $.parseJSON($.ajax({
        url: '/CommonAjax/GetCalenderEventsJson',
        dataType: "json",
        contentType: 'application/json',
        type: "Post",
        data: dataObject,
        async: false
    }).responseText);
    return data;

}


document.addEventListener('DOMContentLoaded', function () {
    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {
        headerToolbar: {
            left: 'title',
            center: false,
            right: 'prev,next today',
        },
        firstDay: 1,
        editable: false,
        expandRows: true,
        dayMaxEvents: false,
        events: GetCalenderEventsJson('Leave'),
        eventClassNames: function (arg) {
            return arg.event.extendedProps.classname
        },
       
        eventDidMount: function (info) {
            $(info.el).tooltip({
                title: info.event.extendedProps.description,
                placement: "top",
                trigger: "hover",
                container: "body"
            });

        },
       
    });

    calendar.render();

   
});
