### WTF is BundleID ?
用來識別App的ID, 每個App都有一個獨一無二的BundleID，通常為reverse domain name 格式 (com.companyname.appname)
### WTF is AppID ?
當App需要啟用一些蘋果的服務時(通知、Apple登入..)時，需要先註冊，而以AppID為單位去註冊，AppID可以是Explicit App ID (只綁定一個App), 或是 Wildcard App ID是也可綁定多個App ()
### WTF is Code Signing?
私鑰擁有者：把Code的Hash值 (又稱為digest，摘要)，用私鑰加密產生數位簽名(signature)，再將(1)公鑰 (2)簽名 (3)Code 傳給驗證者
驗證者: 把收到的簽名用公鑰解密出Hash值，再把Code的Hash值，如果兩者一致，就能確認消息沒有被篡改。
拿私鑰加密摘要的動作，稱為Code Signing，摘要就是原始數據的Hash值
