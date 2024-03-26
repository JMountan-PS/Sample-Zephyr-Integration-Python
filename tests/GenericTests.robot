*** Settings ***
Library        DateTime
Library        String
Library        ../libraries/LibraryListener.py
Suite Setup    Set Random Gen

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

Test Case 003
    [Documentation]    This test case *might* pass
    IF  "${randInt}"<"5"    Fail


*** Keywords ***
Set Random Gen
    ${DateTime}=    Get Current Date    result_format=epoch
    Evaluate        random.seed(${DateTime})
    ${randInt}=    Generate Random String    1    chars=[NUMBERS]