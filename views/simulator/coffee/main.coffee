$ ->
    styleWidgets()
    preDefs.setTwoHanded()
    updateOnChange()
    $('.simulationDialog').dialog({
      title: "Meta D3 Survival Simulator",
      modal: true,
      height: 650,
      width: 800,
      autoOpen: false
    })

updateOnChange = ->
  $('input').change -> Widgets.updateAll()
  $('select').change -> Widgets.updateAll()

styleWidgets = ->
  $('legend').addClass('ui-corner-all')
  $('fieldset').addClass('ui-corner-all')
