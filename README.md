# jaws-ug-nagoya-202402-handson
Jaws UG名古屋 EKS勉強会(2024/2/27)のハンズオン資料です.  
このハンズオンでは、EKSでのGitOpsのパイプラインを構築します.  
こちらのページが元ネタです.  
https://aws.amazon.com/jp/blogs/news/cloud-native-ci-cd-with-tekton-and-argocd-on-aws/

## 構成概要
＜概要図＞

## 手順概要
以下のステップで行います.
0. (準備)IAMユーザの作成
1. cloud9構築
2. cloud9環境設定
3. EKSクラスター構築
4. GitOps環境構築
5. デモ用アプリの更新 
6. リポジトリ更新/稼働確認
7. 後片付け

> [!IMPORTANT]
> 今回のハンズオンは, 以下2つを前提に構成しています. 
> これらを満たしていないとスクリプト等が上手く機能しないため注意してください.
> - 東京リージョンに構築すること
> - IAMユーザ: eks-handson-userを利用すること

## 0. (準備)IAMユーザとアクセスキーの作成
### 0.1 IAMユーザの作成
1. IAM画面へ移動し, 画面左側のユーザータブを開く.
2. 画面右側のユーザーの作成ボタンをクリック.
3. ユーザー名を入力して次へ   
  ユーザー名: `eks-handson-user`  
  "AWSマネジメントコンソールへのユーザアクセスを提供する" オプションはチェックを外す.
4. 'ポリシーを直接アタッチする'を選択し, 以下のポリシーを付与して次へをクリック.  
  付与するポリシー: `AdministoratorAccess`
5. 確認画面で内容を確認し, ユーザーの作成をクリック.

### 0.2 アクセスキーの作成
1. IAM > ユーザー > eks-handson-userをクリック.
2. セキュリティ認証情報のタブ > アクセスキー > アクセスキーを作成 をクリック.
3. "主要なベストプラクティスと代替案にアクセスする" にて, "コマンドラインインターフェイス(CLI)", "上記のレコメンデーションを理解し, アクセスキーを作成する"をチェックして次へ
4. 説明タグは任意の文字を入力し(空でも良い), アクセスキーを作成をクリック
5. アクセスキー, シークレットアクセスキーをメモしておく.



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
4. スクリプトを実行し, cloudformation経由でcloud9及びVPC等を構築する.
```
./createCloud9.sh
```

## 2. Cloud9環境設定
＜概要図＞
### 2.1 Cloud9設定(AWS Managed Temporary Credentials設定)
1. Cloud9の画面を開く.
2. `eks-handson`環境を選択し, cloud9で開く, をクリック.
3. cloud9の画面にて, 画面左上 '雲マーク'-> 'Prefences'をクリックする.
4. 画面左側の'AWS Settings'をクリックし, 画面下部'Credentials'の項目の'AWS Managed Temporary Credentials'のチェックをオフ(赤色)にする.

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


1. 今回のハンズオン用のリポジトリをダウンロードする.
```
cd ~/environment/ && git clone https://github.com/y-sera/aws-pipeline-demo-with-tekton.git
```

2. スクリプト実行
```
cd ~/environment/aws-pipeline-demo-with-tekton/
./setup_cloud9.sh
```
3. パス, エイリアス設定の読み込み
```
source ~/.bashrc
```

## 3. EKSクラスター構築
＜概要図＞
eksctlコマンドにて, eksクラスターを構築する.(15分ほど待つ.)
```
cd ~/environment/aws-pipeline-demo-with-tekton/
eksctl create cluster --config-file eks-cluster-template.yaml
```
今回はあらかじめyamlファイルに設定を記載しておいたが, コマンドの引数として渡すこともできる.
(今回のハンズオンでは, 後の構築段階でクラスター名が異なると上手くいかない箇所があるため, 
名前が一意に定まるように設定ファイルを利用)


## 4. GitOps環境構築
スクリプトにて, GitOps環境を構築する.
```
cd ~/environment/aws-pipeline-demo-with-tekton/
./install.sh
```
構築するものは以下
- OIDCプロバイダー
- IAMサービスアカウント(EBSコントローラー用)
- IAMサービスアカウント(ロードバランサーコントローラ用)
- EBSコントローラー
- ロードバランサーコントローラー
- CodeCommitリポジトリ(デモ用アプリソース管理)
- CodeCommitリポジトリ(デモ用アプリマニフェスト管理)
- CodeCommit(ソース管理)トリガ用lambda
- 各種保存用S3
- その他IAMサービスアカウント
- Tekton pipeline
- Tekton Trigger
- Tekton Dashboard
- ArgoCD
- ChartMuseum
- デモ用アプリ

実行完了時の以下の出力結果を保存しておく.
```
[INFO] $(date +"%T") Display output values...
[INFO] DEMO APP => http://XXXXXXX
[INFO] TEKTON DASHBOARD => http://YYYYYYYYY"
[INFO] ARGOCD => http://ZZZZZZZZZZZ"
[INFO] SOURCE REPO => https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/tekton-demo-app-build"
[INFO] GIT USERNAME => eks-handson-userxxxxxx"
[INFO] GIT PASWORD => xxxxxxxxxxxx"
[INFO] ARGOCD USERNAME => admin"
[INFO] ARGOCD PASSWORD => XXXXXXXXXXXXX"
```

