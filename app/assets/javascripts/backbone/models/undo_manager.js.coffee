class Clock.Models.UndoManager extends Backbone.Model
  defaults:
    object: null
    method: null
    params: null
    message: null

  add: (object, method, params, message) =>
    params = [params] unless params == null || params is Array
    this.set({ 
      object: object
      method: method
      params: params
      message: message
    })

  undo: =>
    this.get('method').apply(this.get('object'), this.get('params'))
    this.clear()
  
