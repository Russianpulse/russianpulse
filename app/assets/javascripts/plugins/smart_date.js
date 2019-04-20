$(function() {
  $('.smart-date').each(function() {
    var dt = $(this).data('dt');
    $(this).html(timeago.format(dt, 'ru'));

    setInterval(function() {
      $(this).html(timeago.format(dt, 'ru'));
    }.bind(this), 1000);
  });

  var ONE_HOUR = 60 * 60 * 1000; // ms

  moment.locale('ru');
  $('.time-or-date').each(function() {
    var dt = Date.parse($(this).data('dt'));
    var text;

    if(((new Date) - dt) < ONE_HOUR * 12) {
      text = moment(dt).format('HH:mm');
    } else {
      text = moment(dt).format('D MMM');
    }

    $(this).text(text);
  });
});