## 5. デモアプリ更新
※以下手順5~6は, 以下リンクとほぼ同じ内容です.(git cloneコマンドのみ差異あり)
[Tekton と Argo CD を使用した AWS でのクラウドネイティブな CI/CD](https://aws.amazon.com/jp/blogs/news/cloud-native-ci-cd-with-tekton-and-argocd-on-aws/)

### 5.1 現在のデモアプリの状態を確認する
手順4の最後の結果: `DEMO APP =>`の行に記載されたURLにブラウザからアクセスする.
Tektonのアイコンと, `Tekton Demo@AWS`の文字が__黒__で表示されています.

### 5.2 アプリケーションに簡単な変更を加える
1. 以下コマンドにて, アプリケーション用リポジトリをcloud9へクローンする.
```
cd ~/environment
git clone codecommit://tekton-demo-app-build
cd tekton-demo-app-build
```

2. リポジトリのクローンに成功したら, `src/main/resources/templates`にあるgreeting.htmlを開き, 13行目のh1タグをコメントアウトします.  
次に, インラインCSSグラデーションを使用するh1タグを追加します(14行目以降のコメントアウトを外す).  
変更内容を保存する.

## 6. リポジトリ更新/稼働確認
### 6.1 tekton dashboardを開く
CodeCommitリポジトリを更新する前に, パイプラインのダッシュボードを開いておく.
手順4の最後の出力の, `[INFO] TEKTON DASHBOARD => http://YYYYYYYYY`に記載されたリンクにアクセスする.

### 6.2 リポジトリの更新
webアプリの更新内容をCodeCommitへpushする.
```
git commit -am "Change text color to match color of Tekton logo"
git push
```

### 6.3 パイプラインで現在の状況を確認する
6.1で開いたtekton dashbaoradの`TaskRuns`タブを開き, パイプラインの実行状況を確認する.  
しばらくすると, ビルドが完了し, 緑色のインジケーターが表示される.

### 6.4 AWS CodeArtifactでJARアーティファクトの新バージョンを確認する.
AWS CodeArtifactを開く. tekton-demo-repositoryリポジトリ内のcom.amazon:tekton-demoパッケージを選択する. 最近のGitコミットハッシュを持つパッケージの新しいバージョンが表示されている子とが確認できる.
Gitコミットのハッシュは, 以下コマンドにて確認できる.
```
git show --format=%H --no-patch
```


### 6.5 ECRで新しいコンテナイメージのバージョンを確認する.
Amazon ECR> プライベートリポジトリ> tekton-demo-appを開く.
Gitコミットハッシュを識別子として含む新しいイメージタグが表示されていることを確認する.

### 6.6 アプリケーションpodの更新を確認する.
以下コマンドを実行する.
```
kubectl get pod -n apps --watch
```
しばらく待つと, ArgoCDがリポジトリの変化を検知し, podが再作成される様子が確認できる.

### 6.7 デモ用アプリケーションの状態を確認する
手順5.1で開いたデモ用アプリを更新し, 文字の色が黒からTektonのロゴの色に変化していることを確認する.


## 7. 後片付け
### 7.1 GitOps環境削除
まず, GitOpsに使用した, EKSの周りにある各種リソースを削除する.  
今回のリソースはほぼ全てCloudFormationにて作成されているため,  
消されているか不安な場合はスタックを確認すると良い.
  
以下スクリプトを実行する.
```
cd ~/environment/aws-pipeline-demo-with-tekton/
./uninstall.sh
```
> [!NOTE]
> 削除するもの
> - ALB３つ, NLB1つ(Kubernetes上ではService(type: LoadBalancer) or Ingressリソース)
> - セキュリティグループ
> - ECR
> - CloudFormationスタック(TektonDemoInfra)
> - CloudFormationスタック(TektonDemoBuckets)
> - CodeCommit用認証情報
> - CloudWatch ロググループ(/aws/lambda/TektonPipelineDemoWebhook)
>  
> これらが消せない場合は以下を試してください
> - コケたところまでのコマンド(export文を除く)をコメントアウト.
> - TektonDemoInfraスタックが消せない場合: スタック上で削除中になっているセキュリティグループに関連したリソースを手動削除してからスタック削除を実行. 
> - TektonDemoBucketsスタックが消せない場合: tektondemobuckets で始まる２つのバケットを空にしてからスタック削除を実行.

### 7.2 EKSクラスター削除
eksctlコマンドにてEKSクラスターの削除を実施する
```
cd ~/environment/aws-pipeline-demo-with-tekton/
eksctl delete cluster --name eks-handson-cluster
```

### 8.3 Cloud9削除
eksクラスターの削除が完了した後に実施する.  
cloud shellを開き, 以下コマンドを実施する.
```
aws cloudformation delete-stack --stack-name eks-handson-cloud9
```

### 8.4 IAMユーザー削除
1. IAM > ユーザー > eks-handson-userをチェックし, 画面右上の削除ボタンよりIAMユーザを削除する.
  
以上でハンズオンは完了です. お疲れ様でした.
