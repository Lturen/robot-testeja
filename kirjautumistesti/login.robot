*** Settings ***
Library           SeleniumLibrary
Resource          variables.robot
Suite Teardown    Close All Browsers

*** Variables ***
${USERNAME_FIELD}    css:input[name="username"]
${PASSWORD_FIELD}    css:input[type="password"]
${LOGIN_BUTTON}      css:button, input[type="submit"]

*** Test Cases ***
Kirjautuminen Onnistuu Oikeilla Tunnuksilla
    Avaa Selain Kirjautumissivulle
    Syota Tunnukset    ${username}    ${password}
    Click Button    ${LOGIN_BUTTON}
    Page Should Contain    Welcome, ${username}!
    Capture Page Screenshot

*** Keywords ***
Avaa Selain Kirjautumissivulle
    Open Browser    ${serverurl}    ${browser}
    ...    options=add_argument("--disable-search-engine-choice-screen");add_argument("--start-maximized")
    Wait Until Element Is Visible    ${USERNAME_FIELD}

Syota Tunnukset
    [Arguments]    ${user}    ${pass}
    Input Text        ${USERNAME_FIELD}    ${user}
    Input Password    ${PASSWORD_FIELD}    ${pass}
