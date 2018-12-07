# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Main class of main_controller.rb application handling the events on `create` route
class Main

  constructor: ->
    @el = $ ".card.fat"
    @events()

    # setTimeout(=> 
    #   @cache().modal.modal 'show'
    # ,1500)
  
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
      modalToken: @el.find '#modal-token'
      apiBtn: @el.find '.btn-bg'
      listapi: @el.find '.list-api'
      searchTerm: @el.find '.search-term'
      tokenInput: @el.find '.token'
    }

  # Set of events to run on document
  events: ->
    @onLoad()
    @onShowPassword()
    @onGetToken()
    @onCloseModal()
    @onShowApis()
    @onAPInputChange()
  
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
    $parent.append $input = $("<input>")
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
      beforeSend: =>
        @el.find('*').prop 'disabled', true
        @el.css 'pointer-events': 'none'
      ,
      contentType: 'application/json',
      headers: 
        'X-CSRF-Token': @getCSRFToken()
      data: JSON.stringify { 
        user: 
          email: email.val(), 
          password: password.val()
      }
    .always =>
      @el.find('*').prop 'disabled', false
      @el.css 'pointer-events': 'unset'

  # Set the api link with the given data, to enable the link work correctly
  setAPILink: ->
    { tokenInput, searchTerm } = @cache()
    debugger;
    @el.find('a[target="_blank"]').each  ->
      @.setAttribute 'href', 
        @.getAttribute('data-template')
        .replace("TERM", searchTerm.val())
        .replace "TOKEN", tokenInput.val()

  # Event to handle when button submit inside form is pressed to get a valid authorization token
  onGetToken: ->
    { submit, tokenInput, modalToken } = @cache()

    submit.on
      click: (e) =>
        e?.preventDefault() 
        @getAuthToken().then ({token}) =>
          tokenInput.val token
          modalToken.modal 'show'

          @setAPILink()

  # Handles the passeye click to show the password as raw text
  onShowPassword: ->
    { passeye, inputs } = @cache()

    passeye.on 
      click: =>
        $input = inputs.password
        $input.prop 'type', if $input.prop('type') is 'password' then 'text' else 'password'
  
  # Handles input changes to mirror the changes to all inputs on the same category
  onAPInputChange: -> 
    { searchTerm, tokenInput } = @cache()
    handler = (e, els) => 
      if e.type is "paste"
        setTimeout(->
          els.val e.target.value
        ,1)
      else
        els.val e.target.value
      @setAPILink()

    searchTerm.on
      keyup: (e) -> handler e, searchTerm
      paste: (e) -> handler e, searchTerm
    
    tokenInput.on
      keyup: (e) -> handler e, token
      paste: (e) -> handler e, token
  
  # Handles the click over the expansor, showing or hidding the api endpoints
  onShowApis: ->
    { listapi, apiBtn, tokenInput, searchTerm } = @cache()

    apiBtn.on 
      click: =>
        isVisibile = listapi.height() is 0

        listapi.animate {
          height: if isVisibile then 150 else 0 
        }, 200

        apiBtn.toggleClass 'btn-expanded', isVisibile

  # Handles the click over the button `close and copy` that will copy the token to clipboard
  onCloseModal: (str) ->
    { modalToken } = @cache()

    handler = => @copyToClipboard modalToken, modalToken.find('textarea').val()
    ($button = modalToken.find('.btn-copy-close')).on
      click: =>
        handler()
        $button.unbind 'click', handler

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
