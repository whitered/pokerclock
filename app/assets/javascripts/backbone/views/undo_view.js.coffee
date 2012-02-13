class Clock.Views.UndoView extends Backbone.View
  el: $('#undo')

  template: JST['backbone/templates/undo']

  events:
    'click a.undo' : 'undo'

  initialize: =>
    this.model.bind('change', this.render)

  undo: =>
    this.model.undo()
    false

  render: =>
    if this.model.get('message')
      this.el.html(this.template({ message: this.model.get('message') }))
      alert = this.$('.alert').first()
      alert.alert()
      alert.oneTime(10000, () -> alert.alert('close'))
    else
      this.el.html('')
    this
