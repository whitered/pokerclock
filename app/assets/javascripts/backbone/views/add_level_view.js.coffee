class Clock.Views.AddLevelView extends Backbone.View
  el: $('#levels a.add')

  events:
    'click' : 'handleClick'

  handleClick: =>
    this.model.addNextLevel()
    return false
