define 'contextFactory', ->
  (prop)->
    @letBe = -> console.log "#{prop} defined"

    this