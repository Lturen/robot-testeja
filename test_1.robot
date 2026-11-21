*** Settings ***
Library           SeleniumLibrary
Suite Setup       Avaa Lukkarikone
Suite Teardown    Close All Browsers

*** Variables ***
${URL}              https://lukkarikone.xamk.fi/#/schedule
${BROWSER}          chrome
${LANG_BUTTON}      id:lang-change
${LANG_ENGLISH}     xpath://a[contains(@class,'dropdown-item') and normalize-space()='In English']
${LANG_FINNISH}     xpath://a[contains(@class,'dropdown-item') and normalize-space()='Suomeksi']
${TILA}             E101
${HAE_TILOJA}       xpath://label[contains(.,'Hae tiloja')]
${HAKUKENTTA}       css:input[placeholder^='Anna hakusana']
${HAE_NAPPI}        xpath://button[normalize-space()='Hae']
${HAKUTULOS_RIVI}   css:.search-result-row
${LISAA_NAPPI}      css:.search-result-row button.btn-add-row
${KALENTERI_VARAUS}    css:.fc-event

*** Test Cases ***
Sivuston Kielen Vaihto Toimii
    [Documentation]    Vaihtaa kielen suomesta englantiin ja takaisin sekä tarkistaa, että valittu kieli on käytössä.
    Kieli Pitaa Olla    FI    Kalenteri    Kirjaudu sisään
    Capture Page Screenshot    kieli_1_suomi.png
    Vaihda Kieli    ${LANG_ENGLISH}
    Kieli Pitaa Olla    EN    Calendar    Login
    Capture Page Screenshot    kieli_2_englanti.png
    Vaihda Kieli    ${LANG_FINNISH}
    Kieli Pitaa Olla    FI    Kalenteri    Kirjaudu sisään
    Capture Page Screenshot    kieli_3_takaisin_suomeksi.png

Tilahaku Nayttaa Luokan Varaukset
    [Documentation]    Hakee luokan E101 ja tarkistaa, että haku löytää tilan ja kalenterissa näkyvät varaukset kuuluvat siihen.
    ...    (Tehtävänannon MB316 ei ole Xamkin lukkarikoneessa, joten käytetään luokkaa E101.)
    Hae Tila    ${TILA}
    Capture Page Screenshot    tilahaku_1_hakutulos.png
    Page Should Contain Element    ${HAKUTULOS_RIVI}
    Element Should Contain    ${HAKUTULOS_RIVI}    ${TILA}
    Click Button    ${LISAA_NAPPI}
    Wait Until Element Is Visible    ${KALENTERI_VARAUS}    timeout=15s
    Capture Page Screenshot    tilahaku_2_varaukset.png
    ${maara}=    Get Element Count    ${KALENTERI_VARAUS}
    Should Be True    ${maara} > 0    Kalenterissa ei näy yhtään varausta tilalle ${TILA}
    ${ensimmainen}=    Get Text    ${KALENTERI_VARAUS}
    Log    Ensimmäinen varaus: ${ensimmainen}
    Should Contain    ${ensimmainen}    ${TILA}
    Page Should Contain    ${TILA}, Mikkeli

*** Keywords ***
Hae Tila
    [Arguments]    ${hakusana}
    Click Element    ${HAE_TILOJA}
    Input Text    ${HAKUKENTTA}    ${hakusana}
    Click Button    ${HAE_NAPPI}
    Wait Until Element Is Visible    ${HAKUTULOS_RIVI}    timeout=15s

Avaa Lukkarikone
    Open Browser    ${URL}    ${BROWSER}
    ...    options=add_argument("--disable-search-engine-choice-screen");add_argument("--start-maximized")
    Wait Until Element Is Visible    ${LANG_BUTTON}    timeout=30s

Vaihda Kieli
    [Arguments]    ${kieli_valinta}
    Click Button    ${LANG_BUTTON}
    Wait Until Element Is Visible    ${kieli_valinta}
    Click Element    ${kieli_valinta}

Kieli Pitaa Olla
    [Documentation]    Tarkistaa kielipainikkeen tekstin sekä kaksi sivun tekstiä valitulla kielellä.
    [Arguments]    ${koodi}    ${teksti_1}    ${teksti_2}
    Wait Until Element Contains    ${LANG_BUTTON}    ${koodi}    timeout=10s
    Page Should Contain    ${teksti_1}
    Page Should Contain    ${teksti_2}
