#!/usr/bin/env python3

import re
import ftplib
from datetime import datetime

DD_WRT_HOST = 'ftp.dd-wrt.com'
START_PATH = '/betas/'
TARGET_DEVICE = 'netgear-r6400v2'
FILE_NAME = TARGET_DEVICE + '-webflash.bin'

try:
    # Login and enumerate /betas/
    ftp = ftplib.FTP(DD_WRT_HOST)
    ftp.login('anonymous', 'dd-wrt-downloader')
    ftp.cwd(START_PATH) 
    data = []
    ftp.dir(data.append)
    
    # Get latest year from /betas/
    data = [int(''.join(c for c in d.split()[-1] if c.isdigit())) for d in data]
    year = str(max(data))
    START_PATH += year + '/'
    
    # Get latest build from /betas/%Y/
    data = []
    ftp.cwd(START_PATH)
    ftp.dir(data.append)
    data = [d.split()[-1] for d in data]

    # Get latest build number
    dates = [datetime.strptime(re.sub('-r\d+', '', d), "%m-%d-%Y") for d in data]
    date_lookup = dict(zip(dates, data))
    newest = date_lookup[max(date_lookup.keys())]
   
    # Navigate to target device folder and pull down binary
    data = []
    START_PATH += newest + '/' + TARGET_DEVICE + '/'
    ftp.cwd(START_PATH)
    ftp.retrbinary('RETR ' + FILE_NAME, open(FILE_NAME, 'wb').write)
    ftp.quit()
except:
    print('Unable to retrieve latest binary from FTP.')
    ftp.quit()
    exit(-1)

