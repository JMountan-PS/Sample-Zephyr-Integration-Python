import requests
#https://requests.readthedocs.io/en/latest/_modules/requests/api/#post
#https://requests.readthedocs.io/en/latest/api/#requests.post
import json

class crt_rest:

    base_url = 'https://api.robotic.copado.com/pace'

    def __init__(self, AuthPAT):
        self.x_auth = AuthPAT
        self.headers = {'X-AUTHORIZATION':AuthPAT}

    def post_new_test_run(self, projectID, suiteID):
        
        requests.request('POST',f"{crt_rest.base_url}/v4/projects/{projectID}/jobs/{suiteID}/builds",
                         headers=self.headers)



#session = crt_rest('')
#session.post_new_test_run('46963','55833')

class salesforce_rest:

    def __init__(self, url, consumer_id, consumer_secret, username, password):
        self.url = url
        self.consumer_id = consumer_id
        self.consumer_secret = consumer_secret
        self.username = username
        self.password = password
        self.auth_headers = {'grant_type':'password',
                        'username':username,
                        'password':password,
                        'client_id':consumer_id,
                        'client_secret':consumer_secret}

        response = requests.post(f"{url}/services/oauth2/token",
                         data=self.auth_headers)
        self.auth_token = json.loads(response.text)['access_token']
        self.instance_url = json.loads(response.text)['instance_url']
        print(f"Salesforce Authorization: {response.status_code} - {response.reason}")

    def create_record(self, object_name, fields):

        response = requests.post(f"{self.instance_url}/services/data/v60.0/sobjects/{object_name}/",
                                 headers={'Authorization':f"Bearer {self.auth_token}",'Content-Type':'application/json'},
                                 data=fields)
        print(f"Create {object_name} Record: {response.status_code} - {response.reason}")
        return  json.loads(response.text)['id']

#sf_session = salesforce_rest('https://login.salesforce.com',
 #                            '',
 #                            '',
  #                           'jmountan@copado.admin.com',
  #                           'DevTest1234!')
#account_id = sf_session.create_record('Account','{"Name":"ExampleFromAPI"}')


class zephyr_rest:

    base_url = 'http://your-jira-host:port/your-jira-context/rest/atm/1.0/'
    #replace <your-jira-host>, <port>, <your-jira-context>


    #https://confluence.atlassian.com/enterprise/using-personal-access-tokens-1026032365.html
    #----------------------------------------------------------------------#
    #                                                                      #
    #  Need to ask about how uber plans on Authenticating:                 #
    #  -PAT                                                                #
    #  -Oauth1.0a                                                          #
    #  -Oauth2                                                             #
    #  -Basic Auth                                                         #
    #                                                                      #
    #----------------------------------------------------------------------#

    def __init__(self):
        self.active_session = requests.Session()

    #auth method assuming personal access token
    def set_auth_pat(self, personal_access_token):
        self.pat = personal_access_token
        self.headers = {'Authorization':f"Bearer {self.pat}","Content-Type":"application/json"}
        self.active_session.headers.update(self.headers)

    #auth method assuming basic auth
    def set_auth_basic(self, username, password):
        self.username = username
        self.password = password
        self.headers = {"Content-Type":"application/json"}
        self.active_session.auth = (username,password)


pat_z = zephyr_rest()

    #----------------------------------------------------------------------#
    #                                                                      #
    #  Need to ask about endpoint usage
    #                                                                      #
    #----------------------------------------------------------------------#

    
        


