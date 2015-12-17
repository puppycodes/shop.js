CrowdControl = require 'crowdcontrol'
m = require '../mediator'
Events = require '../Events'
riot = require 'riot'

module.exports = class Control extends CrowdControl.Views.Input
  lookup: 'user.email'

  init: ()->
    if !@input? && @inputs?
      @input = @inputs[@lookup]

    # prevent weird yield bug
    if @input?
      super
  getValue: (event)->
    return $(event.target).val()?.trim()

  error: (err)->
    if err instanceof DOMException
      console.log('WARNING: Error in riot dom manipulation ignored.', err)
      return

    super
    m.trigger Events.ChangeFailed, @input.name, @input.ref.get @input.name

  change: ()->
    super
    m.trigger Events.Change, @input.name, @input.ref.get @input.name

  changed: (value)->
    m.trigger Events.ChangeSuccess, @input.name, value
    riot.update()
