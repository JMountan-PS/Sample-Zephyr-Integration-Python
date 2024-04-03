*** Settings ***
Library                      Collections
Library                      String
Library                      RequestsLibrary
Library                      ExcelLibrary
Library                      DateTime

*** Variables ***
${access_token}
${new_cycle_id}
${needs_reporting}
${tc_key}
${time_start}
${time_end}

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
    Set Suite Variable       ${access_token}

Start New Test Cycle
    [Arguments]              ${tc_name}

    #Open Excel Spreadsheet and find the appropriate mapping
    ${doc}=                  Open Excel Document         ../data/Example_tc_map.xlsx                             doc_id=tc_map
    ${tc_names_list}=        Read Excel Column           col_num=1

    #Check if this test case is in the list
    ${needs_reporting}=      Run Keyword And Return Status                           List Should Contain Value                   ${tc_names_list}    ${tc_name}
    Set Suite Variable       ${needs_reporting}
    IF                       ${needs_reporting}

        ${zeroed_index}=     Get Index From List         ${tc_names_list}            ${tc_name}
        ${fixed_index}=      Evaluate                    ${zeroed_index} + 1
        ${tc_key}=           Read Excel Cell             row_num=${fixed_index}      col_num=2
        Set Suite Variable                        ${tc_key}


        ${headers_cycle}=    Create Dictionary           Authorization=${access_token}                           Content-Type=application/json
        Create Session       postsession_cycle           ${base_url1}                headers=${headers_cycle}    verify=true
        ${response_cycle}=                               Post On Session             postsession_cycle
        ...                  /rest/atm/1.0/testrun
        ...                  data={"projectKey": "${tc_key}" ,"name": "DirectOpportunity" ,"folder": "/Delivery/DirectOpportunity"}
        ...                  headers=${headers_cycle}

        ${json}=             Set Variable                ${response_cycle.json()}
        Convert To Dictionary                            ${json}
        ${new_cycle}=        Get value from json         ${json}                     key
        Log To Console       ${new_cycle}[0]
        ${new_cycle_id}=     Set Variable                ${new_cycle}[0]
        Set Suite Variable                               ${new_cycle_id}
    END

    ${time_start}=                        Get Current Date                        result_format=epoch

Post New Result
    [Arguments]              ${tc_name}                  ${tc_status}                ${tc_message}

    IF                       ${needs_reporting}
        ${headers_result}=                               Create Dictionary           Authorization=${access_token}               Content-Type=application/json
        Create Session       postsession                 ${base_url1}                headers=${headers_result}                   verify=true

        ${response_result}=                              Post On Session             postsession
        ...                  /rest/atm/1.0/testrun/${new_cycle_id}/testresults
        ...                  data=[{"status": "${tc_status}" ,"testCaseKey": "${tc_key}" ,"comment": "${tc_message}" ,"executionTime": "1721"}]
        ...                  headers=${headers_result}
    END