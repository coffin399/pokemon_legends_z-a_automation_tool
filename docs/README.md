# Pokemon Legends Z-A Automation Tool - Documentation

このディレクトリには、Pokemon Legends Z-A Automation ToolのGitHub Pages用ドキュメントサイトが含まれています。

## 📁 ディレクトリ構造

```
docs/
├── index.html              # メインのドキュメントページ
├── assets/
│   ├── css/
│   │   └── style.css       # スタイルシート
│   ├── js/
│   │   └── script.js       # JavaScript
│   └── images/
│       ├── logo.png        # ロゴ画像
│       └── favicon.ico     # ファビコン
└── README.md               # このファイル
```

## 🚀 GitHub Pages デプロイ方法

### 1. リポジトリの設定

1. GitHubリポジトリの「Settings」タブに移動
2. 左サイドバーの「Pages」をクリック
3. 「Source」で「Deploy from a branch」を選択
4. 「Branch」で「main」を選択
5. 「Folder」で「/docs」を選択
6. 「Save」をクリック

### 2. 自動デプロイ

GitHub Pagesは自動的に`docs/`ディレクトリの内容をデプロイします。変更をプッシュすると、数分後にサイトが更新されます。

### 3. カスタムドメイン（オプション）

カスタムドメインを使用する場合：

1. `docs/`ディレクトリに`CNAME`ファイルを作成
2. ドメイン名を記述（例：`your-domain.com`）
3. DNS設定でドメインをGitHub Pagesに設定

## 📝 ドキュメントの更新

### 新しいページの追加

1. `docs/`ディレクトリに新しいHTMLファイルを作成
2. `index.html`のナビゲーションにリンクを追加
3. 必要に応じてCSSとJavaScriptを更新

### スタイルの変更

- `assets/css/style.css`を編集
- CSS変数を使用してテーマをカスタマイズ可能

### 機能の追加

- `assets/js/script.js`にJavaScript機能を追加
- モジュール化された関数を使用

## 🎨 カスタマイズ

### カラーテーマの変更

`assets/css/style.css`の`:root`セクションでCSS変数を変更：

```css
:root {
    --primary-color: #3b82f6;    /* プライマリカラー */
    --secondary-color: #8b5cf6;   /* セカンダリカラー */
    --accent-color: #f59e0b;      /* アクセントカラー */
}
```

### フォントの変更

```css
:root {
    --font-family: 'Your Font', sans-serif;
}
```

## 📱 レスポンシブデザイン

サイトは以下のブレークポイントでレスポンシブ対応：

- **デスクトップ**: 1200px以上
- **タブレット**: 768px - 1199px
- **モバイル**: 767px以下

## 🔧 開発

### ローカル開発

1. ローカルサーバーを起動：
   ```bash
   # Python 3
   python -m http.server 8000 --directory docs
   
   # Node.js (http-server)
   npx http-server docs -p 8000
   
   # PHP
   php -S localhost:8000 -t docs
   ```

2. ブラウザで `http://localhost:8000` にアクセス

### ビルドツール（オプション）

必要に応じて、以下のツールを使用できます：

- **Sass/SCSS**: CSSプリプロセッサ
- **PostCSS**: CSS後処理
- **Webpack**: モジュールバンドラー
- **Gulp**: タスクランナー

## 📊 パフォーマンス

### 最適化のポイント

1. **画像最適化**: WebP形式の使用を検討
2. **CSS最適化**: 未使用スタイルの削除
3. **JavaScript最適化**: コード分割と遅延読み込み
4. **キャッシュ**: 適切なキャッシュヘッダーの設定

### 監視

- **Lighthouse**: パフォーマンス監視
- **PageSpeed Insights**: Googleのパフォーマンス分析
- **WebPageTest**: 詳細なパフォーマンス分析

## 🛠️ トラブルシューティング

### よくある問題

1. **スタイルが適用されない**
   - ファイルパスを確認
   - ブラウザのキャッシュをクリア

2. **JavaScriptが動作しない**
   - コンソールでエラーを確認
   - ファイルの読み込み順序を確認

3. **GitHub Pagesで表示されない**
   - ファイル名の大文字小文字を確認
   - パスが正しいか確認

### デバッグ

```javascript
// コンソールでデバッグ情報を表示
console.log('Document loaded:', document.readyState);
console.log('Current page:', window.location.pathname);
```

## 📚 参考資料

- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [MDN Web Docs](https://developer.mozilla.org/)
- [CSS Grid Guide](https://css-tricks.com/snippets/css/complete-guide-grid/)
- [Flexbox Guide](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)

## 📄 ライセンス

このドキュメントサイトは、メインプロジェクトと同じMITライセンスの下で提供されています。

---

**作成者**: coffin299と愉快な仲間たち  
**最終更新**: 2025年1月
