*** Settings ***
Library     Browser
Library     DebugLibrary
Library     JSONLibrary
Library     String
Library     Collections


*** Test Cases ***
Bereken Reserveringsruimte
  New Browser  headless=false
  New Context
  New Page
  Go To  https://new.brandnewday.nl/reserveringsruimte-berekenen/#tool
  Click  //div[@id="consent_prompt_submit"]
  ${json_obj} =  Load Json From File  data.json  encoding=utf-8-sig
  ${jaar_inkomen} =  Get From Dictionary  ${json_obj}  jaarInkomen
  ${geboorte_datum} =  Get From Dictionary  ${json_obj}  geboorteDatum
  ${tabel} =  Get From Dictionary  ${json_obj}  tabel
  FOR  ${object}  IN  @{tabel}
    ${jaar} =  Get From Dictionary  ${object}  jaar
    ${belastbaar_inkomen_vorig_jaar} =  Get From Dictionary  ${object}  belastbaarInkomenVorigJaar
    ${afgetrokken_premie} =  Get From Dictionary  ${object}  afgetrokkenPremie
    ${aegon} =  Get From Dictionary  ${object}  aegon
    ${centraal_beheer} =  Get From Dictionary  ${object}  centraalBeheer
    ${nn} =  Get From Dictionary  ${object}  nn
    ${brand_new_day} =  Get From Dictionary  ${object}  brandNewDay
    # Calculate aangroei vorig jaar
    ${pensioen_aangroei_vorig_jaar} =  Evaluate
    ...  math.floor(float(${aegon}) + float(${centraal_beheer}) + float(${nn}) + float(${brand_new_day}))
    # Fill form
    Fill Text  //input[@id="jaarinkomen_${jaar}"]  ${belastbaar_inkomen_vorig_jaar}
    Fill Text  //input[@id="pensioenaangroei_${jaar}"]  ${pensioen_aangroei_vorig_jaar}
    Fill Text  //input[@id="afgetrokken_${jaar}"]  ${afgetrokken_premie}
  END
  Fill Text  //input[@id="jaarinkomen"]  ${jaar_inkomen}
  Type Text  //input[@id="geboortedatum"]  ${geboorte_datum}
  Debug
  Click  //a[@title="Bereken"]
  Scroll To Element  //div[@id="yearcalculator"]
  Debug
