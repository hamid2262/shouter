 # upload photo for avatar and cover images
$ ->
  $('#cover').hover ->
    $('.cover_upload_form').toggleClass("hover")
  # $('.coverImage').hover ->
  #   $('.cover_upload_form').toggleClass("hover")
  $('.gravatar').hover ->
    $('.avatar_upload_form').toggleClass("hover")

# show and hide submit and file upload button
  $('.avatar_upload_button').change ->
    $(this).hide()
    $('.avatar_upload_submit').show()
    $(this).parent().parent().show()

  $('.cover_upload_button').change ->
    $(this).hide()
    $('.cover_upload_submit').show()
    $(this).parent().parent().show()

  $("#user_cover, #user_avatar").change ->
    $(this).closest("form").submit()