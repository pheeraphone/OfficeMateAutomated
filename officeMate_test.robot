**Settings***
Library    SeleniumLibrary
Library    RequestsLibrary

***Variables***
${lbl_search_box}    xpath=//*[@data-testid="txt-SearchBar"]
${icon_search}    xpath=//*[@id="btn-searchResultPage"]
${lbl_result_search}    xpath=//*[@data-testid="pnl-productGrid"]
${url_office_mate}    https://www.officemate.co.th/en
${btn_close_notification_content}    xpath=(//*[@id="question-group-form"]/following::div[contains(@id,"close-button")])[1]
${iframe_notification_content}    xpath=//iframe[contains(@classname,"sp-fancybox-iframe")]
  
***Test Cases***
Jira-001 Validate search feature when user already input wording and click on search icon   
    [Tags]    regression
    Visit website office mate
    Input in search box    Computer
    Click search icon
    Verify result search
    [Teardown]    Close Browser

Jira-002 Validate api/search/products when send request success
    [Tags]    regression
    ${response}    Send get request search product    searchWording=Computer
    Verify response search product     ${response}
 
***Keywords***
Visit website office mate
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method     ${options}    add_argument    --disable-notifications
    Open Browser	${url_office_mate}	   Chrome    options=${options}  
    Wait Until Element Is Visible    ${iframe_notification_content}
    Select Frame	${iframe_notification_content}
    Wait Until Element Is Visible    ${btn_close_notification_content}    10s
    Click Element    ${btn_close_notification_content}
    Unselect Frame
    Capture Page Screenshot    homePage.png

Input in search box
    [Arguments]    ${input_wording}
    Wait Until Element Is Visible    ${lbl_search_box}
    Input Text    ${lbl_search_box}    ${input_wording}
    Capture Page Screenshot    inputSearch.png

Click search icon
    Click Element    ${icon_search}

Verify result search
    Wait Until Element Is Visible    ${lbl_result_search}
    Element Should Be Visible    ${lbl_result_search}
    Capture Page Screenshot    ResultPage.png

Send get request search product
    [Arguments]    ${searchWording}
    ${param}    Set variable    searchQuery=${searchWording}&limit=45
    ${headers}=    Create Dictionary    Content-Type=application/json
    ...    x-store-code=en
    Create Session    office_mate    https://www.officemate.co.th/api/
    ${response}    Get Request    office_mate    search/products?${param}    headers=${headers}
    [Return]    ${response}

Verify response search product
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    200
    Should Not Be Empty    ${response.json()} 
    log    ${response.json()}
