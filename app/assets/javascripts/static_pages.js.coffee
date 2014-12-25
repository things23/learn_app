$ ->
  start_time = new Date()
  $('.form-submit').click ->
    time_for_answer = new Date() - start_time
    alert time_for_answer
    $('input[name="time"]').val(time_for_answer)