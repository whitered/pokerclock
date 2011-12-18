class Clock.Views.AddPlayerView extends Backbone.View
  el: $('#players input.add')

  events:
    'keypress' : 'handleKeyPress'

  handleKeyPress: (event) =>
    return if event.keyCode != 13
    this.model.add({ name: this.el.val() })
    this.el.focus()
    this.el.val('')
