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
