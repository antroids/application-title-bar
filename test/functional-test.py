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
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.by import By
import time
from subprocess import check_output
import subprocess


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
        time.sleep(30);
        print("elements: " + self.driver.find_elements(by=By.XPATH, value="//*"));

    def setUp(self):
        self.driver.find_element("//*[@name='Application title bar']//*[@name='Close']").click()
        widget = self.driver.find_element("//*[@name='Application title bar']")
        ActionChains(self.driver).context_click(widget).perform()

    @classmethod
    def tearDownClass(self):
        self.driver.quit()
        subprocess.run("systemctl --user restart plasma-plasmashell.service");

    def test_initialize(self):
        self.driver.find_element(by=AppiumBy.NAME, value="AC").click()
        self.driver.find_element(by=AppiumBy.NAME, value="7").click()


if __name__ == '__main__':
    unittest.main()
