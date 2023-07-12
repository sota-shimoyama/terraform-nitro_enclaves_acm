# How to use

### ■初期化
```shell
terraform init
```

### ■実行
```shell
terraform apply -var-file=./env/terraform.tfvars
```

変数の入力を求められます。  
```
var.key_pair_id　：　(Optional)使用するキーペアのID  
var.profile　：　(Optional)使用するプロファイル  
var.sg_ingress_cidr_block　：　(Required)SSH接続を許可するCIDR Block  
※　["0.0.0.0/0"]　のようにlist(string)で指定して下さい。
```

### ■削除
```shell
terraform destroy -var-file=./env/terraform.tfvars
```