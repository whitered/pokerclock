class Clock.Views.AddPayoutView extends Backbone.View
  el: $('#payouts input.add')

  events:
    'keypress' : 'handleKeyPress'

  handleKeyPress: (event) =>
    return if event.keyCode != 13
    payout = new Clock.Models.Payout
    if payout.parseString(this.el.val())
      this.model.add(payout)
      this.el.focus()
      this.el.val('')
