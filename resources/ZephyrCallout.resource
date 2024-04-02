*** Settings ***
Library                      Collections
Library                      String
Library                      RequestsLibrary

*** Variables ***
${access_token}
${new_cycle_id}

*** Keywords ***
Authorize Zephyr API
    ${auth}=                 Create List                 ${Client_Id_Zephyr}         ${Client_Secret_Zephyr}
    ${headers}=              Create Dictionary           Content-Type=application/x-www-form-urlencoded

    Create Session           mysession                   ${base_url}                 ${headers}                  auth=${auth}    verify=true
    ${param}=                Create Dictionary           audience=jire.uberinternal.com                          grant_type=client_credentials    scope=openid
    ${response}=             Post On Session             mysession                   /oauth2/token               ${param}
    Log To Console           ${response.content}

    ${json}=                 Set Variable                ${response.json()}
    Convert To Dictionary    ${json}
    ${id}=                   Get value from json         ${json}                     access_token
    Log To Console           ${id}[0]
    ${access_token}=         Set Variable                Bearer${SPACE}${id}[0]
    Set Suite Variable      ${access_token}

Start New Test Cycle
    [Arguments]              ${tc_name}

    ${headers_cycle}=        Create Dictionary           Authorization=${access_token}                           Content-Type=application/json
    Create Session           postsession_cycle           ${base_url1}                headers=${headers_cycle}    verify=true
    ${response_cycle}=       Post On Session             postsession_cycle
    ...                      /rest/atm/1.0/testrun
    ...                      data={"projectKey": "ITEBIZSYS" ,"name": "DirectOpportunity" ,"folder": "/Delivery/DirectOpportunity"}
    ...                      headers=${headers_cycle}

    ${json}=                 Set Variable                ${response_cycle.json()}
    Convert To Dictionary    ${json}
    ${new_cycle}=            Get value from json         ${json}                     key
    Log To Console           ${new_cycle}[0]
    ${new_cycle_id}=         Set Variable                ${new_cycle}[0]
    Set Suite Variable      ${new_cycle_id}


Post New Result
    [Arguments]              ${tc_name}                  ${tc_status}                ${tc_message}
    
    ${headers_result}=       Create Dictionary           Authorization=${access_token}     Content-Type=application/json
    Create Session           postsession                 ${base_url1}                      headers=${headers_result}    verify=true

    ${response_result}=      Post On Session             postsession                       
    ...                                              /rest/atm/1.0/testrun/${new_cycle_id}/testresults
    ...                                              data=[{"status": "Pass" ,"testCaseKey": "ITEBIZSYS-T1903" ,"comment": "Testcase executed successfully" ,"executionTime": "1721"}]
    ...                                              headers=${headers_result}