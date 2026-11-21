*** Settings ***
Library           SeleniumLibrary
Suite Setup       Avaa Lukkarikone
Suite Teardown    Close All Browsers

*** Variables ***
${URL}                https://lukkarikone.xamk.fi/#/schedule
${BROWSER}            chrome
${KUUKAUSI_NAPPI}     css:button.fc-month-button
${VIIKKO_NAPPI}       css:button.fc-agendaWeek-button
${PAIVA_NAPPI}        css:button.fc-agendaDay-button
${OTSIKKO}            css:.fc-toolbar h2
${KUUKAUSI_NAKYMA}    css:.fc-month-view
${VIIKKO_NAKYMA}      css:.fc-agendaWeek-view
${PAIVA_NAKYMA}       css:.fc-agendaDay-view

*** Test Cases ***
Kalenterin Nakymapainikkeet Toimivat
    [Documentation]    Testaa Kuukausi-, Päivä- ja Viikko-painikkeet: jokaisen painalluksen jälkeen oikea painike on
    ...    aktiivinen, oikea kalenterinäkymä näkyy ja otsikon muoto vastaa näkymää.
    # Oletusnäkymä on viikko
    Nakyman Pitaa Olla    ${VIIKKO_NAPPI}    ${VIIKKO_NAKYMA}    ^\\d+\\..*\\d{4}$
    Capture Page Screenshot    nakyma_1_viikko_oletus.png

    Click Button    ${KUUKAUSI_NAPPI}
    Nakyman Pitaa Olla    ${KUUKAUSI_NAPPI}    ${KUUKAUSI_NAKYMA}    ^\\S+ \\d{4}$
    Capture Page Screenshot    nakyma_2_kuukausi.png

    Click Button    ${PAIVA_NAPPI}
    Nakyman Pitaa Olla    ${PAIVA_NAPPI}    ${PAIVA_NAKYMA}    ^\\d+\\. \\S+ \\d{4}$
    Capture Page Screenshot    nakyma_3_paiva.png

    Click Button    ${VIIKKO_NAPPI}
    Nakyman Pitaa Olla    ${VIIKKO_NAPPI}    ${VIIKKO_NAKYMA}    ^\\d+\\..*\\d{4}$
    Capture Page Screenshot    nakyma_4_viikko_takaisin.png

*** Keywords ***
Avaa Lukkarikone
    Open Browser    ${URL}    ${BROWSER}
    ...    options=add_argument("--disable-search-engine-choice-screen");add_argument("--start-maximized")
    Wait Until Element Is Visible    ${VIIKKO_NAPPI}    timeout=30s

Nakyman Pitaa Olla
    [Documentation]    Tarkistaa, että painike on aktiivinen, oikea näkymä on näkyvissä ja otsikko vastaa näkymän muotoa.
    [Arguments]    ${nappi}    ${nakyma}    ${otsikon_muoto}
    Wait Until Element Is Visible    ${nakyma}    timeout=10s
    ${luokat}=    Get Element Attribute    ${nappi}    class
    Should Contain    ${luokat}    fc-state-active
    ${otsikko}=    Get Text    ${OTSIKKO}
    Log    Otsikko: ${otsikko}
    Should Match Regexp    ${otsikko}    ${otsikon_muoto}
