class Clock.Views.EditableView extends Backbone.View

  initialize: =>
    this.displayElement = this.options.displayElement
    this.inputElement = this.options.inputElement
    this.renderValue = this.options.renderValue
    if this.options.changeLink?
      this.options.changeLink.bind('click', this.edit)
    this.displayElement.bind('dblclick', this.edit)
    this.display()

  handleKeyDown: (event) =>
    if event.keyCode == 13
      document.activeElement.blur()
    else if event.keyCode == 27
      this.display()

  display: =>
    this.inputElement.unbind('blur', this.update)
    this.inputElement.unbind('keydown', this.handleKeyDown)
    this.renderValue()
    this.displayElement.show()
    this.inputElement.hide()
    false

  update: =>
    this.options.update(this.inputElement.val())
    this.display()
    false

  edit: =>
    this.inputElement.bind('blur', this.update)
    this.inputElement.bind('keydown', this.handleKeyDown)
    this.inputElement.val(this.options.inputText())
    this.displayElement.hide()
    this.inputElement.show()
    this.inputElement.select()
    false

  render: =>
    this.renderValue()
    this.inputElement.val(this.options.inputText())
    this

