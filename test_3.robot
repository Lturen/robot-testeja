*** Settings ***
Library           SeleniumLibrary
Test Setup        Avaa Lukkarikone
Test Teardown     Close All Browsers

*** Variables ***
${URL}                https://lukkarikone.xamk.fi/#/schedule
${BROWSER}            chrome
${KIRJAUTUMIS_NAPPI}  xpath://button[contains(., 'Kirjaudu sisään')]
${VIIKKO_NAPPI}       css:button.fc-agendaWeek-button
# Microsoft-kirjautumissivun kentät
${MS_SAHKOPOSTI}      id:i0116
${MS_SALASANA}        id:i0118
${MS_SEURAAVA}        id:idSIButton9
${MS_VIRHE}           id:usernameError
# Oikeat tunnukset annetaan komentoriviltä: --variable USERNAME:... --variable PASSWORD:...
${USERNAME}           ${EMPTY}
${PASSWORD}           ${EMPTY}

*** Test Cases ***
Kirjaudu Sisaan Painike Ohjaa Microsoft Kirjautumiseen
    [Documentation]    Painike "Kirjaudu sisään" vie Microsoftin kirjautumissivulle, jossa on sähköpostikenttä.
    Klikkaa Kirjaudu Sisaan
    Location Should Contain    login.microsoftonline.com
    Element Should Be Visible    ${MS_SAHKOPOSTI}
    Capture Page Screenshot    kirjautuminen_1_microsoft.png

Kirjautuminen Epaonnistuu Vaaralla Kayttajatunnuksella
    [Documentation]    Olematon käyttäjätunnus ei pääse eteenpäin, vaan sivu näyttää virheilmoituksen.
    Klikkaa Kirjaudu Sisaan
    Input Text    ${MS_SAHKOPOSTI}    olematon.kayttaja.12345@xamk.fi
    Click Element    ${MS_SEURAAVA}
    Wait Until Element Is Visible    ${MS_VIRHE}    timeout=15s
    Element Should Not Be Visible    ${MS_SALASANA}
    Capture Page Screenshot    kirjautuminen_2_vaara_tunnus.png

Kirjautuminen Onnistuu Oikeilla Tunnuksilla
    [Documentation]    Vaatii oikeat tunnukset (--variable USERNAME / PASSWORD). Ohitetaan, jos tunnuksia ei ole annettu.
    ...    Ei toimi tilillä, jolla on monivaihetunnistus (MFA), ellei sitä hyväksytä käsin.
    Skip If    '${USERNAME}' == '' or '${PASSWORD}' == ''    Tunnuksia ei annettu
    Klikkaa Kirjaudu Sisaan
    Input Text    ${MS_SAHKOPOSTI}    ${USERNAME}
    Click Element    ${MS_SEURAAVA}
    Wait Until Element Is Visible    ${MS_SALASANA}    timeout=15s
    Input Password    ${MS_SALASANA}    ${PASSWORD}
    Click Element    ${MS_SEURAAVA}
    # "Pysytkö kirjautuneena?" -kysymys -> Ei
    Wait Until Element Is Visible    ${MS_SEURAAVA}    timeout=15s
    Click Element    id:idBtn_Back
    Wait Until Location Contains    lukkarikone.xamk.fi    timeout=30s
    Wait Until Element Is Visible    ${VIIKKO_NAPPI}    timeout=30s
    Page Should Not Contain Button    ${KIRJAUTUMIS_NAPPI}
    Capture Page Screenshot    kirjautuminen_3_onnistui.png

*** Keywords ***
Avaa Lukkarikone
    Open Browser    ${URL}    ${BROWSER}
    ...    options=add_argument("--disable-search-engine-choice-screen");add_argument("--start-maximized")
    Wait Until Element Is Visible    ${KIRJAUTUMIS_NAPPI}    timeout=30s

Klikkaa Kirjaudu Sisaan
    Click Button    ${KIRJAUTUMIS_NAPPI}
    Wait Until Element Is Visible    ${MS_SAHKOPOSTI}    timeout=30s
