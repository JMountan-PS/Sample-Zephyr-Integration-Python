*** Settings ***
Library               Collections
Library               String
Library               RequestsLibrary

*** Variables ***
${access_token}

*** Keywords ***
Authorize Zephyr API
    ${auth}=          Create List          ${Client_Id_Zephyr}         ${Client_Secret_Zephyr}
    ${headers}=       Create Dictionary    Content-Type=application/x-www-form-urlencoded

    Create Session    mysession            ${base_url}                 ${headers}                  auth=${auth}    verify=true
    ${param}=         Create Dictionary    audience=jire.uberinternal.com                          grant_type=client_credentials    scope=openid
    ${response}=      Post On Session      mysession                        /oauth2/token                        ${param}
    Log To Console    ${response.content}

    ${json}=          Set Variable         ${response.json()}
    Convert To Dictionary                  ${json}
    ${id}=                        Get value from json                      ${json}                        access_token
    Log To Console                ${id}[0]
    ${access_token}=              Set Variable                        Bearer${SPACE}${id}[0]
    Set Global Variable           ${access_token}

Start New Test Cycle
    [Arguments]       ${tc_name}
    
    ${headers_cycle}=    Create Dictionary    Authorization=${access_token}    Content-Type=application/json
    Create Session       postsession_cycle    ${base_url1}                   headers=${headers_cycle}     verify=true
    ${response_cycle}=                        Post On Session                postsession_cycle            
    ...                                       /rest/atm/1.0/testrun
    ...                                       data={"projectKey": "ITEBIZSYS" ,"name": "DirectOpportunity" ,"folder": "/Delivery/DirectOpportunity"}
    ...                                       headers=${headers_cycle}




Post New Result
    [Arguments]       ${tc_name}           ${tc_status}                ${tc_message}