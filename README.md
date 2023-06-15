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

![b74e0fdd-cbfe-416d-9423-78df29a44d2b](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/10c300b1-46f7-41fc-b226-eb961cd31150)

### Test Case 2: Error When Opening Page (Connection Error)
 
**Description**: When opening the Exchange Rate page, if there is a connection error, an error message is displayed.

**Steps:**

1- Disable internet connectivity on the device.

2-Open the Exchange Rate page.

**Expected Result:** An error message is displayed indicating the connection error and the retry button to load data again.

![2](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/62b0411c-1cf9-484b-9f1a-f1823d501953)


### Test Case 3: Retrieving Data with Missing Start or End Date
 
**Description**: When trying to retrieve data without specifying the start or end date, an error message is displayed.

**Steps:**

1-Open the Exchange Rate page.

2-Leave the start or end date field empty.

3-Click the "Get Exchange Rate" button.

**Expected Result:** An error message is displayed indicating that the start or end date is missing.

![3](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/2190dab4-2c14-478d-80ad-5b157e09af08)

### Test Case 4: Retrieving Data
 
**Description**: When clicking the "Get Exchange Rate" button after specifying the start and end date, the app retrieves the currency conversion history.

**Steps:**

1-Open the Exchange Rate page.

2-Leave the start or end date field empty.

3-Click the "Get Exchange Rate" button.

**Expected Result:** The "Get Exchange Rate" button animates to a loading state until the data is retrieved.

![4_1](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/458b636e-34f3-498c-a181-d133d7fe2a92)
![4_2](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/b5e61979-8cc9-4463-8162-c33a5013a889)

### Test Case 5: Viewing Currency Conversion History
 
**Description**: After retrieving the currency conversion history, the user can view the historical rates.

**Steps:**

1-Wait until The "Get Exchange Rate" button loading.

2-View the displayed historical rates.

**Expected Result:**  The app displays the historical currency conversion rates.

![5](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/99c40f30-e107-4159-9545-c056ab167b49)

## Examples of the inspector

![11](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/e4861c80-8ef2-496b-ba72-bcfb6bf2711a)
![12](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/afc47870-1568-4d06-b869-5485f4a4b665)
![13](https://github.com/amirbahrawy/exchange_rate_task/assets/38887148/23db1505-ad00-432c-b30a-028b79def80a)

