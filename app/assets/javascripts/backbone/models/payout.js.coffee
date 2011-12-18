class Clock.Models.Payout extends Backbone.Model
  defaults:
    rate: 0
    percentage: false

  calculate: (money) =>
    rate = this.get('rate')
    if this.get('percentage') then money * rate / 100 else rate

  formula: =>
    rate = this.get('rate')
    if this.get('percentage') then rate + '%' else rate

  value: (bank) =>
    rate = this.get('rate')
    if this.get('percentage') then rate * bank / 100 else rate

  parseString: (str) =>
    md = str.match /(\d+)(%?)/
    if md
      rate = Number(md[1])
      percentage = md[2].length == 1
      this.set({ rate: rate, percentage: percentage })
    return md?



class Clock.Collections.PayoutsCollection extends Backbone.Collection
  model: Clock.Models.Payout

  localStorage: new Store('payouts')

  initialize: =>
    this.bind('add', this.handleAdd)
    this.bind('change', this.handleChange)
    this.fetch()

  handleAdd: (payout) =>
    payout.save()

  handleChange: (payout) =>
    payout.save()


