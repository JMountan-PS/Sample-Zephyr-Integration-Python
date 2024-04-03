*** Settings ***
Library        DateTime
Library        String

#Impor Robot Framework "Listener"
Resource        ../resources/ZephyrCallout.resource

#These three will be needed to implement a "listener" using only RF syntax
Suite Setup    Setup Work                                                                #Authorize with this call
Test Teardown    Post New Result    ${TEST NAME}    ${TEST STATUS}    ${TEST MESSAGE}    #Update Cycle after test case run

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
    Start New Test Cycle    <EXCEL TEST CYCLE NAME HERE> 

    #Normal Setup Work
    <OPEN BROWSER>
    <LOGIN>
    <ETC>  
