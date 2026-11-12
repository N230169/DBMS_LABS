SET SERVEROUTPUT ON;
CREATE TABLE Developers (
    DeveloperID   NUMBER(10) PRIMARY KEY,
    DeveloperName VARCHAR2(60) NOT NULL,
    Country       VARCHAR2(30),
    FoundedYear   NUMBER(4)
);

CREATE TABLE Publishers (
    PublisherID   NUMBER(10) PRIMARY KEY,
    PublisherName VARCHAR2(60),
    HeadOffice    VARCHAR2(40),
    SupportEmail  VARCHAR2(60)
);

CREATE TABLE Categories (
    CategoryID   NUMBER(10) PRIMARY KEY,
    CategoryName VARCHAR2(40),
    MinimumAge   NUMBER(3)
);

CREATE TABLE Apps (
    AppID       NUMBER(10) PRIMARY KEY,
    AppName     VARCHAR2(60),
    DeveloperID NUMBER(10),
    PublisherID NUMBER(10),
    CategoryID  NUMBER(10),
    Rating      NUMBER(2,1),
    Downloads   NUMBER(10),
    Price       NUMBER(6,2)
);


INSERT INTO Developers VALUES (101, 'Google LLC', 'USA', 1998);
INSERT INTO Developers VALUES (102, 'Meta Platforms', 'USA', 2004);
INSERT INTO Developers VALUES (103, 'Spotify AB', 'Sweden', 2006);
INSERT INTO Developers VALUES (104, 'Canva Pty Ltd', 'Australia', 2012);
INSERT INTO Developers VALUES (105, 'BYJU''S', 'India', 2011);

INSERT INTO Publishers VALUES (201, 'Google Play', 'California', 'support@google.com');
INSERT INTO Publishers VALUES (202, 'Samsung Galaxy Store', 'Seoul', 'support@samsung.com');
INSERT INTO Publishers VALUES (203, 'Huawei AppGallery', 'Shenzhen', 'support@huawei.com');
INSERT INTO Publishers VALUES (204, 'Amazon Appstore', 'Seattle', 'support@amazon.com');

INSERT INTO Categories VALUES (301, 'Education', 3);
INSERT INTO Categories VALUES (302, 'Productivity', 3);
INSERT INTO Categories VALUES (303, 'Music', 12);
INSERT INTO Categories VALUES (304, 'Social', 13);
INSERT INTO Categories VALUES (305, 'Gaming', 16);

INSERT INTO Apps VALUES (1001, 'Google Classroom', 101, 201, 301, 4.6, 500000000, 0);
INSERT INTO Apps VALUES (1002, 'Google Keep', 101, 201, 302, 4.5, 1000000000, 0);
INSERT INTO Apps VALUES (1003, 'Instagram', 102, 201, 304, 4.4, 5000000000, 0);
INSERT INTO Apps VALUES (1004, 'Spotify', 103, 201, 303, 4.5, 1000000000, 0);
INSERT INTO Apps VALUES (1005, 'Canva', 104, 201, 302, 4.7, 500000000, 0);
INSERT INTO Apps VALUES (1006, 'BYJU''S Learning', 105, 201, 301, 4.3, 100000000, 299);
INSERT INTO Apps VALUES (1007, 'Candy Crush', 102, 204, 305, 4.6, 1000000000, 0);
INSERT INTO Apps VALUES (1008, 'Temple Run', 104, 203, 305, 4.2, 500000000, 0);

COMMIT;


SELECT * FROM Developers;
SELECT * FROM Publishers;
SELECT * FROM Categories;
SELECT * FROM Apps;


BEGIN
    DBMS_OUTPUT.PUT_LINE('Welcome to PlayStoreDB');
END;
/


