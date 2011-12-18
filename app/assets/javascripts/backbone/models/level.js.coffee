class Clock.Models.Level extends Backbone.Model
  defaults:
    small: 1
    big: 2
    duration: null

  parseString: (value) =>
    matches = value.match(/(\d+)\D*(\d+)?/)
    this.set({ small: Number(matches[1]), big: Number(matches[2] || (matches[1] * 2)) }) if matches?



class Clock.Collections.LevelsCollection extends Backbone.Collection
  model: Clock.Models.Level

  localStorage: new Store('levels')

  initialize: =>
    this.bind('change', this.handleChange)
    this.bind('add', this.handleAdd)
    this.fetch()

  handleChange: (level) =>
    this.sort()
    level.save()

  handleAdd: (level) =>
    level.save()

  comparator: (level) =>
    return level.get('small')

  addNextLevel: =>
    last = this.last()
    this.add(last && {
      small: last.get('big'),
      big: last.get('big') * 2
    })
