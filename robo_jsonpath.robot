*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary

*** Test Cases ***
Get User Info Simple Log
    # สร้าง session กับ ReqRes API
    Create Session    api    https://reqres.in    disable_warnings=True

    # เรียก API users page 1
    ${response}=    GET On Session    api    /api/users    params=page=1

    # แปลง response เป็น JSON object
    ${json}=    Convert String To Json    ${response.content}

    # ดึงชื่อทั้งหมด
    ${all_names}=    Get Value From Json    ${json}    $.data[*].first_name
    Log    Names: ${all_names}    console=True

    # ดึงอีเมลทั้งหมด
    ${all_emails}=    Get Value From Json    ${json}    $.data[*].email
    Log    Names: ${all_emails}    console=True

    # ดึงชื่อที่ขึ้นต้นด้วย E ทั้งหมด
    ${names_id_more_tree}=    Get Value From Json    ${json}    $.data[?(@.id > 3)].first_name
    Log    Names ID > 3: ${names_id_more_tree}    console=True