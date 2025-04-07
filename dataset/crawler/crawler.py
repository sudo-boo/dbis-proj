from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
import time
import shutil
import json
import pandas as pd
import os

# ---- CONFIGURATION ----

actual_data = pd.read_csv("../data_with_brand.csv")
list_of_products = [
    (row['product_id'], row['name'], row['weightInGms'], row['mrp'], row['category'])
    for index, row in actual_data.iterrows()
]
i = int(input("Enter starting index: "))
offset = int(input("Enter offset: "))
list_of_products = list_of_products[i:i + offset]

# ---- SETUP OPTIONS ----
options = Options()
options.add_argument("--start-maximized")

# Locate the Chromium binary
chromium_path = shutil.which("chromium") or shutil.which("chromium-browser")
if chromium_path is None:
    raise FileNotFoundError("Chromium is not installed or not in PATH.")
options.binary_location = chromium_path

# ---- INITIALIZE DRIVER ----
driver = webdriver.Chrome(service=Service(), options=options)

json_filename = "data13.json"

# Create file if it doesn't exist
if not os.path.exists(json_filename):
    with open(json_filename, "w") as f:
        json.dump([], f)

counter = i
ccc = 0
try:
    driver.get("https://www.google.com/search?q=" + "newton+no+head")
    time.sleep(30)

    for prod in list_of_products:
        counter += 1
        ccc += 1
        search_phrase = f"Zepto {prod[1]} {prod[2]}g {int(prod[3])/100} rupees"
        print(f"Searching for: {search_phrase}")
        print(f"Status: ", counter, "|", ccc, "/", len(list_of_products))


        individual_data = {
            "product_id": prod[0],
            "category": prod[4],
            "search_phrase": search_phrase,
            "image_urls": [],
            "product_highlights": {},
            "product_information": {},
            "offer_price": None,
            "discount": None
        }

        # Google search
        driver.get("https://www.google.com/search?q=" + search_phrase)
        time.sleep(3)
        
        opening_first_result = False

        try:
            first_result = driver.find_elements(By.CSS_SELECTOR, 'div#search a')[0]
            first_result.click()
            opening_first_result = True
            time.sleep(5)

            # Extract image URLs
            print("Extracting image URLs")
            try:
                image_preview_buttons = driver.find_elements(By.CSS_SELECTOR, '[aria-label^="image-preview-"]')
                for button in image_preview_buttons:
                    img_tag = button.find_element(By.TAG_NAME, 'img')
                    src = img_tag.get_attribute('src')
                    individual_data["image_urls"].append(src)
            except:
                pass

            # Product Highlights
            print("Extracting product highlights")
            try:
                product_highlights = driver.find_element(By.ID, "productHighlights")
                items = product_highlights.find_elements(By.CSS_SELECTOR, 'div.flex.items-start.gap-3')
                for item in items:
                    title = item.find_element(By.TAG_NAME, 'h3').text.strip()
                    desc = item.find_element(By.TAG_NAME, 'p').text.strip()
                    individual_data["product_highlights"][title] = desc
            except:
                pass

            # Product Information
            print("Extracting product information")
            try:
                product_info = driver.find_element(By.ID, "productInformationL4")
                items = product_info.find_elements(By.CSS_SELECTOR, 'div.flex.items-start.gap-3')
                for item in items:
                    title = item.find_element(By.TAG_NAME, 'h3').text.strip()
                    desc = item.find_element(By.TAG_NAME, 'p').text.strip()
                    individual_data["product_information"][title] = desc
            except:
                pass

            # Basic product details
            print("Extracting product details")
            try:
                individual_data["name"] = driver.find_element(By.CSS_SELECTOR, 'h1.text-xl').text
            except:
                individual_data["name"] = None

            try:
                individual_data["net_qty"] = driver.find_element(By.XPATH, '//p[contains(text(), "Net Qty")]//span').text
            except:
                individual_data["net_qty"] = None

            print("Extracting offer price")
            try:
                individual_data["offer_price"] = driver.find_element(By.CSS_SELECTOR, 'span[class*="text-[#262A33"]').text
            except:
                individual_data["offer_price"] = None

            try:
                individual_data["mrp"] = driver.find_element(By.CSS_SELECTOR, 'span.line-through').text
            except:
                individual_data["mrp"] = None

            print("Extracting discount")
            try:
                discount_elem = driver.find_element(By.CSS_SELECTOR, 'p[class*="text-[#079761"]')
                individual_data["discount"] = discount_elem.text.strip()
            except:
                individual_data["discount"] = None

        except Exception as e:
            print(f"Failed to open first result for '{search_phrase}':", e)

        # Save the current product's data immediately
        if opening_first_result:
            print("Saving data to JSON...")
            # Read JSON safely even if empty
            if os.path.getsize(json_filename) == 0:
                existing_data = []
            else:
                with open(json_filename, "r") as f:
                    existing_data = json.load(f)

            existing_data.append(individual_data)

            with open(json_filename, "w") as f:
                json.dump(existing_data, f, indent=4)

            print(f"Search completed for: {search_phrase}")
            print("=" * 50)
            print()
            time.sleep(1)

finally:
    driver.quit()
    print("Browser closed.")
