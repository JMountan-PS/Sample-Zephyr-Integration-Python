from robot.running.model import TestSuite as SuiteData, TestCase as TestData
from robot.result.model import TestSuite as SuiteResult, TestCase as TestResult
from robot.api import logger
import requests

class LibraryListener:
    
    #See https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#listener-version-3 for data/result attributes
    ROBOT_LIBRARY_SCOPE = 'SUITE'
    ROBOT_LISTENER_API_VERSION = 3

    def __init__(self):
        self.ROBOT_LIBRARY_LISTENER = self
        self.pass_count = 0
        self.fail_count = 0

    def start_suite(self, data, result):
        Maybe set the suite status as running in Zephyr?
        logger.console(f"---LIBRARY LISTENER--- starting a suite: {data.test_class}")

    def end_suite(self, data, result):
        # Use self.pass_count and self.fail_count and send results
        testcount = int(self.fail_count) + int(self.pass_count)
        passrate = int(self.pass_count) / testcount * 100
        logger.console(f"---LIBRARY LISTENER--- passrate: {passrate}")
        

    def start_test(self, data, result):
        logger.console(f"---LIBRARY LISTENER--- starting a test {data.name}")

    def end_test(self, data, result):
        logger.console(f"---LIBRARY LISTENER--- ending a test {data.name}")
        if result.status == 'PASS':
            self.pass_count += 1
        if result.status == 'FAIL':
            self.fail_count += 1

    def start_message(self):
        logger.console("Library listener started")
        #This exists only to make the library be successfully imported, and does not add any actual value