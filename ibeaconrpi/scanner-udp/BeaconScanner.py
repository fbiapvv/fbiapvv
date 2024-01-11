#This is a working prototype. DO NOT USE IT IN LIVE PROJECTS

from cmath import log
from itertools import count
from time import sleep
import ScanUtility
import bluetooth._bluetooth as bluez
import os
import logging
from logging.handlers import TimedRotatingFileHandler
import subprocess
import ipaddress

from datetime import datetime
import socket
import threading
import json;
import ntplib
import time
import datetime


cwd = os.path.dirname(os.path.realpath(__file__))
    

##################### LOGOVANIE################
aplication_name = 'ibeacon'

# Create the root logger
logger = logging.getLogger()

cwd = os.path.dirname(os.path.realpath(__file__))
if not os.path.exists(os.path.join(cwd, 'logs')):
    os.makedirs(os.path.join(cwd, 'logs'))

# Create a formatter
formatter = logging.Formatter('%(asctime)s %(levelname)s \t %(message)s')

# Create a file handler for INFO level messages
info_handler = TimedRotatingFileHandler(os.path.join(
    cwd, 'logs', aplication_name), when='midnight', interval=1)
info_handler.suffix = '%Y-%m-%d.log'
info_handler.setLevel(logging.DEBUG)
info_handler.setFormatter(formatter)
logger.addHandler(info_handler)
# info_handler.doRollover()

# zapis do stdio
ch = logging.StreamHandler()
ch.setFormatter(formatter)
logger.addHandler(ch)

# logger.setLevel(logging.DEBUG)
logger.setLevel(logging.DEBUG)

logging.info(f'--- START Aplikacia sa spustila - {aplication_name}')


#############################################################################



#Set bluetooth device. Default 0.
dev_id = 0
try:
    sock = bluez.hci_open_dev(dev_id)
    print ("\n *** Looking for BLE Beacons ***\n")
    print ("\n *** CTRL-C to Cancel ***\n")
except:
    print ("Error accessing bluetooth")

ScanUtility.hci_enable_le_scan(sock)

DeviceUniqueID = ''
serverIPAddress = ipaddress.ip_address('0.0.0.0')
searchServerPort = 26573;

def GetUniqueID():
    # Extract serial from cpuinfo file
    cpuserial = "0000000000000000"
    try:
        f = open('/proc/cpuinfo', 'r')
        for line in f:
            if line[0:6] == 'Serial':
                cpuserial = line[10:26]
        f.close()
    except:
        cpuserial = "ERROR000000000"
    
    return cpuserial

def get_ip():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    try:
        # doesn't even have to be reachable
        s.connect(('10.255.255.255', 1))
        IP = s.getsockname()[0]
    except Exception:
        IP = '127.0.0.1'
    finally:
        s.close()

    retIp = ipaddress.ip_address(IP)
    return retIp

def Init():
    global DeviceUniqueID
    DeviceUniqueID = 'rpi-' + GetUniqueID()
    logger.info("DeviceUniqueID: " + DeviceUniqueID)

    global serverIPAddress
    localIPAddress = get_ip()
    logger.info("localIPAddress: " + str(localIPAddress))

    #----------------broadcast
    IP = str(localIPAddress)
    MASK = '255.255.255.0'

    host = ipaddress.IPv4Address(IP)
    net = ipaddress.IPv4Network(IP + '/' + MASK, False)
    broadcast_ip = ipaddress.ip_address(net.broadcast_address)
    logger.info("broadcast_ip: " + str(broadcast_ip))


    #----------------finding server
    str_message = "{\"token\":\"a34c5327-c9e8-461c-a72d-4e27750b8b0d\",\"uid\":\"" + DeviceUniqueID + "\"}"
    message = bytes(str_message,'UTF-8')
    print(message)
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

    address_br = (str(broadcast_ip), searchServerPort)

    while (serverIPAddress == ipaddress.ip_address('0.0.0.0')):
        try:
            server_socket.sendto(message, address_br)
            server_socket.settimeout(2.0)
            message, address = server_socket.recvfrom(8192)
            logger.info("Received... message: " + message.decode() + " ... Address: " + address[0] + " ... Port: " + str(address[1]))
            if (message.decode() == '7978aff6-04b4-4d5f-b873-55216a40bb7f'):
                serverIPAddress = ipaddress.ip_address(address[0])
        except Exception as ex:
            # print(ex)
            logger.warning("Server haven't found. Repeat in 5 second...")
        if serverIPAddress == ipaddress.ip_address('0.0.0.0'):
            serverIPAddress = ipaddress.ip_address('192.168.31.200')
            print(serverIPAddress)
            # sleep(5)
    server_socket.close()

    # NTPSetDateTime()
    
    
is_sending = False


