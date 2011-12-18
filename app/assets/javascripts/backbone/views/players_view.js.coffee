class Clock.Views.PlayerView extends Backbone.View
  tagName: 'tr'

  template: JST['backbone/templates/player']

  initialize: =>
    this.model.bind('change', this.render)

  events:
    'mouseover' : 'handleMouseover'
    'mouseout' : 'handleMouseout'
    'click a.rebuy' : 'handleRebuy'
    'click a.addon' : 'handleAddon'
    'click a.sitout' : 'handleSitout'

  handleMouseover: =>
    $(this.el).addClass('hover')

  handleMouseout: =>
    $(this.el).removeClass('hover')

  handleRebuy: =>
    num = this.model.get('rebuys')
    this.model.set({ rebuys: num + 1 })
    return false

  handleAddon: =>
    this.model.set({ addon: true })
    return false

  handleSitout: =>
    this.model.trigger('sitout', this.model)
    return false

  render: =>
    values = this.model.toJSON()
    values['charge'] = this.model.charge()
    $(this.el).html(this.template(values))
    return this

 

class Clock.Views.PlayersView extends Backbone.View
  el: $('#players table')

  initialize: =>
    this.collection = this.model.players
    this.collection.bind('reset', this.render)
    this.collection.bind('add', this.render)
    this.collection.bind('remove', this.render)
    this.model.bind('change:buyin', this.update)
    this.model.bind('change:rebuy', this.update)
    this.model.bind('change:addon', this.update)
    this.render()

  update: =>
    _.each(this.views, (view) -> view.render() )

  addOne: (player) =>
    view = new Clock.Views.PlayerView({ model: player })
    $(this.el).append(view.render().el)
    this.views.push(view)

  render: =>
    _.each(this.views, (view) ->
      view.remove()
    )
    this.views = []
    this.collection.each(this.addOne)
    return this