CREATE OR REPLACE FUNCTION classify_rating (
    p_rating IN NUMBER
)
RETURN VARCHAR2
IS
BEGIN
    IF p_rating IS NULL THEN
        RETURN 'Not Rated';
    ELSIF p_rating >= 4.5 THEN
        RETURN 'Excellent';
    ELSIF p_rating >= 4.0 THEN
        RETURN 'Very Good';
    ELSIF p_rating >= 3.0 THEN
        RETURN 'Good';
    ELSE
        RETURN 'Needs Improvement';
    END IF;
END;
/

SELECT classify_rating(4.8) AS Result FROM DUAL;
SELECT classify_rating(4.2) AS Result FROM DUAL;
SELECT classify_rating(3.5) AS Result FROM DUAL;
SELECT classify_rating(2.5) AS Result FROM DUAL;
SELECT classify_rating(NULL) AS Result FROM DUAL;


CREATE OR REPLACE PROCEDURE application_details (
    p_application_id IN NUMBER
)
IS
    v_app_name       Apps.AppName%TYPE;
    v_rating         Apps.Rating%TYPE;
    v_price          Apps.Price%TYPE;
    v_downloads      Apps.Downloads%TYPE;
    v_developer_name Developers.DeveloperName%TYPE;
    v_publisher_name Publishers.PublisherName%TYPE;
    v_category_name  Categories.CategoryName%TYPE;
BEGIN
    SELECT a.AppName, a.Rating, a.Price, a.Downloads,
           d.DeveloperName, p.PublisherName, c.CategoryName
    INTO   v_app_name, v_rating, v_price, v_downloads,
           v_developer_name, v_publisher_name, v_category_name
    FROM Apps a
    JOIN Developers d ON a.DeveloperID = d.DeveloperID
    JOIN Publishers p ON a.PublisherID = p.PublisherID
    JOIN Categories c ON a.CategoryID = c.CategoryID
    WHERE a.AppID = p_application_id;

    DBMS_OUTPUT.PUT_LINE('Application ID: ' || p_application_id);
    DBMS_OUTPUT.PUT_LINE('Application Name: ' || v_app_name);
    DBMS_OUTPUT.PUT_LINE('Rating: ' || NVL(TO_CHAR(v_rating), 'Not Rated'));
    DBMS_OUTPUT.PUT_LINE('Price: ' || v_price);
    DBMS_OUTPUT.PUT_LINE('Downloads: ' || v_downloads);
    DBMS_OUTPUT.PUT_LINE('Developer Name: ' || v_developer_name);
    DBMS_OUTPUT.PUT_LINE('Publisher Name: ' || v_publisher_name);
    DBMS_OUTPUT.PUT_LINE('Category Name: ' || v_category_name);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('More than one application found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Test
EXEC application_details(1001);
EXEC application_details(9999);


CREATE OR REPLACE FUNCTION get_developer_app_count (
    p_developer_id IN NUMBER
)
RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM Apps
    WHERE DeveloperID = p_developer_id;

    RETURN v_count;
END;
/

SELECT d.DeveloperID,
       d.DeveloperName,
       get_developer_app_count(d.DeveloperID) AS Number_Of_Applications
FROM Developers d
ORDER BY d.DeveloperID;


CREATE OR REPLACE PROCEDURE category_application_summary (
    p_category_id IN NUMBER
)
IS
    v_category_name Categories.CategoryName%TYPE;
    v_total         NUMBER;
    v_free          NUMBER;
    v_paid          NUMBER;
    v_avg_rating    NUMBER;
BEGIN
    SELECT c.CategoryName,
           COUNT(a.AppID),
           NVL(SUM(CASE WHEN a.Price = 0 THEN 1 ELSE 0 END), 0),
           NVL(SUM(CASE WHEN a.Price > 0 THEN 1 ELSE 0 END), 0),
           AVG(a.Rating)
    INTO v_category_name, v_total, v_free, v_paid, v_avg_rating
    FROM Categories c
    LEFT JOIN Apps a ON a.CategoryID = c.CategoryID
    WHERE c.CategoryID = p_category_id
    GROUP BY c.CategoryName;

    DBMS_OUTPUT.PUT_LINE('Category Name: ' || v_category_name);
    DBMS_OUTPUT.PUT_LINE('Total Applications: ' || v_total);
    DBMS_OUTPUT.PUT_LINE('Free Applications: ' || v_free);
    DBMS_OUTPUT.PUT_LINE('Paid Applications: ' || v_paid);
    DBMS_OUTPUT.PUT_LINE('Average Rating: ' ||
                         NVL(TO_CHAR(ROUND(v_avg_rating, 2)), 'No ratings'));
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Category not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

EXEC category_application_summary(301);
EXEC category_application_summary(999);


CREATE OR REPLACE FUNCTION classify_app_price (
    p_price IN NUMBER
)
RETURN VARCHAR2
IS
BEGIN
    IF p_price IS NULL THEN
        RETURN 'Unknown';
    ELSIF p_price = 0 THEN
        RETURN 'Free';
    ELSIF p_price <= 100 THEN
        RETURN 'Budget';
    ELSIF p_price <= 500 THEN
        RETURN 'Premium';
    ELSE
        RETURN 'High Premium';
    END IF;
END;
/

SELECT AppID, AppName, Price,
       classify_app_price(Price) AS Price_Category
FROM Apps
ORDER BY AppID;


CREATE OR REPLACE PROCEDURE application_rating_decision (
    p_application_id IN NUMBER
)
IS
    v_rating Apps.Rating%TYPE;
BEGIN
    SELECT Rating
    INTO v_rating
    FROM Apps
    WHERE AppID = p_application_id;

    IF v_rating IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('Rating Not Available');
    ELSIF v_rating >= 4.5 THEN
        DBMS_OUTPUT.PUT_LINE('Highly Rated Application');
    ELSIF v_rating >= 4.0 THEN
        DBMS_OUTPUT.PUT_LINE('Good Application');
    ELSIF v_rating >= 3.0 THEN
        DBMS_OUTPUT.PUT_LINE('Average Application');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Low Rated Application');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');
