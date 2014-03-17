# encoding: utf-8
import re

__author__ = 'airsen'

import json
import sys
import datetime

import httplib2
import pymysql


def main():
    symbol = input('下载K线数据，股票代码:')
    pattern = re.compile(r'\d{6}')
    match = pattern.search(symbol)
    simplesymbol = match.group()

    accesstoken = 'access_token=Pm0HVhQUxPHTd0osDjwJ4Y&_=1393950527823'
    h = httplib2.Http('.cache')
    resp, content = h.request(
        'http://xueqiu.com/stock/forchartk/stocklist.json?period=1day&type=before&' + accesstoken + '&symbol=' + symbol)

    klinejson = json.loads(str(content, 'utf-8'))

    chartlist = klinejson['chartlist']
    print('总长度为:' + str(len(chartlist)))

    conn = pymysql.connect(host='127.0.0.1', unix_socket='/tmp/mysql.sock', user='root', passwd='', db='investment',
                           charset='utf8')
    cur = conn.cursor()
    cur.execute('DELETE FROM T_K_LINE WHERE SYMBOL = \'' + simplesymbol + '\'')  # 删除

    insertsql = 'INSERT INTO T_K_LINE VALUES '
    insertvalues = ''

    for chart in chartlist:
        insertvalues += '(\'' + simplesymbol + '\',\'' + str(
            datetime.datetime.strptime(chart['time'], '%a %b %d %H:%M:%S +0800 %Y')) + '\',' + str(
            chart['open']) + ',' + str(
            chart['close']) + ',' + str(chart['high']) + ',' + str(chart['low']) + ',' + str(chart['chg']) + ',' + str(
            chart['percent']) + ',' + str(chart['turnrate']) + ',' + str(chart['ma5']) + ',' + str(
            chart['ma10']) + ',' + str(chart['ma20']) + ',' + str(chart['ma30']) + '),'
    cur.execute(insertsql + insertvalues[:-1])
    conn.commit()
    cur.close()
    conn.close()


if __name__ == '__main__':
    sys.exit(main())