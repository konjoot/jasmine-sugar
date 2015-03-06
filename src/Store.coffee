define 'Store', ->
  privateStore = {}

  (store)->
    privateStore = store if store?
    privateStore
