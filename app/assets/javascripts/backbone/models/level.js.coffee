class Clock.Models.Level extends Backbone.Model
  defaults:
    small: 25
    big: 50
    ante: 0
    duration: null



class Clock.Collections.LevelsCollection extends Backbone.Collection
  model: Clock.Models.Level

  localStorage: new Store('levels')

  initialize: =>
    this.bind('change', this.handleChange)
    this.bind('add', this.handleAdd)
    this.fetch()

  handleChange: (level) =>
    level.save()
    this.sort()

  handleAdd: (level) =>
    level.save()

  comparator: (level) =>
    level.get('small')

  addNextLevel: =>
    last = this.last()
    this.add(last && {
      small: last.get('big')
      big: last.get('big') * 2
      ante: last.get('ante') * 2
    })
