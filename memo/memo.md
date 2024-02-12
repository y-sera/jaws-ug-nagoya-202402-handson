# ハンズオンメモ
解説元ネタ
- [GitOps を用いた Amazon EKS の自動化](https://aws.amazon.com/jp/blogs/news/automating-amazon-eks-with-gitops/)
- [Tekton と Argo CD を使用した AWS でのクラウドネイティブな CI/CD](https://aws.amazon.com/jp/blogs/news/cloud-native-ci-cd-with-tekton-and-argocd-on-aws/)

ハンズオン元ネタ
- [aws-pipeline-demo-with-tekton](https://github.com/aws-samples/aws-pipeline-demo-with-tekton)

## 考えること
- [ ] eksのインストール時の設定
- [ ] helmインストール
- [ ] codecommit等のリポジトリ構成作成方法(手動か/CFか)
- [ ] argocdインストール
- [ ] tektonインストール
- [ ] サンプルアプリの妥当性(元ネタのアプリは今も動くのか)
- [ ] アプリケーションのデプロイ
- [ ] cloud9構築方法(CF? クレデンシャル登録方法も含む)
- [ ] 後片付け手順

## 雑記
cloud9用VPC構築方法: CF用テンプレートがここにある[AWS CloudFormation VPC テンプレート](https://docs.aws.amazon.com/ja_jp/codebuild/latest/userguide/cloudformation-vpc-template.html)
変更するもの: 
- 1サブネットのみに絞る
- サブネットのパブリックIP追加設定
- cloud9追加
