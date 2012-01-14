class Clock.Views.UndoView extends Backbone.View
  el: $('#undo')

  template: JST['backbone/templates/undo']

  events:
    'click a.undo' : 'undo'

  initialize: =>
    this.model.bind('change', this.handleChange)

  handleChange: =>
    this.render()

  undo: =>
    this.model.undo()

  hide: =>
    this.el.fadeOut(2000)

  show: =>
    this.el.fadeIn(200)

  render: =>
    if this.model.get('method')
      this.el.html(this.template({ message: this.model.get('message') }))
      this.show()
      this.el.oneTime(10000, 'hide', this.hide)
      #FIXME: hide is called only once!
    else
      this.el.html('')
    this