def addFoundTags(json_text):
    """
    Pridá zadaný text na koniec textového súboru s názvom podľa aktuálneho dátumu.

    Args:
    text (str): Text na pridanie do súboru.
    """
    # Získanie aktuálneho dátumu
    aktualny_datum = datetime.datetime.now()

    # Formátovanie dátumu do požadovaného formátu reťazca
    nazov_suboru = os.path.join(cwd, 'logs', 'tags_' + aktualny_datum.strftime("%Y-%m-%d") + ".log")




    # Zpracování JSON textu
    try:
        data = json.loads(json_text)
        
        # print(json_text)
        # exit(1)
        
        # Kontrola, zda-li je 'data' typu list a obsahuje slovníky
        # if isinstance(data, list) and all(isinstance(item, dict) for item in data):
        # for zaznam in data:
        # Kontrola, zda je MAC adresa v seznamu povolených
        mac_adresa = data.get('tag_uid')
        
        if mac_adresa in povolene_mac_adresy:
            # Přidání záznamu do souboru
            try:
                with open(nazov_suboru, 'a') as subor:
                    subor.write(json_text + "\n")
                print(f"Záznam s MAC adresou {mac_adresa} byl přidán do souboru {nazov_suboru}.")
                return  # Prerušení cyklu po úspěšném přidání
            except Exception as e:
                print(f"Vyskytla se chyba při práci se souborem: {e}")
                return
        # else:
        #     print("Žádná MAC adresa ze seznamu nebyla nalezena.")
        # else:
        #     print("JSON text neobsahuje očekávaný seznam slovníků.")
            
    except json.JSONDecodeError as e:
        print(f"Nepodařilo se dekódovat JSON: {e}")



def NTPSetDateTime():
    try:
        client = ntplib.NTPClient()
        response = client.request(str(serverIPAddress))
        os.system('date ' + time.strftime('%m%d%H%M%Y.%S',time.localtime(response.tx_time)))
        logger.info('NTP time was set.')

    except:
        logger.warning('Could not sync with time server.')


def SendUdpBLE(_result_json):
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    server_socket.sendto(json.dumps(_result_json).encode('utf-8'), (str(serverIPAddress), searchServerPort))


def printit():
    global is_sending
    threading.Timer(5.0, printit).start()

    if  is_sending == False:
        is_sending = True
        logger.info('pocet na odoslanie:' + str(len(result_json)))
        i = 0

        local_result_json = []
        if len(result_json) != 0:
            logger.info(">>> Start sending...")
            for item in result_json:
                local_result_json.append(item)
                if i%7 == 0 and i != 0:
                    logger.info("result_json")
                    logger.info(local_result_json)
                    SendUdpBLE(local_result_json)
                    local_result_json.clear()
                    i = 0
                i = i + 1
            
            if len(local_result_json) != 0:
                logger.info("result_json_dodatocny")
                logger.info(local_result_json)
                SendUdpBLE(local_result_json)
                local_result_json.clear()


            logger.info("<<< End sending...")

        result_json.clear()

        is_sending = False


result_json = []

povolene_mac_adresy = {
        "7C:2F:80:C4:72:46", "7C:2F:80:C4:62:F0", "7C:2F:80:C4:5E:21", "7C:2F:80:C4:63:2F",
        "7C:2F:80:C4:63:6A", "7C:2F:80:C4:5E:04", "7C:2F:80:C4:5E:02", "7C:2F:80:C4:5E:4B",
        "7C:2F:80:C4:5E:A5", "7C:2F:80:C4:6D:5C", "7C:2F:80:C4:5E:2E", "7C:2F:80:C4:5E:22",
        "7C:2F:80:C4:63:2B", "7C:2F:80:C4:5D:E0", "7C:2F:80:C4:5D:FD", "7C:2F:80:C4:5D:F8",
        "7C:2F:80:C4:5D:BD", "7C:2F:80:C4:5E:3C", "7C:2F:80:C4:65:0D", "7C:2F:80:C4:5E:26",
        "7C:2F:80:C4:72:A8", "7C:2F:80:C4:62:E7", "7C:2F:80:C4:5E:51", "7C:2F:80:C4:62:5B",
        "7C:2F:80:C4:64:60", "7C:2F:80:C4:62:7C", "7C:2F:80:C4:5E:4D", "7C:2F:80:C4:63:70",
        "7C:2F:80:C4:72:89"
    }

povolene_mac_adresy = {mac.lower() for mac in povolene_mac_adresy}




Init()
printit()

#Scans for iBeacons
try:
    while True:
        # print("-------00")

        returnedList = ScanUtility.parse_events(sock, 10)
        # print("-------01")
        # iBeacons_list = [ 'e5:8c:8e:3c:ef:7c', '5c:f9:38:d2:38:83']
        # iBeacons_list = ['a4']
        for item in returnedList:
            # if any(x in item['macAddress'] for x in iBeacons_list):
                # print("vypisujem item -> %s" % item)
                now = datetime.datetime.now() # current date and time

                it = {"read_datetime": item['datetime'], "reader_uid": DeviceUniqueID, "tag_uid": item['macAddress'], "rssi":str(item['rssi']), 'local_name': '', 'UUIDs': ''}
                result_json.append(it)
                print(str(it).replace("'", '"'))
                addFoundTags(str(it).replace("'", '"'))

                # logger.info(it)
        
        sleep(0.1)
except KeyboardInterrupt:
    pass 