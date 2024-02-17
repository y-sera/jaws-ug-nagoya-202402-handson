# jaws-ug-nagoya-202402-handson
Jaws UG名古屋 EKS勉強会(2024/2/27)のハンズオン資料です。
このハンズオンでは、EKSでのGitOpsのパイプラインを構築します。
こちらのページが元ネタです。
https://aws.amazon.com/jp/blogs/news/cloud-native-ci-cd-with-tekton-and-argocd-on-aws/

## 手順概要
以下のステップで行います。
1. cloud9構築
2. cloud9環境設定
3. EKSクラスター構築
3. codeCommitのリポジトリ構築
4. tektonパイプライン構築
5. ArgoCD構築
6. リポジトリ更新
7. 後片付け

## 1. Cloud9構築
cloud shellにて, EKS環境構築用のcloud9を構築する.
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

## 3. 
