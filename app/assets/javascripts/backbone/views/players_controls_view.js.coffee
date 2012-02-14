class Clock.Views.PlayersControlsView extends Backbone.View
  el: $('#players .controls')

  initialize: =>
    this.input = this.$('input')
    this.model.bind('reset', this.render)
    this.model.bind('add', this.render)
    this.model.bind('remove', this.render)
    this.render()

  events:
    'keypress input' : 'handleKeyPress'
    'click ul.dropdown-menu a' : 'handleDeletePlayerClick'

  handleKeyPress: (event) =>
    return if event.keyCode != 13
    name = _.escape(this.input.val())
    this.model.add({ name: name }) unless name.match(/^\s*$/)?
    this.input.focus()
    this.input.val('')

  handleDeletePlayerClick: (event) =>
    cid = event.target.getAttribute('data-playerid')
    if cid == 'all'
      this.model.destroyAll()
    else
      player = this.model.getByCid(cid)
      player.destroy()
    this.$('.btn-group').removeClass('open')
    false

  render: =>
    btn = this.$('a.btn')
    btn.toggleClass('btn-disabled', this.model.length == 0)
    btn.attr('disabled', if this.model.length == 0 then 'disabled' else null)
    ul = this.$('ul')
    ul.empty()
    this.model.each( (player) =>
      ul.append("<li><a href='#' data-playerid='#{player.cid}'>#{player.get('name')}</a></li>")
    )
    if this.model.length > 1
      ul.append("<li class='divider' />")
      ul.append("<li><a href='#' data-playerid='all'>#{I18n.t('clocks.players.remove.all')}</a></li>")
    this
