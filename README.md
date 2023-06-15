# Currency Conversion History App
This Flutter app allows users to view the historical currency conversion rates between two currencies using the ExchangeRate API provider. Users can input the start date, end date, base currency, and desired currency to retrieve the conversion history for the specified period. The app uses clean architecture for a modular and testable codebase.

## Usage
1- Launch the app on your device or simulator.

2- On the home screen, enter the start date, end date, base currency, and desired currency.

3- Tap the "Get Exchange Rate" button to retrieve the currency conversion history for the specified period.

## Test Cases
### Test Case 1: Opening Exchange Rate Page 
**Description**: When the Exchange Rate page is opened, a loading indicator is shown until the symbols are loaded.

**Steps:**

1- Open the Exchange Rate page.

**Expected Result:** The loading indicator is displayed until the symbols are loaded
When open page loading is shown until symbols are loaded

![b74e0fdd-cbfe-416d-9423-78df29a44d2b](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/0dc5f688-c2a7-4026-964c-d4637987c913)

### Test Case 2: Error When Opening Page (Connection Error)
 
**Description**: When opening the Exchange Rate page, if there is a connection error, an error message is displayed.

**Steps:**

1- Disable internet connectivity on the device.

2-Open the Exchange Rate page.

**Expected Result:** An error message is displayed indicating the connection error and the retry button to load data again.

![1](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/9c5ecb86-d888-4a51-a76b-0403cc42d40d)


### Test Case 3: Retrieving Data with Missing Start or End Date
 
**Description**: When trying to retrieve data without specifying the start or end date, an error message is displayed.

**Steps:**

1-Open the Exchange Rate page.

2-Leave the start or end date field empty.

3-Click the "Get Exchange Rate" button.

**Expected Result:** An error message is displayed indicating that the start or end date is missing.

![2](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/6154b85b-cbbc-4e49-ac2b-f4d94115d485)

### Test Case 4: Retrieving Data
 
**Description**: When clicking the "Get Exchange Rate" button after specifying the start and end date, the app retrieves the currency conversion history.

**Steps:**

1-Open the Exchange Rate page.

2-Leave the start or end date field empty.

3-Click the "Get Exchange Rate" button.

**Expected Result:** The "Get Exchange Rate" button animates to a loading state until the data is retrieved.

![4_1](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/11da8847-295f-4d6b-b4be-5ae0aae2680a)
![4_2](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/43839ecb-f6f0-48cb-bf4b-4f19b9d48a87)

### Test Case 5: Viewing Currency Conversion History
 
**Description**: After retrieving the currency conversion history, the user can view the historical rates.

**Steps:**

1-Wait until The "Get Exchange Rate" button loading.

2-View the displayed historical rates.

**Expected Result:**  The app displays the historical currency conversion rates.

![5](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/2a4d9156-6098-47eb-9575-851c8429aa4c)

## Examples of the inspector

![11](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/bc5e1c14-106a-4bc8-b271-4e628e872dc3)
![12](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/ea02f961-10c1-4f9d-b685-be21b61119ce)
![13](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/17b8f99f-3b8b-4125-a01e-3d96b4cb3d37)


