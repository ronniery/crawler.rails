# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Main class of main_controller.rb application handling the events on `create` route
class Main

  constructor: ->
    @el = $ ".card-body"
    @events()

    setTimeout(=> 
      @cache().modal.modal 'show'
    ,1500)
  
  # Can only return the cache elements when the direct dependency @el is fully populated on constuctor
  cache: ->
    if $.isEmptyObject @cached
      @cached 

    @cached = {
      passeye: @el.find '#passeye-toggle'
      inputs:
        email: @el.find '#email'
        password: @el.find '#password'
      tooltips: @el.find '[data-toggle="tooltip"]'
      submit: @el.find '.login-form #get-token'
      modal: @el.find '#modal-token'
    }

  # Set of events to run on document
  events: ->
    @onLoad()
    @onShowPassword()
    @onGetToken()
  
  # Get an valid user from `randomuser.me
  getUser: ->
    { inputs: { email, password }, passeye } = @cache()

    $.ajax
      url: 'https://randomuser.me/api/',
      dataType: 'json',
      success: =>
        email.prop 'disabled', false
        password.prop 'disabled', false
        passeye.removeClass 'btn-disabled'
  
  # Get from document the crfs-token
  getCSRFToken: -> $('[name="csrf-token"]').prop 'content'

  # Copy a given string to clipboard
  copyToClipboard: ($parent, str) ->
    $parent.append $input = $("<input type='hidden'>")
    $input.val(str).select()
    document.execCommand("copy")
    $input.remove()

  # Use the given user data to generate an authorization token (JWT)
  getAuthToken: ->
    { inputs: { email, password } } = @cache()

    if email.val() is "" or password.val() is ""
      return

    $.ajax
      url: '/create',
      method: 'POST',
      dataType: 'json',
      contentType: 'application/json',
      headers: 
        'X-CSRF-Token': @getCSRFToken()
      data: JSON.stringify { 
        user: 
          email: email.val(), 
          password: password.val()
      }

  # Event to handle when button submit inside form is pressed to get a valid authorization token
  onGetToken: ->
    { submit } = @cache()

    submit.on
      click: (e) =>
        e?.preventDefault() 
        @getAuthToken().then ({authorization}) ->
          localStorage.setItem 'auth_token', authorization

  # Handles the passeye click to show the password as raw text
  onShowPassword: ->
    { passeye, inputs } = @cache()

    passeye.on 
      click: =>
        $input = inputs.password
        $input.prop 'type', if $input.prop('type') is 'password' then 'text' else 'password'

  # Run some code when the page fully loads
  onLoad: ->
    { tooltips, inputs } = @cache()

    tooltips.tooltip()
    @getUser().then ({results}) => 
      { email, login: { password } } = results[0]

      inputs.email.val email
      inputs.password.val password

$ ->
  new Main