END;
/

EXEC application_rating_decision(1001);
EXEC application_rating_decision(1006);


DECLARE
    v_counter NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('Application number: ' || v_counter);
        v_counter := v_counter + 1;
        EXIT WHEN v_counter > 10;
    END LOOP;
END;
/

-- B. WHILE LOOP
DECLARE
    v_counter NUMBER := 1;
BEGIN
    WHILE v_counter <= 10 LOOP
        DBMS_OUTPUT.PUT_LINE('Processing application number: ' || v_counter);
        v_counter := v_counter + 1;
    END LOOP;
END;
/


BEGIN
    FOR v_counter IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE('Reviewing application number: ' || v_counter);
    END LOOP;
END;
/


DECLARE
    CURSOR app_cursor IS
        SELECT AppID, AppName, Rating, Price, Downloads
        FROM Apps
        ORDER BY AppID;

    v_app_id    Apps.AppID%TYPE;
    v_app_name  Apps.AppName%TYPE;
    v_rating    Apps.Rating%TYPE;
    v_price     Apps.Price%TYPE;
    v_downloads Apps.Downloads%TYPE;
BEGIN
    OPEN app_cursor;

    IF app_cursor%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('Cursor is open');
    END IF;

    LOOP
        FETCH app_cursor
        INTO v_app_id, v_app_name, v_rating, v_price, v_downloads;

        EXIT WHEN app_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            v_app_id || ' | ' || v_app_name || ' | ' ||
            NVL(TO_CHAR(v_rating), 'Not Rated') || ' | ' ||
            v_price || ' | ' || v_downloads
        );

        DBMS_OUTPUT.PUT_LINE('Rows fetched: ' || app_cursor%ROWCOUNT);
    END LOOP;

    CLOSE app_cursor;
END;
/

