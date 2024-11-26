*** Settings ***
Library        SeleniumLibrary
Library    Dialogs
Library    String
Library    Collections
*** Variables ***
${URL}        https://www.fitpeo.com/
${revenue}    xpath://a[@href='/revenue-calculator']
${sliderthumb}    .MuiSlider-thumb
@{check_boxlist}    CPT-99091    CPT-99453    CPT-99454    CPT-99474
${Totalvalue}    $110700
${Field_Locator}    xpath://input[@type='number']

*** Test Cases ***
Open fitpeo website
    open browser with fitpeo url
    navigate to revenue calculator page  
Test Slider
    Set Slider Position
check text value
    Update and check slider value
check box click
    click checkbox and validate values
validate tolat reccuring
    validate total

*** Keywords ***
open browser with fitpeo url
    Create Webdriver    Chrome
    Maximize Browser Window
    Go To        ${URL}
navigate to revenue calculator page
    Click Element    ${revenue}
Set Slider Position
    Wait Until Element Is Visible    xpath://input[@aria-valuemax="2000"]
    Execute Javascript  window.scrollTo(0,400)
    Sleep    2s
    Drag And Drop By Offset    css:${sliderthumb}    94    0
    # Assign Id To Element    xpath://input[@aria-valuemax='2000']    myid
    # Execute JavaScript    document.getElementById('myid').value=    820;
Update and check slider value
    Wait Until Element Is Visible    ${Field_Locator}
    ${value}=     Get Element Attribute   ${Field_Locator}      value
    ${backspaces count}=    Get Length      ${value}
    Run Keyword If    """${value}""" != ''    
...     Repeat Keyword  ${backspaces count +1}  Press Key  ${Field_Locator}   \\08
    Input Text    xpath://input[@type='number']    520
    Sleep    3s
    ${text}=    Get Value    ${Field_Locator}
    ${slider text}=    Get Value    xpath://input[@aria-valuemax='2000']
    Log    ${slider text}
    Should Be Equal As Integers    ${text}    ${slider text}
click checkbox and validate values
    ${Total}=    Set Variable    0
    ${Total Recurring}    Set Variable    110700
    FOR    ${element}    IN    @{check_boxlist}
        Click Element    xpath://p[text()='${element}']/following-sibling::label[1]
        ${text}=    Get Text    xpath://p[text()='${element}']/following::div[.//span[text()='Recurring in 30 days']]/following-sibling::label
        ${value} =    Convert To Number    ${text}
        ${Total} =    Evaluate    ${Total}+${value}
    END
    ${final}=    Evaluate    ${Total}*30
    Log    ${final}
    Should Be Equal As Integers    ${final}    ${Total Recurring}

validate total
    ${reccuring}    Get Text    xpath://p[text()='Total Recurring Reimbursement for all Patients Per Month:']//child::p[1]
    Log    ${reccuring}
    Run Keyword If  '${reccuring}' == '${Totalvalue}'  Log  both are equal
    ...  ELSE  Log  both are not equal


