$(document).ready(function() {
    $(".errors").hide();

    $('#myonoffswitch').change(function() {
        var value = $(this).prop('checked');
        $.post('/', {on: value})
            .done(function() {
                $(".errors").hide();
            }).fail(function() {
                $(".errors").show();
            });
        $(this).prop('disabled', true);
    })
});