DECLARE
    CURSOR app_cursor IS
        SELECT AppID, AppName, Rating, Price, Downloads
        FROM Apps
        ORDER BY AppID;
BEGIN
    FOR rec IN app_cursor LOOP
        DBMS_OUTPUT.PUT_LINE(
            rec.AppID || ' | ' || rec.AppName || ' | ' ||
            NVL(TO_CHAR(rec.Rating), 'Not Rated') || ' | ' ||
            rec.Price || ' | ' || rec.Downloads
        );
    END LOOP;
END;
/

------------------------------------------------------------
-- LEVEL 2 - QUESTION 3: PROCEDURE WITH UPDATE
------------------------------------------------------------

CREATE OR REPLACE PROCEDURE update_app_rating (
    p_application_id IN NUMBER,
    p_new_rating     IN NUMBER
)
IS
    v_app_name Apps.AppName%TYPE;
    v_rating   Apps.Rating%TYPE;
BEGIN
    -- Check whether the application exists
    SELECT AppName
    INTO v_app_name
    FROM Apps
    WHERE AppID = p_application_id;

    -- Validate rating
    IF p_new_rating IS NULL OR p_new_rating < 0 OR p_new_rating > 5 THEN
        DBMS_OUTPUT.PUT_LINE('Invalid application rating');
        RETURN;
    END IF;

    UPDATE Apps
    SET Rating = p_new_rating
    WHERE AppID = p_application_id;

    SELECT Rating
    INTO v_rating
    FROM Apps
    WHERE AppID = p_application_id;

    DBMS_OUTPUT.PUT_LINE('Rating updated successfully');
    DBMS_OUTPUT.PUT_LINE('Application: ' || v_app_name);
    DBMS_OUTPUT.PUT_LINE('Updated Rating: ' || v_rating);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

EXEC update_app_rating(1008, 4.5);
-- Invalid rating test
EXEC update_app_rating(1008, 6);


CREATE OR REPLACE PROCEDURE update_download_count (
    p_application_id     IN NUMBER,
    p_additional_downloads IN NUMBER,
    p_total_downloads    IN OUT NUMBER
)
IS
    v_existing_downloads Apps.Downloads%TYPE;
BEGIN
    SELECT Downloads
    INTO v_existing_downloads
    FROM Apps
    WHERE AppID = p_application_id;

    p_total_downloads := v_existing_downloads + p_additional_downloads;

    UPDATE Apps
    SET Downloads = p_total_downloads
    WHERE AppID = p_application_id;

    DBMS_OUTPUT.PUT_LINE('Updated Download Count: ' || p_total_downloads);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

-- Test IN OUT parameter
DECLARE
    v_total NUMBER := 0;
BEGIN
    update_download_count(1001, 5000, v_total);
    DBMS_OUTPUT.PUT_LINE('IN OUT parameter value: ' || v_total);
END;
/


CREATE OR REPLACE PROCEDURE application_exception_handling (
    p_application_id IN NUMBER
)
IS
    v_app_name  Apps.AppName%TYPE;
    v_rating    Apps.Rating%TYPE;
    v_price     Apps.Price%TYPE;
    v_downloads Apps.Downloads%TYPE;
BEGIN
    SELECT AppName, Rating, Price, Downloads
    INTO v_app_name, v_rating, v_price, v_downloads
    FROM Apps
    WHERE AppID = p_application_id;

    DBMS_OUTPUT.PUT_LINE('Application Name: ' || v_app_name);
    DBMS_OUTPUT.PUT_LINE('Rating: ' || NVL(TO_CHAR(v_rating), 'Not Rated'));
    DBMS_OUTPUT.PUT_LINE('Price: ' || v_price);
    DBMS_OUTPUT.PUT_LINE('Downloads: ' || v_downloads);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found (NO_DATA_FOUND)');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Multiple applications found (TOO_MANY_ROWS)');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/

EXEC application_exception_handling(1001);
EXEC application_exception_handling(9999);


