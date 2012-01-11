class Clock.Views.EditablePropertyView extends Backbone.View

  template: JST['backbone/templates/editable_property']

  initialize: =>
    this.model.bind('change:' + this.options.property, this.render)
    this.options.inputAttributes ||= {}
    this.options.inputAttributes.type ||= 'text'
    doNotChange = (value) -> value
    this.formatInput = this.options.formatInput or doNotChange
    this.formatOutput = this.options.formatOutput or doNotChange
    this.processInput = this.options.processInput or doNotChange
    this.el.addClass('editable')
    this.render()

  events:
    'dblclick' : 'edit'
    'blur input' : 'update'
    'keypress input' : 'updateOnEnter'
    'click a.change': 'edit'

  edit: =>
    input = this.$('input')
    if this.options.adjustInputWidth?
      width = this.$('.display').innerWidth()
      input.css('width', width)
    this.el.addClass('editing')
    input.select()


  update: =>
    this.el.removeClass('editing')
    value = this.processInput(this.$('input').val())
    values = {}
    values[this.options.property] = value
    this.model.set(values)

  updateOnEnter: (event) =>
    return if event.keyCode != 13
    this.update()

  buildInput: (value) =>
    html = '<input'
    _.each(this.options.inputAttributes, (value, key) ->
      html += ' ' + key + '="' + value + '"'
    )
    html += ' value="' + this.formatInput(value) + '"/>'
    html

  render: =>
    value = this.model.get(this.options.property)
    this.el.html(this.template({ 
      value: this.formatOutput(value)
      input: this.buildInput(value)
    }))
    this
