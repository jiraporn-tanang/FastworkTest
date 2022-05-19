*** Settings ***
Documentation       Test Sign-up user and Login user
Library             SeleniumLibrary
Test Teardown       Close All Browsers

*** Variables ***
${URLfw}                https://staging.fastwork.co/
${username}             uatfwtest001
${username_Notfound}    UATFastworkTest01
${f_name}               Jiraporn
${l_name}               Tanang
${email}                uatfw.jiraporn00@gmail.com
${email_google}         uatfw.jiraporn02@gmail.com
${password}             Abc123456
${password_gmail}       Abc1234!
${wrongpassword}        fw1234test
${phonenumber}          0820471758

*** Test Cases ***
TC01 Sign-up Success filling info
    #Verify register new user by filling information is success
    [Tags]      Positive        Register
    Open website
    Goto page Login
    Goto page register
    Wait Until Page Contains        Fastwork
    Filling information
    Checkbox Should Be Selected         TCConsent
    Checkbox Should Be Selected         PPConsent
    Click Element                       xpath=//*[@id="signup-request-form"]/button     #Register button

TC02 Sign-up Success via google account
    #Verify register new user via google-account is success
    [Tags]      Positive        Register
    Open website
    Goto page Login
    Goto page register
    Signup success via google account

    wait until page contains        เงื่อนไขข้อตกลงการใช้บริการ และนโยบายคุ้มครองความเป็นส่วนตัว
    Select Checkbox     TCConsent
    Select Checkbox     PPConsent
    #verify checkbok
    Checkbox Should Be Selected         TCConsent
    Checkbox Should Be Selected         PPConsent
    Click element           xpath=//*[@id="social-consent-request-form"]/button         #click to register


TC03 Sign-up Fail filling info password less than 8characters
    #Verify register new user by filling information with condition input password less than 8 characters
    [Tags]      Negative        Register
    Open website
    Goto page Login
    Goto page register
    Wait until page contains        Fastwork
    Filling information password less than 8character
    Checkbox Should Be Selected         TCConsent
    Checkbox Should Be Selected         PPConsent
    Click element       xpath=//*[@id="signup-request-form"]/button             #Click register button

TC04 Sign-up Failed via google account
    #Verify register new user via google-account is
    [Tags]      Negative        Register
    Open website
    Goto page Login
    Goto page register
    Logon Failed via google account wrong password

TC05 Login succcess
    #Verify login to website derectly
    [Tags]      Positive        Login
    Open website
    Goto page Login
    Logon success by filling email
    Wait until page contains        Fastwork
    sleep   5seconds

TC06 Login Failed not found username
    #Verify login if username not found
    [Tags]      Negative        Login
    Open website
    Goto page Login
    Logon Failed not found username

    #Verify error message
    ${errMsgOnLoginPage}      Get Text        xpath=//*[@id="authorize-request-form"]/div/div
    Should Be Equal As Strings      ${errMsgOnLoginPage}        Incorrect username

TC07 Login Failed password incorrect
    #Verify login if input wrong password // user can not login
    [Tags]      Negative        Login
    Open website
    Goto page Login
    Login Failed password incorrect

    #Verify error message
    ${errMsgPassword}      Get Text        xpath=//*[@id="signin-request-form"]/div/div
    Should Be Equal As Strings      ${errMsgPassword}        Incorrect Password

TC08 Login success via google account
    #Verify login via google account // user can login to website
    [Tags]      Positive        Login
    Open website
    Goto page Login
    Logon success via google account
    sleep   3seconds


TC09 login failed via google account password incorrect
    #Verify login via google account if input wrong password
    [Tags]      Negative        Login
    Open website
    Goto page Login
    Logon Failed via google account wrong password

TC10 Search keyword by English language
    [Tags]      Positive        Search
    Open website
    Input text      q       review
    Click Element       xpath=//*[@id="__next"]/div[1]/header/nav/div[1]/form/div/div/div/i
    Wait until element is visible       xpath=//*[@id="__next"]/div[1]/main/div/div[1]/div
    Sleep   3sec

    ${mgsENG}      Get Text        xpath=//*[@id="__next"]/div[1]/main/div/div[3]/div/div[1]/div[1]/strong
    Log     ${mgsENG}
    Should be equal      ${mgsENG}       “review”

TC11 Search keyword by Thai language
    [Tags]      Positive        Search
    Open website
    Input text      q       ประชาสัมพันธ์
    Click Element       xpath=//*[@id="__next"]/div[1]/header/nav/div[1]/form/div/div/div/i
    Wait until element is visible       xpath=//*[@id="__next"]/div[1]/main/div/div[1]/div
    Sleep   3sec

    ${mgsTH}      Get Text        xpath=//*[@id="__next"]/div[1]/main/div/div[3]/div/div[1]/div[1]/strong
    Log     ${mgsTH}
    Should be equal      ${mgsTH}        “ประชาสัมพันธ์”

