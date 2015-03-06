define 'Store', ->
  privateStore = {} unless privateStore?

  (store)->
    privateStore = store if store?
    privateStore
