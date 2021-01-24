## Siisii（しぃしぃ）とは
我が家の老猫(2021年1月時点で23歳6か月)の排泄物、餌の時間を記録するWebアプリです。  
（自分でトイレに入れなくなったり、１回の食事で少しづつしか食べられなくなったペットのお世話を想定しています。）

AWS lambda, API Gatewayをつかったサーバーレスアプリケーションとして作成しています。<br/>

- デモサイト<br/>https://siisii-demo.murakami-labo.com/

## 利用技術
- ruby (lambda関数用に使用)
- React, TypeScript (yarn buildした結果をS3に配置)
- AWS lambda, API Gateway, S3, CloudFront, Route53, DynamoDB
