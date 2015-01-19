define 'contextFactory', ->
  (prop)->
    @is = -> console.log "#{prop} defined"

    this