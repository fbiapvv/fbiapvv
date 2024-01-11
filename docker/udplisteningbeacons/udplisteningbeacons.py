import socket
import os
import logging
import json
import requests
import socket

from logging.handlers import TimedRotatingFileHandler

cwd = os.path.dirname(os.path.realpath(__file__))

logs_dir = os.path.join(cwd, 'logs')

#logging --------
namelog = 'udplisteneribeacon'

if not os.path.exists(logs_dir):
    os.makedirs(logs_dir)

logger = logging.getLogger(namelog)

hdlr = TimedRotatingFileHandler(os.path.join(logs_dir, namelog),  when='midnight')
# hdlr.suffix = '%Y_%m_%d.log'

formatter = logging.Formatter('%(message)s')
hdlr.setFormatter(formatter)
logger.addHandler(hdlr) 
hdlr.doRollover()


#zapis do stdio
ch = logging.StreamHandler()
ch.setFormatter(formatter)
logger.addHandler(ch)

# logger.setLevel(logging.DEBUG)
logger.setLevel(logging.INFO)

#logging ------------------------------

apiIP = ""

if os.environ.get('SENDTOAPI') is None:
    os.environ['SENDTOAPI'] = "0"
    # print(os.getenv('SENDTOAPI'))
    
if os.environ['SENDTOAPI'] == "1":
    try:
        apiIP = socket.gethostbyname('becotrack_djangoweb')
    except:
        None
        
    if apiIP == "":
        os.environ['SENDTOAPI'] = "0"
# print(apiIP)
# print(os.environ['SENDTOAPI'])
# print(socket.gethostbyname('becotrack_djangoweb'))
# exit(0)

def SendToApi(address, json_msg):
    try:
        API_ENDPOINT = address
        r = requests.post(url = API_ENDPOINT, data = str.replace(json_msg, r'\u0000', ''), headers={"Content-Type":"application/json"})
        # r = requests.post(url = API_ENDPOINT, data = json_msg, headers={"Content-Type":"application/json"})
        print("API Sent\n")
        print("--- address: " + API_ENDPOINT + "\n")
        print("--- json_msg: " + json_msg + "\n")
        
        # pastebin_url = r.text
        # print("The pastebin URL is:%s"%pastebin_url)
    except Exception as e:
        print("---------")
        print(e)


server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
server_socket.bind(('', 26573))
print("UDP Server is running...")
while True:
    message, address = server_socket.recvfrom(8192)
    print("Received... message: " + message.decode() + " ... Address: " + address[0] + " ... Port: " + str(address[1]))
    json_array = json.loads(message.decode())
    
    try:
        # print(json["token"])
        if ("token" in json_array and "uid" in json_array and json_array["token"] == "a34c5327-c9e8-461c-a72d-4e27750b8b0d"):
            message = b"7978aff6-04b4-4d5f-b873-55216a40bb7f"
            server_socket.sendto(message, address)
            
            _json_msg = "{\"uid\":\"" + json_array['uid'] + "\"}"
            SendToApi(address="http://" + apiIP + ":8000/api/beaconreaders/add", json_msg = _json_msg)

            print("Sent... message: " + message.decode() + " ... Address: " + address[0] + " ... Port: " + str(address[1]))
        else: 
            rowtoadd = ""
            for item in json_array:
                rowtoadd = item['read_datetime'] + '\t' + item['reader_uid'] + '\t' + item['tag_uid'] + '\t' + str(item['rssi'])
                logger.info(rowtoadd)

            print(os.getenv("SENDTOAPI"))
            if os.getenv("SENDTOAPI") == "1":
                print("---------01")

                try:
                    SendToApi(address="http://" + apiIP + ":8000/api/loadedbeacontags/add", json_msg = message.decode())
                except Exception as e:
                    print("---------")
                    print(e)
    except Exception as e:
        print(e)

            

