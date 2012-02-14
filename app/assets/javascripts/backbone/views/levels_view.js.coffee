class Clock.Views.LevelView extends Backbone.View
  tagName: 'li'

  template: JST["backbone/templates/level"]

  initialize: =>
    this.model.view = this
    $(this.el).html(this.template())
    blindsView = new Clock.Views.EditableView({
      displayElement: this.$('span.hoverable')
      inputElement: this.$('input')
      changeLink: this.$('ul.actions a.change')
      inputText: => this.model.get('small') + '/' + this.model.get('big') + '/' + this.model.get('ante')
      renderValue: =>
        text = this.model.get('small') + ' / ' + this.model.get('big')
        ante = this.model.get('ante')
        this.$('span.blinds').text(text)
        this.$('span.ante').text(if ante > 0 then ' / ' + ante else '')
        this.$('div.ante').text(if ante > 0 then I18n.t('clocks.levels.ante') + ' ' + ante else '')
      update: (value) =>
        matches = value.match(/(\d+)\D*(\d+)?(\D*(\d+))?/)
        if matches?
          this.model.set {
            small: Number(matches[1])
            big: Number(matches[2] or (matches[1] * 2))
            ante: Number(matches[4] or 0)
          }
    })
    this.model.bind('change', blindsView.render)
    this.model.bind('change', this.handleChange)
    this.model.bind('destroy', => this.remove() )

  handleChange: =>
    this.highlight()

  highlight: =>
    this.$('.blinds').effect('highlight', {}, 1000)

  events:
    'click a.remove' : 'handleRemove'
    'click a.apply' : 'handleApply'

  handleRemove: =>
    this.model.destroy()
    false

  handleApply: =>
    this.model.trigger('apply', this.model)
    false



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
    nextElement = this.el.children[this.model.indexOf(level)]
    if nextElement?
      $(nextElement).before(view.el)
    else
      this.el.append(view.el)
    view.highlight()
    this.updateCurrent()

  render: =>
    this.model.each( (level) =>
      view = level.view or new Clock.Views.LevelView({ model: level })
      this.el.append(view.el)
    )
    this.updateCurrent()
    this

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
