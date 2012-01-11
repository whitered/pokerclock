class Clock.Views.LevelView extends Backbone.View
  tagName: 'li'

  template: JST["backbone/templates/level"]

  initialize: =>
    this.model.bind('change', this.handleChange)
    this.model.bind('destroy', this.handleDestroy)
    this.model.view = this
    this.render()

  handleChange: =>
    this.render()
    this.handleMouseout()
    this.highlight()

  handleDestroy: =>
    this.remove()

  highlight: =>
    this.$('.blinds').effect('highlight', {}, 1000)

  events:
    'dblclick .blinds': 'edit'
    'blur .edit input': 'display'
    'keypress .edit input': 'updateOnEnter'
    'click a.remove' : 'handleRemove'
    'click a.apply' : 'handleApply'

  handleRemove: =>
    this.model.destroy()
    return false

  handleApply: =>
    this.model.trigger('apply', this.model)
    return false

  edit: =>
    width = this.$('.blinds').innerWidth()
    $(this.el).addClass('editing')
    this.$('.edit input').css('width', width).select()

  updateOnEnter: (e) =>
    this.display() if(e.keyCode == 13)

  display: =>
    this.model.parseString(this.$('.edit input').val())
    $(this.el).removeClass('editing')

  render: =>
    $(this.el).html(this.template(this.model.toJSON()))
    return this



class Clock.Views.LevelsView extends Backbone.View
  el: $('#levels ul')

  initialize: =>
    this.game = this.options.game
    this.model = this.game.levels
    this.model.bind('add', this.handleAdd)
    this.model.bind('remove', this.updateCurrent)
    this.model.bind('reset', this.render)
    this.game.bind('change:level', this.syncLevel)
    this.render()
    this.syncLevel()

  currentIndex: null
    
  handleAdd: (level) =>
    view = new Clock.Views.LevelView({ model: level })
    element = $(this.el).children[this.model.indexOf(level)]
    if element?
      $(element).before(view.el)
    else
      $(this.el).append(view.el)
    view.highlight()
    this.updateCurrent()

  addOne: (level) =>
    view = level.view or new Clock.Views.LevelView({ model: level })
    $(this.el).append(view.el)

  render: =>
    this.model.each(this.addOne)
    this.updateCurrent()
    return this

  syncLevel: (info) =>
    info ?= this.game.currentLevelInfo()
    this.currentIndex = info.levelIndex
    this.updateCurrent()

  updateCurrent: =>
    return unless this.currentIndex?

    this.$('.current').removeClass('current')
    this.$('.next').removeClass('next')

    currentView = this.model.at(this.currentIndex)?.view
    nextView = this.model.at(this.currentIndex + 1)?.view

    $(currentView.el).addClass('current') if currentView?
    $(nextView.el).addClass('next') if nextView?
