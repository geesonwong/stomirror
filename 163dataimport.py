# encoding: utf-8
import shutil

__author__ = 'airsen'
import os
import csv
import re
import sys

import pymysql
import httplib2


isremovecsv = False  # 是否删掉CSV文件
reporttype = {'利润表': {'url': 'http://quotes.money.163.com/service/lrb_%s.html'},
              '主要财务指标': {'url': 'http://quotes.money.163.com/service/zycwzb_%s.html'},
              '资产负债表': {'url': 'http://quotes.money.163.com/service/zcfzb_%s.html'},
              '财务报表摘要': {'url': 'http://quotes.money.163.com/service/cwbbzy_%s.html'},
              '盈利能力': {'url': 'http://quotes.money.163.com/service/zycwzb_%s.html?part=ylnl'},
              '偿还能力': {'url': 'http://quotes.money.163.com/service/zycwzb_%s.html?part=chnl'},
              '成长能力': {'url': 'http://quotes.money.163.com/service/zycwzb_%s.html?part=cznl'},
              '营运能力': {'url': 'http://quotes.money.163.com/service/zycwzb_%s.html?part=yynl'},
              '现金流量表': {'url': 'http://quotes.money.163.com/service/xjllb_%s.html'}}

itemtype = {}  # 类目
reportlist = []
conn = pymysql.connect(host='127.0.0.1', unix_socket='/tmp/mysql.sock', user='root', passwd='',
                       db='investment',
                       charset='utf8')  # 数据库连接
cur = conn.cursor()
h = httplib2.Http('.cache')
executesql = 'INSERT INTO t_163_data VALUES '


def download(symbol, reportname):
    # 下载文件
    resp, content = h.request(reporttype[reportname]['url'] % symbol)
    filename = 'csv/' + symbol + '/' + reportname + '.csv'
    profitfile = open(filename, 'wb+')
    profitfile.write(content)
    profitfile.close()

    # 类目载入
    cur.execute('SELECT * FROM t_163_item WHERE `GROUP` = \'' + reportname + '\'')
    for row in cur:
        itemtype[row[2]] = row[0]

    # 读取 csv
    csvreader = csv.reader(open(filename, 'r', encoding='gbk'))
    for row in csvreader:
        for index, value in enumerate(row):
            if value.strip() == '':
                continue
            if row[0].strip() == '报告日期' or row[0].strip() == '报告期':
                if index != 0:
                    profit = {'date': value}  # 创建并加入到列表中
                    reportlist.append(profit)
            else:
                if index != 0 and index <= len(reportlist):
                    try:
                        value = float(value)
                    except ValueError:
                        value = 0
                    reportlist[index - 1][str(itemtype[row[0].strip()])] = str(value)

    # 存库
    for report in reportlist:
        for item in report:
            if item != 'date':
                global executesql
                executesql += '(\'' + symbol + '\',\'' + report['date'] + '\',\'' + item + '\',\'' + report[
                    item] + '\'),'

    print(symbol + '导入' + reportname + '数据:' + str(len(reportlist)))

    itemtype.clear()
    reportlist.clear()
    pass


def main():
    joozy = input('下载网易股票财报，股票代码:')
    pattern = re.compile(r'(\d{6})')
    match = pattern.findall(joozy)

    if len(match) == 0:
        pass
    else:
        for symbol in match:
            print('# --------------------------------------------')
            cur.execute('DELETE FROM t_163_data WHERE SYMBOL = \'' + symbol + '\'')
            if not os.path.exists('csv/' + symbol):
                os.makedirs('csv/' + symbol)

            for i in reporttype:
                download(symbol, i)

        if isremovecsv:
            shutil.rmtree('csv/' + symbol)
        cur.execute(executesql[:-1])
        conn.commit()
        cur.close()
        conn.close()
    pass


if __name__ == '__main__':
    sys.exit(main())