*** Settings ***
Library                QForce
Library                DateTime
Library                Collections
Library                OperatingSystem

#Required import for sending an email through gmail
Library                ../libraries/smtp.py

#Required variable import for the users to receive notifications
Variables              ../data/NotifyList.py


*** Variables ***
${user}                   #Gmail Account being used to send the email 
${APPPASSGMAIL}           #Gmail Account App Pass being used to send the email
${sender}                 #Email Address being used as the name of the sender
${subject}               
${replyTo}                    

*** Keywords ***

Notify Email Recipients
    [Arguments]        ${suite_name}
    [Documentation]    Sends an email notification to everyone on the notify list to let them know test results
    ${subject}=        Set Variable       Test Suite "${suite_name}" Has Completed
    ${body}=           Set Variable       Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ac euismod mi. Nam blandit mollis urna laoreet luctus. Vestibulum \n
    ...                                   efficitur libero orci. Ut lobortis, dolor id scelerisque vulputate, eros dui tempor neque, eu posuere neque felis non erat. In aliquet augue \n
    ...                                   arcu, ac tristique tellus aliquet ut. Vivamus vestibulum metus quis dui rutrum, sed blandit arcu pellentesque. Praesent bibendum fringilla.
    Send Email         ${subject}                  ${body}                   ${sender}              ${notify_list}         ${user}           ${APPPASSGMAIL}


Notify Email Recipients With Attached Reports
    [Documentation]    Attaches log.html, output.xml, and report.html to the email being sent to the notify list
    [Arguments]        ${suite_name}
    ${subject}=        Set Variable       Test Suite "${suite_name}" Has Completed
    ${body}=           Set Variable       Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque ac euismod mi. Nam blandit mollis urna laoreet luctus. Vestibulum \n
    ...                                   efficitur libero orci. Ut lobortis, dolor id scelerisque vulputate, eros dui tempor neque, eu posuere neque felis non erat. In aliquet augue \n
    ...                                   arcu, ac tristique tellus aliquet ut. Vivamus vestibulum metus quis dui rutrum, sed blandit arcu pellentesque. Praesent bibendum fringilla.
    
    #Filepath needs to be given as from the .py file
    @{files}=             Create List    ${OUTPUT_DIR}/log.html     ${OUTPUT_DIR}/report.html    ${OUTPUT_DIR}/output.xml   
    send email Attachments     
    ...                ${subject}                  
    ...                ${body}                   
    ...                ${sender}              
    ...                ${notify_list}         
    ...                ${user}           
    ...                ${APPPASSGMAIL}
    ...                ${files}