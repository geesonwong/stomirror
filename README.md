### 这是啥玩意
--------
啊，当前有2个工具在里面：

1. K线数据全量导入；
1. 历年财报数据全量导入。

K线是给趋势投资的人做参考的，财报数据是给价值投资的人做参考的。

### 长什么样子
-------
给几张图看看。

#### 财报

运行下载财报的代码是这样子的：

![运行下载财报的代码](http://ww2.sinaimg.cn/mw690/60dc9a70gw1eeinik4rosj209a0d43zw.jpg)

之后经过处理可以是这样子的：

![经过处理的财报数据样式](http://ww4.sinaimg.cn/mw690/60dc9a70gw1eeinilm8u2j20ez04q0tq.jpg)

#### K线

运行K线导入的代码是这样子的：

![运行K线导入的代码](http://ww3.sinaimg.cn/mw690/60dc9a70gw1eeiniku8h0j205t00zt8j.jpg)

导入以后数据是这样子的：

![K线的数据格式](http://ww4.sinaimg.cn/mw690/60dc9a70gw1eeinil1aatj20ma09441q.jpg)

### 怎么用
------

1. 数据库初始化

    找到 sql/table_ddl.sql 文件，运行里面的语句，可以创建

    f* 数据库 `invsertment`；
    f* 数据表 `t_163_data`，`t_163_item`，`t_k_line`，`t_stock`。

    然后找到 sql/procedure.sql 文件，运行语句可以创建

    f* 存储过程 `REPORT`；
    f* 存储过程 `TOOGLE_STOCK`。

    最后找到 sql/data_dml.sql 文件，运行语句初始化类目表数据。

1. 下载数据

    运行环境是 Python 3，有几个包得安装下

    ```shell
    pip install PyMySQL httplib2
    ```

    然后可以运行了

    ```shell
    python 163dataimport.py
    python klineimport.py
    ```

1. 运行查看财务报表对比

    存储过程`REPORT`有查看财务报表的功能，并且可以自己设置查看的股票代码和项目。

    ```sql
    CALL REPORT('2013-09-30');
    ```

    得到类似如下的结果

    ![经过处理的财报数据样式](http://ww4.sinaimg.cn/mw690/60dc9a70gw1eeinilm8u2j20ez04q0tq.jpg)

    出现在报表的股票是 `t_stock` 中 `optional ＝ 1` 的记录，出现在列头的类目是 `t_163_item` 中 `show_code = 1` 的记录，可以自己修改设置。
