#confirm every field is valid, mostly should be 0

class window.Validator
  this.isNumber = (n) ->
    !isNaN(parseFloat(n)) && isFinite(n)
  
  this.correctInputField = (field) ->
    if !Validator.isNumber(field.value)
      field.value = 0 
      
  this.correctInvalidValues = ->
    Validator.correctInputField field for field in $('.widgetsContainer input')
      
  this.isValidCombatStyle = ->
    if Player.isShield() && Player.isDualwield() then false else true
