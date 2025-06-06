*** Settings ***
Library     Browser
Library     DebugLibrary


*** Test Cases ***
Bereken Reserveringsruimte
  New Browser  headless=false
  New Context
  New Page
  Go To  https://new.brandnewday.nl/reserveringsruimte-berekenen/#tool
  Click  //div[@id="consent_prompt_submit"]
  Debug
