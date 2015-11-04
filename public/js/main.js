$(document).ready(function() {
    $(".errors").hide();

    $('#myonoffswitch').change(function() {
        var value = $(this).prop('checked');
        $.post('/update', {on: value})
            .done(function() {
                $(".errors").hide();
            }).fail(function() {
                $(".errors").show();
            });
    })
});