TC12 Search keyword by special character
    [Tags]      Positive        Search
    Open website
    Input text      q       (*)
    Click Element       xpath=//*[@id="__next"]/div[1]/header/nav/div[1]/form/div/div/div/i
    Wait until element is visible       xpath=//*[@id="__next"]/div[1]/main/div/div[1]/div
    Sleep   3sec

    ${mgsSpecial}      Get Text        xpath=//*[@id="__next"]/div[1]/main/div/div[3]/div/div[1]/div[1]/strong
    Log         ${mgsSpecial}
    Should be equal      ${mgsSpecial}        “(*)”

*** Keywords ***
Open website
    Open Browser        ${URLfw}      Chrome
    Maximize Browser Window
    WAIT UNTIL PAGE CONTAINS        Fastwork

Goto page Login
    Click Element          xpath=//*[@id="login-link"]          #Log in button

Goto page register
    Click link           Register         #Sign-up button

Filling information
    Input Text          username            ${username}
    Input Text          first_name          ${f_name}
    Input Text          last_name           ${l_name}
    Input Text          email               ${email}
    Input Password      password            ${password}
    Input Password      confirm_password    ${password}
    Input Text          phone_number        ${phonenumber}
    Select Checkbox     TCConsent
    Select Checkbox     PPConsent

Filling information password less than 8character
    Input Text          username            newusertestfw001
    Input Text          first_name          ${f_name}
    Input Text          last_name           ${l_name}
    Input Text          email               vxjufo8p0b@popcornfarm7.com
    Input Password      password            a12345
    Input Password      confirm_password    a12345
    Input Text          phone_number        ${phonenumber}
    Select Checkbox     TCConsent
    Select Checkbox     PPConsent

Logon Failed via google account wrong password
    Click link              partial link:Google
    Input Text              identifier          ${Email_google}
    Click Element           xpath=//*[@id="identifierNext"]/div/button/span           #Next
    Wait until element is visible           xpath=//*[@id="password"]/div[1]/div/div[1]/input
    Input Password          name=password            fw123456@
    Click element           xpath=//*[@id="passwordNext"]/div/button/span           #Next after input password

    #After email input, verify a failed login by a wrong password
    wait until element is visible           xpath=//*[@id="view_container"]/div/div/div[2]/div/div[1]/div/form/span/section/div/div/div[1]/div[2]/div[2]/span
    ${errMsgOnLoginPage}      Get Text        xpath=//*[@id="view_container"]/div/div/div[2]/div/div[1]/div/form/span/section/div/div/div[1]/div[2]/div[2]/span
    Should Be Equal As Strings      ${errMsgOnLoginPage}      รหัสผ่านไม่ถูกต้อง ลองอีกครั้งหรือคลิก "ลืมรหัสผ่าน" เพื่อรีเซ็ตรหัส

Signup success via google account
    Click link              href=https://auth-staging.fastwork.co/auth/google
    Input Text              identifier          ${email}
    Click Element           xpath=//*[@id="identifierNext"]/div/button/span           #Next
    Wait until element is visible           xpath=//*[@id="password"]/div[1]/div/div[1]/input
    Input Password          name=password            ${password_gmail}
    Click element           xpath=//*[@id="passwordNext"]/div/button/span           #Next after input password

Logon success by filling email
    Input Text          Credential          ${username}
    Click element       xpath=//*[@id="authorize-request-form"]/button          #Next
    Input Password      Password            ${password}
    Click element       xpath=//*[@id="signin-request-form"]/button

Logon success via google account
    Click link              href=https://auth-staging.fastwork.co/auth/google
    Input Text              identifier          ${email_google}
    Click Element           xpath=//*[@id="identifierNext"]/div/button/span           #Next
    Wait until element is visible           xpath=//*[@id="password"]/div[1]/div/div[1]/input
    Input Password          name=password            ${password_gmail}
    Click element           xpath=//*[@id="passwordNext"]/div/button/span           #Next after input password

Logon Failed not found username
    Input Text          Credential          ${username_Notfound}
    Click element       xpath=//*[@id="authorize-request-form"]/button          #Next

Login Failed password incorrect
    Input Text          Credential          ${username}
    Click element       xpath=//*[@id="authorize-request-form"]/button          #Next
    Input Password      Password            ${wrongpassword}
    Click Element       xpath=//*[@id="signin-request-form"]/button