CREATE OR REPLACE PROCEDURE process_application (
    p_application_id IN NUMBER
)
IS
    v_app_name       Apps.AppName%TYPE;
    v_rating         Apps.Rating%TYPE;
    v_price          Apps.Price%TYPE;
    v_downloads      Apps.Downloads%TYPE;
    v_developer_name Developers.DeveloperName%TYPE;
    v_publisher_name Publishers.PublisherName%TYPE;
    v_category_name  Categories.CategoryName%TYPE;
    v_rating_category VARCHAR2(30);
    v_price_category  VARCHAR2(40);
BEGIN
    SELECT a.AppName, a.Rating, a.Price, a.Downloads,
           d.DeveloperName, p.PublisherName, c.CategoryName
    INTO v_app_name, v_rating, v_price, v_downloads,
         v_developer_name, v_publisher_name, v_category_name
    FROM Apps a
    JOIN Developers d ON a.DeveloperID = d.DeveloperID
    JOIN Publishers p ON a.PublisherID = p.PublisherID
    JOIN Categories c ON a.CategoryID = c.CategoryID
    WHERE a.AppID = p_application_id;

    v_rating_category := classify_rating(v_rating);

    IF v_price = 0 THEN
        v_price_category := 'Free Application';
    ELSIF v_price <= 100 THEN
        v_price_category := 'Budget Application';
    ELSIF v_price <= 500 THEN
        v_price_category := 'Premium Application';
    ELSE
        v_price_category := 'High Premium Application';
    END IF;

    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('APPLICATION DETAILS REPORT');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Application ID: ' || p_application_id);
    DBMS_OUTPUT.PUT_LINE('Application Name: ' || v_app_name);
    DBMS_OUTPUT.PUT_LINE('Developer Name: ' || v_developer_name);
    DBMS_OUTPUT.PUT_LINE('Publisher Name: ' || v_publisher_name);
    DBMS_OUTPUT.PUT_LINE('Category Name: ' || v_category_name);
    DBMS_OUTPUT.PUT_LINE('Rating: ' || NVL(TO_CHAR(v_rating), 'Not Rated'));
    DBMS_OUTPUT.PUT_LINE('Rating Category: ' || v_rating_category);
    DBMS_OUTPUT.PUT_LINE('Price: ' || v_price);
    DBMS_OUTPUT.PUT_LINE('Price Category: ' || v_price_category);
    DBMS_OUTPUT.PUT_LINE('Downloads: ' || v_downloads);
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Application not found');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

EXEC process_application(1001);
EXEC process_application(1006);
EXEC process_application(9999);


DECLARE
    CURSOR developer_cursor IS
        SELECT d.DeveloperID,
               d.DeveloperName,
               COUNT(a.AppID) AS app_count,
               AVG(a.Rating) AS avg_rating,
               SUM(a.Downloads) AS total_downloads
        FROM Developers d
        JOIN Apps a ON a.DeveloperID = d.DeveloperID
        GROUP BY d.DeveloperID, d.DeveloperName
        ORDER BY d.DeveloperID;
BEGIN
    FOR rec IN developer_cursor LOOP
        DBMS_OUTPUT.PUT_LINE('Developer ID: ' || rec.DeveloperID);
        DBMS_OUTPUT.PUT_LINE('Developer Name: ' || rec.DeveloperName);
        DBMS_OUTPUT.PUT_LINE('Number of Applications: ' || rec.app_count);
        DBMS_OUTPUT.PUT_LINE('Average Rating: ' ||
                             NVL(TO_CHAR(ROUND(rec.avg_rating, 2)), 'No ratings'));
        DBMS_OUTPUT.PUT_LINE('Total Downloads: ' || rec.total_downloads);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
END;
/


DECLARE
    CURSOR developer_cursor IS
        SELECT DeveloperID, DeveloperName
        FROM Developers
        ORDER BY DeveloperID;

    v_app_count NUMBER;
    v_category  VARCHAR2(30);
