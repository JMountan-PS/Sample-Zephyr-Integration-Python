from robot.api import logger
import requests
import zephyr_rest

class ParamListener:

    #Use the following command line option as a template for importing a listener:
    #--listener	/home/executor/execution/Sample-Zephyr-Integration/libraries/ParamListener.py
    
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LISTENER_API_VERSION = 3

    def __init__(self):
        self.pass_count = 0
        self.fail_count = 0

    #def start_suite(self, data, result):
        # Maybe set the suite status as running in Zephyr?

    def end_suite(self, data, result):
        # Use self.pass_count and self.fail_count and send results
        testcount = int(self.fail_count) + int(self.pass_count)
        passrate = int(self.pass_count) / testcount * 100
        logger.console(f"---PARAM LISTENER--- passrate: {passrate}")

    def start_test(self, data, result):
        logger.console(f"---PARAM LISTENER--- starting a test {data.name}")

    def end_test(self, data, result):
        logger.console(f"---PARAM LISTENER--- ending a test {data.name}")
        if result.status == 'PASS':
            self.pass_count += 1
        if result.status == 'FAIL':
            self.fail_count += 1
