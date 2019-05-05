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
  var dt = moment($(this).data('dt'));
  var text;

  if(dt > moment().subtract(12, 'hours')) {
    text = moment(dt).format('HH:mm');
  } else if(dt > moment().subtract(6, 'months')) {
    text = moment(dt).format('D MMM');
  } else {
    text = moment(dt).format('D MMM YYYY');
  }

  $(this).text(text);
});