BEGIN
    FOR rec IN developer_cursor LOOP
        v_app_count := get_developer_app_count(rec.DeveloperID);

        IF v_app_count = 0 THEN
            v_category := 'No Applications';
        ELSIF v_app_count <= 2 THEN
            v_category := 'Small Portfolio';
        ELSE
            v_category := 'Large Portfolio';
        END IF;

        DBMS_OUTPUT.PUT_LINE('Developer ID: ' || rec.DeveloperID);
        DBMS_OUTPUT.PUT_LINE('Developer Name: ' || rec.DeveloperName);
        DBMS_OUTPUT.PUT_LINE('Application Count: ' || v_app_count);
        DBMS_OUTPUT.PUT_LINE('Developer Application Category: ' || v_category);
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
END;
/


CREATE OR REPLACE PROCEDURE playstore_application_report
IS
    CURSOR report_cursor IS
        SELECT a.AppID, a.AppName, d.DeveloperName, c.CategoryName,
               a.Rating, a.Price, a.Downloads
        FROM Apps a
        JOIN Developers d ON a.DeveloperID = d.DeveloperID
        JOIN Categories c ON a.CategoryID = c.CategoryID
        ORDER BY a.AppID;

    v_total_apps       NUMBER := 0;
    v_total_free       NUMBER := 0;
    v_total_paid       NUMBER := 0;
    v_total_high_rated NUMBER := 0;
    v_total_downloads  NUMBER := 0;
    v_rating_category  VARCHAR2(30);
    v_price_category   VARCHAR2(30);
BEGIN
    DBMS_OUTPUT.PUT_LINE('========== PLAYSTORE APPLICATION REPORT ==========');

    FOR rec IN report_cursor LOOP
        v_total_apps := v_total_apps + 1;

        v_rating_category := classify_rating(rec.Rating);
        v_price_category := classify_app_price(rec.Price);

        IF rec.Price = 0 THEN
            v_total_free := v_total_free + 1;
        ELSE
            v_total_paid := v_total_paid + 1;
        END IF;

        IF rec.Rating >= 4.5 THEN
            v_total_high_rated := v_total_high_rated + 1;
        END IF;

        v_total_downloads := v_total_downloads + NVL(rec.Downloads, 0);

        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Application ID: ' || rec.AppID);
        DBMS_OUTPUT.PUT_LINE('Application Name: ' || rec.AppName);
        DBMS_OUTPUT.PUT_LINE('Developer Name: ' || rec.DeveloperName);
        DBMS_OUTPUT.PUT_LINE('Category Name: ' || rec.CategoryName);
        DBMS_OUTPUT.PUT_LINE('Application Rating: ' ||
                             NVL(TO_CHAR(rec.Rating), 'Not Rated'));
        DBMS_OUTPUT.PUT_LINE('Rating Category: ' || v_rating_category);
        DBMS_OUTPUT.PUT_LINE('Application Price: ' || rec.Price);
        DBMS_OUTPUT.PUT_LINE('Price Category: ' || v_price_category);
        DBMS_OUTPUT.PUT_LINE('Downloads: ' || rec.Downloads);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('TOTAL APPLICATIONS PROCESSED: ' || v_total_apps);
    DBMS_OUTPUT.PUT_LINE('TOTAL FREE APPLICATIONS: ' || v_total_free);
    DBMS_OUTPUT.PUT_LINE('TOTAL PAID APPLICATIONS: ' || v_total_paid);
    DBMS_OUTPUT.PUT_LINE('TOTAL HIGHLY RATED APPLICATIONS: ' || v_total_high_rated);
    DBMS_OUTPUT.PUT_LINE('TOTAL DOWNLOADS: ' || v_total_downloads);
    DBMS_OUTPUT.PUT_LINE('========================================');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Report generation failed: ' || SQLERRM);
END;
/

EXEC playstore_application_report;

