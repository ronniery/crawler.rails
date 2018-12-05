# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class Main

  constructor: ->
    @el = $ ".card-body"
    @events()
  
  # Can only return the cache elements when the direct dependency @el is fully populated on constuctor
  cache: ->
    passeye: @el.find '#passeye-toggle'
    inputs:
      email: @el.find '#email'
      password: @el.find '#password'
    tooltips: @el.find '[data-toggle="tooltip"]'

  events: ->
    @onLoad()
    @onShowPassword()

  getUser: ->
    $.ajax
      url: 'https://randomuser.me/api/',
      dataType: 'json'
  
  onShowPassword: ->
    { passeye, inputs } = @cache()

    passeye.on 
      click: =>
        $input = inputs.password
        $input.prop 'type', if $input.prop('type') is 'password' then 'text' else 'password'

  onLoad: ->
    { tooltips, inputs } = @cache()

    tooltips.tooltip();
    @getUser().then ({results}) => 
      { email, login: { password } } = results[0]

      inputs.email.val email
      inputs.password.val password

$ ->
  new Main