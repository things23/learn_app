$ ->
  start_time = new Date()
  $('.form-submit').click ->
    delta = new Date() - start_time
    $('input[name="time"]').val(delta)