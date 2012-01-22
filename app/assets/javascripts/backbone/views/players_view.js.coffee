class Clock.Views.PlayerView extends Backbone.View
  tagName: 'tr'
  className: 'hoverable hoverhighlight'

  template: JST['backbone/templates/player']

  initialize: =>
    this.model.bind('change', this.render)

  events:
    'click a.rebuy' : 'handleRebuy'
    'click a.addon' : 'handleAddon'
    'click a.sitout' : 'handleSitout'

  handleRebuy: =>
    num = this.model.get('rebuys')
    this.model.set({ rebuys: num + 1 })
    false

  handleAddon: =>
    this.model.set({ addon: true })
    false

  handleSitout: =>
    this.model.trigger('sitout', this.model)
    false

  render: =>
    values = this.model.toJSON()
    values['charge'] = this.model.charge()
    values['place'] = this.model.place()
    $(this.el).html(this.template(values))
    this

 

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
    this.el.toggleClass('no-rebuys', !this.model.get('rebuy'))
    this.el.toggleClass('no-addon', !this.model.get('addon'))
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
    this

