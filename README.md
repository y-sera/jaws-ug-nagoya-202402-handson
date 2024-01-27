# jaws-ug-nagoya-202402-handson
Jaws UG名古屋 EKS勉強会(2024/2/27)のハンズオン資料です。
このハンズオンでは、EKSでのGitOpsのパイプラインを構築します。
こちらのページが元ネタです。
https://aws.amazon.com/jp/blogs/news/cloud-native-ci-cd-with-tekton-and-argocd-on-aws/

## 手順概要
以下のステップで行います。
1. cloud shellにて、環境構築用のcloud9を構築
2. cloud9からeksクラスターを構築
3. codeCommitのリポジトリ構築
4. tektonパイプライン構築
5. ArgoCD構築
6. リポジトリ更新
7. あと片付け
