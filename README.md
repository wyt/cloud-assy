#### 推送镜像

```shell script
[root@cluster-server001 ~]# docker login
[root@cluster-server001 ~]# docker tag io.mysnippet/cloud-assy:1.15.2 wangyongtao/cloud-assy:1.15.2
[root@cluster-server001 ~]# docker push wangyongtao/cloud-assy:1.15.2
```

#### 参考
[1]. [Docker下ELK三部曲之二：细说开发](https://blog.csdn.net/boling_cavalry/article/details/79972444)，Boling  Cavalry