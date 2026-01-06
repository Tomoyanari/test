import streamlit as st
import google.generativeai as genai
from PIL import Image

# ページ設定
st.set_page_config(page_title="AI採点アプリ", page_icon="📝")

# --- サイドバー：設定エリア ---
st.sidebar.title("⚙️ 設定")
api_key = st.sidebar.text_input("Google API Keyを入力", type="password")

st.sidebar.markdown("""
**使い方:**
1. [Google AI Studio](https://aistudio.google.com/)でキーを取得
2. ここにキーを貼り付け
3. 解答画像をアップロード
""")

# --- メインエリア：採点機能 ---
st.title("📝 AI 自動採点システム")
st.markdown("手書きの解答用紙（画像）をアップロードすると、AIが採点・添削を行います。")

# APIキーがあるかチェック
if not api_key:
    st.warning("👈 左のサイドバーにAPIキーを入力してください")
    st.stop() # キーがないとここでストップ

# AIのセットアップ
genai.configure(api_key=api_key)
model = genai.GenerativeModel('gemini-1.5-flash')

# 問題と正解の定義（今回はデモ用に固定。本来はここも入力できるようにします）
col1, col2 = st.columns(2)
with col1:
    question_text = st.text_area("問題文", value="二次方程式 x^2 - 4x + 3 = 0 を解け")
with col2:
    correct_text = st.text_area("模範解答", value="(x-1)(x-3)=0 より、x=1, 3")

# ファイルアップロード
uploaded_file = st.file_uploader("解答画像をアップロード", type=["jpg", "png", "jpeg"])

if uploaded_file is not None:
    # 画像を表示
    image = Image.open(uploaded_file)
    st.image(image, caption="生徒の解答", use_container_width=True)

    # 採点ボタン
    if st.button("採点開始 🚀"):
        with st.spinner("AIが思考中...（文字を認識し、論理を検証しています）"):
            try:
                # AIへの命令（プロンプト）
                prompt = f"""
                あなたはプロの数学講師です。以下の画像を生徒の解答として採点してください。
                
                【問題】{question_text}
                【模範解答】{correct_text}
                
                以下のフォーマットで出力してください：
                ## 採点結果: [点数]/10点
                ### 判定理由
                (ここに理由)
                ### アドバイス
                (ここにアドバイス)
                """
                
                # 画像とテキストを渡して実行
                response = model.generate_content([prompt, image])
                
                # 結果表示
                st.success("採点完了！")
                st.markdown(response.text)
                
            except Exception as e:
                st.error(f"エラーが発生しました: {e}")
