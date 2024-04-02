*** Settings ***
Library               Collections
Library               String
Library               RequestsLibrary

*** Variables ***
${access_token}

*** Keywords ***
Authorize Zephyr API
    [Arguments]       ${tc_name}           ${tc_status}                ${tc_message}

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
