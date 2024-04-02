*** Settings ***
Library        DateTime
Library        String
# Library        ../libraries/LibraryListener.py
# Library        ../libraries/ZephyrRest.py
Resource        ../resources/ZephyrCallout.resource
Suite Setup    Setup Work
Test Teardown    Post New Result    ${TEST NAME}    ${TEST STATUS}    ${TEST MESSAGE}

*** Variables ***
${randInt}

*** Test Cases ***
Test Case 001
    [Documentation]    This test case will Pass
    ${num}=    Set Variable    1
    Log Variables              level=WARN

Test Case 002
    [Documentation]    This test case will Fail
    Fail



*** Keywords ***
Setup Work
    Authorize Zephyr API
