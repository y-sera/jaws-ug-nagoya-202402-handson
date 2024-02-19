# jaws-ug-nagoya-202402-handson
Jaws UG名古屋 EKS勉強会(2024/2/27)のハンズオン資料です.  
このハンズオンでは、EKSでのGitOpsのパイプラインを構築します.  
こちらのページが元ネタです.  
https://aws.amazon.com/jp/blogs/news/cloud-native-ci-cd-with-tekton-and-argocd-on-aws/

## 構成概要
＜概要図＞

## 手順概要
以下のステップで行います.
1. cloud9構築
2. cloud9環境設定
3. EKSクラスター構築
4. codeCommitリポジトリ構築
5. tektonパイプライン構築
6. ArgoCD構築
7. リポジトリ更新/稼働確認
8. 後片付け



## 0. (準備)IAMユーザの作成
1. IAM画面から, IAMユーザを作成する.  
  ユーザー名: `eks-handson-user`
  付与するポリシー: `AdministoratorAccess`

2. アクセスキーを作成する.

3. 一旦ログアウトし, 作成したIAMユーザでログインし直す.

### 1. Cloud9構築
＜概要図＞
CloudShellにて, EKS環境構築用のcloud9を構築する.  
(環境構築にdocker buildを使用するため.)

1. cloud shellを開く
2. ハンズオン用のリポジトリをクローンする.
```
git clone https://github.com/y-sera/jaws-ug-nagoya-202402-handson.git
```
3. ディレクトリを移動する.
```
cd jaws-ug-nagoya-202402-handson/1_create_cloud9/
```
4. スクリプトを実行し, cloudformation経由でcloud9(と, そのために必要なVPC等)を構築する.
```
./createCloud9.sh
```

## 2. Cloud9環境設定
＜概要図＞
TODO:
- 諸々必要なツールインストール
### 2.1 ATMC設定
1. Cloud9の画面を開く.
2. `eks-handson`環境を選択し, cloud9で開く, をクリック.
3. cloud9の画面にて, 画面左上 '雲マーク'-> 'Prefences'をクリックする.
4. 画面左側の'AWS Settings'をクリックし, 画面下部'Credentials'の項目の'AWS managed temporary credentials'のチェックをオフ(赤色)にする.

### 2.2 AWS CLIの設定
1. ターミナルにてaws configureコマンドを実行し, アクセスキー, リージョン情報を登録する.
```
AWS Access Key ID [None]: <アクセスキー(ctrl+vで貼り付け)>
AWS Secret Access Key [None]: <シークレットアクセスキー(ctrl+vで貼り付け)>
Default region name [None]: ap-northeast-1
Default output format [None]: <何も指定せずenter> 
```

2. 動作確認で, 以下のコマンドを実行する
```
aws sts get-caller-identity
```

以下のような結果が返ってくればOK.
```
{
    "UserId": "XXXXXXXXXXXXXXXXXX",
    "Account": "11111111111",
    "Arn": "arn:aws:iam::11111111:user/eks-handson-user"
}
```

### 2.3 必要コマンド類インストール
以下のコンポーネントをスクリプトによってインストールする.
- bash-completion: bashの補完機能を追加.
- docker: デモ用コンテナのビルドに使用.
- aws-iam-authenticator: 
- eksctl: EKSクラスター構築用のツール
- kubectl: kubernetesを操作するCLIツール
- helm: マニフェスト管理ツール


1. スクリプトをダウンロードする.
```
cd ~/environment/ && git clone https://github.com/y-sera/jaws-ug-nagoya-202402-handson
```

2. スクリプト実行
```
cd jaws-ug-nagoya-202402-handon/2_setup_cloud9/
./setup_cloud9.sh
```
3. パスの設定の読み込み
```
source ~/.bashrc
```

## 3. EKSクラスター構築
＜概要図＞
eksctlコマンドにて, eksクラスターを構築する.(15分ほど待つ.)
```
eksctl create cluster --name handson-cluster
```


## 4. CodeCommitリポジトリ構築


## 5. tektonパイプライン構築

## 6. ArgoCD構築

## 7. リポジトリ更新/稼働確認

## 8. 後片付け
TODO: 
- EKSクラスター削除
- CodeCommitリポジトリ削除
- cloud9削除

