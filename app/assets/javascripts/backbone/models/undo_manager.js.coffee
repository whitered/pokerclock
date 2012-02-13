class Clock.Models.UndoManager extends Backbone.Model
  defaults:
    action: null
    message: null

  add: (object, method, params, message) =>
    params = [params] unless params == null || params is Array
    this.set {
      action: -> method.apply(object, params)
      message: message
    }


  addAction: (message, action) =>
    this.set {
      action: action
      message: message
    }

  undo: =>
    this.get('action').apply(null)
    this.clear()
  
