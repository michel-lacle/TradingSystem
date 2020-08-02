$(document).ready(function () {

    // get the race results and put them into a table
    $.getJSON("https://z1lull15qf.execute-api.us-east-1.amazonaws.com/prod/get_watch_list", function (watchList) {

        $.each(watchList, function(index, security) {
            var date = security.date;
            var security = security.security;

            $("#watchList").append("<tr><td>" + date + "</td><td>" + security + "</td></tr>");
        });
    });

    // create the race result
    $("button").click(function () {

        var date = $("#date").val();
        var security = $("#security").val();

        var body = {
            "date" : date,
            "security" : security
        };

        $.post("https://z1lull15qf.execute-api.us-east-1.amazonaws.com/prod/watch_security", JSON.stringify(body), function(data) {
            alert("watch security successfully");
        }, "json");
    });
});