*** Settings ***
Library        DateTime
Library        String
#Library        ../Libraries/StatusListener.py
Suite Setup    Set Random Gen

*** Variables ***
${randInt}

*** Test Cases ***
This Test case will pass
    Log To Console        Filler Text Pass Case
    Log Variables         level=WARN

This Test case will fail
    Log To Console        Filler Text Fail Case
    Fail

This Test case will be random
    Log To Console        Filler Text Unknown Case
    IF  "${randInt}"<"5"    Fail


*** Keywords ***
Set Random Gen
    ${DateTime}=    Get Current Date    result_format=epoch
    Evaluate    random.seed(${DateTime})
    ${randInt}=    Generate Random String    1    chars=[NUMBERS]