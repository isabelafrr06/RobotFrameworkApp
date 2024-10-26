*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${BASE_URL}    http://localhost:5000
${BROWSER}     Firefox

*** Test Cases ***

Open Home Page
    [Tags]    Home
    Open Browser    ${BASE_URL}/home    ${BROWSER}
    Title Should Be    Inicio
    Close Browser

Add Product To Cart
    [Tags]    Cart
    Open Browser    ${BASE_URL}/home    ${BROWSER}
    Click Link    xpath=//a[contains(@href,'/add_to_cart/2')]
    Sleep    2s
    Go To    ${BASE_URL}/cart
    Element Should Contain    xpath=//td[text()='Producto 2']    Producto 2
    Close Browser

Update Product Quantity In Cart
    [Tags]    Cart
    Open Browser    ${BASE_URL}/home    ${BROWSER}
    Click Link    xpath=//a[contains(@href,'/add_to_cart/1')]
    Sleep    2s
    Go To    ${BASE_URL}/cart
    Input Text    xpath=//input[@name='quantity_1']    2
    Click Button    xpath=//button[@name='action' and @value='update']
    Sleep    2s
    Element Should Contain    xpath=//td[text()='$20']    $20
    Close Browser

Remove Product From Cart
    [Tags]    Cart
    Open Browser    ${BASE_URL}/home    ${BROWSER}
    Click Link    xpath=//a[contains(@href,'/add_to_cart/1')]
    Sleep    2s
    Go To    ${BASE_URL}/cart
    Click Button    xpath=//button[@name='action' and @value='remove']
    Sleep    2s
    Element Should Not Be Visible    xpath=//td[text()='Producto 1']    Producto 1
    Close Browser

Reset Cart
    [Tags]    Cart
    Open Browser    ${BASE_URL}/home    ${BROWSER}
    Click Link    xpath=//a[contains(@href,'/add_to_cart/1')]
    Sleep    2s
    Go To    ${BASE_URL}/cart
    Click Link    xpath=//a[contains(@href,'/reset_cart')]
    Sleep    2s
    Element Should Not Be Visible    xpath=//td[text()='Producto 1']    Producto 1
    Close Browser

Verify total price in cart
    [Tags]    Cálculo
    Open Browser    ${BASE_URL}/home    ${BROWSER}
    Click Element   xpath=//a[@href='/add_to_cart/1']
    Click Element   xpath=//a[@href='/add_to_cart/2']
    Go To           ${BASE_URL}/cart
    Input Text      xpath=//input[@name='quantity_1']   2
    Click Button    xpath=//button[@name='action' and @value='update']
    Element Text Should Be   xpath=//h3[@name='total']   Total: $40
    Close Browser

Access Cart Page with No Products
    [Tags]    Cart
    Open Browser    ${BASE_URL}/home    ${BROWSER}
    Go To    ${BASE_URL}/cart
    Page Should Not Contain Element    xpath=//td[contains(text(), 'Producto')]
    Close Browser

Add Multiple Products to Cart
    [Tags]    Cart
    Open Browser    ${BASE_URL}/home    ${BROWSER}
    Click Link    xpath=//a[contains(@href,'/add_to_cart/1')]
    Sleep    1s
    Click Link    xpath=//a[contains(@href,'/add_to_cart/2')]
    Sleep    1s
    Go To    ${BASE_URL}/cart
    Page Should Contain Element    xpath=//td[contains(text(), 'Producto 1')]
    Page Should Contain Element    xpath=//td[contains(text(), 'Producto 2')]
    Close Browser

Login with Correct Credentials
    [Tags]    Login
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Input Text    id=username    admin
    Input Text    id=password    password
    Click Button    xpath=//button[contains(text(), 'Iniciar Sesión')]
    Location Should Be    ${BASE_URL}/home
    Close Browser

Login with Incorrect Credentials
    [Tags]    Login
    Open Browser    ${BASE_URL}/login    ${BROWSER}
    Input Text    name=username    user1
    Input Text    name=password    wrongpassword
    Click Button    xpath=//button[contains(text(), 'Iniciar Sesión')]
    Page Should Contain Element    xpath=//div[contains(text(), 'Credenciales inválidas')]
    Close Browser
