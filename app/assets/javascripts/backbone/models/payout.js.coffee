class Clock.Models.Payout extends Backbone.Model
  defaults:
    place: null
    rate: 0
    percentage: false

  calculate: (money) =>
    rate = this.get('rate')
    if this.get('percentage') then money * rate / 100 else rate

  formula: =>
    rate = this.get('rate')
    if this.get('percentage') then rate + '%' else I18n.toCurrency(rate)

  value: (bank) =>
    rate = this.get('rate')
    if this.get('percentage') then rate * bank / 100 else rate

  parseString: (str) =>
    md = str.match /(\d+)\s*(%?)/
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
    this.bind('remove', this.handleRemove)
    this.fetch()

  handleAdd: (payout) =>
    payout.set({ place: this.length + 1 })

  handleChange: (payout) =>
    payout.save()
    this.sort()

  handleRemove: (payout) =>
    nextPayouts = this.filter( (p) => p.get('place') > payout.get('place') )
    _.each(nextPayouts, (p) => p.set({ place: p.get('place') - 1 }))

  moveUp: (payout) =>
    this.swap(this.at(this.indexOf(payout) - 1), payout)

  moveDown: (payout) =>
    this.swap(payout, this.at(this.indexOf(payout) + 1))

  swap: (a, b) =>
    return unless a? && b?
    p = a.get('place')
    a.set({ place: b.get('place') })
    b.set({ place: p })

  comparator: (payout) =>
    payout.get('place')

  setOrder: (cids) =>
    payouts = cids.map( (cid) => this.getByCid(cid) )
    _.each(payouts, (payout, index) =>
      payout.set({ place: index + 1 })
    )
    this.sort()


