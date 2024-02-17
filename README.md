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


## 1. Cloud9構築
＜概要図＞
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
＜概要図＞
TODO:
- EC2にAdministoratorロール付与
- 諸々必要なツールインストール
- 各種ツールの解説(1行程度)

## 3. EKSクラスター構築
＜概要図＞
TODO:
- EKSクラスター構築

## 4. CodeCommitリポジトリ構築


## 5. tektonパイプライン構築

## 6. ArgoCD構築

## 7. リポジトリ更新/稼働確認

## 8. 後片付け
TODO: 
- EKSクラスター削除
- CodeCommitリポジトリ削除
- cloud9削除

