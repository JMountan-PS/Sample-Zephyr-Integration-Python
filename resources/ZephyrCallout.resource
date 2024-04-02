*** Settings ***
Library    Collections
Library    String
Library    RequestsLibrary


*** Keywords ***
Post New Result
    [Arguments]    ${tc_name}    ${tc_status}    ${tc_message}
    Log To Console               ${tc_name}
    Log To Console               ${tc_status}
    Log To Console               ${tc_message}