class Clock.Views.IrksomeControlsView extends Backbone.View
  el: $(document)

  initialize: =>
    this.el.mousemove(this.mousemove)

  irksomeHidden: false

  hideIrksome: =>
    this.irksomeHidden = true
    $('.irksome').stop(true, false).fadeTo(5000, 0)

  mousemove: =>
    if this.irksomeHidden
      this.irksomeHidden = false
      $('.irksome').stop(true, false).fadeTo(500, 1)
    this.el.stopTime('hideIrksome', this.hideIrksome)
    this.el.oneTime(30000, 'hideIrksome', this.hideIrksome)
