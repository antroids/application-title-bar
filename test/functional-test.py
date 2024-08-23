#!/usr/bin/env python3
#
# SPDX-FileCopyrightText: 2024 Anton Kharuzhy <publicantroids@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

import unittest
from appium import webdriver
from appium.webdriver.common.appiumby import AppiumBy
from appium.options.common.base import AppiumOptions
from selenium.webdriver.support.ui import WebDriverWait
import time


class SimpleCalculatorTests(unittest.TestCase):

    @classmethod

    def setUpClass(self):
        options = AppiumOptions()
        # The app capability may be a command line or a desktop file id.
        options.set_capability("app", "plasmashell --replace")
        # Boilerplate, always the same
        self.driver = webdriver.Remote(
            command_executor='http://127.0.0.1:4723',
            options=options)
        # Set a timeout for waiting to find elements. If elements cannot be found
        # in time we'll get a test failure. This should be somewhat long so as to
        # not fall over when the system is under load, but also not too long that
        # the test takes forever.
        self.driver.implicitly_wait = 10

    def setUp(self):
        self.driver.find_element(by=AppiumBy.NAME, value="AC").click()
        wait = WebDriverWait(self.driver, 5)
        wait.until(lambda x: self.getresults() == '0')

    def tearDown(self):
        if not self._outcome.result.wasSuccessful():
            self.driver.get_screenshot_as_file("failed_test_shot_{}.png".format(self.id()))

    @classmethod
    def tearDownClass(self):
        self.driver.quit()

    def getresults(self):
        displaytext = self.driver.find_element(by='description', value="Result").text
        return displaytext

    def test_initialize(self):
        self.driver.find_element(by=AppiumBy.NAME, value="AC").click()
        self.driver.find_element(by=AppiumBy.NAME, value="7").click()
        self.assertEqual(self.getresults(),"7")

    def test_addition(self):
        self.driver.find_element(by=AppiumBy.NAME, value="1").click()
        self.driver.find_element(by=AppiumBy.NAME, value="+").click()
        self.driver.find_element(by=AppiumBy.NAME, value="7").click()
        self.driver.find_element(by=AppiumBy.NAME, value="=").click()
        self.assertEqual(self.getresults(),"8")

    def test_combination(self):
        self.driver.find_element(by=AppiumBy.NAME, value="7").click()
        self.driver.find_element(by=AppiumBy.NAME, value="×").click()
        self.driver.find_element(by=AppiumBy.NAME, value="9").click()
        self.driver.find_element(by=AppiumBy.NAME, value="+").click()
        self.driver.find_element(by=AppiumBy.NAME, value="1").click()
        self.driver.find_element(by=AppiumBy.NAME, value="=").click()
        self.driver.find_element(by=AppiumBy.NAME, value="÷").click()
        self.driver.find_element(by=AppiumBy.NAME, value="8").click()
        self.driver.find_element(by=AppiumBy.NAME, value="=").click()
        self.assertEqual(self.getresults(),"8")

    def test_division(self):
        self.driver.find_element(by=AppiumBy.NAME, value="8").click()
        self.driver.find_element(by=AppiumBy.NAME, value="8").click()
        self.driver.find_element(by=AppiumBy.NAME, value="÷").click()
        self.driver.find_element(by=AppiumBy.NAME, value="1").click()
        self.driver.find_element(by=AppiumBy.NAME, value="1").click()
        self.driver.find_element(by=AppiumBy.NAME, value="=").click()
        self.assertEqual(self.getresults(),"8")

    def test_multiplication(self):
        self.driver.find_element(by=AppiumBy.NAME, value="9").click()
        self.driver.find_element(by=AppiumBy.NAME, value="×").click()
        self.driver.find_element(by=AppiumBy.NAME, value="8").click()
        self.driver.find_element(by=AppiumBy.NAME, value="=").click()
        self.assertEqual(self.getresults(),"72")

    def test_subtraction(self):
        self.driver.find_element(by=AppiumBy.NAME, value="9").click()
        self.driver.find_element(by=AppiumBy.NAME, value="-").click()
        self.driver.find_element(by=AppiumBy.NAME, value="1").click()
        self.driver.find_element(by=AppiumBy.NAME, value="=").click()
        self.assertEqual(self.getresults(),"8")


if __name__ == '__main__':
    unittest.main()
